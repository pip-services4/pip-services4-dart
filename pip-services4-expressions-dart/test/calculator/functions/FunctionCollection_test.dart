import 'package:pip_services4_expressions/src/calculator/functions/functions.dart';
import 'package:pip_services4_expressions/src/variants/variants.dart';
import 'package:test/test.dart';

void main() {
  group('FunctionCollection', () {
    testFunc(params, variantOperations) async => Variant('ABC');

    test('AddRemoveFunctions', () async {
      var collection = FunctionCollection();

      var func1 = DelegatedFunction('ABC', testFunc);
      collection.add(func1);
      expect(1, collection.length);

      var func2 = DelegatedFunction('XYZ', testFunc);
      collection.add(func2);
      expect(2, collection.length);

      var index = collection.findIndexByName('abc');
      expect(0, index);

      var func = collection.findByName('Xyz');
      expect(func2, func);

      collection.remove(0);
      expect(1, collection.length);

      collection.removeByName('XYZ');
      expect(0, collection.length);
    });
  });
}
