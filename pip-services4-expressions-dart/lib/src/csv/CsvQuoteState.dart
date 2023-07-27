import 'package:pip_services4_expressions/src/io/IScanner.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

/// Implements a quote string state object for CSV streams.
class CsvQuoteState implements IQuoteState {
  /// Gets the next token from the stream started from the character linked to this state.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token? nextToken(IScanner scanner, ITokenizer? tokenizer) {
    var firstSymbol = scanner.read();
    var line = scanner.line();
    var column = scanner.column();
    var tokenValue = '';
    tokenValue = tokenValue + String.fromCharCode(firstSymbol);

    for (var nextSymbol = scanner.read();
        !CharValidator.isEof(nextSymbol);
        nextSymbol = scanner.read()) {
      tokenValue = tokenValue + String.fromCharCode(nextSymbol);
      if (nextSymbol == firstSymbol) {
        if (scanner.peek() == firstSymbol) {
          nextSymbol = scanner.read();
          tokenValue = tokenValue + String.fromCharCode(nextSymbol);
        } else {
          break;
        }
      }
    }

    return Token(TokenType.Quoted, tokenValue, line, column);
  }

  /// Encodes a string value.
  /// - [value] A string value to be encoded.
  /// - [quoteSymbol] A string quote character.
  /// Returns An encoded string.
  @override
  String? encodeString(String? value, int quoteSymbol) {
    if (value == null) return null;

    var quoteString = String.fromCharCode(quoteSymbol);
    var result = quoteString +
        value.replaceAll(quoteString, quoteString + quoteString) +
        quoteString;
    return result;
  }

  /// Decodes a string value.
  /// - [value] A string value to be decoded.
  /// - [quoteSymbol] A string quote character.
  /// Returns An decoded string.
  @override
  String? decodeString(String? value, int quoteSymbol) {
    if (value == null) return null;

    if (value.length >= 2 &&
        value.codeUnitAt(0) == quoteSymbol &&
        value.codeUnitAt(value.length - 1) == quoteSymbol) {
      var quoteString = String.fromCharCode(quoteSymbol);
      return value
          .substring(1, value.length - 1)
          .replaceAll(quoteString + quoteString, quoteString);
    }
    return value;
  }
}
