///
//  Generated code. Do not modify.
//  source: dummies.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'dummies.pb.dart' as $0;
export 'dummies.pb.dart';

class DummiesClient extends $grpc.Client {
  static final _$get_dummies =
      $grpc.ClientMethod<$0.DummiesPageRequest, $0.DummiesPage>(
          '/dummies.Dummies/get_dummies',
          ($0.DummiesPageRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.DummiesPage.fromBuffer(value));
  static final _$get_dummy_by_id =
      $grpc.ClientMethod<$0.DummyIdRequest, $0.Dummy>(
          '/dummies.Dummies/get_dummy_by_id',
          ($0.DummyIdRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Dummy.fromBuffer(value));
  static final _$create_dummy =
      $grpc.ClientMethod<$0.DummyObjectRequest, $0.Dummy>(
          '/dummies.Dummies/create_dummy',
          ($0.DummyObjectRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Dummy.fromBuffer(value));
  static final _$update_dummy =
      $grpc.ClientMethod<$0.DummyObjectRequest, $0.Dummy>(
          '/dummies.Dummies/update_dummy',
          ($0.DummyObjectRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Dummy.fromBuffer(value));
  static final _$delete_dummy_by_id =
      $grpc.ClientMethod<$0.DummyIdRequest, $0.Dummy>(
          '/dummies.Dummies/delete_dummy_by_id',
          ($0.DummyIdRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Dummy.fromBuffer(value));

  DummiesClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.DummiesPage> get_dummies(
      $0.DummiesPageRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$get_dummies, request, options: options);
  }

  $grpc.ResponseFuture<$0.Dummy> get_dummy_by_id($0.DummyIdRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$get_dummy_by_id, request, options: options);
  }

  $grpc.ResponseFuture<$0.Dummy> create_dummy($0.DummyObjectRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$create_dummy, request, options: options);
  }

  $grpc.ResponseFuture<$0.Dummy> update_dummy($0.DummyObjectRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$update_dummy, request, options: options);
  }

  $grpc.ResponseFuture<$0.Dummy> delete_dummy_by_id($0.DummyIdRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$delete_dummy_by_id, request, options: options);
  }
}

abstract class DummiesServiceBase extends $grpc.Service {
  $core.String get $name => 'dummies.Dummies';

  DummiesServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.DummiesPageRequest, $0.DummiesPage>(
        'get_dummies',
        get_dummies_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DummiesPageRequest.fromBuffer(value),
        ($0.DummiesPage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DummyIdRequest, $0.Dummy>(
        'get_dummy_by_id',
        get_dummy_by_id_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DummyIdRequest.fromBuffer(value),
        ($0.Dummy value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DummyObjectRequest, $0.Dummy>(
        'create_dummy',
        create_dummy_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DummyObjectRequest.fromBuffer(value),
        ($0.Dummy value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DummyObjectRequest, $0.Dummy>(
        'update_dummy',
        update_dummy_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DummyObjectRequest.fromBuffer(value),
        ($0.Dummy value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DummyIdRequest, $0.Dummy>(
        'delete_dummy_by_id',
        delete_dummy_by_id_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DummyIdRequest.fromBuffer(value),
        ($0.Dummy value) => value.writeToBuffer()));
  }

  $async.Future<$0.DummiesPage> get_dummies_Pre($grpc.ServiceCall call,
      $async.Future<$0.DummiesPageRequest> request) async {
    return get_dummies(call, await request);
  }

  $async.Future<$0.Dummy> get_dummy_by_id_Pre(
      $grpc.ServiceCall call, $async.Future<$0.DummyIdRequest> request) async {
    return get_dummy_by_id(call, await request);
  }

  $async.Future<$0.Dummy> create_dummy_Pre($grpc.ServiceCall call,
      $async.Future<$0.DummyObjectRequest> request) async {
    return create_dummy(call, await request);
  }

  $async.Future<$0.Dummy> update_dummy_Pre($grpc.ServiceCall call,
      $async.Future<$0.DummyObjectRequest> request) async {
    return update_dummy(call, await request);
  }

  $async.Future<$0.Dummy> delete_dummy_by_id_Pre(
      $grpc.ServiceCall call, $async.Future<$0.DummyIdRequest> request) async {
    return delete_dummy_by_id(call, await request);
  }

  $async.Future<$0.DummiesPage> get_dummies(
      $grpc.ServiceCall call, $0.DummiesPageRequest request);
  $async.Future<$0.Dummy> get_dummy_by_id(
      $grpc.ServiceCall call, $0.DummyIdRequest request);
  $async.Future<$0.Dummy> create_dummy(
      $grpc.ServiceCall call, $0.DummyObjectRequest request);
  $async.Future<$0.Dummy> update_dummy(
      $grpc.ServiceCall call, $0.DummyObjectRequest request);
  $async.Future<$0.Dummy> delete_dummy_by_id(
      $grpc.ServiceCall call, $0.DummyIdRequest request);
}
