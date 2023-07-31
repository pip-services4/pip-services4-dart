import 'package:pip_services4_components/pip_services4_components.dart';

import '../cache/cache.dart';
import '../lock/index.dart';
import '../state/state.dart';

/// Creates observability components by their descriptors.
///
/// See [Factory]
/// See [ICache]
/// See [MemoryCache]
/// See [NullCache]
class DefaultLogicFactory extends Factory {
  static final descriptor =
      Descriptor('pip-services', 'factory', 'logic', 'default', '1.0');
  static final NullCacheDescriptor =
      Descriptor('pip-services', 'cache', 'null', '*', '1.0');
  static final MemoryCacheDescriptor =
      Descriptor('pip-services', 'cache', 'memory', '*', '1.0');
  static final NullLockDescriptor =
      Descriptor('pip-services', 'lock', 'null', '*', '1.0');
  static final MemoryLockDescriptor =
      Descriptor('pip-services', 'lock', 'memory', '*', '1.0');
  static final NullStateStoreDescriptor =
      Descriptor('pip-services', 'state-store', 'null', '*', '1.0');
  static final MemoryStateStoreDescriptor =
      Descriptor('pip-services', 'state-store', 'memory', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultLogicFactory() : super() {
    registerAsType(DefaultLogicFactory.NullCacheDescriptor, NullCache);
    registerAsType(DefaultLogicFactory.MemoryCacheDescriptor, MemoryCache);
    registerAsType(DefaultLogicFactory.NullLockDescriptor, NullLock);
    registerAsType(DefaultLogicFactory.MemoryLockDescriptor, MemoryLock);
    registerAsType(
        DefaultLogicFactory.NullStateStoreDescriptor, NullStateStore);
    registerAsType(
        DefaultLogicFactory.MemoryStateStoreDescriptor, MemoryStateStore);
  }
}
