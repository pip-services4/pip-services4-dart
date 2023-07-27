import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';
import 'package:test/test.dart';

void main() {
  group('CCommentState', () {
    test('NextToken', () {
      var state = CCommentState();

      var scanner = StringScanner('// Comment \n Comment ');
      var failed = false;
      try {
        state.nextToken(scanner, null);
      } catch (e) {
        failed = true;
      }
      expect(failed, isTrue);

      scanner = StringScanner('/* Comment \n Comment */#');
      var token = state.nextToken(scanner, null);
      expect('/* Comment \n Comment */', token?.value);
      expect(TokenType.Comment, token?.type);
    });
  });
}
