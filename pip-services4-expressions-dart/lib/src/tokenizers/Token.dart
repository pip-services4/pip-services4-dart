import 'TokenType.dart';

/// A token represents a logical chunk of a string. For example, a typical tokenizer would break
/// the string "1.23 &lt;= 12.3" into three tokens: the number 1.23, a less-than-or-equal symbol,
/// and the number 12.3. A token is a receptacle, and relies on a tokenizer to decide precisely how
/// to divide a string into tokens.
class Token {
  final TokenType _type;
  final String? _value;
  final int _line;
  final int _column;

  /// Constructs this token with type and value.
  /// - [type] The type of this token.
  /// - [value] The token string value.
  /// - [line] The line number where the token is.
  /// - [column] The column number where the token is.
  Token(TokenType type, String? value, int line, int column)
      : _type = type,
        _value = value,
        _line = line,
        _column = column;

  /// The token type.
  TokenType get type => _type;

  /// The token value.
  String? get value => _value;

  /// The line number where the token is.
  int get line => _line;

  /// The column number where the token is.
  int get column => _column;

  bool equals(dynamic obj) {
    if (obj is Token) {
      var token = obj;
      return token._type == _type && token._value == _value;
    }
    return false;
  }
}
