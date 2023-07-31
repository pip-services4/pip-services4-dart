import 'package:pip_services4_components/pip_services4_components.dart';

import '../../pip_services4_observability.dart';

/// Dummy implementation of logger that doesn't do anything.
///
/// It can be used in testing or in situations when logger is required
/// but shall be disabled.
///
/// See [ILogger]
class NullLogger implements ILogger {
  /// Creates a new instance of the logger.
  ///
  NullLogger();

  /// Gets the maximum log level.
  /// Messages with higher log level are filtered out.
  ///
  /// Return the maximum log level.
  @override
  LogLevel getLevel() {
    return LogLevel.None;
  }

  /// Set the maximum log level.
  ///
  /// - [value]     a new maximum log level.
  @override
  void setLevel(LogLevel value) {}

  /// Logs a message at specified log level.
  ///
  /// - [level]             a log level.
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void log(LogLevel level, IContext? context, Exception? error, String message,
      [List? args]) {}

  /// Logs fatal (unrecoverable) message that caused the process to crash.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void fatal(IContext? context, Exception? error, String message,
      [List? args]) {}

  /// Logs recoverable application error.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void error(IContext? context, Exception? error, String message,
      [List? args]) {}

  /// Logs a warning that may or may not have a negative impact.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void warn(IContext? context, String message, [List? args]) {}

  /// Logs an important information message
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void info(IContext? context, String message, [List? args]) {}

  /// Logs a high-level debug information for troubleshooting.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void debug(IContext? context, String message, [List? args]) {}

  /// Logs a low-level debug information for troubleshooting.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void trace(IContext? context, String message, [List? args]) {}
}
