import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

import '../../pip_services4_observability.dart';

/// Logger that writes log messages to console.
///
/// Errors are written to standard err stream
/// and all other messages to standard out stream.
///
/// ### Configuration parameters ###
///
/// - [level]:             maximum log level to capture
/// - [source]:            source (context) name
///
/// ### References ###
///
/// - \*:context-info:\*:\*:1.0     (optional) [ContextInfo] to detect the context id and specify counters source
///
/// See [Logger]
///
/// ### Example ###
///
///     var logger = new ConsoleLogger();
///     logger.setLevel(LogLevel.debug);
///
///     logger.error('123', ex, 'Error occured: %s', ex.message);
///     logger.debug('123', 'Everything is OK.');
class ConsoleLogger extends Logger {
  /// Creates a new instance of the logger.
  ConsoleLogger() : super();

  /// Writes a log message to the logger destination.
  ///
  /// - [level]             a log level.
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  @override
  void write(
      LogLevel level, IContext? context, Exception? error, String message) {
    if (getLevel().index < level.index) return;

    var result = '[';
    result += context != null ? ContextResolver.getTraceId(context) : '---';
    result += ':';
    result += LogLevelConverter.toString2(level);
    result += ':';
    result += StringConverter.toString2(DateTime.now().toUtc());
    result += '] ';

    result += message;

    if (error != null) {
      if (message.isEmpty) {
        result += 'Error: ';
      } else {
        result += ': ';
      }

      result += composeError(error);
    }

    print(result);
    // if (level == LogLevel.Fatal || level == LogLevel.Error || level == LogLevel.Warn)
    //    console.error(result);
    // else
    //     console.log(result);
  }
}
