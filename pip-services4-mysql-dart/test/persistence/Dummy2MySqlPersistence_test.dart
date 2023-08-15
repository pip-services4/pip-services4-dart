import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import '../fixtures/Dummy2PersistenceFixture.dart';
import 'Dummy2MySqlPersistence.dart';

void main() {
  group('Dummy2MySqlPersistence', () {
    late Dummy2MySqlPersistence persistence;
    late Dummy2PersistenceFixture fixture;

    var mysqlUri = Platform.environment['MYSQL_URI'];
    var mysqlHost = Platform.environment['MYSQL_HOST'] ?? 'localhost';
    var mysqlPort = Platform.environment['MYSQL_PORT'] ?? 3306;
    var mysqlDatabase = Platform.environment['MYSQL_DB'] ?? 'test';
    var mysqlUser = Platform.environment['MYSQL_USER'] ?? 'mysql';
    var mysqlPassword = Platform.environment['MYSQL_PASSWORD'] ?? 'mysql';
    if (mysqlUri == null && mysqlHost == null) {
      return;
    }

    setUp(() async {
      var dbConfig = ConfigParams.fromTuples([
        'connection.uri',
        mysqlUri,
        'connection.host',
        mysqlHost,
        'connection.port',
        mysqlPort,
        'connection.database',
        mysqlDatabase,
        'credential.username',
        mysqlUser,
        'credential.password',
        mysqlPassword
      ]);

      persistence = Dummy2MySqlPersistence();
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
