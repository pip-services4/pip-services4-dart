import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import '../controllers/DummyCommandableHttpController.dart';
import '../sample/DummyService.dart';
import './DummyCommandableHttpClient.dart';
import './DummyClientFixture.dart';

var restConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3000
]);

void main() {
  group('DummyCommandableHttpClient', () {
    late DummyCommandableHttpController controller;
    late DummyCommandableHttpClient client;

    late DummyClientFixture fixture;

    setUpAll(() async {
      var service = DummyService();

      controller = DummyCommandableHttpController();
      controller.configure(restConfig);

      var references = References.fromTuples([
        Descriptor(
            'pip-services-dummies', 'service', 'default', 'default', '1.0'),
        service,
        Descriptor(
            'pip-services-dummies', 'controller', 'http', 'default', '1.0'),
        controller
      ]);
      controller.setReferences(references);

      await controller.open(null);
    });

    tearDownAll(() async {
      await controller.close(null);
    });

    setUp(() async {
      client = DummyCommandableHttpClient();
      fixture = DummyClientFixture(client);

      client.configure(restConfig);
      client.setReferences(References());
      await client.open(null);
    });

    test('CRUD Operations', () async {
      await fixture.testCrudOperations();
    });
  });
}
