import 'package:pip_services4_expressions/src/mustache/parsers/parsers.dart';
import 'package:test/test.dart';

void main() {
  group('MustacheParser', () {
    test('LexicalAnalysis', () {
      var parser = MustacheParser();
      parser.template =
          'Hello, {{{NAME}}}{{ #if ESCLAMATION }}!{{/if}}{{{^ESCLAMATION}}}.{{{/ESCLAMATION}}}';
      var expectedTokens = <MustacheToken>[
        MustacheToken(MustacheTokenType.Value, 'Hello, ', 0, 0),
        MustacheToken(MustacheTokenType.EscapedVariable, 'NAME', 0, 0),
        MustacheToken(MustacheTokenType.Section, 'ESCLAMATION', 0, 0),
        MustacheToken(MustacheTokenType.Value, '!', 0, 0),
        MustacheToken(MustacheTokenType.SectionEnd, null, 0, 0),
        MustacheToken(MustacheTokenType.InvertedSection, 'ESCLAMATION', 0, 0),
        MustacheToken(MustacheTokenType.Value, '.', 0, 0),
        MustacheToken(MustacheTokenType.SectionEnd, 'ESCLAMATION', 0, 0),
      ];

      var tokens = parser.initialTokens;
      expect(expectedTokens.length, tokens.length);

      for (var i = 0; i < tokens.length; i++) {
        expect(expectedTokens[i].type, tokens[i].type);
        expect(expectedTokens[i].value, tokens[i].value);
      }
    });

    test('SyntaxAnalysis', () {
      var parser = MustacheParser();
      parser.template =
          'Hello, {{{NAME}}}{{ #if ESCLAMATION }}!{{/if}}{{{^ESCLAMATION}}}.{{{/ESCLAMATION}}}';
      var expectedTokens = <MustacheToken>[
        MustacheToken(MustacheTokenType.Value, 'Hello, ', 0, 0),
        MustacheToken(MustacheTokenType.EscapedVariable, 'NAME', 0, 0),
        MustacheToken(MustacheTokenType.Section, 'ESCLAMATION', 0, 0),
        MustacheToken(MustacheTokenType.InvertedSection, 'ESCLAMATION', 0, 0),
      ];

      var tokens = parser.resultTokens;
      expect(expectedTokens.length, tokens.length);

      for (var i = 0; i < tokens.length; i++) {
        expect(expectedTokens[i].type, tokens[i].type);
        expect(expectedTokens[i].value, tokens[i].value);
      }
    });

    test('VariableNames', () {
      var parser = MustacheParser();
      parser.template =
          'Hello, {{{NAME}}}{{ #if ESCLAMATION }}!{{/if}}{{{^ESCLAMATION}}}.{{{/ESCLAMATION}}}';
      expect(2, parser.variableNames.length);
      expect('NAME', parser.variableNames[0]);
      expect('ESCLAMATION', parser.variableNames[1]);
    });
  });
}
