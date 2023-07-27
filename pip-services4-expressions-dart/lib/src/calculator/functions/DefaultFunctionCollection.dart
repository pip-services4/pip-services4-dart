import 'package:pip_services4_expressions/src/variants/variants.dart';
import 'dart:math' as math;

import '../ExpressionException.dart';
import 'DelegatedFunction.dart';
import 'FunctionCollection.dart';

/// Implements a list filled with standard functions.
class DefaultFunctionCollection extends FunctionCollection {
  /// Constructs this list and fills it with the standard functions.
  DefaultFunctionCollection() : super() {
    add(DelegatedFunction('Ticks', _ticksFunctionCalculator));
    add(DelegatedFunction('TimeSpan', _timeSpanFunctionCalculator));
    add(DelegatedFunction('Now', _nowFunctionCalculator));
    add(DelegatedFunction('Date', _dateFunctionCalculator));
    add(DelegatedFunction('DayOfWeek', _dayOfWeekFunctionCalculator));
    add(DelegatedFunction('Min', _minFunctionCalculator));
    add(DelegatedFunction('Max', _maxFunctionCalculator));
    add(DelegatedFunction('Sum', _sumFunctionCalculator));
    add(DelegatedFunction('If', _ifFunctionCalculator));
    add(DelegatedFunction('Choose', _chooseFunctionCalculator));
    add(DelegatedFunction('E', _eFunctionCalculator));
    add(DelegatedFunction('Pi', _piFunctionCalculator));
    add(DelegatedFunction('Rnd', _rndFunctionCalculator));
    add(DelegatedFunction('Random', _rndFunctionCalculator));
    add(DelegatedFunction('Abs', _absFunctionCalculator));
    add(DelegatedFunction('Acos', _acosFunctionCalculator));
    add(DelegatedFunction('Asin', _asinFunctionCalculator));
    add(DelegatedFunction('Atan', _atanFunctionCalculator));
    add(DelegatedFunction('Exp', _expFunctionCalculator));
    add(DelegatedFunction('Log', _logFunctionCalculator));
    add(DelegatedFunction('Ln', _logFunctionCalculator));
    add(DelegatedFunction('Log10', _log10FunctionCalculator));
    add(DelegatedFunction('Ceil', _ceilFunctionCalculator));
    add(DelegatedFunction('Ceiling', _ceilFunctionCalculator));
    add(DelegatedFunction('Floor', _floorFunctionCalculator));
    add(DelegatedFunction('Round', _roundFunctionCalculator));
    add(DelegatedFunction('Trunc', _truncFunctionCalculator));
    add(DelegatedFunction('Truncate', _truncFunctionCalculator));
    add(DelegatedFunction('Cos', _cosFunctionCalculator));
    add(DelegatedFunction('Sin', _sinFunctionCalculator));
    add(DelegatedFunction('Tan', _tanFunctionCalculator));
    add(DelegatedFunction('Sqr', _sqrtFunctionCalculator));
    add(DelegatedFunction('Sqrt', _sqrtFunctionCalculator));
    add(DelegatedFunction('Empty', _emptyFunctionCalculator));
    add(DelegatedFunction('Null', _nullFunctionCalculator));
    add(DelegatedFunction('Contains', _containsFunctionCalculator));
    add(DelegatedFunction('Array', _arrayFunctionCalculator));
  }

  /// Checks if params contains the correct number of function parameters (must be stored on the top of the params).
  /// - [params] A list of function parameters.
  /// - [expectedParamCount] The expected number of function parameters.
  void checkParamCount(List<Variant> params, int expectedParamCount) {
    var paramCount = params.length;
    if (expectedParamCount != paramCount) {
      throw ExpressionException(null, 'WRONG_PARAM_COUNT',
          'Expected $expectedParamCount parameters but was found $paramCount');
    }
  }

  /// Gets function parameter by it's index.
  /// - [params] A list of function parameters.
  /// - [paramIndex] Index for the function parameter (0 for the first parameter).
  /// Returns Function parameter value.
  Variant getParameter(List<Variant> params, int paramIndex) =>
      params[paramIndex];

  Future<Variant> _ticksFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 0);
    return Future.value(
        Variant.fromLong(DateTime.now().millisecondsSinceEpoch));
  }

  Future<Variant> _timeSpanFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    var paramCount = params.length;
    if (paramCount != 1 &&
        paramCount != 3 &&
        paramCount != 4 &&
        paramCount != 5) {
      throw ExpressionException(
          null, 'WRONG_PARAM_COUNT', 'Expected 1, 3, 4 or 5 parameters');
    }

    var result = Variant();

    if (paramCount == 1) {
      var value =
          variantOperations.convert(getParameter(params, 0), VariantType.Long);
      result.asTimeSpan = value.asLong;
    } else if (paramCount > 2) {
      var value1 =
          variantOperations.convert(getParameter(params, 0), VariantType.Long);
      var value2 =
          variantOperations.convert(getParameter(params, 1), VariantType.Long);
      var value3 =
          variantOperations.convert(getParameter(params, 2), VariantType.Long);
      var value4 = paramCount > 3
          ? variantOperations.convert(getParameter(params, 3), VariantType.Long)
          : Variant.fromLong(0);
      var value5 = paramCount > 4
          ? variantOperations.convert(getParameter(params, 4), VariantType.Long)
          : Variant.fromLong(0);

      result.asTimeSpan =
          (((value1.asLong * 24 + value2.asLong) * 60 + value3.asLong) * 60 +
                      value4.asLong) *
                  1000 +
              value5.asLong;
    }

    return Future.value(result);
  }

  Future<Variant> _nowFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 0);
    return Future.value(Variant.fromDateTime(DateTime.now()));
  }

  Future<Variant> _dateFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    var paramCount = params.length;
    if (paramCount < 1 || paramCount > 7) {
      throw ExpressionException(
          null, 'WRONG_PARAM_COUNT', 'Expected from 1 to 7 parameters');
    }

    if (paramCount == 1) {
      var value =
          variantOperations.convert(getParameter(params, 0), VariantType.Long);
      return Future.value(Variant.fromDateTime(DateTime(value.asLong)));
    }

    var value1 =
        variantOperations.convert(getParameter(params, 0), VariantType.Integer);
    var value2 = paramCount > 1
        ? variantOperations.convert(
            getParameter(params, 1), VariantType.Integer)
        : Variant.fromInteger(1);
    var value3 = paramCount > 2
        ? variantOperations.convert(
            getParameter(params, 2), VariantType.Integer)
        : Variant.fromInteger(1);
    var value4 = paramCount > 3
        ? variantOperations.convert(
            getParameter(params, 3), VariantType.Integer)
        : Variant.fromInteger(0);
    var value5 = paramCount > 4
        ? variantOperations.convert(
            getParameter(params, 4), VariantType.Integer)
        : Variant.fromInteger(0);
    var value6 = paramCount > 5
        ? variantOperations.convert(
            getParameter(params, 5), VariantType.Integer)
        : Variant.fromInteger(0);
    var value7 = paramCount > 6
        ? variantOperations.convert(
            getParameter(params, 6), VariantType.Integer)
        : Variant.fromInteger(0);

    var date = DateTime(
        value1.asInteger,
        value2.asInteger - 1,
        value3.asInteger,
        value4.asInteger,
        value5.asInteger,
        value6.asInteger,
        value7.asInteger);
    return Future.value(Variant.fromDateTime(date));
  }

  Future<Variant> _dayOfWeekFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value = variantOperations.convert(
        getParameter(params, 0), VariantType.DateTime);
    var date = value.asDateTime;
    return Future.value(Variant.fromInteger(date.day));
  }

  Future<Variant> _minFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    var paramCount = params.length;
    if (paramCount < 2) {
      throw ExpressionException(
          null, 'WRONG_PARAM_COUNT', 'Expected at least 2 parameters');
    }
    var result = getParameter(params, 0);
    for (var i = 1; i < paramCount; i++) {
      var value = getParameter(params, i);
      if (variantOperations.more(result, value).asBoolean) {
        result = value;
      }
    }
    return Future.value(result);
  }

  Future<Variant> _maxFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    var paramCount = params.length;
    if (paramCount < 2) {
      throw ExpressionException(
          null, 'WRONG_PARAM_COUNT', 'Expected at least 2 parameters');
    }
    var result = getParameter(params, 0);
    for (var i = 1; i < paramCount; i++) {
      var value = getParameter(params, i);
      if (variantOperations.less(result, value).asBoolean) {
        result = value;
      }
    }
    return Future.value(result);
  }

  Future<Variant> _sumFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    var paramCount = params.length;
    if (paramCount < 2) {
      throw ExpressionException(
          null, 'WRONG_PARAM_COUNT', 'Expected at least 2 parameters');
    }
    var result = getParameter(params, 0);
    for (var i = 1; i < paramCount; i++) {
      var value = getParameter(params, i);
      result = variantOperations.add(result, value);
    }
    return Future.value(result);
  }

  Future<Variant> _ifFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 3);
    var value1 = getParameter(params, 0);
    var value2 = getParameter(params, 1);
    var value3 = getParameter(params, 2);
    var condition = variantOperations.convert(value1, VariantType.Boolean);
    return Future.value(condition.asBoolean ? value2 : value3);
  }

  Future<Variant> _chooseFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    var paramCount = params.length;
    if (paramCount < 3) {
      throw ExpressionException(
          null, 'WRONG_PARAM_COUNT', 'Expected at least 3 parameters');
    }

    var value1 = getParameter(params, 0);
    var condition = variantOperations.convert(value1, VariantType.Integer);
    var paramIndex = condition.asInteger;

    if (paramCount < paramIndex + 1) {
      throw ExpressionException(null, 'WRONG_PARAM_COUNT',
          'Expected at least ${paramIndex + 1} parameters');
    }

    return Future.value(getParameter(params, paramIndex));
  }

  Future<Variant> _eFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 0);
    return Future.value(Variant(math.e));
  }

  Future<Variant> _piFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 0);
    return Future.value(Variant(math.pi));
  }

  Future<Variant> _rndFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 0);
    return Future.value(Variant(math.Random().nextDouble()));
  }

  Future<Variant> _absFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value = getParameter(params, 0);
    var result = Variant();
    switch (value.type) {
      case VariantType.Integer:
        result.asInteger = value.asInteger.abs();
        break;
      case VariantType.Long:
        result.asLong = value.asLong.abs();
        break;
      case VariantType.Float:
        result.asFloat = value.asFloat.abs();
        break;
      case VariantType.Double:
        result.asDouble = value.asDouble.abs();
        break;
      default:
        value = variantOperations.convert(value, VariantType.Double);
        result.asDouble = value.asDouble.abs();
        break;
    }
    return Future.value(result);
  }

  Future<Variant> _acosFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(math.acos(value.asDouble)));
  }

  Future<Variant> _asinFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(math.asin(value.asDouble)));
  }

  Future<Variant> _atanFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(math.atan(value.asDouble)));
  }

  Future<Variant> _expFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(math.exp(value.asDouble)));
  }

  Future<Variant> _logFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(math.log(value.asDouble)));
  }

  Future<Variant> _log10FunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(math.log(value.asDouble) / math.ln10));
  }

  Future<Variant> _ceilFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(value.asDouble.ceil()));
  }

  Future<Variant> _floorFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(value.asDouble.floor()));
  }

  Future<Variant> _roundFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(value.asDouble.round()));
  }

  Future<Variant> _truncFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant.fromInteger(value.asDouble.truncate()));
  }

  Future<Variant> _cosFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(math.cos(value.asDouble)));
  }

  Future<Variant> _sinFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(math.sin(value.asDouble)));
  }

  Future<Variant> _tanFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(math.tan(value.asDouble)));
  }

  Future<Variant> _sqrtFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value =
        variantOperations.convert(getParameter(params, 0), VariantType.Double);
    return Future.value(Variant(math.sqrt(value.asDouble)));
  }

  Future<Variant> _emptyFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 1);
    var value = getParameter(params, 0);
    return Future.value(Variant(value.isEmpty()));
  }

  Future<Variant> _nullFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 0);
    return Future.value(Variant());
  }

  Future<Variant> _containsFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    checkParamCount(params, 2);
    var containerstr =
        variantOperations.convert(getParameter(params, 0), VariantType.String);
    var substring =
        variantOperations.convert(getParameter(params, 1), VariantType.String);

    if (containerstr.isEmpty() || containerstr.isNull()) {
      return Future.value(Variant.fromBoolean(false));
    }

    return Future.value(Variant.fromBoolean(
        containerstr.asString.contains(substring.asString)));
  }

  Future<Variant> _arrayFunctionCalculator(
      List<Variant> params, IVariantOperations variantOperations) {
    return Future.value(Variant.fromArray(params));
  }
}
