import 'package:pip_services4_aws/src/controllers/CommandableLambdaController.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

class DummyCommandableLambdaController extends CommandableLambdaController {
  DummyCommandableLambdaController() : super('dummies') {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
  }
}
