import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for components that require explicit opening and closing.
///
/// For components that perform opening on demand consider using
/// [ICloseable] interface instead.
///
/// See [IOpenable]
/// See [Opener]
///
/// ### Example ###
///
///     class MyPersistence implements IOpenable {
///         dynamic _client;
///         ...
///         bool isOpen() {
///             return _client != null;
///         }
///
///         Future open(IContext? context) {
///             if (isOpen()) {
///                 return Future(Duration(), (){
///
///                  })
///             }
///             ...
///         }
///
///         Future close(IContext? context) async {
///             if (_client != null) {
///                 result = await _client.close();
///                 _client = null;
///                Future(Duration(), (){ return result})
///             }
///         }
///
///         ...
///     }

abstract class IOpenable implements IClosable {
  /// Checks if the component is opened.
  ///
  /// Returns true if the component has been opened and false otherwise.

  bool isOpen();

  /// Opens the component.
  ///
  /// - [context] 	(optional) a context to trace execution through call chain.
  /// Return 			    Future that receives error or null no errors occured.

  Future open(IContext? context);
}
