import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_expressions/src/calculator/tokenizers/ExpressionTokenizer.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:pip_services4_expressions/src/variants/Variant.dart';

import '../SyntaxErrorCode.dart';
import '../SyntaxException.dart';
import 'ExpressionToken.dart';
import 'ExpressionTokenType.dart';

/// Implements an expression parser class.
class ExpressionParser {
  /// Defines a list of operators.
  final List<String> _Operators = [
    '(',
    ')',
    '[',
    ']',
    '+',
    '-',
    '*',
    '/',
    '%',
    '^',
    '=',
    '<>',
    '!=',
    '>',
    '<',
    '>=',
    '<=',
    '<<',
    '>>',
    'AND',
    'OR',
    'XOR',
    'NOT',
    'IS',
    'IN',
    'NULL',
    'LIKE',
    ','
  ];

  /// Defines a list of operator token types.
  /// Note: it must match to operators.
  final List<ExpressionTokenType> _OperatorTypes = [
    ExpressionTokenType.LeftBrace,
    ExpressionTokenType.RightBrace,
    ExpressionTokenType.LeftSquareBrace,
    ExpressionTokenType.RightSquareBrace,
    ExpressionTokenType.Plus,
    ExpressionTokenType.Minus,
    ExpressionTokenType.Star,
    ExpressionTokenType.Slash,
    ExpressionTokenType.Procent,
    ExpressionTokenType.Power,
    ExpressionTokenType.Equal,
    ExpressionTokenType.NotEqual,
    ExpressionTokenType.NotEqual,
    ExpressionTokenType.More,
    ExpressionTokenType.Less,
    ExpressionTokenType.EqualMore,
    ExpressionTokenType.EqualLess,
    ExpressionTokenType.ShiftLeft,
    ExpressionTokenType.ShiftRight,
    ExpressionTokenType.And,
    ExpressionTokenType.Or,
    ExpressionTokenType.Xor,
    ExpressionTokenType.Not,
    ExpressionTokenType.Is,
    ExpressionTokenType.In,
    ExpressionTokenType.Null,
    ExpressionTokenType.Like,
    ExpressionTokenType.Comma
  ];

  final ITokenizer _tokenizer = ExpressionTokenizer();
  String? _expression;
  List<Token> _originalTokens = [];
  List<ExpressionToken> _initialTokens = [];
  int _currentTokenIndex = 0;
  List<String> _variableNames = [];
  List<ExpressionToken> _resultTokens = [];

  /// The expression string.
  String? get expression => _expression;

  /// The expression string.
  set expression(String? value) => parseString(value);

  List<Token> get originalTokens => _originalTokens;

  set originalTokens(List<Token> value) => parseTokens(value);

  /// The list of original expression tokens.
  List<ExpressionToken> get initialTokens => _initialTokens;

  /// The list of parsed expression tokens.
  List<ExpressionToken> get resultTokens => _resultTokens;

  /// The list of found variable names.
  List<String> get variableNames => _variableNames;

  /// Sets a new expression string and parses it into internal byte code.
  /// - [expression] A new expression string.
  void parseString(String? expression) {
    clear();
    _expression = expression != null ? expression.trim() : '';
    _originalTokens = _tokenizeExpression(_expression);
    _performParsing();
  }

  void parseTokens(List<Token> tokens) {
    clear();
    _originalTokens = tokens;
    _expression = _composeExpression(tokens);
    _performParsing();
  }

  /// Clears parsing results.
  void clear() {
    _expression = null;
    _originalTokens = [];
    _initialTokens = [];
    _resultTokens = [];
    _currentTokenIndex = 0;
    _variableNames = [];
  }

  /// Checks are there more tokens for processing.
  /// Returns `true` if some tokens are present.
  bool _hasMoreTokens() {
    return _currentTokenIndex < _initialTokens.length;
  }

  /// Checks are there more tokens available and throws exception if no more tokens available.
  void _checkForMoreTokens() {
    if (!_hasMoreTokens()) {
      throw SyntaxException(null, SyntaxErrorCode.UnexpectedEnd,
          'Unexpected end of expression.', 0, 0);
    }
  }

  /// Gets the current token object.
  /// Returns The current token object.
  ExpressionToken? _getCurrentToken() {
    return _currentTokenIndex < _initialTokens.length
        ? _initialTokens[_currentTokenIndex]
        : null;
  }

  /// Gets the next token object.
  /// Returns The next token object.
  ExpressionToken? _getNextToken() {
    return (_currentTokenIndex + 1) < _initialTokens.length
        ? _initialTokens[_currentTokenIndex + 1]
        : null;
  }

  /// Moves to the next token object.
  void _moveToNextToken() {
    _currentTokenIndex++;
  }

  /// Adds an expression to the result list
  /// - [type] The type of the token to be added.
  /// - [value] The value of the token to be added.
  /// - [line] The line number where the token is.
  /// - [column] The column number where the token is.
  void _addTokenToResult(
      ExpressionTokenType? type, Variant? value, int? line, int? column) {
    _resultTokens.add(ExpressionToken(type, value, line, column));
  }

  /// Matches available tokens types with types from the list.
  ///
  /// If tokens matchs then shift the list.
  /// - [types] A list of token types to compare.
  /// Returns `true` if token types match.
  bool _matchTokensWithTypes(List<ExpressionTokenType> types) {
    var matches = false;
    for (var i = 0; i < types.length; i++) {
      if (_currentTokenIndex + i < _initialTokens.length) {
        matches = _initialTokens[_currentTokenIndex + i].type == types[i];
      } else {
        matches = false;
        break;
      }
    }

    if (matches) {
      _currentTokenIndex += types.length;
    }
    return matches;
  }

  List<Token> _tokenizeExpression(String? expression) {
    expression = expression != null ? expression.trim() : '';
    if (expression.isNotEmpty) {
      _tokenizer.skipWhitespaces = true;
      _tokenizer.skipComments = true;
      _tokenizer.skipEof = true;
      _tokenizer.decodeStrings = true;
      return _tokenizer.tokenizeBuffer(expression);
    } else {
      return [];
    }
  }

  String _composeExpression(List<Token> tokens) {
    var builder = '';
    for (var token in tokens) {
      builder = builder + (token.value ?? '');
    }
    return builder;
  }

  void _performParsing() {
    if (_originalTokens.isNotEmpty) {
      _completeLexicalAnalysis();
      _performSyntaxAnalysis();
      if (_hasMoreTokens()) {
        var token = _getCurrentToken();
        throw SyntaxException(
            null,
            SyntaxErrorCode.ErrorNear,
            'Syntax error near ${token?.value.toString2() ?? ''}',
            token?.line ?? 0,
            token?.column ?? 0);
      }
    }
  }

  /// Tokenizes the given expression and prepares an initial tokens list.
  void _completeLexicalAnalysis() {
    for (var token in _originalTokens) {
      var tokenType = ExpressionTokenType.Unknown;
      var tokenValue = Variant.Empty;

      switch (token.type) {
        case TokenType.Comment:
        case TokenType.Whitespace:
          continue;
        case TokenType.Keyword:
          {
            var temp = token.value?.toUpperCase();
            if (temp == 'TRUE') {
              tokenType = ExpressionTokenType.Constant;
              tokenValue = Variant.fromBoolean(true);
            } else if (temp == 'FALSE') {
              tokenType = ExpressionTokenType.Constant;
              tokenValue = Variant.fromBoolean(false);
            } else {
              for (var index = 0; index < _Operators.length; index++) {
                if (temp == _Operators[index]) {
                  tokenType = _OperatorTypes[index];
                  break;
                }
              }
            }
            break;
          }
        case TokenType.Word:
          {
            tokenType = ExpressionTokenType.Variable;
            tokenValue = Variant.fromString(token.value ?? '');
            break;
          }
        case TokenType.Integer:
          {
            tokenType = ExpressionTokenType.Constant;
            tokenValue =
                Variant.fromInteger(IntegerConverter.toInteger(token.value));
            break;
          }
        case TokenType.Float:
          {
            tokenType = ExpressionTokenType.Constant;
            tokenValue = Variant.fromFloat(FloatConverter.toFloat(token.value));
            break;
          }
        case TokenType.Quoted:
          {
            tokenType = ExpressionTokenType.Constant;
            tokenValue = Variant.fromString(token.value ?? '');
            break;
          }
        case TokenType.Symbol:
          {
            var temp = token.value?.toUpperCase();
            for (var i = 0; i < _Operators.length; i++) {
              if (temp == _Operators[i]) {
                tokenType = _OperatorTypes[i];
                break;
              }
            }
            break;
          }
        case TokenType.Unknown:
        case TokenType.Eof:
        case TokenType.Eol:
        case TokenType.HexDecimal:
        case TokenType.Number:
        case TokenType.Special:
          break;
      }
      if (tokenType == ExpressionTokenType.Unknown) {
        throw SyntaxException(null, SyntaxErrorCode.UnknownSymbol,
            'Unknown symbol ${token.value ?? ''}', token.line, token.column);
      }
      _initialTokens.add(
          ExpressionToken(tokenType, tokenValue, token.line, token.column));
    }
  }

  /// Performs a syntax analysis at level 0.
  void _performSyntaxAnalysis() {
    _checkForMoreTokens();
    _performSyntaxAnalysisAtLevel1();
    while (_hasMoreTokens()) {
      var token = _getCurrentToken();
      if (token?.type == ExpressionTokenType.And ||
          token?.type == ExpressionTokenType.Or ||
          token?.type == ExpressionTokenType.Xor) {
        _moveToNextToken();
        _performSyntaxAnalysisAtLevel1();
        _addTokenToResult(token?.type ?? ExpressionTokenType.Unknown,
            Variant.Empty, token?.line, token?.column ?? 0);
        continue;
      }
      break;
    }
  }

  /// Performs a syntax analysis at level 1.
  void _performSyntaxAnalysisAtLevel1() {
    _checkForMoreTokens();
    var token = _getCurrentToken();
    if (token?.type == ExpressionTokenType.Not) {
      _moveToNextToken();
      _performSyntaxAnalysisAtLevel2();
      _addTokenToResult(token?.type, Variant.Empty, token?.line, token?.column);
    } else {
      _performSyntaxAnalysisAtLevel2();
    }
  }

  /// Performs a syntax analysis at level 2.
  void _performSyntaxAnalysisAtLevel2() {
    _checkForMoreTokens();
    _performSyntaxAnalysisAtLevel3();
    while (_hasMoreTokens()) {
      var token = _getCurrentToken();
      if (token?.type == ExpressionTokenType.Equal ||
          token?.type == ExpressionTokenType.NotEqual ||
          token?.type == ExpressionTokenType.More ||
          token?.type == ExpressionTokenType.Less ||
          token?.type == ExpressionTokenType.EqualMore ||
          token?.type == ExpressionTokenType.EqualLess) {
        _moveToNextToken();
        _performSyntaxAnalysisAtLevel3();
        _addTokenToResult(
            token?.type, Variant.Empty, token?.line, token?.column);
        continue;
      }
      break;
    }
  }

  /// Performs a syntax analysis at level 3.
  void _performSyntaxAnalysisAtLevel3() {
    _checkForMoreTokens();
    _performSyntaxAnalysisAtLevel4();
    while (_hasMoreTokens()) {
      var token = _getCurrentToken();
      if (token?.type == ExpressionTokenType.Plus ||
          token?.type == ExpressionTokenType.Minus ||
          token?.type == ExpressionTokenType.Like) {
        _moveToNextToken();
        _performSyntaxAnalysisAtLevel4();
        _addTokenToResult(
            token?.type, Variant.Empty, token?.line, token?.column);
      } else if (_matchTokensWithTypes(
          [ExpressionTokenType.Not, ExpressionTokenType.Like])) {
        _performSyntaxAnalysisAtLevel4();
        _addTokenToResult(ExpressionTokenType.NotLike, Variant.Empty,
            token?.line, token?.column);
      } else if (_matchTokensWithTypes(
          [ExpressionTokenType.Is, ExpressionTokenType.Null])) {
        _addTokenToResult(ExpressionTokenType.IsNull, Variant.Empty,
            token?.line, token?.column);
      } else if (_matchTokensWithTypes([
        ExpressionTokenType.Is,
        ExpressionTokenType.Not,
        ExpressionTokenType.Null
      ])) {
        _addTokenToResult(ExpressionTokenType.IsNotNull, Variant.Empty,
            token?.line, token?.column);
      } else if (_matchTokensWithTypes(
          [ExpressionTokenType.Not, ExpressionTokenType.In])) {
        _performSyntaxAnalysisAtLevel4();
        _addTokenToResult(ExpressionTokenType.NotIn, Variant.Empty, token?.line,
            token?.column);
      } else {
        break;
      }
    }
  }

  /// Performs a syntax analysis at level 4.
  void _performSyntaxAnalysisAtLevel4() {
    _checkForMoreTokens();
    _performSyntaxAnalysisAtLevel5();
    while (_hasMoreTokens()) {
      var token = _getCurrentToken();
      if (token?.type == ExpressionTokenType.Star ||
          token?.type == ExpressionTokenType.Slash ||
          token?.type == ExpressionTokenType.Procent) {
        _moveToNextToken();
        _performSyntaxAnalysisAtLevel5();
        _addTokenToResult(
            token?.type, Variant.Empty, token?.line, token?.column);
        continue;
      }
      break;
    }
  }

  /// Performs a syntax analysis at level 5.
  void _performSyntaxAnalysisAtLevel5() {
    _checkForMoreTokens();
    _performSyntaxAnalysisAtLevel6();
    while (_hasMoreTokens()) {
      var token = _getCurrentToken();
      if (token?.type == ExpressionTokenType.Power ||
          token?.type == ExpressionTokenType.In ||
          token?.type == ExpressionTokenType.ShiftLeft ||
          token?.type == ExpressionTokenType.ShiftRight) {
        _moveToNextToken();
        _performSyntaxAnalysisAtLevel6();
        _addTokenToResult(
            token?.type, Variant.Empty, token?.line, token?.column);
        continue;
      }
      break;
    }
  }

  /// Performs a syntax analysis at level 6.
  void _performSyntaxAnalysisAtLevel6() {
    _checkForMoreTokens();
    // Process unary '+' or '-'.
    var unaryToken = _getCurrentToken();
    if (unaryToken?.type == ExpressionTokenType.Plus) {
      unaryToken = null;
      _moveToNextToken();
    } else if (unaryToken?.type == ExpressionTokenType.Minus) {
      unaryToken = ExpressionToken(ExpressionTokenType.Unary, unaryToken?.value,
          unaryToken?.line, unaryToken?.line);
      _moveToNextToken();
    } else {
      unaryToken = null;
    }

    _checkForMoreTokens();

    // Identify function calls.
    var primitiveToken = _getCurrentToken();
    var nextToken = _getNextToken();
    if (primitiveToken?.type == ExpressionTokenType.Variable &&
        nextToken != null &&
        nextToken.type == ExpressionTokenType.LeftBrace) {
      primitiveToken = ExpressionToken(ExpressionTokenType.Function,
          primitiveToken!.value, primitiveToken.line, primitiveToken.column);
    }

    if (primitiveToken?.type == ExpressionTokenType.Constant) {
      _moveToNextToken();
      _addTokenToResult(primitiveToken?.type, primitiveToken?.value,
          primitiveToken?.line, primitiveToken?.column);
    } else if (primitiveToken?.type == ExpressionTokenType.Variable) {
      _moveToNextToken();

      var temp = primitiveToken?.value.asString;
      if (temp != null && !_variableNames.contains(temp)) {
        _variableNames.add(temp);
      }

      _addTokenToResult(primitiveToken?.type, primitiveToken?.value,
          primitiveToken?.line, primitiveToken?.column);
    } else if (primitiveToken?.type == ExpressionTokenType.LeftBrace) {
      _moveToNextToken();
      _performSyntaxAnalysis();
      _checkForMoreTokens();
      primitiveToken = _getCurrentToken();
      if (primitiveToken?.type != ExpressionTokenType.RightBrace) {
        throw SyntaxException(
            null,
            SyntaxErrorCode.MissedCloseParenthesis,
            "Expected ')' was not found",
            primitiveToken?.line,
            primitiveToken?.column);
      }
      _moveToNextToken();
    } else if (primitiveToken?.type == ExpressionTokenType.Function) {
      _moveToNextToken();
      var token = _getCurrentToken();
      if (token?.type != ExpressionTokenType.LeftBrace) {
        throw SyntaxException(null, SyntaxErrorCode.Internal, 'Internal error',
            token?.line, token?.column);
      }
      var paramCount = 0;
      do {
        _moveToNextToken();
        token = _getCurrentToken();
        if (token == null || token.type == ExpressionTokenType.RightBrace) {
          break;
        }
        paramCount++;
        _performSyntaxAnalysis();
        token = _getCurrentToken();
      } while (token != null && token.type == ExpressionTokenType.Comma);

      _checkForMoreTokens();

      if (token?.type != ExpressionTokenType.RightBrace) {
        throw SyntaxException(null, SyntaxErrorCode.MissedCloseParenthesis,
            "Expected ')' was not found", token?.line, token?.column);
      }
      _moveToNextToken();

      _addTokenToResult(ExpressionTokenType.Constant, Variant(paramCount),
          primitiveToken?.line, primitiveToken?.column);
      _addTokenToResult(primitiveToken?.type, primitiveToken?.value,
          primitiveToken?.line, primitiveToken?.column);
    } else {
      throw SyntaxException(
          null,
          SyntaxErrorCode.ErrorAt,
          'Syntax error at ${primitiveToken?.value.toString2() ?? ''}',
          primitiveToken?.line,
          primitiveToken?.column);
    }

    if (unaryToken != null) {
      _addTokenToResult(
          unaryToken.type, Variant.Empty, unaryToken.line, unaryToken.column);
    }

    // Process [] operator.
    if (_hasMoreTokens()) {
      primitiveToken = _getCurrentToken();
      if (primitiveToken?.type == ExpressionTokenType.LeftSquareBrace) {
        _moveToNextToken();
        _performSyntaxAnalysis();
        _checkForMoreTokens();
        primitiveToken = _getCurrentToken();
        if (primitiveToken?.type != ExpressionTokenType.RightSquareBrace) {
          throw SyntaxException(
              null,
              SyntaxErrorCode.MissedCloseSquareBracket,
              "Expected ']' was not found",
              primitiveToken?.line,
              primitiveToken?.column);
        }
        _moveToNextToken();
        _addTokenToResult(ExpressionTokenType.Element, Variant.Empty,
            primitiveToken?.line, primitiveToken?.column);
      }
    }
  }
}
