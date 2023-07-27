import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_expressions/src/calculator/functions/functions.dart';
import 'package:pip_services4_expressions/src/variants/variants.dart';
import 'package:test/test.dart';

void main() {
  group('DefaultFunctionCollection', () {
    test('CalculateFunctions', () async {
      var collection = DefaultFunctionCollection();
      var params = [Variant(1), Variant(2), Variant(3)];
      var operations = TypeUnsafeVariantOperations();

      var func = collection.findByName('sum');
      expect(func, isNotNull);
      var result = await func!.calculate(params, operations);
      expect(VariantType.Integer, result.type);
      expect(6, result.asInteger);
    });

    test('DateFunctions', () async {
      var collection = DefaultFunctionCollection();
      var params = <Variant>[];
      var operations = TypeUnsafeVariantOperations();

      var func = collection.findByName('now');
      expect(func, isNotNull);

      var result = await func!.calculate(params, operations);
      expect(VariantType.DateTime, result.type);

      collection = DefaultFunctionCollection();
      params = [Variant(1975), Variant(4), Variant(8)];

      func = collection.findByName('date');
      expect(func, isNotNull);

      result = await func!.calculate(params, operations);
      expect(VariantType.DateTime, result.type);
      expect(StringConverter.toString2(DateTime(1975, 3, 8)),
          StringConverter.toString2(result.asDateTime));
    });
  });
}
