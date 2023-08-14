import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_messaging/pip_services4_messaging.dart';

import '../../pip_service4_mqtt.dart';

/// Creates [MqttMessageQueue] components by their descriptors.
/// Name of created message queue is taken from its descriptor.
///
/// See [Factory](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/Factory-class.html)
/// See [MqttMessageQueue]
class MqttMessageQueueFactory extends MessageQueueFactory {
  static final Descriptor MqttQueueDescriptor =
      Descriptor('pip-services', 'message-queue', 'mqtt', '*', '1.0');

  MqttMessageQueueFactory() : super() {
    register(MqttMessageQueueFactory.MqttQueueDescriptor, (locator) {
      return createQueue(locator?.getName());
    });
  }

  /// Creates a message queue component and assigns its name.
  /// - [name] a name of the created message queue.
  @override
  IMessageQueue createQueue(String name) {
    var queue = MqttMessageQueue(name);

    if (config_ != null) {
      queue.configure(config_!);
    }
    if (references_ != null) {
      queue.setReferences(references_!);
    }

    return queue;
  }
}
