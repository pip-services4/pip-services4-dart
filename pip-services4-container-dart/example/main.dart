/// See full source on GitHub
/// [https://github.com/pip-services4/pip-services4-dart/tree/main/pip-services4-container-dart/example]
/// See configuration file (dummy.yaml) in ./config dir
///
import './DummyProcess.dart';

void main(List<String> arguments) {
  try {
    DummyProcess().run(arguments);
  } catch (ex) {
    print(ex);
  }
}
