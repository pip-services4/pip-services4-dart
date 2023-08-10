import 'package:pip_services4_components/pip_services4_components.dart';

import '../controllers/GrpcEndpoint.dart';

/// Creates GRPC components by their descriptors.
///
/// See [Factory](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/Factory-class.html)
/// See [GrpcEndpoint]

class DefaultGrpcFactory extends Factory {
  static final descriptor =
      Descriptor('pip-services', 'factory', 'grpc', 'default', '1.0');
  static final GrpcEndpointDescriptor =
      Descriptor('pip-services', 'endpoint', 'grpc', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultGrpcFactory() : super() {
    registerAsType(DefaultGrpcFactory.GrpcEndpointDescriptor, GrpcEndpoint);
  }
}
