import 'package:flutter/foundation.dart';
import 'package:quiz_stepper_poc/app/quiz/manager/quiz_manager.dart';

class QuizOption {
  const QuizOption({
    required this.label,
    required this.value,
    required this.scoreDelta,
  });

  final String label;
  final String value;
  final Map<String, int> scoreDelta;
}

class QuizStep {
  const QuizStep({
    required this.key,
    required this.question,
    required this.options,
  });

  final String key;
  final String question;
  final List<QuizOption> options;
}

class StepperViewModel extends ChangeNotifier {
  final QuizManager manager = QuizManager();

  static const List<QuizStep> steps = [
    QuizStep(
      key: 'budget',
      question: '¿Cuánto quieres gastar en el viaje?',
      options: [
        QuizOption(
          label: 'Lo básico, la hago con poco',
          value: 'low',
          scoreDelta: {'mochilero': 3, 'cultural': 1},
        ),
        QuizOption(
          label: 'Gastar lo necesario',
          value: 'medium',
          scoreDelta: {'cultural': 2, 'gastronomico': 2},
        ),
        QuizOption(
          label: 'Todo incluido, sin broncas',
          value: 'high',
          scoreDelta: {'resort': 3, 'gastronomico': 1},
        ),
      ],
    ),
    QuizStep(
      key: 'activity',
      question: '¿Qué actividad te prende más?',
      options: [
        QuizOption(
          label: 'Caminar sierra y acampar',
          value: 'adventure',
          scoreDelta: {'mochilero': 3},
        ),
        QuizOption(
          label: 'Echarme al sol y no moverme',
          value: 'relax',
          scoreDelta: {'resort': 3},
        ),
        QuizOption(
          label: 'Museos, arte, historia',
          value: 'culture',
          scoreDelta: {'cultural': 3},
        ),
        QuizOption(
          label: 'Probar cada platillo y cada mezcal',
          value: 'food',
          scoreDelta: {'gastronomico': 3},
        ),
      ],
    ),
    QuizStep(
      key: 'accommodation',
      question: '¿Dónde duermes?',
      options: [
        QuizOption(
          label: 'Hostel compartido',
          value: 'hostel',
          scoreDelta: {'mochilero': 3},
        ),
        QuizOption(
          label: 'Airbnb de barrio',
          value: 'airbnb',
          scoreDelta: {'cultural': 2, 'gastronomico': 1},
        ),
        QuizOption(
          label: 'Hotel boutique',
          value: 'boutique',
          scoreDelta: {'cultural': 1, 'gastronomico': 2},
        ),
        QuizOption(
          label: 'Resort todo incluido',
          value: 'resort',
          scoreDelta: {'resort': 3},
        ),
      ],
    ),
    QuizStep(
      key: 'duration',
      question: '¿Cuánto dura tu viaje ideal?',
      options: [
        QuizOption(
          label: 'Un fin de semana',
          value: 'weekend',
          scoreDelta: {'resort': 2, 'gastronomico': 1},
        ),
        QuizOption(
          label: 'Una semana',
          value: 'week',
          scoreDelta: {'cultural': 2, 'gastronomico': 1, 'resort': 1},
        ),
        QuizOption(
          label: 'Un mes o más',
          value: 'month',
          scoreDelta: {'mochilero': 3, 'cultural': 1},
        ),
      ],
    ),
    QuizStep(
      key: 'company',
      question: '¿Con quién viajas?',
      options: [
        QuizOption(
          label: 'Solo/a',
          value: 'solo',
          scoreDelta: {'mochilero': 2, 'cultural': 1},
        ),
        QuizOption(
          label: 'Con mi pareja',
          value: 'couple',
          scoreDelta: {'gastronomico': 2, 'resort': 1, 'cultural': 1},
        ),
        QuizOption(
          label: 'Con los cuates',
          value: 'friends',
          scoreDelta: {'mochilero': 1, 'gastronomico': 1, 'resort': 1},
        ),
        QuizOption(
          label: 'Con la familia',
          value: 'family',
          scoreDelta: {'resort': 3},
        ),
      ],
    ),
    QuizStep(
      key: 'climate',
      question: '¿A dónde quieres aterrizar?',
      options: [
        QuizOption(
          label: 'Playa en el Caribe',
          value: 'beach',
          scoreDelta: {'resort': 3},
        ),
        QuizOption(
          label: 'Sierra y bosque',
          value: 'mountain',
          scoreDelta: {'mochilero': 3},
        ),
        QuizOption(
          label: 'Centro histórico',
          value: 'city',
          scoreDelta: {'cultural': 3, 'gastronomico': 1},
        ),
        QuizOption(
          label: 'Pueblo mágico',
          value: 'countryside',
          scoreDelta: {'gastronomico': 2, 'cultural': 1},
        ),
      ],
    ),
  ];

  int currentIndex = 0;
  QuizOption? selectedOption;

  QuizStep get currentStep => steps[currentIndex];
  int get totalSteps => steps.length;
  double get progress => (currentIndex + 1) / totalSteps;
  bool get isFirst => currentIndex == 0;
  bool get isLast => currentIndex == steps.length - 1;
  bool get canContinue => selectedOption != null;

  void selectOption(QuizOption option) {
    selectedOption = option;
    notifyListeners();
  }

  bool continueNext() {
    final option = selectedOption;
    if (option == null) return false;
    manager.recordAnswer(
      key: currentStep.key,
      value: option.value,
      scoreDelta: option.scoreDelta,
    );
    if (isLast) return true;
    currentIndex++;
    selectedOption = null;
    notifyListeners();
    return false;
  }

  void goBack() {
    if (isFirst) return;
    currentIndex--;
    selectedOption = null;
    final key = currentStep.key;
    final priorValue = manager.answers[key];
    if (priorValue != null) {
      final priorOption = currentStep.options.firstWhere(
        (o) => o.value == priorValue,
        orElse: () => currentStep.options.first,
      );
      priorOption.scoreDelta.forEach((profile, delta) {
        manager.profileScores[profile] =
            (manager.profileScores[profile] ?? 0) - delta;
      });
      manager.answers.remove(key);
    }
    notifyListeners();
  }
}
