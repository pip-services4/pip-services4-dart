import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/src/connect/connect.dart';
import 'package:test/test.dart';

void main() {
  group('ConnectionResolver', () {
    var RestConfig = ConfigParams.fromTuples([
      'connection.protocol',
      'http',
      'connection.host',
      'localhost',
      'connection.port',
      3000
    ]);

    test('Configure', () {
      var connectionResolver = ConnectionResolver(RestConfig);
      var configList = connectionResolver.getAll();
      expect(configList[0].get('protocol'), 'http');
      expect(configList[0].get('host'), 'localhost');
      expect(configList[0].get('port'), '3000');
    });

    test('Register', () async {
      var connectionParams = ConnectionParams();
      var connectionResolver = ConnectionResolver(RestConfig);

      try {
        await connectionResolver.register(
            Context.fromTraceId('context'), connectionParams);
      } catch (err) {
        expect(err, isNull);
      }
      var configList = connectionResolver.getAll();
      expect(configList.length, 1);

      try {
        await connectionResolver.register(
            Context.fromTraceId('context'), connectionParams);
      } catch (err) {
        expect(err, isNull);
      }
      configList = connectionResolver.getAll();
      expect(configList.length, 1);

      connectionParams.setDiscoveryKey('Discovery key value');
      var references = References();
      connectionResolver.setReferences(references);
      try {
        await connectionResolver.register(
            Context.fromTraceId('context'), connectionParams);
      } catch (err) {
        expect(err, isNull);
      }
      configList = connectionResolver.getAll();
      expect(configList.length, 2);
      expect(configList[0].get('protocol'), 'http');
      expect(configList[0].get('host'), 'localhost');
      expect(configList[0].get('port'), '3000');
      //expect(configList[0].get('discovery_key'), 'Discovery key value');
    });

    test('Resolve', () async {
      var connectionResolver = ConnectionResolver(RestConfig);
      try {
        var connectionParams =
            await connectionResolver.resolve(Context.fromTraceId('context'));
        expect(connectionParams!.get('protocol'), 'http');
        expect(connectionParams.get('host'), 'localhost');
        expect(connectionParams.get('port'), '3000');
      } catch (err) {
        expect(err, isNull);
      }

      var RestConfigDiscovery = ConfigParams.fromTuples([
        'connection.protocol',
        'http',
        'connection.host',
        'localhost',
        'connection.port',
        3000,
        'connection.discovery_key',
        'Discovery key value'
      ]);
      var references = References();
      connectionResolver = ConnectionResolver(RestConfigDiscovery, references);
      try {
        var connectionParams =
            await connectionResolver.resolve(Context.fromTraceId('context'));
        expect(connectionParams, isNull);
      } catch (err) {
        expect(err, isNotNull);
      }
    });
  });
}
