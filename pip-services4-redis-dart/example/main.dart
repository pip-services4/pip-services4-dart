import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_redis/pip_services4_redis.dart';

void main() async {
  final LOCK1 = 'lock_1';
  final LOCK2 = 'lock_2';

  RedisLock _lock;

  var host = Platform.environment['REDIS_SERVICE_HOST'] ?? 'localhost';
  var port = Platform.environment['REDIS_SERVICE_PORT'] ?? 6379;

  _lock = RedisLock();

  var config = ConfigParams.fromTuples(
      ['connection.host', host, 'connection.port', port]);
  _lock.configure(config);

  await _lock.open(null);

  // Try to acquire lock for the first time
  var result =
      await _lock.tryAcquireLock(Context.fromTraceId('123'), LOCK1, 3000);
  print(result); // true

  // Try to acquire lock for the second time
  result = await _lock.tryAcquireLock(
      Context.fromTraceId('123'), LOCK1, 3000); // false

  // Release the lock
  await _lock.releaseLock(Context.fromTraceId('123'), LOCK1);

  // Acquire lock for the first time
  await _lock.acquireLock(Context.fromTraceId('123'), LOCK2, 3000, 1000);
  // Acquire lock for the second time
  try {
    await _lock.acquireLock(
        Context.fromTraceId('123'), LOCK2, 3000, 1000); // error
  } catch (err) {
    // error handle
  }

  // Release the lock
  await _lock.releaseLock(Context.fromTraceId('123'), LOCK2);

  await _lock.close(null);
}
