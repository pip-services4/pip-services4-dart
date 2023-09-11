import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import '../DummyClientFixture.dart';
import 'DummyAzureFunctionClient.dart';

void main() {
  var appName = Platform.environment['AZURE_FUNCTION_APP_NAME'];
  var functionName = Platform.environment['AZURE_FUNCTION_NAME'];
  var protocol = Platform.environment['AZURE_FUNCTION_PROTOCOL'];
  var authCode = Platform.environment['AZURE_FUNCTION_AUTH_CODE'];
  var uri = Platform.environment['AZURE_FUNCTION_URI'];

  group('DummyAzureFunctionClient', () {
    if (uri != null &&
        (appName != null ||
            functionName != null ||
            protocol != null ||
            authCode != null)) {
      return;
    }

    var config = ConfigParams.fromTuples([
      'connection.uri',
      uri,
      'connection.protocol',
      protocol,
      'connection.app_name',
      appName,
      'connection.function_name',
      functionName,
      'credential.auth_code',
      authCode,
    ]);

    late DummyAzureFunctionClient client;
    late DummyClientFixture fixture;

    setUp(() async {
      client = DummyAzureFunctionClient();
      client.configure(config);

      fixture = DummyClientFixture(client);

      await client.open(null);
    });

    tearDown(() async {
      await client.close(null);
    });

    test('Crud Operations', () async {
      await fixture.testCrudOperations();
    });
  });
}
