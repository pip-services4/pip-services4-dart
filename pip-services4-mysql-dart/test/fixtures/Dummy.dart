import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

class Dummy implements IStringIdentifiable, ICloneable {
  @override
  String? id;
  String? key;
  String? content;

  Dummy();

  Dummy.from(this.id, this.key, this.content);

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
    return Dummy.from(id, key, content);
  }
}
