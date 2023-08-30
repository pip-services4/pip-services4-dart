import 'dart:io';
import 'package:pip_services4_datadog/pip_services4_datadog.dart';
import 'package:test/test.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

import '../fixtures/LoggerFixture.dart';

void main() {
  group('DataDogLogger', () {
    late DataDogLogger _logger;
    late LoggerFixture _fixture;

    var apiKey = Platform.environment['DATADOG_API_KEY'] ??
        '3eb3355caf628d4689a72084425177ac';

    setUp(() async {
      _logger = DataDogLogger();
      _fixture = LoggerFixture(_logger);

      var config = ConfigParams.fromTuples(
          ['source', 'test', 'credential.access_key', apiKey]);
      _logger.configure(config);

      await _logger.open(null);
    });

    tearDown(() async {
      await _logger.close(null);
    });

    test('Log Level', () {
      _fixture.testLogLevel();
    });

    test('Simple Logging', () async {
      await _fixture.testSimpleLogging();
    });

    test('Error Logging', () async {
      await _fixture.testErrorLogging();
    });
  });
}
