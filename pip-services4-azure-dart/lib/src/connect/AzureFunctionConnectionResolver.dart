import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';

import 'AzureFunctionConnectionParams.dart';

/// Helper class to retrieve Azure connection and credential parameters,
/// validate them and compose a [AzureFunctionConnectionParams] value.
///
/// ### Configuration parameters ###
///
/// - [connections]:
///      - [uri]:           full connection uri with specific app and function name
///      - [protocol]:      connection protocol
///      - [app_name]:      alternative app name
///      - [function_name]: application function name
/// - [credentials]:
///      - [auth_code]:     authorization code or null if using custom auth
///
/// ### References ###
///
/// - *:discovery:\*:\*:1.0         (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connections
/// - *:credential-store:\*:\*:1.0  (optional) Credential stores to resolve credentials
///
/// See [ConnectionParams](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/ConnectionParams-class.html) (in the Pip.Services components package)
/// See [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) (in the Pip.Services components package)
///
/// ### Example ###
///
///     var config = ConfigParams.fromTuples([
///         'connection.uri', 'http://myapp.azurewebsites.net/api/myfunction',
///         'connection.app_name', 'myapp',
///         'connection.function_name', 'myfunction',
///         'credential.auth_code', 'XXXXXXXXXX',
///     ]);
///
///     var connectionResolver = AzureConnectionResolver();
///     connectionResolver.configure(config);
///     connectionResolver.setReferences(references);
///
///     final connectionParams = await connectionResolver.resolve(Context.fromTraceId('123'));
///         // Now use connection...

class AzureFunctionConnectionResolver implements IConfigurable, IReferenceable {
  /// The connection resolver.
  final connectionResolver = ConnectionResolver();

  /// The credential resolver.
  final credentialResolver = CredentialResolver();

  /// Configures component by passing configuration parameters.
  ///
  ///  -  [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    connectionResolver.configure(config);
    credentialResolver.configure(config);
  }

  /// Sets references to dependent components.
  ///
  ///  -  [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    connectionResolver.setReferences(references);
    credentialResolver.setReferences(references);
  }

  /// Resolves connection and credental parameters and generates a single
  /// AzureFunctionConnectionParams value.
  ///
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  Return 			Future that receives AzureFunctionConnectionParams value
  /// Throws error.
  ///
  /// See [connect.idiscovery.html IDiscovery] (in the Pip.Services components package)
  Future<AzureFunctionConnectionParams> resolve(IContext? context) async {
    var connection = AzureFunctionConnectionParams();
    //CredentialParams credential;
    connection.append(await connectionResolver.resolve(context));
    connection.append(await credentialResolver.lookup(context));

    // Perform validation
    await connection.validate(context);

    connection = composeConnection(connection);

    return connection;
  }

  AzureFunctionConnectionParams composeConnection(
      AzureFunctionConnectionParams connection) {
    connection = AzureFunctionConnectionParams.mergeConfigs([connection]);

    var uri = connection.getFunctionUri();

    if (uri == null || uri == '') {
      final protocol = connection.getProtocol();
      final appName = connection.getAppName();
      final functionName = connection.getFunctionName();
      // http://myapp.azurewebsites.net/api/myfunction
      uri = '$protocol://$appName.azurewebsites.net/api/$functionName';

      connection.setFunctionUri(uri);
    } else {
      final address = Uri.parse(uri);
      final protocol = address.scheme.replaceAll(':', '');
      final appName = address.host.replaceAll('.azurewebsites.net', '');
      final functionName = address.path.replaceAll('/api/', '');

      connection.setProtocol(protocol);
      connection.setAppName(appName);
      connection.setFunctionName(functionName);
    }

    return connection;
  }
}
