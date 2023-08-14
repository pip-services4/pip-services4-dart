import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_mqtt/src/build/MqttMessageQueueFactory.dart';
import 'package:test/test.dart';

void main() {
  group('MqttMessageQueueFactory', () {
    test('CreateMessageQueue', () async {
      var factory = MqttMessageQueueFactory();
      var descriptor =
          Descriptor('pip-services', 'message-queue', 'mqtt', 'test', '1.0');

      var canResult = factory.canCreate(descriptor);
      expect(canResult, isNotNull);

      var queue = factory.create(descriptor);
      expect(queue, isNotNull);
      expect('test', queue.getName());
    });
  });
}
