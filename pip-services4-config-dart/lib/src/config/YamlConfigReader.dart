import 'dart:async';
import 'dart:io';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:yaml/yaml.dart';
import '../../pip_services4_config.dart';

/// Config reader that reads configuration from YAML file.
///
/// The reader supports parameterization using Handlebars template engine.
///
/// ### Configuration parameters ###
///
/// - [path]:          path to configuration file
/// - [parameters]:    this entire section is used as template parameters
/// - ...
///
/// See [IConfigReader]
/// See [FileConfigReader]
///
/// ### Example ###
///
///     ======== config.yml ======
///     key1: '{{KEY1_VALUE}}'
///     key2: '{{KEY2_VALUE}}'
///     ===========================
///
///     var configReader = YamlConfigReader('config.yml');
///
///     var parameters = ConfigParams.fromTuples('KEY1_VALUE', 123, 'KEY2_VALUE', 'ABC');
///     var config = await configReader.readConfig('123', parameters)
///         // Result: key1=123;key2=ABC
///
///
class YamlConfigReader extends FileConfigReader {
  /// Creates a new instance of the config reader.
  ///
  /// - [path]  (optional) a path to configuration file.
  YamlConfigReader([String? path]) : super(path);

  /// Reads configuration file, parameterizes its content and converts it into JSON object.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [parameters]        values to parameters the configuration.
  /// Return                 a JSON object with configuration.
  dynamic readObject(IContext? context, ConfigParams parameters) {
    if (super.getPath() == null) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_PATH',
          'Missing config file path');
    }

    try {
      // Todo: make this async?
      String? content = File(super.getPath()!).readAsStringSync();
      content = parameterize(content, parameters);
      var data = content != null ? loadYaml(content) : null;
      return data;
    } catch (e) {
      throw FileException(
              context != null ? ContextResolver.getTraceId(context) : null,
              'READ_FAILED',
              'Failed reading configuration ${super.getPath()!}: $e')
          .withDetails('path', super.getPath())
          .withCause(e);
    }
  }

  /// Reads configuration and parameterize it with given values.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [parameters]        values to parameters the configuration or null to skip parameterization.
  /// Return          callback function that receives configuration or error.
  @override
  Future<ConfigParams> readConfig(
      IContext? context, ConfigParams parameters) async {
    var value = readObject(context, parameters);
    var config = ConfigParams.fromValue(value);
    return config;
  }

  /// Reads configuration file, parameterizes its content and converts it into JSON object.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [file]              a path to configuration file.
  /// - [parameters]        values to parameters the configuration.
  /// Return                 a JSON object with configuration.
  static dynamic readObject_(
      IContext? context, String path, ConfigParams parameters) {
    return YamlConfigReader(path).readObject(context, parameters);
  }

  /// Reads configuration from a file, parameterize it with given values and returns a new ConfigParams object.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [file]              a path to configuration file.
  /// - [parameters]        values to parameters the configuration or null to skip parameterization.
  /// Return          callback function that receives configuration or error.
  static ConfigParams readConfig_(
      IContext? context, String path, ConfigParams parameters) {
    var value = YamlConfigReader(path).readObject(context, parameters);
    var config = ConfigParams.fromValue(value);
    return config;
  }
}
