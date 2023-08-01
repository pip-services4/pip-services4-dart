import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for data processing components that can set (create or update) data items.
abstract interface class ISetter<T> {
  /// Sets a data item. If the data item exists it updates it,
  /// otherwise it create a new data item.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [item]              a item to be set.
  /// Return         (optional) Future that receives updated item
  /// Throw error.
  Future<T?> set(IContext? context, T? item);
}
