import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

/// Implements an Expression-specific number state object.
class ExpressionNumberState extends GenericNumberState {
  final int PLUS = '+'.codeUnitAt(0);
  final int EXP1 = 'e'.codeUnitAt(0);
  final int EXP2 = 'E'.codeUnitAt(0);

  /// Gets the next token from the stream started from the character linked to this state.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token? nextToken(IScanner scanner, ITokenizer? tokenizer) {
    var line = scanner.peekLine();
    var column = scanner.peekColumn();

    // Process leading minus.
    if (scanner.peek() == MINUS) {
      return tokenizer?.symbolState?.nextToken(scanner, tokenizer);
    }

    // Process numbers using base class algorithm.
    var token = super.nextToken(scanner, tokenizer);

    // Exit if number was not detected.
    if (token?.type != TokenType.Integer && token?.type != TokenType.Float) {
      return token;
    }

    // Exit if number is not in scientific format.
    var nextChar = scanner.peek();
    if (nextChar != EXP1 && nextChar != EXP2) {
      return token;
    }

    var tokenValue = String.fromCharCode(scanner.read());

    // Process '-' or '+' in mantissa
    nextChar = scanner.peek();
    if (nextChar == MINUS || nextChar == PLUS) {
      tokenValue = tokenValue + String.fromCharCode(scanner.read());
      nextChar = scanner.peek();
    }

    // Exit if mantissa has no digits.
    if (!CharValidator.isDigit(nextChar)) {
      scanner.unreadMany(tokenValue.length);
      return token;
    }

    // Process matissa digits
    for (; CharValidator.isDigit(nextChar); nextChar = scanner.peek()) {
      tokenValue = tokenValue + String.fromCharCode(scanner.read());
    }

    return Token(
        TokenType.Float, (token?.value ?? '') + tokenValue, line, column);
  }
}
