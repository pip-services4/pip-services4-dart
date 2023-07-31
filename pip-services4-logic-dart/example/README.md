# Examples for Bussiness Logic Components

This library has an extensive set of components for working in various fields when creating
microservices, micro-applications and applications. It includes:

- **Build** - factories

- **Cache** - distributed cache
* Example:

```dart
void main(){
    String KEY1 = 'key1';
    String VALUE1 = 'value1';

    var _cache = MemoryCache();
     try {
      await _cache.store('123', KEY1, VALUE1, 5000);
    } catch (err) {
      //...
    }

    try {
      var val = await _cache.retrieve('123', KEY1);
      // Expect VALUE1
    } catch (err) {
        //...
    }
}
```

- **Lock** - distributed locks
* Example:

```dart
void main() async {
    final String LOCK1 = 'lock_1';
    var _lock = MemoryLock();
    // Try to acquire lock for the first time
    try {
      var result = await _lock.tryAcquireLock('123', LOCK1, 3000);
      // result True
    } catch (err) {
      //...
    }
    // Try to acquire lock for the second time
    try {
      var result = await _lock.tryAcquireLock('123', LOCK1, 3000);
      // result False
    } catch (err) {
      //...
    }
    // Release the lock
    await _lock.releaseLock('123', LOCK1);
    // Try to acquire lock for the third time
    try {
      var result = await _lock.tryAcquireLock('123', LOCK1, 3000);
      // result True
    } catch (err) {
     //...
    }
    await _lock.releaseLock('123', LOCK1);
}
```

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services4/pip-services4-dart/tree/main/pip-services4-logic-dart/test).

