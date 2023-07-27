import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';

import 'MustacheSpecialState.dart';

class MustacheTokenizer extends AbstractTokenizer {
  bool _special = true;
  ITokenizerState _specialState;

  /// Constructs this object with default parameters.
  MustacheTokenizer()
      : _specialState = MustacheSpecialState(),
        super() {
    symbolState = GenericSymbolState();
    symbolState!.add('{{', TokenType.Symbol);
    symbolState!.add('}}', TokenType.Symbol);
    symbolState!.add('{{{', TokenType.Symbol);
    symbolState!.add('}}}', TokenType.Symbol);

    numberState = null;
    quoteState = GenericQuoteState();
    whitespaceState = GenericWhitespaceState();
    wordState = GenericWordState();
    commentState = null;
    _specialState = MustacheSpecialState();

    clearCharacterStates();
    setCharacterState(0x0000, 0x00ff, symbolState!);
    setCharacterState(0x0000, ' '.codeUnitAt(0), whitespaceState!);

    setCharacterState('a'.codeUnitAt(0), 'z'.codeUnitAt(0), wordState!);
    setCharacterState('A'.codeUnitAt(0), 'Z'.codeUnitAt(0), wordState!);
    setCharacterState('0'.codeUnitAt(0), '9'.codeUnitAt(0), wordState!);
    setCharacterState('_'.codeUnitAt(0), '_'.codeUnitAt(0), wordState!);
    setCharacterState(0x00c0, 0x00ff, wordState!);
    setCharacterState(0x0100, 0xfffe, wordState!);

    setCharacterState('"'.codeUnitAt(0), '"'.codeUnitAt(0), quoteState!);
    setCharacterState('\''.codeUnitAt(0), '\''.codeUnitAt(0), quoteState!);

    skipWhitespaces = true;
    skipComments = true;
    skipEof = true;
  }

  /// Reads the next token.
  /// Returns next token
  @override
  Token? readNextToken() {
    if (scanner == null) {
      return null;
    }

    // Check for initial state
    if (nextTokenValue == null && lastTokenType == TokenType.Unknown) {
      _special = true;
    }

    // Process quotes
    if (_special) {
      var token = _specialState.nextToken(scanner!, this);
      if (token != null && token.value != '') {
        return token;
      }
    }

    // Proces other tokens
    _special = false;
    var token = super.readNextToken();
    // Switch to quote when '{{' or '{{{' symbols found
    if (token != null && (token.value == '}}' || token.value == '}}}')) {
      _special = true;
    }
    return token;
  }
}
