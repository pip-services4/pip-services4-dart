import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

class Dummy implements IStringIdentifiable, ICloneable {
  @override
  String? id;
  String? key;
  String? content;

  Dummy({String? id, String? key, String? content})
      : id = id,
        key = key,
        content = content;

  factory Dummy.fromJson(Map<String, dynamic> json) {
    return Dummy(id: json['id'], key: json['key'], content: json['content']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'key': key, 'content': content};
  }

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    content = json['content'];
  }

  @override
  Dummy clone() {
    return Dummy(id: id, key: key, content: content);
  }
}
