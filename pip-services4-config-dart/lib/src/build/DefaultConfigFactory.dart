import 'package:pip_services4_components/pip_services4_components.dart';
import '../auth/MemoryCredentialStore.dart';
import '../config/config.dart';
import '../connect/MemoryDiscovery.dart';

/// Creates [ICredentialStore] components by their descriptors.
///
/// See [IFactory]
/// See [ICredentialStore]
/// See [MemoryCredentialStore]
class DefaultConfigFactory extends Factory {
  static final MemoryCredentialStoreDescriptor =
      Descriptor('pip-services', 'credential-store', 'memory', '*', '1.0');
  static final MemoryConfigReaderDescriptor =
      Descriptor('pip-services', 'config-reader', 'memory', '*', '1.0');
  static final JsonConfigReaderDescriptor =
      Descriptor('pip-services', 'config-reader', 'json', '*', '1.0');
  static final YamlConfigReaderDescriptor =
      Descriptor('pip-services', 'config-reader', 'yaml', '*', '1.0');
  static final MemoryDiscoveryDescriptor =
      Descriptor('pip-services', 'discovery', 'memory', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultConfigFactory() : super() {
    registerAsType(DefaultConfigFactory.MemoryCredentialStoreDescriptor,
        MemoryCredentialStore);
    registerAsType(
        DefaultConfigFactory.MemoryConfigReaderDescriptor, MemoryConfigReader);
    registerAsType(
        DefaultConfigFactory.JsonConfigReaderDescriptor, JsonConfigReader);
    registerAsType(
        DefaultConfigFactory.YamlConfigReaderDescriptor, YamlConfigReader);
    registerAsType(
        DefaultConfigFactory.MemoryDiscoveryDescriptor, MemoryDiscovery);
  }
}
