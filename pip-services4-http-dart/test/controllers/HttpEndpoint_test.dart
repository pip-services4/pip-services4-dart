import 'package:http/http.dart' as http;
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:pip_services4_http/pip_services4_http.dart';
import 'dart:convert';
import 'package:test/test.dart';
import '../sample/DummyService.dart';
import 'DummyRestController.dart';

var restConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  '3001'
]);

void main() {
  group('HttpEndpoint', () {
    HttpEndpoint endpoint;
    DummyRestController controller;

    late http.Client rest;
    late String url;

    var service = DummyService();

    controller = DummyRestController();
    controller.configure(ConfigParams.fromTuples(['base_route', '/api/v1']));

    endpoint = HttpEndpoint();
    endpoint.configure(restConfig);

    setUpAll(() async {
      var references = References.fromTuples([
        Descriptor(
            'pip-services-dummies', 'service', 'default', 'default', '1.0'),
        service,
        Descriptor(
            'pip-services-dummies', 'controller', 'rest', 'default', '1.0'),
        controller,
        Descriptor('pip-services', 'endpoint', 'http', 'default', '1.0'),
        endpoint
      ]);
      controller.setReferences(references);

      await endpoint.open(null);
      await controller.open(null);

      url = 'http://localhost:3001';
      rest = http.Client();
    });

    tearDownAll(() async {
      await controller.close(null);
      await endpoint.close(null);
    });

    test('CRUD Operations', () async {
      var resp = await rest.get(Uri.parse('$url/api/v1/dummies'));
      var dummies =
          DataPage.fromJson(json.decode(resp.body.toString()), (itemsJson) {
        return Map.from(itemsJson).cast<String, String>();
      });
      expect(dummies, isNotNull);
      expect(dummies.data.length, 0);
    });
  });
}
