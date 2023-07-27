import 'package:pip_services4_expressions/src/variants/Variant.dart';
import 'package:pip_services4_expressions/src/variants/IVariantOperations.dart';

import 'IFunction.dart';

/// Defines a delegate to implement a function
typedef FunctionCalculator = Future<Variant> Function(
    List<Variant> params, IVariantOperations variantOperations);

/// Defines an interface for expression function.
class DelegatedFunction implements IFunction {
  late String _name;
  late FunctionCalculator _calculator;

  /// Creates a new command object and assigns it's parameters.
  /// - [name] The name of this function.
  /// - [calculator] The function calculator delegate.
  DelegatedFunction(String name, FunctionCalculator calculator) {
    _name = name;
    _calculator = calculator;
  }

  /// The function name.
  @override
  String get name => _name;

  @override
  set name(String value) {
    _name = value;
  }

  /// The function calculation method.
  /// - [params] an array with function parameters.
  /// - [variantOperations] Variants operations manager.
  /// Returns return function result.
  @override
  Future<Variant> calculate(
      List<Variant> params, IVariantOperations variantOperations) async {
    return await _calculator(params, variantOperations);
  }
}
