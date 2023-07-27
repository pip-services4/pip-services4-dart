import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

import '../ITokenizer.dart';
import '../Token.dart';
import '../TokenType.dart';
import 'CppCommentState.dart';

/// This state will either delegate to a comment-handling state, or return a token with just a slash in it.
class CCommentState extends CppCommentState {
  /// Either delegate to a comment-handling state, or return a token with just a slash in it.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token? nextToken(IScanner scanner, ITokenizer? tokenizer) {
    var firstSymbol = scanner.read();
    var line = scanner.line();
    var column = scanner.column();

    if (firstSymbol != CppCommentState.SLASH) {
      scanner.unread();
      throw Exception('Incorrect usage of CCommentState.');
    }

    var secondSymbol = scanner.read();
    if (secondSymbol == CppCommentState.STAR) {
      return Token(
          TokenType.Comment, '/*${getMultiLineComment(scanner)}', line, column);
    } else {
      if (!CharValidator.isEof(secondSymbol)) {
        scanner.unread();
      }
      if (!CharValidator.isEof(firstSymbol)) {
        scanner.unread();
      }
      return tokenizer!.symbolState!.nextToken(scanner, tokenizer);
    }
  }
}
