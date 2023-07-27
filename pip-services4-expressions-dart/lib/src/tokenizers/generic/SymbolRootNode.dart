import 'package:pip_services4_expressions/src/io/io.dart';
import 'package:pip_services4_expressions/src/tokenizers/Token.dart';
import 'package:pip_services4_expressions/src/tokenizers/TokenType.dart';

import 'SymbolNode.dart';

/// This class is a special case of a [SymbolNode]. A [SymbolRootNode]
/// object has no symbol of its own, but has children that represent all possible symbols.
class SymbolRootNode extends SymbolNode {
  /// Creates and initializes a root node.
  SymbolRootNode() : super(null, 0);

  /// Add the given string as a symbol.
  /// - [value] The character sequence to add.
  /// - [tokenType] token type
  void add(String value, TokenType tokenType) {
    if (value == '') {
      throw Exception('Value must have at least 1 character');
    }
    var childNode = ensureChildWithChar(value.codeUnitAt(0));
    if (childNode.tokenType == TokenType.Unknown) {
      childNode.valid = true;
      childNode.tokenType = TokenType.Symbol;
    }
    childNode.addDescendantLine(value.substring(1), tokenType);
  }

  /// Return a symbol string from a scanner.
  /// - [scanner] A scanner to read from
  /// Returns A symbol string from a scanner
  Token nextToken(IScanner scanner) {
    var nextSymbol = scanner.read();
    var line = scanner.line();
    var column = scanner.column();

    var childNode = findChildWithChar(nextSymbol);
    if (childNode != null) {
      childNode = childNode.deepestRead(scanner);
      childNode = childNode.unreadToValid(scanner);
      return Token(childNode.tokenType, childNode.ancestry(), line, column);
    } else {
      return Token(
          TokenType.Symbol, String.fromCharCode(nextSymbol), line, column);
    }
  }
}
