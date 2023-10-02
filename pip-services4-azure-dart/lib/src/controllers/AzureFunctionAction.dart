import 'package:pip_services4_data/pip_services4_data.dart';

class AzureFunctionAction {
  /// Command to call the action
  String? cmd;

  /// Schema to validate action parameters
  Schema? schema;

  /// Action to be executed
  Future Function(Map<String, dynamic>)? action;

  AzureFunctionAction(String? cmd, Schema? schema,
      Future Function(Map<String, dynamic>) action) {
    this.cmd = cmd;
    this.schema = schema;
    this.action = action;
  }
}
