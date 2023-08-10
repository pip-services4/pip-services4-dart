import 'package:pip_services4_container/src/refer/refer.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:test/test.dart';
import 'package:pip_services4_components/pip_services4_components.dart';

void main() {
  group('ManagedReferences', () {
    test('Auto Create Component', () {
      var refs = ManagedReferences([]);

      var factory = DefaultObservabilityFactory();
      refs.put(null, factory);

      var logger = refs
          .getOneRequired<ILogger>(Descriptor('*', 'logger', '*', '*', '*'));
      expect(logger, isNotNull);
    });

    test('String Locator', () {
      var refs = ManagedReferences([]);

      var factory = DefaultObservabilityFactory();
      refs.put(null, factory);

      var component = refs.getOneOptional('ABC');
      expect(component, isNull);
    });

    test('Null Locator', () {
      var refs = ManagedReferences([]);

      var factory = DefaultObservabilityFactory();
      refs.put(null, factory);

      var component = refs.getOneOptional(null);
      expect(component, isNull);
    });
  });
}
