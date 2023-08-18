// ignore_for_file: unnecessary_overrides

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_http/pip_services4_http.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../data/Dummy.dart';
import '../data/DummySchema.dart';
import '../services/IDummyService.dart';

class DummyRestController extends RestController {
  late IDummyService service;

  DummyRestController() : super() {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
  }

  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    service = dependencyResolver.getOneRequired('service');
  }

  @override
  void configure(ConfigParams config) {
    super.configure(config);
  }

  FutureOr<Response> _getPageByFilter(Request req) async {
    var result = await service.getPageByFilter(
        Context.fromTraceId(getTraceId(req) ?? ''),
        FilterParams(req.url.queryParameters),
        PagingParams(req.url.queryParameters));

    return await sendResult(req, result);
  }

  FutureOr<Response> _getOneById(Request req) async {
    var result = await service.getOneById(
        Context.fromTraceId(getTraceId(req) ?? ''), req.params['dummy_id']!);
    return await sendResult(req, result);
  }

  FutureOr<Response> _create(Request req) async {
    var dummy = Dummy.fromJson(json.decode(await req.readAsString()));
    var result =
        await service.create(Context.fromTraceId(getTraceId(req) ?? ''), dummy);
    return await sendCreatedResult(req, result);
  }

  FutureOr<Response> _update(Request req) async {
    var dummy = Dummy.fromJson(json.decode(await req.readAsString()));
    var result =
        await service.update(Context.fromTraceId(getTraceId(req) ?? ''), dummy);
    return await sendResult(req, result);
  }

  FutureOr<Response> _deleteById(Request req) async {
    var result = await service.deleteById(
        Context.fromTraceId(getTraceId(req) ?? ''), req.params['dummy_id']!);
    return await sendDeletedResult(req, result);
  }

  FutureOr<Response> _checkTraceId(Request req) async {
    try {
      var result = await service
          .checkTraceId(Context.fromTraceId(getTraceId(req) ?? ''));
      return await sendResult(req, {'trace_id': result});
    } catch (ex) {
      return await sendError(req, ex);
    }
  }

  @override
  void register() {
    registerRoute(
        'get',
        '/dummies',
        ObjectSchema(true)
            .withOptionalProperty('skip', TypeCode.String)
            .withOptionalProperty('take', TypeCode.String)
            .withOptionalProperty('total', TypeCode.String)
            .withOptionalProperty('body', FilterParamsSchema()),
        _getPageByFilter);

    registerRoute(
        'get', '/dummies/check/trace_id', ObjectSchema(true), _checkTraceId);

    registerRoute(
        'get',
        '/dummy/<dummy_id>',
        ObjectSchema(true).withRequiredProperty('dummy_id', TypeCode.String),
        _getOneById);

    registerRoute(
        'post',
        '/dummies',
        ObjectSchema(true).withRequiredProperty('body', DummySchema()),
        _create);

    registerRoute(
        'put',
        '/dummy/<dummy_id>',
        ObjectSchema(true).withRequiredProperty('body', DummySchema()),
        _update);

    registerRoute(
        'delete',
        '/dummy/<dummy_id>',
        ObjectSchema(true).withRequiredProperty('dummy_id', TypeCode.String),
        _deleteById);

    swaggerRoute = '/dummies/swagger';

    registerOpenApiSpecFromFile(
        '${Directory.current.path}/example/controllers/dummy.yml');
  }
}
