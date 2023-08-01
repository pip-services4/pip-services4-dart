import 'dart:async';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_persistence/src/read/read.dart';
import 'package:pip_services4_persistence/src/write/write.dart';
import './Dummy.dart';

abstract class IDummyPersistence
    implements
        IGetter<Dummy, String>,
        IWriter<Dummy, String>,
        IPartialUpdater<Dummy, String> {
  Future<DataPage<Dummy>> getPageByFilter(
      IContext? context, FilterParams? filter, PagingParams? paging);
  Future<List<Dummy>> getListByIds(IContext? context, List<String> ids);
  @override
  Future<Dummy?> getOneById(IContext? context, String id);
  @override
  Future<Dummy?> create(IContext? context, Dummy? item);
  @override
  Future<Dummy?> update(IContext? context, Dummy? item);
  @override
  Future<Dummy?> updatePartially(
      IContext? context, String id, AnyValueMap data);
  @override
  Future<Dummy?> deleteById(IContext? context, String? id);
  Future deleteByIds(IContext? context, List<String> id);
  Future<int> getCountByFilter(IContext? context, FilterParams? filter);

  Future<DataPage<Dummy>> getSortedPage(IContext? context, Function sort);
  Future<List<Dummy>> getSortedList(IContext? context, Function sort);
}
