import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

/// Exception that can be thrown by Expression Calculator.
class ExpressionException extends BadRequestException {
  ExpressionException(IContext? context, String code, String message,
      [int line = 0, int column = 0])
      : super(
            context != null ? ContextResolver.getTraceId(context) : null,
            code,
            line != 0 || column != 0
                ? '$message at line $line and column $column'
                : message);
}
