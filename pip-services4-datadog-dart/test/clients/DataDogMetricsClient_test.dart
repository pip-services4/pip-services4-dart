import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_datadog/pip_services4_datadog.dart';
import 'package:test/test.dart';

void main() {
  var apiKey = Platform.environment['DATADOG_API_KEY'] ??
      '3eb3355caf628d4689a72084425177ac';

  group('DataDogMetricsClient', () {
    var config = ConfigParams.fromTuples(
        ['source', 'test', 'credential.access_key', apiKey]);

    late DataDogMetricsClient client;

    setUp(() async {
      client = DataDogMetricsClient(null);
      client.configure(config);

      await client.open(null);
    });

    tearDown(() async {
      await client.close(null);
    });

    test('Crud Operations', () async {
      List<DataDogMetric> metrics = [
        DataDogMetric(
            metric: 'test.metric.1',
            service: 'TestService',
            host: 'TestHost',
            type: DataDogMetricType.Gauge,
            points: [
              DataDogMetricPoint(
                  time: DateTime.now(), value: RandomDouble.nextDouble(0, 100))
            ]),
        DataDogMetric(
            metric: 'test.metric.2',
            service: 'TestService',
            host: 'TestHost',
            type: DataDogMetricType.Rate,
            interval: 100,
            points: [
              DataDogMetricPoint(
                  time: DateTime.now(), value: RandomDouble.nextDouble(0, 100))
            ]),
        DataDogMetric(
            metric: 'test.metric.3',
            service: 'TestService',
            host: 'TestHost',
            type: DataDogMetricType.Count,
            interval: 100,
            points: [
              DataDogMetricPoint(
                  time: DateTime.now(), value: RandomDouble.nextDouble(0, 100))
            ])
      ];

      await client.sendMetrics(null, metrics);
    });
  });
}
