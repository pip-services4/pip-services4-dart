import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import 'package:pip_services4_mongodb/pip_services4_mongodb.dart';

void main() {
  group('MongoDbConnection', () {
    late MongoDbConnection connection;

    var mongoUri = Platform.environment['MONGO_SERVICE_URI'];
    var mongoHost = Platform.environment['MONGO_SERVICE_HOST'] ?? 'localhost';
    var mongoPort = Platform.environment['MONGO_SERVICE_PORT'] ?? '27017';
    var mongoDatabase = Platform.environment['MONGO_DB'] ?? 'test';
    if (mongoUri == null && mongoHost == null) {
      return;
    }

    setUp(() async {
      var dbConfig = ConfigParams.fromTuples([
        'connection.uri',
        mongoUri,
        'connection.host',
        mongoHost,
        'connection.port',
        mongoPort,
        'connection.database',
        mongoDatabase
      ]);

      connection = MongoDbConnection();
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
