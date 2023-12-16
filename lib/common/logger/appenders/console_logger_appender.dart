// ignore_for_file: avoid_print

import 'package:books_to_read/common/logger/logger_appender.dart';

/// Prints logs to the console.
class ConsoleLoggerAppender implements LoggerAppender {
  const ConsoleLoggerAppender();

  @override
  void append(String message) {
    print('${DateTime.now()}/ $message');
  }

  @override
  void appendError(Object error, [StackTrace? stackTrace]) {
    print('${DateTime.now()}/ ${error.runtimeType}: $error');
    if (stackTrace != null) {
      print('${DateTime.now()}/ $stackTrace');
    }
  }
}
