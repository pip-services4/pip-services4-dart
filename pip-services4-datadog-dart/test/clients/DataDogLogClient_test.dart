import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_datadog/pip_services4_datadog.dart';
import 'package:test/test.dart';

void main() {
  var apiKey = Platform.environment['DATADOG_API_KEY'] ??
      '3eb3355caf628d4689a72084425177ac';

  group('DataDogLogClient', () {
    var config = ConfigParams.fromTuples(
        ['source', 'test', 'credential.access_key', apiKey]);

    late DataDogLogClient client;

    setUp(() async {
      client = DataDogLogClient(null);
      client.configure(config);

      await client.open(null);
    });

    tearDown(() async {
      await client.close(null);
    });

    test('Crud Operations', () async {
      List<DataDogLogMessage> messages = [
        DataDogLogMessage(
            time: DateTime.now(),
            service: 'TestService',
            host: 'TestHost',
            status: DataDogStatus.Debug,
            message: 'Test trace message'),
        DataDogLogMessage(
            time: DateTime.now(),
            service: 'TestService',
            host: 'TestHost',
            status: DataDogStatus.Info,
            message: 'Test info message'),
        DataDogLogMessage(
            time: DateTime.now(),
            service: 'TestService',
            host: 'TestHost',
            status: DataDogStatus.Error,
            message: 'Test error message',
            error_kind: 'Exception',
            error_stack: 'Stack trace...'),
        DataDogLogMessage(
            time: DateTime.now(),
            service: 'TestService',
            host: 'TestHost',
            status: DataDogStatus.Emergency,
            message: 'Test fatal message',
            error_kind: 'Exception',
            error_stack: 'Stack trace...'),
      ];

      await client.sendLogs(null, messages);
    });
  });
}
