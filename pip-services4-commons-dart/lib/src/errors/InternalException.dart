import './ErrorCategory.dart';
import './ApplicationException.dart';

/// Errors caused by programming mistakes.

class InternalException extends ApplicationException {
  /// Creates an error instance and assigns its values.
  ///
  /// - [trace_id]    (optional) a unique transaction id to trace execution through call chain.
  /// - [code]              (optional) a unique error code. Default: 'UNKNOWN'
  /// - [message]           (optional) a human-readable description of the error.
  ///
  /// See [ErrorCategory]

  InternalException([String? trace_id, String? code, String? message])
      : super(ErrorCategory.Internal, trace_id, code, message) {
    status = 500;
  }
}
