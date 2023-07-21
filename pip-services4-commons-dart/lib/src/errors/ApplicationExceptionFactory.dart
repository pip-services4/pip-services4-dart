import './ErrorCategory.dart';
import './ErrorDescription.dart';
import './ApplicationException.dart';
import './UnknownException.dart';
import './InternalException.dart';
import './ConfigException.dart';
import './ConnectionException.dart';
import './InvocationException.dart';
import './FileException.dart';
import './BadRequestException.dart';
import './UnauthorizedException.dart';
import './ConflictException.dart';
import './NotFoundException.dart';
import './UnsupportedException.dart';
import './InvalidStateException.dart';
import '../data/StringValueMap.dart';

/// Factory to recreate exceptions from [ErrorDescription] values passed through the wire.
///
/// See [ErrorDescription]
/// See [ApplicationException]

class ApplicationExceptionFactory {
  /// Recreates ApplicationException object from serialized ErrorDescription.
  ///
  /// It tries to restore original exception type using type or error category fields.
  ///
  /// - [description]	a serialized error description received as a result of remote call

  static ApplicationException create(ErrorDescription description) {
    ApplicationException error;
    var category = description.category;
    var code = description.code;
    var message = description.message;
    var traceId = description.trace_id;

    // Create well-known exception type based on error category
    if (ErrorCategory.Unknown == category) {
      error = UnknownException(traceId, code, message);
    } else if (ErrorCategory.Internal == category) {
      error = InternalException(traceId, code, message);
    } else if (ErrorCategory.Misconfiguration == category) {
      error = ConfigException(traceId, code, message);
    } else if (ErrorCategory.NoResponse == category) {
      error = ConnectionException(traceId, code, message);
    } else if (ErrorCategory.FailedInvocation == category) {
      error = InvocationException(traceId, code, message);
    } else if (ErrorCategory.FileError == category) {
      error = FileException(traceId, code, message);
    } else if (ErrorCategory.BadRequest == category) {
      error = BadRequestException(traceId, code, message);
    } else if (ErrorCategory.Unauthorized == category) {
      error = UnauthorizedException(traceId, code, message);
    } else if (ErrorCategory.Conflict == category) {
      error = ConflictException(traceId, code, message);
    } else if (ErrorCategory.NotFound == category) {
      error = NotFoundException(traceId, code, message);
    } else if (ErrorCategory.InvalidState == category) {
      error = InvalidStateException(traceId, code, message);
    } else if (ErrorCategory.Unsupported == category) {
      error = UnsupportedException(traceId, code, message);
    } else {
      error = UnknownException();
      error.category = category ?? error.category;
      error.status = description.status ?? error.status;
    }

    // Fill error with details
    error.details = StringValueMap.fromValue(description.details);
    if (description.cause != null) error.setCauseString(description.cause!);
    if (description.stack_trace != null) {
      error.setStackTraceString(description.stack_trace!);
    }

    return error;
  }
}
