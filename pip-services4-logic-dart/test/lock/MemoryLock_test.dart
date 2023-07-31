import 'package:pip_services4_logic/src/lock/index.dart';
import 'package:test/test.dart';
import './LockFixture.dart';

void main() {
  group('MemoryLock', () {
    MemoryLock _lock;
    LockFixture _fixture;

    _lock = MemoryLock();
    _fixture = LockFixture(_lock);
    test('Try Acquire Lock', () {
      _fixture.testTryAcquireLock();
    });

    _lock = MemoryLock();
    _fixture = LockFixture(_lock);
    test('Acquire Lock', () {
      _fixture.testAcquireLock();
    });

    _lock = MemoryLock();
    _fixture = LockFixture(_lock);
    test('Release Lock', () {
      _fixture.testReleaseLock();
    });
  });
}
