import 'package:pip_services4_components/pip_services4_components.dart';

import '../../pip_services4_swagger.dart';

/// Creates Swagger components by their descriptors.
///
/// See [Factory]

class DefaultSwaggerFactory extends Factory {
  static final SwaggerControllerDescriptor =
      Descriptor('pip-services', 'swagger-controller', '*', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultSwaggerFactory() : super() {
    registerAsType(
        DefaultSwaggerFactory.SwaggerControllerDescriptor, SwaggerController);
  }
}
