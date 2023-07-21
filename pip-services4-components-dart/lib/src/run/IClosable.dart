import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for components that require explicit closure.
///
/// For components that require opening as well as closing
/// use [IOpenable] interface instead.
///
/// See [IOpenable]
/// See [Closer]
///
/// ### Example ###
///
///     class MyConnector implements ICloseable {
///         dynamic _client = null;
///
///         ... // The _client can be lazy created
///
///         Future close(IContext context){
///             if (_client != null) {
///                 _client.close();
///                 _client = null;
///             }
///             return  Future.delayed( Duration());
///         }
///     }
///

abstract interface class IClosable {
  /// Closes component and frees used resources.
  ///
  /// - [context] 	(optional) a context to trace execution through call chain.
  /// Return 			  Future that receives error or null no errors occured.

  Future close(IContext? context);
}
