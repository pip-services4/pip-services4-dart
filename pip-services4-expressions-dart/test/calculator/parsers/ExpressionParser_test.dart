import 'package:pip_services4_expressions/src/calculator/parsers/parsers.dart';
import 'package:pip_services4_expressions/src/variants/variants.dart';
import 'package:test/test.dart';

void main() {
  group('ExpressionParser', () {
    test('ParseString', () async {
      var parser = ExpressionParser();
      parser.expression = '(2+2)*ABS(-2)';
      var expectedTokens = [
        ExpressionToken(
            ExpressionTokenType.Constant, Variant.fromInteger(2), 0, 0),
        ExpressionToken(
            ExpressionTokenType.Constant, Variant.fromInteger(2), 0, 0),
        ExpressionToken(ExpressionTokenType.Plus, Variant.Empty, 0, 0),
        ExpressionToken(
            ExpressionTokenType.Constant, Variant.fromInteger(2), 0, 0),
        ExpressionToken(ExpressionTokenType.Unary, Variant.Empty, 0, 0),
        ExpressionToken(
            ExpressionTokenType.Constant, Variant.fromInteger(1), 0, 0),
        ExpressionToken(
            ExpressionTokenType.Function, Variant.fromString('ABS'), 0, 0),
        ExpressionToken(ExpressionTokenType.Star, Variant.Empty, 0, 0),
      ];

      var tokens = parser.resultTokens;
      expect(expectedTokens.length, tokens.length);

      for (var i = 0; i < tokens.length; i++) {
        expect(expectedTokens[i].type, tokens[i].type);
        expect(expectedTokens[i].value.type, tokens[i].value.type);
        expect(expectedTokens[i].value.asObject, tokens[i].value.asObject);
      }
    });

    test('WrongExpression', () async {
      var parser = ExpressionParser();
      parser.expression = '1 > 2';
      expect('1 > 2', parser.expression);
    });
  });
}
