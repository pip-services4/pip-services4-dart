import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:pip_services4_grpc/pip_services4_grpc.dart';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:protobuf/protobuf.dart';

import '../generated/dummies.pbgrpc.dart' as command;

import '../sample/DummySchema.dart';
import '../sample/Dummy.dart';
import '../sample/IDummyService.dart';

class DummyGrpcController extends command.DummiesServiceBase
    with GrpcController {
  IDummyService? _service;
  int _numberOfCalls = 0;

  DummyGrpcController() {
    serviceName = 'dummies.Dummies.service';
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
  }

  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    _service = dependencyResolver.getOneRequired<IDummyService>('service');
  }

  int getNumberOfCalls() {
    return _numberOfCalls;
  }

  FutureOr<GrpcError?> _incrementNumberOfCalls(
      ServiceCall call, ServiceMethod method) async {
    _numberOfCalls++;
    // return GrpcError.ok();
    return null;
  }

  @override
  void register() {
    registerInterceptor(_incrementNumberOfCalls);
    registerService(this);
  }

  @override
  Future<command.Dummy> create_dummy(
      ServiceCall call, command.DummyObjectRequest request) async {
    var schema =
        ObjectSchema(true).withRequiredProperty('dummy', DummySchema());
    var traceId = request.traceId;
    var err = schema.validateAndReturnException(traceId, request, false);

    if (err != null) {
      throw err;
    }

    var response = command.Dummy();
    var context = Context.fromTraceId(traceId);
    var timing = instrument(context, 'create_dummy.call');
    try {
      var dummy = Dummy.fromGrpcJson(request.dummy.writeToJsonMap());
      var result = await _service!.create(context, dummy);
      if (result != null) {
        response.mergeFromJsonMap(result.toGrpcJson());
      }
      timing.endTiming();
    } catch (ex) {
      var err = ApplicationException().wrap(ex);
      timing.endFailure(err);
    }
    return response;
  }

  @override
  Future<command.Dummy> delete_dummy_by_id(
      ServiceCall call, command.DummyIdRequest request) async {
    var schema =
        ObjectSchema(true).withRequiredProperty('dummyId', TypeCode.String);
    var traceId = request.traceId;
    var err = schema.validateAndReturnException(traceId, request, false);

    if (err != null) {
      throw err;
    }
    var response = command.Dummy();
    var context = Context.fromTraceId(traceId);
    var timing = instrument(context, 'delete_dummy_by_id.call');
    try {
      var result = await _service!.deleteById(context, request.dummyId);
      if (result != null) {
        response.mergeFromJsonMap(result.toGrpcJson());
      }
      timing.endTiming();
    } catch (ex) {
      var err = ApplicationException().wrap(ex);

      timing.endFailure(err);
    }
    return response;
  }

  @override
  Future<command.DummiesPage> get_dummies(
      ServiceCall call, command.DummiesPageRequest request) async {
    //TODO: Fix schema checks for PagingParams
    // var schema = ObjectSchema(true)
    //     .withOptionalProperty('paging', PagingParamsSchema())
    //     .withOptionalProperty('filter', FilterParamsSchema());
    var traceId = request.traceId;
    // var err = schema.validateAndReturnException(context, request, false);

    // if (err != null) {
    //   throw err;
    // }

    var filter = FilterParams.fromValue(request.filter);
    var paging = PagingParams.fromValue(request.paging);
    var response = command.DummiesPage();
    var context = Context.fromTraceId(traceId);

    var timing = instrument(context, 'get_dummies.call');
    try {
      var result = await _service!.getPageByFilter(context, filter, paging);
      var list = PbList<command.Dummy>();
      for (var item in result.data) {
        var cmdDummyItem = command.Dummy();
        cmdDummyItem.mergeFromJsonMap(item.toGrpcJson());
        list.add(cmdDummyItem);
      }
      // Hack for set total value
      response.total += result.total;
      response.data.addAll(list);
      timing.endTiming();
    } catch (ex) {
      var err = ApplicationException().wrap(ex);
      timing.endFailure(err);
    }
    return response;
  }

  @override
  Future<command.Dummy> get_dummy_by_id(
      ServiceCall call, command.DummyIdRequest request) async {
    var schema =
        ObjectSchema(true).withRequiredProperty('dummyId', TypeCode.String);
    var traceId = request.traceId;
    var err = schema.validateAndReturnException(traceId, request, false);

    if (err != null) {
      throw err;
    }

    var response = command.Dummy();
    var context = Context.fromTraceId(traceId);
    var timing = instrument(context, 'get_dummy_by_id.call');
    try {
      var result = await _service!.getOneById(context, request.dummyId);
      if (result != null) {
        response.mergeFromJsonMap(result.toGrpcJson());
      }
      timing.endTiming();
    } catch (ex) {
      var err = ApplicationException().wrap(ex);
      timing.endFailure(err);
    }

    return response;
  }

  @override
  Future<command.Dummy> update_dummy(
      ServiceCall call, command.DummyObjectRequest request) async {
    // 'update_dummy',
    var schema =
        ObjectSchema(true).withRequiredProperty('dummy', DummySchema());
    var traceId = request.traceId;
    var err = schema.validateAndReturnException(traceId, request, false);

    if (err != null) {
      throw err;
    }
    var response = command.Dummy();
    var context = Context.fromTraceId(traceId);
    var timing = instrument(context, 'update_dummy.call');
    try {
      var dummy = Dummy.fromGrpcJson(request.dummy.writeToJsonMap());
      var result = await _service!.update(context, dummy);
      response.mergeFromJsonMap(result!.toGrpcJson());
      timing.endTiming();
    } catch (ex) {
      var err = ApplicationException().wrap(ex);
      timing.endFailure(err);
    }

    return response;
  }
}
