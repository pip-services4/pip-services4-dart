import 'dart:async';

import 'package:pip_services4_commons/pip_services4_commons.dart';

import 'package:pip_services4_azure/pip_services4_azure.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import '../IDummyService.dart';
import '../DummyFactory.dart';
import '../DummySchema.dart';

class DummyAzureFunction extends AzureFunction {
  late IDummyService _service;

  DummyAzureFunction() : super('dummy', 'Dummy Azure Function') {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
    factories.add(DummyFactory());
  }

  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    _service = dependencyResolver.getOneRequired<IDummyService>('service');
  }

  Future _getPageByFilter(req) async {
    return await _service.getPageByFilter(
        req?['body']?['trace_id'],
        FilterParams(req?['body']?['filter']),
        PagingParams(req?['body']?['paging']));
  }

  Future _getOneById(req) async {
    return await _service.getOneById(
        req?['body']?['trace_id'], req?['body']?['dummy_id']);
  }

  Future _create(req) async {
    return await _service.create(
        req?['body']?['trace_id'], req?['body']?['dummy']);
  }

  Future _update(req) async {
    return await _service.update(
        req?['body']?['trace_id'], req?['body']?['dummy']);
  }

  Future _deleteById(req) async {
    return await _service.deleteById(
        req?['body']?['trace_id'], req?['body']?['dummy_id']);
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
