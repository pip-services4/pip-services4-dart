import 'package:pip_services4_components/pip_services4_components.dart';

import '../connect/MongoDbConnection.dart';

/// Creates MongoDb components by their descriptors.
///
/// See [Factory](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/Factory-class.html)
/// See [MongoDbConnection]
class DefaultMongoDbFactory extends Factory {
  static final descriptor =
      Descriptor('pip-services', 'factory', 'mongodb', 'default', '1.0');
  static final MongoDbConnectionDescriptor =
      Descriptor('pip-services', 'connection', 'mongodb', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultMongoDbFactory() : super() {
    registerAsType(
        DefaultMongoDbFactory.MongoDbConnectionDescriptor, MongoDbConnection);
  }
}
