import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';

import '../controllers/DummyRestController.dart';
import '../sample/DummyService.dart';
import './DummyRestClient.dart';
import './DummyClientFixture.dart';

var restConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3002,
  //'options.trace_id_place', 'headers',
]);

void main() {
  group('DummyRestClient', () {
    late DummyRestController controller;
    DummyRestClient client;

    late DummyClientFixture fixture;

    setUpAll(() async {
      var service = DummyService();

      controller = DummyRestController();
      controller.configure(restConfig);

      var references = References.fromTuples([
        Descriptor(
            'pip-services-dummies', 'service', 'default', 'default', '1.0'),
        service,
        Descriptor(
            'pip-services-dummies', 'controller', 'rest', 'default', '1.0'),
        controller
      ]);
      controller.setReferences(references);

      await controller.open(null);
    });

    tearDown(() async {
      await controller.close(null);
    });

    setUp(() async {
      client = DummyRestClient();
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
