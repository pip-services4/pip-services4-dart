import 'package:pip_services4_components/pip_services4_components.dart';

import '../../pip_services4_messaging.dart';

/// Creates [IMessageQueue] components by their descriptors.
/// Name of created message queue is taken from its descriptor.
///
/// See [Factory](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/Factory-class.html)
/// See [MessageQueue]
abstract class MessageQueueFactory extends Factory
    implements IMessageQueueFactory, IConfigurable, IReferenceable {
  ConfigParams? config_;
  IReferences? references_;

  /// Configures component by passing configuration parameters.
  ///
  /// - [config] configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    config_ = config;
  }

  /// Sets references to dependent components.
  ///
  /// - [references] references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    references_ = references;
  }

  /// Creates a message queue component and assigns its name.
  /// - [name] a name of the created message queue.
  @override
  IMessageQueue createQueue(String name);
}
