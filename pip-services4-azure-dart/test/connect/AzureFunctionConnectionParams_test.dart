import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import 'package:pip_services4_azure/pip_services4_azure.dart';

void main() {
  group('AzureFunctionConnectionParams', () {
    test('Test Empty Connection', () {
      var connection = AzureFunctionConnectionParams();
      expect(null, connection.getFunctionUri());
      expect(null, connection.getAppName());
      expect(null, connection.getFunctionName());
      expect(null, connection.getAuthCode());
      expect(null, connection.getProtocol());
    });

    test('Compose Config', () async {
      var config1 = ConfigParams.fromTuples([
        'connection.uri',
        'http://myapp.azurewebsites.net/api/myfunction',
        'credential.auth_code',
        '1234',
      ]);
      var config2 = ConfigParams.fromTuples([
        'connection.protocol',
        'http',
        'connection.app_name',
        'myapp',
        'connection.function_name',
        'myfunction',
        'credential.auth_code',
        '1234',
      ]);

      var resolver = AzureFunctionConnectionResolver();
      resolver.configure(config1);
      var connection = await resolver.resolve(null);

      expect('http://myapp.azurewebsites.net/api/myfunction',
          connection.getFunctionUri());
      expect('myapp', connection.getAppName());
      expect('http', connection.getProtocol());
      expect('myfunction', connection.getFunctionName());
      expect('1234', connection.getAuthCode());

      resolver = AzureFunctionConnectionResolver();
      resolver.configure(config2);
      connection = await resolver.resolve(null);

      expect('http://myapp.azurewebsites.net/api/myfunction',
          connection.getFunctionUri());
      expect('http', connection.getProtocol());
      expect('myapp', connection.getAppName());
      expect('myfunction', connection.getFunctionName());
      expect('1234', connection.getAuthCode());
    });
  });
}
