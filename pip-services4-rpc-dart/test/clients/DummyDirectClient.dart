import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_rpc/src/clients/clients.dart';

import '../sample/Dummy.dart';
import '../sample/IDummyService.dart';
import './IDummyClient.dart';

class DummyDirectClient extends DirectClient<IDummyService>
    implements IDummyClient {
  DummyDirectClient() : super() {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', '*', '*', '*'));
  }

  @override
  Future<DataPage<Dummy>?> getDummies(
      IContext? context, FilterParams? filter, PagingParams? paging) async {
    var timing = instrument(context, 'dummy.get_page_by_filter');
    try {
      return await service.getPageByFilter(context, filter, paging);
    } catch (ex) {
      timing.endFailure(ex as Exception);
    } finally {
      timing.endTiming();
    }
    return null;
  }

  @override
  Future<Dummy?> getDummyById(IContext? context, String dummyId) async {
    var timing = instrument(context, 'dummy.get_one_by_id');
    try {
      return await service.getOneById(context, dummyId);
    } catch (ex) {
      timing.endFailure(ex as Exception);
    } finally {
      timing.endTiming();
    }
    return null;
  }

  @override
  Future<Dummy?> createDummy(IContext? context, Dummy dummy) async {
    var timing = instrument(context, 'dummy.create');
    try {
      return await service.create(context, dummy);
    } catch (ex) {
      timing.endFailure(ex as Exception);
    } finally {
      timing.endTiming();
    }
    return null;
  }

  @override
  Future<Dummy?> updateDummy(IContext? context, Dummy dummy) async {
    var timing = instrument(context, 'dummy.update');
    try {
      return await service.update(context, dummy);
    } catch (ex) {
      timing.endFailure(ex as Exception);
    } finally {
      timing.endTiming();
    }
    return null;
  }

  @override
  Future<Dummy?> deleteDummy(IContext? context, String dummyId) async {
    var timing = instrument(context, 'dummy.delete_by_id');
    try {
      return await service.deleteById(context, dummyId);
    } catch (ex) {
      timing.endFailure(ex as Exception);
    } finally {
      timing.endTiming();
    }
    return null;
  }

  @override
  Future<String?> checkTraceId(IContext? context) async {
    var timing = instrument(context, 'dummy.check_trace_id');
    try {
      return await service.checkTraceId(context);
    } catch (ex) {
      timing.endFailure(ex as Exception);
    } finally {
      timing.endTiming();
    }
    return null;
  }
}
