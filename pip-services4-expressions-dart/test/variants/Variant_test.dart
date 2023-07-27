import 'package:pip_services4_expressions/src/variants/variants.dart';
import 'package:test/test.dart';

void main() {
  group('Variant', () {
    test('Variants', () {
      var a = Variant(123);
      expect(VariantType.Integer, a.type);
      expect(123, a.asInteger);
      expect(123, a.asObject);

      var b = Variant('xyz');
      expect(VariantType.String, b.type);
      expect('xyz', b.asString);
      expect('xyz', b.asObject);
    });
  });
}
