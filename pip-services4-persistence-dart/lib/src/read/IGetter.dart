import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

/// Interface for data processing components that can get data items.

abstract interface class IGetter<T extends IIdentifiable<K>, K> {
  /// Gets a data items by its unique id.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [id]                an id of item to be retrieved.
  /// Return                that receives an item
  /// Throw error.
  Future<T?> getOneById(IContext? context, K id);
}
