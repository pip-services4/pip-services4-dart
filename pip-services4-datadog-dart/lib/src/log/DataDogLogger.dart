import 'dart:async';
import 'dart:io';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';

import '../clients/DataDogLogClient.dart';
import '../clients/DataDogLogMessage.dart';

/// Logger that dumps execution logs to DataDog service.
///
/// DataDog is a popular monitoring SaaS service. It collects logs, metrics, events
/// from infrastructure and applications and analyze them in a single place.
///
/// ### Configuration parameters ###
///
/// - level:             maximum log level to capture
/// - source:            source (context) name
/// - connection:
///     - discovery_key:         (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///     - protocol:              (optional) connection protocol: http or https (default: https)
///     - host:                  (optional) host name or IP address (default: http-intake.logs.datadoghq.com)
///     - port:                  (optional) port number (default: 443)
///     - uri:                   (optional) resource URI or connection string with all parameters in it
/// - credential:
///     - access_key:      DataDog client api key
/// - options:
///     - interval:        interval in milliseconds to save log messages (default: 10 seconds)
///     - max_cache_size:  maximum number of messages stored in this cache (default: 100)
///     - reconnect:       reconnect timeout in milliseconds (default: 60 sec)
///     - timeout:         invocation timeout in milliseconds (default: 30 sec)
///     - max_retries:     maximum number of retries (default: 3)
///
/// ### References ###
///
/// - *:context-info:\*:\*:1.0      (optional) [ContextInfo](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/ContextInfo-class.html) to detect the context id and specify counters source
/// - *:discovery:\*:\*:1.0         (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection
///
/// ### Example ###
///
///     var logger = DataDogLogger();
///     logger.configure(ConfigParams.fromTuples([
///         'credential.access_key', '827349874395872349875493'
///     ]));
///
///     await logger.open(Context.fromTraceId('123'));
///
///     logger.error(Context.fromTraceId('123'), ex, 'Error occured: %s', ex.message);
///     logger.debug(Context.fromTraceId('123'), 'Everything is OK.');
class DataDogLogger extends CachedLogger implements IReferenceable, IOpenable {
  final _client = DataDogLogClient(null);
  Timer? _timer;
  String _instance = Platform.localHostname;

  /// Creates a new instance of the logger.
  DataDogLogger() : super();

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    super.configure(config);
    _client.configure(config);

    _instance = config.getAsStringWithDefault('instance', _instance);
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    _client.setReferences(references);

    final contextInfo = references.getOneOptional<ContextInfo>(
        Descriptor('pip-services', 'context-info', 'default', '*', '1.0'));
    if (contextInfo != null && source == null) {
      source = contextInfo.name;
    }
    // ignore: unnecessary_null_comparison
    if (contextInfo != null && _instance == null) {
      _instance = contextInfo.contextId;
    }
  }

  /// Checks if the component is opened.
  ///
  /// Return true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return _timer != null;
  }

  /// Opens the component.
  ///
  /// - [context] 	(optional) execution context to trace execution through call chain.
  @override
  Future open(IContext? context) async {
    if (isOpen()) {
      return;
    }

    await _client.open(context);

    _timer ??= Timer.periodic(Duration(milliseconds: interval), (tm) {
      dump();
    });
  }

  /// Closes component and frees used resources.
  ///
  /// - [context] 	(optional) execution context to trace execution through call chain.
  @override
  Future close(IContext? context) async {
    await save(cache);

    if (_timer != null) {
      _timer!.cancel();
    }

    cache = [];
    _timer = null;

    await _client.close(context);
  }

  // private convertStatus(level: number): string {
  //     switch (level) {
  //         case LogLevel.Fatal:
  //             return DataDogStatus.Emergency;
  //         case LogLevel.Error:
  //             return DataDogStatus.Error;
  //         case LogLevel.Warn:
  //             return DataDogStatus.Warn;
  //         case LogLevel.Info:
  //             return DataDogStatus.Info;
  //         case LogLevel.Debug:
  //             return DataDogStatus.Debug;
  //         case LogLevel.Trace:
  //             return DataDogStatus.Debug;
  //         default:
  //             return DataDogStatus.Info;
  //     }
  // }

  DataDogLogMessage _convertMessage(LogMessage message) {
    DataDogLogMessage result = DataDogLogMessage(
        time: message.time ?? DateTime.now(),
        tags: {'trace_id': message.trace_id ?? ''},
        host: _instance,
        service: message.source ?? source,
        status: message.level,
        message: message.message);

    if (message.error != null) {
      result.error_kind = message.error?.type;
      result.error_message = message.error?.message;
      result.error_stack = message.error?.stack_trace;
    }

    return result;
  }

  /// Saves log messages from the cache.
  ///
  /// - [messages]  a list with log messages
  @override
  Future save(List<LogMessage> messages) async {
    if (!isOpen() || messages.isEmpty) {
      return;
    }

    final data = messages.map((m) => _convertMessage(m)).toList();

    await _client.sendLogs(Context.fromTraceId('datadog-logger'), data);
  }
}
