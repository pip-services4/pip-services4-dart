import 'dart:convert';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:test/test.dart';
import 'package:grpc/grpc.dart' as grpc;

import 'package:pip_services4_grpc/src/generated/commandable.pbgrpc.dart'
    as command;
import 'package:pip_services4_grpc/src/generated/commandable.pb.dart'
    as messages;

import '../sample/Dummy.dart';
import '../sample/DummyService.dart';
import 'DummyCommandableGrpcController.dart';

void main() {
  var port = 3000;
  var grpcConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'http',
    'connection.host',
    'localhost',
    'connection.port',
    port
  ]);

  group('DummyCommandableGrpcService', () {
    late Dummy _dummy1;
    late Dummy _dummy2;

    late DummyCommandableGrpcController controller;

    late command.CommandableClient client;
    grpc.ClientChannel channel;

    setUpAll(() async {
      var service = DummyService();

      controller = DummyCommandableGrpcController();
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
      final options =
          grpc.ChannelOptions(credentials: grpc.ChannelCredentials.insecure());

      channel = grpc.ClientChannel('localhost', port: port, options: options);
      client = command.CommandableClient(channel);

      _dummy1 = Dummy(id: '', key: 'Key 1', content: 'Content 1');
      _dummy2 = Dummy(id: '', key: 'Key 2', content: 'Content 2');
    });

    test('CRUD Operations', () async {
      var dummy1;

      // Create one dummy
      var request = messages.InvokeRequest();
      request.traceId = '123';
      request.method = 'dummy.create_dummy';
      request.argsEmpty = false;
      request.argsJson = json.encode({'dummy': _dummy1});
      command.InvokeReply response;

      response = await client.invoke(request);

      expect(response.resultEmpty, isFalse);
      expect(response.resultJson, isNotEmpty);
      var dummy = Dummy.fromJson(json.decode(response.resultJson));

      expect(dummy, isNotNull);
      expect(dummy.content, _dummy1.content);
      expect(dummy.key, _dummy1.key);

      dummy1 = dummy;

      // Create another dummy
      request = messages.InvokeRequest();
      request.traceId = '123';
      request.method = 'dummy.create_dummy';
      request.argsEmpty = false;
      request.argsJson = json.encode({'dummy': _dummy2});

      response = await client.invoke(request);

      expect(response.resultEmpty, isFalse);
      expect(response.resultJson, isNotEmpty);
      dummy = Dummy.fromJson(json.decode(response.resultJson));

      expect(dummy, isNotNull);
      expect(dummy.content, _dummy2.content);
      expect(dummy.key, _dummy2.key);

      // Get all dummies
      request = messages.InvokeRequest();
      request.traceId = '123';
      request.method = 'dummy.get_dummies';
      request.argsEmpty = false;
      request.argsJson = json.encode({});

      response = await client.invoke(request);

      expect(response.resultEmpty, isFalse);
      expect(response.resultJson, isNotEmpty);
      var dummies = DataPage<Dummy>.fromJson(
          json.decode(response.resultJson), (item) => Dummy.fromJson(item));

      expect(dummies, isNotNull);
      expect(dummies.data.length, 2);

      // Update the dummy
      dummy1.content = 'Updated Content 1';

      request = messages.InvokeRequest();
      request.traceId = '123';
      request.method = 'dummy.update_dummy';
      request.argsEmpty = false;
      request.argsJson = json.encode({'dummy': dummy1});

      response = await client.invoke(request);

      expect(response.resultEmpty, isFalse);
      expect(response.resultJson, isNotEmpty);
      dummy = Dummy.fromJson(json.decode(response.resultJson));

      expect(dummy, isNotNull);
      expect(dummy.content, 'Updated Content 1');
      expect(dummy.key, _dummy1.key);

      dummy1 = dummy;

      // Delete dummy
      request = messages.InvokeRequest();
      request.traceId = '123';
      request.method = 'dummy.delete_dummy';
      request.argsEmpty = false;
      request.argsJson = json.encode({'dummy_id': dummy1.id});
      response = await client.invoke(request);
      expect(response.error.code, isEmpty);
      expect(response.error.message, isEmpty);
      expect(response.error.stackTrace, isEmpty);
      expect(response.error.status, 0);

      // Try to get delete dummy
      request = messages.InvokeRequest();
      request.traceId = '123';
      request.method = 'dummy.get_dummy_by_id';
      request.argsEmpty = false;
      request.argsJson = json.encode({'dummy_id': dummy1.id});

      response = await client.invoke(request);

      expect(response.error.code, isEmpty);
      expect(response.error.message, isEmpty);
      expect(response.error.stackTrace, isEmpty);
      expect(response.error.status, 0);
      expect(response.resultEmpty, isTrue);
    });
  });
}
