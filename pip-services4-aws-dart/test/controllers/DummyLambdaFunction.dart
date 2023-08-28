import 'package:pip_services4_aws/pip_services4_aws.dart';
import '../DummyFactory.dart';

class DummyLambdaFunction extends LambdaFunction {
  DummyLambdaFunction() : super('dummy', 'Dummy lambda function') {
    factories.add(DummyFactory());
  }

  @override
  void register() {
    // TODO: implement register
  }
}
