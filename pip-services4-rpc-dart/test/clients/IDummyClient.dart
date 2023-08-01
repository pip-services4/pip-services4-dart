import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

import '../sample/Dummy.dart';

abstract class IDummyClient {
  Future<DataPage<Dummy>?> getDummies(
      IContext? context, FilterParams? filter, PagingParams? paging);
  Future<Dummy?> getDummyById(IContext? context, String dummyId);
  Future<Dummy?> createDummy(IContext? context, Dummy dummy);
  Future<Dummy?> updateDummy(IContext? context, Dummy dummy);
  Future<Dummy?> deleteDummy(IContext? context, String dummyId);
  Future<String?> checkTraceId(IContext? context);
}
