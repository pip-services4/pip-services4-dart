import 'package:pip_services4_expressions/src/variants/variants.dart';

/// Defines a variable interface.
abstract interface class IVariable {
  /// The variable name.
  abstract String name;

  /// The variable value.
  abstract Variant value;
}
