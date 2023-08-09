import 'dart:async';
import 'dart:convert';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_http/pip_services4_http.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../sample/Dummy.dart';
import '../sample/DummySchema.dart';
import '../sample/IDummyService.dart';

class DummyRestController extends RestController {
  IDummyService? _service;
  int _numberOfCalls = 0;
  String? _swaggerContent;
  String? _swaggerPath;

  DummyRestController() : super() {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
  }

  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    _service = dependencyResolver.getOneRequired('service');
  }

  @override
  void configure(ConfigParams config) {
    super.configure(config);

    _swaggerContent = config.getAsNullableString('swagger.content');
    _swaggerPath = config.getAsNullableString('swagger.path');
  }

  int getNumberOfCalls() {
    return _numberOfCalls;
  }

  void _incrementNumberOfCalls(Request req) async {
    _numberOfCalls++;
  }

  FutureOr<Response> _getPageByFilter(Request req) async {
    var result = await _service?.getPageByFilter(
        Context.fromTraceId(getTraceId(req) ?? ''),
        FilterParams(req.url.queryParameters),
        PagingParams(req.url.queryParameters));

    return await sendResult(req, result);
  }

  FutureOr<Response> _getOneById(Request req) async {
    var result = await _service?.getOneById(
        Context.fromTraceId(getTraceId(req) ?? ''), req.params['dummy_id']!);
    return await sendResult(req, result);
  }

  FutureOr<Response> _create(Request req) async {
    var dummy = Dummy.fromJson(json.decode(await req.readAsString()));
    var result = await _service?.create(
        Context.fromTraceId(getTraceId(req) ?? ''), dummy);
    return await sendCreatedResult(req, result);
  }

  FutureOr<Response> _update(Request req) async {
    var dummy = Dummy.fromJson(json.decode(await req.readAsString()));
    var result = await _service?.update(
        Context.fromTraceId(getTraceId(req) ?? ''), dummy);
    return await sendResult(req, result);
  }

  FutureOr<Response> _deleteById(Request req) async {
    var result = await _service?.deleteById(
        Context.fromTraceId(getTraceId(req) ?? ''), req.params['dummy_id']!);
    return await sendDeletedResult(req, result);
  }

  FutureOr<Response> _checkTraceId(Request req) async {
    try {
      var result = await _service
          ?.checkTraceId(Context.fromTraceId(getTraceId(req) ?? ''));
      return await sendResult(req, {'trace_id': result});
    } catch (ex) {
      return await sendError(req, ex);
    }
  }

  @override
  void register() {
    registerInterceptor(r'/dummies$', _incrementNumberOfCalls);

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
        '/dummies/<dummy_id>',
        ObjectSchema(true).withRequiredProperty('dummy_id', TypeCode.String),
        _getOneById);

    registerRoute(
        'post',
        '/dummies',
        ObjectSchema(true).withRequiredProperty('body', DummySchema()),
        _create);

    registerRoute(
        'put',
        '/dummies',
        ObjectSchema(true).withRequiredProperty('body', DummySchema()),
        _update);

    registerRoute(
        'delete',
        '/dummies/<dummy_id>',
        ObjectSchema(true).withRequiredProperty('dummy_id', TypeCode.String),
        _deleteById);

    if (_swaggerContent != null) registerOpenApiSpec_(_swaggerContent!);
    if (_swaggerPath != null) registerOpenApiSpecFromFile(_swaggerPath!);
  }
}
