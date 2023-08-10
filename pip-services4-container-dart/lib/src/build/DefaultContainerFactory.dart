import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:pip_services4_logic/pip_services4_logic.dart';

import '../test/DefaultTestFactory.dart';

/// Creates default container components (loggers, counters, caches, locks, etc.) by their descriptors.
///
/// See [Factory](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/Factory-class.html) (in the PipServices 'Components' package)
/// See [DefaultInfoFactory](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/DefaultInfoFactory-class.html) (in the PipServices 'Components' package)
/// See [DefaultObservabilityFactory](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/DefaultObservabilityFactory-class.html) (in the PipServices 'Observability' package)
/// See [DefaultLogicFactory](https://pub.dev/documentation/pip_services4_logic/latest/pip_services4_logic/DefaultLogicFactory-class.html) (in the PipServices 'Logic' package)
/// See [DefaultConfigFactory](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/DefaultConfigFactory-class.html) (in the PipServices 'Config' package)
/// See [DefaultTestFactory](https://pub.dev/documentation/pip_services4_containers/latest/pip_services4_containers/DefaultTestFactory-class.html) (in the PipServices 'Components' package)

class DefaultContainerFactory extends CompositeFactory {
  static final descriptor =
      Descriptor('pip-services', 'factory', 'container', 'default', '1.0');

  /// Create a new instance of the factory and sets nested factories.
  ///
  /// - [factories]     a list of nested factories
  DefaultContainerFactory(List<IFactory> factories) : super(factories) {
    add(DefaultInfoFactory());
    add(DefaultObservabilityFactory());
    add(DefaultLogicFactory());
    add(DefaultConfigFactory());
    add(DefaultTestFactory());
  }
}
