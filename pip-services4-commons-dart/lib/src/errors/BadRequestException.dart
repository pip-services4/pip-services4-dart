import './ErrorCategory.dart';
import './ApplicationException.dart';

/// Errors due to improper user requests.
///
/// For example: missing or incorrect parameters.

class BadRequestException extends ApplicationException {
  /// Creates an error instance and assigns its values.
  ///
  /// - [trace_id]    (optional) a unique transaction id to trace execution through call chain.
  /// - [code]              (optional) a unique error code. Default: 'UNKNOWN'
  /// - [message]           (optional) a human-readable description of the error.
  ///
  /// See [ErrorCategory]

  BadRequestException([String? trace_id, String? code, String? message])
      : super(ErrorCategory.BadRequest, trace_id, code, message) {
    status = 400;
  }
}
