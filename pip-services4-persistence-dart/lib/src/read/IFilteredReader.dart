import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

/// Interface for data processing components that can retrieve a list of data items by filter.
abstract interface class IFilteredReader<T> {
  /// Gets a list of data items using filter parameters.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [filter]            (optional) filter parameters
  /// - [sort]              (optional) sort parameters
  /// Return                Future that receives list of items
  /// Throw error.
  Future<List<T>> getListByFilter(
      IContext? context, FilterParams? filter, SortParams? sort);
}
