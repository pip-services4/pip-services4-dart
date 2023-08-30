import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';
import 'package:pip_services4_http/pip_services4_http.dart';

import 'DataDogLogMessage.dart';

class DataDogLogClient extends RestClient {
  final _defaultConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'https',
    'connection.host',
    'http-intake.logs.datadoghq.com',
    'connection.port',
    443,
    'credential.internal_network',
    'true'
  ]);
  final _credentialResolver = CredentialResolver();

  DataDogLogClient(ConfigParams? config) : super() {
    if (config != null) configure(config);
    baseRoute = 'v1';
  }

  @override
  void configure(ConfigParams config) {
    config = _defaultConfig.override(config);
    super.configure(config);
    _credentialResolver.configure(config);
  }

  @override
  void setReferences(IReferences references) {
    super.setReferences(references);
    _credentialResolver.setReferences(references);
  }

  @override
  Future open(IContext? context) async {
    final credential = await _credentialResolver.lookup(context);

    if (credential == null || credential.getAccessKey() == null) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_ACCESS_KEY',
          'Missing access key in credentials');
    }

    //headers = headers;
    headers['DD-API-KEY'] = credential.getAccessKey()!;

    await super.open(context);
  }

  String? _convertTags(Map<String, String>? tags) {
    if (tags == null) return null;

    var builder = '';

    for (var key in tags.keys) {
      if (builder != '') {
        builder += ',';
      }
      builder += '$key:${tags[key]}';
    }
    return builder;
  }

  dynamic _convertMessage(DataDogLogMessage message) {
    final result = {
      'timestamp': StringConverter.toString2(message.time ?? DateTime.now()),
      'status': message.status ?? 'INFO',
      'ddsource': message.source ?? 'pip-services',
//            'source': message.source ?? 'pip-services',
      'service': message.service,
      'message': message.message,
    };

    if (message.tags != null) {
      result['ddtags'] = _convertTags(message.tags) ?? '';
    }
    if (message.host != null) {
      result['host'] = message.host!;
    }
    if (message.logger_name != null) {
      result['logger.name'] = message.logger_name!;
    }
    if (message.thread_name != null) {
      result['logger.thread_name'] = message.thread_name!;
    }
    if (message.error_message != null) {
      result['error.message'] = message.error_message!;
    }
    if (message.error_kind != null) {
      result['error.kind'] = message.error_kind!;
    }
    if (message.error_stack != null) {
      result['error.stack'] = message.error_stack!;
    }

    return result;
  }

  List<dynamic> _convertMessages(List<DataDogLogMessage> messages) {
    return messages.map((m) => _convertMessage(m)).toList();
  }

  Future sendLogs(IContext? context, List<DataDogLogMessage> messages) async {
    final data = _convertMessages(messages);

    // Commented instrumentation because otherwise it will never stop sending logs...
    //let timing = this.instrument(context, 'datadog.send_logs');
    try {
      await call('post', 'input', null, {}, data);
    } finally {
      //timing.endTiming();
    }
  }
}
