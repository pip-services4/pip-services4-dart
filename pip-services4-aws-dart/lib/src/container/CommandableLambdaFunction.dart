import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';

import './LambdaFunction.dart';
import '../clients/LambdaClient.dart';

/// Abstract AWS Lambda function, that acts as a container to instantiate and run components
/// and expose them via external entry point. All actions are automatically generated for commands
/// defined in [ICommandable components](https://pub.dev/documentation/pip_services4_rpc/latest/pip_services4_rpc/ICommandable-class.html). Each command is exposed as an action defined by "cmd" parameter.
///
/// Container configuration for this Lambda function is stored in <code>"./config/config.yml"</code> file.
/// But this path can be overriden by <code>CONFIG_PATH</code> environment variable.
///
/// ### Configuration parameters ###
///
/// - [dependencies]:
///     - [controller]:                  override for Controller dependency
/// - [connections]:
///     - [discovery_key]:               (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///     - [region]:                      (optional) AWS region
/// - [credentials]:
///     - [store_key]:                   (optional) a key to retrieve the credentials from [ICredentialStore](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/ICredentialStore-class.html)
///     - [access_id]:                   AWS access/client id
///     - [access_key]:                  AWS access/client id
///
/// ### References ###
///
/// - *:logger:\*:\*:1.0            (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - *:counters:\*:\*:1.0          (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
/// - *:discovery:\*:\*:1.0         (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection
/// - *:controller:awslambda:\*:1.0       (optional) [ILambdaController](https://pub.dev/documentation/pip_services4_aws/latest/pip_services4_aws/ILambdaController-class.html) controllers to handle action requests
/// - *:controller:commandable-awslambda:\*:1.0 (optional) [ILambdaController](https://pub.dev/documentation/pip_services4_aws/latest/pip_services4_aws/ILambdaController-class.html) controllers to handle action requests
/// - *:credential-store:\*:\*:1.0  (optional) Credential stores to resolve credentials
///
/// See [LambdaClient]
///
/// ### Example ###
///
///     class MyLambdaFunction extends CommandableLambdaFunction {
///         IMyController _service;
///         ...
///         MyLambdaFunction()
///             super('mygroup', 'MyGroup lambda function'){
///             dependencyResolver.put(
///                 'service',
///                 Descriptor('mygroup','service','*','*','1.0')
///             );
///         }
///
///     var lambda = new MyLambdaFunction();
///
///     lambda.run((err) => {
///         console.log("MyLambdaFunction is started");
///     });

abstract class CommandableLambdaFunction extends LambdaFunction {
  /// Creates a new instance of this lambda function.
  ///
  ///  -  [name]          (optional) a container name (accessible via ContextInfo)
  ///  -  [description]   (optional) a container description (accessible via ContextInfo)
  CommandableLambdaFunction(String name, [String? description])
      : super(name, description) {
    dependencyResolver.put('service', 'none');
  }

  void _registerCommandSet(CommandSet commandSet) {
    var commands = commandSet.getCommands();
    for (var index = 0; index < commands.length; index++) {
      var command = commands[index];

      registerAction(command.getName(), null, (params) async {
        IContext? context = Context.fromTraceId(params['trace_id'] ?? '');
        var args = Parameters.fromValue(params);
        var timing = instrument(context, '${info?.name}.${command.getName()}');
        dynamic result;
        try {
          result = await command.execute(context, args);
          timing.endTiming();
          return result;
        } catch (ex) {
          timing.endFailure(ex as Exception);
        }        
      });
    }
  }

  /// Registers all actions in this lambda function.
  @override
  void register() {
    var service = dependencyResolver.getOneRequired<ICommandable>('service');
    var commandSet = service.getCommandSet();
    _registerCommandSet(commandSet);
  }
}
