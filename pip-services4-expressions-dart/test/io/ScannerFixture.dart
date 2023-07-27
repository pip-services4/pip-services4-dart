import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:test/test.dart';

class ScannerFixture {
  final IScanner _scanner;
  final String _content;

  ScannerFixture(IScanner scanner, String content)
      : _scanner = scanner,
        _content = content;

  void testRead() {
    _scanner.reset();

    for (var i = 0; i < _content.length; i++) {
      var chr = _scanner.read();
      expect(_content.codeUnitAt(i), chr);
    }

    var chr = _scanner.read();
    expect(-1, chr);

    chr = _scanner.read();
    expect(-1, chr);
  }

  void testUnread() {
    _scanner.reset();

    var chr = _scanner.peek();
    expect(_content.codeUnitAt(0), chr);

    chr = _scanner.read();
    expect(_content.codeUnitAt(0), chr);

    chr = _scanner.read();
    expect(_content.codeUnitAt(1), chr);

    _scanner.unread();
    chr = _scanner.read();
    expect(_content.codeUnitAt(1), chr);

    _scanner.unreadMany(2);
    chr = _scanner.read();
    expect(_content.codeUnitAt(0), chr);
    chr = _scanner.read();
    expect(_content.codeUnitAt(1), chr);
  }

  void testLineColumn(int position, int charAt, int line, int column) {
    _scanner.reset();

    // Get in position
    while (position > 1) {
      _scanner.read();
      position--;
    }

    // Test forward scanning
    var chr = _scanner.read();
    expect(charAt, chr);
    var ln = _scanner.line();
    expect(line, ln);
    var col = _scanner.column();
    expect(column, col);

    // Moving backward
    chr = _scanner.read();
    if (chr != -1) {
      _scanner.unread();
    }
    _scanner.unread();

    // Test backward scanning
    chr = _scanner.read();
    expect(charAt, chr);
    ln = _scanner.line();
    expect(line, ln);
    col = _scanner.column();
    expect(column, col);
  }
}
