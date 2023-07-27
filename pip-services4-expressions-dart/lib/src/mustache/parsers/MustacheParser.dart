import 'package:pip_services4_expressions/src/mustache/parsers/MustacheToken.dart';
import 'package:pip_services4_expressions/src/mustache/tokenizers/tokenizers.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';

import '../MustacheException.dart';
import 'MustacheErrorCode.dart';
import 'MustacheLexicalState.dart';
import 'MustacheTokenType.dart';

/// Implements an mustache parser class.
class MustacheParser {
  final ITokenizer _tokenizer = MustacheTokenizer();
  String _template = '';
  var _originalTokens = <Token>[];
  final _initialTokens = <MustacheToken>[];
  int _currentTokenIndex = 0;
  final _variableNames = <String>[];
  final _resultTokens = <MustacheToken>[];

  /// The mustache template.
  String get template => _template;

  /// The mustache template.
  set template(String value) {
    parseString(value);
  }

  List<Token> get originalTokens => _originalTokens;

  set originalTokens(List<Token> value) {
    parseTokens(value);
  }

  /// The list of original mustache tokens.
  List<MustacheToken> get initialTokens => _initialTokens;

  /// The list of parsed mustache tokens.
  List<MustacheToken> get resultTokens => _resultTokens;

  /// The list of found variable names.
  List<String> get variableNames => _variableNames;

  /// Sets a new mustache string and parses it into internal byte code.
  /// - [mustache] A new mustache string.
  void parseString(String? mustache) {
    clear();
    _template = mustache != null ? mustache.trim() : '';
    _originalTokens = _tokenizeMustache(_template);
    _performParsing();
  }

  /// Sets a new mustache Token and parses it into internal byte code.
  /// - [tokens] Mustache tokens.
  void parseTokens(List<Token> tokens) {
    clear();
    originalTokens = tokens;
    _template = _composeMustache(tokens);
    _performParsing();
  }

  void clear() {
    _template = '';
    _originalTokens.clear();
    _initialTokens.clear();
    _resultTokens.clear();
    _currentTokenIndex = 0;
    _variableNames.clear();
  }

  /// Checks are there more tokens for processing.
  /// Returns `true` if some tokens are present.
  bool _hasMoreTokens() {
    return _currentTokenIndex < _initialTokens.length;
  }

  /// Checks are there more tokens available and throws exception if no more tokens available.
  void _checkForMoreTokens() {
    if (!_hasMoreTokens()) {
      throw MustacheException(null, MustacheErrorCode.UnexpectedEnd,
          'Unexpected end of mustache', 0, 0);
    }
  }

  /// Gets the current token object.
  /// Returns The current token object.
  MustacheToken? _getCurrentToken() {
    return _currentTokenIndex < _initialTokens.length
        ? _initialTokens[_currentTokenIndex]
        : null;
  }

  /// Gets the next token object.
  /// Returns The next token object.
  MustacheToken? _getNextToken() {
    return (_currentTokenIndex + 1) < _initialTokens.length
        ? _initialTokens[_currentTokenIndex + 1]
        : null;
  }

  /// Moves to the next token object.
  void _moveToNextToken() {
    _currentTokenIndex++;
  }

  /// Adds an mustache to the result list
  /// - [type] The type of the token to be added.
  /// - [value] The value of the token to be added.
  /// - [line] The line where the token is.
  /// - [column] The column number where the token is.
  /// Returns result MustacheToken
  MustacheToken _addTokenToResult(
      MustacheTokenType? type, String? value, int? line, int? column) {
    type = type ?? MustacheTokenType.Unknown;
    var token = MustacheToken(type, value, line, column);
    _resultTokens.add(token);
    return token;
  }

  List<Token> _tokenizeMustache(String? mustache) {
    mustache = mustache != null ? mustache.trim() : '';
    if (mustache.isNotEmpty) {
      _tokenizer.skipWhitespaces = true;
      _tokenizer.skipComments = true;
      _tokenizer.skipEof = true;
      _tokenizer.decodeStrings = true;
      return _tokenizer.tokenizeBuffer(mustache);
    } else {
      return [];
    }
  }

  String _composeMustache(List<Token> tokens) {
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
        throw MustacheException(
            null,
            MustacheErrorCode.ErrorNear,
            'Syntax error near ${token?.value}',
            token?.line ?? 0,
            token?.column ?? 0);
      }
      _lookupVariables();
    }
  }

  /// Tokenizes the given mustache and prepares an initial tokens list.
  void _completeLexicalAnalysis() {
    var state = MustacheLexicalState.Value;
    String? closingBracket;
    String? operator1;
    String? operator2;
    String? variable;

    for (var token in _originalTokens) {
      var tokenType = MustacheTokenType.Unknown;
      String? tokenValue;

      if (state == MustacheLexicalState.Comment) {
        if (token.value == '}}' || token.value == '}}}') {
          state = MustacheLexicalState.Closure;
        } else {
          continue;
        }
      }

      switch (token.type) {
        case TokenType.Special:
          if (state == MustacheLexicalState.Value) {
            tokenType = MustacheTokenType.Value;
            tokenValue = token.value;
          }
          break;
        case TokenType.Symbol:
          if (state == MustacheLexicalState.Value &&
              (token.value == '{{' || token.value == '{{{')) {
            closingBracket = token.value == '{{' ? '}}' : '}}}';
            state = MustacheLexicalState.Operator1;
            continue;
          }
          if (state == MustacheLexicalState.Operator1 && token.value == '!') {
            operator1 = token.value;
            state = MustacheLexicalState.Comment;
            continue;
          }
          if (state == MustacheLexicalState.Operator1 &&
              (token.value == '/' ||
                  token.value == '#' ||
                  token.value == '^')) {
            operator1 = token.value;
            state = MustacheLexicalState.Operator2;
            continue;
          }

          if (state == MustacheLexicalState.Variable &&
              (token.value == '}}' || token.value == '}}}')) {
            if (operator1 != '/') {
              variable = operator2;
              operator2 = null;
            }
            state = MustacheLexicalState.Closure;
            // Pass through
          }
          if (state == MustacheLexicalState.Closure &&
              (token.value == '}}' || token.value == '}}}')) {
            if (closingBracket != token.value) {
              throw MustacheException(
                  null,
                  MustacheErrorCode.MismatchedBrackets,
                  "Mismatched brackets. Expected '${closingBracket!}'",
                  token.line,
                  token.column);
            }

            if (operator1 == '#' && (operator2 == null || operator2 == 'if')) {
              tokenType = MustacheTokenType.Section;
              tokenValue = variable;
            }

            if (operator1 == '#' && operator2 == 'unless') {
              tokenType = MustacheTokenType.InvertedSection;
              tokenValue = variable;
            }

            if (operator1 == '^' && operator2 == null) {
              tokenType = MustacheTokenType.InvertedSection;
              tokenValue = variable;
            }

            if (operator1 == '/') {
              tokenType = MustacheTokenType.SectionEnd;
              tokenValue = variable;
            }

            if (operator1 == null) {
              tokenType = closingBracket == '}}'
                  ? MustacheTokenType.Variable
                  : MustacheTokenType.EscapedVariable;
              tokenValue = variable;
            }

            if (tokenType == MustacheTokenType.Unknown) {
              throw MustacheException(null, MustacheErrorCode.Internal,
                  'Internal error', token.line, token.column);
            }

            operator1 = null;
            operator2 = null;
            variable = null;
            state = MustacheLexicalState.Value;
          }
          break;
        case TokenType.Word:
          if (state == MustacheLexicalState.Operator1) {
            state = MustacheLexicalState.Variable;
          }
          if (state == MustacheLexicalState.Operator2 &&
              (token.value == 'if' || token.value == 'unless')) {
            operator2 = token.value;
            state = MustacheLexicalState.Variable;
            continue;
          }
          if (state == MustacheLexicalState.Operator2) {
            state = MustacheLexicalState.Variable;
          }
          if (state == MustacheLexicalState.Variable) {
            variable = token.value;
            state = MustacheLexicalState.Closure;
            continue;
          }
          break;
        case TokenType.Whitespace:
          continue;

        default:
          break;
      }
      if (tokenType == MustacheTokenType.Unknown) {
        throw MustacheException(
            null,
            MustacheErrorCode.UnexpectedSymbol,
            "Unexpected symbol '${token.value ?? ''}'",
            token.line,
            token.column);
      }
      _initialTokens
          .add(MustacheToken(tokenType, tokenValue, token.line, token.column));
    }

    if (state != MustacheLexicalState.Value) {
      throw MustacheException(null, MustacheErrorCode.UnexpectedEnd,
          'Unexpected end of file', 0, 0);
    }
  }

  /// Performs a syntax analysis at level 0.
  void _performSyntaxAnalysis() {
    _checkForMoreTokens();
    while (_hasMoreTokens()) {
      var token = _getCurrentToken();
      _moveToNextToken();

      if (token?.type == MustacheTokenType.SectionEnd) {
        throw MustacheException(
            null,
            MustacheErrorCode.UnexpectedSectionEnd,
            "Unexpected section end for variable '${token?.value}'",
            token?.line ?? 0,
            token?.column ?? 0);
      }

      var result = _addTokenToResult(
          token?.type, token?.value, token?.line, token?.column);

      if (token?.type == MustacheTokenType.Section ||
          token?.type == MustacheTokenType.InvertedSection) {
        result.tokens.addAll(_performSyntaxAnalysisForSection(token?.value));
      }
    }
  }

  List<MustacheToken> _performSyntaxAnalysisForSection(String? variable) {
    var result = <MustacheToken>[];

    _checkForMoreTokens();
    while (_hasMoreTokens()) {
      var token = _getCurrentToken();
      _moveToNextToken();

      if (token?.type == MustacheTokenType.SectionEnd &&
          (token?.value == variable || token?.value == null)) {
        return result;
      }

      if (token?.type == MustacheTokenType.SectionEnd) {
        throw MustacheException(
            null,
            MustacheErrorCode.UnexpectedSectionEnd,
            "Unexpected section end for variable '$variable'",
            token?.line ?? 0,
            token?.column ?? 0);
      }

      var resultToken =
          MustacheToken(token?.type, token?.value, token?.line, token?.column);

      if (token?.type == MustacheTokenType.Section ||
          token?.type == MustacheTokenType.InvertedSection) {
        resultToken.tokens
            .addAll(_performSyntaxAnalysisForSection(token?.value));
      }

      result.add(resultToken);
    }

    var token = _getCurrentToken();
    throw MustacheException(
        null,
        MustacheErrorCode.NotClosedSection,
        "Not closed section for variable '$variable'",
        token?.line ?? 0,
        token?.column ?? 0);
  }

  /// Retrieves variables from the parsed output.
  void _lookupVariables() {
    if (_originalTokens.isEmpty) return;

    _variableNames.clear();
    for (var token in _initialTokens) {
      if (token.type != MustacheTokenType.Value &&
          token.type != MustacheTokenType.Comment &&
          token.value != null) {
        var variableName = token.value?.toLowerCase();
        var found = _variableNames.firstWhere(
                    (v) => v.toLowerCase() == variableName,
                    orElse: () => '') !=
                ''
            ? true
            : false;
        if (!found) {
          _variableNames.add(token.value!);
        }
      }
    }
  }
}
