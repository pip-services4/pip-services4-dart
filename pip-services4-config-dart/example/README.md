# Examples for Config

This library has an extensive set of configs for working in various fields when creating
microservices, micro-applications and applications. It includes:


- **Auth** - authentication credential store
* Example:

```dart
void main(){
     var restConfig = ConfigParams.fromTuples([
      'credential.username',
      'Negrienko',
      'credential.password',
      'qwerty',
      'credential.access_key',
      'key',
      'credential.store_key',
      'store key'
    ]);
    var credentialResolver = CredentialResolver(restConfig);
    var configList = credentialResolver.getAll();
    configList[0].get('username'); // Returns 'Negrienko'
    configList[0].get('password'); // Returns 'qwerty'
    configList[0].get('access_key'); // Returns 'key'
    configList[0].get('store_key'); // Returns 'store key'
}
```

- **Build** - factory

- **Config** - configuration reader
* Example:

```dart
void main(){
     var parameters = ConfigParams.fromTuples(
          ['param1', 'Test Param 1', 'param2', 'Test Param 2']);
      var config =
          JsonConfigReader.readConfig_('123', './data/config.json', parameters);

      config.getAsInteger('field1.field11'); // Return 123
      config.get('field1.field12'); // Return 'ABC'
      config.getAsInteger('field2.0'); // Return  123
      config.get('field4'); // Return 'Test Param 1'
      config.get('field5'); // Return 'Test Param 2'
}
```

- **Connect** - connection discovery services
* Example:

```dart
void main(){
    var RestConfig = ConfigParams.fromTuples([
      'connection.protocol',
      'http',
      'connection.host',
      'localhost',
      'connection.port',
      3000
    ]);
    var connectionResolver = ConnectionResolver(RestConfig);
    var configList = connectionResolver.getAll();
    configList[0].get('protocol'); // Return 'http'
    configList[0].get('host'); // Return 'localhost'
    configList[0].get('port'); // Return '3000'
}
```

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services4/pip-services4-dart/tree/main/pip-services4-config-dart/test).

