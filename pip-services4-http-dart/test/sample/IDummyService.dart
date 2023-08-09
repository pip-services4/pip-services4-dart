import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

import './Dummy.dart';

abstract class IDummyService {
  Future<DataPage<Dummy>> getPageByFilter(
      IContext? context, FilterParams? filter, PagingParams? paging);
  Future<Dummy?> getOneById(IContext? context, String id);
  Future<Dummy?> create(IContext? context, Dummy entity);
  Future<Dummy?> update(IContext? context, Dummy entity);
  Future<Dummy?> deleteById(IContext? context, String id);
  Future<String?> checkTraceId(IContext? context);
}
