import 'package:pip_services4_expressions/src/tokenizers/utilities/utilities.dart';
import 'package:test/test.dart';

void main() {
  group('CharValidator', () {
    test('IsEof', () {
      expect(CharValidator.isEof(0xffff), isTrue);
      expect(CharValidator.isEof('A'.codeUnitAt(0)), isFalse);
    });

    test('IsEol', () {
      expect(CharValidator.isEol(10), isTrue);
      expect(CharValidator.isEol(13), isTrue);
      expect(CharValidator.isEof('A'.codeUnitAt(0)), isFalse);
    });

    test('IsDigit', () {
      expect(CharValidator.isDigit('0'.codeUnitAt(0)), isTrue);
      expect(CharValidator.isDigit('7'.codeUnitAt(0)), isTrue);
      expect(CharValidator.isDigit('9'.codeUnitAt(0)), isTrue);
      expect(CharValidator.isDigit('A'.codeUnitAt(0)), isFalse);
    });
  });
}
