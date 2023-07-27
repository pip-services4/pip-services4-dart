import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

/// Exception that can be thrown by Expression Parser.
class SyntaxException extends BadRequestException {
  SyntaxException(
      IContext? context, String code, String message, int? line, int? column)
      : super(
            context != null ? ContextResolver.getTraceId(context) : null,
            code,
            line != 0 || column != 0
                ? '$message at line $line and column $column'
                : message);
}
