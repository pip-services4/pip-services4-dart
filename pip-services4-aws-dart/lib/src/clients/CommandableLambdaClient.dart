import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

import './LambdaClient.dart';
import '../container/LambdaFunction.dart';

/// Abstract client that calls commandable AWS Lambda Functions.
///
/// Commandable services are generated automatically for [ICommandable](https://pub.dev/documentation/pip_services4_rpc/latest/pip_services4_rpc/ICommandable-class.html).
/// Each command is exposed as action determined by "cmd" parameter.
///
/// ### Configuration parameters ###
///
/// - [connections]:
///     - [discovery_key]:               (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///     - [region]:                      (optional) AWS region
/// - [credentials]:
///     - [store_key]:                   (optional) a key to retrieve the credentials from [ICredentialStore](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/ICredentialStore-class.html)
///     - [access_id]:                   AWS access/client id
///     - [access_key]:                  AWS access/client id
/// - [options]:
///     - [connect_timeout]:             (optional) connection timeout in milliseconds (default: 10 sec)
///
/// ### References ###
///
/// - *:logger:\*:\*:1.0            (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - *:counters:\*:\*:1.0          (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
/// - *:discovery:\*:\*:1.0         (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection
/// - *:credential-store:\*:\*:1.0  (optional) Credential stores to resolve credentials
///
/// See [LambdaFunction]
///
/// ### Example ###
///
///     class MyLambdaClient extends CommandableLambdaClient implements IMyClient {
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
///     var client = new MyLambdaClient();
///     client.configure(ConfigParams.fromTuples([
///         "connection.region", "us-east-1",
///         "connection.access_id", "XXXXXXXXXXX",
///         "connection.access_key", "XXXXXXXXXXX",
///         "connection.arn", "YYYYYYYYYYYYY"
///     ]));
///
///     var data = client.getData(Context.fromTraceId('123'), '1');

class CommandableLambdaClient extends LambdaClient {
  String? _name;

  /// Creates a new instance of this client.
  ///
  ///  -  name a service name.

  CommandableLambdaClient(String name) : super() {
    _name = name;
  }

  /// Calls a remote action in AWS Lambda function.
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
    dynamic result;
    try {
      result = await call(cmd, context, params);
    } catch (err) {
      rethrow;
    } finally {
      timing.endTiming();
    }
    return result;
  }
}
