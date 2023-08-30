import 'package:pip_services4_components/pip_services4_components.dart';
import '../count/DataDogCounters.dart';
import '../log/DataDogLogger.dart';

/// Creates DataDog components by their descriptors.
///
/// see [DataDogLogger]
class DefaultDataDogFactory extends Factory {
  static final DataDogLoggerDescriptor =
      Descriptor('pip-services', 'logger', 'datadog', '*', '1.0');
  static final DataDogCountersDescriptor =
      Descriptor('pip-services', 'counters', 'datadog', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultDataDogFactory() : super() {
    registerAsType(
        DefaultDataDogFactory.DataDogLoggerDescriptor, DataDogLogger);
    registerAsType(
        DefaultDataDogFactory.DataDogCountersDescriptor, DataDogCounters);
  }
}
