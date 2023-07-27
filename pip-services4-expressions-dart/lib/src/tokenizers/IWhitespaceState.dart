import 'ITokenizerState.dart';

/// Defines an interface for tokenizer state that processes whitespaces (' ', '\t')
abstract interface class IWhitespaceState implements ITokenizerState {
  /// Establish the given characters as whitespace to ignore.
  /// - [fromSymbol] First character index of the interval.
  /// - [toSymbol] Last character index of the interval.
  /// - [enable] <code>true</code> if this state should ignore characters in the given range.
  void setWhitespaceChars(int fromSymbol, int toSymbol, bool enable);

  /// Clears definitions of whitespace characters.
  void clearWhitespaceChars();
}
