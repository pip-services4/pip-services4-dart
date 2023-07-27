import 'ITokenizerState.dart';

/// Defines an interface for tokenizer state that processes quoted strings.
abstract interface class IQuoteState implements ITokenizerState {
  /// Encodes a string value.
  /// - [value] A string value to be encoded.
  /// - [quoteSymbol] A string quote character.
  /// Returns An encoded string.
  String? encodeString(String? value, int quoteSymbol);

  /// Decodes a string value.
  /// - [value] A string value to be decoded.
  /// - [quoteSymbol] A string quote character.
  /// Returns An decoded string.
  String? decodeString(String? value, int quoteSymbol);
}
