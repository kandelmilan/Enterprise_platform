import 'dart:developer';

class AppLogger {
  AppLogger._();

  static void info(String message) {
    log(message);
  }

  static void error(String message, {StackTrace? stackTrace}) {
    log(message, stackTrace: stackTrace, level: 1000);
  }
}
