import 'package:pip_services4_components/pip_services4_components.dart';
import '../queues/RabbitMQMessageQueue.dart';

class RabbitMQMessageQueueFactory extends Factory {
  static final descriptor = Descriptor(
      'pip-services3-rabbitmq', 'factory', 'message-queue', 'rabbitmq', '1.0');
  static final MemoryQueueDescriptor = Descriptor(
      'pip-services3-rabbitmq', 'message-queue', 'rabbitmq', '*', '*');

  ConfigParams? config;

  RabbitMQMessageQueueFactory() : super() {
    register(MemoryQueueDescriptor, (locator) {
      var queue = RabbitMQMessageQueue(locator.getName());
      if (config != null) {
        queue.configure(config!);
      }
      return queue;
    });
  }

  void configure(ConfigParams config) {
    this.config = config;
  }
}
