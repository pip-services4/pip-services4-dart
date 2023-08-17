import 'dart:async';

import 'package:pip_services4_config/pip_services4_config.dart';
import 'package:pip_services4_logic/pip_services4_logic.dart';
import 'package:redis/redis.dart' as redis;
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

///Distributed cache that stores values in Redis in-memory database.
///
///### Configuration parameters ###
///
/// - [connection(s)]:
///  - [discovery_key]:         (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///  - [host]:                  host name or IP address
///  - [port]:                  port number
///  - [uri]:                   resource URI or connection string with all parameters in it
/// - [credential(s)]:
///  - [store_key]:             key to retrieve parameters from credential store
///  - [username]:              user name (currently is not used)
///  - [password]:              user password
/// - [options]:
///  - [retries]:               number of retries (default: 3)
///  - [timeout]:               default caching timeout in milliseconds (default: 1 minute)
///  - [max_size]:              maximum number of values stored in this cache (default: 1000)
///
///### References ###
///
/// - *:discovery:*:*:1.0        (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection
/// - *:credential-store:*:*:1.0 (optional) Credential stores to resolve credential [ICredentialStore](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/ICredentialStore-class.html)
///
///### Example ###
///```dart
///    var cache = RedisCache();
///    cache.configure(ConfigParams.fromTuples([
///      "host", "localhost",
///      "port", 6379
///    ]));
///
///   await cache.open(Context.fromTraceId("123"));
///      ...
///
///    await cache.store(Context.fromTraceId("123"), "key1", "ABC");
///    var value = await cache.retrieve(Context.fromTraceId("123"), "key1");
///     // Result: "ABC"
///```
class RedisCache implements ICache, IConfigurable, IReferenceable, IOpenable {
  final _connectionResolver = ConnectionResolver();
  final _credentialResolver = CredentialResolver();

  int _timeout = 30000;
  int _retries = 3;

  redis.Command? _client;

  ///Creates a new instance of this cache.
  RedisCache();

  ///Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _connectionResolver.configure(config);
    _credentialResolver.configure(config);

    _timeout = config.getAsIntegerWithDefault('options.timeout', _timeout);
    _retries = config.getAsIntegerWithDefault('options.retries', _retries);
  }

  ///Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    _connectionResolver.setReferences(references);
    _credentialResolver.setReferences(references);
  }

  ///Checks if the component is opened.
  ///
  ///Returns true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return _client != null;
  }

  ///Opens the component.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return 			Future that receives null no errors occured.
  /// Throws error
  @override
  Future open(IContext? context) async {
    var connection = await _connectionResolver.resolve(context);
    if (connection == null) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_CONNECTION',
          'Connection is not configured');
    }
    //credential = await _credentialResolver.lookup(context);

    var redisConn = redis.RedisConnection();

    //TODO: Fix work with uri connection string and credentials
    // if (connection.getUri() != null) {
    //   var url = connection.getUri();
    // } else {
    var host = connection.getHost() ?? 'localhost';
    var port = connection.getPort() ?? 6379;
    _client = await redisConn.connect(host, port);

    // }

    // if (credential != null) {
    //   var password = credential.getPassword();
    // }
  }

  ///Closes component and frees used resources.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return 			Future that receives null if no errors occured.
  /// Throws error
  @override
  Future close(IContext? context) async {
    if (_client != null) {
      await _client!.get_connection().close();
      _client = null;
    }
  }

  bool _checkOpened(IContext? context) {
    if (!isOpen()) {
      throw InvalidStateException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NOT_OPENED',
          'Connection is not opened');
    }
    return true;
  }

  ///Retrieves cached value from the cache using its key.
  ///If value is missing in the cache or expired it returns null.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique value key.
  /// Return                Future that receives cached value.
  /// Throws error
  @override
  Future<dynamic> retrieve(IContext? context, String key) async {
    if (!_checkOpened(context)) return;
    return await _client!.get(key);
  }

  ///Stores value in the cache with expiration time.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique value key.
  /// - [value]             a value to store.
  /// - [timeout]           expiration timeout in milliseconds.
  /// Return                Future that receives an 'OK' for success
  /// Throws error
  @override
  Future<dynamic> store(
      IContext? context, String key, value, int timeout) async {
    if (!_checkOpened(context)) return;
    return await _client!.send_object(['SET', key, value, 'PX', timeout]);
  }

  ///Removes a value from the cache by its key.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a unique value key.
  /// Return                Future function that receives an null for success
  /// Throws error
  @override
  Future<dynamic> remove(IContext? context, String key) async {
    if (!_checkOpened(context)) return;
    return await _client!.send_object(['DEL', key]);
  }
}
