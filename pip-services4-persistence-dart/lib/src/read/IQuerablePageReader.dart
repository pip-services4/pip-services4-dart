import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

/// Interface for data processing components that can query a page of data items.

abstract interface class IQuerablePageReader<T> {
  /// Gets a page of data items using a query string.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [query]             (optional) a query string
  /// - [paging]            (optional) paging parameters
  /// - [sort]              (optional) sort parameters
  /// Return          Future that receives list of items or error.

  Future<DataPage<T>> getPageByQuery(
      IContext? context, String? query, PagingParams? paging, SortParams? sort);
}
