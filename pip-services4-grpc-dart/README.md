# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> GRPC Communication Components for Dart

This module is a part of the [Pip.Services](https://pipservices.org) polyglot microservices toolkit.

The grpc module is used to organize synchronous data exchange using calls through the gRPC protocol. It has implementations of both the server and client parts.

The module contains the following packages:

- **Build** - factories for creating gRPC services
- **Clients** - basic client components that use the gRPC protocol and Commandable pattern through gRPC
- **Controllers** - basic service implementations for connecting via the gRPC protocol and using the Commandable pattern via gRPC

<a name="links"></a> Quick links:

* [Configuration](https://www.pipservices.org/recipies/configuration)
* [Protocol buffer](https://github.com/pip-services4-dart/pip-services4-grpc-dart/blob/master/lib/src/protos/commandable.proto)
* [gRPC Dart Quick Start](https://grpc.io/docs/quickstart/dart/)
* [Protocol Buffer Basics: Dart](https://developers.google.com/protocol-buffers/docs/darttutorial)
* [API Reference](https://pub.dev/documentation/pip_services4_grpc/latest/pip_services4_grpc/pip_services4_grpc-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)


## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services4_grpc: version
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
- **Mark Makarychev**
- **Levichev Dmitry**