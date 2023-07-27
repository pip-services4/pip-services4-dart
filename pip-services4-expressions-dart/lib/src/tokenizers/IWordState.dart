import 'ITokenizerState.dart';

/// Defines an interface for tokenizer state that processes words, identificators or keywords
abstract interface class IWordState implements ITokenizerState {
  /// Establish characters in the given range as valid characters for part of a word after
  /// the first character. Note that the tokenizer must determine which characters are valid
  /// as the beginning character of a word.
  /// - [fromSymbol] First character index of the interval.
  /// - [toSymbol] Last character index of the interval.
  /// - [enable] true if this state should use characters in the given range.
  void setWordChars(int fromSymbol, int toSymbol, bool enable);

  /// Clears definitions of word chars.
  void clearWordChars();
}
