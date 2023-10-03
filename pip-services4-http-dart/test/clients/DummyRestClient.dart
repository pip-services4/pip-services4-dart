import 'dart:async';
import 'dart:convert';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_http/src/clients/clients.dart';

import './IDummyClient.dart';
import '../sample/Dummy.dart';

class DummyRestClient extends RestClient implements IDummyClient {
  @override
  Future<DataPage<Dummy>?> getDummies(
      IContext? context, FilterParams? filter, PagingParams? paging) async {
    var params = <String, String>{};
    addFilterParams(params, filter);
    addPagingParams(params, paging);

    var timing = instrument(context, 'dummy.get_page_by_filter');
    try {
      var result = await call('get', '/dummies', context, params);
      if (result == null) return null;
      timing.endTiming();
      return DataPage<Dummy>.fromJson(
          json.decode(result), (item) => Dummy.fromJson(item));
    } catch (ex) {
      timing.endFailure(ex as Exception);
    }
    return null;
  }

  @override
  Future<Dummy?> getDummyById(IContext? context, String dummyId) async {
    var timing = instrument(context, 'dummy.get_one_by_id');

    try {
      var result = await call('get', '/dummies/$dummyId', context, {}, null);
      if (result == null) return null;
      timing.endTiming();
      return Dummy.fromJson(json.decode(result));
    } catch (ex) {
      timing.endFailure(ex as Exception);
    }
    return null;
  }

  @override
  Future<Dummy?> createDummy(IContext? context, Dummy dummy) async {
    var timing = instrument(context, 'dummy.create');
    try {
      var result = await call('post', '/dummies', context, {}, dummy);
      if (result == null) return null;
      timing.endTiming();
      return Dummy.fromJson(json.decode(result));
    } catch (ex) {
      timing.endFailure(ex as Exception);
    }
    return null;
  }

  @override
  Future<Dummy?> updateDummy(IContext? context, Dummy dummy) async {
    var timing = instrument(context, 'dummy.update');
    try {
      var result = await call('put', '/dummies', context, {}, dummy);
      if (result == null) return null;
      timing.endTiming();
      return Dummy.fromJson(json.decode(result));
    } catch (ex) {
      timing.endFailure(ex as Exception);
    }
    return null;
  }

  @override
  Future<Dummy?> deleteDummy(IContext? context, String dummyId) async {
    var timing = instrument(context, 'dummy.delete_by_id');
    try {
      var result = await call('delete', '/dummies/$dummyId', context, {});
      if (result == null) return null;
      timing.endTiming();
      return Dummy.fromJson(json.decode(result));
    } catch (ex) {
      timing.endFailure(ex as Exception);
    }
    return null;
  }

  @override
  Future<String?> checkTraceId(IContext? context) async {
    var timing = instrument(context, 'dummy.check_trace_id');
    try {
      var result = await call('get', '/dummies/check/trace_id', context, {});
      timing.endTiming();
      return result != null ? json.decode(result)['trace_id'] : null;
    } catch (ex) {
      timing.endFailure(ex as Exception);
    }
    return null;
  }
}
