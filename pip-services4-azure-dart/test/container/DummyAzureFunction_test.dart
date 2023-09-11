import 'dart:convert';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import 'package:test/test.dart';

import '../Dummy.dart';
import 'DummyAzureFunction.dart';

void main() {
  group('DummyAzureFunction', () {
    var DUMMY1 = Dummy(id: '', key: 'Key 1', content: 'Content 1');
    var DUMMY2 = Dummy(id: '', key: 'Key 2', content: 'Content 2');

    late DummyAzureFunction azureFunction;

    setUpAll(() async {
      var config = ConfigParams.fromTuples([
        'logger.descriptor',
        'pip-services:logger:console:default:1.0',
        'service.descriptor',
        'pip-services-dummies:service:default:default:1.0'
      ]);

      azureFunction = DummyAzureFunction();
      azureFunction.configure(config);
      await azureFunction.open(
        null,
      );
    });

    tearDownAll(() async {
      await azureFunction.close(
        null,
      );
    });

    test('CRUD Operations', () async {
      Dummy dummy1;

      // Create one dummy
      var result =
          await azureFunction.act({'cmd': 'create_dummy', 'dummy': DUMMY1});
      var dummy = Dummy.fromJson(json.decode(result));
      expect(dummy, isNotNull);
      expect(dummy.content, DUMMY1.content);
      expect(dummy.key, DUMMY1.key);

      dummy1 = dummy;

      // Create another dummy
      result =
          await azureFunction.act({'cmd': 'create_dummy', 'dummy': DUMMY2});
      dummy = Dummy.fromJson(json.decode(result));
      expect(dummy, isNotNull);
      expect(dummy.content, DUMMY2.content);
      expect(dummy.key, DUMMY2.key);

      // Get all dummies
      result = await azureFunction.act({'cmd': 'get_dummies'});
      var dummies = DataPage<Dummy>.fromJson(json.decode(result), (item) {
        return Dummy.fromJson(item);
      });
      expect(dummies, isNotNull);
      expect(dummies.data.length, 2);

      // Update the dummy
      dummy1.content = 'Updated Content 1';
      result =
          await azureFunction.act({'cmd': 'update_dummy', 'dummy': dummy1});
      dummy = Dummy.fromJson(json.decode(result));
      expect(dummy, isNotNull);
      expect(dummy.id, dummy1.id);
      expect(dummy.content, dummy1.content);
      expect(dummy.key, dummy1.key);

      // Delete dummy
      await azureFunction.act({'cmd': 'delete_dummy', 'dummy_id': dummy1.id});

      // Try to get delete dummy
      result = await azureFunction
          .act({'cmd': 'get_dummy_by_id', 'dummy_id': dummy1.id});
      expect(result, null);

      var err = await azureFunction.act({'cmd': 'create_dummy', 'dummy': null});
      err = json.decode(err);
      expect(
          err is ValidationException ? err.code : err['code'], 'INVALID_DATA');
    });
  });
}
