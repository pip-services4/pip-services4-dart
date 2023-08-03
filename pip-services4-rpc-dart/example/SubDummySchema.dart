import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

class SubDummySchema extends ObjectSchema {
  SubDummySchema() : super() {
    withRequiredProperty('key', TypeCode.String);
    withOptionalProperty('content', TypeCode.String);
  }
}
