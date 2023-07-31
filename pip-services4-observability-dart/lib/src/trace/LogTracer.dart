import 'package:pip_services4_components/pip_services4_components.dart';
import '../log/log.dart';
import 'ITracer.dart';
import 'TraceTiming.dart';

class LogTracer implements IConfigurable, IReferenceable, ITracer {
  final _logger = CompositeLogger();
  var _logLevel = LogLevel.Debug;

  /// Creates a new instance of the tracer.
  LogTracer();

  /// Configures component by passing configuration parameters.
  ///
  /// - [config] configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _logLevel = LogLevelConverter.toLogLevel(
        config.getAsObject('options.log_level'), _logLevel);
  }

  /// Sets references to dependent components.
  ///
  /// - [references] references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    _logger.setReferences(references);
  }

  void _logTrace(IContext? context, String component, String? operation,
      Exception? error, int duration) {
    var builder = '';

    if (error != null) {
      builder += 'Failed to execute ';
    } else {
      builder += 'Executed ';
    }

    builder += component;

    if (operation != null || operation != '') {
      builder += '.';
      builder += operation!;
    }

    if (duration > 0) {
      builder += ' in $duration msec';
    }

    if (error != null) {
      _logger.error(context, error, builder);
    } else {
      _logger.log(_logLevel, context, null, builder);
    }
  }

  /// Records an operation trace with its name and duration
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  /// - [duration] execution duration in milliseconds.
  @override
  void trace(
      IContext? context, String component, String operation, int duration) {
    _logTrace(context, component, operation, null, duration);
  }

  /// Records an operation failure with its name, duration and error
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  /// - [error] an error object associated with this trace.
  /// - [duration] execution duration in milliseconds.
  @override
  void failure(IContext? context, String component, String operation,
      Exception error, int duration) {
    _logTrace(context, component, operation, error, duration);
  }

  /// Begings recording an operation trace
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  ///
  @override
  TraceTiming beginTrace(
      IContext? context, String component, String operation) {
    return TraceTiming(context, component, operation, this);
  }
}
