import 'dart:async';

import 'package:pip_services4_azure/src/controllers/AzureFunctionController.dart';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import './IDummyService.dart';
import './DummySchema.dart';

class DummyAzureFunctionController extends AzureFunctionController {
  late IDummyService _service;
  final _headers = {'Content-Type': 'application/json'};

  DummyAzureFunctionController() : super('dummies') {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
  }

  getBodyData(Map<String, dynamic> context) {
    var params = context;
    if (context.containsKey('body') && context['body'] != null) {
      params.addAll(context['body']);
    }
    return params;
  }

  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    _service = dependencyResolver.getOneRequired<IDummyService>('service');
  }

  Future _getPageByFilter(req) async {
    final page = await _service.getPageByFilter(
        req?['body']?['trace_id'],
        FilterParams(req?['body']?['filter']),
        PagingParams(req?['body']?['paging']));
    return {'body': page, 'headers': _headers};
  }

  Future _getOneById(req) async {
    final params = getBodyData(req);
    final dummy =
        await _service.getOneById(params['trace_id'], params['dummy_id']);
    return {'body': dummy, 'headers': _headers};
  }

  Future _create(req) async {
    final params = getBodyData(req);
    final dummy = await _service.create(params['trace_id'], params['dummy']);
    return {'body': dummy, 'headers': _headers};
  }

  Future _update(req) async {
    final params = getBodyData(req);
    final dummy = await _service.update(params['trace_id'], params['dummy']);
    return {'body': dummy, 'headers': _headers};
  }

  Future _deleteById(req) async {
    final params = getBodyData(req);
    final dummy =
        await _service.deleteById(params['trace_id'], params['dummy_id']);
    return {'body': dummy, 'headers': _headers};
  }

  @override
  void register() {
    registerAction(
        'get_dummies',
        ObjectSchema(true).withOptionalProperty(
            'body',
            ObjectSchema()
                .withOptionalProperty('filter', FilterParamsSchema())
                .withOptionalProperty('paging', PagingParamsSchema())),
        _getPageByFilter);

    registerAction(
        'get_dummy_by_id',
        ObjectSchema(true).withOptionalProperty(
            'body',
            ObjectSchema(true)
                .withOptionalProperty('dummy_id', TypeCode.String)),
        _getOneById);

    registerAction(
        'create_dummy',
        ObjectSchema(true).withOptionalProperty('body',
            ObjectSchema(true).withRequiredProperty('dummy', DummySchema())),
        _create);

    registerAction(
        'update_dummy',
        ObjectSchema(true).withOptionalProperty('body',
            ObjectSchema(true).withRequiredProperty('dummy', DummySchema())),
        _update);

    registerAction(
        'delete_dummy',
        ObjectSchema(true).withOptionalProperty(
            'body',
            ObjectSchema(true)
                .withOptionalProperty('dummy_id', TypeCode.String)),
        _deleteById);
  }
}
