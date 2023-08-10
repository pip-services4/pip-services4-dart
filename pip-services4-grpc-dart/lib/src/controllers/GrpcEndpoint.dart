import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:grpc/grpc.dart' as grpc;
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import '../generated/commandable.pbgrpc.dart' as command;
import './IRegisterable.dart';

/// Helper classs for work commandable service
class _CommandableMediator extends command.CommandableServiceBase {
  Future<command.InvokeReply> Function(
      grpc.ServiceCall call, command.InvokeRequest request)? _invoke;

  @override
  Future<command.InvokeReply> invoke(
      grpc.ServiceCall call, command.InvokeRequest request) async {
    if (_invoke != null) {
      return await _invoke!(call, request);
    }
    return command.InvokeReply().createEmptyInstance();
  }

  /// Sets invoke function
  set invokeFunc(
      Future<command.InvokeReply> Function(
              grpc.ServiceCall call, command.InvokeRequest request)
          fn) {
    _invoke = fn;
  }
}

/// Used for creating GRPC endpoints. An endpoint is a URL, at which a given service can be accessed by a client.
///
/// ### Configuration parameters ###
///
/// Parameters to pass to the [configure] method for component configuration:
///
/// - [connection(s)] - the connection resolver's connections:
///     - '[connection.discovery_key]' - the key to use for connection resolving in a discovery service;
///     - '[connection.protocol]' - the connection's protocol;
///     - '[connection.host]' - the target host;
///     - '[connection.port]' - the target port;
///     - '[connection.uri]' - the target URI.
/// - credential - the HTTPS credentials:
///     - '[credential.ssl_key_file]' - the SSL key private in PEM
///     - '[credential.ssl_crt_file]' - the SSL certificate in PEM
///     - '[credential.ssl_ca_file]' - the certificate authorities (root cerfiticates) in PEM
///
/// ### References ###
///
/// A logger, counters, and a connection resolver can be referenced by passing the
/// following references to the object's [setReferences] method:
///
/// - logger: '\*:logger:\*:\*:1.0';
/// - counters: '\*:counters:\*:\*:1.0';
/// - discovery: '\*:discovery:\*:\*:1.0' (for the connection resolver).
///
/// ### Examples ###
///
///     void MyMethod(ConfigParams _config, IReferences _references) async {
///         var endpoint = new GrpcEndpoint();
///         if (_config != null)
///             endpoint.configure(_config);
///         if (_references 1= null)
///             endpoint.setReferences(_references);
///         ...
///         _opened = false;
///
///         await endpoint.open(context);
///         _opened = true;
///
///         ...
///     }
class GrpcEndpoint implements IOpenable, IConfigurable, IReferenceable {
  static final _defaultConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'http',
    'connection.host',
    '0.0.0.0',
    'connection.port',
    3000,
    'credential.ssl_key_file',
    null,
    'credential.ssl_crt_file',
    null,
    'credential.ssl_ca_file',
    null,
    'options.maintenance_enabled',
    false,
    'options.request_max_size',
    1024 * 1024,
    'options.file_max_size',
    200 * 1024 * 1024,
    'options.connect_timeout',
    60000,
    'options.debug',
    true
  ]);

  grpc.Server? _server;
  final _connectionResolver = HttpConnectionResolver();
  final _logger = CompositeLogger();
  final _counters = CompositeCounters();
  bool _maintenanceEnabled = false;
  int _fileMaxSize = 200 * 1024 * 1024;
  String? _uri;
  final _registrations = <IRegisterable>[];
  Map<String, Future<dynamic> Function(IContext? context, Parameters args)>?
      _commandableMethods = {};
  Map<String, Schema>? _commandableSchemas = {};
  _CommandableMediator? _commandableService;
  final _services = <grpc.Service>[];
  final List<grpc.Interceptor> _interceptors = [];

  /// Configures this GrpcEndpoint using the given configuration parameters.
  ///
  /// Configuration parameters:
  /// - [connection(s)] - the connection resolver's connections;
  ///     - '[connection.discovery_key]' - the key to use for connection resolving in a discovery service;
  ///     - '[connection.protocol]' - the connection's protocol;
  ///     - '[connection.host]' - the target host;
  ///     - '[connection.port]' - the target port;
  ///     - '[connection.uri]' - the target URI.
  ///     - '[credential.ssl_key_file]' - SSL key in PEM
  ///     - '[credential.ssl_crt_file]' - SSL certificate in PEM
  ///     - '[credential.ssl_ca_file]' - Certificate authority (root certificate) in PEM
  ///
  /// - [config]    configuration parameters, containing a 'connection(s)' section.
  ///
  /// See [ConfigParams](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/ConfigParams-class.html) (in the PipServices 'Commons' package)
  @override
  void configure(ConfigParams config) {
    config = config.setDefaults(GrpcEndpoint._defaultConfig);
    _connectionResolver.configure(config);

    _maintenanceEnabled = config.getAsBooleanWithDefault(
        'options.maintenance_enabled', _maintenanceEnabled);
    _fileMaxSize =
        config.getAsLongWithDefault('options.file_max_size', _fileMaxSize);
  }

  /// Sets references to this endpoint's logger, counters, and connection resolver.
  ///
  /// References
  /// - [logger]: '\*:logger:\*:\*:1.0'
  /// - [counters]: '\*:counters:\*:\*:1.0'
  /// - [discovery]: '\*:discovery:\*:\*:1.0' (for the connection resolver)
  ///
  /// - [references]    an IReferences object, containing references to a logger, counters,
  ///                      and a connection resolver.
  /// See [IReferences] (in the PipServices 'Commons' package)
  @override
  void setReferences(IReferences references) {
    _logger.setReferences(references);
    _counters.setReferences(references);
    _connectionResolver.setReferences(references);
  }

  /// Returns whether or not this endpoint is open with an actively listening GRPC server.
  @override
  bool isOpen() {
    return _server != null;
  }

  /// Opens a connection using the parameters resolved by the referenced connection
  /// resolver and creates a GRPC server (service) using the set options and parameters.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return               Future the opening process is complete.
  /// Throws               error if one is raised.
  @override
  Future open(IContext? context) async {
    if (isOpen()) {
      return null;
    }

    var connection = await _connectionResolver.resolve(context);
    _uri = connection.getAsString('uri');
    try {
      await _connectionResolver.register(context);
      // Perform registration for adds all services before create server
      _performRegistrations();

      if (_interceptors.isNotEmpty) {
        _server = grpc.Server.create(
            services: _services, interceptors: _interceptors);
      } else {
        _server = grpc.Server.create(services: _services);
      }
      if (connection.getAsString('uri') == 'https') {
        var sslKeyFile = connection.getAsNullableString('ssl_key_file');
        var sslCrtFile = connection.getAsNullableString('ssl_crt_file');
        final certificate = File(sslCrtFile!).readAsBytes();
        final privateKey = File(sslKeyFile!).readAsBytes();
        var tlsCredentials = grpc.ServerTlsCredentials(
            certificate: await certificate, privateKey: await privateKey);
        await _server!.serve(
            address: connection.getAsString('host'),
            port: connection.getAsInteger('port'),
            security: tlsCredentials);
      } else {
        await _server!.serve(
            address: connection.getAsString('host'),
            port: connection.getAsInteger('port'));
      }
      _logger.debug(context, 'Opened GRPC service at %s', [_uri]);
    } catch (ex) {
      _server = null;
      throw ConnectionException(
              context != null ? ContextResolver.getTraceId(context) : null,
              'CANNOT_CONNECT',
              'Opening GRPC service failed')
          .wrap(ex)
          .withDetails('url', _uri);
    }
  }

  /// Closes this endpoint and the GRPC server (service) that was opened earlier.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return           Future the closing process is complete.
  /// Throws           error if one is raised.
  @override
  Future close(IContext? context) async {
    if (_server != null) {
      _uri = null;
      _commandableMethods = null;
      _commandableSchemas = null;
      _services.clear();

      // Eat exceptions
      try {
        await _server!.shutdown();
        _logger.debug(context, 'Closed GRPC service at %s', [_uri]);
        _commandableService = null;
        _server = null;
      } catch (ex) {
        _logger.warn(context, 'Failed while closing GRPC service: %s', [ex]);
      }
    }
  }

  /// Registers a registerable object for dynamic endpoint discovery.
  ///
  /// - [registration]      the registration to add.
  ///
  /// See [IRegisterable]

  void register(IRegisterable registration) {
    _registrations.add(registration);
  }

  /// Unregisters a registerable object, so that it is no longer used in dynamic
  /// endpoint discovery.
  ///
  /// - [registration]      the registration to remove.
  ///
  /// See [IRegisterable]

  void unregister(IRegisterable registration) {
    _registrations.remove(registration);
  }

  void _performRegistrations() {
    for (var registration in _registrations) {
      registration.register();
    }

    _registerCommandableService();
  }

  void _registerCommandableService() {
    if (_commandableMethods == null || _commandableMethods!.isEmpty) return;

    _commandableService = _CommandableMediator();
    _commandableService!.invokeFunc = _invokeCommandableMethod;

    registerService(_commandableService!);
  }

  Future<command.InvokeReply> _invokeCommandableMethod(
      grpc.ServiceCall call, command.InvokeRequest request) async {
    var method = request.method;
    var action =
        _commandableMethods != null ? _commandableMethods![method] : null;
    var traceId = request.traceId;
    var response = command.InvokeReply();

    // Handle method not found
    if (action == null) {
      var err = InvocationException(
              traceId, 'METHOD_NOT_FOUND', 'Method $method was not found')
          .withDetails('method', method);

      var respErr = ErrorDescriptionFactory.create(err);
      response.error = command.ErrorDescription();
      response.error.category = respErr.category ?? '';
      response.error.code = respErr.code ?? '';
      response.error.traceId = respErr.trace_id ?? '';
      response.error.status = respErr.status ?? 0;
      response.error.message = respErr.message ?? '';
      response.error.cause = respErr.cause ?? '';
      response.error.stackTrace = respErr.stack_trace ?? '';
      response.error.details.addAll(respErr.details as Map<String, String>);
      response.resultEmpty = true;
      response.resultJson = '';

      return response;
    }

    try {
      // Convert arguments
      var argsEmpty = request.argsEmpty;
      var argsJson = request.argsJson;
      var args = !argsEmpty
          ? Parameters.fromJson(json.decode(argsJson))
          : Parameters();

      // TODO: Validate schema
      // var schema = _commandableSchemas[method];
      // if (schema != null) {
      //   //...
      // }
      // Call command action
      try {
        var result = await action(Context.fromTraceId(traceId), args);
        response.error = command.ErrorDescription().createEmptyInstance();
        response.resultEmpty = result == null;
        response.resultJson = result != null ? json.encode(result) : '';
      } catch (err) {
        // Process result and generate response
        var respErr = ErrorDescriptionFactory.create(err);
        response.error = command.ErrorDescription();
        response.error.category = respErr.category ?? '';
        response.error.code = respErr.code ?? '';
        response.error.traceId = respErr.trace_id ?? '';
        response.error.status = respErr.status ?? 0;
        response.error.message = respErr.message ?? '';
        response.error.cause = respErr.cause ?? '';
        response.error.stackTrace = respErr.stack_trace ?? '';
        response.error.details.addAll(respErr.details as Map<String, String>);
        response.resultEmpty = true;
        response.resultJson = '';
      }
    } catch (ex) {
      // Handle unexpected exception
      var err =
          InvocationException(traceId, 'METHOD_FAILED', 'Method $method failed')
              .wrap(ex)
              .withDetails('method', method);
      var respErr = ErrorDescriptionFactory.create(err);
      response.error = command.ErrorDescription();
      response.error.category = respErr.category ?? '';
      response.error.code = respErr.code ?? '';
      response.error.traceId = respErr.trace_id ?? '';
      response.error.status = respErr.status ?? 0;
      response.error.message = respErr.message ?? '';
      response.error.cause = respErr.cause ?? '';
      response.error.stackTrace = respErr.stack_trace ?? '';
      response.error.details.addAll(respErr.details as Map<String, String>);
      response.resultEmpty = true;
      response.resultJson = '';
    }
    return response;
  }

  /// Registers a service with related implementation
  ///
  /// - [implementation] a GRPC service object with service implementation methods.
  void registerService(grpc.Service implementation) {
    _services.add(implementation);
  }

  /// Registers a commandable method in this objects GRPC server (service) by the given name.,
  ///
  /// - [method]        the GRPC method name.
  /// - [schema]        the schema to use for parameter validation.
  /// - [action]        the action to perform at the given route.
  void registerCommadableMethod(String method, Schema? schema,
      Future<dynamic> Function(IContext? context, Parameters args) action) {
    _commandableMethods![method] = action;
    _commandableSchemas![method] = schema ?? Schema();
  }

  /// Registers a interceptor in this objects GRPC server (service)
  ///
  /// - [action]        the action to perform.
  void registerInterceptor(grpc.Interceptor action) {
    // _interceptors ??= <grpc.Interceptor>[];
    _interceptors.add(action);
  }
}
