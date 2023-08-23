import 'dart:async';
import 'dart:convert';

import 'package:pip_services4_aws/pip_services4_aws.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

import './Dummy.dart';
import './IDummyClient.dart';

class DummyCommandableLambdaClient extends CommandableLambdaClient
    implements IDummyClient {
  DummyCommandableLambdaClient() : super('dummy');

  @override
  Future<DataPage<Dummy>?> getDummies(
      IContext? context, FilterParams? filter, PagingParams? paging) async {
    var result = await call('get_dummies', context,
        {'filter': filter?.toJson(), 'paging': paging?.toJson()});
    if (result == null) {
      return null;
    }
    return DataPage<Dummy>.fromJson(json.decode(result), (item) {
      return Dummy.fromJson(item);
    });
  }

  @override
  Future<Dummy?> getDummyById(IContext? context, String dummyId) async {
    var result = await call('get_dummy_by_id', context, {'dummy_id': dummyId});
    if (result == null) {
      return null;
    }
    return Dummy.fromJson(json.decode(result));
  }

  @override
  Future<Dummy?> createDummy(IContext? context, Dummy dummy) async {
    var result = await call('create_dummy', context, {dummy: dummy.toJson()});
    if (result == null) {
      return null;
    }
    return Dummy.fromJson(json.decode(result));
  }

  @override
  Future<Dummy?> updateDummy(IContext? context, Dummy dummy) async {
    var result = await call('update_dummy', context, {'dummy': dummy.toJson()});
    if (result == null) {
      return null;
    }
    return Dummy.fromJson(json.decode(result));
  }

  @override
  Future<Dummy?> deleteDummy(IContext? context, String dummyId) async {
    var result = await call('delete_dummy', context, {'dummy_id': dummyId});
    if (result == null) {
      return null;
    }
    return Dummy.fromJson(json.decode(result));
  }
}
