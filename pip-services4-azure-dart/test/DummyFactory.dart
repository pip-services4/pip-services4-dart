import 'package:pip_services4_components/pip_services4_components.dart';

import 'DummyService.dart';
import 'controllers/DummyCommandableAzureFunctionController.dart';
import 'controllers/DummyAzureFunctionController.dart';

class DummyFactory extends Factory {
  static final descriptor = Descriptor(
      'pip-services-dummies', 'factory', 'default', 'default', '1.0');
  static final ServiceDescriptor =
      Descriptor('pip-services-dummies', 'service', 'default', '*', '1.0');
  static final AzureFunctionControllerDescriptor =
      Descriptor('pip-services-dummies', 'controller', 'azurefunc', '*', '1.0');
  static final CmdAzureFunctionControllerDescriptor = Descriptor(
      'pip-services-dummies',
      'controller',
      'commandable-azurefunc',
      '*',
      '1.0');

  DummyFactory() : super() {
    registerAsType(DummyFactory.ServiceDescriptor, DummyService);
    registerAsType(DummyFactory.AzureFunctionControllerDescriptor,
        DummyAzureFunctionController);
    registerAsType(DummyFactory.CmdAzureFunctionControllerDescriptor,
        DummyCommandableAzureFunctionController);
  }
}
