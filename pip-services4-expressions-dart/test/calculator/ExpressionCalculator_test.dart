import 'package:pip_services4_expressions/src/calculator/calculator.dart';
import 'package:pip_services4_expressions/src/variants/variants.dart';
import 'package:test/test.dart';

void main() {
  group('ExpressionCalculator', () {
    test('SimpleExpression', () async {
      var calculator = ExpressionCalculator();

      calculator.expression = '2 + 2';
      var result = await calculator.evaluate();
      expect(VariantType.Integer, result.type);
      expect(4, result.asInteger);
    });

    test('FunctionExpression', () async {
      var calculator = ExpressionCalculator();

      calculator.expression = 'A + b / (3 - Max(-123, 1)*2)';
      // calculator.expression = "Abs(1)";
      expect('A', calculator.defaultVariables.findByName('a')?.name);
      expect('b', calculator.defaultVariables.findByName('b')?.name);
      calculator.defaultVariables.findByName('a')!.value = Variant('xyz');
      calculator.defaultVariables.findByName('b')!.value = Variant(123);

      var result = await calculator.evaluate();
      expect(VariantType.String, result.type);
      expect('xyz123', result.asString);
    });

    test('ArrayExpression', () async {
      var calculator = ExpressionCalculator();

      calculator.expression = "'abc'[1]";
      var result = await calculator.evaluate();
      expect(VariantType.String, result.type);
      expect('b', result.asString);
    });

    test('BooleanExpression', () async {
      var calculator = ExpressionCalculator();

      calculator.expression = '1 > 2';
      var result = await calculator.evaluate();
      expect(VariantType.Boolean, result.type);
      expect(result.asBoolean, false);
    });

    test('UnknownFunction', () async {
      var calculator = ExpressionCalculator();

      calculator.expression = 'XXX(1)';
      try {
        await calculator.evaluate();
        fail('Expected exception on unknown function');
      } catch (e) {
        // Expected exception
      }
    });

    test('InExpression', () async {
      var calculator = ExpressionCalculator();

      calculator.expression = '2 IN ARRAY(1,2,3)';
      var result = await calculator.evaluate();
      expect(VariantType.Boolean, result.type);
      expect(result.asBoolean, true);

      calculator = ExpressionCalculator();

      calculator.expression = '5 NOT IN ARRAY(1,2,3)';
      result = await calculator.evaluate();
      expect(VariantType.Boolean, result.type);
      expect(result.asBoolean, true);
    });
  });
}
