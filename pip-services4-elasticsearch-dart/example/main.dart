import 'dart:io';

import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_elasticsearch/pip_services4_elasticsearch.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';

void main() async {
  var host = Platform.environment['ELASTICSEARCH_SERVICE_HOST'] ?? 'localhost';
  var port = Platform.environment['ELASTICSEARCH_SERVICE_PORT'] ?? 9200;
  var dateFormat = 'yyyyMMdd';

  var _logger = ElasticSearchLogger();

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

  _logger.setLevel(LogLevel.Trace);
  _logger.fatal(null, null, 'Fatal error message');
  _logger.error(null, null, 'Error message');
  _logger.warn(null, 'Warning message');
  _logger.info(null, 'Information message');
  _logger.debug(null, 'Debug message');
  _logger.trace(null, 'Trace message');

  try {
    // Raise an exception
    throw Exception('Test error');
  } catch (err) {
    var ex = ApplicationException().wrap(err);
    _logger.fatal(Context.fromTraceId('123'), ex, 'Fatal error');
    _logger.error(Context.fromTraceId('123'), ex, 'Recoverable error');
  }

  _logger.dump();

  await _logger.close(null);
}
