import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/src/config/config.dart';
import 'package:test/test.dart';

void main() {
  group('YamlConfigReader', () {
    test('Config Sections', () {
      var parameters = ConfigParams.fromTuples(
          ['param1', 'Test Param 1', 'param2', 'Test Param 2']);
      var config =
          YamlConfigReader.readConfig_(null, './data/config.yaml', parameters);

      expect(config.length, 9);
      expect(config.getAsInteger('field1.field11'), 123);
      expect(config.get('field1.field12'), 'ABC');
      expect(config.getAsInteger('field2.0'), 123);
      expect(config.get('field2.1'), 'ABC');
      expect(config.getAsInteger('field2.2.field21'), 543);
      expect(config.get('field2.2.field22'), 'XYZ');
      expect(config.getAsBoolean('field3'), true);
      expect(config.get('field4'), 'Test Param 1');
      expect(config.get('field5'), 'Test Param 2');
    });
  });
}
