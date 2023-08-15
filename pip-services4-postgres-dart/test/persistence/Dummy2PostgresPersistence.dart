import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_postgres/src/persistence/persistence.dart';

import '../fixtures/Dummy2.dart';
import '../fixtures/IDummy2Persistence.dart';

class Dummy2PostgresPersistence
    extends IdentifiablePostgresPersistence<Dummy2, int>
    implements IDummy2Persistence {
  Dummy2PostgresPersistence() : super('dummies2', null) {
    autoGenerateId_ = false;
  }

  @override
  void defineSchema_() {
    clearSchema();
    ensureSchema_(
        'CREATE TABLE ${tableName_!} (id INTEGER PRIMARY KEY, key TEXT, content TEXT)');
    ensureIndex_('${tableName_!}_key', {'key': 1}, {'unique': true});
  }

  @override
  Future<DataPage<Dummy2>> getPageByFilter(
      IContext? context, FilterParams? filter, PagingParams? paging) async {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    dynamic filterCondition;
    if (key != null) {
      filterCondition += "${"`key`='$key"}'";
    }

    return super.getPageByFilter_(context, filterCondition, paging, null, null);
  }

  @override
  Future<int> getCountByFilter(IContext? context, FilterParams? filter) {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    dynamic filterCondition;
    if (key != null) {
      filterCondition += "${"`key`='$key"}'";
    }

    return super.getCountByFilter_(context, filterCondition);
  }
}
