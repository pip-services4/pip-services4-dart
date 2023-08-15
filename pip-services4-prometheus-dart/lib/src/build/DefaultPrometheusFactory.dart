import 'package:pip_services4_components/pip_services4_components.dart';

import '../count/PrometheusCounters.dart';
import '../controllers/PrometheusMetricsController.dart';

/// Creates Prometheus components by their descriptors.
///
/// See [Factory](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/Factory-class.html)
/// See [PrometheusCounters]
/// See [PrometheusMetricsController]
class DefaultPrometheusFactory extends Factory {
  static final descriptor =
      Descriptor('pip-services', 'factory', 'prometheus', 'default', '1.0');
  static final PrometheusCountersDescriptor =
      Descriptor('pip-services', 'counters', 'prometheus', '*', '1.0');
  static final PrometheusMetricsControllerDescriptor = Descriptor(
      'pip-services', 'metrics-controller', 'prometheus', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultPrometheusFactory() : super() {
    registerAsType(DefaultPrometheusFactory.PrometheusCountersDescriptor,
        PrometheusCounters);
    registerAsType(
        DefaultPrometheusFactory.PrometheusMetricsControllerDescriptor,
        PrometheusMetricsController);
  }
}
