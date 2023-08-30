import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';
import 'package:pip_services4_http/pip_services4_http.dart';

import 'DataDogMetric.dart';
import 'DataDogMetricPoint.dart';

class DataDogMetricsClient extends RestClient {
  final _defaultConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'https',
    'connection.host',
    'api.datadoghq.com',
    'connection.port',
    443,
    'credential.internal_network',
    'true'
  ]);
  final _credentialResolver = CredentialResolver();

  DataDogMetricsClient(ConfigParams? config) : super() {
    if (config != null) configure(config);
    baseRoute = 'api/v1';
  }

  @override
  void configure(ConfigParams config) {
    config = _defaultConfig.override(config);
    super.configure(config);
    _credentialResolver.configure(config);
  }

  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    _credentialResolver.setReferences(references);
  }

  @override
  Future open(IContext? context) async {
    final credential = await _credentialResolver.lookup(context);

    if (credential == null || credential.getAccessKey() == null) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_ACCESS_KEY',
          'Missing access key in credentials');
    }

    headers['DD-API-KEY'] = credential.getAccessKey()!;

    await super.open(context);
  }

  String? _convertTags(Map<String, String>? tags) {
    if (tags == null) return null;

    var builder = '';

    for (var key in tags.keys) {
      if (builder != '') {
        builder += ',';
      }
      builder += '$key:${tags[key]}';
    }
    return builder;
  }

  List<dynamic> _convertPoints(List<DataDogMetricPoint> points) {
    final result = points.map((p) => [
          StringConverter.toString2(
              (p.time ?? DateTime.now()).microsecondsSinceEpoch / 1000),
          StringConverter.toString2(p.value)
        ]);
    return result.toList();
  }

  dynamic _convertMetric(DataDogMetric metric) {
    var tags = metric.tags;

    if (metric.service != null) {
      tags = tags ?? {};
      tags['service'] = metric.service ?? '';
    }

    final result = {
      'metric': metric.metric,
      'type': metric.type ?? 'gauge',
      'points': _convertPoints(metric.points ?? []),
    };

    if (tags != null) {
      result['tags'] = _convertTags(tags) ?? '';
    }
    if (metric.host != null) {
      result['host'] = metric.host!;
    }
    if (metric.interval != null) {
      result['interval'] = metric.interval!;
    }

    return result;
  }

  dynamic _convertMetrics(List<DataDogMetric> metrics) {
    final series = metrics.map((m) => _convertMetric(m)).toList();
    return {'series': series};
  }

  Future sendMetrics(IContext? context, List<DataDogMetric> metrics) async {
    final data = _convertMetrics(metrics);

    // Commented instrumentation because otherwise it will never stop sending logs...
    //let timing = this.instrument(context, 'datadog.send_metrics');
    try {
      await call('post', 'series', null, {}, data);
    } finally {
      //timing.endTiming();
    }
  }
}
