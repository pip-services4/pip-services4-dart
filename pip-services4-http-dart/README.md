# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> HTTP/REST Communication Components for Dart

This module is a part of the [Pip.Services](https://pipservices.org) polyglot microservices toolkit.

The http module provides the synchronous communication using local calls or the HTTP(S) protocol. It contains both server and client side implementations.

The module contains the following packages:
- **Auth** - authentication and authorization components
- **Build** - HTTP service factory
- **Clients** - mechanisms for retrieving connection settings from the microservice’s configuration and providing clients and services with these settings
- **Controller** - basic implementation of controllers for connecting via the HTTP/REST protocol and using the Commandable pattern over HTTP

<a name="links"></a> Quick links:

* [Your first microservice in Dart](https://www.pipservices.org/docs/quickstart/dart) 
* [Data Microservice. Step 5](https://docs.pipservices.org/toolkit/tutorials/data_microservice/step5/)
* [Microservice Facade](https://docs.pipservices.org/toolkit/tutorials/microservice_facade/) 
* [Client Library. Step 3](https://docs.pipservices.org/toolkit/tutorials/client_library/step2/)
* [Client Library. Step 4](https://docs.pipservices.org/toolkit/tutorials/client_library/step3/)
* [API Reference](https://pub.dev/documentation/pip_services4_http/latest/pip_services4_http/pip_services4_http-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)

## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services4_http: version
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
- **Aleksey Dvoykin**

The documentation is written by:
- **Mark Makarychev**
- **Levichev Dmitry**
