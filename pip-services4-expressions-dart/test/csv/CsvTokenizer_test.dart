import 'package:pip_services4_expressions/src/csv/csv.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:test/test.dart';

import '../tokenizers/TokenizerFixture.dart';

void main() {
  group('CsvTokenizer', () {
    test('TokenizerWithDefaultParameters', () {
      var tokenString =
          '\n\r\"John \"\"Da Man\"\"\",Repici,120 Jefferson St.,Riverside, NJ,08075\r\n' +
              'Stephen,Tyler,\"7452 Terrace \"\"At the Plaza\"\" road\",SomeTown,SD, 91234\r' +
              ',Blankman,,SomeTown, SD, 00298\n';
      var expectedTokens = <Token>[
        Token(TokenType.Eol, '\n\r', 0, 0),
        Token(TokenType.Quoted, '\"John \"\"Da Man\"\"\"', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, 'Repici', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, '120 Jefferson St.', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, 'Riverside', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, ' NJ', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, '08075', 0, 0),
        Token(TokenType.Eol, '\r\n', 0, 0),
        Token(TokenType.Word, 'Stephen', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, 'Tyler', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Quoted, '\"7452 Terrace \"\"At the Plaza\"\" road\"', 0,
            0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, 'SomeTown', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, 'SD', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, ' 91234', 0, 0),
        Token(TokenType.Eol, '\r', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, 'Blankman', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, 'SomeTown', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, ' SD', 0, 0),
        Token(TokenType.Symbol, ',', 0, 0),
        Token(TokenType.Word, ' 00298', 0, 0),
        Token(TokenType.Eol, '\n', 0, 0)
      ];

      var tokenizer = CsvTokenizer();
      tokenizer.skipEof = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });
    test('TokenizerWithOverridenParameters', () {
      var tokenString =
          "\n\r\'John, \'\'Da Man\'\'\'\tRepici\t120 Jefferson St.\tRiverside\t NJ\t08075\r\n" +
              "Stephen\t\"Tyler\"\t\'7452 \t\nTerrace \'\'At the Plaza\'\' road\'\tSomeTown\tSD\t 91234\r" +
              "\tBlankman\t\tSomeTown \'xxx\t\'\t SD\t 00298\n";
      var expectedTokens = <Token>[
        Token(TokenType.Eol, '\n\r', 0, 0),
        Token(TokenType.Quoted, "\'John, \'\'Da Man\'\'\'", 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, 'Repici', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, '120 Jefferson St.', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, 'Riverside', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, ' NJ', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, '08075', 0, 0),
        Token(TokenType.Eol, '\r\n', 0, 0),
        Token(TokenType.Word, 'Stephen', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Quoted, '\"Tyler\"', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Quoted,
            "\'7452 \t\nTerrace \'\'At the Plaza\'\' road\'", 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, 'SomeTown', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, 'SD', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, ' 91234', 0, 0),
        Token(TokenType.Eol, '\r', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, 'Blankman', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, 'SomeTown ', 0, 0),
        Token(TokenType.Quoted, "\'xxx\t\'", 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, ' SD', 0, 0),
        Token(TokenType.Symbol, '\t', 0, 0),
        Token(TokenType.Word, ' 00298', 0, 0),
        Token(TokenType.Eol, '\n', 0, 0)
      ];

      var tokenizer = CsvTokenizer();
      tokenizer.fieldSeparators = ['\t'.codeUnitAt(0)];
      tokenizer.quoteSymbols = ['\''.codeUnitAt(0), '\"'.codeUnitAt(0)];
      tokenizer.endOfLine = '\n';
      tokenizer.skipEof = true;
      var tokenList = tokenizer.tokenizeBuffer(tokenString);

      TokenizerFixture.assertAreEqualsTokenLists(expectedTokens, tokenList);
    });
  });
}
