import 'package:flutter/material.dart';
import 'package:quiz_stepper_poc/framework/theme/app_theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isEnabled = true,
    this.height = 52,
    this.colorFill,
    this.colorBorder,
    this.colorText,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final bool isEnabled;
  final double height;
  final Color? colorFill;
  final Color? colorBorder;
  final Color? colorText;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final fill = colorFill ?? AppTheme.COLOR_OCEAN;
    final border = colorBorder ?? AppTheme.COLOR_OCEAN;
    final text = colorText ?? AppTheme.COLOR_WHITE;

    return AnimatedOpacity(
      duration: AppTheme.DURATION_FAST,
      opacity: isEnabled ? 1.0 : 0.45,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: AppTheme.DURATION_FAST,
          height: height,
          decoration: BoxDecoration(
            color: fill,
            border: Border.all(color: border, width: 1.5),
            borderRadius: BorderRadius.circular(14),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: fill.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: text, size: 20),
                const SizedBox(width: 8),
              ],
              Text(label, style: AppTheme.title(color: text)),
            ],
          ),
        ),
      ),
    );
  }
}
