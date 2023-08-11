import 'dart:async';

import 'package:elastic_client/elastic_client.dart';
import 'package:intl/intl.dart';

import 'package:elastic_client/elastic_client.dart' as elastic;
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';

/// Logger that dumps execution logs to ElasticSearch service.
///
/// ElasticSearch is a popular search index. It is often used
/// to store and index execution logs by itself or as a part of
/// ELK (ElasticSearch - Logstash - Kibana) stack.
///
/// Authentication is not supported in this version.
///
/// ### Configuration parameters ###
///
/// - [level]:             maximum log level to capture
/// - [source]:            source (context) name
/// - [connection(s)]:
///     - [discovery_key]:         (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///     - [protocol]:              connection protocol: http or https
///     - [host]:                  host name or IP address
///     - [port]:                  port number
///     - [uri]:                   resource URI or connection string with all parameters in it
/// - [options]:
///     - [interval]:        interval in milliseconds to save log messages (default: 10 seconds)
///     - [max_cache_size]:  maximum number of messages stored in this cache (default: 100)
///     - [index]:           ElasticSearch index name (default: 'log')
///     - [date_format]      The date format to use when creating the index name. Eg. log-yyyyMMdd (default: 'yyyyMMdd'). See [DateFormat](https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html)
///     - [daily]:           true to create a new index every day by adding date suffix to the index
///                        name (default: false)
///     - [reconnect]:       reconnect timeout in milliseconds (default: 60 sec)
///     - [timeout]:         invocation timeout in milliseconds (default: 30 sec)
///     - [max_retries]:     maximum number of retries (default: 3)
///     - [index_message]:   true to enable indexing for message object (default: false)
///     - [include_type_name]: Will create using a "typed" index compatible with ElasticSearch 6.x (default: false)
///
/// ### References ###
///
/// - \*:context-info:\*:\*:1.0      (optional) [ContextInfo](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/ContextInfo-class.html) to detect the context id and specify counters source
/// - \*:discovery:\*:\*:1.0         (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection
///
/// ### Example ###
///
///     var logger = ElasticSearchLogger();
///     logger.configure(ConfigParams.fromTuples([
///         'connection.protocol', 'http',
///         'connection.host', 'localhost',
///         'connection.port', 9200
///     ]));
///
///     await logger.open(Context.fromTraceId('123'))
///         ...
///
///     logger.error(Context.fromTraceId('123'), ex, 'Error occured: %s', ex.message);
///     logger.debug(Context.fromTraceId('123'), 'Everything is OK.');

class ElasticSearchLogger extends CachedLogger
    implements IReferenceable, IOpenable {
  final _connectionResolver = HttpConnectionResolver();

  Timer? _timer;
  String _index = 'log';
  String _dateFormat = 'yyyyMMdd';
  bool _dailyIndex = false;
  String? _currentIndex;
  int _reconnect = 60000;
  int _timeout = 30000;
  int _maxRetries = 3;
  bool _indexMessage = false;
  bool _includeTypeName = false;

  elastic.Client? _client;
  HttpTransport? _transport;

  /// Creates a new instance of the logger.
  ElasticSearchLogger() : super();

  /// Configures component by passing configuration parameters.
  ///
  /// -  [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    super.configure(config);

    _connectionResolver.configure(config);

    _index = config.getAsStringWithDefault('index', _index);
    _dateFormat = config.getAsStringWithDefault('date_format', _dateFormat);
    _dailyIndex = config.getAsBooleanWithDefault('daily', _dailyIndex);
    _reconnect =
        config.getAsIntegerWithDefault('options.reconnect', _reconnect);
    _timeout = config.getAsIntegerWithDefault('options.timeout', _timeout);
    _maxRetries =
        config.getAsIntegerWithDefault('options.max_retries', _maxRetries);
    _indexMessage =
        config.getAsBooleanWithDefault('options.index_message', _indexMessage);
    _includeTypeName = config.getAsBooleanWithDefault(
        'options.include_type_name', _includeTypeName);
  }

  /// Sets references to dependent components.
  ///
  /// -  [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    _connectionResolver.setReferences(references);
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
  /// -  [context]     (optional) a context to trace execution through call chain.
  /// Return 			Future that receives null no errors occured.
  /// Throws error
  @override
  Future open(IContext? context) async {
    if (isOpen()) {
      return null;
    }

    var connection = await _connectionResolver.resolve(context);
    // ignore: unnecessary_null_comparison
    if (connection == null) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_CONNECTION',
          'Connection is not configured');
    }

    var uri = connection.getAsString('uri');

    // var options = {
    //     host: uri,
    //     requestTimeout: this._timeout,
    //     deadTimeout: this._reconnect,
    //     maxRetries: this._maxRetries
    // };

    _transport = HttpTransport(url: Uri.parse(uri));
    _client = elastic.Client(_transport!);

    await _createIndexIfNeeded(context, true);
    _timer = Timer.periodic(Duration(milliseconds: interval), (tm) {
      dump();
    });
  }

  /// Closes component and frees used resources.
  ///
  /// -  [context]     (optional) a context to trace execution through call chain.
  /// Return 			Future that receives null no errors occured.
  /// Throws error
  @override
  Future close(IContext? context) async {
    await save(cache);
    if (_timer != null) {
      _timer!.cancel();
    }

    cache = [];
    _timer = null;
    _client = null;
    await _transport?.close();
    _transport = null;
  }

  String _getCurrentIndex() {
    if (!_dailyIndex) return _index;

    return '$_index-${DateFormat(_dateFormat).format(DateTime.now().toUtc())}';
  }

  Future _createIndexIfNeeded(IContext? context, bool force) async {
    var newIndex = _getCurrentIndex();
    if (!force && _currentIndex == newIndex) {
      return null;
    }

    _currentIndex = newIndex;
    var exists = await _client!.indexExists(index: _currentIndex!);

    if (exists) {
      return null;
    }

    await _client!.updateIndex(index: _currentIndex!, content: {
      'settings': {'number_of_shards': 1},
      'mappings': _getIndexSchema()
    });
  }

  /// Returns the schema of the log message
  /// - [include_type_name] A flag that indicates whether the schema should follow the pre-ES 6.x convention
  Map<String, dynamic> _getIndexSchema() {
    var schema = {
      'properties': {
        'time': {'type': 'date', 'index': true},
        'source': {'type': 'keyword', 'index': true},
        'level': {'type': 'keyword', 'index': true},
        'trace_id': {'type': 'text', 'index': true},
        'error': {
          'type': 'object',
          'properties': {
            'type': {'type': 'keyword', 'index': true},
            'category': {'type': 'keyword', 'index': true},
            'status': {'type': 'integer', 'index': false},
            'code': {'type': 'keyword', 'index': true},
            'message': {'type': 'text', 'index': false},
            'details': {'type': 'object'},
            'trace_id': {'type': 'text', 'index': false},
            'cause': {'type': 'text', 'index': false},
            'stack_trace': {'type': 'text', 'index': false}
          }
        },
        'message': {'type': 'text', 'index': _indexMessage}
      }
    };
    if (_includeTypeName) {
      return {'log_message': schema};
    } else {
      return schema;
    }
  }

  /// Saves log messages from the cache.
  ///
  /// -  [messages]  a list with log messages
  /// Return  Future that receives null for success.
  /// Throws error
  @override
  Future save(List<LogMessage> messages) async {
    if (!isOpen() && messages.isEmpty) {
      return null;
    }

    await _createIndexIfNeeded(
        Context.fromTraceId('elasticsearch_logger'), false);

    var logItem = getLogItem();

    var bulk = <Doc>[];
    for (var message in messages) {
      var doc = Doc(logItem['_id'], message.toJson(),
          index: logItem['_index'], type: logItem['_type']);
      bulk.add(doc);
    }

    var compleate = await _client!.bulk(updateDocs: bulk);
    if (!compleate) {
      throw ApplicationException('Logger', 'elasticsearch_logger', 'SAVE_ERROR',
          'Can\'t save log messages to Elasticsearch server!');
    }
  }

  Map<String, dynamic> getLogItem() {
    return _includeTypeName
        ? {
            '_index': _currentIndex,
            '_type': 'log_message',
            '_id': IdGenerator.nextLong()
          } // ElasticSearch 6.x
        : {
            '_index': _currentIndex,
            '_id': IdGenerator.nextLong()
          }; // ElasticSearch 7.x
  }
}
