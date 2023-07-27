import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:test/test.dart';

void main() {
  group('GenericSymbolState', () {
    test('NextToken', () {
      var state = GenericSymbolState();
      state.add('<', TokenType.Symbol);
      state.add('<<', TokenType.Symbol);
      state.add('<>', TokenType.Symbol);

      var scanner = StringScanner('<A<<<>');

      var token = state.nextToken(scanner, null);
      expect('<', token.value);
      expect(TokenType.Symbol, token.type);

      token = state.nextToken(scanner, null);
      expect('A', token.value);
      expect(TokenType.Symbol, token.type);

      token = state.nextToken(scanner, null);
      expect('<<', token.value);
      expect(TokenType.Symbol, token.type);

      token = state.nextToken(scanner, null);
      expect('<>', token.value);
      expect(TokenType.Symbol, token.type);
    });
  });
}
