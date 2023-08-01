import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

/// Interface for data processing components that can retrieve a page of data items by a filter.
abstract interface class IFilteredPageReader<T> {
  /// Gets a page of data items using filter parameters.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [filter]            (optional) filter parameters
  /// - [paging]            (optional) paging parameters
  /// - [sort]              (optional) sort parameters
  /// Return                Future that receives list of items
  /// Throw error.
  Future<DataPage<T>> getPageByFilter(IContext? context, FilterParams? filter,
      PagingParams? paging, SortParams? sort);
}
