import 'package:pip_services4_expressions/src/variants/variants.dart';
import 'package:test/test.dart';

void main() {
  group('TypeUnsafeVariantOperations', () {
    test('Operations', () {
      var a = Variant('123');
      var manager = TypeUnsafeVariantOperations();

      var b = manager.convert(a, VariantType.Float);
      expect(VariantType.Float, b.type);
      expect(123.0, b.asFloat);

      var c = Variant(2);
      expect(125.0, manager.add(b, c).asFloat);
      expect(121.0, manager.sub(b, c).asFloat);
      expect(manager.equal(a, b).asBoolean, isTrue);
    });
  });
}
