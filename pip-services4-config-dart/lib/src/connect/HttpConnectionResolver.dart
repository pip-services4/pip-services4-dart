import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import '../connect/connect.dart';
import '../auth/auth.dart';

/// Helper class to retrieve connections for HTTP-based services abd clients.
///
/// In addition to regular functions of ConnectionResolver is able to parse http:// URIs
/// and validate connection parameters before returning them.
///
/// ### Configuration parameters ###
///
/// - connection:
///   - [discovery_key]: (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///   - ...                          other connection parameters
///
/// - connections:                   alternative to connection
///   - [connection params 1]:       first connection parameters
///   -  ...
///   - [connection params N]:       Nth connection parameters
///   -  ...
///
/// ### References ###
///
/// - \*:discovery:\*:\*:1.0           (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connections
///
/// See [ConnectionParams]
/// See [ConnectionResolver]
///
/// ### Example ###
///
///     var config = ConfigParams.fromTuples(
///          'connection.host', '10.1.1.100',
///          'connection.port', 8080
///     );
///
///     var connectionResolver = HttpConnectionResolver();
///     connectionResolver.configure(config);
///     connectionResolver.setReferences(references);
///
///     var connection = await connectionResolver.resolve('123');
///     // Now use connection...
class HttpConnectionResolver implements IReferenceable, IConfigurable {
  /// The base connection resolver.
  final ConnectionResolver _connectionResolver = ConnectionResolver();

  /// The base credential resolver.
  final CredentialResolver _credentialResolver = CredentialResolver();

  /// Configures component by passing configuration parameters.
  ///
  /// [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _connectionResolver.configure(config);
    _credentialResolver.configure(config);
  }

  /// Sets references to dependent components.
  ///
  /// [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    _connectionResolver.setReferences(references);
    _credentialResolver.setReferences(references);
  }

  void _validateConnection(IContext? context, ConnectionParams? connection,
      CredentialParams? credential) {
    if (connection == null) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_CONNECTION',
          'HTTP connection is not set');
    }

    final uri = connection.getUri();
    if (uri != null) return;

    final String protocol = connection.getProtocolWithDefault('http');
    if ('http' != protocol && 'https' != protocol) {
      throw ConfigException(
              context != null ? ContextResolver.getTraceId(context) : null,
              'WRONG_PROTOCOL',
              'Protocol is not supported by REST connection')
          .withDetails('protocol', protocol);
    }

    final host = connection.getHost();
    if (host == null) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_HOST',
          'Connection host is not set');
    }

    final port = connection.getPort();
    if (port == 0) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_PORT',
          'Connection port is not set');
    }

    // Check HTTPS credentials
    if (protocol == 'https') {
      // Check for credential
      if (credential == null) {
        throw ConfigException(
            context != null ? ContextResolver.getTraceId(context) : null,
            'NO_CREDENTIAL',
            'SSL certificates are not configured for HTTPS protocol');
      } else {
        // Sometimes when we use https we are on an internal network and do not want to have to deal with security.
        // When we need a https connection and we don't want to pass credentials, flag is 'credential.internal_network',
        // this flag just has to be present and non null for this functionality to work.
        if (credential.getAsNullableString('internal_network') == null) {
          if (credential.getAsNullableString('ssl_key_file') == null) {
            throw ConfigException(
                context != null ? ContextResolver.getTraceId(context) : null,
                'NO_SSL_KEY_FILE',
                'SSL key file is not configured in credentials');
          } else if (credential.getAsNullableString('ssl_crt_file') == null) {
            throw ConfigException(
                context != null ? ContextResolver.getTraceId(context) : null,
                'NO_SSL_CRT_FILE',
                'SSL crt file is not configured in credentials');
          }
        }
      }
    }
  }

  ConfigParams _composeConnection(
      List<ConnectionParams> connections, CredentialParams? credential) {
    var connection = ConfigParams.mergeConfigs(connections);

    var uri = connection.getAsString('uri');

    if (uri.isEmpty) {
      final protocol = connection.getAsStringWithDefault('protocol', 'http');
      final host = connection.getAsString('host');
      final port = connection.getAsInteger('port');

      uri = '$protocol://$host';
      if (port > 0) {
        uri += ':$port';
      }
      connection.setAsObject('uri', uri);
    } else {
      final address = Uri.parse(uri);
      final protocol = address.scheme.replaceFirst(':', '');

      connection.setAsObject('protocol', protocol);
      connection.setAsObject('host', address.host);
      connection.setAsObject('port', address.port);
    }

    if (connection.getAsString('protocol') == 'https' && credential != null) {
      if (credential.getAsNullableString('internal_network') == null) {
        connection = connection.override(credential);
      }
    }

    return connection;
  }

  /// Resolves a single component connection. If connections are configured to be retrieved
  /// from Discovery service it finds a IDiscovery and resolves the connection there.
  ///
  /// [context]     (optional) a context to trace execution through call chain.
  /// Return 			    a resolved connection options
  Future<ConfigParams> resolve(IContext? context) async {
    final connection = await _connectionResolver.resolve(context);
    final credential = await _credentialResolver.lookup(context);
    _validateConnection(context, connection, credential);
    return _composeConnection([connection!], credential);
  }

  /// Resolves all component connection. If connections are configured to be retrieved
  /// from Discovery service it finds a IDiscovery and resolves the connection there.
  ///
  /// [context]     (optional) a context to trace execution through call chain.
  /// Return 			    a resolved connection options
  Future<ConfigParams> resolveAll(IContext? context) async {
    var connections = await _connectionResolver.resolveAll(context);
    final credential = await _credentialResolver.lookup(context);

    connections = connections;
    for (final connection in connections) {
      _validateConnection(context, connection, credential);
    }

    return _composeConnection(connections, credential);
  }

  /// Registers the given connection in all referenced discovery services.
  /// This method can be used for dynamic service discovery.
  ///
  /// context     (optional) a context to trace execution through call chain.
  /// connection        a connection to register.
  Future<void> register(IContext context) async {
    final connection = await _connectionResolver.resolve(context);
    final credential = await _credentialResolver.lookup(context);

    // Validate connection
    _validateConnection(context, connection, credential);

    await _connectionResolver.register(context, connection!);
  }
}
