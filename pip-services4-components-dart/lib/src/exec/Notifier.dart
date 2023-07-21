import 'package:pip_services4_components/pip_services4_components.dart';

/// Helper class that notifies components.
///
/// [INotifiable]

class Notifier {
  /// Notifies specific component.
  ///
  /// To be notiied components must implement [INotifiable] interface.
  /// If they don't the call to this method has no effect.
  ///
  /// - [context] 	(optional) a context to trace execution through call chain.
  /// - [component] 		the component that is to be notified.
  /// - [args]              notifiation arguments.
  ///
  /// See [INotifiable]

  static void notifyOne(IContext? context, component, Parameters args) {
    if (component is INotifiable) component.notify(context, args);
  }

  /// Notifies multiple components.
  ///
  /// To be notified components must implement [INotifiable] interface.
  /// If they don't the call to this method has no effect.
  ///
  /// - [context] 	(optional) a context to trace execution through call chain.
  /// - [components] 		a list of components that are to be notified.
  /// - [args]              notification arguments.
  ///
  /// See [notifyOne]
  /// See [INotifiable]

  static void notify(IContext? context, List? components, Parameters args) {
    if (components == null) return;

    for (var component in components) {
      Notifier.notifyOne(context, component, args);
    }
  }
}
