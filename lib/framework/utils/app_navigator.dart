import 'package:flutter/material.dart';

/// Centralized navigation mirroring ABEA's ModuleNavigator.
/// Deviation from the source: transitions are animated (300ms fade+slide)
/// instead of Duration.zero — the POC showcases animations explicitly.
class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> navigateToWidget({
    required Widget view,
    required BuildContext context,
  }) async {
    await Navigator.of(context).push(_buildRoute(view));
  }

  static Future<void> navigateAndReplaceAll({
    required Widget view,
    required BuildContext context,
  }) async {
    await Navigator.of(context).pushAndRemoveUntil(
      _buildRoute(view),
      (route) => false,
    );
  }

  static Future<T?> navigateAndWait<T>({
    required Widget view,
    BuildContext? context,
  }) async {
    final ctx = context ?? navigatorKey.currentContext;
    if (ctx == null) return null;
    return Navigator.of(ctx).push<T>(
      PageRouteBuilder<T>(
        opaque: false,
        pageBuilder: (_, _, _) => view,
        transitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  static PageRouteBuilder<T> _buildRoute<T>(Widget view) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, _, _) => view,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
