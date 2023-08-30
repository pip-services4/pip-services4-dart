import 'dart:io';
import 'package:pip_services4_datadog/pip_services4_datadog.dart';
import 'package:test/test.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

import '../fixtures/CountersFixture.dart';

void main() {
  group('DataDogCounters', () {
    late DataDogCounters _counters;
    late CountersFixture _fixture;

    var apiKey = Platform.environment['DATADOG_API_KEY'] ??
        '3eb3355caf628d4689a72084425177ac';

    setUp(() async {
      _counters = DataDogCounters();
      _fixture = CountersFixture(_counters);

      var config = ConfigParams.fromTuples(
          ['source', 'test', 'credential.access_key', apiKey]);
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
