# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> Azure specific components for Dart

This module is a part of the [Pip.Services](https://pipservices.org) polyglot microservices toolkit.

Contains packages used to create containers and services that do operations via the Azure Function protocol.

The module contains the following packages:
- **Clients** - client components for working with Azure cloud Functions.
- **Connect** - components for installation and connection settings.
- **Containers** - contains classes that act as containers to instantiate and run components.
- **Controllers** - contains interfaces and classes used to create controllers that do operations via the Azure Function protocol.



<a name="links"></a> Quick links:

* [Configuration](https://www.pipservices.org/recipies/configuration)
* [API Reference](https://pub.dev/documentation/pip_services4_azure/latest/pip_services4_azure/pip_services4_azure-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)

## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services4_azure: version
```

Now you can install package from the command line:
```bash
pub get
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

The Dart version of Pip.Services is created and maintained by:
 - **Sergey Seroukhov**
 - **Levichev Dmitry**

 The documentation is written by:
- **Levichev Dmitry**
