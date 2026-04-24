import 'package:flutter/material.dart';
import 'package:quiz_stepper_poc/app/quiz/intro/model.dart';
import 'package:quiz_stepper_poc/app/quiz/stepper/view.dart';
import 'package:quiz_stepper_poc/framework/theme/app_theme.dart';
import 'package:quiz_stepper_poc/framework/utils/app_navigator.dart';
import 'package:quiz_stepper_poc/framework/utils/telemetry.dart';
import 'package:quiz_stepper_poc/framework/widgets/base/app_button.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  static const String tag = 'IntroView';

  late final IntroViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = IntroViewModel();
    _viewModel.init();
    Telemetry.trackView(tag, 'init');
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void onStart() {
    Telemetry.trackView(
      tag,
      'button_tap',
      metadata: {'button_name': 'Empezar'},
    );
    AppNavigator.navigateAndReplaceAll(
      view: const StepperView(),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorSand,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (_, _) => _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return AnimatedOpacity(
      duration: AppTheme.durationSlow,
      opacity: _viewModel.isReady ? 1 : 0,
      child: AnimatedSlide(
        duration: AppTheme.durationSlow,
        curve: Curves.easeOutCubic,
        offset: _viewModel.isReady ? Offset.zero : const Offset(0, 0.08),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const _Hero(),
              const SizedBox(height: 32),
              const _Header(),
              const Spacer(),
              AppButton(
                label: 'Descubrir mi perfil',
                onTap: onStart,
                icon: Icons.arrow_forward_rounded,
              ),
              const SizedBox(height: 12),
              Text(
                '6 preguntas · toma 1 minuto',
                style: AppTheme.caption(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.colorOcean, AppTheme.colorOceanDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(48),
          boxShadow: [
            BoxShadow(
              color: AppTheme.colorOcean.withValues(alpha: 0.35),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: const Icon(
          Icons.travel_explore_rounded,
          size: 88,
          color: AppTheme.colorWhite,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '¿Qué tipo de viajero eres?',
          style: AppTheme.heading(),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Responde unas preguntas rápidas y descubre qué perfil se ajusta mejor a tu forma de viajar.',
          style: AppTheme.paragraph(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
