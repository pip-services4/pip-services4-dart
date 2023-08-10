import 'dart:async';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';
import './ContainerConfig.dart';

/// Helper class that reads container configuration from JSON or YAML file.

class ContainerConfigReader {
  /// Reads container configuration from JSON or YAML file.
  /// The type of the file is determined by file extension.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [path]              a path to component configuration file.
  /// - [parameters]        values to parameters the configuration or null to skip parameterization.
  /// Returns the read container configuration
  static Future<ContainerConfig> readFromFile(
      IContext? context, String? path, ConfigParams parameters) async {
    if (path == null) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_PATH',
          'Missing config file path');
    }

    var ext = path.split('.').last; //.pop();

    if (ext == 'json') {
      return await ContainerConfigReader.readFromJsonFile(
          context, path, parameters);
    }

    if (ext == 'yaml' || ext == 'yml') {
      return await ContainerConfigReader.readFromYamlFile(
          context, path, parameters);
    }

    // By default read as JSON
    return await ContainerConfigReader.readFromJsonFile(
        context, path, parameters);
  }

  /// Reads container configuration from JSON file.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [path]              a path to component configuration file.
  /// - [parameters]        values to parameters the configuration or null to skip parameterization.
  /// Returns the read container configuration
  static Future<ContainerConfig> readFromJsonFile(
      IContext? context, String path, ConfigParams parameters) async {
    var config = JsonConfigReader.readConfig_(context, path, parameters);
    return ContainerConfig.fromConfig(config);
  }

  /// Reads container configuration from YAML file.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [path]              a path to component configuration file.
  /// - [parameters]        values to parameters the configuration or null to skip parameterization.
  /// Returns the read container configuration
  static Future<ContainerConfig> readFromYamlFile(
      IContext? context, String path, ConfigParams parameters) async {
    var config = YamlConfigReader.readConfig_(context, path, parameters);
    return ContainerConfig.fromConfig(config);
  }
}
