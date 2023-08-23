import 'dart:io';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

import './Dummy.dart';
import 'DummyCommandableLambdaClient.dart';
import 'DummyCommandableLambdaFunction.dart';

void main() async {
  var awsAccessId = Platform.environment['AWS_ACCESS_ID'];
  var awsAccessKey = Platform.environment['AWS_ACCESS_KEY'];
  var lambdaArn = Platform.environment['LAMBDA_ARN'];
  var config = ConfigParams.fromTuples([
    'logger.descriptor',
    'pip-services:logger:console:default:1.0',
    'service.descriptor',
    'pip-services-dummies:service:default:default:1.0'
  ]);
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

  DummyCommandableLambdaFunction lambda;
  DummyCommandableLambdaClient client;

  lambda = DummyCommandableLambdaFunction();
  lambda.configure(config);

  await lambda.open(null);

  client = DummyCommandableLambdaClient();

  client.configure(lambdaConfig);
  await client.open(null);

  var dummy1 = Dummy(id: null, key: 'Key 1', content: 'Content 1');
  var dummy2 = Dummy(id: null, key: 'Key 2', content: 'Content 2');

  // Create one dummy
  try {
    var dummy = await client.createDummy(null, dummy1);
    // work with created item

    dummy1 = dummy!;
  } catch (err) {
    // error processing
  }

  // Create another dummy
  try {
    var dummy = await client.createDummy(null, dummy2);
    // work with second created item
    dummy2 = dummy!;
  } catch (err) {
    // error processing
  }

  // Get all dummies
  try {
    var dummies = await client.getDummies(
        null, FilterParams(), PagingParams(0, 5, false));
    print(dummies);
    // processing recived items
  } catch (err) {
    // error processing
  }

  // Update the dummy
  try {
    dummy1.content = 'Updated Content 1';
    var dummy = await client.updateDummy(null, dummy1);
    // processing with updated item
    dummy1 = dummy!;
  } catch (err) {
    // error processing
  }

  // Delete dummy
  try {
    await client.deleteDummy(null, dummy1.id!);
  } catch (err) {
    // error processing
  }

  // Try to get delete dummy
  try {
    var dummy = await client.getDummyById(null, dummy1.id!);
    print(dummy);
    // work with deleted item
  } catch (err) {
    // error processing
  }
  // close service and client
  await client.close(null);
}
