import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_grpc/src/clients/CommandableGrpcClient.dart';
import './IDummyClient.dart';
import '../sample/Dummy.dart';

class DummyCommandableGrpcClient extends CommandableGrpcClient
    implements IDummyClient {
  DummyCommandableGrpcClient() : super('dummy');

  @override
  Future<DataPage<Dummy>?> getDummies(
      IContext? context, FilterParams? filter, PagingParams? paging) async {
    var response = await callCommand(
        'get_dummies', context, {'filter': filter, 'paging': paging});
    if (response == null) {
      return null;
    }
    return DataPage<Dummy>.fromJson(response, (item) => Dummy.fromJson(item));
  }

  @override
  Future<Dummy?> getDummyById(IContext? context, String dummyId) async {
    var response =
        await callCommand('get_dummy_by_id', context, {'dummy_id': dummyId});

    if (response == null) {
      return null;
    }
    return Dummy.fromJson(response);
  }

  @override
  Future<Dummy?> createDummy(IContext? context, Dummy dummy) async {
    var response = await callCommand('create_dummy', context, {'dummy': dummy});
    if (response == null) {
      return null;
    }
    return Dummy.fromJson(response);
  }

  @override
  Future<Dummy?> updateDummy(IContext? context, Dummy dummy) async {
    var response = await callCommand('update_dummy', context, {'dummy': dummy});
    if (response == null) {
      return null;
    }
    return Dummy.fromJson(response);
  }

  @override
  Future<Dummy?> deleteDummy(IContext? context, String dummyId) async {
    var response =
        await callCommand('delete_dummy', context, {'dummy_id': dummyId});
    if (response == null) {
      return null;
    }
    return Dummy.fromJson(response);
  }
}
