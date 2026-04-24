import 'package:flutter/material.dart';
import 'package:quiz_stepper_poc/framework/theme/app_theme.dart';
import 'package:quiz_stepper_poc/framework/widgets/base/app_button.dart';

/// Recoverable-error / confirmation dialog — analog to ABEA's showAlert.
/// Use for backend rejections a user can fix, or destructive confirmations.
/// Never use for fatal errors: those route to ErrorView.
Future<void> showAlert({
  required BuildContext context,
  required String body,
  required VoidCallback continueCallBack,
  String continueLabel = 'Continuar',
  String? title,
  String? cancelLabel,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      backgroundColor: AppTheme.COLOR_WHITE,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Text(title, style: AppTheme.title()),
              const SizedBox(height: 12),
            ],
            Text(body, style: AppTheme.paragraph()),
            const SizedBox(height: 24),
            if (cancelLabel != null) ...[
              AppButton(
                label: cancelLabel,
                onTap: () => Navigator.of(ctx).pop(),
                colorFill: AppTheme.COLOR_WHITE,
                colorBorder: AppTheme.COLOR_CLOUD,
                colorText: AppTheme.COLOR_SLATE,
                height: 44,
              ),
              const SizedBox(height: 10),
            ],
            AppButton(
              label: continueLabel,
              onTap: () {
                Navigator.of(ctx).pop();
                continueCallBack();
              },
              height: 44,
            ),
          ],
        ),
      ),
    ),
  );
}
