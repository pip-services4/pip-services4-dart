# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> Business Logic definitions for Dart

This module is a part of the [Pip.Services](https://pipservices.org) polyglot microservices toolkit.

The Logic module contains standard component definitions to handle complex business transactions.

The module contains the following packages:
- **Cache** - distributed cache
- **Lock** -  distributed lock components
- **State** -  distributed state management components

<a name="links"></a> Quick links:

* [Logging](https://www.pipservices.org/recipies/logging)
* [Configuration](https://www.pipservices.org/recipies/configuration) 
* [API Reference](https://pub.dev/documentation/pip_services4_logic/latest/pip_services4_logic/pip_services4_logic-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)
* [Examples](https://github.com/pip-services4/pip-services4-dart/blob/main/pip-services4-logic-dart/example/README.md)


## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services4_logic: version
```

Now you can install package from the command line:
```bash
pub get
```

Example how to use caching and locking.
Here we assume that references are passed externally.

```dart
import 'package:pip_services4_commons/src/refer/Descriptor.dart';
import 'package:pip_services4_commons/src/refer/References.dart';
import 'package:pip_services4_commons/src/refer/IReferences.dart';
import 'package:pip_services4_commons/src/refer/IReferenceable.dart';
import 'package:pip_services4_logic/src/lock/ILock.dart';
import 'package:pip_services4_logic/src/lock/MemoryLock.dart';
import 'package:pip_services4_logic/src/cache/ICache.dart';
import 'package:pip_services4_logic/src/cache/MemoryCache.dart';

class MyComponent implements IReferenceable {
  ICache? _cache;
  ILock? _lock;

  @override
  void setReferences(IReferences refs) {
    _cache =
        refs.getOneRequired<ICache>(Descriptor('*', 'cache', '*', '*', '1.0'));
    _lock =
        refs.getOneRequired<ILock>(Descriptor('*', 'lock', '*', '*', '1.0'));
  }

  Future myMethod(IContext? context, dynamic param1) async {
    // First check cache for result
    dynamic result = await _cache!.retrieve(context, 'mykey');

    // Lock..
    await _lock!.acquireLock(context, 'mykey', 1000, 1000);

    // Do processing
    // ...

    // Store result to cache async
    await _cache!.store(context, 'mykey', result, 3600000);

    // Release lock async
    await _lock!.releaseLock(context, 'mykey');
  }
}

void main() async {
// Use the component
  MyComponent myComponent = MyComponent();

  myComponent.setReferences(References.fromTuples([
    Descriptor('pip-services', 'cache', 'memory', 'default', '1.0'),
    MemoryCache(),
    Descriptor('pip-services', 'lock', 'memory', 'default', '1.0'),
    MemoryLock(),
  ]));

  await myComponent.myMethod(null, 'param1');
}
```

## Develop

For development you shall install the following prerequisites:
* Dart SDK 3
* Visual Studio Code or another IDE of your choice
* Docker

Install dependencies:
```bash
pub get
```

Run automated tests:
```bash
pub run test
```

Generate API documentation:
```bash
./docgen.ps1
```

Before committing changes run dockerized build and test as:
```bash
./build.ps1
./test.ps1
./clear.ps1
```

## Contacts

The library is created and maintained by **Sergey Seroukhov** and **Levichev Dmitry**.

The documentation is written by **Egor Nuzhnykh**, **Alexey Dvoykin**, **Mark Makarychev**, **Levichev Dmitry**.
