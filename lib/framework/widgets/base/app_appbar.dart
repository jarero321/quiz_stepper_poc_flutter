import 'package:flutter/material.dart';
import 'package:quiz_stepper_poc/framework/theme/app_theme.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.progress,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double? progress;

  @override
  Size get preferredSize => Size.fromHeight(progress != null ? 59 : 56);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: AppTheme.COLOR_SAND,
          elevation: 0,
          centerTitle: true,
          leading: leading,
          title: title == null ? null : Text(title!, style: AppTheme.title()),
          actions: actions,
        ),
        if (progress != null)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: AppTheme.DURATION_NORMAL,
            curve: Curves.easeOutCubic,
            builder: (_, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 3,
              backgroundColor: AppTheme.COLOR_CLOUD,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.COLOR_OCEAN,
              ),
            ),
          ),
      ],
    );
  }
}
