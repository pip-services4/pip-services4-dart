import 'package:pip_services4_components/pip_services4_components.dart';
import '../controllers/HttpEndpoint.dart';
import '../controllers/HeartbeatRestController.dart';
import '../controllers/StatusRestController.dart';

/// Creates HTTP components by their descriptors.
///
/// See [Factory]
/// See [HttpEndpoint]
/// See [HeartbeatRestController]
/// See [StatusRestController]

class DefaultHttpFactory extends Factory {
  static final HttpEndpointDescriptor =
      Descriptor('pip-services', 'endpoint', 'http', '*', '1.0');
  static final StatusControllerDescriptor =
      Descriptor('pip-services', 'status-controller', 'http', '*', '1.0');
  static final HeartbeatControllerDescriptor =
      Descriptor('pip-services', 'heartbeat-controller', 'http', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultHttpFactory() : super() {
    registerAsType(DefaultHttpFactory.HttpEndpointDescriptor, HttpEndpoint);
    registerAsType(DefaultHttpFactory.HeartbeatControllerDescriptor,
        HeartbeatRestController);
    registerAsType(
        DefaultHttpFactory.StatusControllerDescriptor, StatusRestController);
  }
}
