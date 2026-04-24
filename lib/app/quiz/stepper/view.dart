import 'package:flutter/material.dart';
import 'package:quiz_stepper_poc/app/quiz/intro/view.dart';
import 'package:quiz_stepper_poc/app/quiz/result/view.dart';
import 'package:quiz_stepper_poc/app/quiz/stepper/model.dart';
import 'package:quiz_stepper_poc/framework/theme/app_theme.dart';
import 'package:quiz_stepper_poc/framework/utils/app_navigator.dart';
import 'package:quiz_stepper_poc/framework/utils/telemetry.dart';
import 'package:quiz_stepper_poc/framework/widgets/base/app_appbar.dart';
import 'package:quiz_stepper_poc/framework/widgets/base/app_button.dart';

class StepperView extends StatefulWidget {
  const StepperView({super.key});

  @override
  State<StepperView> createState() => _StepperViewState();
}

class _StepperViewState extends State<StepperView> {
  // ─── Constants ───
  static const String tag = 'StepperView';

  late final StepperViewModel _viewModel;

  // ─── Lifecycle ───
  @override
  void initState() {
    super.initState();
    _viewModel = StepperViewModel();
    Telemetry.trackView(tag, 'init');
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  // ─── Handlers ───
  void onContinue() {
    Telemetry.trackView(
      tag,
      'continue_tap',
      metadata: {'step': _viewModel.currentStep.key},
    );
    final isDone = _viewModel.continueNext();
    if (isDone && mounted) {
      AppNavigator.navigateAndReplaceAll(
        view: const ResultView(),
        context: context,
      );
    }
  }

  void onBack() {
    if (_viewModel.isFirst) {
      Telemetry.trackView(tag, 'exit_quiz');
      AppNavigator.navigateAndReplaceAll(
        view: const IntroView(),
        context: context,
      );
      return;
    }
    Telemetry.trackView(
      tag,
      'back_tap',
      metadata: {'step': _viewModel.currentStep.key},
    );
    _viewModel.goBack();
  }

  // ─── Build ───
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Future.delayed(Duration.zero, onBack);
      },
      child: ListenableBuilder(
        listenable: _viewModel,
        builder: (_, _) => Scaffold(
          backgroundColor: AppTheme.colorSand,
          appBar: AppAppBar(
            title:
                'Pregunta ${_viewModel.currentIndex + 1} de ${_viewModel.totalSteps}',
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppTheme.colorSlate,
                size: 18,
              ),
              onPressed: onBack,
            ),
            progress: _viewModel.progress,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: _stepBody()),
                _footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── UI helpers ───
  Widget _stepBody() {
    return AnimatedSwitcher(
      duration: AppTheme.durationNormal,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: _StepContent(
        key: ValueKey(_viewModel.currentStep.key),
        step: _viewModel.currentStep,
        selected: _viewModel.selectedOption,
        onSelect: _viewModel.selectOption,
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: AppButton(
        label: _viewModel.isLast ? 'Ver mi perfil' : 'Siguiente',
        isEnabled: _viewModel.canContinue,
        onTap: onContinue,
        icon: _viewModel.isLast
            ? Icons.auto_awesome_rounded
            : Icons.arrow_forward_rounded,
      ),
    );
  }
}

class _StepContent extends StatelessWidget {
  const _StepContent({
    super.key,
    required this.step,
    required this.selected,
    required this.onSelect,
  });

  final QuizStep step;
  final QuizOption? selected;
  final ValueChanged<QuizOption> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(step.question, style: AppTheme.heading()),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: step.options.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final opt = step.options[i];
                return _OptionCard(
                  option: opt,
                  isSelected: selected?.value == opt.value,
                  onTap: () => onSelect(opt),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final QuizOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppTheme.durationFast,
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.colorOcean : AppTheme.colorWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.colorOcean : AppTheme.colorCloud,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.colorOcean.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: AppTheme.durationFast,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.colorWhite : AppTheme.colorCloud,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: AppTheme.colorOcean,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                option.label,
                style: AppTheme.paragraph(
                  color: isSelected
                      ? AppTheme.colorWhite
                      : AppTheme.colorSlate,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
