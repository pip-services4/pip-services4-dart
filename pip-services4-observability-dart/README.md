# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> Observability Component definitions for Dart

This module is a part of the [Pip.Services](https://pipservices.org) polyglot microservices toolkit.

The Observability module contains observability component definitions that can be used to build applications and services.

The module contains the following packages:
- **Count** - performance counters
- **Log** - basic logging components that provide console and composite logging, as well as an interface for developing custom loggers
- **Trace** - tracing components

<a name="links"></a> Quick links:

* [Logging](https://www.pipservices.org/recipies/logging)
* [Configuration](https://www.pipservices.org/recipies/configuration) 
* [API Reference](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/pip_services4_observability-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)
* [Examples](https://github.com/pip-services4/pip-services4-dart/blob/main/pip-services4-observability-dart/example/README.md)

## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services4_observability: version
```

Now you can install package from the command line:
```bash
pub get
```

Example how to use Logging and Performance counters.
Here we are going to use CompositeLogger and CompositeCounters components.
They will pass through calls to loggers and counters that are set in references.

```dart
import 'package:pip_services4_components/src/config/ConfigParams.dart';
import 'package:pip_services4_components/src/config/IConfigurable.dart';
import 'package:pip_services4_components/src/refer/IReferences.dart';
import 'package:pip_services4_components/src/refer/IReferenceable.dart';
import 'package:pip_services4_observability/src/log/CompositeLogger.dart';
import 'package:pip_services4_observability/src/count/CompositeCounters.dart';
import 'package:pip_services4_observability/src/count/Timing.dart';


class MyComponent implements IConfigurable, IReferenceable {
  CompositeLogger _logger = CompositeLogger();
  CompositeCounters _counters = CompositeCounters();
  
  configure(ConfigParams config) {
    this._logger.configure(config);
  }
  
  setReferences(IReferences refs) {
    this._logger.setReferences(refs);
    this._counters.setReferences(refs);
  }
  
  myMethod(IContext context, dynamic param1) {
    try{
      this._logger.trace(context, "Executed method mycomponent.mymethod");
      this._counters.increment("mycomponent.mymethod.exec_count", 1);
      Timing timing = this._counters.beginTiming("mycomponent.mymethod.exec_time");
      ....
      timing.endTiming();
    } catch(e) {
      this._logger.error(context, e, "Failed to execute mycomponent.mymethod");
      this._counters.increment("mycomponent.mymethod.error_count", 1);
    }
  }
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
