import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_mongodb/pip_services4_mongodb.dart';
import '../fixtures/Dummy.dart';
import '../fixtures/IDummyPersistence.dart';

class DummyMongoDbPersistence
    extends IdentifiableMongoDbPersistence<Dummy, String>
    implements IDummyPersistence {
  DummyMongoDbPersistence() : super('dummies') {
    ensureIndex({'key': 1}, unique: true);
  }

  @override
  Future<DataPage<Dummy>> getPageByFilter(
      IContext? context, FilterParams? filter, PagingParams? paging) async {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    var filterCondition = <String, dynamic>{};
    if (key != null) {
      filterCondition['key'] = key;
    }

    return super.getPageByFilterEx(context, filterCondition, paging, null);
  }

  @override
  Future<int> getCountByFilter(IContext? context, FilterParams? filter) async {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    var filterCondition = <String, dynamic>{};
    if (key != null) {
      filterCondition['key'] = key;
    }

    return super.getCountByFilterEx(context, filterCondition);
  }
}
