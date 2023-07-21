import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for components that should clean their state.
///
/// Cleaning state most often is used during testing.
/// But there may be situations when it can be done in production.
///
/// See [Cleaner]
///
/// ### Example ###
///
///     class MyObjectWithState implements ICleanable {
///         dynamic _state = {};
///         ...
///         Future clear(IContext? context) {
///            _state = {};
///            return  Future();
///         }
///     }
///

abstract class ICleanable {
  /// Clears component state.
  ///
  /// - [context] 	(optional) a context to trace execution through call chain.
  /// Return 			Future that receives error or null no errors occured.

  Future clear(IContext? context);
}
