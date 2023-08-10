import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';

class DummyController
    implements IReferenceable, IReconfigurable, IOpenable, INotifiable {
  late FixedRateTimer _timer;
  final _logger = CompositeLogger();
  var _message = 'Hello World!';
  var _counter = 0;

  DummyController() {
    _timer = FixedRateTimer(this, 1000, 1000);
  }

  String get message {
    return _message;
  }

  set message(String value) {
    _message = value;
  }

  int get counter {
    return _counter;
  }

  set counter(int value) {
    _counter = value;
  }

  @override
  void configure(ConfigParams config) {
    message = config.getAsStringWithDefault('message', message);
  }

  @override
  void setReferences(IReferences references) {
    _logger.setReferences(references);
  }

  @override
  bool isOpen() {
    return _timer.isStarted();
  }

  @override
  Future open(IContext? context) async {
    try {
      _timer.start();
      _logger.trace(context, 'Dummy controller opened');
    } catch (ex) {
      _logger.error(context, ex as Exception, 'Failed to open Dummy container');

      rethrow;
    }
  }

  @override
  Future close(IContext? context) async {
    try {
      _timer.stop();
      _logger.trace(context, 'Dummy controller closed');
    } catch (ex) {
      _logger.error(
          context, ex as Exception, 'Failed to close Dummy container');
      rethrow;
    }
  }

  @override
  void notify(IContext? context, Parameters args) {
    _logger.info(context, '%d - %s', [counter++, message]);
  }
}
