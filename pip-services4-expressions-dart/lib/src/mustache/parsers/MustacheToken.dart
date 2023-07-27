import 'MustacheTokenType.dart';

class MustacheToken {
  final MustacheTokenType _type;
  final String? _value;
  final _tokens = <MustacheToken>[];
  final int _line;
  final int _column;

  /// Creates an instance of a mustache token.
  /// - [type] a token type.
  /// - [value] a token value.
  /// - [line] a line number where the token is.
  /// - [column] a column numer where the token is.
  MustacheToken(MustacheTokenType? type, String? value, int? line, int? column)
      : _type = type ?? MustacheTokenType.Unknown,
        _value = value,
        _line = line ?? 0,
        _column = column ?? 0;

  /// Gets the token type.
  MustacheTokenType get type => _type;

  /// Gets the token value or variable name.
  String? get value => _value;

  /// Gets a list of subtokens is this token a section.
  List<MustacheToken> get tokens => _tokens;

  /// The line number where the token is.
  int get line => _line;

  /// The column number where the token is.
  int get column => _column;
}
