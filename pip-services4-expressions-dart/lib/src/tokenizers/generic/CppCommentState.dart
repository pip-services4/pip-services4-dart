import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

import '../ITokenizer.dart';
import '../Token.dart';
import '../TokenType.dart';
import 'GenericCommentState.dart';

/// This state will either delegate to a comment-handling state, or return a token with just a slash in it.
class CppCommentState extends GenericCommentState {
  static final STAR = '*'.codeUnitAt(0);
  static final SLASH = '/'.codeUnitAt(0);

  /// Ignore everything up to a closing star and slash, and then return the tokenizer's next token.
  /// - [scanner] A textual string to be tokenized.
  String getMultiLineComment(IScanner scanner) {
    var result = '';
    var lastSymbol = 0;
    for (var nextSymbol = scanner.read();
        !CharValidator.isEof(nextSymbol);
        nextSymbol = scanner.read()) {
      result = result + String.fromCharCode(nextSymbol);
      if (lastSymbol == STAR && nextSymbol == SLASH) {
        break;
      }
      lastSymbol = nextSymbol;
    }
    return result;
  }

  /// Ignore everything up to an end-of-line and return the tokenizer's next token.
  /// - [scanner]  A textual string to be tokenized.
  String getSingleLineComment(IScanner scanner) {
    var result = '';
    int nextSymbol;
    for (nextSymbol = scanner.read();
        !CharValidator.isEof(nextSymbol) && !CharValidator.isEol(nextSymbol);
        nextSymbol = scanner.read()) {
      result = result + String.fromCharCode(nextSymbol);
    }
    if (CharValidator.isEol(nextSymbol)) {
      scanner.unread();
    }
    return result;
  }

  /// Either delegate to a comment-handling state, or return a token with just a slash in it.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token? nextToken(IScanner scanner, ITokenizer? tokenizer) {
    var firstSymbol = scanner.read();
    var line = scanner.line();
    var column = scanner.column();

    if (firstSymbol != SLASH) {
      scanner.unread();
      throw Exception('Incorrect usage of CppCommentState.');
    }

    var secondSymbol = scanner.read();
    if (secondSymbol == STAR) {
      return Token(
          TokenType.Comment, '/*${getMultiLineComment(scanner)}', line, column);
    } else if (secondSymbol == SLASH) {
      return Token(TokenType.Comment, '//${getSingleLineComment(scanner)}',
          line, column);
    } else {
      if (!CharValidator.isEof(secondSymbol)) {
        scanner.unread();
      }
      if (!CharValidator.isEof(firstSymbol)) {
        scanner.unread();
      }
      return tokenizer?.symbolState?.nextToken(scanner, tokenizer);
    }
  }
}
