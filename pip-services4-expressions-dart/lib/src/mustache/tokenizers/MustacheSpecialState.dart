import 'package:pip_services4_expressions/src/io/IScanner.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

/// Implements a quote string state object for Mustache templates.
class MustacheSpecialState implements ITokenizerState {
  static final Bracket = '{'.codeUnitAt(0);

  /// Gets the next token from the stream started from the character linked to this state.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token? nextToken(IScanner scanner, ITokenizer? tokenizer) {
    var line = scanner.peekLine();
    var column = scanner.peekColumn();
    var tokenValue = '';

    for (var nextSymbol = scanner.read();
        !CharValidator.isEof(nextSymbol);
        nextSymbol = scanner.read()) {
      if (nextSymbol == MustacheSpecialState.Bracket) {
        if (scanner.peek() == MustacheSpecialState.Bracket) {
          scanner.unread();
          break;
        }
      }

      tokenValue = tokenValue + String.fromCharCode(nextSymbol);
    }

    return Token(TokenType.Special, tokenValue, line, column);
  }
}
