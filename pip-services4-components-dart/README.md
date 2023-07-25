# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> Portable Component Model for Dart

This module is a part of the [Pip.Services](https://pip.services.org) polyglot microservices toolkit.

It defines a portable component model interfaces and provides utility classes to handle component lifecycle.

The module contains the following packages:
- **Build** - basic factories for constructing objects
- **Config** - configuration pattern
- **Refer** - locator inversion of control (IoC) pattern
- **Run** - component life-cycle management patterns

<a name="links"></a> Quick links:

* [Logging](https://www.pipservices.org/recipies/logging)
* [Configuration](https://www.pipservices.org/recipies/configuration) 
* [API Reference](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/pip_services4_components-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)
* [Examples](https://github.com/pip-services4/pip-services4-dart/pip-services4-components-dart/blob/master/example/README.md)


* Warning!
Config package now not work with condition **{{#if var}} something {{/}}** in config files.
Use **Mustache** syntax, for example **{{#var}} something {{/var}}**

## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services4_components: version
```

Now you can install package from the command line:
```bash
pub get
```

Then you are ready to start using the Pip.Services patterns to augment your backend code.

For instance, here is how you can implement a component, that receives configuration, get assigned references,
can be opened and closed using the patterns from this module.

```dart
class MyComponentA implements IConfigurable, IReferenceable, IOpenable {
  MyComponentA();

  String _param1 = 'ABC';
  int _param2 = 123;
  MyComponentB _anotherComponent;
  bool _opened = true;

  @override
  void configure(ConfigParams config) {
    this._param1 = config.getAsStringWithDefault('param1', this._param1);
    this._param2 = config.getAsIntegerWithDefault('param2', this._param2);
  }

  @override
  void setReferences(IReferences refs) {
    this._anotherComponent = refs.getOneRequired<MyComponentB>(
      Descriptor('myservice', 'mycomponent-b', '*', '*', '1.0')
    );
  }

  @override
  bool isOpen() {
    return this._opened;
  }

  @override
  Future open(IContext? context) {
    return Future(() {
      this._opened = true;
      print('MyComponentA has been opened.');
    });
  }

  @override
  Future close(IContext? context) {
    return Future(() {
      this._opened = true;
      print('MyComponentA has been closed.');
    });
  }
}
```

Then here is how the component can be used in the code

```dart
import 'package:pip_services3_commons/src/config/ConfigParams.dart';
import 'package:pip_services3_commons/src/refer/References.dart';
import 'package:pip_services3_commons/src/refer/DependencyResolver.dart';

var myComponentA = MyComponentA();

// Configure the component
myComponentA.configure(ConfigParams.fromTuples([
  'param1', 'XYZ',
  'param2', 987
]));

// Set references to the component
myComponentA.setReferences(References.fromTuples([
   Descriptor('myservice', 'mycomponent-b', 'default', 'default', '1.0',) myComponentB
]));

// Open the component
myComponentA.open(Context.fromTraceId('123'));
```

If you need to create components using their locators (descriptors) implement 
component factories similar to the example below.

```dart
import 'package:pip_services3_components/src/build/Factory.dart';
import 'package:pip_services3_commons/src/refer/Descriptor.dart';

class MyFactory extends Factory {
  static Descriptor myComponentDescriptor =
      Descriptor('myservice', 'mycomponent', 'default', '*', '1.0');

  MyFactory() : super() {
    registerAsType(MyFactory.myComponentDescriptor, MyComponent);
  }
}

// Using the factory

MyFactory myFactory = MyFactory();

MyComponent1 myComponent1 = myFactory.create(
    Descriptor('myservice', 'mycomponent', 'default', 'myComponent1', '1.0'));
MyComponent2 myComponent2 = myFactory.create(
    Descriptor('myservice', 'mycomponent', 'default', 'myComponent2', '1.0'));
...
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
