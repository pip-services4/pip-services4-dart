import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_postgres/src/persistence/persistence.dart';

import '../fixtures/Dummy.dart';
import '../fixtures/IDummyPersistence.dart';

class DummyPostgresPersistence
    extends IdentifiablePostgresPersistence<Dummy, String>
    implements IDummyPersistence {
  DummyPostgresPersistence() : super('dummies', null);

  @override
  void defineSchema_() {
    clearSchema();
    ensureSchema_(
        'CREATE TABLE ${tableName_!} (id TEXT PRIMARY KEY, key TEXT, content TEXT)');
    ensureIndex_('${tableName_!}_key', {'key': 1}, {'unique': true});
  }

  @override
  Future<DataPage<Dummy>> getPageByFilter(
      IContext? context, FilterParams? filter, PagingParams? paging) {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    var filterCondition = "";
    if (key != null) filterCondition += "${"key='$key"}'";

    return super.getPageByFilter_(context, filterCondition, paging, null, null);
  }

  @override
  Future<int> getCountByFilter(IContext? context, FilterParams? filter) {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    var filterCondition = "";
    if (key != null) filterCondition += "${"key='$key"}'";

    return super.getCountByFilter_(context, filterCondition);
  }
}
