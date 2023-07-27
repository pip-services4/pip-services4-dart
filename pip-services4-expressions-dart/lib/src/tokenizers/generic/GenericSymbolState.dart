import 'package:pip_services4_expressions/src/tokenizers/TokenType.dart';

import 'package:pip_services4_expressions/src/tokenizers/Token.dart';

import 'package:pip_services4_expressions/src/tokenizers/ITokenizer.dart';

import 'package:pip_services4_expressions/src/io/IScanner.dart';

import '../ISymbolState.dart';
import 'SymbolRootNode.dart';

/// The idea of a symbol is a character that stands on its own, such as an ampersand or a parenthesis.
///
/// For example, when tokenizing the expression `(isReady)& (isWilling)`, a typical
/// tokenizer would return 7 tokens, including one for each parenthesis and one for the ampersand.
/// Thus a series of symbols such as `)&(` becomes three tokens, while a series of letters
/// such as `isReady` becomes a single word token.
///
/// Multi-character symbols are an exception to the rule that a symbol is a standalone character.
/// For example, a tokenizer may want less-than-or-equals to tokenize as a single token. This class
/// provides a method for establishing which multi-character symbols an object of this class should
/// treat as single symbols. This allows, for example, `"cat <= dog"` to tokenize as
/// three tokens, rather than splitting the less-than and equals symbols into separate tokens.
///
/// By default, this state recognizes the following multi-character symbols:
/// `!=, :-, <=, >=`
class GenericSymbolState implements ISymbolState {
  final _symbols = SymbolRootNode();

  /// Add a multi-character symbol.
  /// - [value] The symbol to add, such as "=:="
  /// - [tokenType] type of the token
  @override
  void add(String value, TokenType tokenType) {
    _symbols.add(value, tokenType);
  }

  /// Return a symbol token from a scanner.
  /// - [scanner] A textual string to be tokenized.
  /// - [tokenizer] A tokenizer class that controls the process.
  /// Returns The next token from the top of the stream.
  @override
  Token nextToken(IScanner scanner, ITokenizer? tokenizer) {
    return _symbols.nextToken(scanner);
  }
}
