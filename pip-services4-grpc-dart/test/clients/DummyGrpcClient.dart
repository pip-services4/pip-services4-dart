import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

import '../generated/dummies.pbgrpc.dart' as messages;

import 'package:pip_services4_grpc/src/clients/GrpcClient.dart';
import './IDummyClient.dart';
import '../sample/Dummy.dart';

class DummyGrpcClient extends GrpcClient implements IDummyClient {
  DummyGrpcClient() : super('dummies.Dummies');

  @override
  Future<DataPage<Dummy>?> getDummies(
      IContext? context, FilterParams? filter, PagingParams? paging) async {
    var request = messages.DummiesPageRequest();
    request.traceId = ContextResolver.getTraceId(context);
    if (filter != null) {
      for (var element in filter.entries) {
        request.filter.addAll({element.key: element.value ?? ''});
      }
    }
    if (paging != null) {
      var params = messages.PagingParams();
      params.total = paging.total;
      params.skip += paging.skip ?? 0;
      params.take = paging.take ?? 0;
      request.paging = params;
    }

    instrument(context, 'dummy.get_page_by_filter');

    var response =
        await call<messages.DummiesPageRequest, messages.DummiesPage>(
            'get_dummies', context, request);
    var items = <Dummy>[];
    for (var item in response.data) {
      items.add(Dummy.fromGrpcJson(item.writeToJsonMap()));
    }
    return DataPage(items, response.total.toInt());
  }

  @override
  Future<Dummy?> getDummyById(IContext? context, String dummyId) async {
    var request = messages.DummyIdRequest();
    request.dummyId = dummyId;

    instrument(context, 'dummy.get_one_by_id');

    var response = await call<messages.DummyIdRequest, messages.Dummy>(
        'get_dummy_by_id', context, request);

    var result = Dummy.fromGrpcJson(response.writeToJsonMap());
    if ((result.id == null) && result.key == null) {
      return null;
    }
    return result;
  }

  @override
  Future<Dummy?> createDummy(IContext? context, Dummy dummy) async {
    var request = messages.DummyObjectRequest();
    request.traceId = ContextResolver.getTraceId(context);
    var item = messages.Dummy();
    item.mergeFromJsonMap(dummy.toGrpcJson());
    request.dummy = item;

    instrument(context, 'dummy.create');

    var response = await call<messages.DummyObjectRequest, messages.Dummy>(
        'create_dummy', context, request);

    var result = Dummy.fromGrpcJson(response.writeToJsonMap());
    if ((result.id == null) && result.key == null) {
      return null;
    }
    return result;
  }

  @override
  Future<Dummy?> updateDummy(IContext? context, Dummy dummy) async {
    var request = messages.DummyObjectRequest();
    request.traceId = ContextResolver.getTraceId(context);
    var item = messages.Dummy();
    item.mergeFromJsonMap(dummy.toGrpcJson());
    request.dummy = item;

    instrument(context, 'dummy.update');

    var response = await call<messages.DummyObjectRequest, messages.Dummy>(
        'update_dummy', context, request);

    var result = Dummy.fromGrpcJson(response.writeToJsonMap());
    if ((result.id == null) && result.key == null) {
      return null;
    }
    return result;
  }

  @override
  Future<Dummy?> deleteDummy(IContext? context, String dummyId) async {
    var request = messages.DummyIdRequest();
    request.dummyId = dummyId;

    instrument(context, 'dummy.delete_by_id');

    var response = await call<messages.DummyIdRequest, messages.Dummy>(
        'delete_dummy_by_id', context, request);

    var result = Dummy.fromGrpcJson(response.writeToJsonMap());
    if ((result.id == null) && result.key == null) {
      return null;
    }
    return result;
  }
}
