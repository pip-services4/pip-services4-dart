import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for caches that are used to cache values to improve performance.

abstract interface class ICache {
  /// Retrieves cached value from the cache using its key.
  /// If value is missing in the cache or expired it returns null.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique value key.
  /// Return                Future that receives cached value
  /// Throws  error.
  Future<dynamic> retrieve(IContext? context, String key);

  /// Stores value in the cache with expiration time.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique value key.
  /// - [value]             a value to store.
  /// - [timeout]           expiration timeout in milliseconds.
  /// Return                Future that receives an null for success
  /// Throws error
  Future<dynamic> store(IContext? context, String key, value, int timeout);

  /// Removes a value from the cache by its key.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique value key.
  /// Return                Future that receives an null for success
  /// Throws error
  Future<dynamic> remove(IContext? context, String key);
}
