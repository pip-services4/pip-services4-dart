import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';

import '../connect/AzureFunctionConnectionParams.dart';
import '../connect/AzureFunctionConnectionResolver.dart';
import '../container/AzureFunction.dart';
import 'CommandableAzureFunctionClient.dart';

/// Abstract client that calls Azure Functions.
///
/// When making calls 'cmd' parameter determines which what action shall be called, while
/// other parameters are passed to the action itself.
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
/// See [CommandableAzureFunctionClient]
///
/// ### Example ###
///
///     class MyAzureFunctionClient extends AzureFunctionClient implements IMyClient {
///         ...
///
///         Future<MyData> getData(IContext? context, String id) async {
///             var timing = this.instrument(context, 'myclient.get_data');
///             var result = await call('get_data', context, { id: id });
///             timing.endTiming();
///             return result;
///         }
///         ...
///     }
///
///     var client = MyAzureFunctionClient();
///     client.configure(ConfigParams.fromTuples([
///        "connection.uri", "http://myapp.azurewebsites.net/api/myfunction",
///        "connection.protocol", "http",
///        "connection.app_name", "myapp",
///        "connection.function_name", "myfunction"
///        "credential.auth_code", "XXXX"
///     ]));
///
///     var data = client.getData(Context.fromTraceId('123'), '1');
///     ...

abstract class AzureFunctionClient
    implements IOpenable, IConfigurable, IReferenceable {
  /// The HTTP client
  http.Client? client;

  /// The opened flag.
  bool opened = false;

  var _retries = 3;

  /// The default headers to be added to every request.
  var headers = <String, String>{};

  /// The remote controller uri which is calculated on open.
  String? uri;

  /// The Azure function connection parameters
  AzureFunctionConnectionParams? connection;
  var _connectTimeout = 10000;

  /// The invocation timeout in milliseconds.
  var _timeout = 10000;

  /// The dependencies resolver.
  final dependencyResolver = DependencyResolver();

  /// The connection resolver.
  final connectionResolver = AzureFunctionConnectionResolver();

  /// The logger.
  final logger = CompositeLogger();

  /// The performance counters.
  final counters = CompositeCounters();

  final tracer = CompositeTracer();

  /// Configures component by passing configuration parameters.
  ///
  ///  -  [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    connectionResolver.configure(config);
    dependencyResolver.configure(config);

    _connectTimeout = config.getAsIntegerWithDefault(
        'options.connect_timeout', _connectTimeout);
    _retries = config.getAsIntegerWithDefault('options.retries', _retries);
    _timeout = config.getAsIntegerWithDefault('options.timeout', _timeout);
  }

  /// Sets references to dependent components.
  ///
  ///  -  [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    logger.setReferences(references);
    counters.setReferences(references);
    connectionResolver.setReferences(references);
    dependencyResolver.setReferences(references);
  }

  /// Adds instrumentation to log calls and measure call time.
  /// It returns a InstrumentTiming object that is used to end the time measurement.
  ///
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  -  [name]              a method name.
  /// Returns InstrumentTiming object to end the time measurement.
  InstrumentTiming instrument(IContext? context, String name) {
    logger.trace(context, "Executing %s method", [name]);
    counters.incrementOne("$name.exec_count");

    final counterTiming = counters.beginTiming("$name.exec_time");
    final traceTiming = tracer.beginTrace(context, name, '');
    return InstrumentTiming(
        context, name, "exec", logger, counters, counterTiming, traceTiming);
  }

  /// Checks if the component is opened.
  ///
  /// Returns true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return client != null;
  }

  /// Opens the component.
  ///
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  Return 			Future that receives  null no errors occured.
  /// Throws error
  @override
  Future open(IContext? context) async {
    if (isOpen()) {
      return;
    }

    connection = await connectionResolver.resolve(context);
    headers['x-functions-key'] = connection!.getAuthCode()!;
    uri = connection?.getFunctionUri();
    try {
      client = http.Client();
      logger.debug(context, 'Azure Function client connected to %s',
          [connection?.getFunctionUri()]);
    } catch (ex) {
      client = null;
      logger.error(context, ApplicationException().wrap(ex),
          'Error while open Azure Function client');
      return ex;
    }
  }

  /// Closes component and frees used resources.
  ///
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  Return 			Future that receives error or null no errors occured.
  @override
  Future close(IContext? context) async {
    if (!isOpen()) {
      return;
    }
    if (client != null) {
      // Eat exceptions
      try {
        client!.close();
        logger.debug(context, 'Closed Azure Function client at %s', [uri]);
      } catch (ex) {
        logger.warn(
            context, 'Failed while closing Azure Function client: %s', [ex]);
      }

      client = null;
      uri = null;
    }
  }

  /// Performs Azure Function invocation.
  ///
  ///  -  [invocationType]    an invocation type: 'RequestResponse' or 'Event'
  ///  -  [cmd]               an action name to be called.
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  -  [args]              action arguments
  ///  Return          Future that receives action result
  /// Throws error.
  Future invoke(String? cmd, IContext? context, Map args) async {
    if (cmd == null || cmd.isEmpty) {
      var err = UnknownException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_COMMAND',
          'Missing Seneca pattern cmd');
      logger.error(context, err, 'Failed to call %s', [cmd]);
      throw err;
    }

    var cloneArgs = Map.from(args);
    cloneArgs['cmd'] = cmd;
    cloneArgs['trace_id'] = context != null
        ? ContextResolver.getTraceId(context)
        : IdGenerator.nextShort();
    headers['Content-Type'] = 'application/json';
    http.Response? response;

    try {
      response = await client!.post(Uri.parse(uri!),
          headers: headers, body: json.encode(cloneArgs));

      // ignore: unnecessary_null_comparison
      if (response == null) {
        throw ApplicationExceptionFactory.create(ErrorDescriptionFactory.create(
            UnknownException(
                context != null ? ContextResolver.getTraceId(context) : null,
                'Unable to get a result from uri $uri')));
      }

      if (response.statusCode == 204) {
        return null;
      }

      return response.body;
    } catch (err) {
      logger.error(context, InvocationException().wrap(err),
          'Failed to invoke AzureFunction function');

      throw InvocationException(
              context != null ? ContextResolver.getTraceId(context) : null,
              'CALL_FAILED',
              'Failed to invoke AzureFunction function')
          .withCause(err);
    }
  }

  /// Calls a Azure Function action.
  ///
  ///  -  [cmd]               an action name to be called.
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  -  [params]            (optional) action parameters.
  ///  Returns               Future that receives result object
  /// Throws error.
  Future call(String cmd, IContext? context, params) {
    return invoke(cmd, context, params);
  }
}
