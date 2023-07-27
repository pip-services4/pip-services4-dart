import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';

import 'CsvConstant.dart';
import 'CsvQuoteState.dart';
import 'CsvSymbolState.dart';
import 'CsvWordState.dart';

/// Implements a tokenizer class for CSV files.
class CsvTokenizer extends AbstractTokenizer {
  var _fieldSeparators = [','.codeUnitAt(0)];
  var _quoteSymbols = ['"'.codeUnitAt(0)];
  String _endOfLine = '\n\r';

  /// Separator for fields in CSV stream.
  List<int> get fieldSeparators => _fieldSeparators;

  /// Separator for fields in CSV stream.
  set fieldSeparators(List<int> value) {
    for (var fieldSeparator in value) {
      if (fieldSeparator == CsvConstant.CR ||
          fieldSeparator == CsvConstant.LF ||
          fieldSeparator == CsvConstant.Nil) {
        throw Exception('Invalid field separator.');
      }

      for (var quoteSymbol in quoteSymbols) {
        if (fieldSeparator == quoteSymbol) {
          throw Exception('Invalid field separator.');
        }
      }
    }

    _fieldSeparators = value;
    wordState = CsvWordState(value, quoteSymbols);
    _assignStates();
  }

  /// Separator for rows in CSV stream.
  String get endOfLine => _endOfLine;

  /// Separator for rows in CSV stream.
  set endOfLine(String value) {
    _endOfLine = value;
  }

  /// Character to quote strings.
  List<int> get quoteSymbols => _quoteSymbols;

  /// Character to quote strings.
  set quoteSymbols(List<int> value) {
    for (var quoteSymbol in value) {
      if (quoteSymbol == CsvConstant.CR ||
          quoteSymbol == CsvConstant.LF ||
          quoteSymbol == CsvConstant.Nil) {
        throw Exception('Invalid quote symbol.');
      }

      for (var fieldSeparator in fieldSeparators) {
        if (quoteSymbol == fieldSeparator) {
          throw Exception('Invalid quote symbol.');
        }
      }
    }

    _quoteSymbols = value;
    wordState = CsvWordState(fieldSeparators, value);
    _assignStates();
  }

  /// Assigns tokenizer states to correct characters.
  void _assignStates() {
    clearCharacterStates();
    setCharacterState(0x0000, 0xfffe, wordState!);
    setCharacterState(CsvConstant.CR, CsvConstant.CR, symbolState!);
    setCharacterState(CsvConstant.LF, CsvConstant.LF, symbolState!);

    for (var fieldSeparator in fieldSeparators) {
      setCharacterState(fieldSeparator, fieldSeparator, symbolState!);
    }

    for (var quoteSymbol in quoteSymbols) {
      setCharacterState(quoteSymbol, quoteSymbol, quoteState!);
    }
  }

  /// Constructs this object with default parameters.
  CsvTokenizer() : super() {
    numberState = null;
    whitespaceState = null;
    commentState = null;
    wordState = CsvWordState(fieldSeparators, quoteSymbols);
    symbolState = CsvSymbolState();
    quoteState = CsvQuoteState();
    _assignStates();
  }
}
