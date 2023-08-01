import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';

class InstrumentTiming {
  final IContext? _context;
  final String _name;
  final String _verb;
  ILogger? _logger;
  ICounters? _counters;
  CounterTiming? _counterTiming;
  TraceTiming? _traceTiming;

  InstrumentTiming(
      IContext? context,
      String name,
      String? verb,
      ILogger? logger,
      ICounters? counters,
      CounterTiming? counterTiming,
      TraceTiming? traceTiming)
      : _context = context,
        _name = name,
        _verb = verb ?? 'call',
        _logger = logger,
        _counters = counters,
        _counterTiming = counterTiming,
        _traceTiming = traceTiming;

  void _clear() {
    // Clear references to avoid double processing
    _counters = null;
    _logger = null;
    _counterTiming = null;
    _traceTiming = null;
  }

  void endTiming([Exception? err]) {
    if (err == null) {
      endSuccess();
    } else {
      endFailure(err);
    }
  }

  void endSuccess() {
    if (_counterTiming != null) {
      _counterTiming!.endTiming();
    }
    if (_traceTiming != null) {
      _traceTiming!.endTrace();
    }

    _clear();
  }

  void endFailure([Exception? err]) {
    if (_counterTiming != null) {
      _counterTiming!.endTiming();
    }

    if (err != null) {
      if (_logger != null) {
        _logger!.error(_context, err, 'Failed to call %s method', [_name]);
      }
      if (_counters != null) {
        _counters!.incrementOne('$_name.${_verb}_errors');
      }
      if (_traceTiming != null) {
        _traceTiming!.endFailure(err);
      }
    } else {
      if (_traceTiming != null) {
        _traceTiming!.endTrace();
      }
    }

    _clear();
  }
}
