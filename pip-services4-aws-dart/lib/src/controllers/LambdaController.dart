import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';
import 'package:collection/collection.dart';

import '../clients/LambdaClient.dart';
import 'ILambdaController.dart';
import 'LambdaAction.dart';

/// Abstract controller that receives remove calls via AWS Lambda protocol.
///
/// This controller is intended to work inside LambdaFunction container that
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
/// [LambdaClient]
///
/// ### Example ###
///
///     class MyLambdaController extends LambdaController {
///        IMyService _service;
///        ...
///
///        MyLambdaController(): super('v1.mycontroller') {
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
///     let controller = new MyLambdaController();
///     controller.configure(ConfigParams.fromTuples([
///         "connection.protocol", "http",
///         "connection.host", "localhost",
///         "connection.port", 8080
///     ]));
///     controller.setReferences(References.fromTuples(
///        new Descriptor("mygroup","controller","default","default","1.0"), controller
///     ));
///
///     controller.open(Context.fromTraceId("123"));
///     console.log("The AWS controller is running on port 8080");
abstract class LambdaController
    implements ILambdaController, IOpenable, IConfigurable, IReferenceable {
  String? _name;
  List<LambdaAction> _actions = [];
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
  LambdaController(String? name) {
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
  List<LambdaAction> getActions() {
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

//<Future Function(dynamic p1)>
  Future applyValidation(
      Schema? schema, Future Function(Map<String, dynamic>) action) async {
    // ignore: unnecessary_null_comparison
    if (action == null) {
      throw UnknownException(null, 'NO_ACTION', 'Missing action');
    }

    // Create an action function
    Future actionWrapper(Map<String, dynamic> params) async {
      // Validate object
      // ignore: unnecessary_null_comparison
      if (schema != null && params != null) {
        // Perform validation
        final context = Context.fromTraceId(params['trace_id'] ?? '');
        final err = schema.validateAndReturnException(
            ContextResolver.getTraceId(context), params, false);
        if (err != null) {
          throw err;
        }
      }

      //final result = action(params);
      return action(params);
    }

    return actionWrapper;
  }

//<Future Function(dynamic p1)>
  dynamic applyInterceptors(dynamic action) {
    //Future Function(dynamic) action
    // ignore: unnecessary_null_comparison
    if (action == null) {
      throw UnknownException(null, 'NO_ACTION', 'Missing action');
    }
    var actionWrapper = action;

    for (var index = _interceptors.length - 1; index >= 0; index--) {
      final interceptor = _interceptors[index];
      // actionWrapper = ((action) => {
      //       (params) => {interceptor(params, action)}
      //     })(actionWrapper) as Future Function(dynamic p1);

      actionWrapper = (action) => (params) => interceptor(params, action);
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

  /// Registers a action in AWS Lambda function.
  ///
  /// - [name]          an action name
  /// - [schema]        a validation schema to validate received parameters.
  /// - [action]        an action function that is called when operation is invoked.
  Future<void> registerAction(
      String name, Schema? schema, Future Function(Map<String, dynamic>) action) async {
    try {
      var actionWrapper = await applyValidation(schema, action);
      actionWrapper = applyInterceptors(actionWrapper);

      final LambdaAction registeredAction =
          LambdaAction(generateActionCmd(name), schema, actionWrapper);
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
      Future Function(dynamic call, Future Function(Map<String, dynamic>) next) authorize,
      Future Function(Map<String, dynamic>) action) async {
    var actionWrapper = await applyValidation(schema, action);
    // Add authorization just before validation
    actionWrapper = (call) => authorize(call, actionWrapper);
    actionWrapper = applyInterceptors(actionWrapper);

    //     actionWrapper = ((call) => {
    //       authorize(call, actionWrapper as Future Function(dynamic p1))
    //     }) as Future;
    // actionWrapper =
    //     applyInterceptors(actionWrapper as Future Function(dynamic p1));

    final registeredAction = LambdaAction(
        generateActionCmd(name), schema, (params) async => actionWrapper);
    _actions.add(registeredAction);
  }

  /// Registers a middleware for actions in AWS Lambda controller.
  ///
  /// - [action]        an action function that is called when middleware is invoked.
  void registerInterceptor(
      Future Function(dynamic params, Future Function(dynamic) next) action) {
    _interceptors.add(action);
  }

  /// Registers all controller routes in HTTP endpoint.
  ///
  /// This method is called by the controller and must be overriden
  /// in child classes.
  void register();

  /// Calls registered action in this lambda function.
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
