import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_mysql/src/connect/MySqlConnection.dart';
import 'package:test/test.dart';

void main() {
  group('MySqlConnection', () {
    late MySqlConnection connection;

    var mysqlUri = Platform.environment['MYSQL_URI'];
    var mysqlHost = Platform.environment['MYSQL_HOST'] ?? 'localhost';
    var mysqlPort = Platform.environment['MYSQL_PORT'] ?? 3306;
    var mysqlDatabase = Platform.environment['MYSQL_DB'] ?? 'test';
    var mysqlUser = Platform.environment['MYSQL_USER'] ?? 'mysql';
    var mysqlPassword = Platform.environment['MYSQL_PASSWORD'] ?? 'mysql';
    // ignore: unnecessary_null_comparison
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

      connection = MySqlConnection();
      connection.configure(dbConfig);

      await connection.open(null);
    });

    tearDown(() async {
      await connection.close(null);
    });

    test('Open and Close', () {
      expect(connection.getConnection(), isNotNull);
      expect(connection.getDatabaseName(), isNotNull);
    });
  });
}
