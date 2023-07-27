import 'package:pip_services4_expressions/src/variants/variants.dart';

import 'ExpressionTokenType.dart';

class ExpressionToken {
  final ExpressionTokenType _type;
  final Variant _value;
  final int _line;
  final int _column;

  /// Creates an instance of this token and initializes it with specified values.
  /// - [type] The type of this token.
  /// - [value] The value of this token.
  /// - [line] the line number where the token is.
  /// - [column] the column number where the token is.
  ExpressionToken(
      ExpressionTokenType? type, Variant? value, int? line, int? colum)
      : _type = type ?? ExpressionTokenType.Unknown,
        _value = value ?? Variant.Empty,
        _line = line ?? 0,
        _column = colum ?? 0;

  /// The type of this token.
  ExpressionTokenType get type => _type;

  /// The value of this token.
  Variant get value => _value;

  /// The line number where the token is.
  int get line => _line;

  /// The column number where the token is.
  int get column => _column;
}
