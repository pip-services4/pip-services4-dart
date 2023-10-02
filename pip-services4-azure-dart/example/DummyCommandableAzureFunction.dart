import 'package:pip_services4_azure/pip_services4_azure.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import './DummyFactory.dart';

class DummyCommandableAzureFunction extends CommandableAzureFunction {
  DummyCommandableAzureFunction() : super('dummy', 'Dummy Azure Function') {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
    factories.add(DummyFactory());
  }
}
