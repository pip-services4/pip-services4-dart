import 'package:pip_services4_commons/pip_services4_commons.dart';

/// Data object to store captured log messages.
/// This object is used by [CachedLogger].
// Todo: Make it JSON Serializable
class LogMessage {
  // The time then message was generated
  DateTime? time;
  // The source (context name)
  String? source;
  // This log level
  String? level;
  // The transaction id to trace execution through call chain.
  String? trace_id;

  /// The description of the captured error
  ///
  /// [ErrorDescription](https://pub.dev/documentation/pip_services4_commons/latest/pip_services4_commons/ErrorDescription-class.html)
  /// [ApplicationException](https://pub.dev/documentation/pip_services4_commons/latest/pip_services4_commons/ApplicationException-class.html)

  ErrorDescription? error;
  // The human-readable message
  String message = '';

  LogMessage();

  factory LogMessage.fromJson(Map<String, dynamic> json) {
    var c = LogMessage();
    c.time = json['time'];
    c.source = json['source'];
    c.level = json['level'];
    c.trace_id = json['trace_id'];
    c.error = json['error'];
    c.message = json['message'];
    return c;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'time': time != null
          ? time!.toIso8601String()
          : DateTime.now().toIso8601String(),
      'source': source,
      'level': level,
      'trace_id': trace_id,
      'error': error,
      'message': message
    };
  }

  void fromJson(Map<String, dynamic> json) {
    time = DateTime.parse(json['time']);
    source = json['source'];
    level = json['level'];
    trace_id = json['trace_id'];
    error = json['error'];
    message = json['message'];
  }
}
