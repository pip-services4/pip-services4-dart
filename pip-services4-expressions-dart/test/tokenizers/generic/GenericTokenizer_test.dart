import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:test/test.dart';

import '../TokenizerFixture.dart';

void main() {
  group('GenericTokenizer', () {
    test('Expression', () {
      var tokenString = "A+B/123 - \t 'xyz'\n <>-10.11# This is a comment";
      var expectedTokens = <Token>[
        Token(TokenType.Word, 'A', 0, 0),
        Token(TokenType.Symbol, '+', 0, 0),
        Token(TokenType.Word, 'B', 0, 0),
        Token(TokenType.Symbol, '/', 0, 0),
        Token(TokenType.Integer, '123', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Symbol, '-', 0, 0),
        Token(TokenType.Whitespace, ' \t ', 0, 0),
        Token(TokenType.Quoted, "'xyz'", 0, 0),
        Token(TokenType.Whitespace, '\n ', 0, 0),
        Token(TokenType.Symbol, '<>', 0, 0),
        Token(TokenType.Float, '-10.11', 0, 0),
        Token(TokenType.Comment, '# This is a comment', 0, 0),
        Token(TokenType.Eof, null, 0, 0)
      ];

      var tokenizer = GenericTokenizer();
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });

    test('WordToken', () {
      var tokenString = "A'xyz'Ebf_2\n2x_2";
      var expectedTokens = <Token>[
        Token(TokenType.Word, 'A', 0, 0),
        Token(TokenType.Quoted, 'xyz', 0, 0),
        Token(TokenType.Word, 'Ebf_2', 0, 0),
        Token(TokenType.Whitespace, '\n', 0, 0),
        Token(TokenType.Integer, '2', 0, 0),
        Token(TokenType.Word, 'x_2', 0, 0)
      ];

      var tokenizer = GenericTokenizer();
      tokenizer.skipEof = true;
      tokenizer.decodeStrings = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });

    test('NumberToken', () {
      var tokenString = '123-321 .543-.76-. -123.456';
      var expectedTokens = <Token>[
        Token(TokenType.Integer, '123', 0, 0),
        Token(TokenType.Integer, '-321', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Float, '.543', 0, 0),
        Token(TokenType.Float, '-.76', 0, 0),
        Token(TokenType.Symbol, '-', 0, 0),
        Token(TokenType.Symbol, '.', 0, 0),
        Token(TokenType.Whitespace, ' ', 0, 0),
        Token(TokenType.Float, '-123.456', 0, 0)
      ];

      var tokenizer = GenericTokenizer();
      tokenizer.skipEof = true;
      tokenizer.decodeStrings = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });

    test('ExpressionToken', () {
      var tokenString = 'A + b / (3 - Max(-123, 1)*2)';

      var tokenizer = GenericTokenizer();
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      expect(24, tokenList.length);
    });

    test('ExpressionToken2', () {
      var tokenString = '1>2';
      var expectedTokens = <Token>[
        Token(TokenType.Integer, '1', 0, 0),
        Token(TokenType.Symbol, '>', 0, 0),
        Token(TokenType.Integer, '2', 0, 0),
      ];

      var tokenizer = GenericTokenizer();
      tokenizer.skipEof = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });
  });
}
