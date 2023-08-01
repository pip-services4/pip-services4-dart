import 'package:pip_services4_components/pip_services4_components.dart';

import './IEvent.dart';
import './Event.dart';

/// An interface for listener objects that receive notifications on fired events.
///
/// See [IEvent]
/// See [Event]
///
/// ### Example ###
///
///     class MyListener implements IEventListener {
///          void _onEvent(IContext? context, IEvent event, Parameters args ) {
///             print('Fired event ' + event.getName());
///         }
///     }
///
///     var event =  Event('myevent');
///     event.addListener( MyListener());
///     event.notify('123', Parameters.fromTuples(['param1', 'ABC']));
///
///     // Console output: Fired event myevent

abstract interface class IEventListener {
  /// A method called when events this listener is subscrubed to are fired.
  ///
  /// - [event] 			a fired evemt
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [args] 			    event arguments.

  void onEvent(IContext? context, IEvent event, Parameters args);
}
