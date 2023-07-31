import 'package:pip_services4_components/pip_services4_components.dart';

import '../log/log.dart';

/// Todo: solve issue with overloaded methods. Look at Python implementation
/// Interface for logger components that capture execution log messages.

abstract interface class ILogger {
  /// Gets the maximum log level.
  /// Messages with higher log level are filtered out.
  ///
  /// Return the maximum log level.
  LogLevel getLevel();

  /// Set the maximum log level.
  ///
  /// - [value]     a new maximum log level.
  void setLevel(LogLevel value);

  /// Logs a message at specified log level.
  ///
  /// - [level]             a log level.
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void log(LogLevel level, IContext? context, Exception? error, String message,
      [List? args]);

  /// Logs fatal (unrecoverable) message that caused the process to crash.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void fatal(IContext? context, Exception? error, String message, [List args]);

  // Todo: these overloads are not supported in TS
  //fatal(IContext? context, error: Exception) ;
  //fatal(IContext? context, String message, List args) ;

  /// Logs recoverable application error.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void error(IContext? context, Exception? error, String message, [List? args]);

  // Todo: these overloads are not supported in TS
  //error(IContext? context, error: Exception) ;
  //error(IContext? context, String message, List args) ;

  /// Logs a warning that may or may not have a negative impact.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void warn(IContext? context, String message, [List? args]);

  /// Logs an important information message
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void info(IContext? context, String message, [List? args]);

  /// Logs a high-level debug information for troubleshooting.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void debug(IContext? context, String message, [List args]);

  /// Logs a low-level debug information for troubleshooting.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void trace(IContext? context, String message, [List? args]);
}
