import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aws_client/lambda_2015_03_31.dart';
import 'package:http_client/console.dart';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';

import '../connect/AwsConnectionParams.dart';
import '../connect/AwsConnectionResolver.dart';
import '../container/LambdaFunction.dart';
import 'CommandableLambdaClient.dart';

/// Abstract client that calls AWS Lambda Functions.
///
/// When making calls 'cmd' parameter determines which what action shall be called, while
/// other parameters are passed to the action itself.
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
/// See [CommandableLambdaClient]
///
/// ### Example ###
///
///     class MyLambdaClient extends LambdaClient implements IMyClient {
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
///     var client = MyLambdaClient();
///     client.configure(ConfigParams.fromTuples([
///         'connection.region', 'us-east-1',
///         'connection.access_id', 'XXXXXXXXXXX',
///         'connection.access_key', 'XXXXXXXXXXX',
///         'connection.arn', 'YYYYYYYYYYYYY'
///     ]));
///
///     var data = client.getData(Context.fromTraceId('123'), '1');
///     ...

abstract class LambdaClient
    implements IOpenable, IConfigurable, IReferenceable {
  /// The reference to AWS Lambda Function.
  Lambda? lambda;

  Client? _httpClient;
  //Aws _aws;

  /// The opened flag.
  bool opened = false;

  /// The AWS connection parameters
  AwsConnectionParams? connection;
  var _connectTimeout = 10000;

  /// The dependencies resolver.
  final dependencyResolver = DependencyResolver();

  /// The connection resolver.
  final connectionResolver = AwsConnectionResolver();

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
    return opened;
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

    //final Client httpClient = ConsoleClient(idleTimeout: Duration(milliseconds: _connectTimeout));
    _httpClient = ConsoleClient();
    final credentials = AwsClientCredentials(
        accessKey: connection!.getAccessId() ?? '',
        secretKey: connection!.getAccessKey() ?? '');
    //
    try {
      //_aws = Aws(credentials: credentials, httpClient: _httpClient);
      //lambda = _aws.lambda(connection.getRegion());
      lambda = Lambda(
          region: connection!.getRegion() ?? '', credentials: credentials);

      opened = true;
      logger.debug(
          context, 'Lambda client connected to %s', [connection?.getArn()]);
    } catch (ex) {
      logger.error(context, ApplicationException().wrap(ex),
          'Error while open AWS client');
      await _httpClient?.close();
      return ex;
    }
  }

  /// Closes component and frees used resources.
  ///
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  Return 			Future that receives error or null no errors occured.
  @override
  Future close(IContext? context) async {
    if (_httpClient != null) {
      await _httpClient?.close();
    }
    opened = false;
  }

  /// Performs AWS Lambda Function invocation.
  ///
  ///  -  [invocationType]    an invocation type: 'RequestResponse' or 'Event'
  ///  -  [cmd]               an action name to be called.
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  -  [args]              action arguments
  ///  Return          Future that receives action result
  /// Throws error.

  Future invoke(InvocationType invocationType, String? cmd, IContext? context,
      Map args) async {
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

    // var headers = {'X-Amz-Log-Type': 'None'};

    try {
      var data = await lambda?.invoke(
          functionName: connection!.getArn(),
          invocationType: invocationType,
          logType: LogType.none,
          payload: Uint8List.fromList(json.encode(cloneArgs).codeUnits));

      var result = data?.payload; //readAsBytes();

      try {
        result = json.decode(String.fromCharCodes(result ?? []));
      } catch (err) {
        throw InvocationException(
                context != null ? ContextResolver.getTraceId(context) : null,
                'DESERIALIZATION_FAILED',
                'Failed to deserialize result')
            .withCause(err);
      }

      return result;
    } catch (err) {
      logger.error(context, InvocationException().wrap(err),
          'Failed to invoke lambda function');

      throw InvocationException(
              context != null ? ContextResolver.getTraceId(context) : null,
              'CALL_FAILED',
              'Failed to invoke lambda function')
          .withCause(err);
    }
  }

  /// Calls a AWS Lambda Function action.
  ///
  ///  -  [cmd]               an action name to be called.
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  -  [params]            (optional) action parameters.
  ///  Returns               Future that receives result object
  /// Throws error.

  Future call(String cmd, IContext? context, params) {
    return invoke(InvocationType.requestResponse, cmd, context, params);
  }

  /// Calls a AWS Lambda Function action asynchronously without waiting for response.
  ///
  ///  -  [cmd]               an action name to be called.
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  -  [params]            (optional) action parameters.
  ///  Returns                Future that receives null for success.
  /// Throws error or

  Future callOneWay(String cmd, IContext? context, params) async {
    await invoke(InvocationType.event, cmd, context, params);
  }
}
