# Examples for Observability Components

This library has an extensive set of components for working in various fields when creating
microservices, micro-applications and applications. It includes:


- **Build** - factories

- **Count** - performance counters
* Example:

```dart
void main(){
    LogCounters counters;

    var log = NullLogger();
    var refs =
        References.fromTuples([DefaultLoggerFactory.NullLoggerDescriptor, log]);
    counters = LogCounters();
    counters.setReferences(refs);
    counters.last('Test.LastValue', 123);
    counters.last('Test.LastValue', 123456);

    var counter = counters.get('Test.LastValue', CounterType.LastValue);
    
    counter.last; // Return  123456
    counters.incrementOne('Test.Increment');
    counters.increment('Test.Increment', 3);
    counter = counters.get('Test.Increment', CounterType.Increment);
    counters.timestampNow('Test.Timestamp');
    counters.timestampNow('Test.Timestamp');
    counter = counters.get('Test.Timestamp', CounterType.Timestamp);
    counter.time; // Return time
    counters.stats('Test.Statistics', 1);
    counters.stats('Test.Statistics', 2);
    counters.stats('Test.Statistics', 3);
    counter = counters.get('Test.Statistics', CounterType.Statistics);
    counter.average;// Return 2
}
```

- **Log** - logging components
* Example:

```dart
void main(){
    var _logger = ConsoleLogger();
    _logger.setLevel(LogLevel.Trace);
    _logger.fatal(null, null, 'Fatal error message');
    _logger.error(null, null, 'Error message');
    _logger.warn(null, 'Warning message');
    _logger.info(null, 'Information message');
    _logger.debug(null, 'Debug message');
    _logger.trace(null, 'Trace message');

    try {
        // Raise an exception
        throw Exception();
      } catch (err) {
        var ex = ApplicationException().wrap(err);
        _logger.fatal('123', ex, 'Fatal error');
        _logger.error('123', ex, 'Recoverable error');
      }
}
```


In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services4/pip-services4-dart/tree/main/pip-services4-observability-dart/test).

