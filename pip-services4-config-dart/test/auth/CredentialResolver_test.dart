import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/src/auth/auth.dart';
import 'package:test/test.dart';

void main() {
  group('CredentialResolver', () {
    var restConfig = ConfigParams.fromTuples([
      'credential.username',
      'Negrienko',
      'credential.password',
      'qwerty',
      'credential.access_key',
      'key',
      'credential.store_key',
      'store key'
    ]);

    test('Configure', () {
      var credentialResolver = CredentialResolver(restConfig);
      var configList = credentialResolver.getAll();

      expect(configList[0].get('username'), 'Negrienko');
      expect(configList[0].get('password'), 'qwerty');
      expect(configList[0].get('access_key'), 'key');
      expect(configList[0].get('store_key'), 'store key');
    });

    test('Lookup', () async {
      var credentialResolver = CredentialResolver();
      var credential =
          await credentialResolver.lookup(Context.fromTraceId('context'));
      expect(credential, isNull);

      var RestConfigWithoutStoreKey = ConfigParams.fromTuples([
        'credential.username',
        'Negrienko',
        'credential.password',
        'qwerty',
        'credential.access_key',
        'key'
      ]);
      credentialResolver = CredentialResolver(RestConfigWithoutStoreKey);
      credential =
          await credentialResolver.lookup(Context.fromTraceId('context'));
      expect(credential!.get('username'), 'Negrienko');
      expect(credential.get('password'), 'qwerty');
      expect(credential.get('access_key'), 'key');
      expect(credential.get('store_key'), isNull);

      credentialResolver = CredentialResolver(restConfig);
      credential =
          await credentialResolver.lookup(Context.fromTraceId('context'));
      expect(credential, isNull);

      credentialResolver = CredentialResolver(restConfig);
      credentialResolver.setReferences(References());
      try {
        credential =
            await credentialResolver.lookup(Context.fromTraceId('context'));
      } catch (err) {
        expect(err, isNotNull);
      }
      expect(credential, isNull);
    });
  });
}
