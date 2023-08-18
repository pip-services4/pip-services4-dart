// ignore_for_file: unnecessary_overrides

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_http/pip_services4_http.dart';

class DummyCommandableHttpController extends CommandableHttpController {
  DummyCommandableHttpController() : super('dummy') {
    dependencyResolver.put('service',
        Descriptor('pip-services-dummies', 'service', 'default', '*', '*'));
  }

  @override
  void register() {
    super.register();
  }
}
