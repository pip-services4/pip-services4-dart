import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:test/test.dart';

void main() {
  group('GenericWordState', () {
    test('NextToken', () {
      var state = GenericWordState();

      var scanner = StringScanner('AB_CD=');
      var token = state.nextToken(scanner, null);
      expect('AB_CD', token?.value);
      expect(TokenType.Word, token?.type);
    });
  });
}
