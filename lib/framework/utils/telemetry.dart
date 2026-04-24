import 'package:flutter/foundation.dart';

class Telemetry {
  static void trackView(
    String tag,
    String event, {
    Map<String, dynamic>? metadata,
  }) {
    if (kDebugMode) {
      final meta = metadata == null ? '' : ' $metadata';
      debugPrint('[Telemetry] $tag :: $event$meta');
    }
  }

  static void trackError(
    String tag,
    String event,
    Object error,
    StackTrace stackTrace,
  ) {
    if (kDebugMode) {
      debugPrint('[Telemetry][ERROR] $tag :: $event :: $error');
      debugPrint(stackTrace.toString());
    }
  }
}
