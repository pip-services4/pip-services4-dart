import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_elasticsearch/pip_services4_elasticsearch.dart';
import 'package:test/test.dart';
import '../fixtures/LoggerFixture.dart';

void main() {
  group('ElasticSearchLogger', () {
    late ElasticSearchLogger _logger;
    late LoggerFixture _fixture;

    setUp(() async {
      var host =
          Platform.environment['ELASTICSEARCH_SERVICE_HOST'] ?? 'localhost';
      var port = Platform.environment['ELASTICSEARCH_SERVICE_PORT'] ?? 9200;
      var dateFormat = 'yyyyMMdd';

      _logger = ElasticSearchLogger();
      _fixture = LoggerFixture(_logger);

      var config = ConfigParams.fromTuples([
        'source',
        'test',
        'index',
        'log',
        'daily',
        true,
        'date_format',
        dateFormat,
        'connection.host',
        host,
        'connection.port',
        port
      ]);
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

    /// We test to ensure that the date pattern does not effect the opening of the elasticsearch component

    test('Date Pattern Testing - yyyy.MM.dd', () async {
      var host =
          Platform.environment['ELASTICSEARCH_SERVICE_HOST'] ?? 'localhost';
      var port = Platform.environment['ELASTICSEARCH_SERVICE_PORT'] ?? 9200;

      var logger = ElasticSearchLogger();
      var dateFormat = 'yyyy.MM.dd';

      var config = ConfigParams.fromTuples([
        'source',
        'test',
        'index',
        'log',
        'daily',
        true,
        'date_format',
        dateFormat,
        'connection.host',
        host,
        'connection.port',
        port
      ]);
      logger.configure(config);

      await logger.open(null);

      // Since the currentIndex property is private, we will just check for an open connection
      expect(logger.isOpen(), isTrue);
      await logger.close(null);
    });

    /// We test to ensure that the date pattern does not effect the opening of the elasticsearch component

    test('Date Pattern Testing - yyyy.M.dd', () async {
      var host =
          Platform.environment['ELASTICSEARCH_SERVICE_HOST'] ?? 'localhost';
      var port = Platform.environment['ELASTICSEARCH_SERVICE_PORT'] ?? 9200;

      var logger = ElasticSearchLogger();
      var dateFormat = 'yyyy.M.dd';

      var config = ConfigParams.fromTuples([
        'source',
        'test',
        'index',
        'log',
        'daily',
        true,
        'date_format',
        dateFormat,
        'connection.host',
        host,
        'connection.port',
        port
      ]);
      logger.configure(config);

      await logger.open(null);

      // Since the currentIndex property is private, we will just check for an open connection
      expect(logger.isOpen(), isTrue);
      await logger.close(null);
    });
  });
}
