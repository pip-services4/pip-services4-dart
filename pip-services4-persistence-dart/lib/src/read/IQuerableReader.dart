import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

/// Interface for data processing components that can query a list of data items.
abstract interface class IQuerableReader<T> {
  /// Gets a list of data items using a query string.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [query]             (optional) a query string
  /// - [sort]              (optional) sort parameters
  /// Return         Future that receives list of items
  /// Throws error.
  Future<List<T>> getListByQuery(
      IContext? context, String? query, SortParams? sort);
}
