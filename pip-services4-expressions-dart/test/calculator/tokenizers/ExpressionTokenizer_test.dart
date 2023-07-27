import 'package:test/test.dart';
import 'package:pip_services4_expressions/src/calculator/tokenizers/tokenizers.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';

import '../../tokenizers/TokenizerFixture.dart';

void main() {
  group('ExpressionTokenizer', () {
    test('QuoteToken', () {
      var tokenString = "A'xyz'\"abc\ndeg\" 'jkl\"def'\"ab\"\"de\"'df''er'";
      var expectedTokens = <Token>[
        Token(TokenType.Word, 'A', 0, 0),
        Token(TokenType.Quoted, 'xyz', 0, 0),
        Token(TokenType.Word, 'abc\ndeg', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Quoted, 'jkl"def', 0, 0),
        Token(TokenType.Word, 'ab"de', 0, 0),
        Token(TokenType.Quoted, "df'er", 0, 0)
      ];

      var tokenizer = ExpressionTokenizer();
      tokenizer.skipEof = true;
      tokenizer.decodeStrings = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });
    test('WordToken', () {
      var tokenString = "A'xyz'Ebf_2\n2_2";
      var expectedTokens = <Token>[
        Token(TokenType.Word, 'A', 0, 0),
        Token(TokenType.Quoted, 'xyz', 0, 0),
        Token(TokenType.Word, 'Ebf_2', 0, 0),
        Token(TokenType.Whitespace, '\n', 0, 0),
        Token(TokenType.Integer, '2', 0, 0),
        Token(TokenType.Word, '_2', 0, 0)
      ];

      var tokenizer = ExpressionTokenizer();
      tokenizer.skipEof = true;
      tokenizer.decodeStrings = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });

    test('NumberToken', () {
      var tokenString = '123-321 .543-.76-. 123.456 123e45 543.11E+43 1e 3E-';
      var expectedTokens = <Token>[
        Token(TokenType.Integer, '123', 0, 0),
        Token(TokenType.Symbol, '-', 0, 0),
        Token(TokenType.Integer, '321', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Float, '.543', 0, 0),
        Token(TokenType.Symbol, '-', 0, 0),
        Token(TokenType.Float, '.76', 0, 0),
        Token(TokenType.Symbol, '-', 0, 0),
        Token(TokenType.Symbol, '.', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Float, '123.456', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Float, '123e45', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Float, '543.11E+43', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Integer, '1', 0, 0),
        Token(TokenType.Word, 'e', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Integer, '3', 0, 0),
        Token(TokenType.Word, 'E', 0, 0),
        Token(TokenType.Symbol, '-', 0, 0)
      ];

      var tokenizer = ExpressionTokenizer();
      tokenizer.skipEof = true;
      tokenizer.decodeStrings = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });

    test('ExpressionToken', () {
      var tokenString = 'A + b / (3 - Max(-123, 1)*2)';

      var tokenizer = ExpressionTokenizer();
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      expect(25, tokenList.length);
    });
  });
}
