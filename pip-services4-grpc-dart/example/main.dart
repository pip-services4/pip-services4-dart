import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

import './sample/DummyService.dart';
import 'controllers/DummyCommandableGrpcController.dart';
import './clients/DummyCommandableGrpcClient.dart';
import './sample/Dummy.dart';

var grpcConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3002
]);

void main() async {
  DummyCommandableGrpcController controller;
  DummyCommandableGrpcClient client;

  var service = DummyService();

  controller = DummyCommandableGrpcController();
  controller.configure(grpcConfig);

  var references = References.fromTuples([
    Descriptor('pip-services-dummies', 'service', 'default', 'default', '1.0'),
    service,
    Descriptor('pip-services-dummies', 'controller', 'grpc', 'default', '1.0'),
    controller
  ]);
  controller.setReferences(references);
  await controller.open(Context.fromTraceId('123'));

  client = DummyCommandableGrpcClient();

  client.configure(grpcConfig);
  client.setReferences(References());
  await client.open(Context.fromTraceId('123'));
//----------------------------------------------
  var dummy1 = Dummy(id: '', key: 'Key 1', content: 'Content 1');

  // Create one dummy
  var dummy = await client.createDummy(Context.fromTraceId('123'), dummy1);

  // Get all dummies
  var dummies = await client.getDummies(
      Context.fromTraceId('123'), FilterParams(), PagingParams(0, 5, false));

  // Update the dummy
  dummy!.content = 'Updated Content 1';
  dummy = await client.updateDummy(Context.fromTraceId('123'), dummy);

  // Delete dummy
  await client.deleteDummy(Context.fromTraceId('123'), dummy1.id!);

  // Try to get delete dummy
  dummy = await client.getDummyById(Context.fromTraceId('123'), dummy1.id!);

//----------------------------------------------
  await client.close(Context.fromTraceId('123'));
  await controller.close(Context.fromTraceId('123'));
}
