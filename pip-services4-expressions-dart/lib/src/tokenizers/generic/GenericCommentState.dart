import 'package:pip_services4_expressions/src/tokenizers/Token.dart';

import 'package:pip_services4_expressions/src/tokenizers/ITokenizer.dart';

import 'package:pip_services4_expressions/src/io/IScanner.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

import '../ICommentState.dart';
import '../TokenType.dart';

/// A CommentState object returns a comment from a scanner.
class GenericCommentState implements ICommentState {
  final int LF = '\r'.codeUnitAt(0);
  final int CR = '\n'.codeUnitAt(0);

  /// Either delegate to a comment-handling state, or return a token with just a slash in it.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token? nextToken(IScanner scanner, ITokenizer? tokenizer) {
    var line = scanner.peekLine();
    var column = scanner.peekColumn();
    var tokenValue = '';
    int nextSymbol;
    for (nextSymbol = scanner.read();
        !CharValidator.isEof(nextSymbol) &&
            nextSymbol != CR &&
            nextSymbol != LF;
        nextSymbol = scanner.read()) {
      tokenValue = tokenValue + String.fromCharCode(nextSymbol);
    }
    if (!CharValidator.isEof(nextSymbol)) {
      scanner.unread();
    }

    return Token(TokenType.Comment, tokenValue, line, column);
  }
}
