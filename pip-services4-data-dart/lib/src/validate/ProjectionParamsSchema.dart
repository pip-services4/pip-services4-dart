import 'package:pip_services4_commons/pip_services4_commons.dart';
import './ArraySchema.dart';

/// Schema to validate [ProjectionParams]
///
/// See [ProjectionParams]

class ProjectionParamsSchema extends ArraySchema {
  /// Creates a new instance of validation schema.

  ProjectionParamsSchema() : super(TypeCode.String);
}
