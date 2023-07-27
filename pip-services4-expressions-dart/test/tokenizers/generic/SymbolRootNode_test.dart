import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:test/test.dart';

void main() {
  group('SymbolRootNode', () {
    test('NextToken', () {
      var node = SymbolRootNode();
      node.add('<', TokenType.Symbol);
      node.add('<<', TokenType.Symbol);
      node.add('<>', TokenType.Symbol);

      var scanner = StringScanner('<A<<<>');

      var token = node.nextToken(scanner);
      expect('<', token.value);

      token = node.nextToken(scanner);
      expect('A', token.value);

      token = node.nextToken(scanner);
      expect('<<', token.value);

      token = node.nextToken(scanner);
      expect('<>', token.value);
    });

    test('SingleToken', () {
      var node = SymbolRootNode();
      node.add('<', TokenType.Symbol);
      node.add('<<', TokenType.Symbol);

      var scanner = StringScanner('<A');

      var token = node.nextToken(scanner);
      expect('<', token.value);
      expect(TokenType.Symbol, token.type);
    });
  });
}
