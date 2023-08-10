import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';

import '../generated/dummies.pbgrpc.dart' as dummygrpc;
import '../generated/dummies.pb.dart' as messages;
import 'package:grpc/grpc.dart' as grpc;

import '../sample/Dummy.dart';
import '../sample/DummyService.dart';
import 'DummyGrpcController.dart';

void main() {
  var grpcConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'http',
    'connection.host',
    'localhost',
    'connection.port',
    3001
  ]);

  group('DummyGrpcService', () {
    late Dummy _dummy1;
    late Dummy _dummy2;

    late DummyGrpcController controller;

    late dummygrpc.DummiesClient client;
    grpc.ClientChannel channel;

    setUpAll(() async {
      var service = DummyService();

      controller = DummyGrpcController();
      controller.configure(grpcConfig);

      var references = References.fromTuples([
        Descriptor(
            'pip-services-dummies', 'service', 'default', 'default', '1.0'),
        service,
        Descriptor(
            'pip-services-dummies', 'controller', 'grpc', 'default', '1.0'),
        controller
      ]);
      controller.setReferences(references);
      await controller.open(null);
    });

    tearDownAll(() async {
      await controller.close(null);
    });

    setUp(() {
      // 'localhost:3000', grpc.credentials.createInsecure()
      final options =
          grpc.ChannelOptions(credentials: grpc.ChannelCredentials.insecure());

      channel = grpc.ClientChannel('localhost', port: 3001, options: options);
      client = dummygrpc.DummiesClient(channel);

      _dummy1 = Dummy(id: '', key: 'Key 1', content: 'Content 1');
      _dummy2 = Dummy(id: '', key: 'Key 2', content: 'Content 2');
    });

    test('CRUD Operations', () async {
      var dummy1;
      var request;

      // Create one dummy
      var dummy = messages.Dummy();
      dummy.id = _dummy1.id!;
      dummy.key = _dummy1.key!;
      dummy.content = _dummy1.content!;
      request = messages.DummyObjectRequest();
      request.dummy = dummy;
      dummy = await client.create_dummy(request);
      expect(dummy, isNotNull);
      expect(dummy.content, _dummy1.content);
      expect(dummy.key, _dummy1.key);
      dummy1 = dummy;

      // Create another dummy
      dummy = messages.Dummy();
      dummy.id = _dummy2.id!;
      dummy.key = _dummy2.key!;
      dummy.content = _dummy2.content!;
      request = messages.DummyObjectRequest();
      request.dummy = dummy;
      dummy = await client.create_dummy(request);
      expect(dummy, isNotNull);
      expect(dummy.content, _dummy2.content);
      expect(dummy.key, _dummy2.key);

      // Get all dummies
      request = messages.DummiesPageRequest();
      var dummies = await client.get_dummies(request);
      expect(dummies, isNotNull);
      expect(dummies.data.length, 2);

      // Update the dummy
      dummy1.content = 'Updated Content 1';
      dummy = messages.Dummy();
      dummy.id = dummy1.id;
      dummy.key = dummy1.key;
      dummy.content = dummy1.content;
      request = messages.DummyObjectRequest();
      request.dummy = dummy;
      dummy = await client.update_dummy(request);
      expect(dummy, isNotNull);
      expect(dummy.content, 'Updated Content 1');
      expect(dummy.key, _dummy1.key);
      dummy1 = dummy;

      // Delete dummy
      request = messages.DummyIdRequest();
      request.dummyId = dummy1.id;
      dummy = await client.delete_dummy_by_id(request);

      // Try to get delete dummy
      request = messages.DummyIdRequest();
      request.dummyId = dummy1.id;
      dummy = await client.get_dummy_by_id(request);
      expect(dummy.id, isEmpty);
      expect(dummy.key, isEmpty);
      expect(dummy.content, isEmpty);
    });
  });
}
