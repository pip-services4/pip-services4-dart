import 'package:pip_services4_components/pip_services4_components.dart';

import 'DummyService.dart';

class DummyFactory extends Factory {
  static final descriptor = Descriptor(
      'pip-services-dummies', 'factory', 'default', 'default', '1.0');
  static final ServiceDescriptor =
      Descriptor('pip-services-dummies', 'service', 'default', '*', '1.0');
  static final LambdaControllerDescriptor =
      Descriptor('pip-services-dummies', 'controller', 'awslambda', '*', '1.0');
  static final CmdLambdaControllerDescriptor = Descriptor(
      'pip-services-dummies',
      'controller',
      'commandable-awslambda',
      '*',
      '1.0');

  DummyFactory() : super() {
    registerAsType(DummyFactory.ServiceDescriptor, DummyService);
  }
}
