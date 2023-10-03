import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';
import '../controllers/controllers.dart';

/// Abstract client that calls remove endpoints using HTTP/REST protocol.
///
/// ### Configuration parameters ###
///
/// - [base_route]:              base route for remote URI
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
///   - [trace_id]         place for adding correalationId, query - in query string, headers - in headers, both - in query and headers (default: query)
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0         (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - \*:counters:\*:\*:1.0         (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
/// - \*:tracer:\*:\*:1.0         (optional) [ITracer](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ITracer-class.html) components to record traces
/// - \*:discovery:\*:\*:1.0        (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection
///
/// See [RestController]
/// See [CommandableHttpController]
///
/// ### Example ###
///
///     class MyRestClient extends RestClient implements IMyClient {
///        ...
///
///         Future<MyData> getData(IContext? context, String id) async {
///            var timing = instrument(context, 'myclient.get_data');
///           try{
///             var result = await call('get', '/get_data' context, { id: id }, null);
///             timing.endTiming();
///             return result;
///           } catch (err) {
///                timing.endFailure(err as Exception);
///                rethrow;
///            });
///        }
///        ...
///     }
///
///     var client = MyRestClient();
///     client.configure(ConfigParams.fromTuples([
///         'connection.protocol', 'http',
///         'connection.host', 'localhost',
///         'connection.port', 8080
///     ]));
///
///     var result = await client.getData('123', '1');
///       ...

abstract class RestClient implements IOpenable, IConfigurable, IReferenceable {
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

  /// The HTTP client.
  http.Client? client;

  /// The connection resolver.
  var connectionResolver = HttpConnectionResolver();

  /// The logger.
  var logger = CompositeLogger();

  /// The performance counters.
  var counters = CompositeCounters();

  /// The tracer.
  var tracer = CompositeTracer(null);

  /// The configuration options.
  var options = ConfigParams();

  /// The base route.
  String? baseRoute;

  /// The number of retries.
  int retries = 1;

  /// The default headers to be added to every request.
  var headers = <String, String>{};

  /// The connection timeout in milliseconds.
  int connectTimeout = 10000;

  /// The invocation timeout in milliseconds.
  int timeout = 10000;

  /// The remote service uri which is calculated on open.
  String? uri;

  dynamic contextLocation = 'query';

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    config = config.setDefaults(RestClient._defaultConfig);
    connectionResolver.configure(config);
    options = options.override(config.getSection('options'));

    retries = config.getAsIntegerWithDefault('options.retries', retries);
    connectTimeout = config.getAsIntegerWithDefault(
        'options.connect_timeout', connectTimeout);
    timeout = config.getAsIntegerWithDefault('options.timeout', timeout);

    baseRoute = config.getAsStringWithDefault('base_route', baseRoute ?? '');
    contextLocation = config.getAsStringWithDefault(
        'options.trace_id_place', contextLocation);
    contextLocation =
        config.getAsStringWithDefault('options.trace_id', contextLocation);
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    logger.setReferences(references);
    counters.setReferences(references);
    tracer.setReferences(references);
    connectionResolver.setReferences(references);
  }

  /// Adds instrumentation to log calls and measure call time.
  /// It returns a Timing object that is used to end the time measurement.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [name]              a method name.
  /// Returns               [InstrumentTiming] object to end the time measurement.
  InstrumentTiming instrument(IContext? context, String name) {
    logger.trace(context, 'Executing %s method', [name]);
    counters.incrementOne('$name.exec_count');

    var counterTiming = counters.beginTiming('$name.exec_time');
    var traceTiming = tracer.beginTrace(context, name, '');

    return InstrumentTiming(
        context, name, 'exec', logger, counters, counterTiming, traceTiming);
  }

  /// Adds instrumentation to error handling.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [name]              a method name.
  /// - [err]               an occured error
  void instrumentError(IContext? context, String name, err,
      [bool? reerror = false]) {
    if (err != null) {
      logger.error(context, ApplicationException().wrap(err),
          'Failed to call %s method', [name]);
      counters.incrementOne('$name.call_errors');
      if (reerror != null && reerror == true) {
        throw err;
      }
    }
  }

  /// Checks if the component is opened.
  /// Returns true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return client != null;
  }

  /// Opens the component.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return 			Future that receives null no errors occured.
  /// Throws error
  @override
  Future open(IContext? context) async {
    if (isOpen()) {
      return;
    }

    var connection = await connectionResolver.resolve(context);

    try {
      uri = connection.getAsString('uri');
      client = http.Client();
      // this.client = restify.createJsonClient({
      //     url: this.uri,
      //     connectTimeout: this.connectTimeout,
      //     requestTimeout: this.timeout,
      //     headers: this.headers,
      //     retry: {
      //         minTimeout: this.timeout,
      //         maxTimeout: Infinity,
      //         retries: this.retries
      //     },
      //     version: '*'
      // });
      logger.debug(context, 'Connected via REST to %s', [uri]);
    } catch (err) {
      client = null;
      throw ConnectionException(
              context != null ? ContextResolver.getTraceId(context) : null,
              'CANNOT_CONNECT',
              'Connection to REST service failed')
          .wrap(err)
          .withDetails('url', uri);
    }
  }

  /// Closes component and frees used resources.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return			Future that receives null no errors occured.
  /// Throws error
  @override
  Future close(IContext? context) async {
    if (client != null) {
      // Eat exceptions
      try {
        client!.close();
        logger.debug(context, 'Closed REST service at %s', [uri]);
      } catch (ex) {
        logger.warn(context, 'Failed while closing REST service: %s', [ex]);
      }

      client = null;
      uri = null;
    }
  }

  /// Adds a trace id (trace_id) to invocation parameter map.
  ///
  /// - [params]            invocation parameters.
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Returns invocation parameters with added trace id.
  Map<String, String> addTraceId(
      Map<String, String>? params, IContext? context) {
    params = params ?? {};

    // Automatically generate short ids for now
    if (context == null) {
      return params;
    }

    params['trace_id'] = ContextResolver.getTraceId(context);
    return params;
  }

  /// Adds filter parameters (with the same name as they defined)
  /// to invocation parameter map.
  ///
  /// - [params]        invocation parameters.
  /// - [filter]        (optional) filter parameters
  /// Returns invocation parameters with added filter parameters.
  Map<String, String> addFilterParams(
      Map<String, String>? params, FilterParams? filter) {
    params = params ?? {};

    if (filter != null) {
      for (var prop in filter.values) {
        //if (filter.hasOwnProperty(prop))
        if (prop != null) {
          params[prop] = filter[prop]!;
        }
      }
    }

    return params;
  }

  /// Adds paging parameters (skip, take, total) to invocation parameter map.
  ///
  /// - [params]        invocation parameters.
  /// - [paging]        (optional) paging parameters
  /// Returns invocation parameters with added paging parameters.
  Map<String, String> addPagingParams(
      Map<String, String>? params, PagingParams? paging) {
    params = params ?? {};

    if (paging != null) {
      if (paging.total) {
        params['total'] = paging.total.toString();
      }
      if (paging.skip != null && paging.skip! > 0) {
        params['skip'] = paging.skip.toString();
      }
      if (paging.take != null && paging.take! > 0) {
        params['take'] = paging.take.toString();
      }
    }

    return params;
  }

  String createRequestRoute(String route) {
    var builder = '';

    if (baseRoute != null && baseRoute!.isNotEmpty) {
      if (baseRoute![0] != '/') {
        builder += '/';
      }
      builder += baseRoute!;
    }

    if (route[0] != '/') {
      builder += '/';
    }
    builder += route;

    return (uri ?? '') + builder;
  }

  /// Calls a remote method via HTTP/REST protocol.
  ///
  /// - [method]            HTTP method: 'get', 'head', 'post', 'put', 'delete'
  /// - [route]             a command route. Base route will be added to this route
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [params]            (optional) query parameters.
  /// - [data]              (optional) body object.
  /// Returns          Future that receives result object
  /// Throw error.
  Future call(String method, String route, IContext? context,
      Map<String, String> params,
      [data]) async {
    method = method.toLowerCase();

    route = createRequestRoute(route);
    params = addTraceId(params, context);
    if (params.isNotEmpty) {
      var uri = Uri(queryParameters: params);
      route += uri.toString();
    }

    http.Response? response;
    var retriesCount = retries;

    if (data != null) {
      headers['Content-Type'] = 'application/json';
    } else {
      headers.remove('Content-Type');
    }
    var routeUri = Uri.parse(route);
    for (; retries > 0;) {
      try {
        if (method == 'get') {
          response = await client!.get(routeUri); //headers: headers
        } else if (method == 'head') {
          response = await client!.head(routeUri); //headers: headers
        } else if (method == 'post') {
          response = await client!
              .post(routeUri, headers: headers, body: json.encode(data));
        } else if (method == 'put') {
          response = await client!
              .put(routeUri, headers: headers, body: json.encode(data));
        } else if (method == 'delete') {
          response = await client!.delete(routeUri); //headers: headers
        } else {
          var error = UnknownException(
                  context != null ? ContextResolver.getTraceId(context) : null,
                  'UNSUPPORTED_METHOD',
                  'Method is not supported by REST client')
              .withDetails('verb', method);
          throw error;
        }
        break;
      } catch (ex) {
        retriesCount--;
        if (retriesCount == 0) {
          rethrow;
        } else {
          logger.trace(context, "Connection failed to uri '$uri'. Retrying...");
        }
      }
    }

    if (response == null) {
      throw ApplicationExceptionFactory.create(ErrorDescriptionFactory.create(
          UnknownException(
              context != null ? ContextResolver.getTraceId(context) : null,
              'Unable to get a result from uri $uri with method $method')));
    }

    if (response.statusCode == 204) {
      return null;
    }

    return response.body;
  }
}
