import 'dart:async';

import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:shelf/shelf.dart';

import './HttpResponseSender.dart';

abstract class RestOperations implements IConfigurable, IReferenceable {
  var logger = CompositeLogger();
  var counters = CompositeCounters();
  var dependencyResolver = DependencyResolver();

  String? componentName;

  RestOperations();

  RestOperations.withName(String name) : componentName = name;

  @override
  void configure(ConfigParams config) {
    dependencyResolver.configure(config);
  }

  @override
  void setReferences(IReferences references) {
    logger.setReferences(references);
    counters.setReferences(references);
    dependencyResolver.setReferences(references);
  }

  CounterTiming instrument(IContext? context, String name) {
    logger.trace(context, 'Executing %s method', [name]);
    counters.incrementOne('$name.exec_count');
    return counters.beginTiming('$name.exec_time');
  }

  void instrumentError(IContext? context, String name, err,
      [bool? reerror = false]) {
    if (err != null) {
      logger.error(context, ApplicationException().wrap(err),
          'Failed to execute %s method', [name]);
      counters.incrementOne('$name.exec_errors');
      if (reerror != null && reerror == true) {
        throw err;
      }
    }
  }

  /// Returns trace id from request
  /// - [req] -  http request
  /// Returns Returns traceId from request
  String? getTraceId(Request req) {
    var traceId = req.url.queryParameters['trace_id'];
    if (traceId == null || traceId == '') {
      traceId = req.headers['trace_id'];
    }
    return traceId;
  }

  FilterParams getFilterParams(Request req) {
    var params = Map.from(req.url.queryParameters);

    params.remove('skip');
    params.remove('take');
    params.remove('total');

    var filter = FilterParams.fromValue(params);
    return filter;
  }

  PagingParams getPagingParams(Request req) {
    var params = <String, dynamic>{};
    params['skip'] = req.url.queryParameters['skip'] ?? 0;
    params['take'] = req.url.queryParameters['take'] ?? 100;
    params['total'] = req.url.queryParameters['total'] ?? false;
    var paging = PagingParams.fromValue(params);
    return paging;
  }

  FutureOr<Response> sendResult(Request req, err, result) async {
    return await HttpResponseSender.sendResult(req, result);
  }

  FutureOr<Response> sendEmptyResult(Request req, err) async {
    return await HttpResponseSender.sendEmptyResult(req, err);
  }

  FutureOr<Response> sendCreatedResult(Request req, err, result) async {
    return await HttpResponseSender.sendCreatedResult(req, result);
  }

  FutureOr<Response> sendDeletedResult(Request req, err, result) async {
    return await HttpResponseSender.sendDeletedResult(req, result);
  }

  FutureOr<Response> sendError(Request req, error) async {
    return await HttpResponseSender.sendError(req, error);
  }

  FutureOr<Response> sendBadRequest(Request req, String message) async {
    var traceId = getTraceId(req);
    var error = BadRequestException(traceId, 'BAD_REQUEST', message);
    return await sendError(req, error);
  }

  FutureOr<Response> sendUnauthorized(Request req, String message) async {
    var traceId = getTraceId(req);
    var error = UnauthorizedException(traceId, 'UNAUTHORIZED', message);
    return await sendError(req, error);
  }

  FutureOr<Response> sendNotFound(Request req, String message) async {
    var traceId = getTraceId(req);
    var error = NotFoundException(traceId, 'NOT_FOUND', message);
    return await sendError(req, error);
  }

  FutureOr<Response> sendConflict(Request req, String message) async {
    var traceId = getTraceId(req);
    var error = ConflictException(traceId, 'CONFLICT', message);
    return await sendError(req, error);
  }

  FutureOr<Response> sendSessionExpired(Request req, String message) async {
    var traceId = getTraceId(req);
    var error = UnknownException(traceId, 'SESSION_EXPIRED', message);
    error.status = 440;
    return await sendError(req, error);
  }

  FutureOr<Response> sendInternalError(Request req, String message) async {
    var traceId = getTraceId(req);
    var error = UnknownException(traceId, 'INTERNAL', message);
    return await sendError(req, error);
  }

  FutureOr<Response> sendServerUnavailable(Request req, String message) async {
    var traceId = getTraceId(req);
    var error = ConflictException(traceId, 'SERVER_UNAVAILABLE', message);
    error.status = 503;
    return await sendError(req, error);
  }

  Function(Request req) invoke(String operation) {
    return (Request req) {
      //TODO: Wrote code, if thos methods are needed
      throw Exception('RestOperations: Need wrote Invoke method!!!');
      //this. ['operation'](req, res);
    };
  }

  Future safeInvoke(Request req, String name, Function() operation,
      Function(Exception err) error) async {
    var traceId = getTraceId(req);

    var timing =
        instrument(traceId != null ? Context.fromTraceId(traceId) : null, name);
    try {
      return await operation();
    } catch (err) {
      timing.endTiming();
      return await error(ApplicationException().wrap(err));
    } finally {
      timing.endTiming();
    }
  }
}
