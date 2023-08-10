import 'package:pip_services4_grpc/pip_services4_grpc.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

class DummyCommandableGrpcController extends CommandableGrpcController {
  DummyCommandableGrpcController() : super('dummy') {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
  }
}
