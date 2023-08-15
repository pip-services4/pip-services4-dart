import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';

import 'package:pip_services4_prometheus/src/count/PrometheusCounters.dart';
import '../fixtures/CountersFixture.dart';

void main() {
  group('PrometheusCounters', () {
    late PrometheusCounters _counters;
    late CountersFixture _fixture;

    setUp(() async {
      var host =
          Platform.environment['PUSHGATEWAY_SERVICE_HOST'] ?? 'localhost';
      var port = Platform.environment['PUSHGATEWAY_SERVICE_PORT'] ?? 9091;

      _counters = PrometheusCounters();
      _fixture = CountersFixture(_counters);

      var config = ConfigParams.fromTuples(
          ['source', 'test', 'connection.host', host, 'connection.port', port]);
      _counters.configure(config);

      await _counters.open(null);
    });

    tearDown(() async {
      await _counters.close(null);
    });

    test('Simple Counters', () async {
      await _fixture.testSimpleCounters();
    });

    test('Measure Elapsed Time', () async {
      await _fixture.testMeasureElapsedTime();
    });
  });
}
