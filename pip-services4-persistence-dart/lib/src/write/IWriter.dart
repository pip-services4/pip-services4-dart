import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for data processing components that can create, update and delete data items.
abstract interface class IWriter<T, K> {
  /// Creates a data item.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [item]              an item to be created.
  /// Return                Future that receives created item
  /// Throw error.
  Future<T?> create(IContext? context, T? item);

  /// Updates a data item.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [item]              an item to be updated.
  /// Return                Future that receives updated item
  /// Throw error.
  Future<T?> update(IContext? context, T? item);

  /// Deleted a data item by it's unique id.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [id]                an id of the item to be deleted
  /// Return                Future that receives deleted item
  /// Throw error.
  Future<T?> deleteById(IContext? context, K? id);
}
