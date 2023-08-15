import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';

import './PrometheusCounterConverter.dart';

/// Performance counters that send their metrics to Prometheus service.
///
/// The component is normally used in passive mode conjunction with [PrometheusMetricsService].
/// Alternatively when connection parameters are set it can push metrics to Prometheus PushGateway.
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
/// - [\*:discovery:\*:\*:1.0]        (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection
///
/// See [RestController](https://pub.dev/documentation/pip_services4_http/latest/pip_services4_http/RestController-class.html)
/// See [CommandableHttpController](https://pub.dev/documentation/pip_services4_http/latest/pip_services4_http/CommandableHttpController-class.html)
///
/// ### Example ###
///
///     var counters =  PrometheusCounters();
///     counters.configure(ConfigParams.fromTuples([
///         'connection.protocol', 'http',
///         'connection.host', 'localhost',
///         'connection.port', 8080
///     ]));
///
///     await counters.open('123')
///         ...
///
///     counters.increment('mycomponent.mymethod.calls');
///     var timing = counters.beginTiming('mycomponent.mymethod.exec_time');
///     try {
///         ...
///     } finally {
///         timing.endTiming();
///     }
///
///     counters.dump();

class PrometheusCounters extends CachedCounters
    implements IReferenceable, IOpenable {
  final _logger = CompositeLogger();
  final _connectionResolver = HttpConnectionResolver();
  bool _opened = false;
  String? _source;
  String? _instance;
  bool _pushEnabled = true;
  http.Client? _client;
  String? _requestRoute;
  String? _uri;

  /// Creates a new instance of the performance counters.
  PrometheusCounters() : super();

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    super.configure(config);

    _connectionResolver.configure(config);
    _source = config.getAsNullableString('source') ?? _source;
    _instance = config.getAsNullableString('instance') ?? _instance;
    _pushEnabled = config.getAsBooleanWithDefault('push_enabled', true);
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    _logger.setReferences(references);
    _connectionResolver.setReferences(references);

    var contextInfo = references.getOneOptional<ContextInfo>(
        Descriptor('pip-services', 'context-info', 'default', '*', '1.0'));
    if (contextInfo != null && _source == null) {
      _source = contextInfo.name;
    }
    if (contextInfo != null && _instance == null) {
      _instance = contextInfo.contextId;
    }
  }

  /// Checks if the component is opened.
  ///
  /// Returns true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return _opened;
  }

  /// Opens the component.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return 			Future that receives null no errors occured.
  /// Throws error
  @override
  Future open(IContext? context) async {
    if (_opened) {
      return null;
    }
    if (!_pushEnabled) {
      return null;
    }

    ConfigParams? connection;

    try {
      connection = await _connectionResolver.resolve(context);
      // ignore: unnecessary_null_comparison
      if (connection == null) {
        throw Exception('Empty config.');
      }
    } catch (err) {
      _client = null;
      _logger.warn(
          context, 'Connection to Prometheus server is not configured: $err');
      return null;
    }
    var job = _source ?? 'unknown';
    var instance = _instance ?? Platform.localHostname;
    _requestRoute = '/metrics/job/$job/instance/$instance';
    _uri = connection.getAsString('uri');
    _client = http.Client();
    _opened = true;
  }

  /// Closes component and frees used resources.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return 			      Future that receives null no errors occured.
  /// Throws error
  @override
  Future close(IContext? context) async {
    _opened = false;
    if (_client != null) {
      _client!.close();
    }
    _client = null;
    _requestRoute = null;
  }

  /// Saves the current counters measurements.
  ///
  /// - [counters]      current counters measurements to be saves.
  @override
  Future save(List<Counter> counters) async {
    if (_client == null || !_pushEnabled) return;
    var body = PrometheusCounterConverter.toString2(counters, null, null);

    var url = _uri! + _requestRoute!;
    try {
      var response = await _client!
          .put(Uri.parse(url), headers: {'Accept': 'text/html'}, body: body);
      if (response.statusCode >= 400) {
        _logger.error(Context.fromTraceId('prometheus-counters'),
            ApplicationException(), 'Failed to push metrics to prometheus');
      }
    } catch (ex) {
      _logger.error(
          Context.fromTraceId('prometheus-counters'),
          ApplicationException().wrap(ex),
          'Failed to push metrics to prometheus');
    }
  }
}
