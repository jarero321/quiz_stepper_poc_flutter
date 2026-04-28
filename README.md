# quiz_stepper_poc

POC de un quiz lineal: 6 preguntas con opciones, cada respuesta acumula puntos en cuatro perfiles, y al final se revela el perfil ganador con un breakdown porcentual.

Tema: "¿Qué tipo de viajero eres?" — perfiles `mochilero`, `resort`, `cultural`, `gastronomico`. La lógica de scoring es genérica; el contenido (preguntas, opciones, perfiles) está completamente decoupled del flujo.

100% en memoria. Sin DB, sin red, sin auth.

## Stack

| Capa | Decisión |
|---|---|
| SDK | Dart `^3.11.1`, Flutter Material 3 |
| Estado | `ChangeNotifier` por pantalla + `QuizManager` singleton para acumular respuestas |
| Navegación | `Navigator` con `AppNavigator` propio + transiciones custom (fade + slide) |
| Iconografía | `phosphor_flutter` v2 (duotone) |
| Tipografía | Fraunces (display) + Inter (body), variables, en `assets/fonts/` |

Sin persistencia. Sin gestor de estado externo. Sin DI container. Sin generación de código.

## Cómo correrlo

```bash
flutter pub get
flutter run
```

No requiere permisos. Funciona offline.

## Arquitectura

Dos carpetas en `lib/`:

- `app/quiz/` — el feature único, dividido por **paso del flujo** (intro, stepper, result, error).
- `framework/` — theme, navegación, telemetría y widgets reutilizables.

```
lib/
├── main.dart                        # MaterialApp con navigatorKey global
├── app/quiz/
│   ├── intro/                       # pantalla de bienvenida
│   │   ├── view.dart
│   │   └── model.dart               # IntroViewModel
│   ├── stepper/                     # las 6 preguntas
│   │   ├── view.dart
│   │   └── model.dart               # StepperViewModel + QuizStep + QuizOption + steps[]
│   ├── result/                      # perfil revelado
│   │   ├── view.dart
│   │   └── model.dart               # ResultViewModel + TravelerProfile + _profiles{}
│   ├── error/view.dart              # fallback
│   └── manager/
│       └── quiz_manager.dart        # singleton: respuestas + scores acumulados
└── framework/
    ├── theme/app_theme.dart         # colores, tipografía, durations
    ├── utils/
    │   ├── app_navigator.dart       # push, replaceAll, navigateAndWait con transiciones
    │   └── telemetry.dart           # tracking de views y errores
    └── widgets/base/                # AppButton, AppAppBar, AppAlert, AppLoading
```

### El patrón: QuizManager + ViewModel por paso

Tres piezas:

1. **`QuizManager`** (`app/quiz/manager/quiz_manager.dart`) — singleton. Mantiene el estado *transversal al flujo*: `answers` (map de `stepKey → optionValue`) y `profileScores` (map de `profileKey → puntos`). Expone `recordAnswer(...)`, `reset()` y el getter `winningProfile`. **No** notifica cambios; solo almacena.

2. **ViewModel por pantalla** (`app/quiz/<step>/model.dart`) — extiende `ChangeNotifier`. Lee y escribe `QuizManager`, mantiene estado puramente de pantalla (índice actual, opción seleccionada, banderas de animación) y dispara `notifyListeners()`. Cada VM también define los **modelos de contenido** que consume (`QuizStep`, `QuizOption`, `TravelerProfile`).

3. **View** (`app/quiz/<step>/view.dart`) — `StatefulWidget` que crea su `late final XViewModel _viewModel` en `initState`, llama hooks de inicio (`init()`, `reveal()`), y envuelve la UI en `ListenableBuilder(listenable: _viewModel, ...)`.

Flujo del quiz:

```
IntroView           → QuizManager.reset(), animación de entrada
  ↓ AppNavigator.navigateAndReplaceAll(StepperView)
StepperView         → 6 pasos con AnimatedSwitcher entre cada pregunta
  · selectOption()  → guarda en VM (no en manager todavía)
  · continueNext()  → QuizManager.recordAnswer() + avanza índice
  · goBack()        → resta el scoreDelta del paso anterior y retrocede
  ↓ al terminar el último paso
ResultView          → lee QuizManager.winningProfile, muestra _ProfileCard + _Breakdown
  · onRestartTap()  → confirm → QuizManager.reset() → replaceAll(IntroView)
```

Decisión clave: `goBack()` **resta** el `scoreDelta` del paso al que regresas y borra la respuesta de `answers`. Permite cambiar respuestas sin acumular sesgo. Ver `StepperViewModel.goBack()`.

### Contenido como dato, no como código

Las 6 preguntas viven en `StepperViewModel.steps` como `List<QuizStep>` const. Los 4 perfiles viven en `ResultViewModel._profiles` como `Map<String, TravelerProfile>` const. Cada `QuizOption` carga su propio `scoreDelta: Map<String, int>` que aplica al elegirla.

Para cambiar el contenido del quiz (preguntas, perfiles, scoring), no se toca lógica — se editan esos dos arreglos const.

### Navegación: `AppNavigator` con transiciones

`MaterialApp` recibe `navigatorKey: AppNavigator.navigatorKey` (`main.dart`). `AppNavigator` expone:

- `navigateToWidget(view, context)` — push estándar.
- `navigateAndReplaceAll(view, context)` — reemplaza todo el stack (uso típico entre pasos del flujo).
- `navigateAndWait<T>(view)` — push esperando un valor de retorno (`AppAlert` lo usa).

Todas las transiciones son **fade + slide vertical 4%** con `Curves.easeOutCubic`, 320ms entrando / 220ms saliendo. Se construyen una sola vez en `_buildRoute<T>()`.

`PopScope(canPop: false)` en `StepperView` intercepta el back del sistema para que vaya a `goBack()` del VM (retroceder un paso) en lugar de cerrar la pantalla.

## Convenciones

- **Tokens, no literales.** Colores (`AppTheme.colorOcean`, `colorSand`...), tipografía (`AppTheme.heading()`, `paragraph()`, `caption()`) y durations (`durationFast` 200ms, `durationNormal` 350ms, `durationSlow` 600ms) viven en `framework/theme/app_theme.dart`. Las views no usan `Color(0xFF...)` ni `Duration(milliseconds: ...)` directos.
- **Animación con tokens.** `AnimatedOpacity`, `AnimatedSlide`, `AnimatedSwitcher`, `AnimatedContainer`, `AnimatedScale` con `AppTheme.duration*` + `Curves.easeOutCubic` (entrada) / `Curves.easeInCubic` (salida). Para barras animadas: `TweenAnimationBuilder<double>`.
- **Modelos de contenido tipados.** `QuizStep`, `QuizOption`, `TravelerProfile` son clases `const` inmutables. Nada de `Map<String, dynamic>` para contenido.
- **Telemetría.** Cada view tiene `static const String tag = 'XView'`. Eventos vía `Telemetry.trackView(tag, action, metadata: {...})` y `Telemetry.trackError(tag, action, e, st)`.
- **Widgets `Base` reutilizables.** `AppButton`, `AppAppBar` (con `progress` opcional para la barra de avance), `AppAlert`, `AppLoading` viven en `framework/widgets/base/`. Lo específico de un paso queda como `class _Widget` privado en el archivo de la view (ver `_Hero`, `_OptionCard`, `_ProfileCard`, `_Breakdown`).
- **Iconografía.** `PhosphorIconsDuotone.*` consistente en toda la app. No mezclar con `Icons.*` de Material.

## Modificar el quiz

- **Cambiar preguntas/opciones** → editar la lista `StepperViewModel.steps`. Asegúrate que cada `scoreDelta` sume al perfil correcto (`mochilero`, `resort`, `cultural`, `gastronomico`).
- **Agregar un perfil** → entrada nueva en `QuizManager.profileScores` + entrada nueva en `ResultViewModel._profiles` + actualizar los `scoreDelta` de cada opción para que toquen el perfil nuevo.
- **Cambiar la cantidad de pasos** → solo agregar/quitar entradas en `steps`. La barra de progreso (`progress = (currentIndex + 1) / totalSteps`) y los textos ("Pregunta X de Y") se ajustan solos.

## Limitaciones conocidas

- Sin persistencia: cerrar la app pierde el progreso del quiz.
- Sin tests automatizados (es un POC).
- `QuizManager` es global; los tests que toquen scoring requieren `QuizManager().reset()` en `setUp`.
- El back del sistema en `IntroView` y `ResultView` no está interceptado — sale de la app.
