import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for data processing components that load data items.
abstract interface class ILoader<T> {
  /// Loads data items.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return                Future that receives a list of data items
  /// Throw error.
  Future<List<T>> load(IContext? context);
}
