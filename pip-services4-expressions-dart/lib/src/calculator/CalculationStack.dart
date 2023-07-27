import 'package:pip_services4_expressions/src/variants/variants.dart';

/// Implements a stack of Variant values.
class CalculationStack {
  final List<Variant> _values = [];

  int get length => _values.length;

  void push(Variant value) {
    _values.add(value);
  }

  Variant pop() {
    if (_values.isEmpty) {
      throw Exception('Stack is empty.');
    }
    var result = _values.removeLast();
    return result;
  }

  Variant peekAt(int index) {
    return _values[index];
  }

  Variant peek() {
    if (_values.isEmpty) {
      throw Exception('Stack is empty.');
    }
    return _values[_values.length - 1];
  }
}
