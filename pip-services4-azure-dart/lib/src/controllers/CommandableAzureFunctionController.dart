import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';

import '../clients/CommandableAzureFunctionClient.dart';
import '../container/AzureFunctionContextHelper.dart';
import 'AzureFunctionController.dart';

/// Abstract controller that receives commands via Azure Function protocol
/// to operations automatically generated for commands defined in [ICommandable components](https://pub.dev/documentation/pip_services4_rpc/latest/pip_services4_rpc/ICommandable-class.html).
/// Each command is exposed as invoke method that receives command name and parameters.
///
/// Commandable services require only 3 lines of code to implement a robust external
/// Azure Function-based remote interface.
///
/// This controller is intended to work inside Azure Function container that
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
/// [CommandableAzureFunctionClient]
/// [AzureFunctionController]
///
/// ### Example ###
///
///     class MyCommandableAzureFunctionController extends CommandableAzureFunctionController {
///        MyCommandableAzureFunctionController(): super() {
///           _dependencyResolver.put(
///               "service",
///               Descriptor("mygroup","service","*","*","1.0")
///           );
///        }
///     }
///
///     var controller = MyCommandableAzureFunctionController();
///     controller.setReferences(References.fromTuples(
///        Descriptor("mygroup","service","default","default","1.0"), controller
///     ));
///
///     await controller.open(Context.fromTraceId("123"));
///     console.log("The Azure Function controller is running");
abstract class CommandableAzureFunctionController
    extends AzureFunctionController {
  CommandSet? _commandSet;

  /// Creates a new instance of the controller.
  ///
  /// - [name] a controller name.
  CommandableAzureFunctionController(String? name) : super(name) {
    dependencyResolver.put('service', 'none');
  }

  /// Registers all actions in Azure Function.
  @override
  void register() {
    ICommandable service =
        dependencyResolver.getOneRequired<ICommandable>('service');
    _commandSet = service.getCommandSet();

    final commands = _commandSet?.getCommands();
    for (var index = 0; index < commands!.length; index++) {
      final command = commands[index];
      final name = command.getName();

      registerAction(name, null, (context) async {
        final traceId = getTraceId(context);

        final args = AzureFunctionContextHelper.getParameters(context);
        args.remove("trace_id");

        final timing = instrument(Context.fromTraceId(traceId), name);
        try {
          final res = await command.execute(Context.fromTraceId(traceId), args);
          timing.endTiming();
          return res;
        } catch (ex) {
          timing.endFailure(ex as Exception);
          return ex;
        }
      });
    }
  }
}
