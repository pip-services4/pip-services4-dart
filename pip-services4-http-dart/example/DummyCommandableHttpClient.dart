import 'dart:async';
import 'dart:convert';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_http/src/clients/clients.dart';

import './IDummyClient.dart';
import 'Dummy.dart';

class DummyCommandableHttpClient extends CommandableHttpClient
    implements IDummyClient {
  DummyCommandableHttpClient() : super('dummy');

  @override
  Future<DataPage<Dummy>?> getDummies(
      IContext? context, FilterParams? filter, PagingParams? paging) async {
    var result = await callCommand(
        'get_dummies', context, {'filter': filter, 'paging': paging});
    return DataPage<Dummy>.fromJson(
        json.decode(result), (item) => Dummy.fromJson(item));
  }

  @override
  Future<Dummy?> getDummyById(IContext? context, String dummyId) async {
    var result =
        await callCommand('get_dummy_by_id', context, {'dummy_id': dummyId});
    if (result == null) return null;
    return Dummy.fromJson(json.decode(result));
  }

  @override
  Future<Dummy?> createDummy(IContext? context, Dummy dummy) async {
    var result = await callCommand('create_dummy', context, {'dummy': dummy});
    if (result == null) return null;
    return Dummy.fromJson(json.decode(result));
  }

  @override
  Future<Dummy?> updateDummy(IContext? context, Dummy dummy) async {
    var result = await callCommand('update_dummy', context, {'dummy': dummy});
    if (result == null) return null;
    return Dummy.fromJson(json.decode(result));
  }

  @override
  Future<Dummy?> deleteDummy(IContext? context, String dummyId) async {
    var result =
        await callCommand('delete_dummy', context, {'dummy_id': dummyId});
    if (result == null) return null;
    return Dummy.fromJson(json.decode(result));
  }

  @override
  Future<String?> checkTraceId(IContext? context) async {
    var result = await callCommand('check_trace_id', context, null);
    return result != null ? json.decode(result)['trace_id'] : null;
  }
}
