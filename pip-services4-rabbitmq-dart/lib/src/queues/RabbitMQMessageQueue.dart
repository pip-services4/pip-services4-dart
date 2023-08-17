import 'dart:async';

import 'package:dart_amqp/dart_amqp.dart' as amqp;
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_config/pip_services4_config.dart';
import 'package:pip_services4_messaging/pip_services4_messaging.dart';
import '../connect/RabbitMQConnectionResolver.dart';

///  Message queue that sends and receives messages via RabbitMQ message broker.
///  RabbitMQ is a popular light-weight protocol to communicate.
///  Configuration parameters:
///
///  [connection(s)]:
///  - [discovery_key]:               (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///  - [host]:                        host name or IP address
///  - [port]:                        port number
///  - [uri]:                         resource URI or connection string with all parameters in it
/// - [credential(s)]:
///  - [store_key]:                   (optional) a key to retrieve the credentials from [ICredentialStore](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/ICredentialStore-class.html)
///  - [username]:                    user name
///  - [password]:                    user password
///
///  References:
///
///  - *:logger:*:*:1.0             (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
///  - *:counters:*:*:1.0           (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
///  - *:discovery:*:*:1.0          (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connections
///  - *:credential-store:*:*:1.0   (optional) Credential stores to resolve credentials
///
///  var queue = RabbitMQMessageQueue('my_queue');
///  queue.configure(ConfigParams.fromTuples([
///  'topic', 'mytopic',
///  'connection.protocol', 'amqp'
///  'connection.host', 'localhost'
///  'connection.port', 5672 ]));
///  await queue.open(Context.fromTraceId('123'));
///
///  await queue.send(Context.fromTraceId('123'), MessageEnvelop(Context.fromTraceId('123'), 'mymessage', 'ABC'));
///  await queue.receive(Context.fromTraceId('123'), 0);
///  await queue.complete(Context.fromTraceId('123'), message);

class RabbitMQMessageQueue extends MessageQueue {
  final _defaultCheckinterval = 1000;
  amqp.Client? _connection;
  amqp.Channel? _mqChanel;
  final RabbitMQConnectionResolver _optionsResolver;
  String? _queueName;
  String? _exchangeName;
  amqp.Queue? _queue;
  amqp.Exchange? _exchange;
  amqp.ExchangeType _exchangeType = amqp.ExchangeType.FANOUT;
  amqp.Consumer? _consumer;
  String? _routingKey;
  bool _persistent = false;
  bool _exclusive = false;
  bool _autoCreate = false;
  bool _autoDelete = false;
  bool _noQueue = false;
  late int interval;

  /// Creates a new instance of the message _queue.
  /// - [name]  (optional) a queue name.
  /// - [config] (optional)
  /// - [mqChanel] (optional) RrabbitMQ chanel
  /// - [queue] (optional)  RrabbitMQ queue name
  RabbitMQMessageQueue(String name,
      {ConfigParams? config, amqp.Channel? mqChanel, String? queue})
      : _optionsResolver = RabbitMQConnectionResolver(),
        super() {
    capabilities = MessagingCapabilities(
        true, true, false, false, false, false, true, false, true);
    interval = _defaultCheckinterval;
    if (config != null) {
      configure(config);
    }
    _mqChanel = mqChanel;
    _queueName = queue;
  }

  ///  Configures component by passing configuration parameters.
  /// - [config] configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    super.configure(config);

    interval = config.getAsLongWithDefault('interval', _defaultCheckinterval);

    _queueName = config.getAsNullableString('queue') ?? _queueName;
    _exchangeName = config.getAsNullableString('exchange') ?? _exchangeName;

    _exchangeType = amqp.ExchangeType.valueOf(config.getAsStringWithDefault(
        'options.exchange_type', _exchangeType.toString()));
    _routingKey =
        config.getAsNullableString('options.routing_key') ?? _routingKey;
    _persistent =
        config.getAsBooleanWithDefault('options.persistent', _persistent);
    _exclusive =
        config.getAsBooleanWithDefault('options.exclusive', _exclusive);
    _autoCreate =
        config.getAsBooleanWithDefault('options.auto_create', _autoCreate);
    _autoDelete =
        config.getAsBooleanWithDefault('options.auto_delete', _autoDelete);
    _noQueue = config.getAsBooleanWithDefault('options.no_queue', _noQueue);
  }

  void _checkOpened(IContext? context) {
    if (_mqChanel == null) {
      throw InvalidStateException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NOT_OPENED',
          'The _queue is not opened');
    }
  }

  ///  Checks if the component is opened.
  ///  Retruns true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return _connection != null && _mqChanel != null;
  }

  ///  Opens the component with given _connection and credential parameters.
  ///  - [context]     (optional) a context to trace execution through call chain.
  ///  - [connection] connection parameters
  ///  - [credential] credential parameters
  /// Return            Future that recive null if all ok
  /// Throws error
  @override
  Future openWithParams(IContext? context, ConnectionParams? connection,
      CredentialParams? credential) async {
    var options =
        await _optionsResolver.compose(context, connection, credential);

    if (_queueName == null && _exchangeName == null) {
      throw ConfigException(
          context != null ? ContextResolver.getTraceId(context) : null,
          'NO_QUEUE',
          'Queue or exchange are not defined in connection parameters');
    }

    var settings = amqp.ConnectionSettings();
    var uri = Uri();
    var url = options.get('uri');
    uri = uri.resolve(url!);
    settings.host = uri.host;
    settings.port = uri.port;
    if (uri.userInfo != '') {
      var auth = amqp.PlainAuthenticator(
          options.get('username')!, options.get('password')!);
      settings.authProvider = auth;
    }

    _connection = amqp.Client(settings: settings);
    await _connection!.connect();

    _mqChanel = await _connection!.channel();

    // Automatically create queue, exchange and binding
    if (_autoCreate) {
      if (_exchangeName != null) {
        _exchange = await _mqChanel!
            .exchange(_exchangeName!, _exchangeType, durable: _persistent);
      }
      if (!_noQueue) {
        if (_queueName == null) {
          _queue = await _mqChanel!.queue('',
              durable: _persistent,
              autoDelete: true,
              exclusive: true,
              noWait: false);

          _queueName = _queue?.name;
        } else {
          _queue = await _mqChanel!.queue(_queueName!,
              durable: _persistent,
              exclusive: _exclusive,
              autoDelete: _autoDelete,
              noWait: false);
        }

        _queue =
            await _queue!.bind(_exchange!, _routingKey ?? '', noWait: false);
      }
    }
    return null;
  }

  /// Close method are closes component and frees used resources.
  ///  Parameters:
  ///   - [context]     (optional) a context to trace execution through call chain.
  /// Return            Future that recive null if all ok
  /// Throws error
  @override
  Future close(IContext? context) async {
    if (_mqChanel != null) {
      await _mqChanel!.close();
    }

    if (_connection != null) {
      await _connection!.close();
    }
    _connection = null;
    _mqChanel = null;
    logger.trace(context, 'Closed _queue %s', [_queue]);
  }

  /// ReadMessageCount method are reads the current number of messages in the _queue to be delivered.
  /// Returns         Future that contains count number of messages
  /// Throws error.
  @override
  Future<int> readMessageCount() async {
    try {
      _checkOpened(null);
    } catch (err) {
      logger.error(
          null, err as Exception, 'RabbitMQMessageQueue:MessageCount: $err');
      rethrow;
    }

    if (_queue == null) {
      return 0;
    }

    return _queue!.messageCount;
  }

  MessageEnvelope? _toMessage(amqp.AmqpMessage? envelope) {
    if (envelope == null) {
      return null;
    }

    var message = MessageEnvelope(
        Context.fromTraceId(envelope.properties?.corellationId ?? ''),
        envelope.properties?.type,
        envelope.payloadAsString);
    message.message_id = envelope.properties?.messageId ?? '';
    message.sent_time = DateTime.now().toUtc();
    message.setReference(envelope);

    return message;
  }

  ///  Send method are sends a message into the _queue.
  ///  Parameters:
  ///  - [context]     (optional) a context to trace execution through call chain.
  ///  - [message] a message envelop to be sent.
  /// Return            Future that recive null if all ok
  /// Throws error
  @override
  Future send(IContext? context, MessageEnvelope message) async {
    _checkOpened(context);

    var messageProperties = amqp.MessageProperties();
    messageProperties.contentType = 'text/plain';

    if (message.trace_id != null) {
      messageProperties.corellationId = message.trace_id;
    }
    if (message.message_id.isNotEmpty) {
      messageProperties.messageId = message.message_id;
    }
    messageProperties.persistent = _persistent;
    if (message.message_type != null) {
      messageProperties.type = message.message_type;
    }
    _queue!.publish(message.message!, properties: messageProperties);

    counters.incrementOne('_queue.$name.sent_messages');
    logger.debug(Context.fromTraceId(message.trace_id ?? ''),
        'Sent message %s via %s', [message, this]);
  }

  ///  Peeks a single incoming message from the queue without removing it.
  ///  If there are no messages available in the queue it returns null.
  ///  Important: This method are not supported in this release!
  ///  Parameters:
  ///  - [context]     (optional) a context to trace execution through call chain.
  /// Return            Future that recive a message
  /// Throws error
  @override
  Future<MessageEnvelope> peek(IContext? context) async {
    // _checkOpened(context);

    // var envelope = _mqChanel.get(_queue, false);
    // var message = _toMessage(envelope);
    // if (message != null) {
    //   logger.trace(
    //       message.trace_id, 'Peeked message %s on %s', [message, name]);
    // }
    // return message;

    throw Exception('Method "peek" are not supported!');
  }

  ///  PeekBatch method are peeks multiple incoming messages from the _queue without removing them.
  ///  If there are no messages available in the _queue it returns an empty list.
  ///  Parameters:
  ///   - [context]     (optional) a context to trace execution through call chain.
  ///   - [messageCount] a maximum number of messages to peek.
  /// Return            Future that recive  a list with messages
  /// Throws error
  @override
  Future<List<MessageEnvelope>> peekBatch(
      IContext? context, int messageCount) async {
//  _checkOpened(context);
// 	var messages = <MessageEnvelope>[];
// 	for (;messageCount > 0;) {
// 		var envelope = _mqChanel.get(_queue, false);
// 		// if getErr != null || !ok {
// 		// 	err = getErr
// 		// 	break
// 		// }
// 		var message = _toMessage(envelope);
// 		messages.add(message);
// 		messageCount--;
// 	}
// 	logger.trace(context, 'Peeked %s messages on %s', [messages.length, name]);
// 	return messages;
    throw Exception('Method "peekBatch" are not supported!');
  }

  ///  Receive method are receives an incoming message and removes it from the _queue.
  ///  Parameters:
  ///  - [context]     (optional) a context to trace execution through call chain.
  ///  - [waitTimeout] a timeout in milliseconds to wait for a message to come.
  /// Return            Future that recive a message
  /// Throws error
  @override
  Future<MessageEnvelope?> receive(IContext? context, int waitTimeout) async {
    _checkOpened(context);

    MessageEnvelope? receivedMessage;

    _consumer ??= await _queue!.consume();

    await Future(() async {
      _consumer!.listen((amqp.AmqpMessage message) {
        message.ack();
        receivedMessage = _toMessage(message);
      });

      var start = 0;
      while (waitTimeout - start > 0 && receivedMessage == null) {
        await Future.delayed(Duration(milliseconds: 100));
        start += 100;
      }
    });

    // await _consumer!.channel.;

    return receivedMessage;
  }

  ///  Renews a lock on a message that makes it invisible from other receivers in the _queue.
  ///  This method is usually used to extend the message processing time.
  ///  Important: This method is not supported by RabbitMQ.
  ///  Parameters:
  ///  - [message] a message to extend its lock.
  ///  - [lockTimeout] a locking timeout in milliseconds.
  /// Return            Future that recive a null if all ok
  /// Throws error
  @override
  Future renewLock(MessageEnvelope message, int lockTimeout) async {
    // Operation is not supported
    return null;
  }

  ///  Returnes message into the queue and makes it available for all subscribers to receive it again.
  ///  This method is usually used to return a message which could not be processed at the moment
  ///  to repeat the attempt.Messages that cause unrecoverable errors shall be removed permanently
  ///  or/and send to dead letter _queue.
  ///  Parameters:
  ///  - [message] a message to return.
  /// Return            Future that recive a null if all ok
  /// Throws error
  @override
  Future abandon(MessageEnvelope message) async {
    _checkOpened(null);

    // Make the message immediately visible
    amqp.AmqpMessage envelope = message.getReference();
    envelope.reject(true);
    message.setReference(null);
    logger.trace(Context.fromTraceId(message.trace_id ?? ''),
        'Abandoned message %s at %s', [message, name]);
    return null;
  }

  ///  Permanently removes a message from the _queue.
  ///  This method is usually used to remove the message after successful processing.
  ///  Parameters:
  ///  - [message] a message to remove.
  /// Return            Future that recive a null if all done
  /// Throws error
  @override
  Future complete(MessageEnvelope message) async {
    _checkOpened(null);

    amqp.AmqpMessage envelope = message.getReference();
    envelope.ack();
    message.setReference(null);
    logger.trace(Context.fromTraceId(message.trace_id ?? ''),
        'Completed message %s at %s', [message, name]);
  }

  ///  Permanently removes a message from the _queue and sends it to dead letter _queue.
  ///  Important: This method is not supported by RabbitMQ.
  ///  Parameters:
  ///  - [message] a message to be removed.
  /// Return            Future that recive a null when all done
  /// Throws error
  @override
  Future moveToDeadLetter(MessageEnvelope message) async {
    _checkOpened(null);
    // Operation is not supported
  }

  ///  Listens for incoming messages and blocks the current thread until _queue is closed.
  /// Parameters:
  ///  - [context]     (optional) a context to trace execution through call chain.
  ///  Returns            Future that recive null on compleate
  /// Throws error
  @override
  Future listen(IContext? context, IMessageReceiver receiver) async {
    try {
      _checkOpened(null);
    } catch (err) {
      logger.error(context, err as Exception,
          'RabbitMQMessageQueue:Listen: Can\'t start listen $err');
      rethrow;
    }

    logger.debug(context, 'Started listening messages at %s', [name]);
    try {
      _consumer = await _queue!.consume();
    } catch (err) {
      logger.error(context, err as Exception,
          'RabbitMQMessageQueue:Listen: Can\'t consume to _queue$err');
      rethrow;
    }

    _consumer!.listen((amqp.AmqpMessage msg) {
      var message = _toMessage(msg);
      counters.incrementOne('_queue.$name.received_messages');
      logger.debug(Context.fromTraceId(message?.trace_id ?? ''),
          'Received message %s via %s', [message, name]);
      try {
        receiver.receiveMessage(message!, this);
      } catch (err) {
        logger.error(
            Context.fromTraceId(message?.trace_id ?? ''),
            err as Exception,
            'Processing received message %s error in _queue %s',
            [message, name]);
      }
      msg.ack();
    });
  }

  ///  Ends listening for incoming messages.
  ///  When this method is call listen unblocks the thread and execution continues.
  ///  Parameters:
  ///  - [context]     (optional) a context to trace execution through call chain.
  /// Return            Future that recive a null when all done
  /// Throws error
  @override
  Future endListen(IContext? context) async {
    if (_consumer != null) {
      try {
        await _consumer!.cancel();
      } catch (ex) {
        logger.error(context, ex as Exception, 'Error while closing consumer.');
      }
    }
  }

  ///  Clear method are clears component state.
  ///  Parameters:
  ///  - [context]     (optional) a context to trace execution through call chain.
  /// Return            Future that recive a null when clean compleate
  /// Throws error
  @override
  Future clear(IContext? context) async {
    _checkOpened(null);

    var count = 0;
    if (_queue != null) {
      count = _queue!.messageCount;
      await _queue!.purge();
    }

    logger.trace(context, 'Cleared  %s messages in _queue %s', [count, name]);
  }
}
