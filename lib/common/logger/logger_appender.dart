/// An abstraction describing how actual logs are reported.
abstract class LoggerAppender {
  /// Appends a debug message.
  void append(String message);

  /// Appends an error with optional stacktrace.
  void appendError(Object error, [StackTrace? stackTrace]);
}
