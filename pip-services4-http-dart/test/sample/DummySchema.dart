import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

import 'SubDummySchema.dart';

class DummySchema extends ObjectSchema {
  DummySchema() : super() {
    withOptionalProperty('id', TypeCode.String);
    withRequiredProperty('key', TypeCode.String);
    withOptionalProperty('content', TypeCode.String);
    withOptionalProperty('array', ArraySchema(SubDummySchema()));
  }
}
