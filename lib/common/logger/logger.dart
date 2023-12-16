import 'package:books_to_read/common/logger/logger_appender.dart';

class Logger {
  static final List<LoggerAppender> _appenders = [];
  final String tag;

  const Logger(this.tag);

  static void addAppender(LoggerAppender appender) {
    _appenders.add(appender);
  }

  void log(Object message) {
    for (final appender in _appenders) {
      appender.append('$tag: $message');
    }
  }

  void logError(dynamic error, [StackTrace? stackTrace]) {
    for (final appender in _appenders) {
      appender.appendError(error, stackTrace);
    }
  }
}
