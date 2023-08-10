import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:protobuf/protobuf.dart' as $pb;
import '../clients/GrpcClient.dart';

/// Grpc client used for automated testing.
class TestGrpcClient extends GrpcClient {
  TestGrpcClient(String clientName) : super(clientName);

  /// Calls a remote method via GRPC protocol.
  ///
  /// [method]            a method name to called
  /// [context]           (optional) a context to trace execution through call chain.
  /// [request]           (optional) request object.
  /// Return                (optional) Future that receives result object or error.
  @override
  grpc.ResponseFuture<TestDataPage> call<
          TestPageRequest extends $pb.GeneratedMessage,
          TestDataPage extends $pb.GeneratedMessage>(
      String method, IContext? context, TestPageRequest request,
      {grpc.CallOptions? options}) {
    return super.call(method, context, request, options: options);
  }
}
