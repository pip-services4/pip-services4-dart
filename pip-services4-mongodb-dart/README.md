# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> MongoDB components for Dart

This module is a part of the [Pip.Services](https://pipservices.org) polyglot microservices toolkit. It provides a set of components to implement MongoDB persistence.

The module contains the following packages:
- **Build** - Factory to create MongoDB persistence components.
- **Connect** - Connection component to configure MongoDB connection to database.
- **Persistence** - abstract persistence components to perform basic CRUD operations.

<a name="links"></a> Quick links:

* [MongoDB persistence](https://www.pipservices.org/recipies/mongodb-persistence)
* [Configuration](https://www.pipservices.org/recipies/configuration)
* [API Reference](https://pub.dev/documentation/pip_services4_mongodb/latest/pip_services4_mongodb/pip_services4_mongodb-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)

## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services4_mongodb: version
```

Now you can install package from the command line:
```bash
pub get
```

As an example, lets create persistence for the following data object.

```dart
import 'package:pip_services4_data/src/data/IIdentifiable.dart';

class MyObject implements IIdentifiable<String> {
  String id;
  String key;
  int value;
}

```

The persistence component shall implement the following interface with a basic set of CRUD operations.

```dart
abstract class IMyPersistence {
    void getPageByFilter(IContext? context, FilterParams filter, PagingParams paging);
    
    getOneById(IContext? context, String id);
    
    getOneByKey(IContext? context, String key;
    
    create(IContext? context, MyObject item);
    
    update(IContext? context, MyObject item);
    
    deleteById(IContext? context, String id);
}
```

To implement mongodb persistence component you shall inherit `IdentifiableMongoDbPersistence`. 
Most CRUD operations will come from the base class. You only need to override `getPageByFilter` method with a custom filter function.
And implement a `getOneByKey` custom persistence method that doesn't exist in the base class.

```dart
import 'package:pip_services4_data/src/data/FilterParams.dart';
import 'package:pip_services4_data/src/data/PagingParams.dart';
import 'package:pip_services4_mongodb/src/persistence/IdentifiableMongoDbPersistence.dart';


class MyMongoDbPersistence extends IdentifiableMongoDbPersistence {
  MyMongoDbPersistence():super("myobjects"){
    this.ensureIndex({{ "key": 1 }, { "unique": true }});
  }

  composeFilter(FilterParams filter) {
    filter = filter!=null ? filter : new FilterParams();
    
    List criteria = [];

    String id = filter.getAsNullableString('id');
    if (id != null)
        criteria.add({ "_id": id });

    String tempIds = filter.getAsNullableString("ids");
    if (tempIds != null) {
        List ids = tempIds.split(",");
        criteria.add({ "_id": { "\$in": ids } });
    }

    String key = filter.getAsNullableString("key");
    if (key != null)
        criteria.add({ "key": key });

    return criteria.length > 0 ? { "\$and": criteria } : null;
  }
  
  Future<DataPage<MyData>> getPageByFilter(IContext? context, FilterParams filter, PagingParams paging){
    return super.getPageByFilterEx(context, composeFilter(filter), paging, null);
  } 
  
  getOneByKey(IContext? context, String key) async {
    
    Map<String, String> filter = { key: key };

    Map<String, dynamic> item = await this.collection.findOne(filter);

    if (item == null)
      this.logger.trace(context, "Nothing found from %s with key = %s", [this.collectionName, key]);
    else
      this.logger.trace(context, "Retrieved from %s with key = %s", [this.collectionName, key]);

    item = this.convertToPublic(item);
  }
}
```

Configuration for your microservice that includes mongodb persistence may look the following way.

```yaml
...
{{#if MONGODB_ENABLED}}
- descriptor: pip-services:connection:mongodb:con1:1.0
  connection:
    uri: {{{MONGO_SERVICE_URI}}}
    host: {{{MONGO_SERVICE_HOST}}}{{#unless MONGO_SERVICE_HOST}}localhost{{/unless}}
    port: {{MONGO_SERVICE_PORT}}{{#unless MONGO_SERVICE_PORT}}27017{{/unless}}
    database: {{MONGO_DB}}{{#unless MONGO_DB}}app{{/unless}}
  credential:
    username: {{MONGO_USER}}
    password: {{MONGO_PASS}}
    
- descriptor: myservice:persistence:mongodb:default:1.0
  dependencies:
    connection: pip-services:connection:mongodb:con1:1.0
  collection: {{MONGO_COLLECTION}}{{#unless MONGO_COLLECTION}}myobjects{{/unless}}
{{/if}}
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

The library is created and maintained by 
- **Sergey Seroukhov**
- **Levichev Dmitry**.

The documentation is written by 
- **Mark Makarychev**
- **Levichev Dmitry**.
