import 'dart:io';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';

import '../clients/DataDogMetric.dart';
import '../clients/DataDogMetricPoint.dart';
import '../clients/DataDogMetricType.dart';
import '../clients/DataDogMetricsClient.dart';

/// Performance counters that send their metrics to DataDog service.
///
/// DataDog is a popular monitoring SaaS service. It collects logs, metrics, events
/// from infrastructure and applications and analyze them in a single place.
///
/// ### Configuration parameters ###
///
/// - connection(s):
///   - discovery_key:         (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///     - protocol:            (optional) connection protocol: http or https (default: https)
///     - host:                (optional) host name or IP address (default: api.datadoghq.com)
///     - port:                (optional) port number (default: 443)
///     - uri:                 (optional) resource URI or connection string with all parameters in it
/// - credential:
///     - access_key:          DataDog client api key
/// - options:
///   - retries:               number of retries (default: 3)
///   - connect_timeout:       connection timeout in milliseconds (default: 10 sec)
///   - timeout:               invocation timeout in milliseconds (default: 10 sec)
///
/// ### References ###
///
/// - [\*:logger:\*:\*:1.0]         (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - [\*:counters:\*:\*:1.0]         (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
/// - [\*:discovery:\*:\*:1.0]        (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection
///
/// ### Example ###
///
///     var counters = new DataDogCounters();
///     counters.configure(ConfigParams.fromTuples([
///         "credential.access_key", "827349874395872349875493"
///     ]));
///
///     await counters.open(Context.fromTraceId("123"));
///
///     counters.increment("mycomponent.mymethod.calls");
///     var timing = counters.beginTiming("mycomponent.mymethod.exec_time");
///     try {
///         ...
///     } finally {
///         timing.endTiming();
///     }
///
///     counters.dump();
class DataDogCounters extends CachedCounters
    implements IReferenceable, IOpenable {
  final DataDogMetricsClient _client = DataDogMetricsClient(null);
  final _logger = CompositeLogger();
  bool _opened = false;
  String? _source;
  String _instance = Platform.localHostname;

  /// Creates a new instance of the performance counters.
  DataDogCounters() : super();

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    super.configure(config);
    _client.configure(config);

    _source = config.getAsStringWithDefault("source", _source ?? '');
    _instance = config.getAsStringWithDefault("instance", _instance);
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    _logger.setReferences(references);
    _client.setReferences(references);

    final contextInfo = references.getOneOptional<ContextInfo>(
        Descriptor("pip-services", "context-info", "default", "*", "1.0"));
    if (contextInfo != null && _source == null) {
      _source = contextInfo.name;
    }
    // ignore: unnecessary_null_comparison
    if (contextInfo != null && _instance == null) {
      _instance = contextInfo.contextId;
    }
  }

  /// Checks if the component is opened.
  ///
  /// Return true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return _opened;
  }

  /// Opens the component.
  ///
  /// - [context] 	(optional) execution context to trace execution through call chain.
  @override
  Future open(IContext? context) async {
    if (_opened) {
      return;
    }

    _opened = true;

    await _client.open(context);
  }

  /// Closes component and frees used resources.
  ///
  /// - [context] 	(optional) execution context to trace execution through call chain.
  @override
  Future close(IContext? context) async {
    _opened = false;

    return _client.close(context);
  }

  List<DataDogMetric>? _convertCounter(Counter counter) {
    switch (counter.type) {
      case CounterType.Increment:
        return [
          DataDogMetric(
              metric: counter.name,
              type: DataDogMetricType.Gauge,
              host: _instance,
              service: _source,
              points: [
                DataDogMetricPoint(time: counter.time, value: counter.count)
              ])
        ];
      case CounterType.LastValue:
        return [
          DataDogMetric(
              metric: counter.name,
              type: DataDogMetricType.Gauge,
              host: _instance,
              service: _source,
              points: [
                DataDogMetricPoint(time: counter.time, value: counter.last)
              ])
        ];
      case CounterType.Interval:
      case CounterType.Statistics:
        return [
          DataDogMetric(
              metric: "${counter.name}.min",
              type: DataDogMetricType.Gauge,
              host: _instance,
              service: _source,
              points: [
                DataDogMetricPoint(time: counter.time, value: counter.min)
              ]),
          DataDogMetric(
              metric: "${counter.name}.average",
              type: DataDogMetricType.Gauge,
              host: _instance,
              service: _source,
              points: [
                DataDogMetricPoint(time: counter.time, value: counter.average)
              ]),
          DataDogMetric(
              metric: "${counter.name}.max",
              type: DataDogMetricType.Gauge,
              host: _instance,
              service: _source,
              points: [
                DataDogMetricPoint(time: counter.time, value: counter.max)
              ])
        ];
      default:
        return null;
    }
  }

  List<DataDogMetric> _convertCounters(List<Counter> counters) {
    List<DataDogMetric> metrics = [];

    for (var counter in counters) {
      final data = _convertCounter(counter);
      if (data != null && data.isNotEmpty) {
        metrics.addAll(data);
      }
    }

    return metrics;
  }

  /// Saves the current counters measurements.
  ///
  /// - [counters]      current counters measurements to be saves.
  @override
  void save(List<Counter> counters) {
    final metrics = _convertCounters(counters);
    if (metrics.isEmpty) return;
    final context = Context.fromTraceId('datadog-counters');
    try {
      _client.sendMetrics(context, metrics);
    } catch (err) {
      _logger.error(
          context, err as Exception, "Failed to push metrics to DataDog");
    }
  }
}
