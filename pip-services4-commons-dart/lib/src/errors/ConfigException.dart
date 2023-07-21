import './ErrorCategory.dart';
import './ApplicationException.dart';

/// Errors related to mistakes in the microservice's user-defined configurations.

class ConfigException extends ApplicationException {
  /// Creates an error instance and assigns its values.
  ///
  /// - [trace_id]    (optional) a unique transaction id to trace execution through call chain.
  /// - [code]              (optional) a unique error code. Default: 'UNKNOWN'
  /// - [message]           (optional) a human-readable description of the error.
  ///
  /// See [ErrorCategory]

  ConfigException([String? trace_id, String? code, String? message])
      : super(ErrorCategory.Misconfiguration, trace_id, code, message) {
    status = 500;
  }
}
