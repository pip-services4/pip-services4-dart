import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import '../sample/DummyService.dart';
import '../controllers/DummyGrpcController.dart';
import './DummyGrpcClient.dart';
import './DummyClientFixture.dart';

void main() {
  var grpcConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'http',
    'connection.host',
    'localhost',
    'connection.port',
    3000
  ]);

  group('DummyGrpcClient', () {
    late DummyGrpcController controller;
    late DummyClientFixture fixture;
    DummyGrpcClient client;

    setUpAll(() async {
      var service = DummyService();

      controller = DummyGrpcController();
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
      client = DummyGrpcClient();
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
