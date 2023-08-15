import 'package:pip_services4_components/pip_services4_components.dart';
import '../connect/MySqlConnection.dart';

/// Creates MySql components by their descriptors.
///
/// See [Factory]
/// See [MySqlConnection]
class DefaultMySqlFactory extends Factory {
  static var MySqlConnectionDescriptor =
      Descriptor("pip-services", "connection", "mysql", "*", "1.0");

  ///  Create a new instance of the factory.
  DefaultMySqlFactory() : super() {
    registerAsType(
        DefaultMySqlFactory.MySqlConnectionDescriptor, MySqlConnection);
  }
}
