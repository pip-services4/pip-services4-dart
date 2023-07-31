import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for locks to synchronize work or parallel processes and to prevent collisions.
///
/// The lock allows to manage multiple locks identified by unique keys.

abstract interface class ILock {
  /// Makes a single attempt to acquire a lock by its key.
  /// It returns immediately a positive or negative result.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique lock key to acquire.
  /// - [ttl]               a lock timeout (time to live) in milliseconds.
  /// Return          Future  that receives a lock result
  /// Throws  error.
  Future<bool> tryAcquireLock(IContext? context, String key, int ttl);

  /// Makes multiple attempts to acquire a lock by its key within give time interval.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique lock key to acquire.
  /// - [ttl]               a lock timeout (time to live) in milliseconds.
  /// - [timeout]           a lock acquisition timeout.
  /// Return                Future  that receives  null for success.
  /// Throws error
  Future acquireLock(IContext? context, String key, int ttl, int timeout);

  /// Releases prevously acquired lock by its key.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique lock key to release.
  /// Return          Future  that receives error or null for success.
  Future releaseLock(IContext? context, String key);
}
