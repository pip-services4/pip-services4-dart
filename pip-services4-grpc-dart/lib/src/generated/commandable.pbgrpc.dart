///
//  Generated code. Do not modify.
//  source: commandable.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'commandable.pb.dart' as $0;
export 'commandable.pb.dart';

class CommandableClient extends $grpc.Client {
  static final _$invoke = $grpc.ClientMethod<$0.InvokeRequest, $0.InvokeReply>(
      '/commandable.Commandable/invoke',
      ($0.InvokeRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.InvokeReply.fromBuffer(value));

  CommandableClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.InvokeReply> invoke($0.InvokeRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$invoke, request, options: options);
  }
}

abstract class CommandableServiceBase extends $grpc.Service {
  $core.String get $name => 'commandable.Commandable';

  CommandableServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.InvokeRequest, $0.InvokeReply>(
        'invoke',
        invoke_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.InvokeRequest.fromBuffer(value),
        ($0.InvokeReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.InvokeReply> invoke_Pre(
      $grpc.ServiceCall call, $async.Future<$0.InvokeRequest> request) async {
    return invoke(call, await request);
  }

  $async.Future<$0.InvokeReply> invoke(
      $grpc.ServiceCall call, $0.InvokeRequest request);
}
