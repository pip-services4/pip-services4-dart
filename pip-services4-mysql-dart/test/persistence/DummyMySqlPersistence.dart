import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_mysql/src/persistence/IdentifiableMySqlPersistence.dart';

import '../fixtures/Dummy.dart';
import '../fixtures/IDummyPersistence.dart';

class DummyMySqlPersistence extends IdentifiableMySqlPersistence<Dummy, String>
    implements IDummyPersistence {
  DummyMySqlPersistence() : super('dummies', null);

  @override
  void defineSchema_() {
    clearSchema();
    ensureSchema_(
        'CREATE TABLE `${tableName_!}` (id VARCHAR(32) PRIMARY KEY, `key` VARCHAR(50), `content` TEXT)');
    ensureIndex_('${tableName_!}_key', {'key': 1}, {'unique': true});
  }

  @override
  Future<DataPage<Dummy>> getPageByFilter(
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
