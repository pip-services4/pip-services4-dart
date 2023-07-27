import 'package:pip_services4_expressions/src/tokenizers/generic/generic.dart';
import 'package:pip_services4_expressions/src/tokenizers/tokenizers.dart';

/// Implements a symbol state object.
class ExpressionSymbolState extends GenericSymbolState {
  /// Constructs an instance of this class.
  ExpressionSymbolState() : super() {
    add('<=', TokenType.Symbol);
    add('>=', TokenType.Symbol);
    add('<>', TokenType.Symbol);
    add('!=', TokenType.Symbol);
    add('>>', TokenType.Symbol);
    add('<<', TokenType.Symbol);
  }
}
