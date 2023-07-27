import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:test/test.dart';

void main() {
  group('GenericNumberState', () {
    test('NextToken', () {
      var state = GenericNumberState();

      var scanner = StringScanner('ABC');
      var failed = false;
      try {
        state.nextToken(scanner, null);
      } catch (e) {
        failed = true;
      }
      expect(failed, isTrue);

      scanner = StringScanner('123#');
      var token = state.nextToken(scanner, null);
      expect('123', token?.value);
      expect(TokenType.Integer, token?.type);

      scanner = StringScanner('-123#');
      token = state.nextToken(scanner, null);
      expect('-123', token?.value);
      expect(TokenType.Integer, token?.type);

      scanner = StringScanner('123.#');
      token = state.nextToken(scanner, null);
      expect('123.', token?.value);
      expect(TokenType.Float, token?.type);

      scanner = StringScanner('123.456#');
      token = state.nextToken(scanner, null);
      expect('123.456', token?.value);
      expect(TokenType.Float, token?.type);

      scanner = StringScanner('-123.456#');
      token = state.nextToken(scanner, null);
      expect('-123.456', token?.value);
      expect(TokenType.Float, token?.type);
    });
  });
}
