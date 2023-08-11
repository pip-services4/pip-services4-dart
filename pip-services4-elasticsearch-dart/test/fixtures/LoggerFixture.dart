import 'dart:async';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:test/test.dart';

class LoggerFixture {
  late CachedLogger _logger;

  LoggerFixture(CachedLogger logger) {
    _logger = logger;
  }

  void testLogLevel() {
    expect(_logger.getLevel().index >= LogLevel.None.index, isTrue);
    expect(_logger.getLevel().index <= LogLevel.Trace.index, isTrue);
  }

  Future testSimpleLogging() async {
    _logger.setLevel(LogLevel.Trace);

    _logger.fatal(null, null, 'Fatal error message');
    _logger.error(null, null, 'Error message');
    _logger.warn(null, 'Warning message');
    _logger.info(null, 'Information message');
    _logger.debug(null, 'Debug message');
    _logger.trace(null, 'Trace message');

    _logger.dump();
    await Future.delayed(Duration(milliseconds: 1000));
  }

  Future testErrorLogging() async {
    try {
      // Raise an exception
      throw Exception('Test error');
    } catch (err) {
      var ex = ApplicationException().wrap(err);
      _logger.fatal(Context.fromTraceId('123'), ex, 'Fatal error');
      _logger.error(Context.fromTraceId('123'), ex, 'Recoverable error');

      expect(ex, isNotNull);
    }

    _logger.dump();
    await Future.delayed(Duration(milliseconds: 1000));
  }
}
