import 'package:pip_services4_expressions/src/calculator/functions/functions.dart';
import 'package:pip_services4_expressions/src/calculator/parsers/parsers.dart';
import 'package:pip_services4_expressions/src/calculator/variables/variables.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:pip_services4_expressions/src/variants/variants.dart';

import 'CalculationStack.dart';
import 'ExpressionException.dart';

/// Implements an expression calculator class.
class ExpressionCalculator {
  final IVariableCollection _defaultVariables = VariableCollection();
  final IFunctionCollection _defaultFunctions = DefaultFunctionCollection();
  IVariantOperations _variantOperations = TypeUnsafeVariantOperations();
  final ExpressionParser _parser = ExpressionParser();
  bool _autoVariables = true;

  /// Constructs this class and assigns expression string.
  /// - [expression] The expression string.
  ExpressionCalculator([String? expression]) {
    if (expression != null) {
      this.expression = expression;
    }
  }

  /// The expression string.
  String? get expression => _parser.expression;

  /// The expression string.
  set expression(String? value) {
    _parser.expression = value;
    if (_autoVariables) {
      createVariables(_defaultVariables);
    }
  }

  List<Token> get originalTokens => _parser.originalTokens;

  set originalTokens(List<Token> value) {
    _parser.originalTokens = value;
    if (_autoVariables) {
      createVariables(_defaultVariables);
    }
  }

  /// Gets the flag to turn on auto creation of variables for specified expression.
  bool get autoVariables => _autoVariables;

  /// Sets the flag to turn on auto creation of variables for specified expression.
  set autoVariables(bool value) => _autoVariables = value;

  /// Gets the manager for operations on variant values.
  IVariantOperations get variantOperations => _variantOperations;

  /// Sets the manager for operations on variant values.
  set variantOperations(IVariantOperations value) => _variantOperations = value;

  /// The list with default variables.
  IVariableCollection get defaultVariables => _defaultVariables;

  /// The list with default functions.
  IFunctionCollection get defaultFunctions => _defaultFunctions;

  /// The list of original expression tokens.
  List<ExpressionToken> get initialTokens => _parser.initialTokens;

  /// The list of processed expression tokens.
  List<ExpressionToken> get resultTokens => _parser.resultTokens;

  /// Populates the specified variables list with variables from parsed expression.
  /// - [variables] The list of variables to be populated.
  void createVariables(IVariableCollection variables) {
    for (var variableName in _parser.variableNames) {
      if (variables.findByName(variableName) == null) {
        variables.add(Variable(variableName));
      }
    }
  }

  /// Cleans up this calculator from all data.
  void clear() {
    _parser.clear();
    _defaultVariables.clear();
  }

  /// Evaluates this expression using default variables and functions.
  /// Returns the evaluation result.
  Future<Variant> evaluate() async {
    return await evaluateWithVariablesAndFunctions(null, null);
  }

  /// Evaluates this expression using specified variables.
  /// - [variables] The list of variables
  /// Returns the evaluation result
  Future<Variant> evaluateWithVariables(IVariableCollection variables) async {
    return await evaluateWithVariablesAndFunctions(variables, null);
  }

  /// Evaluates this expression using specified variables and functions.
  /// - [variables] The list of variables
  /// - [functions] The list of functions
  /// Returns the evaluation result
  Future<Variant> evaluateWithVariablesAndFunctions(
      IVariableCollection? variables, IFunctionCollection? functions) async {
    var stack = CalculationStack();
    variables = variables ?? _defaultVariables;
    functions = functions ?? _defaultFunctions;

    for (var token in resultTokens) {
      if (await _evaluateConstant(token, stack)) {
        continue;
      }
      if (await _evaluateVariable(token, stack, variables)) {
        continue;
      }
      if (await _evaluateFunction(token, stack, functions)) {
        continue;
      }
      if (await _evaluateLogical(token, stack)) {
        continue;
      }
      if (await _evaluateArithmetical(token, stack)) {
        continue;
      }
      if (await _evaluateBoolean(token, stack)) {
        continue;
      }
      if (await _evaluateOther(token, stack)) {
        continue;
      }
      throw ExpressionException(
          null, 'INTERNAL', 'Internal error', token.line, token.column);
    }

    if (stack.length != 1) {
      throw ExpressionException(null, 'INTERNAL', 'Internal error', 0, 0);
    }

    return Future.value(stack.pop());
  }

  Future<bool> _evaluateConstant(
      ExpressionToken token, CalculationStack stack) {
    if (token.type != ExpressionTokenType.Constant) {
      return Future.value(false);
    }

    stack.push(token.value);
    return Future.value(true);
  }

  Future<bool> _evaluateVariable(ExpressionToken token, CalculationStack stack,
      IVariableCollection variables) {
    if (token.type != ExpressionTokenType.Variable) {
      return Future.value(false);
    }

    var variable = variables.findByName(token.value.asString);
    if (variable == null) {
      throw ExpressionException(
          null,
          'VAR_NOT_FOUND',
          'Variable ${token.value.asString} was not found',
          token.line,
          token.column);
    }

    stack.push(variable.value);
    return Future.value(true);
  }

  Future<bool> _evaluateFunction(ExpressionToken token, CalculationStack stack,
      IFunctionCollection functions) async {
    if (token.type != ExpressionTokenType.Function) {
      return Future.value(false);
    }

    var func = functions.findByName(token.value.asString);
    if (func == null) {
      throw ExpressionException(
          null,
          'FUNC_NOT_FOUND',
          'Function ${token.value.asString} was not found',
          token.line,
          token.column);
    }

    // Retrieve function parameters
    var params = <Variant>[];
    var paramCount = stack.pop().asInteger;
    while (paramCount > 0) {
      params.insert(0, stack.pop());
      paramCount--;
    }

    var functionResult = await func.calculate(params, _variantOperations);
    stack.push(functionResult);
    return true;
  }

  Future<bool> _evaluateLogical(ExpressionToken token, CalculationStack stack) {
    switch (token.type) {
      case ExpressionTokenType.And:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.and(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.Or:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.or(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.Xor:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.xor(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.Not:
        {
          stack.push(_variantOperations.not(stack.pop()));
          return Future.value(true);
        }
      default:
        return Future.value(false);
    }
  }

  Future<bool> _evaluateArithmetical(
      ExpressionToken token, CalculationStack stack) {
    switch (token.type) {
      case ExpressionTokenType.Plus:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.add(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.Minus:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.sub(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.Star:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.mul(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.Slash:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.div(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.Procent:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.mod(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.Power:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.pow(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.Unary:
        {
          stack.push(_variantOperations.negative(stack.pop()));
          return Future.value(true);
        }
      case ExpressionTokenType.ShiftLeft:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.lsh(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.ShiftRight:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.rsh(value1, value2));
          return Future.value(true);
        }
      default:
        return Future.value(false);
    }
  }

  Future<bool> _evaluateBoolean(ExpressionToken token, CalculationStack stack) {
    switch (token.type) {
      case ExpressionTokenType.Equal:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.equal(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.NotEqual:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.notEqual(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.More:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.more(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.Less:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.less(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.EqualMore:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.moreEqual(value1, value2));
          return Future.value(true);
        }
      case ExpressionTokenType.EqualLess:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          stack.push(_variantOperations.lessEqual(value1, value2));
          return Future.value(true);
        }
      default:
        return Future.value(false);
    }
  }

  Future<bool> _evaluateOther(ExpressionToken token, CalculationStack stack) {
    switch (token.type) {
      case ExpressionTokenType.In:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          var rvalue = _variantOperations.in_(value2, value1);
          stack.push(rvalue);
          return Future.value(true);
        }
      case ExpressionTokenType.NotIn:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          var rvalue = _variantOperations.in_(value2, value1);
          rvalue = Variant.fromBoolean(!rvalue.asBoolean);
          stack.push(rvalue);
          return Future.value(true);
        }
      case ExpressionTokenType.Element:
        {
          var value2 = stack.pop();
          var value1 = stack.pop();
          var rvalue = _variantOperations.getElement(value1, value2);
          stack.push(rvalue);
          return Future.value(true);
        }
      case ExpressionTokenType.IsNull:
        {
          var rvalue = Variant(stack.pop().isNull());
          stack.push(rvalue);
          return Future.value(true);
        }
      case ExpressionTokenType.IsNotNull:
        {
          var rvalue = Variant(!stack.pop().isNull());
          stack.push(rvalue);
          return Future.value(true);
        }
      default:
        return Future.value(false);
    }
  }
}
