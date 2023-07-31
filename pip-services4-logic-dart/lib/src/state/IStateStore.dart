import 'package:pip_services4_components/pip_services4_components.dart';

import 'StateValue.dart';

/// Interface for state storages that are used to store and retrieve transaction states.
abstract interface class IStateStore {
  /// Loads state from the store using its key.
  /// If value is missing in the store it returns null.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key] a unique state key.
  /// Returns the state value or <code>null</code> if value wasn't found.
  Future<T?> load<T>(IContext? context, String key);

  /// Loads an array of states from the store using their keys.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [keys] unique state keys.
  /// Returns an array with state values and their corresponding keys.
  Future<List<StateValue<T>>> loadBulk<T>(IContext? context, List<String> keys);

  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]           a unique state key.
  /// - [value]         a state value.
  /// Return The state that was stored in the store.
  Future<T> save<T>(IContext? context, String key, value);

  /// Deletes a state from the store by its key.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key] a unique value key.
  Future<T?> delete<T>(IContext? context, String key);
}
