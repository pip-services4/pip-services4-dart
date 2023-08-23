import 'package:pip_services4_aws/pip_services4_aws.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'DummyFactory.dart';

class DummyCommandableLambdaFunction extends CommandableLambdaFunction {
  DummyCommandableLambdaFunction() : super('dummy', 'Dummy lambda function') {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
    factories.add(DummyFactory());
  }
}

//export const handler = new DummyCommandableLambdaFunction().getHandler();
