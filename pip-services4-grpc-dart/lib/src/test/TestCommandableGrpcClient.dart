import 'package:pip_services4_components/pip_services4_components.dart';

import '../clients/CommandableGrpcClient.dart';

class TestCommandableGrpcClient extends CommandableGrpcClient {
  TestCommandableGrpcClient(String baseRoute) : super(baseRoute);

  /// Calls a remote method via GRPC commadable protocol.
  /// The call is made via Invoke method and all parameters are sent in args object.
  /// The complete route to remote method is defined as controllerName + "." + name.
  ///
  /// [name]              a name of the command to call.
  /// [context]     (optional) a context to trace execution through the call chain.
  /// [params]            command parameters.
  /// Return                 a command execution result.
  @override
  Future callCommand(String name, IContext? context, params) async {
    return super.callCommand(name, context, params);
  }
}
