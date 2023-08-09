import 'package:http/http.dart' as http;
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_http/src/controllers/controllers.dart';
import 'package:test/test.dart';

void main() {
  var restConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'http',
    'connection.host',
    'localhost',
    'connection.port',
    3005
  ]);

  group('StatusRestController', () {
    late StatusRestController controller;
    late http.Client rest;
    late String url;

    setUpAll(() async {
      controller = StatusRestController();
      controller.configure(restConfig);

      var contextInfo = ContextInfo();
      contextInfo.name = 'Test';
      contextInfo.description = 'This is a test container';

      var references = References.fromTuples([
        Descriptor('pip-services', 'context-info', 'default', 'default', '1.0'),
        contextInfo,
        Descriptor(
            'pip-services', 'status-controller', 'http', 'default', '1.0'),
        controller
      ]);
      controller.setReferences(references);

      await controller.open(null);

      url = 'http://localhost:3005';
      rest = http.Client();
    });

    tearDownAll(() async {
      await controller.close(null);
    });

    test('Status', () async {
      try {
        var resp = await rest.get(Uri.parse('$url/status'));

        print(resp.body.toString());

        expect(resp.body.toString(), isNotNull);
      } catch (err) {
        expect(err, isNull);
      }
    });
  });
}
