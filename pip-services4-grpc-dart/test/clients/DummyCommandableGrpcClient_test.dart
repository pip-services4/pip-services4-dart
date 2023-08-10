import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';

import '../sample/DummyService.dart';
import '../controllers/DummyCommandableGrpcController.dart';
import './DummyCommandableGrpcClient.dart';
import './DummyClientFixture.dart';

var grpcConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3002
]);

void main() {
  group('DummyCommandableGrpcClient', () {
    late DummyCommandableGrpcController controller;
    late DummyClientFixture fixture;
    DummyCommandableGrpcClient client;

    setUpAll(() async {
      var service = DummyService();

      controller = DummyCommandableGrpcController();
      controller.configure(grpcConfig);

      var references = References.fromTuples([
        Descriptor(
            'pip-services-dummies', 'service', 'default', 'default', '1.0'),
        service,
        Descriptor(
            'pip-services-dummies', 'controller', 'grpc', 'default', '1.0'),
        controller
      ]);
      controller.setReferences(references);

      await controller.open(null);
    });

    tearDownAll(() async {
      await controller.close(null);
    });

    setUp(() async {
      client = DummyCommandableGrpcClient();
      fixture = DummyClientFixture(client);

      client.configure(grpcConfig);
      client.setReferences(References());
      await client.open(null);
    });

    test('CRUD Operations', () async {
      await fixture.testCrudOperations();
    });
  });
}
