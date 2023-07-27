# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> Tokenizers, parsers and expression calculators in Dart

This module is a part of the [Pip.Services](https://pipservices.org) polyglot microservices toolkit.
It provides syntax and lexical analyzers and expression calculator optimized for repeated calculations.

The module contains the following packages:
- **Calculator** - Expression calculator
- **CSV** - CSV tokenizer
- **IO** - input/output utility classes to support lexical analysis
- **Mustache** - Mustache templating engine
- **Tokenizers** - lexical analyzers to break incoming character streams into tokens
- **Variants** - dynamic objects that can hold any values and operators for them

<a name="links"></a> Quick links:

* [API Reference](https://pub.dev/documentation/pip_services4_expressions/latest/pip_services4_expressions/pip_services4_expressions-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)

## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services4_expressions: version
```

Now you can install package from the command line:
```bash
pub get
```

The example below shows how to use expression calculator to dynamically
calculate user-defined expressions.

```dart
import 'package:pip_services4_expressions/src/calculator/calculator.dart';
import 'package:pip_services4_expressions/src/calculator/variables/variables.dart';
import 'package:pip_services4_expressions/src/variants/variants.dart';

...
var calculator = ExpressionCalculator();

calculator.expression = 'A + b / (5 - Max(-123, 1)*2)';

var vars = VariableCollection();
vars.add(Variable('A', Variant('1')));
vars.add(Variable('B', Variant(3)));

var result = await calculator.evaluateWithVariables(vars);
print('The result of the expression is ' +
    result.asString); // The result of the expression is 11
...
```

This is an example to process mustache templates.

```dart
import 'package:pip_services4_expressions/src/mustache/mustache.dart';

var mustache = MustacheTemplate();
mustache.template =
    'Hello, {{{NAME}}}{{#ESCLAMATION}}!{{/ESCLAMATION}}{{#unless ESCLAMATION}}.{{/unless}}';
var result =
    mustache.evaluateWithVariables({'NAME': 'Mike', 'ESCLAMATION': true});
print("The result of template evaluation is '" + result.toString() + "'");
```

For development you shall install the following prerequisites:
* Dart SDK 2
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

The library is created and maintained by **Sergey Seroukhov** and **Danil Prisiazhnyi**.

The documentation is written by **Egor Nuzhnykh**, **Alexey Dvoykin**, **Mark Makarychev**, **Levichev Dmitry**.