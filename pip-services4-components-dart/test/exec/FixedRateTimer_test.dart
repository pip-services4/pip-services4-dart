import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import 'dart:async';

class TestTimer implements INotifiable {
  int counter = 0;
  @override
  void notify(IContext? context, Parameters args) {
    counter++;
  }
}

void main() {
  group('FixedRateTimer', () {
    test('Run with task', () async {
      var notifier = TestTimer();
      var timer = FixedRateTimer(notifier, 100);

      timer.start();

      await Future.delayed(Duration(milliseconds: 500)).then((e) {
        timer.stop();
        expect(notifier.counter > 3, isTrue);
        return null;
      });
    });

    test('Run with callback', () async {
      var counter = 0;

      var timer = FixedRateTimer(() {
        counter++;
      }, 100);

      timer.start();

      await Future.delayed(Duration(milliseconds: 500)).then((e) {
        timer.stop();
        expect(counter > 3, isTrue);
        return null;
      });
    });
  });
}
