import 'dart:async';

import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for data processing components to update data items partially.
abstract interface class IPartialUpdater<T, K> {
  /// Updates only few selected fields in a data item.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [id]                an id of data item to be updated.
  /// - [data]              a map with fields to be updated.
  /// Return          Future that receives updated item
  /// Throw error.
  Future<T?> updatePartially(IContext? context, K id, AnyValueMap data);
}
