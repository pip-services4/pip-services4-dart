import 'package:pip_services4_observability/src/count/count.dart';
import 'package:test/test.dart';

void main() {
  group('NullCounters', () {
    test('Simple Counters', () {
      var counters = NullCounters();

      counters.last('Test.LastValue', 123);
      counters.increment('Test.Increment', 3);
      counters.stats('Test.Statistics', 123);
    });

    test('Measure Elapsed Time', () {
      var counters = NullCounters();
      var timer = counters.beginTiming('Test.Elapsed');
      timer.endTiming();
    });
  });
}
