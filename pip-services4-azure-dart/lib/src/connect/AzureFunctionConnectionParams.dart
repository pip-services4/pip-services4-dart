import 'dart:async';

import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';
import 'AzureFunctionConnectionResolver.dart';

/// Contains connection parameters to authenticate against Azure Functions
/// and connect to specific Azure Function.
///
/// The class is able to compose and parse Azure Function connection parameters.
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
/// In addition to standard parameters [CredentialParams](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/CredentialParams-class.html) may contain any number of custom parameters
///
/// See [AzureFunctionConnectionResolver]
///
/// ### Example ###
///
///     var connection = AzureConnectionParams.fromTuples([
///         'connection.uri', 'http://myapp.azurewebsites.net/api/myfunction',
///         'connection.protocol', 'http',
///         'connection.app_name', 'myapp',
///         'connection.function_name', 'myfunction',
///         'connection.auth_code', 'code',
///     ]);
///
///     final uri = connection.getFunctionUri();             // Result: 'http://myapp.azurewebsites.net/api/myfunction'
///     final protocol = connection.getAppName();            // Result: 'http'
///     final appName = connection.getAppName();             // Result: 'myapp'
///     final functionName = connection.getFunctionName();   // Result: 'myfunction'
///     final authCode = connection.getAuthCode();           // Result: 'code'

class AzureFunctionConnectionParams extends ConfigParams {
  /// Creates an new instance of the connection parameters.
  ///
  ///  -  [values] 	(optional) an object to be converted into key-value pairs to initialize this connection.
  AzureFunctionConnectionParams([values]) : super(values);

  /// Gets the Azure function connection protocol.
  ///
  /// Returns the Azure function connection protocol.
  String? getProtocol() {
    return super.getAsNullableString('protocol');
  }

  /// Sets the Azure function connection protocol.
  ///
  /// - [value] -  a new Azure function connection protocol.
  void setProtocol(String value) {
    super.put('protocol', value);
  }

  /// Gets the Azure function uri.
  ///
  /// Returns  the Azure function uri.
  String? getFunctionUri() {
    return super.getAsNullableString('uri');
  }

  /// Sets the Azure function uri.
  ///
  /// - [value] a new Azure function uri.
  void setFunctionUri(String value) {
    super.put('uri', value);
  }

  /// Gets the Azure app name.
  ///
  /// Returns the Azure app name.
  String? getAppName() {
    return super.getAsNullableString('app_name');
  }

  /// Sets the Azure app name.
  ///
  /// - [value] a new Azure app name.
  void setAppName(String value) {
    super.put('app_name', value);
  }

  /// Gets the Azure function name.
  ///
  /// Returns the Azure function name.
  String? getFunctionName() {
    return super.getAsNullableString('function_name');
  }

  /// Sets the Azure function name.
  ///
  /// - [value] a new Azure function name.
  void setFunctionName(String value) {
    super.put('function_name', value);
  }

  /// Gets the Azure auth code.
  ///
  /// Returns the Azure auth code.
  String? getAuthCode() {
    return super.getAsNullableString('auth_code');
  }

  /// Sets the Azure auth code.
  ///
  /// - [value] a new Azure auth code.
  void setAuthCode(String value) {
    super.put('auth_code', value);
  }

  /// Creates a new AzureFunctionConnectionParams object filled with key-value pairs serialized as a string.
  ///
  ///  -  [line] 		a string with serialized key-value pairs as 'key1=value1;key2=value2;...'
  /// 					Example: 'Key1=123;Key2=ABC;Key3=2016-09-16T00:00:00.00Z'
  /// Returns			a new AzureFunctionConnectionParams object.
  static AzureFunctionConnectionParams fromString(String line) {
    var map = StringValueMap.fromString(line);
    return AzureFunctionConnectionParams(map);
  }

  /// Validates this connection parameters
  ///
  ///  -  context     (optional) transaction id to trace execution through call chain.
  /// Returns   Future that return null if validation passed successfully.
  /// Throws ConfigException
  Future validate(IContext? context) async {
    final uri = getFunctionUri();
    final protocol = getProtocol();
    final appName = getAppName();
    final functionName = getFunctionName();

    if (uri == null &&
        (appName == null || functionName == null || protocol == null)) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_CONNECTION_URI',
          'No uri, app_name and function_name is configured in Auzre function uri');
    }

    if (protocol != null && 'http' != protocol && 'https' != protocol) {
      throw ConfigException(
              context != null ? ContextResolver.getTraceId(context) : null,
              'WRONG_PROTOCOL',
              'Protocol is not supported by REST connection')
          .withDetails('protocol', protocol);
    }
  }

  /// Retrieves AzureFunctionConnectionParams from configuration parameters.
  /// The values are retrieves from 'connection' and 'credential' sections.
  ///
  ///  -  [config] 	configuration parameters
  /// Returns			the generated AzureFunctionConnectionParams object.
  ///
  /// See [mergeConfigs]
  static AzureFunctionConnectionParams fromConfig(ConfigParams config) {
    var result = AzureFunctionConnectionParams();

    var credentials = CredentialParams.manyFromConfig(config);
    for (var credential in credentials) {
      result.append(credential);
    }

    var connections = ConnectionParams.manyFromConfig(config);
    for (var connection in connections) {
      result.append(connection);
    }

    return result;
  }

  /// Retrieves AzureFunctionConnectionParams from multiple configuration parameters.
  /// The values are retrieves from 'connection' and 'credential' sections.
  ///
  ///  -  [configs] 	a list with configuration parameters
  /// Returns			the generated AzureFunctionConnectionParams object.
  ///
  /// See [fromConfig]

  static AzureFunctionConnectionParams mergeConfigs(
      List<ConfigParams> configs) {
    var config = ConfigParams.mergeConfigs(configs);
    return AzureFunctionConnectionParams(config);
  }

  /// Creates a new ConfigParams object filled with provided key-value pairs called tuples.
  /// Tuples parameters contain a sequence of key1, value1, key2, value2, ... pairs.
  ///
  /// - [tuples]	the tuples to fill a new ConfigParams object.
  /// Returns			a new ConfigParams object.
  ///
  /// See [ConfigParams.fromTuples]
  static AzureFunctionConnectionParams fromTuples(List tuples) {
    final config = ConfigParams.fromTuples(tuples);
    return AzureFunctionConnectionParams(config);
  }
}
