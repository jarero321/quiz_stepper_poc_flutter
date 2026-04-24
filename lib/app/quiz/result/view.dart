import 'package:flutter/material.dart';
import 'package:quiz_stepper_poc/app/quiz/intro/view.dart';
import 'package:quiz_stepper_poc/app/quiz/result/model.dart';
import 'package:quiz_stepper_poc/framework/theme/app_theme.dart';
import 'package:quiz_stepper_poc/framework/utils/app_navigator.dart';
import 'package:quiz_stepper_poc/framework/utils/telemetry.dart';
import 'package:quiz_stepper_poc/framework/widgets/base/app_alert.dart';
import 'package:quiz_stepper_poc/framework/widgets/base/app_button.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  static const String tag = 'ResultView';

  late final ResultViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ResultViewModel();
    _viewModel.reveal();
    Telemetry.trackView(
      tag,
      'init',
      metadata: {'profile': _viewModel.profile.key},
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void onRestartTap() {
    Telemetry.trackView(tag, 'restart_tap');
    showAlert(
      context: context,
      title: '¿Hacer el test de nuevo?',
      body: 'Se van a borrar tus respuestas actuales.',
      continueLabel: 'Sí, empezar de nuevo',
      cancelLabel: 'Cancelar',
      continueCallBack: () {
        _viewModel.restart();
        if (!mounted) return;
        AppNavigator.navigateAndReplaceAll(
          view: const IntroView(),
          context: context,
        );
      },
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tu perfil de viajero',
            style: AppTheme.caption(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedOpacity(
              duration: AppTheme.durationSlow,
              opacity: _viewModel.isRevealed ? 1 : 0,
              child: AnimatedScale(
                duration: AppTheme.durationSlow,
                curve: Curves.easeOutBack,
                scale: _viewModel.isRevealed ? 1 : 0.85,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _ProfileCard(profile: _viewModel.profile),
                      const SizedBox(height: 20),
                      _Breakdown(viewModel: _viewModel),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Volver a empezar',
            onTap: onRestartTap,
            colorFill: AppTheme.colorWhite,
            colorBorder: AppTheme.colorOcean,
            colorText: AppTheme.colorOcean,
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final TravelerProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [profile.gradientStart, profile.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: profile.gradientEnd.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.colorWhite.withValues(alpha: 0.18),
            ),
            child: Icon(profile.icon, size: 44, color: AppTheme.colorWhite),
          ),
          const SizedBox(height: 16),
          Text(
            profile.title,
            style: AppTheme.heading(color: AppTheme.colorWhite),
          ),
          const SizedBox(height: 6),
          Text(
            profile.tagline,
            style: AppTheme.paragraph(
              color: AppTheme.colorWhite.withValues(alpha: 0.9),
              weight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            profile.description,
            style: AppTheme.paragraph(
              color: AppTheme.colorWhite.withValues(alpha: 0.95),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.viewModel});

  final ResultViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.colorWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.colorCloud),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Cómo se distribuyó tu perfil', style: AppTheme.title()),
          const SizedBox(height: 14),
          for (final p in viewModel.allProfiles) ...[
            _BreakdownRow(
              label: p.title,
              ratio: viewModel.scoreRatio(p.key),
              color: p.gradientEnd,
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.ratio,
    required this.color,
  });

  final String label;
  final double ratio;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTheme.paragraph(weight: FontWeight.w500)),
            Text('${(ratio * 100).round()}%', style: AppTheme.caption()),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: ratio),
            duration: AppTheme.durationSlow,
            curve: Curves.easeOutCubic,
            builder: (_, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: AppTheme.colorCloud,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
