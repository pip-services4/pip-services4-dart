import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';

import 'AzureFunction.dart';
import '../clients/AzureFunctionClient.dart';
import 'AzureFunctionContextHelper.dart';

/// Abstract Azure function, that acts as a container to instantiate and run components
/// and expose them via external entry point. All actions are automatically generated for commands
/// defined in [ICommandable components](https://pub.dev/documentation/pip_services4_rpc/latest/pip_services4_rpc/ICommandable-class.html). Each command is exposed as an action defined by "cmd" parameter.
///
/// Container configuration for this Azure function is stored in <code>"./config/config.yml"</code> file.
/// But this path can be overriden by <code>CONFIG_PATH</code> environment variable.
///
/// Note: This component has been deprecated. Use Azure Function Controller instead.
///
/// ### References ###
///
/// - *:logger:\*:\*:1.0            (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - *:counters:\*:\*:1.0          (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
/// - *:controller:azurefunc:\*:1.0       (optional) [IAzureFunctionController](https://pub.dev/documentation/pip_services4_azure/latest/pip_services4_azure/IAzureFunctionController-class.html) controllers to handle action requests
/// - *:controller:commandable-azurefunc:\*:1.0 (optional) [IAzureFunctionController](https://pub.dev/documentation/pip_services4_azure/latest/pip_services4_azure/IAzureFunctionController-class.html) controllers to handle action requests
///
/// See [AzureFunctionClient]
///
/// ### Example ###
///
///     class MyAzureFunction extends CommandableAzureFunction {
///         IMyController _service;
///         ...
///         MyAzureFunction()
///             super('mygroup', 'MyGroup Azure function'){
///             dependencyResolver.put(
///                 'service',
///                 Descriptor('mygroup','service','*','*','1.0')
///             );
///         }
///
///     var azureFunction = new MyAzureFunction();
///
///     azureFunction.run((err) => {
///         console.log("MyAzureFunction is started");
///     });

abstract class CommandableAzureFunction extends AzureFunction {
  /// Creates a new instance of this Azure function.
  ///
  ///  -  [name]          (optional) a container name (accessible via ContextInfo)
  ///  -  [description]   (optional) a container description (accessible via ContextInfo)
  CommandableAzureFunction(String name, [String? description])
      : super(name, description) {
    dependencyResolver.put('service', 'none');
  }

  /// Returns body from Azure Function context.
  /// This method can be overloaded in child classes
  /// - [context]   Azure Function context
  /// Returns Parameters from context
  Parameters getParametrs(Map<String, dynamic> context) {
    return AzureFunctionContextHelper.getParameters(context);
  }

  void _registerCommandSet(CommandSet commandSet) {
    var commands = commandSet.getCommands();
    for (var index = 0; index < commands.length; index++) {
      var command = commands[index];

      registerAction(command.getName(), null,
          (Map<String, dynamic> context) async {
        var traceId = getTraceId(context);
        var args = getParametrs(context);
        var timing = instrument(
            Context.fromTraceId(traceId), '${info?.name}.${command.getName()}');
        try {
          final result =
              await command.execute(Context.fromTraceId(traceId), args);
          timing.endTiming();
          return result;
        } catch (ex) {
          timing.endFailure(ex as Exception);
          return ex;
        }
      });
    }
  }

  /// Registers all actions in this Azure function.
  @override
  void register() {
    var service = dependencyResolver.getOneRequired<ICommandable>('service');
    var commandSet = service.getCommandSet();
    _registerCommandSet(commandSet);
  }
}
