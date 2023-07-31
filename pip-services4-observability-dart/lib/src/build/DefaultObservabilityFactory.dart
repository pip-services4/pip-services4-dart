import 'package:pip_services4_components/pip_services4_components.dart';

import '../count/count.dart';
import '../log/log.dart';
import '../trace/trace.dart';

/// Creates observability components by their descriptors.
///
/// See [Factory]
/// See [NullCounters]
/// See [LogCounters]
/// See [CompositeCounters]
/// See [NullLogger]
/// See [ConsoleLogger]
/// See [CompositeLogger]
/// See [NullTracer]
/// See [ConsoleTracer]
/// See [CompositeTracer]
class DefaultObservabilityFactory extends Factory {
  static final NullCountersDescriptor =
      Descriptor('pip-services', 'counters', 'null', '*', '1.0');
  static final LogCountersDescriptor =
      Descriptor('pip-services', 'counters', 'log', '*', '1.0');
  static final CompositeCountersDescriptor =
      Descriptor('pip-services', 'counters', 'composite', '*', '1.0');
  static final NullLoggerDescriptor =
      Descriptor('pip-services', 'logger', 'null', '*', '1.0');
  static final ConsoleLoggerDescriptor =
      Descriptor('pip-services', 'logger', 'console', '*', '1.0');
  static final CompositeLoggerDescriptor =
      Descriptor('pip-services', 'logger', 'composite', '*', '1.0');
  static final NullTracerDescriptor =
      Descriptor('pip-services', 'tracer', 'null', '*', '1.0');
  static final LogTracerDescriptor =
      Descriptor('pip-services', 'tracer', 'log', '*', '1.0');
  static final CompositeTracerDescriptor =
      Descriptor('pip-services', 'tracer', 'composite', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultObservabilityFactory() : super() {
    registerAsType(
        DefaultObservabilityFactory.NullCountersDescriptor, NullCounters);
    registerAsType(
        DefaultObservabilityFactory.LogCountersDescriptor, LogCounters);
    registerAsType(DefaultObservabilityFactory.CompositeCountersDescriptor,
        CompositeCounters);
    registerAsType(
        DefaultObservabilityFactory.NullLoggerDescriptor, NullLogger);
    registerAsType(
        DefaultObservabilityFactory.ConsoleLoggerDescriptor, ConsoleLogger);
    registerAsType(
        DefaultObservabilityFactory.CompositeLoggerDescriptor, CompositeLogger);
    registerAsType(
        DefaultObservabilityFactory.NullTracerDescriptor, NullTracer);
    registerAsType(DefaultObservabilityFactory.LogTracerDescriptor, LogTracer);
    registerAsType(
        DefaultObservabilityFactory.CompositeTracerDescriptor, CompositeTracer);
  }
}
