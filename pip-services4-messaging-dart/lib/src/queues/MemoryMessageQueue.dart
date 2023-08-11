import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_config/pip_services4_config.dart';

import './IMessageReceiver.dart';
import './MessageQueue.dart';
import './MessageEnvelope.dart';
import './MessagingCapabilities.dart';
import './LockedMessage.dart';

/// Message queue that sends and receives messages within the same process by using shared memory.
///
/// This queue is typically used for testing to mock real queues.
///
/// ### Configuration parameters ###
///
/// - [name]:                        name of the message queue
///
/// ### References ###
///
/// - [\*:logger:\*:\*:1.0]           (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - [\*:counters:\*:\*:1.0]         (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
///
/// See [MessageQueue]
/// See [MessagingCapabilities]
///
/// ### Example ###
///
///     var queue = MessageQueue("myqueue");
///
///     await queue.send(Context.fromTraceId("123"), MessageEnvelop(null, "mymessage", "ABC"));
///
///     var message = await queue.receive(Context.fromTraceId("123"));
///     if (message != null) {
///        ...
///        await queue.complete(Context.fromTraceId("123"), message);
///     }
///

class MemoryMessageQueue extends MessageQueue {
  var _messages = <MessageEnvelope?>[];
  int _lockTokenSequence = 0;
  var _lockedMessages = <int, LockedMessage>{};
  bool _opened = false;
  //Used to stop the listening process.
  bool _cancel = false;
  int _listenInterval = 1000;

  /// Creates a new instance of the message queue.
  ///
  /// - [name]  (optional) a queue name.
  ///
  /// See [MessagingCapabilities]
  MemoryMessageQueue([String? name]) : super(name) {
    capabilities = MessagingCapabilities(
        true, true, true, true, true, true, true, false, true);
  }

  /// Checks if the component is opened.
  ///
  /// Returns true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return _opened;
  }

  /// Opens the component with given connection and credential parameters.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [connection]        connection parameters
  /// - [credential]        credential parameters
  /// Return 			          Future that receives null no errors occured.
  /// Throws error
  @override
  Future openWithParams(IContext? context, ConnectionParams? connection,
      CredentialParams? credential) async {
    _opened = true;
  }

  /// Closes component and frees used resources.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return 			        Future that receives null no errors occured.
  /// Throws error
  @override
  Future close(IContext? context) async {
    _opened = false;
    _cancel = true;
    logger.trace(context, 'Closed queue %s', [this]);
  }

  /// Clears component state.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return 			        Future that receives null no errors occured.
  /// Throws error
  @override
  Future clear(IContext? context) async {
    _messages = <MessageEnvelope>[];
    _lockedMessages = <int, LockedMessage>{};
    _cancel = false;
  }

  /// Configures component by passing configuration parameters.
  /// - [config] configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    super.configure(config);

    _listenInterval =
        config.getAsIntegerWithDefault('listen_interval', _listenInterval);
    _listenInterval = config.getAsIntegerWithDefault(
        'options.listen_interval', _listenInterval);
  }

  /// Reads the current number of messages in the queue to be delivered.
  ///
  /// Return      Future that receives number of messages
  /// Throws error.
  @override
  Future<int> readMessageCount() async {
    return _messages.length;
  }

  /// Sends a message into the queue.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [envelope]          a message envelop to be sent.
  /// Return          (optional) Future that receives null for success.
  /// Throws error
  @override
  Future send(IContext? context, MessageEnvelope envelope) async {
    envelope.sent_time = DateTime.now().toUtc();
    // Add message to the queue
    _messages.add(envelope);
    counters.incrementOne('queue.' + getName() + '.sent_messages');
    logger.debug(
        envelope.trace_id != null
            ? Context.fromTraceId(envelope.trace_id!)
            : null,
        'Sent message %s via %s',
        [envelope.toString(), toString()]);
  }

  /// Peeks a single incoming message from the queue without removing it.
  /// If there are no messages available in the queue it returns null.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// Return          Future that receives a message
  /// Throws error.
  @override
  Future<MessageEnvelope?> peek(IContext? context) async {
    MessageEnvelope? message;
    // Pick a message
    if (_messages.isNotEmpty) {
      message = _messages[0];
    }

    if (message != null) {
      logger.trace(
          message.trace_id != null
              ? Context.fromTraceId(message.trace_id!)
              : null,
          'Peeked message %s on %s',
          [message, toString()]);
    }

    return message;
  }

  /// Peeks multiple incoming messages from the queue without removing them.
  /// If there are no messages available in the queue it returns an empty list.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [messageCount]      a maximum number of messages to peek.
  /// Return          Future that receives a list with messages
  /// Throws error.
  @override
  Future<List<MessageEnvelope?>> peekBatch(
      IContext? context, int messageCount) async {
    var messages = _messages.sublist(0, messageCount);
    logger.trace(
        context, 'Peeked %d messages on %s', [messages.length, toString()]);
    return Future.value(messages);
  }

  /// Receives an incoming message and removes it from the queue.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [waitTimeout]       a timeout in milliseconds to wait for a message to come.
  /// Return          Future that receives a message
  /// Throws error.
  @override
  Future<MessageEnvelope?> receive(IContext? context, int waitTimeout) async {
    var err;
    MessageEnvelope? message;
    var messageReceived = false;

    var checkIntervalMs = 100;
    var i = 0;
    for (; i < waitTimeout && !messageReceived;) {
      i = i + checkIntervalMs;

      await Future.delayed(Duration(milliseconds: checkIntervalMs), () {
        if (_messages.isEmpty) {
          return null;
        }

        try {
          // Get message the the queue
          message = _messages.removeAt(0);

          if (message != null) {
            // Generate and set locked token
            var lockedToken = _lockTokenSequence++;
            message!.setReference(lockedToken);

            // Add messages to locked messages list
            var lockedMessage = LockedMessage();
            var now = DateTime.now().toUtc();
            lockedMessage.expirationTime =
                now.add(Duration(milliseconds: waitTimeout));
            lockedMessage.message = message;
            lockedMessage.timeout = waitTimeout;
            _lockedMessages[lockedToken] = lockedMessage;

            // Instrument the process
            counters.incrementOne('queue.' + getName() + '.received_messages');
            logger.debug(
                message?.trace_id != null
                    ? Context.fromTraceId(message!.trace_id!)
                    : null,
                'Received message %s via %s',
                [message, toString()]);
          }
        } catch (ex) {
          err = ex;
        }

        messageReceived = true;
        return null;
      });
    }

    if (err != null) {
      throw err;
    }

    return message;
  }

  /// Renews a lock on a message that makes it invisible from other receivers in the queue.
  /// This method is usually used to extend the message processing time.
  ///
  /// - [message]       a message to extend its lock.
  /// - [lockTimeout]   a locking timeout in milliseconds.
  /// Return      (optional) Future that receives or null for success.
  /// Throws error
  @override
  Future renewLock(MessageEnvelope message, int lockTimeout) async {
    if (message.getReference() == null) {
      return null;
    }

    // Get message from locked queue
    int lockedToken = message.getReference();
    var lockedMessage = _lockedMessages[lockedToken];

    // If lock is found, extend the lock
    if (lockedMessage != null) {
      var now = DateTime.now().toUtc();
      // TODO: Shall we skip if the message already expired?
      if (lockedMessage.expirationTime!.millisecondsSinceEpoch >
          now.millisecondsSinceEpoch) {
        lockedMessage.expirationTime =
            now.add(Duration(milliseconds: lockedMessage.timeout!));
      }
    }

    logger.trace(
        message.trace_id != null
            ? Context.fromTraceId(message.trace_id!)
            : null,
        'Renewed lock for message %s at %s',
        [message, toString()]);
  }

  /// Permanently removes a message from the queue.
  /// This method is usually used to remove the message after successful processing.
  ///
  /// - message   a message to remove.
  /// Return  (optional) Future that receives or null for success.
  /// Throw error
  @override
  Future complete(MessageEnvelope message) async {
    if (message.getReference() == null) {
      return null;
    }
    int lockKey = message.getReference();
    _lockedMessages.remove(lockKey);
    message.setReference(null);
    logger.trace(
        message.trace_id != null
            ? Context.fromTraceId(message.trace_id!)
            : null,
        'Completed message %s at %s',
        [message, toString()]);
  }

  /// Returnes message into the queue and makes it available for all subscribers to receive it again.
  /// This method is usually used to return a message which could not be processed at the moment
  /// to repeat the attempt. Messages that cause unrecoverable errors shall be removed permanently
  /// or/and send to dead letter queue.
  ///
  /// - [message]   a message to return.
  /// Return  (optional) Future that receives an null for success.
  /// Throws error
  @override
  Future abandon(MessageEnvelope message) async {
    if (message.getReference() == null) {
      return null;
    }

    // Get message from locked queue
    int lockedToken = message.getReference();
    var lockedMessage = _lockedMessages[lockedToken];
    if (lockedMessage != null) {
      // Remove from locked messages
      _lockedMessages.remove(lockedToken);
      message.setReference(null);

      // Skip if it is already expired
      if (lockedMessage.expirationTime!.millisecondsSinceEpoch <=
          DateTime.now().toUtc().millisecondsSinceEpoch) {
        return null;
      }
    }
    // Skip if it absent
    else {
      return null;
    }

    logger.trace(
        message.trace_id != null
            ? Context.fromTraceId(message.trace_id!)
            : null,
        'Abandoned message %s at %s',
        [message, toString()]);

    return send(
        message.trace_id != null
            ? Context.fromTraceId(message.trace_id!)
            : null,
        message);
  }

  /// Permanently removes a message from the queue and sends it to dead letter queue.
  ///
  /// - [message]   a message to be removed.
  /// Return  (optional) Future that receives or null for success.
  /// Throws error
  @override
  Future moveToDeadLetter(MessageEnvelope message) async {
    if (message.getReference() == null) {
      return null;
    }

    int lockedToken = message.getReference();
    _lockedMessages.remove(lockedToken);
    message.setReference(null);

    counters.incrementOne('queue.' + getName() + '.dead_messages');
    logger.trace(
        message.trace_id != null
            ? Context.fromTraceId(message.trace_id!)
            : null,
        'Moved to dead message %s at %s',
        [message, toString()]);
  }

  /// Listens for incoming messages and blocks the current thread until queue is closed.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [receiver]          a receiver to receive incoming messages.
  ///
  /// See [IMessageReceiver]
  /// See [receive]
  @override
  void listen(IContext? context, IMessageReceiver receiver) async {
    var timeoutInterval = 1000;

    logger.trace(null, 'Started listening messages at %s', [toString()]);
    _cancel = false;
    try {
      for (; !_cancel;) {
        MessageEnvelope? message;

        try {
          var result = await receive(context, timeoutInterval);
          message = result;
        } catch (err) {
          logger.error(
              context, err as Exception, 'Failed to receive the message');
        }

        if (message != null && !_cancel) {
          try {
            await receiver.receiveMessage(message, this);
          } catch (err) {
            logger.error(
                context, err as Exception, 'Failed to process the message');
          }
        }

        await Future.delayed(
            Duration(milliseconds: timeoutInterval), () => null);
      }
    } catch (err) {
      logger.error(context, ApplicationException().wrap(err),
          'Failed to process the message');
    }
  }

  /// Ends listening for incoming messages.
  /// When this method is call [listen] unblocks the thread and execution continues.
  ///
  /// - [context]     (optional) a context to trace execution through call chain.
  @override
  void endListen(IContext? context) {
    _cancel = true;
  }
}
