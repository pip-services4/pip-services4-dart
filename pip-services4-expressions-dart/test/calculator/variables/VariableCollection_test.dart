import 'package:pip_services4_expressions/src/calculator/variables/variables.dart';
import 'package:test/test.dart';

void main() {
  group('VariableCollection', () {
    test('AddRemoveVariables', () {
      var collection = VariableCollection();

      var var1 = Variable('ABC');
      collection.add(var1);
      expect(1, collection.length);

      var var2 = Variable('XYZ');
      collection.add(var2);
      expect(2, collection.length);

      var index = collection.findIndexByName('abc');
      expect(0, index);

      var v = collection.findByName('Xyz');
      expect(var2, v);

      var var3 = collection.locate('ghi');
      expect(var3, isNotNull);
      expect('ghi', var3.name);
      expect(3, collection.length);

      collection.remove(0);
      expect(2, collection.length);

      collection.removeByName('GHI');
      expect(1, collection.length);
    });
  });
}
