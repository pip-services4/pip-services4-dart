import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_persistence/pip_services4_persistence.dart';

import 'Dummy2.dart';

abstract class IDummy2Persistence
    implements
        IGetter<Dummy2, int>,
        IWriter<Dummy2, int>,
        IPartialUpdater<Dummy2, int> {
  Future<DataPage<Dummy2>> getPageByFilter(
      IContext? context, FilterParams? filter, PagingParams? paging);

  Future<int> getCountByFilter(IContext? context, FilterParams? filter);

  Future<List<Dummy2>> getListByIds(IContext? context, List<int> ids);

  @override
  Future<Dummy2?> getOneById(IContext? context, int id);

  @override
  Future<Dummy2?> create(IContext? context, Dummy2? item);

  @override
  Future<Dummy2?> update(IContext? context, Dummy2? item);

  Future<Dummy2?> set(IContext? context, Dummy2? item);

  @override
  Future<Dummy2?> updatePartially(IContext? context, int id, AnyValueMap data);

  @override
  Future<Dummy2?> deleteById(IContext? context, int? id);

  Future<void> deleteByIds(IContext? context, List<int> id);
}
