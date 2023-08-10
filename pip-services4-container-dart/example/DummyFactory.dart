import 'package:pip_services4_components/pip_services4_components.dart';

import './DummyController.dart';

class DummyFactory extends Factory {
  static var descriptor = Descriptor(
      'pip-services-dummies', 'factory', 'default', 'default', '1.0');
  static var ControllerDescriptor =
      Descriptor('pip-services-dummies', 'controller', 'default', '*', '1.0');

  DummyFactory() : super() {
    registerAsType(DummyFactory.ControllerDescriptor, DummyController);
  }
}
