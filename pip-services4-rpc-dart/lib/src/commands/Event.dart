import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

import './IEvent.dart';
import './IEventListener.dart';

/// Concrete implementation of [IEvent] interface.
/// It allows to send asynchronous notifications to multiple subscribed listeners.
///
/// See [IEvent]
/// See [IEventListener]
///
/// ### Example ###
///
///     var event =  Event('my_event');
///
///     event.addListener(myListener);
///
///     event.notify('123', Parameters.fromTuples(
///       ['param1', 'ABC',
///       'param2', 123]
///     ));

class Event implements IEvent {
  final String _name;
  final List<IEventListener> _listeners;

  /// Creates a new event and assigns its name.
  ///
  /// - name  the name of the event that is to be created.
  /// @throws an Error if the name is null.

  Event(String name)
      : _name = name,
        _listeners = [];

  /// Gets the name of the event.
  ///
  /// Returns the name of this event.
  @override
  String getName() {
    return _name;
  }

  /// Gets all listeners registred in this event.
  ///
  /// Returns a list of listeners.
  @override
  List<IEventListener> getListeners() {
    return _listeners;
  }

  /// Adds a listener to receive notifications when this event is fired.
  ///
  /// - [listener] the listener reference to add.

  @override
  void addListener(IEventListener listener) {
    _listeners.add(listener);
  }

  /// Removes a listener, so that it no longer receives notifications for this event.
  ///
  /// - [listener]      the listener reference to remove.

  @override
  void removeListener(IEventListener listener) {
    var index = _listeners.indexOf(listener);

    if (index > -1) _listeners.removeAt(index);
  }

  /// Fires this event and notifies all registred listeners.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [args]              the parameters to raise this event with.
  /// throws an [InvocationException] if the event fails to be raised.

  @override
  void notify(IContext? context, Parameters args) {
    for (var i = 0; i < _listeners.length; i++) {
      try {
        var listener = _listeners[i];
        listener.onEvent(context, this, args);
      } catch (ex) {
        throw InvocationException(
                context != null ? ContextResolver.getTraceId(context) : null,
                'EXEC_FAILED',
                'Raising event ${getName()} failed: $ex')
            .withDetails('event', getName())
            .wrap(ex);
      }
    }
  }
}
