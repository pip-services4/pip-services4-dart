import 'package:pip_services4_expressions/src/io/IScanner.dart';

class StringScanner implements IScanner {
  static const int Eof = -1;

  final String _content;
  int _position;
  int _line;
  int _column;

  /// Creates an instance of this class.
  /// - [content] A text content to be read.
  StringScanner(String content)
      : _content = content,
        _position = -1,
        _line = 1,
        _column = 0;

  /// Returns character from a specified position in the stream
  /// - [position] a position to read character
  /// Returns a character from the specified position or EOF (-1)
  int _charAt(int position) {
    if (position < 0 || position >= _content.length) {
      return StringScanner.Eof;
    }

    return _content.codeUnitAt(position);
  }

  /// Checks if the current character represents a new line
  /// - [charBefore] the character before the current one
  /// - [charAt] the current character
  /// - [charAfter] the character after the current one
  /// Returns true if the current character is a new line, or false otherwise.
  bool _isLine(int charBefore, int charAt, int charAfter) {
    if (charAt != 10 && charAt != 13) {
      return false;
    }
    if (charAt == 13 && (charBefore == 10 || charAfter == 10)) {
      return false;
    }
    return true;
  }

  /// Checks if the current character represents a column
  /// - [charAt] the current character
  /// Returns true if the current character is a column, or false otherwise.
  bool _isColumn(int charAt) {
    if (charAt == 10 || charAt == 13) {
      return false;
    }
    return true;
  }

  /// Gets the current line number
  /// Returns The current line number in the stream
  @override
  int line() => _line;

  /// Gets the column in the current line
  /// Returns The column in the current line in the stream
  @override
  int column() => _column;

  /// Reads character from the top of the stream.
  /// Returns A read character or -1 if stream processed to the end.
  @override
  int read() {
    // Skip if we are at the end
    if ((_position + 1) > _content.length) {
      return StringScanner.Eof;
    }

    // Update the current position
    _position++;

    if (_position >= _content.length) {
      return StringScanner.Eof;
    }

    // Update line and columns
    var charBefore = _charAt(_position - 1);
    var charAt = _charAt(_position);
    var charAfter = _charAt(_position + 1);

    if (_isLine(charBefore, charAt, charAfter)) {
      _line++;
      _column = 0;
    }
    if (_isColumn(charAt)) {
      _column++;
    }

    return charAt;
  }

  /// Gives the character from the top of the stream without moving the stream pointer.
  /// Returns A character from the top of the stream or -1 if stream is empty.
  @override
  int peek() => _charAt(_position + 1);

  /// Gets the next character line number
  /// Returns The next character line number in the stream
  @override
  int peekLine() {
    var charBefore = _charAt(_position);
    var charAt = _charAt(_position + 1);
    var charAfter = _charAt(_position + 2);

    return _isLine(charBefore, charAt, charAfter) ? _line + 1 : _line;
  }

  /// Gets the next character column number
  /// Returns The next character column number in the stream
  @override
  int peekColumn() {
    var charBefore = _charAt(_position);
    var charAt = _charAt(_position + 1);
    var charAfter = _charAt(_position + 2);

    if (_isLine(charBefore, charAt, charAfter)) {
      return 0;
    }

    return _isColumn(charAt) ? _column + 1 : _column;
  }

  /// Puts the one character back into the stream stream.
  /// - [value] A character to be pushed back.
  @override
  void unread() {
    // Skip if we are at the beginning
    if (_position < -1) {
      return;
    }

    // Update the current position
    _position--;

    // Update line and columns (optimization)
    if (_column > 0) {
      _column--;
      return;
    }

    // Update line and columns (full version)
    _line = 1;
    _column = 0;

    var charBefore = StringScanner.Eof;
    var charAt = StringScanner.Eof;
    var charAfter = _charAt(0);

    for (var position = 0; position <= _position; position++) {
      charBefore = charAt;
      charAt = charAfter;
      charAfter = _charAt(position + 1);

      if (_isLine(charBefore, charAt, charAfter)) {
        _line++;
        _column = 0;
      }
      if (_isColumn(charAt)) {
        _column++;
      }
    }
  }

  /// Pushes the specified number of characters to the top of the stream.
  /// - [count] A number of characcted to be pushed back.
  @override
  void unreadMany(int count) {
    while (count > 0) {
      unread();
      count--;
    }
  }

  /// Resets scanner to the initial position
  @override
  void reset() {
    _position = -1;
    _line = 1;
    _column = 0;
  }
}
