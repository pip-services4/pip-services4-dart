import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';
import 'package:collection/collection.dart';

import '../clients/AzureFunctionClient.dart';
import '../container/AzureFunctionContextHelper.dart';
import 'IAzureFunctionController.dart';
import 'AzureFunctionAction.dart';

/// Abstract controller that receives remove calls via Azure Function protocol.
///
/// This controller is intended to work inside Azure Function container that
/// exploses registered actions externally.
///
/// ### Configuration parameters ###
///
/// - dependencies:
///   - controller:            override for Controller dependency
///
/// ### References ###
///
/// - *:logger:\*:\*:1.0            (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - *:counters:\*:\*:1.0          (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
///
/// [AzureFunctionClient]
///
/// ### Example ###
///
///     class MyAzureFunctionController extends AzureFunctionController {
///        IMyService _service;
///        ...
///
///        MyAzureFunctionController(): super('v1.mycontroller') {
///           dependencyResolver.put(
///               'service',
///               Descriptor('mygroup','service','*','*','1.0')
///           );
///        }
///
///        void setReferences(IReferences references) {
///           super.setReferences(references);
///           _service = this._dependencyResolver.getRequired<IMyController>("service");
///        }
///
///         void register() {
///         registerAction(
///           'get_mydata',
///           ObjectSchema(true).withOptionalProperty('id', TypeCode.String),
///           getMyData);
///         }
///
///         Future getMyData(params) async {
///           return await _service.getMyData(params['trace_id'],
///             params['id']),
///         }
///     }
///
///     ...
///
///     var controller = MyAzureFunctionController();
///     controller.configure(ConfigParams.fromTuples([
///         "connection.protocol", "http",
///         "connection.host", "localhost",
///         "connection.port", 8080
///     ]));
///     controller.setReferences(References.fromTuples([
///        Descriptor("mygroup","controller","default","default","1.0"), controller
///     ]));
///
///     controller.open(Context.fromTraceId("123"));
///     console.log("The Azure Function controller is running on port 8080");
abstract class AzureFunctionController
    implements
        IAzureFunctionController,
        IOpenable,
        IConfigurable,
        IReferenceable {
  String? _name;
  List<AzureFunctionAction> _actions = [];
  List<dynamic> _interceptors = [];
  bool _opened = false;

  /// The dependency resolver.
  final DependencyResolver dependencyResolver = DependencyResolver();

  /// The logger.
  final CompositeLogger logger = CompositeLogger();

  /// The performance counters.
  final CompositeCounters counters = CompositeCounters();

  /// The tracer.
  final CompositeTracer tracer = CompositeTracer();

  /// Creates an instance of this controller.
  /// - [name] a controller name to generate action cmd.
  AzureFunctionController(String? name) {
    _name = name;
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    dependencyResolver.configure(config);
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    logger.setReferences(references);
    counters.setReferences(references);
    tracer.setReferences(references);
    dependencyResolver.setReferences(references);
  }

  /// Get all actions supported by the controller.
  /// Return an array with supported actions.
  @override
  List<AzureFunctionAction> getActions() {
    return _actions;
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

  /// Checks if the component is opened.
  ///
  /// Return true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return _opened;
  }

  /// Opens the component.
  ///
  /// - [context] 	(optional) execution context to trace execution through call chain.
  @override
  Future open(IContext? context) async {
    if (_opened) {
      return;
    }

    register();

    _opened = true;
  }

  /// Closes component and frees used resources.
  ///
  /// - [context] 	(optional) execution context to trace execution through call chain.
  @override
  Future close(IContext? context) async {
    if (!_opened) {
      return;
    }

    _opened = false;
    _actions = [];
    _interceptors = [];
  }

  Future applyValidation(
      Schema? schema, Future Function(Map<String, dynamic>) action) async {
    // ignore: unnecessary_null_comparison
    if (action == null) {
      throw UnknownException(null, 'NO_ACTION', 'Missing action');
    }

    // Create an action function
    Future actionWrapper(Map<String, dynamic> context) async {
      // Validate object
      // ignore: unnecessary_null_comparison
      if (schema != null && context != null) {
        // Perform validation
        final traceId = getTraceId(context);
        final err = schema.validateAndReturnException(traceId, context, false);
        if (err != null) {
          return err;
        }
      }

      return action(context);
    }

    return actionWrapper;
  }

  dynamic applyInterceptors(dynamic action) {
    // ignore: unnecessary_null_comparison
    if (action == null) {
      throw UnknownException(null, 'NO_ACTION', 'Missing action');
    }
    var actionWrapper = action;

    for (var index = _interceptors.length - 1; index >= 0; index--) {
      final interceptor = _interceptors[index];
      actionWrapper = (action) => (context) => interceptor(context, action);
    }

    return actionWrapper;
  }

  String? generateActionCmd(String? name) {
    var cmd = name;
    if (_name != null) {
      cmd = "$_name.$cmd";
    }
    return cmd;
  }

  /// Registers a action in Azure Function.
  ///
  /// - [name]          an action name
  /// - [schema]        a validation schema to validate received parameters.
  /// - [action]        an action function that is called when operation is invoked.
  Future<void> registerAction(String name, Schema? schema,
      Future Function(Map<String, dynamic>) action) async {
    try {
      var actionWrapper = await applyValidation(schema, action);
      actionWrapper = applyInterceptors(actionWrapper);

      final AzureFunctionAction registeredAction =
          AzureFunctionAction(generateActionCmd(name), schema, actionWrapper);
      _actions.add(registeredAction);
    } catch (ex) {
      logger.error(
          null, ApplicationException().wrap(ex), 'Error while registerAction');
    }
  }

  /// Registers an action with authorization.
  ///
  /// - [name]          an action name
  /// - [schema]        a validation schema to validate received parameters.
  /// - [authorize]     an authorization interceptor
  /// - [action]        an action function that is called when operation is invoked.
  Future<void> registerActionWithAuth(
      String name,
      Schema schema,
      Future Function(dynamic call, Future Function(Map<String, dynamic>) next)
          authorize,
      Future Function(Map<String, dynamic>) action) async {
    var actionWrapper = await applyValidation(schema, action);
    // Add authorization just before validation
    actionWrapper = (call) async => await authorize(call, actionWrapper);
    actionWrapper = applyInterceptors(actionWrapper);

    //     actionWrapper = ((call) => {
    //       authorize(call, actionWrapper as Future Function(dynamic p1))
    //     }) as Future;
    // actionWrapper =
    //     applyInterceptors(actionWrapper as Future Function(dynamic p1));

    final registeredAction = AzureFunctionAction(
        generateActionCmd(name), schema, (params) async => actionWrapper);
    _actions.add(registeredAction);
  }

  /// Registers a middleware for actions in Azure Function controller.
  ///
  /// - [action]        an action function that is called when middleware is invoked.
  void registerInterceptor(
      String? cmd,
      Future Function(
              dynamic context, Future Function(Map<String, dynamic>) next)
          action) {
    Future interceptorWrapper(
        request, Future Function(Map<String, dynamic>) next) async {
      var currCmd = getCommand(request);
      var match = cmd != null && (currCmd.allMatches(cmd)).isNotEmpty;

      if (cmd != null && cmd != "" && !match) {
        return await next(request);
      } else {
        return await action(request, next);
      }
    }

    _interceptors.add(interceptorWrapper);
  }

  /// Registers all controller routes in HTTP endpoint.
  ///
  /// This method is called by the controller and must be overriden
  /// in child classes.
  void register();

  /// Returns context from Azure Function context.
  /// This method can be overloaded in child classes
  /// - [context] - the context context
  /// Returns context from context
  String getTraceId(context) {
    return AzureFunctionContextHelper.getTraceId(context);
  }

  /// Returns command from Azure Function context.
  /// This method can be overloaded in child classes
  /// - [context] -  the context context
  /// Returns command from context
  String getCommand(context) {
    return AzureFunctionContextHelper.getCommand(context);
  }

  /// Calls registered action in this Azure Function.
  /// "cmd" parameter in the action parameters determin
  /// what action shall be called.
  ///
  /// This method shall only be used in testing.
  ///
  /// - [params] action parameters.
  Future act(params) async {
    final String? cmd = params['cmd'];
    final context = params['trace_id'];

    if (cmd == null) {
      throw BadRequestException(
          context, 'NO_COMMAND', 'Cmd parameter is missing');
    }

    var action = _actions.firstWhereOrNull((a) => a.cmd == cmd);
    if (action == null) {
      throw BadRequestException(
              context, 'NO_ACTION', 'Action $cmd was not found')
          .withDetails('command', cmd);
    }

    return await action.action!(params);
  }
}
