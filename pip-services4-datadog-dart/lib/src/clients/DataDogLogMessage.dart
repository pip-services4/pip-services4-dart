class DataDogLogMessage {
  DateTime? time;
  Map<String, String>? tags;
  String? status;
  String? source;
  String? service;
  String? host;
  String? message;
  String? logger_name;
  String? thread_name;
  String? error_message;
  String? error_kind;
  String? error_stack;

  DataDogLogMessage(
      {this.time,
      this.tags,
      this.status,
      this.source,
      this.service,
      this.host,
      this.message,
      this.logger_name,
      this.thread_name,
      this.error_message,
      this.error_kind,
      this.error_stack});
}
