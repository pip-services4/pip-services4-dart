import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_persistence/src/persistence/persistence.dart';

import './DummyMemoryPersistence.dart';
import '../Dummy.dart';

class DummyFilePersistence extends DummyMemoryPersistence {
  final JsonFilePersister<Dummy> _persister;

  DummyFilePersistence([String? path])
      : _persister = JsonFilePersister<Dummy>(path),
        super() {
    loader = _persister;
    saver = _persister;
  }

  @override
  void configure(ConfigParams config) {
    super.configure(config);
    _persister.configure(config);
  }
}
