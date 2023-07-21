import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

///
/// Todo: Rewrite the description
///
/// @preferred
/// Contains a simple object that defines the context of execution. For various
/// logging functions we need to know what source we are logging from – what is
/// the processes name, what the process is/does.

export './ContextInfo.dart';
export './DefaultInfoFactory.dart';
export './IContext.dart';
export './ContextResolver.dart';

/// Basic implementation of an execution context.
///
/// See [IContext]
/// See [AnyValueMap]
///
class Context implements IContext {
  AnyValueMap _values = AnyValueMap();

  Context(AnyValueMap? values) {
    _values = AnyValueMap(values);
  }

  /// Gets a map element specified by its key.
  ///
  /// - [key] a key of the element to get.
  /// Return the value of the map element.
  @override
  get(String key) {
    return _values.get(key);
  }

  /// Creates a new Parameters object filled with key-value pairs from specified object.
  ///
  /// - [value]		an object with key-value pairs used to initialize a new Parameters.
  /// Returns			a new Context object.

  static Context fromValue(value) {
    return Context(value);
  }

  /// Creates a new Context object filled with provided key-value pairs called tuples.
  /// Tuples parameters contain a sequence of key1, value1, key2, value2, ... pairs.
  ///
  /// - [tuples]	the tuples to fill a new Parameters object.
  /// Returns			a new Context object.
  ///
  /// See [StringValueMap.fromTuplesArray]

  static Context fromTuples(List tuples) {
    var map = AnyValueMap.fromTuples(tuples);
    return Context(map);
  }

  /// Creates new Context from ConfigMap object.
  ///
  /// - [config]  a ConfigParams that contain parameters.
  /// Returns a new Context object.

  static Context fromConfig(ConfigParams? config) {
    if (config == null) {
      return Context(null);
    }

    final values = AnyValueMap();
    for (var key in config.keys) {
      if (config.containsKey(key)) {
        values.put(key, config[key]);
      }
    }

    return Context(values);
  }

  /// Creates new Context from trace id.
  ///
  /// - [traceId] a a context to trace execution through call chain.
  /// Returns a new Context object.

  static Context fromTraceId(String traceId) {
    final map = Parameters.fromTuples(["trace_id", traceId]);
    return Context(map);
  }
}
