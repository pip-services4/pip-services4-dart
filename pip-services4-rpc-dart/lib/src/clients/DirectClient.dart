import 'dart:async';

import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';

import '../trace/InstrumentTiming.dart';

/// Abstract client that calls service directly in the same memory space.
///
/// It is used when multiple microservices are deployed in a single container (monolyth)
/// and communication between them can be done by direct calls rather then through
/// the network.
///
/// ### Configuration parameters ###
///
/// - [dependencies]:
///   - [service]:            override service descriptor
///
/// ### References ###
///
/// - [\*:logger:\*:\*:1.0]         (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - [\*:counters:\*:\*:1.0]       (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
/// - [\*:tracer:\*:\*:1.0]         (optional) [ITracer](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ITracer-class.html) components to record traces
/// - [\*:service:\*:\*:1.0]     service to call business methods
///
/// ### Example ###
///
///     class MyDirectClient extends DirectClient<IMyService> implements IMyClient {
///
///         public MyDirectClient(): super() {
///
///           dependencyResolver.put('service', Descriptor(
///               "mygroup", "service", "*", "*", "*"));
///         }
///         ...
///
///         Future<MyData> getData(IContext? context, String id) async {
///           var timing = instrument(context, 'myclient.get_data');
///           try {
///           var result = await service.getData(context, id)
///           timing.endTiming();
///           return result;
///           } catch (err){
///              timing.endTiming();
///              instrumentError(context, 'myclient.get_data', err, reerror=true);
///           });
///         }
///         ...
///     }
///
///     var client = MyDirectClient();
///     client.setReferences(References.fromTuples([
///          Descriptor("mygroup","service","default","default","1.0"), service
///     ]));
///
///     var result = await client.getData("123", "1")
///       ...

abstract class DirectClient<T>
    implements IConfigurable, IReferenceable, IOpenable {
  /// The service reference.
  late T service;

  /// The open flag.
  bool opened = true;

  /// The logger.
  var logger = CompositeLogger();

  /// The performance counters
  var counters = CompositeCounters();

  /// The dependency resolver to get service reference.
  var dependencyResolver = DependencyResolver();

  /// The tracer.
  var tracer = CompositeTracer();

  /// Creates a new instance of the client.
  DirectClient() {
    dependencyResolver.put('service', 'none');
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
    service = dependencyResolver.getOneRequired<T>('service');
  }

  /// Adds instrumentation to log calls and measure call time.
  /// It returns a Timing object that is used to end the time measurement.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [name]              a method name.
  /// Returns               [InstrumentTiming] object to end the time measurement.
  InstrumentTiming instrument(IContext? context, String name) {
    logger.trace(context, 'Executing %s method', [name]);
    counters.incrementOne('$name.exec_count');

    var counterTiming = counters.beginTiming('$name.exec_time');
    var traceTiming = tracer.beginTrace(context, name, '');

    return InstrumentTiming(
        context, name, 'exec', logger, counters, counterTiming, traceTiming);
  }

  /// Adds instrumentation to error handling.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [name]              a method name.
  /// - [err]               an occured error
  /// - [result]            (optional) an execution result
  /// - [reerror]           flag for rethrow exception
  void instrumentError(IContext? context, String name, err,
      [bool? reerror = false]) {
    if (err != null) {
      logger.error(context, ApplicationException().wrap(err),
          'Failed to call %s method', [name]);
      counters.incrementOne('$name.call_errors');
      if (reerror != null && reerror == true) {
        throw err;
      }
    }
  }

  /// Checks if the component is opened.
  ///
  /// Returns true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return opened;
  }

  /// Opens the component.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Returns 			Future that receives error or null no errors occured.
  @override
  Future open(IContext? context) async {
    if (opened) {
      return null;
    }

    if (service == null) {
      var err = ConnectionException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NOservice',
          'Service reference is missing');

      throw err;
    }

    opened = true;

    logger.info(context, 'Opened direct client');
  }

  /// Closes component and frees used resources.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return 			      Future that receives null no errors occured.
  /// Throw error
  @override
  Future close(IContext? context) async {
    if (opened) {
      logger.info(context, 'Closed direct client');
    }

    opened = false;
  }
}
