import './ErrorCategory.dart';
import './ApplicationException.dart';

/// Errors returned by remote services or by the network during call attempts.

class InvocationException extends ApplicationException {
  /// Creates an error instance and assigns its values.
  ///
  /// - [trace_id]    (optional) a unique transaction id to trace execution through call chain.
  /// - [code]              (optional) a unique error code. Default: 'UNKNOWN'
  /// - [message]           (optional) a human-readable description of the error.
  ///
  /// See [ErrorCategory]

  InvocationException([String? trace_id, String? code, String? message])
      : super(ErrorCategory.FailedInvocation, trace_id, code, message) {
    status = 500;
  }
}
