import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import 'package:pip_services4_aws/pip_services4_aws.dart';

void main() {
  group('AwsConnectionParams', () {
    test('Test Empty Connection', () {
      var connection = AwsConnectionParams();
      expect('arn:aws::::', connection.getArn());
    });

    test('Parse ARN', () {
      var connection = AwsConnectionParams();

      connection.setArn(
          'arn:aws:lambda:us-east-1:12342342332:function:pip-services-dummies');
      expect('lambda', connection.getService());
      expect('us-east-1', connection.getRegion());
      expect('12342342332', connection.getAccount());
      expect('function', connection.getResourceType());
      expect('pip-services-dummies', connection.getResource());

      connection
          .setArn('arn:aws:s3:us-east-1:12342342332:pip-services-dummies');
      expect('s3', connection.getService());
      expect('us-east-1', connection.getRegion());
      expect('12342342332', connection.getAccount());
      expect(null, connection.getResourceType());
      expect('pip-services-dummies', connection.getResource());

      connection.setArn(
          'arn:aws:lambda:us-east-1:12342342332:function/pip-services-dummies');
      expect('lambda', connection.getService());
      expect('us-east-1', connection.getRegion());
      expect('12342342332', connection.getAccount());
      expect('function', connection.getResourceType());
      expect('pip-services-dummies', connection.getResource());
    });

    test('Compose AR', () {
      var connection = AwsConnectionParams.fromConfig(ConfigParams.fromTuples([
        'connection.service',
        'lambda',
        'connection.region',
        'us-east-1',
        'connection.account',
        '12342342332',
        'connection.resource_type',
        'function',
        'connection.resource',
        'pip-services-dummies',
        'credential.access_id',
        '1234',
        'credential.access_key',
        'ABCDEF'
      ]));

      expect(
          'arn:aws:lambda:us-east-1:12342342332:function:pip-services-dummies',
          connection.getArn());
      expect('1234', connection.getAccessId());
      expect('ABCDEF', connection.getAccessKey());
    });
  });
}
