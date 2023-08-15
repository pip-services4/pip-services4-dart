import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import '../fixtures/Dummy2PersistenceFixture.dart';
import 'Dummy2PostgresPersistence.dart';

void main() {
  group('Dummy2PostgresPersistence', () {
    late Dummy2PostgresPersistence persistence;
    late Dummy2PersistenceFixture fixture;

    var postgresUri = Platform.environment['POSTGRES_URI'];
    var postgresHost = Platform.environment['POSTGRES_HOST'] ?? 'localhost';
    var postgresPort = Platform.environment['POSTGRES_PORT'] ?? 5432;
    var postgresDatabase = Platform.environment['POSTGRES_DB'] ?? 'test';
    var postgresUser = Platform.environment['POSTGRES_USER'] ?? 'postgres';
    var postgresPassword =
        Platform.environment['POSTGRES_PASSWORD'] ?? 'postgres';

    // ignore: unnecessary_null_comparison
    if (postgresUri == null && postgresHost == null) {
      return;
    }

    setUp(() async {
      var dbConfig = ConfigParams.fromTuples([
        'connection.uri',
        postgresUri,
        'connection.host',
        postgresHost,
        'connection.port',
        postgresPort,
        'connection.database',
        postgresDatabase,
        'credential.username',
        postgresUser,
        'credential.password',
        postgresPassword
      ]);

      persistence = Dummy2PostgresPersistence();
      persistence.configure(dbConfig);

      fixture = Dummy2PersistenceFixture(persistence);

      await persistence.open(null);
      await persistence.clear(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('Crud Operations', () async {
      await fixture.testCrudOperations();
    });

    test('Batch Operations', () async {
      await fixture.testBatchOperations();
    });
  });
}
