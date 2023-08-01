import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for data processing components that save data items.
abstract interface class ISaver<T> {
  /// Saves given data items.
  ///
  /// - [context]    (optional) a context to trace execution through call chain.
  /// - [items]              a list of items to save.
  /// Return         (optional) Future that receives null for success.
  /// Throw error
  Future save(IContext? context, List<T> items);
}
