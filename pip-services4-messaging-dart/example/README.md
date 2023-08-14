# Examples for Messaging

The Messaging module contains a set of interfaces and classes for working with message queues, as well as an in-memory message queue implementation. It includes:


- **Queues** - contains interfaces for working with message queues, subscriptions for receiving messages from the queue, and an in-memory message queue implementation.

```dart
void main(){
     var envelope1 =
        MessageEnvelope(Context.fromTraceId('123'), 'Test', 'Test message');
    await _queue.send(null, envelope1);

    var count = await _queue.readMessageCount(); // Returns count > 0

    var envelope2 = await _queue.receive(null, 10000); // Returns MessageEnvelope object 
}
```

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services4/pip-services4-dart/pip-services4-messaging-dart/tree/master/test).

