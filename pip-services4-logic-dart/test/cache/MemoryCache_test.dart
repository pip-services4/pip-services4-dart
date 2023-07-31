import 'package:pip_services4_logic/src/cache/cache.dart';
import 'package:test/test.dart';
import './CacheFixture.dart';

void main() {
  group('MemoryCache', () {
    MemoryCache _cache;
    CacheFixture _fixture;

    _cache = MemoryCache();
    _fixture = CacheFixture(_cache);

    test('Store and Retrieve', () {
      _fixture.testStoreAndRetrieve();
    });

    test('Retrieve Expired', () {
      _fixture.testRetrieveExpired();
    });

    test('Remove', () {
      _fixture.testRemove();
    });
  });
}
