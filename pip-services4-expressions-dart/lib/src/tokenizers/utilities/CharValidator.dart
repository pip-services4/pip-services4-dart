class CharValidator {
  static final int Eof = 0xffff;
  static final int Zero = '0'.codeUnitAt(0);
  static final int Nine = '9'.codeUnitAt(0);

  static bool isEof(int value) {
    return value == CharValidator.Eof || value == -1;
  }

  static bool isEol(int value) {
    return value == 10 || value == 13;
  }

  static bool isDigit(int value) {
    return value >= CharValidator.Zero && value <= CharValidator.Nine;
  }
}
