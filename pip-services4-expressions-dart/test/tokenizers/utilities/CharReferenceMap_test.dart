import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';
import 'package:test/test.dart';

void main() {
  group('CharReferenceMap', () {
    test('DefaultInterval', () {
      var map = CharReferenceMap<dynamic>();
      expect(map.lookup('A'.codeUnitAt(0)), isNull);
      expect(map.lookup(0x2045), isNull);

      map.addDefaultInterval(true);
      expect(map.lookup('A'.codeUnitAt(0)), isNotNull);
      expect(map.lookup(0x2045), isNotNull);

      map.clear();
      expect(map.lookup('A'.codeUnitAt(0)), isNull);
      expect(map.lookup(0x2045), isNull);
    });

    test('Interval', () {
      var map = CharReferenceMap<dynamic>();
      expect(map.lookup('A'.codeUnitAt(0)), isNull);
      expect(map.lookup(0x2045), isNull);

      map.addInterval('A'.codeUnitAt(0), 'z'.codeUnitAt(0), true);
      expect(map.lookup('A'.codeUnitAt(0)), isNotNull);
      expect(map.lookup(0x2045), isNull);

      map.addInterval(0x2000, 0x20ff, true);
      expect(map.lookup('A'.codeUnitAt(0)), isNotNull);
      expect(map.lookup(0x2045), isNotNull);

      map.clear();
      expect(map.lookup('A'.codeUnitAt(0)), isNull);
      expect(map.lookup(0x2045), isNull);

      map.addInterval('A'.codeUnitAt(0), 0x20ff, true);
      expect(map.lookup('A'.codeUnitAt(0)), isNotNull);
      expect(map.lookup(0x2045), isNotNull);
    });
  });
}
