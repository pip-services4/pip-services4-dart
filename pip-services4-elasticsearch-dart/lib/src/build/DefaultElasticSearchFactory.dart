import 'package:pip_services4_components/pip_services4_components.dart';

import '../log/ElasticSearchLogger.dart';

/// Creates ElasticSearch components by their descriptors.
///
/// See [ElasticSearchLogger]
class DefaultElasticSearchFactory extends Factory {
  static final ElasticSearchLoggerDescriptor =
      Descriptor('pip-services', 'logger', 'elasticsearch', '*', '1.0');

  /// Create a new instance of the factory.

  DefaultElasticSearchFactory() : super() {
    registerAsType(DefaultElasticSearchFactory.ElasticSearchLoggerDescriptor,
        ElasticSearchLogger);
  }
}
