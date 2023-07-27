import 'package:pip_services4_expressions/src/mustache/mustache.dart';
import 'package:test/test.dart';

void main() {
  group('MustacheTemplate', () {
    test('Template1', () {
      var template = MustacheTemplate();
      template.template =
          'Hello, {{{NAME}}}{{ #if ESCLAMATION }}!{{/if}}{{{^ESCLAMATION}}}.{{{/ESCLAMATION}}}';
      var variables = {'NAME': 'Alex', 'ESCLAMATION': '1'};
      var result = template.evaluateWithVariables(variables);
      expect('Hello, Alex!', result);

      template.defaultVariables['name'] = 'Mike';
      template.defaultVariables['esclamation'] = false;

      result = template.evaluate();
      expect('Hello, Mike.', result);
    });
  });
}
