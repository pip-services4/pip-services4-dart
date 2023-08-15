import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_persistence/pip_services4_persistence.dart';
import '../persistence/MySqlPersistence.dart';

/// Abstract persistence component that stores data in MySQL
/// and implements a number of CRUD operations over data items with unique ids.
/// The data items must implement [IIdentifiable] interface.
///
/// In basic scenarios child classes shall only override [getPageByFilter_],
/// [getListByFilter_] or [deleteByFilter_] operations with specific filter function.
/// All other operations can be used out of the box.
///
/// In complex scenarios child classes can implement additional operations by
/// accessing connection_ and client_ properties.
///
/// ### Configuration parameters ###
///
/// - [table]:                  (optional) MySQL table name
/// - [schema]:                 (optional) MySQL schema name
/// - [connection(s)]:
///   - [discovery_key]:             (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///   - [host]:                      host name or IP address
///   - [port]:                      port number (default: 27017)
///   - [uri]:                       resource URI or connection string with all parameters in it
/// - [credential(s)]:
///   - [store_key]:                 (optional) a key to retrieve the credentials from [ICredentialStore](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/ICredentialStore-class.html)
///   - [username]:                  (optional) user name
///   - [password]:                  (optional) user password
/// - [options]:
///   - [connect_timeout]:      (optional) number of milliseconds to wait before timing out when connecting a new client (default: 10000)
///
///   Note: the options below are currently not supported.
///   - [idle_timeout]:         (optional) number of milliseconds a client must sit idle in the pool and not be checked out (default: 10000)
///   - [max_pool_size]:        (optional) maximum number of clients the pool should contain (default: 10)
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0           (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - \*:discovery:*:*:1.0        (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services
/// - \*:credential-store:\*:\*:1.0 (optional) Credential stores to resolve credentials
///
/// ### Example ###
///
///     class MyMySqlPersistence extends IdentifiableMySqlPersistence<MyData, String> {
///       MyMySqlPersistence() : super('mydata', null);
///
///       @override
///       void defineSchema_() {
///         clearSchema();
///         ensureSchema_('CREATE TABLE `' +
///             tableName_! +
///             '` (id VARCHAR(32) PRIMARY KEY, `key` VARCHAR(50), `content` TEXT)');
///         ensureIndex_(tableName_! + '_key', {'key': 1}, {'unique': true});
///       }
///
///       @override
///       Future<DataPage<MyData>> getPageByFilter(
///           IContext? context, FilterParams? filter, PagingParams? paging) async {
///         filter = filter ?? new FilterParams();
///         var key = filter.getAsNullableString('key');
///
///         var filterCondition = null;
///         if (key != null) {
///           filterCondition += 'key='$key';
///         }
///
///         return super
///             .getPageByFilter_(context, filterCondition, paging, null, null);
///       }
///     }
///     var persistence = MyMySqlPersistence();
///     persistence
///         .configure(ConfigParams.fromTuples(['host', 'localhost', 'port', 27017]));
///     await persistence.open(null);
///     var item = await persistence.create(null, MyData());
///     var page = await persistence.getPageByFilter(
///         null, FilterParams.fromTuples(['key', 'ABC']), null);
///     print(page.data);
///     var deleted = await persistence.deleteById(null, '1');

class IdentifiableMySqlPersistence<T extends IIdentifiable<K>, K>
    extends MySqlPersistence<T>
    implements IWriter<T, K>, IGetter<T, K>, ISetter<T> {
  // Flag to turn on auto generation of object ids.
  bool autoGenerateId_ = true;

  /// Creates a new instance of the persistence component.
  ///
  /// - [tableName]    (optional) a table name.
  /// - [schemaName]   (optional) a schema name
  IdentifiableMySqlPersistence(String? tableName, String? schemaName)
      : super(tableName, schemaName);

  /// Converts the given object from the public partial format.
  ///
  /// - [value]     the object to convert from the public partial format.
  /// Return the initial object.
  dynamic convertFromPublicPartial_(value) {
    return convertFromPublic_(value);
  }

  /// Gets a list of data items retrieved by given unique ids.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [ids]               ids of data items to be retrieved
  /// Return a list with requested data items.
  Future<List<T>> getListByIds(IContext? context, List<K> ids) async {
    var params = generateParameters_(ids);
    var query = 'SELECT * FROM ${quotedTableName_()} WHERE id IN($params)';

    var res = await client_!.query(query, ids);
    logger_.trace(context, 'Retrieved %d from %s', [res.length, tableName_]);

    var items =
        res.toList().map((e) => convertToPublic_(e.fields) as T).toList();
    return items;
  }

  /// Gets a data item by its unique id.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [id]                an id of data item to be retrieved.
  /// Return a requested data item or `null if nothing was found.
  @override
  Future<T?> getOneById(IContext? context, K id) async {
    var query = 'SELECT * FROM ${quotedTableName_()} WHERE id=?';
    var params = [id];

    var res = await client_!.query(query, params);

    if (res.toList().isEmpty) {
      logger_.trace(
          context, 'Nothing found from %s with id = %s', [tableName_, id]);
    } else {
      logger_
          .trace(context, 'Retrieved from %s with id = %s', [tableName_, id]);
    }

    var resValues = res.toList().isNotEmpty ? res.toList()[0].fields : null;
    var item = convertToPublic_(resValues);

    return item as T?;
  }

  /// Creates a data item.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [item]              an item to be created.
  /// Return  a created item.
  @override
  Future<T?> create(IContext? context, T? item) async {
    if (item == null) {
      return null;
    }

    // Assign unique id
    dynamic newItem = item;
    if (newItem.id == null && autoGenerateId_) {
      newItem = (newItem as ICloneable).clone();
      newItem.id = item.id ?? IdGenerator.nextLong();
    }

    return super.create(context, newItem);
  }

  /// Sets a data item. If the data item exists it updates it,
  /// otherwise it create a new data item.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [item]              a item to be set.
  /// Return the updated item.
  @override
  Future<T?> set(IContext? context, T? item) async {
    if (item == null) {
      return null;
    }

    // Assign unique id
    dynamic newItem = item;
    if (newItem.id == null && autoGenerateId_) {
      newItem = (newItem as ICloneable).clone();
      newItem.id = IdGenerator.nextLong();
    }

    var row = convertFromPublic_(item);
    var columns = generateColumns_(row);
    var params = generateParameters_(row);
    var setParams = generateSetParameters_(row);
    var values = generateValues_(row);
    values.addAll(List.from(values));
    // values.add(item.id);

    var query = 'INSERT INTO ${quotedTableName_()} ($columns) VALUES ($params)';
    query += ' ON DUPLICATE KEY UPDATE $setParams';

    var res = await client_!.query(query, values);

    query = 'SELECT * FROM ${quotedTableName_()} WHERE id=?';
    res = await client_!.query(query, [item.id]);

    var resValues = res.toList().isNotEmpty ? res.toList()[0].fields : null;
    newItem = convertToPublic_(resValues);

    logger_.trace(
        context, 'Set in %s with id = %s', [quotedTableName_(), newItem.id]);

    return newItem;
  }

  /// Updates a data item.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [item]              an item to be updated.
  /// Return the updated item.
  @override
  Future<T?> update(IContext? context, T? item) async {
    if (item == null || item.id == null) {
      return null;
    }

    var row = convertFromPublic_(item);
    var params = generateSetParameters_(row);
    var values = generateValues_(row);
    values.add(item.id);
    //values.add(item.id);

    var query = 'UPDATE ${quotedTableName_()} SET $params WHERE id=?';

    var res = await client_!.query(query, values);

    query = 'SELECT * FROM ${quotedTableName_()} WHERE id=?';
    res = await client_!.query(query, [item.id]);

    var resValues = res.toList().isNotEmpty ? res.toList()[0].fields : null;

    logger_.trace(context, 'Updated in %s with id = %s', [tableName_, item.id]);

    var newItem = convertToPublic_(resValues);
    return newItem as T?;
  }

  /// Updates only few selected fields in a data item.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [id]                an id of data item to be updated.
  /// - [data]              a map with fields to be updated.
  /// Return the updated item.
  Future<T?> updatePartially(
      IContext? context, K? id, AnyValueMap? data) async {
    if (data == null || id == null) {
      return null;
    }

    var row = convertFromPublic_(data.getAsObject());
    var params = generateSetParameters_(row);
    var values = generateValues_(row);
    values.add(id);
    // values.add(id);

    var query = 'UPDATE ${quotedTableName_()} SET $params WHERE id=?';

    var res = await client_!.query(query, values);

    query = 'SELECT * FROM ${quotedTableName_()} WHERE id=?';
    res = await client_!.query(query, [id]);

    var resValues = res.toList().isNotEmpty ? res.toList()[0].fields : null;

    logger_.trace(
        context, 'Updated partially in %s with id = %s', [tableName_, id]);

    var newItem = convertToPublic_(resValues);
    return newItem as T?;
  }

  /// Deleted a data item by it's unique id.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [id]                an id of the item to be deleted
  /// Return the deleted item.
  @override
  Future<T?> deleteById(IContext? context, K? id) async {
    var values = [id];

    var query = 'SELECT * FROM ${quotedTableName_()} WHERE id=?';
    var res = await client_!.query(query, values);

    var resValues = res.toList().isNotEmpty ? res.toList()[0].fields : null;

    query = 'DELETE FROM ${quotedTableName_()} WHERE id=?';
    res = await client_!.query(query, [id]);

    logger_.trace(context, 'Deleted from %s with id = %s', [tableName_, id]);

    var newItem = convertToPublic_(resValues);
    return newItem;
  }

  /// Deletes multiple data items by their unique ids.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [ids]               ids of data items to be deleted.
  Future<void> deleteByIds(IContext? context, List<K> ids) async {
    var params = generateParameters_(ids);
    var query = 'DELETE FROM ${quotedTableName_()} WHERE id IN($params)';

    var res = await client_!.query(query, ids);

    var count = res.affectedRows;

    logger_.trace(context, 'Deleted %d items from %s', [count, tableName_]);
  }
}
