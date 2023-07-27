import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';

import 'MustacheException.dart';
import 'parsers/parsers.dart';

/// Implements an mustache template class.
class MustacheTemplate {
  final Map<String, dynamic> _defaultVariables = {};
  final _parser = MustacheParser();
  bool _autoVariables = true;

  /// Constructs this class and assigns mustache template.
  /// - [template] The mustache template.
  MustacheTemplate([String? mustacheTemplate]) {
    if (mustacheTemplate != null) {
      template = mustacheTemplate;
    }
  }

  /// The mustache template.
  String get template => _parser.template;

  /// The mustache template.
  set template(String value) {
    _parser.template = value;
    if (_autoVariables) {
      createVariables(_defaultVariables);
    }
  }

  /// List of original Mustache tokens.
  List<Token> get originalTokens => _parser.originalTokens;

  /// Sets list of original Mustache tokens.
  set originalTokens(List<Token> value) {
    _parser.originalTokens = value;
    if (_autoVariables) {
      createVariables(_defaultVariables);
    }
  }

  /// Gets the flag to turn on auto creation of variables for specified mustache.
  bool get autoVariables => _autoVariables;

  /// Sets the flag to turn on auto creation of variables for specified mustache.
  set autoVariables(bool value) {
    _autoVariables = value;
  }

  /// The list with default variables.
  Map<String, dynamic> get defaultVariables => _defaultVariables;

  /// The list of original mustache tokens.
  List<MustacheToken> get initialTokens => _parser.initialTokens;

  /// The list of processed mustache tokens.
  List<MustacheToken> get resultTokens => _parser.resultTokens;

  /// Gets a variable value from the collection of variables
  /// - [variables] a collection of variables.
  /// - [name] a variable name to get.
  /// Returns a variable value or `null`
  dynamic getVariable(Map<String, dynamic>? variables, String? name) {
    if (variables == null || name == null) return null;

    name = name.toLowerCase();
    dynamic result;

    for (var propName in variables.keys) {
      if (propName.toLowerCase() == name) {
        result = result ?? variables[propName];
      }
    }

    return result;
  }

  /// Populates the specified variables list with variables from parsed mustache.
  /// - [variables] The list of variables to be populated.
  void createVariables(Map<String, dynamic>? variables) {
    if (variables == null) return;

    for (var variableName in _parser.variableNames) {
      var found = getVariable(variables, variableName) != null;
      if (!found) {
        variables[variableName] = null;
      }
    }
  }

  /// Cleans up this calculator from all data.
  void clear() {
    _parser.clear();
    _defaultVariables.clear();
  }

  /// Evaluates this mustache template using default variables.
  /// Returns the evaluated template
  String? evaluate() {
    return evaluateWithVariables(null);
  }

  /// Evaluates this mustache using specified variables.
  /// - [variables] The collection of variables
  /// Returns the evaluated template
  String? evaluateWithVariables(Map<String, dynamic>? variables) {
    variables = variables ?? _defaultVariables;

    return _evaluateTokens(_parser.resultTokens, variables);
  }

  bool _isDefinedVariable(Map<String, dynamic>? variables, String? name) {
    var value = getVariable(variables, name);
    return value != null && value != '' && value != false;
  }

  String? _escapeString(String? value) {
    if (value == null) return null;

    return value
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('/', '\\/')
        .replaceAll('\b', '\\b')
        .replaceAll('\f', '\\f')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  String? _evaluateTokens(
      List<MustacheToken>? tokens, Map<String, dynamic>? variables) {
    if (tokens == null) return null;

    var result = '';

    for (var token in tokens) {
      switch (token.type) {
        case MustacheTokenType.Comment:
          // Skip;
          break;
        case MustacheTokenType.Value:
          result += token.value ?? '';
          break;
        case MustacheTokenType.Variable:
          var value1 = getVariable(variables, token.value);
          result += value1 ?? '';
          break;
        case MustacheTokenType.EscapedVariable:
          var value2 = getVariable(variables, token.value);
          value2 = _escapeString(value2);
          result += value2 ?? '';
          break;
        case MustacheTokenType.Section:
          var defined1 = _isDefinedVariable(variables, token.value);
          if (defined1 && token.tokens.isNotEmpty) {
            result += _evaluateTokens(token.tokens, variables) ?? '';
          }
          break;
        case MustacheTokenType.InvertedSection:
          var defined2 = _isDefinedVariable(variables, token.value);
          if (!defined2 && token.tokens.isNotEmpty) {
            result += _evaluateTokens(token.tokens, variables) ?? '';
          }
          break;
        case MustacheTokenType.Partial:
          throw MustacheException(null, 'PARTIALS_NOT_SUPPORTED',
              'Partials are not supported', token.line, token.column);
        default:
          throw MustacheException(
              null, 'INTERNAL', 'Internal error', token.line, token.column);
      }
    }

    return result != '' ? result : null;
  }
}
