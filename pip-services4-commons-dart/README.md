# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> Portable Core Abstractions for Dart

This module is a part of the [Pip.Services](https://pipservices.org/) polyglot microservices toolkit.
It provides a set of basic patterns used in microservices or backend services.
Also the module implemenets a reasonably thin abstraction layer over most fundamental functions across
all languages supported by the toolkit to facilitate symmetric implementation.

The module contains the following packages:

The module contains the following packages:
- **Convert** - portable value converters
- **Data** - data patterns
- **Errors**- application errors
- **Reflect** - portable reflection utilities

<a name="links"></a> Quick links:

* [Configuration Pattern](https://www.pipservices.org/recipies/configuration) 
* [Locator Pattern](https://www.pipservices.org/recipies/references)
* [Component Lifecycle](https://www.pipservices.org/recipies/component-lifecycle)
* [Components with Active Logic](https://www.pipservices.org/recipies/active-logic)
* [Data Patterns](https://www.pipservices.org/recipies/memory-persistence)
* [API Reference](https://pub.dev/documentation/pip_services4_commons/latest/pip_services4_commons/pip_services4_commons-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)

## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services4_commons: version
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

The library is created and maintained by **Sergey Seroukhov**, **Levichev Dmitry**, **Alexey Dvoykin**.

The documentation is written by **Egor Nuzhnykh**, **Alexey Dvoykin**, **Mark Makarychev**, **Levichev Dmitry**.
