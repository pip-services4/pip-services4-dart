import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

/// Helper class that closes previously opened components.
///
/// [ICloseable]

class Closer {
  /// Closes specific component.
  ///
  /// To be closed components must implement [ICloseable] interface.
  /// If they don't the call to this method has no effect.
  ///
  /// - [context] 	(optional) a context to trace execution through call chain.
  /// - [component] 		the component that is to be closed.
  /// Retrun 			Future that receives error or null no errors occured.
  ///
  /// See [IClosable]

  static Future closeOne(IContext? context, component) async {
    if (component is IClosable) await component.close(context);
  }

  /// Closes multiple components.
  ///
  /// To be closed components must implement [ICloseable] interface.
  /// If they don't the call to this method has no effect.
  ///
  /// - [context] 	(optional) a context to trace execution through call chain.
  /// - [components] 		the list of components that are to be closed.
  /// Returns 			  Future that receives error or null no errors occured.
  ///
  /// See [closeOne]
  /// See [IClosable]

  static Future close(IContext? context, List? components) async {
    if (components == null) return;

    for (var component in components) {
      await Closer.closeOne(context, component);
    }
  }
}
