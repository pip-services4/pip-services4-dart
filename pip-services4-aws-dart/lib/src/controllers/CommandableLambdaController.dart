import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';

import '../clients/CommandableLambdaClient.dart';
import 'LambdaController.dart';

/// Abstract controller that receives commands via AWS Lambda protocol
/// to operations automatically generated for commands defined in [ICommandable components](https://pub.dev/documentation/pip_services4_rpc/latest/pip_services4_rpc/ICommandable-class.html).
/// Each command is exposed as invoke method that receives command name and parameters.
///
/// Commandable services require only 3 lines of code to implement a robust external
/// Lambda-based remote interface.
///
/// This controller is intended to work inside LambdaFunction container that
/// exploses registered actions externally.
///
/// ### Configuration parameters ###
///
/// - dependencies:
///   - service:            override for Controller dependency
///
/// ### References ###
///
/// - *:logger:\*:\*:1.0            (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - *:counters:\*:\*:1.0          (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
///
/// [CommandableLambdaClient]
/// [LambdaController]
///
/// ### Example ###
///
///     class MyCommandableLambdaController extends CommandableLambdaController {
///        MyCommandableLambdaController(): super() {
///           _dependencyResolver.put(
///               "service",
///               new Descriptor("mygroup","service","*","*","1.0")
///           );
///        }
///     }
///
///     let controller = new MyCommandableLambdaController();
///     controller.setReferences(References.fromTuples(
///        Descriptor("mygroup","service","default","default","1.0"), controller
///     ));
///
///     await controller.open(Context.fromTraceId("123"));
///     console.log("The AWS Lambda controller is running");
abstract class CommandableLambdaController extends LambdaController {
  CommandSet? _commandSet;

  /// Creates a new instance of the controller.
  ///
  /// - [name] a controller name.
  CommandableLambdaController(String? name) : super(name) {
    dependencyResolver.put('service', 'none');
  }

  /// Registers all actions in AWS Lambda function.
  @override
  void register() {
    ICommandable service =
        dependencyResolver.getOneRequired<ICommandable>('service');
    _commandSet = service.getCommandSet();

    final commands = _commandSet?.getCommands();
    for (var index = 0; index < commands!.length; index++) {
      final command = commands[index];
      final name = command.getName();

      registerAction(name, null, (params) async {
        final context =
            params != null ? Context.fromTraceId(params.trace_id) : null;

        final args = Parameters.fromValue(params);
        args.remove("trace_id");

        final timing = instrument(context, name);
        try {
          final res = command.execute(context, args);
          timing.endTiming();
          return res;
        } catch (ex) {
          timing.endFailure(ex as Exception);
        }
      });
    }
  }
}
