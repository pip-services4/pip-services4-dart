import 'package:pip_services4_expressions/src/tokenizers/Token.dart';
import 'package:pip_services4_expressions/src/tokenizers/ITokenizer.dart';
import 'package:pip_services4_expressions/src/io/IScanner.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

import '../IWhitespaceState.dart';
import '../TokenType.dart';

/// A whitespace state ignores whitespace (such as blanks and tabs), and returns the tokenizer's
/// next token. By default, all characters from 0 to 32 are whitespace.
class GenericWhitespaceState implements IWhitespaceState {
  final _map = CharReferenceMap<bool>();

  /// Constructs a whitespace state with a default idea of what characters are, in fact, whitespace.
  GenericWhitespaceState() {
    setWhitespaceChars(0, ' '.codeUnitAt(0), true);
  }

  /// Ignore whitespace (such as blanks and tabs), and return the tokenizer's next token.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token nextToken(IScanner scanner, ITokenizer? tokenizer) {
    var line = scanner.peekLine();
    var column = scanner.peekColumn();
    int nextSymbol;
    var tokenValue = '';
    for (nextSymbol = scanner.read();
        _map.lookup(nextSymbol) != null && _map.lookup(nextSymbol) != false;
        nextSymbol = scanner.read()) {
      tokenValue = tokenValue + String.fromCharCode(nextSymbol);
    }

    if (!CharValidator.isEof(nextSymbol)) {
      scanner.unread();
    }

    return Token(TokenType.Whitespace, tokenValue, line, column);
  }

  /// Establish the given characters as whitespace to ignore.
  /// - [fromSymbol] First character index of the interval.
  /// - [toSymbol] Last character index of the interval.
  /// - [enable] `true` if this state should ignore characters in the given range.
  @override
  void setWhitespaceChars(int fromSymbol, int toSymbol, bool enable) {
    _map.addInterval(fromSymbol, toSymbol, enable);
  }

  /// Clears definitions of whitespace characters.
  @override
  void clearWhitespaceChars() {
    _map.clear();
  }
}
