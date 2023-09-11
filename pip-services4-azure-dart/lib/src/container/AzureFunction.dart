import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_container/pip_services4_container.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';
import '../clients/AzureFunctionClient.dart';

import '../controllers/IAzureFunctionController.dart';
import 'AzureFunctionContextHelper.dart';

/// Abstract Azure Function, that acts as a container to instantiate and run components
/// and expose them via external entry point.
///
/// When handling calls 'cmd' parameter determines which what action shall be called, while
/// other parameters are passed to the action itself.
///
/// Container configuration for this Azure function is stored in <code>'./config/config.yml'</code> file.
/// But this path can be overriden by <code>CONFIG_PATH</code> environment variable.
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
///```dart
///     class MyAzureFunction extends AzureFunction {
///         IMyService _service;
///         ...
///         MyAzureFunction()
///             super('mygroup', 'MyGroup Azure function'){
///             dependencyResolver.put(
///                 'service',
///                 Descriptor('mygroup','service','*','*','1.0')
///             );
///         }
///
///         void setReferences(IReferences references) {
///             super.setReferences(references);
///             _service = dependencyResolver.getRequired<IMyService>('service');
///         }
///
///         Future getMyData(params) async {
///           return await _service.getMyData(params['trace_id'],
///             params['id']),
///         }
///
///         void register() {
///         registerAction(
///           'get_mydata',
///           ObjectSchema(true).withOptionalProperty('id', TypeCode.String),
///           getMyData);
///         }
///             ...
///     }
///
///     var azureFunction = MyAzureFunction();
///
///     await azureFunction.run();
///     print('MyAzureFunction is started');
///
///     var result = await azureFunction.act({'cmd': 'get_dummies'});
///     print(result);
/// ```

abstract class AzureFunction extends Container {
  /// The performanc counters.
  final counters = CompositeCounters();

  final tracer = CompositeTracer();

  /// The dependency resolver.
  final dependencyResolver = DependencyResolver();

  /// The map of registred validation schemas.
  Map<String, Schema> schemas = {};

  /// The map of registered actions.
  Map<String, Future Function(Map<String, dynamic>)> actions = {};

  /// The default path to config file.
  String configPath = './config/config.yml';

  /// Creates a new instance of this Azure function.
  ///
  ///  -  [name]          (optional) a container name (accessible via ContextInfo)
  ///  -  [description]   (optional) a container description (accessible via ContextInfo)
  AzureFunction([String? name, String? description])
      : super(name, description) {
    logger = ConsoleLogger();
  }

  String _getConfigPath() {
    return Platform.environment['CONFIG_PATH'] ?? configPath;
  }

  ConfigParams _getParameters() {
    var parameters = ConfigParams.fromValue(Platform.environment);
    return parameters;
  }

  void _captureExit(IContext? context) {
    logger.info(context, 'Press Control-C to stop the microservice...');

    // Activate graceful exit
    ProcessSignal.sigint.watch().listen((signal) {
      close(context);
      logger.info(context, 'Goodbye!');
      exit(0);
    });
  }

  /// Sets references to dependent components.
  ///
  ///  -  [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    counters.setReferences(references);
    dependencyResolver.setReferences(references);
    register();
  }

  /// Opens the component.
  ///
  /// - [context] 	(optional) execution context to trace execution through call chain.
  @override
  Future open(IContext? context) async {
    if (isOpen()) return;

    await super.open(context);
    registerControllers();
  }

  /// Adds instrumentation to log calls and measure call time.
  /// It returns a Timing object that is used to end the time measurement.
  ///
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  -  [name]              a method name.
  /// Returns Timing object to end the time measurement.
  InstrumentTiming instrument(IContext? context, String name) {
    logger.trace(context, "Executing %s method", [name]);
    counters.incrementOne("$name.exec_count");

    final counterTiming = counters.beginTiming("$name.exec_time");
    final traceTiming = tracer.beginTrace(context, name, '');
    return InstrumentTiming(
        context, name, "exec", logger, counters, counterTiming, traceTiming);
  }

  /// Runs this Azure function, loads container configuration,
  /// instantiate components and manage their lifecycle,
  /// makes this function ready to access action calls.
  ///
  ///  Return  Future that receives null for success.
  /// Throws error
  Future run() async {
    var context = Context.fromTraceId(info?.name ?? '');

    try {
      var path = _getConfigPath();
      var parameters = _getParameters();
      readConfigFromFile(context, path, parameters);
      _captureExit(context);
      await open(context);
    } catch (ex) {
      logger.fatal(
        context,
        ex as Exception,
        'Process is terminated',
      );
      exit(1);
    }
  }

  /// Registers all actions in this Azure function.
  ///
  /// This method is called by the service and must be overriden
  /// in child classes.

  void register();

  /// Registers all Azure controllers in the container.
  void registerControllers() {
    // Extract regular and commandable Azure Function controllers from references
    final controllers = references?.getOptional<IAzureFunctionController>(
        Descriptor("*", "controller", "azurefunc", "*", "*"));
    final cmdControllers = references?.getOptional<IAzureFunctionController>(
        Descriptor("*", "controller", "commandable-azurefunc", "*", "*"));
    if (cmdControllers != null) {
      controllers?.addAll(cmdControllers);
    }

    if (controllers != null && controllers.isNotEmpty) {
      // Register actions defined in those controllers
      for (var controller in controllers) {
        // Check if the controller implements required interface
        // ignore: unnecessary_type_check
        if (controller.getActions is! Function) continue;

        final actions = controller.getActions();
        for (var action in actions) {
          registerAction(action.cmd, action.schema, action.action!);
        }
      }
    }
  }

  /// Registers an action in this Azure function.
  ///
  ///  -  [cmd]           a action/command name.
  ///  -  [schema]        a validation schema to validate received parameters.
  ///  -  [action]        an action function that is called when action is invoked.
  void registerAction(String? cmd, Schema? schema,
      Future Function(Map<String, dynamic>) action) {
    if (cmd == null || cmd.isEmpty) {
      throw UnknownException(null, 'NO_COMMAND', 'Missing command');
    }

    // ignore: unnecessary_null_comparison
    if (action == null) {
      throw UnknownException(null, 'NO_ACTION', 'Missing action');
    }

    if (actions[cmd] != null) {
      throw UnknownException(
          null, 'DUPLICATED_ACTION', '$cmd action already exists');
    }

    // Hack!!! Wrapping action to preserve prototyping context
    Future actionCurl(Map<String, dynamic> params) async {
      // Perform validation
      if (schema != null) {
        var traceId = getTraceId(params);
        var err = schema.validateAndReturnException(traceId, params, false);
        if (err != null) {
          return err;
        }
      }

      // Todo: perform verification?
      return action(params);
    }

    actions[cmd] = actionCurl;
  }

  /// Returns context from Azure Function context.
  /// This method can be overloaded in child classes
  /// - [context] -  Azure Function context
  /// Returns context from context
  String getTraceId(Map<String, dynamic> context) {
    return AzureFunctionContextHelper.getTraceId(context);
  }

  /// Returns command from Azure Function context.
  /// This method can be overloaded in child classes
  /// - [context] -  Azure Function context
  /// Returns command from context
  String getCommand(Map<String, dynamic> context) {
    return AzureFunctionContextHelper.getCommand(context);
  }

  Future _execute(Map<String, dynamic> context) async {
    var cmd = getCommand(context);
    var traceId = getTraceId(context);

    if (cmd.isEmpty) {
      throw BadRequestException(
          traceId, 'NO_COMMAND', 'Cmd parameter is missing');
    }

    var action = actions[cmd];
    if (action == null) {
      throw BadRequestException(
              traceId, 'NO_ACTION', 'Action $cmd was not found')
          .withDetails('command', cmd);
    }

    return await action(context);
  }

  Future _handler(Map<String, dynamic> context) async {
    dynamic result;
    // If already started then execute
    if (isOpen()) {
      result = await _execute(context);
    }
    // Start before execute
    else {
      try {
        await run();
        result = await _execute(context);
      } catch (err) {
        result = ApplicationException().wrap(err);
      }
    }
    Map<String, dynamic>? jsonMap;
    if (result != null) {
      jsonMap = result is Map
          ? result.containsKey('body')
              ? result['body'] != null
                  ? result['body'].toJson()
                  : result['body']
              : result
          : result.toJson();
    } else {
      jsonMap = null;
    }
    return jsonMap != null ? json.encode(jsonMap) : jsonMap;
  }

  /// Gets entry point into this Azure function.
  ///
  ///  -  [event]     an incoming event object with invocation parameters.
  ///  -  [context]   a context object with local references.
  Future Function(Map<String, dynamic> context) getHandler() {
    // Return plugin function
    return (Map<String, dynamic> context) {
      // Calling run with changed context
      return _handler(context);
    };
  }

  /// Calls registered action in this Azure function.
  /// 'cmd' parameter in the action parameters determin
  /// what action shall be called.
  ///
  /// This method shall only be used in testing.
  ///
  ///  -  [params] action parameters.
  ///  -  Return  Future that receives action result
  /// Throws error.
  Future act(Map<String, dynamic> context) async {
    var result = await getHandler()({'body': context});
    return result;
    //return result.body.body;
  }
}
