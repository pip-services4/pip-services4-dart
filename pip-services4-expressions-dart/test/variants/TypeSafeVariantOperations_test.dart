import 'package:pip_services4_expressions/src/variants/variants.dart';
import 'package:test/test.dart';

void main() {
  group('TypeSafeVariantOperations', () {
    test('Operations', () {
      var a = Variant(123);
      var manager = TypeSafeVariantOperations();

      var b = manager.convert(a, VariantType.Float);
      expect(VariantType.Float, b.type);
      expect(123.0, b.asFloat);

      var c = Variant(2);
      expect(125, manager.add(a, c).asInteger);
      expect(121, manager.sub(a, c).asInteger);
      expect(manager.equal(a, c).asBoolean, isFalse);

      var array = [
        Variant('aaa'),
        Variant('bbb'),
        Variant('ccc'),
        Variant('ddd')
      ];
      var d = Variant(array);
      expect(manager.in_(d, Variant('ccc')).asBoolean, isTrue);
      expect(manager.in_(d, Variant('eee')).asBoolean, isFalse);
      expect('bbb', manager.getElement(d, Variant(1)).asString);
    });
  });
}
