import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:test/test.dart';

class CountersFixture {
  late CachedCounters _counters;

  CountersFixture(CachedCounters counters) {
    _counters = counters;
  }

  Future testSimpleCounters() async {
    var counters = _counters;

    counters.last('Test.LastValue', 123);
    counters.last('Test.LastValue', 123456);

    var counter = counters.get('Test.LastValue', CounterType.LastValue);
    expect(counter, isNotNull);
    expect(counter.last, isNotNull);
    expect(counter.last, 123456); // ,3

    counters.incrementOne('Test.Increment');
    counters.increment('Test.Increment', 3);

    counter = counters.get('Test.Increment', CounterType.Increment);
    expect(counter, isNotNull);
    expect(counter.count, 4);

    counters.timestampNow('Test.Timestamp');
    counters.timestampNow('Test.Timestamp');

    counter = counters.get('Test.Timestamp', CounterType.Timestamp);
    expect(counter, isNotNull);
    expect(counter.time, isNotNull);

    counters.stats('Test.Statistics', 1);
    counters.stats('Test.Statistics', 2);
    counters.stats('Test.Statistics', 3);

    counter = counters.get('Test.Statistics', CounterType.Statistics);
    expect(counter, isNotNull);
    expect(counter.average, 2); // ,3

    counters.dump();
    await Future.delayed(Duration(milliseconds: 1000));
  }

  Future testMeasureElapsedTime() async {
    var timer = _counters.beginTiming('Test.Elapsed');

    await Future.delayed(Duration(milliseconds: 100), () {
      timer.endTiming();

      var counter = _counters.get('Test.Elapsed', CounterType.Interval);
      print(counter.last);
      expect(counter.last! > 50, isTrue);
      expect(counter.last! < 5000, isTrue);

      _counters.dump();
    });
    await Future.delayed(Duration(milliseconds: 1000));
  }
}
