import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for components that can be asynchronously notified.
/// The notification may include optional argument that describe
/// the occured event.
///
/// See [Notifier]
/// See [IExecutable]
///
/// ### Example ###
///
///     class MyComponent implements INotifable {
///         ...
///         void notify(IContext? context, Parameters args) {
///             console.log('Occured event ' + args.getAsString('event'));
///         }
///     }
///
///     var myComponent =  MyComponent();
///
///     myComponent.notify(Context.fromTraceId('123'), Parameters.fromTuples('event', 'Test Event'));

abstract class INotifiable {
  /// Notifies the component about occured event.
  ///
  /// - [context] 	(optional) a context to trace execution through call chain.
  /// - [args] 				notification arguments.

  void notify(IContext? context, Parameters args);
}
