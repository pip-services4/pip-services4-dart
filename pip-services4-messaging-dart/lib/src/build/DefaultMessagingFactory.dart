import 'package:pip_services4_components/pip_services4_components.dart';
import '../queues/MemoryMessageQueue.dart';
import 'MemoryMessageQueueFactory.dart';

/// Creates [MemoryMessageQueue] components by their descriptors.
/// Name of created message queue is taken from its descriptor.
///
/// See [Factory](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/Factory-class.html)
/// See [MemoryMessageQueue]
class DefaultMessagingFactory extends Factory {
  static final descriptor =
      Descriptor('pip-services', 'message-queue', 'memory', '*', '1.0');
  static final MemoryQueueFactoryDescriptor =
      Descriptor('pip-services', 'queue-factory', 'memory', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultMessagingFactory() : super() {
    register(DefaultMessagingFactory.MemoryQueueFactoryDescriptor,
        (locator) => MemoryMessageQueue(locator?.getName()));
    registerAsType(DefaultMessagingFactory.MemoryQueueFactoryDescriptor,
        MemoryMessageQueueFactory);
  }
}
