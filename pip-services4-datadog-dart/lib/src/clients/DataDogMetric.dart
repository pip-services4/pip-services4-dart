import 'DataDogMetricPoint.dart';

class DataDogMetric {
  String? metric;
  String? service;
  String? host;
  Map<String, String>? tags;
  String? type;
  num? interval;
  List<DataDogMetricPoint>? points;

  DataDogMetric(
      {this.metric,
      this.service,
      this.host,
      this.tags,
      this.type,
      this.interval,
      this.points});
}
