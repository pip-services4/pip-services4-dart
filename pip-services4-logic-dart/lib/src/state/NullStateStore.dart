import 'package:pip_services4_components/pip_services4_components.dart';

import 'state.dart';

/// Dummy state store implementation that doesn't do anything.
///
/// It can be used in testing or in situations when state management is not required
/// but shall be disabled.
///
/// See [ICache]
class NullStateStore implements IStateStore {
  /// Loads state from the store using its key.
  /// If value is missing in the stored it returns null.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key] a unique state key.
  /// Returns the state value or <code>null</code> if value wasn't found.
  @override
  Future<T?> load<T>(IContext? context, String key) async {
    return null;
  }

  /// Loads an array of states from the store using their keys.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [keys] unique state keys.
  /// Returns an array with state values and their corresponding keys.
  ///
  @override
  Future<List<StateValue<T>>> loadBulk<T>(
      IContext? context, List<String> keys) async {
    return [];
  }

  /// Saves state into the store.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key] a unique state key.
  /// - [value] a state value.
  /// @returns The state that was stored in the store.
  @override
  Future<T> save<T>(IContext? context, String key, value) {
    return value;
  }

  /// Deletes a state from the store by its key.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key] a unique value key.
  ///
  @override
  Future<T?> delete<T>(IContext? context, String key) async {
    return null;
  }
}
