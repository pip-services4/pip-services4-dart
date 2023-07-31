import 'package:pip_services4_components/pip_services4_components.dart';

import 'ITracer.dart';
import 'TraceTiming.dart';

class NullTracer implements ITracer {
  /// Records an operation trace with its name and duration
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  /// - [duration] execution duration in milliseconds.
  @override
  void trace(
      IContext? context, String component, String operation, int duration) {
    // Do nothing...
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
    // Do nothing...
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
