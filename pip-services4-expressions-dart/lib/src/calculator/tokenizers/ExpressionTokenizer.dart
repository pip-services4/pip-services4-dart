import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';

import 'ExpressionNumberState.dart';
import 'ExpressionQuoteState.dart';
import 'ExpressionSymbolState.dart';
import 'ExpressionWordState.dart';

class ExpressionTokenizer extends AbstractTokenizer {
  ExpressionTokenizer() : super() {
    decodeStrings = false;

    whitespaceState = GenericWhitespaceState();

    symbolState = ExpressionSymbolState();
    numberState = ExpressionNumberState();
    quoteState = ExpressionQuoteState();
    wordState = ExpressionWordState();
    commentState = CppCommentState();

    clearCharacterStates();
    setCharacterState(0x0000, 0xfffe, symbolState!);
    setCharacterState(0, ' '.codeUnitAt(0), whitespaceState!);

    setCharacterState('a'.codeUnitAt(0), 'z'.codeUnitAt(0), wordState!);
    setCharacterState('A'.codeUnitAt(0), 'Z'.codeUnitAt(0), wordState!);
    setCharacterState(0x00c0, 0x00ff, wordState!);
    setCharacterState('_'.codeUnitAt(0), '_'.codeUnitAt(0), wordState!);

    setCharacterState('0'.codeUnitAt(0), '9'.codeUnitAt(0), numberState!);
    setCharacterState('-'.codeUnitAt(0), '-'.codeUnitAt(0), numberState!);
    setCharacterState('.'.codeUnitAt(0), '.'.codeUnitAt(0), numberState!);

    setCharacterState('"'.codeUnitAt(0), '"'.codeUnitAt(0), quoteState!);
    setCharacterState('\''.codeUnitAt(0), '\''.codeUnitAt(0), quoteState!);

    setCharacterState('/'.codeUnitAt(0), '/'.codeUnitAt(0), commentState!);
  }
}
