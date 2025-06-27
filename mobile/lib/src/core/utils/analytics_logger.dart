class AnalyticsLogger {
  static void logEvent(String name, [Map<String, dynamic>? params]) {
    // TODO: integrate Firebase Analytics; for now print.
    // ignore: avoid_print
    print('[Analytics] $name ${params ?? {}}');
  }
}
