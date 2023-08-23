import 'dart:io';
import 'package:test/test.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

import 'package:pip_services4_aws/pip_services4_aws.dart';
import './LoggerFixture.dart';

void main() {
  group('CloudWatchLogger', () {
    late CloudWatchLogger _logger;
    late LoggerFixture _fixture;

    var AWS_REGION = Platform.environment['AWS_REGION'];
    var AWS_ACCESS_ID = Platform.environment['AWS_ACCESS_ID'];
    var AWS_ACCESS_KEY = Platform.environment['AWS_ACCESS_KEY'];

    if (AWS_REGION == null || AWS_ACCESS_ID == null || AWS_ACCESS_KEY == null) {
      return;
    }

    setUp(() async {
      _logger = CloudWatchLogger();
      _fixture = LoggerFixture(_logger);

      var config = ConfigParams.fromTuples([
        'group',
        'TestGroup',
        'connection.region',
        AWS_REGION,
        'credential.access_id',
        AWS_ACCESS_ID,
        'credential.access_key',
        AWS_ACCESS_KEY
      ]);
      _logger.configure(config);

      var contextInfo = ContextInfo();
      contextInfo.name = 'TestStream';

      var references = References.fromTuples([
        Descriptor('pip-services', 'context-info', 'default', 'default', '1.0'),
        contextInfo,
        Descriptor('pip-services', 'counters', 'cloudwatch', 'default', '1.0'),
        _logger
      ]);
      _logger.setReferences(references);

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
