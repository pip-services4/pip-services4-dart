import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_rpc/src/commands/commands.dart';

import './Dummy.dart';
import 'IDummyService.dart';
import './DummySchema.dart';

class DummyCommandSet extends CommandSet {
  final IDummyService _service;

  DummyCommandSet(IDummyService service)
      : _service = service,
        super() {
    addCommand(_makeGetPageByFilterCommand());
    addCommand(_makeGetOneByIdCommand());
    addCommand(_makeCreateCommand());
    addCommand(_makeUpdateCommand());
    addCommand(_makeDeleteByIdCommand());
    addCommand(_makeCheckTraceIdCommand());
  }

  ICommand _makeGetPageByFilterCommand() {
    return Command(
        'get_dummies',
        ObjectSchema(true)
            .withOptionalProperty('filter', FilterParamsSchema())
            .withOptionalProperty('paging', PagingParamsSchema()),
        (IContext? context, Parameters args) async {
      var filter = FilterParams.fromValue(args.get('filter'));
      var paging = PagingParams.fromValue(args.get('paging'));
      return await _service.getPageByFilter(context, filter, paging);
    });
  }

  ICommand _makeGetOneByIdCommand() {
    return Command('get_dummy_by_id',
        ObjectSchema(true).withRequiredProperty('dummy_id', TypeCode.String),
        (IContext? context, Parameters args) async {
      var id = args.getAsString('dummy_id');
      return await _service.getOneById(context, id);
    });
  }

  ICommand _makeCreateCommand() {
    return Command('create_dummy',
        ObjectSchema(true).withRequiredProperty('dummy', DummySchema()),
        (IContext? context, Parameters args) async {
      var entity = Dummy.fromJson(args.get('dummy'));
      return await _service.create(context, entity);
    });
  }

  ICommand _makeUpdateCommand() {
    return Command('update_dummy',
        ObjectSchema(true).withRequiredProperty('dummy', DummySchema()),
        (IContext? context, Parameters args) async {
      var entity = Dummy.fromJson(args.get('dummy'));
      return await _service.update(context, entity);
    });
  }

  ICommand _makeDeleteByIdCommand() {
    return Command('delete_dummy',
        ObjectSchema(true).withRequiredProperty('dummy_id', TypeCode.String),
        (IContext? context, Parameters args) async {
      var id = args.getAsString('dummy_id');
      return await _service.deleteById(context, id);
    });
  }

  ICommand _makeCheckTraceIdCommand() {
    return Command('check_trace_id', ObjectSchema(true),
        (IContext? context, Parameters args) async {
      var value = await _service.checkTraceId(context);
      return {'trace_id': value};
    });
  }
}
