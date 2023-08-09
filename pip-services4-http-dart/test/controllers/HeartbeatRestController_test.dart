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
    3004
  ]);

  group('HeartbeatRestController', () {
    late HeartbeatRestController controller;
    late http.Client rest;
    late String url;

    setUpAll(() async {
      controller = HeartbeatRestController();
      controller.configure(restConfig);

      await controller.open(null);
      url = 'http://localhost:3004';
      rest = http.Client();
    });

    tearDownAll(() async {
      await controller.close(null);
    });

    test('Status', () async {
      try {
        var resp = await rest.get(Uri.parse('$url/heartbeat'));

        print(resp.body.toString());

        expect(resp.body.toString(), isNotNull);
      } catch (err) {
        expect(err, isNull);
      }
    });
  });
}
