import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';

import 'package:pip_services4_grpc/pip_services4_grpc.dart';

void main() {
  var grpcConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'http',
    'connection.host',
    'localhost',
    'connection.port',
    3000
  ]);

  group('GrpcEndpoint', () {
    late GrpcEndpoint endpoint;

    setUpAll(() async {
      endpoint = GrpcEndpoint();
      endpoint.configure(grpcConfig);
      await endpoint.open(null);
    });

    tearDownAll(() async {
      await endpoint.close(null);
    });

    test('Is Open', () async {
      expect(endpoint.isOpen(), isTrue);
    });
  });
}
