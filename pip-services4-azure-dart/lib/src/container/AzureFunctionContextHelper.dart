import 'package:pip_services4_components/pip_services4_components.dart';

class AzureFunctionContextHelper {
  /// Returns context from Azure Function context.
  /// - [context] the Azure Function context
  /// Returns context from context
  static String getTraceId(Map<String, dynamic> context) {
    String traceId = context['trace_id'] ?? "";
    try {
      if ((traceId == "") &&
          (context.containsKey('body') && context['body'] != null)) {
        traceId = context['body']['trace_id'] ?? '';
        if (traceId == "") {
          traceId = context['query']?['trace_id'] ?? '';
        }
      }
    } catch (e) {
      // Ignore the error
    }
    return traceId;
  }

  /// Returns command from Azure Function context.
  /// - [context] the Azure Function context
  /// Returns command from context
  static String getCommand(Map<String, dynamic> context) {
    String cmd = context['cmd'] ?? "";
    try {
      if ((cmd == "") &&
          (context.containsKey('body') && context['body'] != null)) {
        cmd = context['body']['cmd'];
        if (cmd == "") {
          cmd = context['query']?['cmd'] ?? '';
        }
      }
    } catch (e) {
      // Ignore the error
    }
    return cmd;
  }

  /// Returns body from Azure Function context http request.
  /// - [context] the Azure Function context
  /// Returns body from context
  static Parameters getParameters(Map<String, dynamic> context) {
    var body = context;
    try {
      if (context.containsKey('body') && context['body'] != null) {
        body = context['body'];
      }
    } catch (e) {
      // Ignore the error
    }
    return Parameters.fromValue(body);
  }
}
