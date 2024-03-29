import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';

import '../../pip_services4_config.dart';

/// Used to store key-identifiable information about connections.
class DiscoveryItem {
  String? key;
  ConnectionParams? connection;
}

/// Discovery service that keeps connections in memory.
///
/// ### Configuration parameters ###
///
/// - [connection key 1]:
///     - ...                          connection parameters for key 1
/// - [connection key 2]:
///     - ...                          connection parameters for key N
///
/// See [IDiscovery]
/// See [ConnectionParams]
///
/// ### Example ###
///
///     var config = ConfigParams.fromTuples(
///         'key1.host', '10.1.1.100',
///         'key1.port', '8080',
///         'key2.host', '10.1.1.100',
///         'key2.port', '8082'
///     );
///
///     var discovery = new MemoryDiscovery();
///     discovery.configure(config);
///
///     var connection await discovery.resolveOne('123', 'key1');
///         // Result: host=10.1.1.100;port=8080
class MemoryDiscovery implements IDiscovery, IReconfigurable {
  List<DiscoveryItem> _items = <DiscoveryItem>[];

  /// Creates a new instance of discovery service.
  ///
  /// - [config]    (optional) configuration with connection parameters.
  MemoryDiscovery([ConfigParams? config]) {
    if (config != null) configure(config);
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    readConnections(config);
  }

  /// Reads connections from configuration parameters.
  /// Each section represents an individual Connectionparams
  ///
  /// - [config]   configuration parameters to be read
  void readConnections(ConfigParams config) {
    _items = [];

    if (config.isNotEmpty) {
      var connectionSections = config.getSectionNames();
      for (var index = 0; index < connectionSections.length; index++) {
        var key = connectionSections[index];
        var value = config.getSection(key);

        var item = DiscoveryItem();
        item.key = key;
        item.connection = ConnectionParams(value);
        _items.add(item);
      }
    }
  }

  /// Registers connection parameters into the discovery service.
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a key to uniquely identify the connection parameters.
  /// - [credential]        a connection to be registered.
  /// Return 			Future that receives a registered connection or error.
  @override
  Future<ConnectionParams> register(
      IContext? context, String key, ConnectionParams connection) async {
    var item = DiscoveryItem();
    item.key = key;
    item.connection = connection;
    _items.add(item);

    return connection;
  }

  /// Resolves a single connection parameters by its key.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a key to uniquely identify the connection.
  /// Return          Future that receives found connection or error.
  @override
  Future<ConnectionParams?> resolveOne(IContext? context, String key) async {
    ConnectionParams? connection;
    for (var index = 0; index < _items.length; index++) {
      var item = _items[index];
      if (item.key == key && item.connection != null) {
        connection = item.connection;
        break;
      }
    }
    return connection;
  }

  /// Resolves all connection parameters by their key.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [key]               a key to uniquely identify the connections.
  /// Return          Future that receives found connections or error.
  @override
  Future<List<ConnectionParams>> resolveAll(
      IContext? context, String key) async {
    var connections = <ConnectionParams>[];
    for (var index = 0; index < _items.length; index++) {
      var item = _items[index];
      if (item.key == key && item.connection != null) {
        connections.add(item.connection!);
      }
    }
    return connections;
  }
}
