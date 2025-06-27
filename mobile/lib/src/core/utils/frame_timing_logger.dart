import 'package:flutter/widgets.dart';

/// Logs jank frame timings to the console.
/// Can be hooked to Firebase Performance in the future.
class FrameTimingLogger {
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addTimingsCallback((timings) {
      for (final t in timings) {
        final ms = t.totalSpan.inMilliseconds;
        if (ms > 16) {
          // ignore: avoid_print
          print('[Perf] Jank frame: ${ms}ms');
        }
      }
    });
  }
}
