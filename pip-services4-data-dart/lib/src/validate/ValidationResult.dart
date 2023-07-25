import './ValidationResultType.dart';

/// Result generated by schema validation

class ValidationResult {
  String? _path;
  ValidationResultType? _type;
  String? _code;
  String? _message;
  dynamic _expected;
  dynamic _actual;

  /// Creates a new instance of validation ressult and sets its values.
  ///
  /// - [path]      a dot notation path of the validated element.
  /// - [type]      a type of the validation result: Information, Warning, or Error.
  /// - [code]      an error code.
  /// - [message]   a human readable message.
  /// - [expected]  an value expected by schema validation.
  /// - [actual]    an actual value found by schema validation.
  ///
  /// See [ValidationResultType]

  ValidationResult(
      [String? path,
      ValidationResultType? type,
      String? code,
      String? message,
      dynamic expected,
      dynamic actual]) {
    _path = path;
    _type = type;
    _code = code;
    _message = message;
    _expected = expected;
    _actual = actual;
  }

  /// Gets dot notation path of the validated element.
  ///
  /// Returns the path of the validated element.

  String getPath() {
    return _path!;
  }

  /// Gets the type of the validation result: Information, Warning, or Error.
  ///
  /// Returns the type of the validation result.
  ///
  /// See [ValidationResultType]

  ValidationResultType getType() {
    return _type!;
  }

  /// Gets the error code.
  ///
  /// Returns the error code

  String getCode() {
    return _code!;
  }

  /// Gets the human readable message.
  ///
  /// Returns the result message.

  String getMessage() {
    return _message!;
  }

  /// Gets the value expected by schema validation.
  ///
  /// Returns the expected value.

  dynamic getExpected() {
    return _expected;
  }

  /// Gets the actual value found by schema validation.
  ///
  /// Returns the actual value.

  dynamic getActual() {
    return _actual;
  }
}
