# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> Config components definitions for Dart

This module is a part of the [Pip.Services](https://pipservices.org) polyglot microservices toolkit.

The Config module contains configuration component definitions that can be used to build applications and services.

The module contains the following packages:
- **Auth** - authentication credential stores
- **Config** - configuration readers and managers, whose main task is to deliver configuration parameters to the application from wherever they are being stored
- **Connect** - connection discovery and configuration services

<a name="links"></a> Quick links:

* [Logging](https://www.pipservices.org/recipies/logging)
* [Configuration](https://www.pipservices.org/recipies/configuration) 
* [API Reference](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/pip_services4_config-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)
* [Examples](https://github.com/pip-services4/pip-services4-dart/blob/main/pip-services4-config-dart/example/README.md)


* Warning!
Config package now not work with condition **{{#if var}} something {{/}}** in config files.
Use **Mustache** syntax, for example **{{#var}} something {{/var}}**

## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services4_config: version
```

Now you can install package from the command line:
```bash
pub get
```

Example how to get connection parameters and credentials using resolvers.
The resolvers support "discovery_key" and "store_key" configuration parameters
to retrieve configuration from discovery services and credential stores respectively.

```dart
import 'package:pip_services4_commons/src/config/ConfigParams.dart';
import 'package:pip_services4_commons/src/config/IConfigurable.dart';
import 'package:pip_services4_commons/src/refer/IReferences.dart';
import 'package:pip_services4_commons/src/refer/IReferenceable.dart';
import 'package:pip_services4_commons/src/run/IOpenable.dart';
import 'package:pip_services4_config/src/connect/ConnectionParams.dart';
import 'package:pip_services4_config/src/connect/ConnectionResolver.dart';
import 'package:pip_services4_config/src/auth/CredentialParams.dart';
import 'package:pip_services4_config/src/auth/CredentialResolver.dart';

class MyComponent implements IConfigurable, IReferenceable, IOpenable {
  final _connectionResolver = ConnectionResolver();
  final _credentialResolver = CredentialResolver();
  bool _opened = false;

  @override
  void configure(ConfigParams config) {
    _connectionResolver.configure(config);
    _credentialResolver.configure(config);
  }

  @override
  void setReferences(IReferences refs) {
    _connectionResolver.setReferences(refs);
    _credentialResolver.setReferences(refs);
  }

  // ...
  @override
  Future open(IContext? context) async {
    ConnectionParams? connection =
        await _connectionResolver.resolve(context);

    CredentialParams? credential =
        await _credentialResolver.lookup(context);

    if (connection != null && credential != null) {
      String? host = connection.getHost();
      int? port = connection.getPort();
      String? user = credential.getUsername();
      String? pass = credential.getPassword();
      // ...
      _opened = true;
    }
  }
}

// Using the component
var myComponent = new MyComponent();

myComponent.configure(ConfigParams.fromTuples(
  'connection.host', 'localhost',
  'connection.port', 1234,
  'credential.username', 'anonymous',
  'credential.password', 'pass123'
));

await myComponent.open(null);

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
