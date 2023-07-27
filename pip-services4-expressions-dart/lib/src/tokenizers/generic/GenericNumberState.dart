import 'package:pip_services4_expressions/src/tokenizers/Token.dart';

import 'package:pip_services4_expressions/src/tokenizers/ITokenizer.dart';

import 'package:pip_services4_expressions/src/io/IScanner.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

import '../INumberState.dart';
import '../TokenType.dart';

/// A NumberState object returns a number from a scanner. This state's idea of a number allows
/// an optional, initial minus sign, followed by one or more digits. A decimal point and another string
/// of digits may follow these digits.
class GenericNumberState implements INumberState {
  final int MINUS = '-'.codeUnitAt(0);
  final int DOT = '.'.codeUnitAt(0);

  /// Gets the next token from the stream started from the character linked to this state.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token? nextToken(IScanner scanner, ITokenizer? tokenizer) {
    var absorbedDot = false;
    var gotADigit = false;
    var tokenValue = '';
    var nextSymbol = scanner.read();
    var line = scanner.line();
    var column = scanner.column();

    // Parses leading minus.
    if (nextSymbol == MINUS) {
      tokenValue = '$tokenValue-';
      nextSymbol = scanner.read();
    }

    // Parses digits before decimal separator.
    for (;
        CharValidator.isDigit(nextSymbol) && !CharValidator.isEof(nextSymbol);
        nextSymbol = scanner.read()) {
      gotADigit = true;
      tokenValue = tokenValue + String.fromCharCode(nextSymbol);
    }

    // Parses part after the decimal separator.
    if (nextSymbol == DOT) {
      absorbedDot = true;
      tokenValue = '$tokenValue.';
      nextSymbol = scanner.read();

      // Absorb all digits.
      for (;
          CharValidator.isDigit(nextSymbol) && !CharValidator.isEof(nextSymbol);
          nextSymbol = scanner.read()) {
        gotADigit = true;
        tokenValue = tokenValue + String.fromCharCode(nextSymbol);
      }
    }

    // Pushback last unprocessed symbol.
    if (!CharValidator.isEof(nextSymbol)) {
      scanner.unread();
    }

    // Process the result.
    if (!gotADigit) {
      scanner.unreadMany(tokenValue.length);
      if (tokenizer?.symbolState != null) {
        return tokenizer!.symbolState!.nextToken(scanner, tokenizer);
      } else {
        throw Exception('Tokenizer must have an assigned symbol state.');
      }
    }

    return Token(absorbedDot ? TokenType.Float : TokenType.Integer, tokenValue,
        line, column);
  }
}
