import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';

import './RestClient.dart';

/// Abstract client that calls commandable HTTP service.
///
/// Commandable services are generated automatically for [ICommandable objects](https://pub.dev/documentation/pip_services4_rpc/latest/pip_services4_rpc/ICommandable-class.html).
/// Each command is exposed as POST operation that receives all parameters
/// in body object.
///
/// ### Configuration parameters ###
///
/// [base_route]:              base route for remote URI
///
/// - [connection](s):
///   - [discovery_key]:         (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///   - [protocol]:              connection protocol: http or https
///   - [host]:                  host name or IP address
///   - [port]:                  port number
///   - [uri]:                   resource URI or connection string with all parameters in it
/// - [options]:
///   - [retries]:               number of retries (default: 3)
///   - [connect_timeout]:       connection timeout in milliseconds (default: 10 sec)
///   - [timeout]:               invocation timeout in milliseconds (default: 10 sec)
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0         (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - \*:counters:\*:\*:1.0         (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
/// - \*:tracer:\*:\*:1.0         (optional) [ITracer](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ITracer-class.html) components to record traces
/// - \*:discovery:\*:\*:1.0        (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection
///
/// ### Example ###
///
///     class MyCommandableHttpClient extends CommandableHttpClient implements IMyClient {
///        ...
///
///        Future<MyData> getData(IContext? context, String id) async {
///            var result = await callCommand(
///                "get_data",
///                context,
///                { 'id': id });
///           if (result == null) return null;
///           return MyData.fromJson(json.decode(result));
///         }
///         ...
///     }
///
///     var client = MyCommandableHttpClient();
///     client.configure(ConfigParams.fromTuples([
///         "connection.protocol", "http",
///         "connection.host", "localhost",
///         "connection.port", 8080
///     ]));
///
///     var result = await client.getData("123", "1")
///     ...

class CommandableHttpClient extends RestClient {
  /// Creates a new instance of the client.
  ///
  /// - [baseRoute]     a base route for remote service.
  CommandableHttpClient(String baseRoute) : super() {
    this.baseRoute = baseRoute;
  }

  /// Calls a remote method via HTTP commadable protocol.
  /// The call is made via POST operation and all parameters are sent in body object.
  /// The complete route to remote method is defined as baseRoute + "/" + name.
  ///
  /// - [name]              a name of the command to call.
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [params]            command parameters.
  /// Return          Future that receives result or error.

  Future callCommand(String name, IContext? context, params) async {
    var timing = instrument(context, '${baseRoute ?? ''}.$name');

    try {
      var response = await call('post', name, context, {}, params ?? {});
      timing.endTiming();
      return response;
    } catch (err) {
      timing.endTiming();
      instrumentError(context, '${baseRoute ?? ''}.$name', err, true);
    }
  }
}
