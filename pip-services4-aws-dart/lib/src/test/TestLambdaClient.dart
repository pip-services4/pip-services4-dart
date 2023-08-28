import 'package:pip_services4_components/pip_services4_components.dart';

import '../clients/LambdaClient.dart';

/// AWS Lambda client used for automated testing.
class TestLambdaClient extends LambdaClient {
  TestLambdaClient() : super();

  /// Calls a AWS Lambda Function action.
  ///
  /// - [cmd]               an action name to be called.
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [params]            (optional) action parameters.
  /// Return            action result.
  @override
  Future call(String cmd, IContext? context, params) async {
    return super.call(cmd, context, params);
  }

  /// Calls a AWS Lambda Function action asynchronously without waiting for response.
  ///
  /// - [cmd]               an action name to be called.
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [params]            (optional) action parameters.
  /// @return {any}            action result.
  @override
  Future callOneWay(String cmd, IContext? context, params) async {
    return super.callOneWay(cmd, context, params);
  }
}
