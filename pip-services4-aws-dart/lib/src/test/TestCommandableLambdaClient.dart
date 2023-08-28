import 'package:pip_services4_components/pip_services4_components.dart';

import '../clients/CommandableLambdaClient.dart';

class TestCommandableLambdaClient extends CommandableLambdaClient {
  TestCommandableLambdaClient(String baseRoute) : super(baseRoute);

  /// Calls a remote action in AWS Lambda function.
  /// The name of the action is added as "cmd" parameter
  /// to the action parameters.
  ///
  /// - [name]               an action name
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [params]            command parameters.
  /// Return            action result.
  @override
  Future callCommand(String name, IContext? context, params) async {
    return super.callCommand(name, context, params);
  }
}
