import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:test/test.dart';

void main() {
  group('GenericCommentState', () {
    test('NextToken', () {
      var state = GenericCommentState();

      var scanner = StringScanner('# Comment \r# Comment ');
      var token = state.nextToken(scanner, null);
      expect('# Comment ', token?.value);
      expect(TokenType.Comment, token?.type);

      scanner = StringScanner('# Comment \n# Comment ');
      token = state.nextToken(scanner, null);
      expect('# Comment ', token?.value);
      expect(TokenType.Comment, token?.type);
    });
  });
}
