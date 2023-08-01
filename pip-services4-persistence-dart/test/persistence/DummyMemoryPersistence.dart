import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_persistence/pip_services4_persistence.dart';
import '../Dummy.dart';
import '../IDummyPersistence.dart';

class DummyMemoryPersistence
    extends IdentifiableMemoryPersistence<Dummy, String>
    implements IDummyPersistence {
  DummyMemoryPersistence() : super();

  @override
  Future<DataPage<Dummy>> getPageByFilter(
      IContext? context, FilterParams? filter, PagingParams? paging) {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    return super.getPageByFilterEx(context, (Dummy item) {
      if (key != null && item.key != key) {
        return false;
      }
      return true;
    }, paging, null);
  }

  @override
  Future<int> getCountByFilter(IContext? context, FilterParams? filter) async {
    filter = filter ?? FilterParams();
    var key = filter.getAsNullableString('key');

    return super.getCountByFilterEx(context, (Dummy item) {
      if (key != null && item.key != key) {
        return false;
      }
      return true;
    });
  }

  @override
  Future<DataPage<Dummy>> getSortedPage(
      IContext? context, Function sort) async {
    return await super.getPageByFilterEx(context, null, null, sort, null);
  }

  @override
  Future<List<Dummy>> getSortedList(IContext? context, Function sort) async {
    return await super.getListByFilterEx(context, null, sort, null);
  }
}
