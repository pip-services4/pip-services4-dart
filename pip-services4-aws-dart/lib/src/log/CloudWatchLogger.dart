import 'dart:async';

import 'package:aws_logs_api/logs-2014-03-28.dart';

import 'package:http/http.dart' as http;

import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';

import '../connect/AwsConnectionParams.dart';
import '../connect/AwsConnectionResolver.dart';

/// Logger that writes log messages to AWS Cloud Watch Log.
///
/// ### Configuration parameters ###
///
/// - [stream]:                        (optional) Cloud Watch Log stream (default: context name)
/// - [group]:                         (optional) Cloud Watch Log group (default: context instance ID or hostname)
/// - [connections]:
///     - [discovery_key]:               (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///     - [region]:                      (optional) AWS region
/// - [credentials]:
///     - [store_key]:                   (optional) a key to retrieve the credentials from [ICredentialStore](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/ICredentialStore-class.html)
///     - [access_id]:                   AWS access/client id
///     - [access_key]:                  AWS access/client id
/// - [options]:
///     - [interval]:        interval in milliseconds to save current counters measurements (default: 5 mins)
///     - [reset_timeout]:   timeout in milliseconds to reset the counters. 0 disables the reset (default: 0)
///
/// ### References ###
///
/// - *:context-info:\*:\*:1.0      (optional) [ContextInfo](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/ContextInfo-class.html) to detect the context id and specify counters source
/// - *:discovery:\*:\*:1.0         (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connections
/// - *:credential-store:\*:\*:1.0  (optional) Credential stores to resolve credentials
///
/// See [Counter](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/Counter-class.html) (in the Pip.Services components package)
/// See [CachedCounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/CachedCounters-class.html) (in the Pip.Services components package)
/// See [CompositeLogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/CompositeLogger-class.html) (in the Pip.Services components package)

///
/// ### Example ###
///
///     var logger =  Logger();
///     logger.config(ConfigParams.fromTuples(
///         'stream', 'mystream',
///         'group', 'mygroup',
///         'connection.region', 'us-east-1',
///         'connection.access_id', 'XXXXXXXXXXX',
///         'connection.access_key', 'XXXXXXXXXXX'
///     ));
///     logger.setReferences(References.fromTuples([
///          Descriptor('pip-services', 'logger', 'console', 'default', '1.0'),
///          ConsoleLogger()
///     ]));
///
///     logger.open(Context.fromTraceId('123'));
///         ...
///
///     logger.setLevel(LogLevel.debug);
///
///     logger.error(Context.fromTraceId('123'), ex, 'Error occured: %s', ex.message);
///     logger.debug(Context.fromTraceId('123'), 'Everything is OK.');

class CloudWatchLogger extends CachedLogger
    implements IReferenceable, IOpenable {
  Timer? _timer;

  final _connectionResolver = AwsConnectionResolver();
  CloudWatchLogs? _service; //AmazonCloudWatchLogsClient
  http.Client? _client;
  AwsConnectionParams? _connection;
  int _connectTimeout = 30000;

  String _group = 'undefined';
  String? _stream;
  String? _lastToken;

  final _logger = CompositeLogger();

  /// Creates a new instance of this logger.
  CloudWatchLogger() : super();

  /// Configures component by passing configuration parameters.
  ///
  ///  -  [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    super.configure(config);
    _connectionResolver.configure(config);

    _group = config.getAsStringWithDefault('group', _group);
    _stream = config.getAsStringWithDefault('stream', _stream ?? '');
    _connectTimeout = config.getAsIntegerWithDefault(
        'options.connect_timeout', _connectTimeout);
  }

  /// Sets references to dependent components.
  ///
  ///  -  [references] 	references to locate the component dependencies.
  /// See [IReferences](https://pub.dev/documentation/pip_services4_commons/latest/pip_services4_commons/IReferences-class.html) (in the Pip.Services commons package)
  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    _logger.setReferences(references);
    _connectionResolver.setReferences(references);

    var contextInfo = references.getOneOptional<ContextInfo>(
        Descriptor('pip-services', 'context-info', 'default', '*', '1.0'));
    if (contextInfo != null && _stream == null) {
      _stream = contextInfo.name;
    }
    // ignore: unnecessary_null_comparison
    if (contextInfo != null && _group == null) {
      _group = contextInfo.contextId;
    }
  }

  /// Writes a log message to the logger destination.
  ///
  ///  -  [level]             a log level.
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  -  [ex]             an exception object associated with this message.
  ///  -  [message]           a human-readable message to log.
  @override
  void write(LogLevel level, IContext? context, Exception? ex, String message) {
    if (getLevel().index < level.index) {
      return;
    }
    super.write(level, context, ex, message);
  }

  /// Checks if the component is opened.
  ///
  /// Returns true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return _timer != null;
  }

  /// Opens the component.
  ///
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  Return 			Future that receives  null no errors occured.
  /// Throws error
  @override
  Future open(IContext? context) async {
    if (isOpen()) {
      return;
    }

    _connection = await _connectionResolver.resolve(context);

    //timeout: this._connectTimeout

    _client = http.Client();
    final credentials = AwsClientCredentials(
        accessKey: _connection!.getAccessId() ?? '',
        secretKey: _connection!.getAccessKey() ?? '');
    _service = CloudWatchLogs(
        region: _connection!.getRegion() ?? '',
        credentials: credentials,
        client: _client);

    try {
      await _service?.createLogGroup(logGroupName: _group);
    } catch (err) {
      if (err is! ResourceAlreadyExistsException) {
        rethrow;
      }
    }

    try {
      await _service?.createLogStream(
          logGroupName: _group, logStreamName: _stream ?? '');
      _lastToken = null;
    } catch (err) {
      if (err is ResourceAlreadyExistsException) {
        var data = await _service?.describeLogStreams(
            logGroupName: _group, logStreamNamePrefix: _stream);
        if (data != null &&
            data.logStreams != null &&
            data.logStreams!.isNotEmpty) {
          _lastToken = data.logStreams?[0].uploadSequenceToken;
        }
      } else {
        rethrow;
      }
    }

    _timer ??= Timer.periodic(Duration(milliseconds: interval), (tm) {
      dump();
    });
  }

  /// Closes component and frees used resources.
  ///
  ///  -  [context]     (optional) a context to trace execution through call chain.
  ///  Return 			Future that receives error or null no errors occured.
  @override
  Future close(IContext? context) async {
    await save(cache);

    if (_timer != null) {
      _timer!.cancel();
    }

    cache = [];
    _timer = null;
    _service = null;
  }

  // ignore: unused_element
  String _formatMessageText(LogMessage message) {
    var result = '';
    result +=
        '[${message.source ?? '---'}:${message.trace_id ?? '---'}:${message.level}] ${message.message}';
    if (message.error != null) {
      // ignore: unnecessary_null_comparison
      if (message.message == null || message.message.isEmpty) {
        result += 'Error: ';
      } else {
        result += ': ';
      }

      result += message.error!.message ?? '';

      if (message.error!.stack_trace != null &&
          message.error!.stack_trace!.isNotEmpty) {
        result += ' StackTrace: ${message.error!.stack_trace}';
      }
    }

    return result;
  }

  /// Saves log messages from the cache.
  ///
  ///  -  [messages]  a list with log messages
  ///  Return  Future that receives error or null for success.
  @override
  Future save(List<LogMessage> messages) async {
    // ignore: unnecessary_null_comparison
    if (!isOpen() || messages == null || messages.isEmpty) {
      return;
    }

    if (_service == null) {
      throw ConfigException(
          'cloudwatch_logger', 'NOT_OPENED', 'CloudWatchLogger is not opened');
    }

    var events = <InputLogEvent>[];

    for (var message in messages) {
      var event = InputLogEvent(
          message: message.message,
          timestamp: message.time!.millisecondsSinceEpoch);
      events.add(event);
    }

    // get token again if saving log from another container

    var data = await _service?.describeLogStreams(
        logGroupName: _group, logStreamNamePrefix: _stream);

    if (data != null &&
        data.logStreams != null &&
        data.logStreams!.isNotEmpty) {
      _lastToken = data.logStreams?[0].uploadSequenceToken;
    }

    try {
      var data = await _service?.putLogEvents(
          logEvents: events,
          logGroupName: _group,
          logStreamName: _stream ?? '',
          sequenceToken: _lastToken);
      _lastToken = data?.nextSequenceToken;
    } catch (err) {
      _logger.error(null, ApplicationException().wrap(err), 'cloudwatch_logger',
          ['putLogEvents error']);
    }
  }
}
