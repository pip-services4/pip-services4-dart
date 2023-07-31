import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';

import '../../pip_services4_logic.dart';

/// Dummy cache implementation that doesn't do anything.
///
/// It can be used in testing or in situations when cache is required
/// but shall be disabled.
///
/// See [ICache]

class NullCache implements ICache {
  /// Retrieves cached value from the cache using its key.
  /// If value is missing in the cache or expired it returns null.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique value key.
  /// Return          Future that receives cached value
  /// Throws error.
  @override
  Future<dynamic> retrieve(IContext? context, String key) async {}

  /// Stores value in the cache with expiration time.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique value key.
  /// - [value]             a value to store.
  /// - [timeout]           expiration timeout in milliseconds.
  /// Return              Future that receives an null for success
  /// Throws error
  @override
  Future<dynamic> store(
      IContext? context, String key, value, int timeout) async {
    return value;
  }

  /// Removes a value from the cache by its key.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique value key.
  /// Return              Future that receives an null for success
  /// Throws error
  @override
  Future<dynamic> remove(IContext? context, String key) async {
    return null;
  }
}
