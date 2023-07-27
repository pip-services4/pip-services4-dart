import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:test/test.dart';

import 'ScannerFixture.dart';

void main() {
  late String content;
  late StringScanner scanner;
  late ScannerFixture fixture;

  setUp(() {
    content = 'Test String\nLine2\rLine3\r\n\r\nLine5';
    scanner = StringScanner(content);
    fixture = ScannerFixture(scanner, content);
  });
  group('StringScanner', () {
    test('Read', () {
      fixture.testRead();
    });

    test('Unread', () {
      fixture.testUnread();
    });

    test('LineColumn', () {
      fixture.testLineColumn(3, 's'.codeUnitAt(0), 1, 3);
      fixture.testLineColumn(12, '\n'.codeUnitAt(0), 2, 0);
      fixture.testLineColumn(15, 'n'.codeUnitAt(0), 2, 3);
      fixture.testLineColumn(21, 'n'.codeUnitAt(0), 3, 3);
      fixture.testLineColumn(26, '\r'.codeUnitAt(0), 4, 0);
      fixture.testLineColumn(30, 'n'.codeUnitAt(0), 5, 3);
    });
  });
}
