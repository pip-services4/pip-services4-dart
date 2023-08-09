import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

import '../test/controllers/DummyCommandableHttpController.dart';
import './Dummy.dart';
import 'DummyCommandableHttpClient.dart';
import 'DummyService.dart';

void main() async {
  var restConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'http',
    'connection.host',
    'localhost',
    'connection.port',
    3000
  ]);

  DummyCommandableHttpController controller;
  DummyCommandableHttpClient client;

  var service = DummyService();

  controller = DummyCommandableHttpController();
  controller.configure(restConfig);

  var references = References.fromTuples([
    Descriptor('pip-services-dummies', 'service', 'default', 'default', '1.0'),
    service,
    Descriptor('pip-services-dummies', 'controller', 'http', 'default', '1.0'),
    controller
  ]);
  controller.setReferences(references);

  await controller.open(null);

  client = DummyCommandableHttpClient();

  client.configure(restConfig);
  client.setReferences(References());
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
