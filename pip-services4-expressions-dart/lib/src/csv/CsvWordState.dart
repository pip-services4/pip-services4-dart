import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';

import 'CsvConstant.dart';

/// Implements a word state to tokenize CSV stream.
class CsvWordState extends GenericWordState {
  /// Constructs this object with specified parameters.
  /// - [fieldSeparators] Separators for fields in CSV stream.
  /// - [quoteSymbols] Delimiters character to quote strings.
  CsvWordState(List<int> fieldSeparators, List<int> quoteSymbols) : super() {
    clearWordChars();
    setWordChars(0x0000, 0xfffe, true);

    setWordChars(CsvConstant.CR, CsvConstant.CR, false);
    setWordChars(CsvConstant.LF, CsvConstant.LF, false);

    for (var fieldSeparator in fieldSeparators) {
      setWordChars(fieldSeparator, fieldSeparator, false);
    }

    for (var quoteSymbol in quoteSymbols) {
      setWordChars(quoteSymbol, quoteSymbol, false);
    }
  }
}
