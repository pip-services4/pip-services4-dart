import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:test/test.dart';

void main() {
  group('GenericQuoteState', () {
    test('NextToken', () {
      var state = GenericQuoteState();

      var scanner = StringScanner("'ABC#DEF'#");
      var token = state.nextToken(scanner, null);
      expect("'ABC#DEF'", token.value);
      expect(TokenType.Quoted, token.type);

      scanner = StringScanner("'ABC#DEF''");
      token = state.nextToken(scanner, null);
      expect("'ABC#DEF'", token.value);
      expect(TokenType.Quoted, token.type);
    });

    test('Encode and Decode String', () {
      var state = GenericQuoteState();

      var value = state.encodeString('ABC', "'".codeUnitAt(0));
      expect("'ABC'", value);

      value = state.decodeString(value, "'".codeUnitAt(0));
      expect('ABC', value);

      value = state.decodeString("'ABC'DEF'", "'".codeUnitAt(0));
      expect("ABC'DEF", value);
    });
  });
}
