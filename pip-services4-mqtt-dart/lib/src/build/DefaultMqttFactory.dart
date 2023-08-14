import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_mqtt/src/connect/MqttConnection.dart';
import '../queues/MqttMessageQueue.dart';
import 'MqttMessageQueueFactory.dart';

///Creates [MqttMessageQueue] components by their descriptors.
///
/// See [Factory]
/// See [MqttMessageQueue]

class DefaultMqttFactory extends Factory {
  static final MqttQueueDescriptor =
      Descriptor('pip-services', 'message-queue', 'mqtt', '*', '1.0');
  static final MqttConnectionDescriptor =
      Descriptor('pip-services', 'connection', 'mqtt', '*', '1.0');
  static final MqttQueueFactoryDescriptor =
      Descriptor('pip-services', 'queue-factory', 'mqtt', '*', '1.0');

  ///Create a new instance of the factory.
  DefaultMqttFactory() : super() {
    register(DefaultMqttFactory.MqttQueueDescriptor, (locator) {
      return MqttMessageQueue(locator?.getName());
    });

    registerAsType(DefaultMqttFactory.MqttConnectionDescriptor, MqttConnection);
    registerAsType(
        DefaultMqttFactory.MqttQueueFactoryDescriptor, MqttMessageQueueFactory);
  }
}
