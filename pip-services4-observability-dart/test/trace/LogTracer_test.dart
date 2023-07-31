import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_observability/src/log/log.dart';
import 'package:pip_services4_observability/src/trace/trace.dart';
import 'package:test/test.dart';

void main() {
  group('MemoryStateStore', () {
    var _tracer = LogTracer();
    _tracer.setReferences(References.fromTuples([
      Descriptor('pip-services', 'logger', 'null', 'default', '1.0'),
      NullLogger()
    ]));
    test('Simple Tracing', () {
      _tracer.trace(
          Context.fromTraceId('123'), 'mycomponent', 'mymethod', 123456);
      _tracer.failure(Context.fromTraceId('123'), 'mycomponent', 'mymethod',
          Exception('Test error'), 123456);
    });
    test('Trace Timing', () {
      var timing = _tracer.beginTrace(
          Context.fromTraceId('123'), 'mycomponent', 'mymethod');
      timing.endTrace();

      timing = _tracer.beginTrace(
          Context.fromTraceId('123'), 'mycomponent', 'mymethod');
      timing.endFailure(Exception('Test error'));
    });
  });
}
