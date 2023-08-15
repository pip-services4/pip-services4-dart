import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_postgres/src/persistence/persistence.dart';

import '../fixtures/Dummy.dart';
import '../fixtures/IDummyPersistence.dart';

class DummyJsonPostgresPersistence
    extends IdentifiableJsonPostgresPersistence<Dummy, String>
    implements IDummyPersistence {
  DummyJsonPostgresPersistence() : super('dummies_json', null);

  @override
  void defineSchema_() {
    clearSchema();
    ensureTable_();
    ensureIndex_(
        '${tableName_!}_json_key', {"(data->>'key')": 1}, {'unique': true});
  }

  @override
  Future<int> getCountByFilter(IContext? context, FilterParams? filter) async {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    dynamic filterCondition;
    if (key != null) {
      filterCondition += "${"data->>'key'='$key"}'";
    }

    return await super.getCountByFilter_(context, filterCondition);
  }

  @override
  Future<DataPage<Dummy>> getPageByFilter(
      IContext? context, FilterParams? filter, PagingParams? paging) async {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    dynamic filterCondition;
    if (key != null) {
      filterCondition += "${"data->>'key'='$key"}'";
    }

    return await super
        .getPageByFilter_(context, filterCondition, paging, null, null);
  }
}
