# Examples for MySql persistence

This component library is a part of the [Pip.Services](https://github.com/pip-services/pip-services) project.
It contains the following MySql components: 
 
 - **MySqlConnectionResolver**
  * Example:
 ```dart 
  class Test {
  var connectionResolver = MySqlConnectionResolver();

  @override
  void configure(ConfigParams config) {
    connectionResolver.configure(config);
    ...
  }

   @override
  void setReferences(IReferences references) {
    connectionResolver.setReferences(references);
    ...
  }

   @override
  Future open(IContext? context) async {
    String uri;
    try {
      uri = await connectionResolver.resolve(context);
    } catch (err) {
      logger.error(context, ApplicationException().wrap(err),
          'Failed to resolve MySql connection');
    }
    ...
  }
}
```

 - **MySqlConnection**

 * Example:
 ```dart
    MySqlConnection connection;

    var mysqlUri = Platform.environment['MYSQL_URI'];
    var mysqlHost = Platform.environment['MYSQL_HOST'] ?? 'localhost';
    var mysqlPort = Platform.environment['MYSQL_PORT'] ?? '27017';
    var mysqlDatabase = Platform.environment['MYSQL_DB'] ?? 'test';
    var mysqlUser = Platform.environment['MYSQL_USER'] ?? 'mysql';
    var mysqlPassword = Platform.environment['MYSQL_PASSWORD'] ?? 'mysql';
   
      var dbConfig = ConfigParams.fromTuples([
        'connection.uri',  mysqlUri,
        'connection.host', mysqlHost,
        'connection.port', mysqlPort,
        'connection.database', mysqlDatabase,
        'credential.username', mysqlUser,
        'credential.password', mysqlPassword
      ]);

      connection = MySqlConnection();
      connection.configure(dbConfig);

      await connection.open(null);
 ```

 - **MySqlPersistence**
 * Example:

```dart
     class MyMySqlPersistence extends MySqlPersistence<MyData> {

       MyMySqlPersistence():base('mydata', null);

       Future<String?> getByName(IContext? context, String name) async {
         var query = "SELECT * FROM " + this.quotedTableName_() + " WHERE id=?";
         var params = [name];
         var res = await client_!.query(query, params);
         if (res.toList().isEmpty)
           this.logger_.trace(context, "Nothing found from %s with name = %s",
               [this.tableName_, name]);
         else
           this.logger_.trace(context, "Retrieved from %s with name = %s",
              [this.tableName_, name]);

        var resValues = res.toList().isNotEmpty ? res.toList()[0].fields : null;
         var item = this.convertToPublic_(resValues);

         return item;
       }

      Future<MyData?> set(IContext? context, MyData item) async {
        if (item == null) {
          return null;
        }

        // Assign unique id
        dynamic newItem = item;
        if (newItem.id == null && this.autoGenerateId_) {
          newItem = (newItem as ICloneable).clone();
          newItem.id = IdGenerator.nextLong();
        }

        var row = this.convertFromPublic_(item);
        var columns = this.generateColumns_(row);
        var params = this.generateParameters_(row);
        var setParams = this.generateSetParameters_(row);
        var values = this.generateValues_(row);
        values.addAll(List.from(values));

        var query = "INSERT INTO " +
            this.quotedTableName_() +
            " (" +
            columns +
            ") VALUES (" +
            params +
            ")";
        query += " ON DUPLICATE KEY UPDATE " + setParams;

        var res = await client_!.query(query, values);

        query = "SELECT * FROM " + this.quotedTableName_() + " WHERE id=?";
        res = await client_!.query(query, [item.id]);

        var resValues = res.toList().isNotEmpty ? res.toList()[0].fields : null;
        newItem = this.convertToPublic_(resValues);

        logger_.trace(context, "Set in %s with id = %s",
            [this.quotedTableName_(), newItem.id]);

        return newItem;
      }
    }

     }

    var persistence = MyMySqlPersistence();
    persistence.configure(ConfigParams.fromTuples(["host", "localhost", "port", 27017]));
    await persistence.open(null);
    var item = await persistence.set(null, MyData());
    print(item);
```

 - **IdentifiableMySqlPersistence**

* Example:
```dart
    class MyMySqlPersistence extends IdentifiableMySqlPersistence<MyData, String> {
      MyMySqlPersistence() : super('mydata', null);

      @override
      void defineSchema_() {
        this.clearSchema();
        this.ensureSchema_('CREATE TABLE `' +
            this.tableName_! +
            '` (id VARCHAR(32) PRIMARY KEY, `key` VARCHAR(50), `content` TEXT)');
        this.ensureIndex_(this.tableName_! + '_key', {'key': 1}, {'unique': true});
      }

      @override
      Future<DataPage<MyData>> getPageByFilter(
          IContext? context, FilterParams? filter, PagingParams? paging) async {
        filter = filter ?? new FilterParams();
        var key = filter.getAsNullableString('key');

        var filterCondition = null;
        if (key != null) {
          filterCondition += "`key`='" + key + "'";
        }

        return super
            .getPageByFilter_(context, filterCondition, paging, null, null);
      }
    }
    var persistence = MyMySqlPersistence();
    persistence
        .configure(ConfigParams.fromTuples(["host", "localhost", "port", 27017]));
    await persistence.open(null);
    var item = await persistence.create(null, MyData());
    var page = await persistence.getPageByFilter(
        null, FilterParams.fromTuples(["key", "ABC"]), null);
    print(page.data);
    var deleted = await persistence.deleteById(null, '1');
```

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services4/pip-services4-dart/tree/main/pip-services4-mysql-dart/test).

