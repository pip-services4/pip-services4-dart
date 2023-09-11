import 'package:pip_services4_azure/src/controllers/CommandableAzureFunctionController.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

class DummyCommandableAzureFunctionController
    extends CommandableAzureFunctionController {
  DummyCommandableAzureFunctionController() : super('dummies') {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
  }
}
