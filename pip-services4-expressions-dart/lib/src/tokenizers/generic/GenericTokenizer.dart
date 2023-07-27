import '../AbstractTokenizer.dart';
import '../TokenType.dart';
import 'GenericCommentState.dart';
import 'GenericNumberState.dart';
import 'GenericQuoteState.dart';
import 'GenericSymbolState.dart';
import 'GenericWhitespaceState.dart';
import 'GenericWordState.dart';

/// Implements a default tokenizer class.
class GenericTokenizer extends AbstractTokenizer {
  GenericTokenizer() : super() {
    symbolState = GenericSymbolState();
    symbolState!.add('<>', TokenType.Symbol);
    symbolState!.add('<=', TokenType.Symbol);
    symbolState!.add('>=', TokenType.Symbol);

    numberState = GenericNumberState();
    quoteState = GenericQuoteState();
    whitespaceState = GenericWhitespaceState();
    wordState = GenericWordState();
    commentState = GenericCommentState();

    clearCharacterStates();
    setCharacterState(0x0000, 0x00ff, symbolState!);
    setCharacterState(0x0000, ' '.codeUnitAt(0), whitespaceState!);

    setCharacterState('a'.codeUnitAt(0), 'z'.codeUnitAt(0), wordState!);
    setCharacterState('A'.codeUnitAt(0), 'Z'.codeUnitAt(0), wordState!);
    setCharacterState(0x00c0, 0x00ff, wordState!);
    setCharacterState(0x0100, 0xfffe, wordState!);

    setCharacterState('-'.codeUnitAt(0), '-'.codeUnitAt(0), numberState!);
    setCharacterState('0'.codeUnitAt(0), '9'.codeUnitAt(0), numberState!);
    setCharacterState('.'.codeUnitAt(0), '.'.codeUnitAt(0), numberState!);

    setCharacterState('"'.codeUnitAt(0), '"'.codeUnitAt(0), quoteState!);
    setCharacterState('\''.codeUnitAt(0), '\''.codeUnitAt(0), quoteState!);

    setCharacterState('#'.codeUnitAt(0), '#'.codeUnitAt(0), commentState!);
  }
}
