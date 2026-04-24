import 'package:flutter/material.dart';
import 'package:quiz_stepper_poc/app/quiz/intro/view.dart';
import 'package:quiz_stepper_poc/framework/theme/app_theme.dart';
import 'package:quiz_stepper_poc/framework/utils/app_navigator.dart';
import 'package:quiz_stepper_poc/framework/utils/telemetry.dart';
import 'package:quiz_stepper_poc/framework/widgets/base/app_button.dart';

/// Terminal error view — reached only for fatal/irrecoverable states.
/// Recoverable errors must use showAlert, not this view.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  static const String tag = 'ErrorView';

  @override
  Widget build(BuildContext context) {
    Telemetry.trackView(tag, 'init');
    return Scaffold(
      backgroundColor: AppTheme.COLOR_SAND,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(
                Icons.error_outline_rounded,
                size: 72,
                color: AppTheme.COLOR_SUNSET,
              ),
              const SizedBox(height: 16),
              Text(
                'Algo salió mal',
                style: AppTheme.heading(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'No pudimos terminar el test. Probá de nuevo.',
                style: AppTheme.paragraph(),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton(
                label: 'Volver al inicio',
                onTap: () {
                  AppNavigator.navigateAndReplaceAll(
                    view: const IntroView(),
                    context: context,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
