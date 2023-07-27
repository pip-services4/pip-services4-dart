import 'package:pip_services4_expressions/src/tokenizers/Token.dart';

import 'package:pip_services4_expressions/src/tokenizers/ITokenizer.dart';

import 'package:pip_services4_expressions/src/io/IScanner.dart';
import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';

import '../IWordState.dart';
import '../TokenType.dart';

/// A `wordState` returns a word from a scanner. Like other states, a tokenizer transfers the job
/// of reading to this state, depending on an initial character. Thus, the tokenizer decides
/// which characters may begin a word, and this state determines which characters may appear
/// as a second or later character in a word. These are typically different sets of characters;
/// in particular, it is typical for digits to appear as parts of a word, but not
/// as the initial character of a word.
///
/// By default, the following characters may appear in a word.
/// The method [setWordChars] allows customizing this.
///
/// .. list-table::
///     :header-rows: 1
///     :widths: 10, 10
///
///     * - From
///       - To
///
///     * - 'a'
///       - 'z'
///     * - 'A'
///       - 'Z'
///     * - '0'
///       - '9'
///
/// as well as: minus sign, underscore, and apostrophe.
class GenericWordState implements IWordState {
  final _map = CharReferenceMap<bool>();

  /// Constructs a word state with a default idea of what characters
  /// are admissible inside a word (as described in the class comment).
  GenericWordState() {
    setWordChars('a'.codeUnitAt(0), 'z'.codeUnitAt(0), true);
    setWordChars('A'.codeUnitAt(0), 'Z'.codeUnitAt(0), true);
    setWordChars('0'.codeUnitAt(0), '9'.codeUnitAt(0), true);
    setWordChars('-'.codeUnitAt(0), '-'.codeUnitAt(0), true);
    setWordChars('_'.codeUnitAt(0), '_'.codeUnitAt(0), true);
    // setWordChars(39, 39, true);
    setWordChars(0x00c0, 0x00ff, true);
    setWordChars(0x0100, 0xfffe, true);
  }

  /// Ignore word (such as blanks and tabs), and return the tokenizer's next token.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token? nextToken(IScanner scanner, ITokenizer? tokenizer) {
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

    return Token(TokenType.Word, tokenValue, line, column);
  }

  /// Establish characters in the given range as valid characters for part of a word after
  /// the first character.
  ///
  /// Note that the tokenizer must determine which characters are valid
  /// as the beginning character of a word.
  /// - [fromSymbol] First character index of the interval.
  /// - [toSymbol] Last character index of the interval.
  /// - [enable] `true` if this state should use characters in the given range.
  @override
  void setWordChars(int fromSymbol, int toSymbol, bool enable) {
    _map.addInterval(fromSymbol, toSymbol, enable);
  }

  /// Clears definitions of word chars.
  @override
  void clearWordChars() {
    _map.clear();
  }
}
