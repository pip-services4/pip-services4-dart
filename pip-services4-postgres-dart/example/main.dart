import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_postgres/pip_services4_postgres.dart';

void main(List<String> args) async {
  var dbConfig = ConfigParams.fromTuples([
    'connection.uri',
    null,
    'connection.host',
    'localhost',
    'connection.port',
    5432,
    'connection.database',
    'mytestobjects',
    'credential.username',
    'postgres',
    'credential.password',
    'postgres'
  ]);

  // create two type of persistence
  var persistences = [MyPostgresPersistence(), MyPostgresJsonPersistence()];

  // make operations with persistences
  for (var persistence in persistences) {
    persistence.configure(dbConfig);

    await persistence.open(null);
    await persistence.clear(null);

    await makePersistenceOperations(persistence);

    await persistence.close(null);
  }
}

class MyObject implements IStringIdentifiable, ICloneable {
  @override
  String? id;
  String? key;
  String? content;

  MyObject();

  MyObject.from(this.id, this.key, this.content);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'key': key, 'content': content};
  }

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    content = json['content'];
  }

  @override
  MyObject clone() {
    return MyObject.from(id, key, content);
  }
}

abstract class IMyPersistence {
  Future<DataPage<MyObject>> getPageByFilter(
      IContext? context, FilterParams? filter, PagingParams? paging);

  Future<MyObject?> getOneById(IContext? context, String id);

  Future<MyObject?> getOneByKey(IContext? context, String key);

  Future<MyObject?> create(IContext? context, MyObject? item);

  Future<MyObject?> update(IContext? context, MyObject? item);

  Future<MyObject?> set(IContext? context, MyObject? item);

  Future<MyObject?> deleteById(IContext? context, String? id);
}

class MyPostgresPersistence
    extends IdentifiablePostgresPersistence<MyObject, String> {
  MyPostgresPersistence() : super('myobjects', null) {
    ensureSchema_(
        "CREATE TABLE myobjects (id VARCHAR(32) PRIMARY KEY, key VARCHAR(50), content VARCHAR(255))");
    ensureIndex_("myobjects_key", {'key': 1}, {'unique': true});
  }

  @override
  void defineSchema_() {
    // pass
  }

  String? _composeFilter(FilterParams? filter) {
    filter = filter ?? FilterParams();

    var criteria = [];

    var id = filter.getAsNullableString('id');
    if (id != null) criteria.add("id='$id'");

    var tempIds = filter.getAsNullableString("ids");
    if (tempIds != null) {
      var ids = tempIds.split(",");
      criteria.add("id IN ('${ids.join("','")}')");
    }

    var key = filter.getAsNullableString("key");
    if (key != null) criteria.add("key='$key'");

    return criteria.isNotEmpty ? criteria.join(" AND ") : null;
  }

  Future<DataPage<MyObject>> getPageByFilter(
      IContext? context, FilterParams? filter, PagingParams? paging) {
    return super
        .getPageByFilter_(context, _composeFilter(filter), paging, null, null);
  }

  Future<MyObject?> getOneByKey(IContext? context, String key) async {
    var query = "SELECT * FROM ${quotedTableName_()} WHERE \"key\"=@1";
    var params = {'1': key};

    var res = await client_!.query(query, substitutionValues: params);

    var resValues = res.isNotEmpty ? res.first[0][1] : null;

    var item = convertToPublic_(resValues);

    if (item == null) {
      logger_.trace(
          context, "Nothing found from %s with key = %s", [tableName_, key]);
    } else {
      logger_
          .trace(context, "Retrieved from %s with key = %s", [tableName_, key]);
    }

    item = convertToPublic_(item);
    return item;
  }
}

class MyPostgresJsonPersistence
    extends IdentifiableJsonPostgresPersistence<MyObject, String> {
  MyPostgresJsonPersistence() : super('myobjects_json', null) {
    clearSchema();
    ensureTable_(idType: "VARCHAR(32)", dataType: "JSONB");
    ensureIndex_(
        '${tableName_!}_json_key', {"(data->>'key')": 1}, {'unique': true});
  }

  @override
  void defineSchema_() {
    // pass
  }

  String? _composeFilter(FilterParams? filter) {
    filter = filter ?? FilterParams();

    var criteria = [];

    var id = filter.getAsNullableString('id');
    if (id != null) criteria.add("data->>'id'='$id'");

    var tempIds = filter.getAsNullableString("ids");
    if (tempIds != null) {
      var ids = tempIds.split(",");
      criteria.add("data->>'id' IN ('${ids.join("','")}')");
    }

    var key = filter.getAsNullableString("key");
    if (key != null) criteria.add("data->>'key'='$key'");

    return criteria.isNotEmpty ? criteria.join(" AND ") : null;
  }

  Future<DataPage<MyObject>> getPageByFilter(
      IContext? context, FilterParams? filter, PagingParams? paging) {
    return super
        .getPageByFilter_(context, _composeFilter(filter), paging, 'id', null);
  }

  Future<MyObject?> getOneByKey(IContext? context, String key) async {
    var query = "SELECT * FROM ${quotedTableName_()} WHERE data->>'key'=@1";
    var params = {'1': key};

    var res = await client_!.query(query, substitutionValues: params);

    var resValues = res.isNotEmpty ? res.first[0][1] : null;

    var item = convertToPublic_(resValues);

    if (item == null) {
      logger_.trace(
          context, "Nothing found from %s with key = %s", [tableName_, key]);
    } else {
      logger_
          .trace(context, "Retrieved from %s with key = %s", [tableName_, key]);
    }

    item = convertToPublic_(item);
    return item;
  }
}

Future<void> makePersistenceOperations(
    IdentifiablePostgresPersistence persistence) async {
  var myObject1 = MyObject.from('1', 'Key 1', 'Content 1');
  var myObject2 = MyObject.from('2', 'Key 2', 'Content 2');

  // create items
  var item = await persistence.create(null, myObject1);

  assert(myObject1.id == item!.id);

  item = await persistence.create(null, myObject2);

  assert(myObject2.id == item!.id);

  // delete items
  var deleted = await persistence.deleteById(null, myObject1.id);
  assert(myObject1.id == deleted!.id);

  deleted = await persistence.deleteById(null, myObject2.id);
  assert(myObject2.id == deleted!.id);

  // check deleted
  var items = await persistence.getListByFilter_(null, null, null, null);

  assert(items.isEmpty == true);

  print('All operations completed for persistence $persistence');
}
