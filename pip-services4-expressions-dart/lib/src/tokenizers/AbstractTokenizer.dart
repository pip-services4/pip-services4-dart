import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

import 'ICommentState.dart';
import 'INumberState.dart';
import 'IQuoteState.dart';
import 'ISymbolState.dart';
import 'ITokenizer.dart';
import 'ITokenizerState.dart';
import 'IWhitespaceState.dart';
import 'IWordState.dart';
import 'Token.dart';
import 'TokenType.dart';

/// Implements an abstract tokenizer class.
abstract class AbstractTokenizer implements ITokenizer {
  final _map = CharReferenceMap<ITokenizerState>();

  @override
  bool skipUnknown = false;
  @override
  bool skipWhitespaces = false;
  @override
  bool skipComments = false;
  @override
  bool skipEof = false;
  @override
  bool mergeWhitespaces = false;
  @override
  bool unifyNumbers = false;
  @override
  bool decodeStrings = false;
  @override
  ICommentState? commentState;
  @override
  INumberState? numberState;
  @override
  IQuoteState? quoteState;
  @override
  ISymbolState? symbolState;
  @override
  IWhitespaceState? whitespaceState;
  @override
  IWordState? wordState;

  IScanner? _scanner;
  Token? nextTokenValue;
  var lastTokenType = TokenType.Unknown;

  /// Gest the state for a given character.
  /// - [symbol] symbol
  /// Returns tokenizer state
  ITokenizerState? getCharacterState(int symbol) => _map.lookup(symbol);

  /// Sets the characters' state.
  /// - [fromSymbol] first symbol
  /// - [toSymbol] last symbol
  /// - [state] tokenizer state
  void setCharacterState(int fromSymbol, int toSymbol, ITokenizerState state) {
    _map.addInterval(fromSymbol, toSymbol, state);
  }

  /// Clears all character states.
  void clearCharacterStates() {
    _map.clear();
  }

  /// Gets the scanner
  @override
  IScanner? get scanner => _scanner;

  /// Sets the scanner
  @override
  set scanner(IScanner? value) {
    _scanner = value;
    nextTokenValue = null;
    lastTokenType = TokenType.Unknown;
  }

  /// Finds out if the tokenizer has a next token.
  /// Returns true if it has a next token, false otherwise.
  @override
  bool hasNextToken() {
    nextTokenValue = nextTokenValue ?? readNextToken();
    return nextTokenValue != null;
  }

  /// Gets the next token.
  /// Returns next token
  @override
  Token? nextToken() {
    var token = nextTokenValue ?? readNextToken();
    nextTokenValue = null;
    return token;
  }

  /// Reads the next token.
  /// Returns next token
  Token? readNextToken() {
    if (_scanner == null) {
      return null;
    }

    var line = _scanner!.peekLine();
    var column = _scanner!.peekColumn();
    Token? token;

    while (true) {
      // Read character
      var nextChar = _scanner!.peek();

      // If reached Eof then exit
      if (CharValidator.isEof(nextChar)) {
        token = null;
        break;
      }

      // Get state for character
      var state = getCharacterState(nextChar);
      if (state != null) {
        token = state.nextToken(_scanner!, this);
      }

      // Check for unknown characters and endless loops...
      if (token == null || token.value == '') {
        token = Token(TokenType.Unknown, String.fromCharCode(_scanner!.read()),
            line, column);
      }

      // Skip unknown characters if option set.
      if (token.type == TokenType.Unknown && skipUnknown) {
        lastTokenType = token.type;
        continue;
      }

      // Decode strings is option set.
      try {
        if (state != null &&
            decodeStrings &&
            (state as dynamic)?.decodeString != null) {
          token = Token(token.type,
              quoteState?.decodeString(token.value, nextChar), line, column);
        }
      } on NoSuchMethodError {
        // pass
      }

      // Skips comments if option set.
      if (token?.type == TokenType.Comment && skipComments) {
        lastTokenType = token!.type;
        continue;
      }

      // Skips whitespaces if option set.
      if (token?.type == TokenType.Whitespace &&
          lastTokenType == TokenType.Whitespace &&
          skipWhitespaces) {
        lastTokenType = token!.type;
        continue;
      }

      // Unifies whitespaces if option set.
      if (token?.type == TokenType.Whitespace && mergeWhitespaces) {
        token = Token(TokenType.Whitespace, ' ', line, column);
      }

      // Unifies numbers if option set.
      if (unifyNumbers &&
          (token?.type == TokenType.Integer ||
              token?.type == TokenType.Float ||
              token?.type == TokenType.HexDecimal)) {
        token = Token(TokenType.Number, token?.value, line, column);
      }

      break;
    }

    // Adds an Eof if option is not set.
    if (token == null && lastTokenType != TokenType.Eof && !skipEof) {
      token = Token(TokenType.Eof, null, line, column);
    }

    // Assigns the last token type
    lastTokenType = token != null ? token.type : TokenType.Eof;

    return token;
  }

  /// Creates a list of tokens
  /// - [scanner] scanner
  /// Returns list of tokens
  @override
  List<Token> tokenizeStream(IScanner scanner) {
    this.scanner = scanner;
    var tokenList = <Token>[];
    for (var token = nextToken(); token != null; token = nextToken()) {
      tokenList.add(token);
    }
    return tokenList;
  }

  /// Provides a token for a string buffer.
  /// - [buffer] buffer
  /// Returns tokens
  @override
  List<Token> tokenizeBuffer(String buffer) {
    var scanner = StringScanner(buffer);
    return tokenizeStream(scanner);
  }

  /// Creates a list of token values.
  /// - [scanner] scanner
  /// Returns list of token values
  @override
  List<String?> tokenizeStreamToStrings(IScanner scanner) {
    this.scanner = scanner;
    var stringList = <String?>[];
    for (var token = nextToken(); token != null; token = nextToken()) {
      stringList.add(token.value);
    }
    return stringList;
  }

  /// Creates a list of token values.
  /// - [buffer] buffer
  /// Returns list of token values
  @override
  List<String?> tokenizeBufferToStrings(String buffer) {
    var scanner = StringScanner(buffer);
    return tokenizeStreamToStrings(scanner);
  }
}
