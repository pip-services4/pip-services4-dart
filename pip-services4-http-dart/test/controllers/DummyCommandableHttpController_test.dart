import 'dart:convert';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import '../sample/Dummy.dart';
import '../sample/DummyService.dart';
import '../sample/SubDummy.dart';
import 'DummyCommandableHttpController.dart';

var restConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3000,
  'swagger.enable',
  'true'
]);

void main() {
  group('DummyCommandableHttpController', () {
    late Dummy _dummy1;
    late Dummy _dummy2;

    late DummyCommandableHttpController controller;

    late http.Client rest;
    late String url;

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
      url = 'http://localhost:3000';
    });

    tearDownAll(() async {
      await controller.close(null);
    });

    setUp(() {
      rest = http.Client();
      _dummy1 = Dummy(
          id: null,
          key: 'Key 1',
          content: 'Content 1',
          array: [SubDummy(key: 'SubKey 1', content: 'SubContent 1')]);

      _dummy2 = Dummy(
          id: null,
          key: 'Key 2',
          content: 'Content 2',
          array: [SubDummy(key: 'SubKey 2', content: 'SubContent 2')]);
    });

    test('CRUD Operations', () async {
      var dummy1;

      // Create one dummy
      var resp = await rest.post(Uri.parse('$url/dummy/create_dummy'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'dummy': _dummy1}));
      var dummy = Dummy.fromJson(json.decode(resp.body.toString()));
      expect(dummy, isNotNull);
      expect(dummy.content, _dummy1.content);
      expect(dummy.key, _dummy1.key);

      dummy1 = dummy;

      // Create another dummy
      resp = await rest.post(Uri.parse('$url/dummy/create_dummy'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'dummy': _dummy2}));
      dummy = Dummy.fromJson(json.decode(resp.body.toString()));
      expect(dummy, isNotNull);
      expect(dummy.content, _dummy2.content);
      expect(dummy.key, _dummy2.key);

      // Get all dummies
      resp = await rest.post(Uri.parse('$url/dummy/get_dummies'));
      var dummies = DataPage<Dummy>.fromJson(
          json.decode(resp.body.toString()), (item) => Dummy.fromJson(item));
      expect(dummies, isNotNull);
      expect(dummies.data.length, 2);

      // Update the dummy
      dummy1.content = 'Updated Content 1';
      resp = await rest.post(Uri.parse('$url/dummy/update_dummy'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'dummy': dummy1}));
      dummy = Dummy.fromJson(json.decode(resp.body.toString()));
      expect(dummy, isNotNull);
      expect(dummy.content, 'Updated Content 1');
      expect(dummy.key, dummy1.key);

      dummy1 = dummy;

      // Delete dummy
      resp = await rest.post(Uri.parse('$url/dummy/delete_dummy'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'dummy_id': dummy1.id}));
      dummy = Dummy.fromJson(json.decode(resp.body.toString()));
      expect(dummy.id, dummy1.id);

      // Try to get delete dummy
      resp = await rest.post(Uri.parse('$url/dummy/get_dummy_by_id'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'dummy_id': dummy1.id}));
      expect(resp.body, isEmpty);
    });

    test('Check traceId', () async {
      // check transmit traceId over params
      var resp = await rest
          .post(Uri.parse('$url/dummy/check_trace_id?trace_id=test_cor_id'));
      expect(json.decode(resp.body)['trace_id'], 'test_cor_id');

      // check transmit traceId over header
      resp = await rest.post(Uri.parse('$url/dummy/check_trace_id'),
          headers: {'trace_id': 'test_cor_id_header'});
      expect(json.decode(resp.body)['trace_id'], 'test_cor_id_header');
    });

    test('Get OpenApi Spec', () async {
      var resp = await rest.get(Uri.parse('$url/dummy/swagger'));
      expect(resp.body.contains('openapi:'), true);
    });

    test('OpenApi Spec Override', () async {
      var openApiContent = 'swagger yaml content';

      // recreate controller with new configuration
      await controller.close(null);

      var config = restConfig
          .setDefaults(ConfigParams.fromTuples(['swagger.auto', false]));

      var service = DummyService();
      controller = DummyCommandableHttpController();
      controller.configure(config);

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
      var resp = await rest.get(Uri.parse('$url/dummy/swagger'));
      expect(openApiContent, resp.body);
    });
  });
}
