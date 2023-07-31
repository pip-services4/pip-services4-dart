import 'package:pip_services4_components/pip_services4_components.dart';

import 'TraceTiming.dart';

///
/// Interface for tracer components that capture operation traces.
///
abstract interface class ITracer {
  /// Records an operation trace with its name and duration
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  /// - [duration] execution duration in milliseconds.
  void trace(
      IContext? context, String component, String operation, int duration);

  /// Records an operation failure with its name, duration and error
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  /// - [error] an error object associated with this trace.
  /// - [duration] execution duration in milliseconds.
  void failure(IContext? context, String component, String operation,
      Exception error, int duration);

  /// Begings recording an operation trace
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  ///
  TraceTiming beginTrace(IContext? context, String component, String operation);
}
