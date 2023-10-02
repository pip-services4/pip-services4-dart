import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

import 'AzureFunctionClient.dart';
import '../container/AzureFunction.dart';

/// Abstract client that calls commandable Azure Functions.
///
/// Commandable services are generated automatically for [ICommandable](https://pub.dev/documentation/pip_services4_rpc/latest/pip_services4_rpc/ICommandable-class.html).
/// Each command is exposed as action determined by "cmd" parameter.
///
/// ### Configuration parameters ###
///
/// - [connections]:
///     - [uri]:                         (optional) full connection string or use protocol, app_name and function_name to build
///     - [protocol]:                    (optional) connection protocol
///     - [app_name]:                    (optional) Azure Function application name
///     - [function_name]:               (optional) Azure Function name
/// - options:
///      - [retries]:               number of retries (default: 3)
///      - [connect_timeout]:       connection timeout in milliseconds (default: 10 sec)
///      - [timeout]:               invocation timeout in milliseconds (default: 10 sec)
/// - [credentials]:
///     - [auth_code]:                   Azure Function auth code if use custom authorization provide empty string
///
/// ### References ###
///
/// - *:logger:\*:\*:1.0            (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - *:counters:\*:\*:1.0          (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
/// - *:discovery:\*:\*:1.0         (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection
/// - *:credential-store:\*:\*:1.0  (optional) Credential stores to resolve credentials
///
/// See [AzureFunction]
///
/// ### Example ###
///
///     class MyAzureFunctionClient extends CommandableAzureFunctionClient implements IMyClient {
///         ...
///
///         Future<MyData> getData(IContext? context, id: string) async {
///             var result = await callCommand(
///                 "get_data",
///                 context,
///                 { id: id }
///             );
///         }
///         ...
///     }
///
///     var client = new MyAzureFunctionClient();
///     client.configure(ConfigParams.fromTuples([
///        "connection.uri", "http://myapp.azurewebsites.net/api/myfunction",
///        "connection.protocol", "http",
///        "connection.app_name", "myapp",
///        "connection.function_name", "myfunction"
///        "credential.auth_code", "XXXX"
///     ]));
///
///     var data = client.getData(Context.fromTraceId('123'), '1');

class CommandableAzureFunctionClient extends AzureFunctionClient {
  String? _name;

  /// Creates a new instance of this client.
  ///
  ///  -  name a service name.

  CommandableAzureFunctionClient(String name) : super() {
    _name = name;
  }

  /// Calls a remote action in Azure Function.
  /// The name of the action is added as "cmd" parameter
  /// to the action parameters.
  ///
  ///  -  [cmd]               an action name
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  -  [params]            command parameters.
  ///  Return          Future that receives result
  /// Throws  error.

  Future callCommand(String cmd, IContext? context, params) async {
    var timing = instrument(context, '$_name.$cmd');
    try {
      final result = await call(cmd, context, params);
      timing.endTiming();
      return result;
    } catch (ex) {
      timing.endFailure(ex as Exception);
      return ex;
    }
  }
}
