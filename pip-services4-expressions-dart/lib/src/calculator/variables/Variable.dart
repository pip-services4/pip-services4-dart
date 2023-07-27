import 'package:pip_services4_expressions/src/variants/Variant.dart';

import 'IVariable.dart';

/// Implements a variable holder object.
class Variable implements IVariable {
  String _name;
  Variant _value;

  Variable(String name, [Variant? value])
      : _name = name,
        _value = value ?? Variant();

  /// The variable name.
  @override
  String get name => _name;

  /// The variable value.
  @override
  set name(String value) => _name = value;

  /// The variable value.
  @override
  Variant get value => _value;

  /// The variable value.
  @override
  set value(Variant value) => _value = value;
}
