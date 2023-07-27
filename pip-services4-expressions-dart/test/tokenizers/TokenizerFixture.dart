import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:test/expect.dart';

/// Implements test utilities to Tokenzier tests
class TokenizerFixture {
  /// Checks is expected tokens matches actual tokens.
  /// - [expectedTokens] An array with expected tokens.
  /// - [actualTokens] An array with actual tokens.
  static void assertAreEqualsTokenLists(
      List<Token> expectedTokens, List<Token> actualTokens) {
    expect(expectedTokens.length, actualTokens.length);
    for (var i = 0; i < expectedTokens.length; i++) {
      expect(expectedTokens[i].type, actualTokens[i].type);
      expect(expectedTokens[i].value, actualTokens[i].value);
    }
  }
}
