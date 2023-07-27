import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';

import 'CsvConstant.dart';

/// Implements a symbol state to tokenize delimiters in CSV streams.
class CsvSymbolState extends GenericSymbolState {
  CsvSymbolState() : super() {
    add('\n', TokenType.Eol);
    add('\r', TokenType.Eol);
    add('\r\n', TokenType.Eol);
    add('\n\r', TokenType.Eol);
  }

  /// Gets the next token from the stream started from the character linked to this state.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token nextToken(IScanner scanner, ITokenizer? tokenizer) {
    // Optimization...
    var nextSymbol = scanner.read();
    var line = scanner.line();
    var column = scanner.column();

    if (nextSymbol != CsvConstant.LF && nextSymbol != CsvConstant.CR) {
      return Token(
          TokenType.Symbol, String.fromCharCode(nextSymbol), line, column);
    } else {
      scanner.unread();
      return super.nextToken(scanner, tokenizer);
    }
  }
}
