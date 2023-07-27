import 'package:pip_services4_expressions/src/mustache/tokenizers/tokenizers.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:test/test.dart';

import '../../tokenizers/TokenizerFixture.dart';

void main() {
  group('MustacheTokenizer', () {
    test('Template1', () {
      var tokenString = 'Hello, {{ Name }}!';
      var expectedTokens = <Token>[
        Token(TokenType.Special, 'Hello, ', 0, 0),
        Token(TokenType.Symbol, '{{', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Word, 'Name', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Symbol, '}}', 0, 0),
        Token(TokenType.Special, '!', 0, 0),
      ];

      var tokenizer = MustacheTokenizer();
      tokenizer.skipEof = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });

    test('Template2', () {
      var tokenString = 'Hello, {{{ Name }}}!';
      var expectedTokens = <Token>[
        Token(TokenType.Special, 'Hello, ', 0, 0),
        Token(TokenType.Symbol, '{{{', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Word, 'Name', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Symbol, '}}}', 0, 0),
        Token(TokenType.Special, '!', 0, 0),
      ];

      var tokenizer = MustacheTokenizer();
      tokenizer.skipEof = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });

    test('Template3', () {
      var tokenString = '{{ Name }}}';
      var expectedTokens = <Token>[
        Token(TokenType.Symbol, '{{', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Word, 'Name', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Symbol, '}}}', 0, 0)
      ];

      var tokenizer = MustacheTokenizer();
      tokenizer.skipEof = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });

    test('Template4', () {
      var tokenString = 'Hello, World!';
      var expectedTokens = <Token>[
        Token(TokenType.Special, 'Hello, World!', 0, 0)
      ];

      var tokenizer = MustacheTokenizer();
      tokenizer.skipEof = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });
  });
}
