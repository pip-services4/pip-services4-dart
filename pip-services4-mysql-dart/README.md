# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> MySQL components for Pip.Service in Dart

This module is a part of the [Pip.Services](https://pipservices.org) polyglot microservices toolkit.

The module contains the following packages:
 
- **Build** - a standard factory for constructing components
- **Connect** - instruments for configuring connections to the database.
- **Persistence** - abstract classes for working with the database that can be used for connecting to collections and performing basic CRUD operations

<a name="links"></a> Quick links:

* [Configuration](https://docs.pipservices.org/toolkit/getting_started/configurations/)
* [API Reference](https://pub.dev/documentation/pip_services4_mysql/latest/pip_services4_mysql/pip_services4_mysql-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://docs.pipservices.org/get_help/)
* [Contribute](https://docs.pipservices.org/toolkit/contribute/)

## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services4_mysql: version
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

The module is created and maintained by 
- **Sergey Seroukhov**
- **Danil Prisiazhnyi**