import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_messaging/src/build/MemoryMessageQueueFactory.dart';
import 'package:test/test.dart';

void main() {
  group('MemoryMessageQueueFactory', () {
    test('CreateMessageQueue', () {
      var factory = MemoryMessageQueueFactory();
      var descriptor =
          Descriptor('pip-services', 'message-queue', 'memory', 'test', '1.0');

      var canResult = factory.canCreate(descriptor);
      expect(canResult, isNotNull);

      var queue = factory.create(descriptor);
      expect(queue, isNotNull);
      expect('test', queue.getName());
    });
  });
}
