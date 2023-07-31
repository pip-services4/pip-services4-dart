import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_observability/src/log/log.dart';
import 'package:test/test.dart';

void main() {
  group('NullLogger', () {
    NullLogger _logger;

    _logger = NullLogger();

    test('Log Level', () {
      expect(_logger.getLevel().index >= LogLevel.None.index, isTrue);
      expect(_logger.getLevel().index <= LogLevel.Trace.index, isTrue);
    });

    _logger = NullLogger();
    test('Simple Logging', () {
      _logger.setLevel(LogLevel.Trace);

      _logger.fatal(null, null, 'Fatal error message');
      _logger.error(null, null, 'Error message');
      _logger.warn(null, 'Warning message');
      _logger.info(null, 'Information message');
      _logger.debug(null, 'Debug message');
      _logger.trace(null, 'Trace message');
    });

    _logger = NullLogger();
    test('Error Logging', () {
      try {
        // Raise an exception
        throw Exception();
      } catch (ex) {
        //var ex = ApplicationException().wrap(err);
        _logger.fatal(
            Context.fromTraceId('123'), ex as Exception, 'Fatal error');
        _logger.error(Context.fromTraceId('123'), ex, 'Recoverable error');
        expect(ex, isNotNull);
      }
    });
  });
}
