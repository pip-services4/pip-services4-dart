import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';

/// Implements a word state object.
class ExpressionWordState extends GenericWordState {
  final List<String> keywords = [
    'AND',
    'OR',
    'NOT',
    'XOR',
    'LIKE',
    'IS',
    'IN',
    'NULL',
    'TRUE',
    'FALSE'
  ];

  /// Constructs an instance of this class.
  ExpressionWordState() : super() {
    clearWordChars();
    setWordChars('a'.codeUnitAt(0), 'z'.codeUnitAt(0), true);
    setWordChars('A'.codeUnitAt(0), 'Z'.codeUnitAt(0), true);
    setWordChars('0'.codeUnitAt(0), '9'.codeUnitAt(0), true);
    setWordChars('_'.codeUnitAt(0), '_'.codeUnitAt(0), true);
    setWordChars(0x00c0, 0x00ff, true);
    setWordChars(0x0100, 0xfffe, true);
  }

  /// Gets the next token from the stream started from the character linked to this state.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token? nextToken(IScanner scanner, ITokenizer? tokenizer) {
    var line = scanner.peekLine();
    var column = scanner.peekColumn();
    var token = super.nextToken(scanner, tokenizer);
    var value = token?.value?.toUpperCase();

    for (var keyword in keywords) {
      if (keyword == value) {
        return Token(TokenType.Keyword, token?.value, line, column);
      }
    }
    return token;
  }
}
