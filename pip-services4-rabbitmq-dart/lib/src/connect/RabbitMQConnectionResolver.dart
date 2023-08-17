import 'dart:async';

import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';

/// RabbitMQConnectionResolver helper class that resolves RabbitMQ connection and credential parameters,
/// validates them and generates connection options.
///   Configuration parameters:
/// - [connection(s)]:
///   - [discovery_key]:               (optional) a key to retrieve the connection from IDiscovery
///   - [host]:                        host name or IP address
///   - [port]:                        port number
///   - [uri]:                         resource URI or connection string with all parameters in it
/// - [credential(s)]:
///   - [store_key]:                   (optional) a key to retrieve the credentials from ICredentialStore
///   - [username]:                    user name
///   - [password]:                    user password
///  References:
/// - *:discovery:*:*:1.0          (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connections
/// - *:credential-store:*:*:1.0   (optional) Credential stores to resolve credentials [ICredentialStore](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/ICredentialStore-class.html)

class RabbitMQConnectionResolver implements IReferenceable, IConfigurable {
  // The connections resolver.
  ConnectionResolver connectionResolver;
  //The credentials resolver.
  CredentialResolver credentialResolver;

  RabbitMQConnectionResolver()
      : connectionResolver = ConnectionResolver(),
        credentialResolver = CredentialResolver();

  /// Configure are configures component by passing configuration parameters.
  /// Parameters:
  /// - [config]  configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    connectionResolver.configure(config);
    credentialResolver.configure(config);
  }

  /// SetReferences are sets references to dependent components.
  /// Parameters:
  /// - [references]  references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    connectionResolver.setReferences(references);
    credentialResolver.setReferences(references);
  }

  void _validateConnection(IContext? context, ConnectionParams? connection) {
    if (connection == null) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_CONNECTION',
          'RabbitMQ connection is not set');
    }

    var uri = connection.getUri();
    if (uri != null && uri.isNotEmpty) {
      return;
    }

    var protocol = connection.getAsNullableString('protocol');
    if (protocol == null || protocol.isEmpty) {
      //return cerr.NewConfigError(context, 'NO_PROTOCOL', 'Connection protocol is not set')
      connection.setAsObject('protocol', 'amqp');
    }

    var host = connection.getHost();
    if (host == null || host.isEmpty) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_HOST',
          'Connection host is not set');
    }

    var port = connection.getPort();
    if (port == 0) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_PORT',
          'Connection port is not set');
    }
  }

  ConfigParams _composeOptions(
      ConnectionParams? connection, CredentialParams? credential) {
    // Define additional parameters parameters
    credential ??= CredentialParams();

    var options = connection!.override(credential);

    // Compose uri
    if (options.get('uri') == null) {
      var credential = '';
      if (options.get('username') != null) {
        credential = options.get('username')!;
      }
      if (options.get('password') != null) {
        credential += ':${options.get('password')!}';
      }
      var uri = '';
      if (credential.isEmpty) {
        uri = '${options.get('protocol')!}://${options.get('host')!}';
      } else {
        uri =
            '${options.get('protocol')!}://$credential@${options.get('host')!}';
      }
      if (options.get('port') != null) {
        uri = '$uri:${options.get('port')!}';
      }
      options.setAsObject('uri', uri);
    }
    return options;
  }

  /// Resolves RabbitMQ connection options from connection and credential parameters.
  /// Parameters:
  ///  - [context]     (optional) a context to trace execution through call chain.
  /// Retruns               Future that receives resolved options
  /// Throw error.
  Future<ConfigParams> resolve(IContext? context) async {
    ConnectionParams? connection;
    CredentialParams? credential;
    dynamic err;

    await Future.wait([
      () async {
        try {
          connection = await connectionResolver.resolve(context);
          //Validate connections
          _validateConnection(context, connection);
        } catch (ex) {
          err = ex;
        }
      }(),
      () async {
        try {
          credential = await credentialResolver.lookup(context);
          // Credentials are not validated right now
        } catch (ex) {
          err = ex;
        }
      }()
    ]);

    if (err != null) {
      throw err;
    }
    return _composeOptions(connection, credential);
  }

  /// Compose method are composes RabbitMQ connection options from connection and credential parameters.
  /// Parameters:
  ///    - [context]     (optional) a context to trace execution through call chain.
  ///    - [connection]    connection parameters
  ///    - [credential]     credential parameters
  /// Returns               Future that receives resolved options
  /// Throw error.
  Future<ConfigParams> compose(IContext? context, ConnectionParams? connection,
      CredentialParams? credential) async {
    // Validate connections
    _validateConnection(context, connection);
    return _composeOptions(connection, credential);
  }
}
