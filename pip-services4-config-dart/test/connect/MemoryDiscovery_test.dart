import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/src/connect/connect.dart';
import 'package:test/test.dart';

void main() {
  group('MemoryDiscovery', () {
    test('Resolve connections', () async {
      var config = ConfigParams.fromTuples([
        'key1.host',
        '10.1.1.100',
        'key1.port',
        '8080',
        'key2.host',
        '10.1.1.101',
        'key2.port',
        '8082'
      ]);

      var discovery = MemoryDiscovery();
      discovery.configure(config);

      // Resolve one
      var connection =
          await discovery.resolveOne(Context.fromTraceId('context'), 'key1');
      expect('10.1.1.100', connection?.getHost());
      expect(8080, connection?.getPort());

      connection =
          await discovery.resolveOne(Context.fromTraceId('context'), 'key2');
      expect('10.1.1.101', connection?.getHost());
      expect(8082, connection?.getPort());

      // Resolve all
      await discovery.register(
          null, 'key1', ConnectionParams.fromTuples(['host', '10.3.3.151']));

      var connections =
          await discovery.resolveAll(Context.fromTraceId('context'), 'key1');

      expect(true, connections.length > 1);
    });
  });
}
