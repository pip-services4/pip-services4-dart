import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import '../fixtures/DummyPersistenceFixture.dart';
import './DummyPostgresPersistence.dart';

void main() {
  group('DummyPostgresPersistence', () {
    late DummyPostgresPersistence persistence;
    late DummyPersistenceFixture fixture;

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

      persistence = DummyPostgresPersistence();
      persistence.configure(dbConfig);

      fixture = DummyPersistenceFixture(persistence);

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
