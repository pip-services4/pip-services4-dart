import './ErrorCategory.dart';
import './ApplicationException.dart';

/// Errors in read/write local disk operations.

class FileException extends ApplicationException {
  /// Creates an error instance and assigns its values.
  ///
  /// - [trace_id]    (optional) a unique transaction id to trace execution through call chain.
  /// - [code]              (optional) a unique error code. Default: 'UNKNOWN'
  /// - mes[sage           (optional) a human-readable description of the error.
  ///
  /// See [ErrorCategory]

  FileException([String? trace_id, String? code, String? message])
      : super(ErrorCategory.FileError, trace_id, code, message) {
    status = 500;
  }
}
