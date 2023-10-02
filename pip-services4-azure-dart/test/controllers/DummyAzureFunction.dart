import 'package:pip_services4_azure/pip_services4_azure.dart';
import '../DummyFactory.dart';

class DummyAzureFunction extends AzureFunction {
  DummyAzureFunction() : super('dummy', 'Dummy Azure function') {
    factories.add(DummyFactory());
  }

  @override
  void register() {
    // TODO: implement register
  }
}
