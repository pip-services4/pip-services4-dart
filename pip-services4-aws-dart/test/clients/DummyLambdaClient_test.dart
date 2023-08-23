import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import '../DummyClientFixture.dart';
import './DummyLambdaClient.dart';

void main() {
  var awsAccessId = Platform.environment['AWS_ACCESS_ID'];
  var awsAccessKey = Platform.environment['AWS_ACCESS_KEY'];
  var lambdaArn = Platform.environment['LAMBDA_ARN'];

  group('DummyLambdaClient', () {
    if (awsAccessId == null || awsAccessKey == null || lambdaArn == null) {
      return;
    }

    var lambdaConfig = ConfigParams.fromTuples([
      'connection.protocol',
      'aws',
      'connection.arn',
      lambdaArn,
      'credential.access_id',
      awsAccessId,
      'credential.access_key',
      awsAccessKey,
      'options.connection_timeout',
      30000
    ]);

    late DummyLambdaClient client;
    late DummyClientFixture fixture;

    setUp(() async {
      client = DummyLambdaClient();
      client.configure(lambdaConfig);

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
