import 'package:pip_services4_components/pip_services4_components.dart';

import 'Shutdown.dart';

/// Creates test components by their descriptors.
///
/// See [Factory]
/// See [Shutdown]

class DefaultTestFactory extends Factory {
  static final descriptor =
      Descriptor('pip-services', 'factory', 'test', 'default', '1.0');
  static final ShutdownDescriptor =
      Descriptor('pip-services', 'shutdown', '*', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultTestFactory() : super() {
    registerAsType(DefaultTestFactory.ShutdownDescriptor, Shutdown);
  }
}
