import 'ITokenizerState.dart';
import 'TokenType.dart';

/// Defines an interface for tokenizer state that processes delimiters.
abstract interface class ISymbolState implements ITokenizerState {
  /// Add a multi-character symbol.
  /// - [value] The symbol to add, such as "=:="
  /// - [tokenType] The token type
  void add(String value, TokenType tokenType);
}
