import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

/// Error when required component dependency cannot be found.

class ReferenceException extends InternalException {
  /// Creates an error instance and assigns its values.
  ///
  /// - [context]    (optional) a unique a context to trace execution through call chain.
  /// - [locator] 			the locator to find reference to dependent component.

  ReferenceException(IContext? context, locator)
      : super(ContextResolver.getTraceId(context), 'REF_ERROR',
            'Failed to obtain reference to ' + locator.toString()) {
    withDetails('locator', locator);
  }
}
