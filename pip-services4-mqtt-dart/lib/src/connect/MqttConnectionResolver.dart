import 'dart:async';

import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';

///Helper class that resolves MQTT connection and credential parameters,
///validates them and generates connection options.
///
/// ### Configuration parameters ###
///
///- [connection(s)]:
///  - [discovery_key]:               (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///  - [host]:                        host name or IP address
///  - [port]:                        port number
///  - [uri]:                         resource URI or connection string with all parameters in it
///- [credential(s)]:
///  - [store_key]:                   (optional) a key to retrieve the credentials from [ICredentialStore](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/ICredentialStore-class.html)
///  - [username]:                    user name
///  - [password]:                    user password
///
///### References ###
///
///- *:discovery:*:*:1.0          (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connections
///- *:credential-store:*:*:1.0   (optional) Credential stores to resolve credentials

class MqttConnectionResolver implements IReferenceable, IConfigurable {
  ///The connections resolver.
  final connectionResolver = ConnectionResolver();

  ///The credentials resolver.
  final credentialResolver = CredentialResolver();

  ///Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    connectionResolver.configure(config);
    credentialResolver.configure(config);
  }

  ///Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
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
          'MQTT connection is not set');
    }

    var uri = connection.getUri();
    if (uri != null) return;

    var protocol = connection.getAsNullableString('protocol');
    if (protocol == null) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_PROTOCOL',
          'Connection protocol is not set');
    }

    var host = connection.getHost();
    if (host == null) {
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
      ConnectionParams connection, ConfigParams credential) {
    // Define additional parameters parameters
    var options = connection.override(credential);

    // Compose uri
    if (options.getAsNullableString('uri') == null) {
      var protocol = connection.getAsStringWithDefault('protocol', 'mqtt');
      var host = connection.getHost()!;
      var port = connection.getAsIntegerWithDefault('port', 1883);
      var uri = '$protocol://$host:$port';
      options.setAsObject('uri', uri);
    }

    return options;
  }

  ///Resolves MQTT connection options from connection and credential parameters.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return 			        Future that receives resolved options
  /// Throws error.
  Future<ConfigParams> resolve(IContext? context) async {
    var connection = await connectionResolver.resolve(context);
    // Validate connections
    _validateConnection(context, connection);

    var credential = await credentialResolver.lookup(context);
    // Credentials are not validated right now

    var options = _composeOptions(connection!, credential ?? ConfigParams());
    return options;
  }

  ///Composes MQTT connection options from connection and credential parameters.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [connection]        connection parameters
  /// - [credential]        credential parameters
  /// Returns              Future that receives resolved options.
  /// Throws error.
  Future<ConfigParams> compose(IContext? context, ConnectionParams connection,
      CredentialParams credential) async {
    // Validate connections
    _validateConnection(context, connection);
    return _composeOptions(connection, credential);
  }
}
