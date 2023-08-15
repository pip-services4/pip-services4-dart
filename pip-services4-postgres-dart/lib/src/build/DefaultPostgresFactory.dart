import 'package:pip_services4_components/pip_services4_components.dart';
import '../connect/PostgresConnection.dart';

/// Creates Postgres components by their descriptors.
///
/// See [Factory]
/// See [PostgresConnection]
class DefaultPostgresFactory extends Factory {
  static final PostgresConnectionDescriptor =
      Descriptor("pip-services", "connection", "postgres", "*", "1.0");

  ///  Create a new instance of the factory.
  DefaultPostgresFactory() : super() {
    registerAsType(DefaultPostgresFactory.PostgresConnectionDescriptor,
        PostgresConnection);
  }
}
