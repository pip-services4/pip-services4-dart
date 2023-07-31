import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';

import '../../pip_services4_config.dart';

/// Interface for credential stores which are used to store and lookup credentials
/// to authenticate against external services.
///
/// See [CredentialParams]
/// See [ConnectionParams]
abstract interface class ICredentialStore {
  /// Stores credential parameters into the store.
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a key to uniquely identify the credential.
  /// - [credential]        a credential to be stored.
  /// Return 			        Future that receives an null for success.
  /// Throw error
  Future store(IContext? context, String key, CredentialParams credential);

  /// Lookups credential parameters by its key.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a key to uniquely identify the credential.
  /// Return              Future that receives found credential
  /// Throw  error.
  Future<CredentialParams?> lookup(IContext? context, String? key);
}
