import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart' as grpc;
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';
import 'package:protobuf/protobuf.dart';
import '../controllers/controllers.dart';

/// Abstract client that calls remove endpoints using GRPC protocol.
///
/// ### Configuration parameters ###
///
/// - [connection(s)]:
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
/// - [\*:logger:\*:\*:1.0]         (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - [\*:counters:\*:\*:1.0]         (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
/// - [\*:discovery:\*:\*:1.0]        (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection///
///
/// See [GrpcController]
/// See [CommandableGrpcController]
///
/// ### Example ###
///
///     class MyGrpcClient extends GrpcClient implements IMyClient {
///        ...
///
///        Future<MyData> getData(IContext? context, string id) async {
///
///            var timing = this.instrument(context, 'myclient.get_data');
///            var request = MyDataRequest();
///            request.id = id;
///            var response = await call<MydataRequest,MyDataResponse>('get_data', context, request)
///            timing.endTiming();
///            MyData item;
///            ///... convert MyDataResponse to MyData
///            return item;
///        }
///        ...
///     }
///
///     var client = MyGrpcClient();
///     client.configure(ConfigParams.fromTuples([
///         'connection.protocol', 'http',
///         'connection.host', 'localhost',
///         'connection.port', 8080
///     ]));
///
///     var item = await client.getData('123', '1')
///       ...

abstract class GrpcClient implements IOpenable, IConfigurable, IReferenceable {
  static final _defaultConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'http',
    'connection.host',
    '0.0.0.0',
    'connection.port',
    3000,
    'options.request_max_size',
    1024 * 1024,
    'options.connect_timeout',
    10000,
    'options.timeout',
    10000,
    'options.retries',
    3,
    'options.debug',
    true
  ]);

  final String _clientName;

  /// The GRPC client chanel
  grpc.ClientChannel? _channel;

  /// The connection resolver.
  final _connectionResolver = HttpConnectionResolver();

  /// The logger.
  final _logger = CompositeLogger();

  /// The performance counters.
  final _counters = CompositeCounters();

  /// The tracer.
  final _tracer = CompositeTracer();

  /// The configuration options.
  var _options = ConfigParams();

  /// The connection timeout in milliseconds.
  int _connectTimeout = 10000;

  /// The invocation timeout in milliseconds.
  int _timeout = 10000;

  /// The remote service uri which is calculated on open.
  String? _uri;

  GrpcClient(String clientName) : _clientName = clientName;

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    config = config.setDefaults(GrpcClient._defaultConfig);
    _connectionResolver.configure(config);
    _options = _options.override(config.getSection('options'));

    _connectTimeout = config.getAsIntegerWithDefault(
        'options.connect_timeout', _connectTimeout);
    _timeout = config.getAsIntegerWithDefault('options.timeout', _timeout);
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    _logger.setReferences(references);
    _counters.setReferences(references);
    _connectionResolver.setReferences(references);
  }

  /// Adds instrumentation to log calls and measure call time.
  /// It returns a Timing object that is used to end the time measurement.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [name]              a method name.
  /// Returns Timing object to end the time measurement.
  InstrumentTiming instrument(IContext? context, String name) {
    _logger.trace(context, 'Executing %s method', [name]);
    _counters.incrementOne('$name.call_time');

    var counterTiming = _counters.beginTiming('$name.call_time');
    var traceTiming = _tracer.beginTrace(context, name, '');
    return InstrumentTiming(
        context, name, 'exec', _logger, _counters, counterTiming, traceTiming);
  }

  /// Adds instrumentation to error handling.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [name]              a method name.
  /// - [err]               an occured error
  /// - [reerror]           if true - throw error
  // void instrumentError(IContext? context, String name, err,
  //     [bool reerror = false]) {
  //   if (err != null) {
  //     _logger.error(context, err, 'Failed to call %s method', [name]);
  //     _counters.incrementOne(name + '.call_errors');
  //     if (reerror != null && reerror == true) {
  //       throw err;
  //     }
  //   }
  // }

  /// Checks if the component is opened.
  ///
  /// Returns true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return _channel != null;
  }

  /// Opens the component.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return 			      Future that receives error or null no errors occured.
  @override
  Future open(IContext? context) async {
    if (isOpen()) {
      return null;
    }

    try {
      var connection = await _connectionResolver.resolve(context);
      _uri = connection!.getAsString('uri');

      grpc.ChannelCredentials credentials;
      if (connection.getAsString('uri') == 'https') {
        var sslCaFile = connection.getAsNullableString('ssl_ca_file');
        List<int> trustedRoot = File(sslCaFile!).readAsBytesSync();
        credentials = grpc.ChannelCredentials.secure(
            certificates: trustedRoot,
            authority: connection.getAsString('host'));
      } else {
        credentials = const grpc.ChannelCredentials.insecure();
      }

      final options = grpc.ChannelOptions(
          credentials: credentials,
          connectionTimeout: Duration(milliseconds: _connectTimeout),
          idleTimeout: Duration(milliseconds: _timeout));
      _channel = grpc.ClientChannel(connection.getAsString('host'),
          port: connection.getAsInteger('port'), options: options);
    } catch (ex) {
      _channel = null;
      throw ConnectionException(
              context != null ? ContextResolver.getTraceId(context) : null,
              'CANNOT_CONNECT',
              'Opening GRPC client failed')
          .wrap(ex)
          .withDetails('url', _uri);
    }
  }

  /// Closes component and frees used resources.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return 			Future that receives error or null no errors occured.
  @override
  Future close(IContext? context) async {
    if (_channel != null) {
      // Eat exceptions
      try {
        _logger.debug(context, 'Closed GRPC service at %s', [_uri]);
      } catch (ex) {
        _logger.warn(context, 'Failed while closing GRPC service: %s', [ex]);
      }
      _channel = null;
      _uri = null;
    }
  }

  /// Calls a remote method via GRPC protocol.
  ///
  /// - [method]            a method name to called
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [request]           (optional) request object.
  /// Return                (optional) Future that receives result object or error.
  grpc.ResponseFuture<R>
      call<Q extends GeneratedMessage, R extends GeneratedMessage>(
          String method, IContext? context, Q request,
          {grpc.CallOptions? options}) {
    method = method.toLowerCase();
    method = '/$_clientName/$method';

    final _options = grpc.CallOptions();
    final clientMethod = grpc.ClientMethod<Q, R>(
        method, (Q value) => value.writeToBuffer(), (List<int> value) {
      //TODO: make a decision is it right or not?
      R item = TypeReflector.createInstanceByType(R, []);
      item.mergeFromBuffer(value);
      return item;
    });

    final call = _channel!.createCall(clientMethod,
        Stream.fromIterable([request]), _options.mergedWith(options));
    return grpc.ResponseFuture(call);
  }

  /// AddFilterParams method are adds filter parameters (with the same name as they defined)
  /// to invocation parameter map.
  ///  - [params]        invocation parameters.
  ///  - [filter]        (optional) filter parameters
  /// Return invocation parameters with added filter parameters.
  StringValueMap addFilterParams(StringValueMap? params, FilterParams? filter) {
    params ??= StringValueMap();

    if (filter != null) {
      for (var k in filter.keys) {
        params.put(k, filter[k]);
      }
    }
    return params;
  }

  /// AddPagingParams method are adds paging parameters (skip, take, total) to invocation parameter map.
  /// - [params]        invocation parameters.
  /// - [paging]        (optional) paging parameters
  /// Return invocation parameters with added paging parameters.
  StringValueMap addPagingParams(StringValueMap? params, PagingParams? paging) {
    params ??= StringValueMap();

    if (paging != null) {
      params.put('total', paging.total);
      if (paging.skip != null) {
        params.put('skip', paging.skip);
      }
      if (paging.take != null) {
        params.put('take', paging.take);
      }
    }
    return params;
  }
}
