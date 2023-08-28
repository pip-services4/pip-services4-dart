import 'dart:async';

import 'package:pip_services4_aws/src/controllers/LambdaController.dart';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import '../IDummyService.dart';
import '../DummySchema.dart';
import '../Dummy.dart';

class DummyLambdaController extends LambdaController {
  late IDummyService _service;

  DummyLambdaController() : super('dummies') {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
  }

  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    _service = dependencyResolver.getOneRequired<IDummyService>('service');
  }

  Future _getPageByFilter(params) async {
    return await _service.getPageByFilter(params['trace_id'],
        FilterParams(params['filter']), PagingParams(params['paging']));
  }

  Future _getOneById(params) async {
    return await _service.getOneById(params['trace_id'], params['dummy_id']);
  }

  Future _create(params) async {
    return await _service.create(
        params['trace_id'], Dummy.fromJson(params['dummy']));
  }

  Future _update(params) async {
    return await _service.update(
        params['trace_id'], Dummy.fromJson(params['dummy']));
  }

  Future _deleteById(params) async {
    return await _service.deleteById(params['trace_id'], params['dummy_id']);
  }

  @override
  void register() {
    registerAction(
        'get_dummies',
        ObjectSchema(true)
            .withOptionalProperty('filter', FilterParamsSchema())
            .withOptionalProperty('paging', PagingParamsSchema()),
        _getPageByFilter);

    registerAction(
        'get_dummy_by_id',
        ObjectSchema(true).withOptionalProperty('dummy_id', TypeCode.String),
        _getOneById);

    registerAction(
        'create_dummy',
        ObjectSchema(true).withRequiredProperty('dummy', DummySchema()),
        _create);

    registerAction(
        'update_dummy',
        ObjectSchema(true).withRequiredProperty('dummy', DummySchema()),
        _update);

    registerAction(
        'delete_dummy',
        ObjectSchema(true).withOptionalProperty('dummy_id', TypeCode.String),
        _deleteById);
  }
}

//export const handler = DummyLambdaFunction().getHandler();
