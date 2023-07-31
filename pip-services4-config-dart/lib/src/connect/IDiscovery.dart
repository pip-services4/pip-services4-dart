import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';

import '../../pip_services4_config.dart';

/// Interface for discovery services which are used to store and resolve connection parameters
/// to connect to external services.
///
/// See [ConnectionParams]
/// See [CredentialParams]
///
abstract interface class IDiscovery {
  /// Registers connection parameters into the discovery service.
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a key to uniquely identify the connection parameters.
  /// - [credential]        a connection to be registered.
  /// Return 			          Future that receives a registered connection
  /// Throw error.
  Future<ConnectionParams> register(
      IContext? context, String key, ConnectionParams connection);

  /// Resolves a single connection parameters by its key.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a key to uniquely identify the connection.
  /// Return          Future that receives found connection
  /// Throw error.
  Future<ConnectionParams?> resolveOne(IContext? context, String key);

  /// Resolves all connection parameters by their key.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a key to uniquely identify the connections.
  /// Return          Future that receives found connections
  /// Throw error.
  Future<List<ConnectionParams>> resolveAll(IContext? context, String key);
}
