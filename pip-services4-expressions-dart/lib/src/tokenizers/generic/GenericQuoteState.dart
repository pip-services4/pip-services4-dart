import 'package:pip_services4_expressions/src/tokenizers/Token.dart';

import 'package:pip_services4_expressions/src/tokenizers/ITokenizer.dart';

import 'package:pip_services4_expressions/src/io/IScanner.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

import '../IQuoteState.dart';
import '../TokenType.dart';

/// A quoteState returns a quoted string token from a scanner.
///
/// This state will collect characters
/// until it sees a match to the character that the tokenizer used to switch to this state.
/// For example, if a tokenizer uses a double-quote character to enter this state,
/// then [nextToken] will search for another double-quote until it finds one
/// or finds the end of the scanner.
class GenericQuoteState implements IQuoteState {
  /// Return a quoted string token from a scanner.
  ///
  /// This method will collect characters until it sees a match to the character
  /// that the tokenizer used to switch to this state.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token nextToken(IScanner scanner, ITokenizer? tokenizer) {
    var firstSymbol = scanner.read();
    var line = scanner.line();
    var column = scanner.column();
    var tokenValue = String.fromCharCode(firstSymbol);

    for (var nextSymbol = scanner.read();
        !CharValidator.isEof(nextSymbol);
        nextSymbol = scanner.read()) {
      tokenValue = tokenValue + String.fromCharCode(nextSymbol);
      if (nextSymbol == firstSymbol) {
        break;
      }
    }

    return Token(TokenType.Quoted, tokenValue, line, column);
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
      return value.substring(1, value.length - 1);
    }
    return value;
  }

  /// Encodes a string value.
  /// - [value] A string value to be encoded.
  /// - [quoteSymbol] A string quote character.
  /// Returns An encoded string.
  @override
  String? encodeString(String? value, int quoteSymbol) {
    if (value == null) return null;

    var result = String.fromCharCode(quoteSymbol) +
        value +
        String.fromCharCode(quoteSymbol);
    return result;
  }
}
