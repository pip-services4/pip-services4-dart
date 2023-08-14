import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:test/test.dart';
import 'package:pip_services4_messaging/pip_services4_messaging.dart';

class TestMessageReciver implements IMessageReceiver {
  late MessageEnvelope message;

  @override
  Future receiveMessage(MessageEnvelope envelope, IMessageQueue queue) async {
    message = envelope;
    return null;
  }
}

class MessageQueueFixture {
  final IMessageQueue _queue;

  MessageQueueFixture(IMessageQueue queue) : _queue = queue;

  Future testSendReceiveMessage() async {
    var envelope1 =
        MessageEnvelope(Context.fromTraceId('123'), 'Test', 'Test message');
    await _queue.send(null, envelope1);

    var envelope2 = await _queue.receive(null, 10000);
    expect(envelope2, isNotNull);
    expect(envelope1.message_type, envelope2!.message_type);
    expect(envelope1.message.toString(), envelope2.message.toString());
    expect(envelope1.trace_id, envelope2.trace_id);
  }

  Future testReceiveSendMessage() async {
    var envelope1 =
        MessageEnvelope(Context.fromTraceId('123'), 'Test', 'Test message');

    await Future.delayed(Duration(milliseconds: 500), () {
      _queue.send(null, envelope1);
    });
    var envelope2 = await _queue.receive(null, 10000);
    expect(envelope2, isNotNull);
    expect(envelope1.message_type, envelope2!.message_type);
    expect(envelope1.message.toString(), envelope2.message.toString());
    expect(envelope1.trace_id, envelope2.trace_id);
  }

  Future testReceiveCompleteMessage() async {
    var envelope1 =
        MessageEnvelope(Context.fromTraceId('123'), 'Test', 'Test message');

    await _queue.send(null, envelope1);

    await Future.delayed(Duration(milliseconds: 500), () {});

    var count = await _queue.readMessageCount();
    expect(count > 0, isTrue);

    var envelope2 = await _queue.receive(null, 10000);
    expect(envelope2, isNotNull);
    expect(envelope1.message_type, envelope2!.message_type);
    expect(envelope1.message.toString(), envelope2.message.toString());
    expect(envelope1.trace_id, envelope2.trace_id);

    await _queue.complete(envelope2);
    expect(envelope2.getReference(), isNull);
  }

  Future testReceiveAbandonMessage() async {
    var envelope1 =
        MessageEnvelope(Context.fromTraceId('123'), 'Test', 'Test message');
    await _queue.send(null, envelope1);

    var envelope2 = await _queue.receive(null, 10000);
    expect(envelope2, isNotNull);
    expect(envelope1.message_type, envelope2!.message_type);
    expect(envelope1.message.toString(), envelope2.message.toString());
    expect(envelope1.trace_id, envelope2.trace_id);

    await _queue.abandon(envelope2);

    envelope2 = await _queue.receive(null, 10000);
    expect(envelope2, isNotNull);
    expect(envelope1.message_type, envelope2!.message_type);
    expect(envelope1.message.toString(), envelope2.message.toString());
    expect(envelope1.trace_id, envelope2.trace_id);
  }

  Future testSendPeekMessage() async {
    var envelope1 =
        MessageEnvelope(Context.fromTraceId('123'), 'Test', 'Test message');
    await _queue.send(null, envelope1);

    // Delay until the message is received
    await Future.delayed(Duration(milliseconds: 500), () {});

    var envelope2 = await _queue.peek(null);
    expect(envelope2, isNotNull);
    expect(envelope1.message_type, envelope2!.message_type);
    expect(envelope1.message.toString(), envelope2.message.toString());
    expect(envelope1.trace_id, envelope2.trace_id);
  }

  Future testPeekNoMessage() async {
    var result = await _queue.peek(null);
    expect(result, isNull);
  }

  Future testMoveToDeadMessage() async {
    var envelope1 =
        MessageEnvelope(Context.fromTraceId('123'), 'Test', 'Test message');
    await _queue.send(null, envelope1);

    var envelope2 = await _queue.receive(null, 10000);
    expect(envelope2, isNotNull);
    expect(envelope1.message_type, envelope2!.message_type);
    expect(envelope1.message.toString(), envelope2.message.toString());
    expect(envelope1.trace_id, envelope2.trace_id);

    await _queue.moveToDeadLetter(envelope2);
  }

  Future testOnMessage() async {
    var messageReceiver = TestMessageReceiver();
    _queue.beginListen(null, messageReceiver);

    await Future.delayed(Duration(milliseconds: 1000), () {});

    var envelope1 =
        MessageEnvelope(Context.fromTraceId('123'), 'Test', 'Test message');
    await _queue.send(null, envelope1);

    await Future.delayed(Duration(milliseconds: 1000), () {});

    var envelope2 = messageReceiver.messages[0];
    expect(envelope2, isNotNull);
    expect(envelope1.message_type, envelope2.message_type);
    expect(envelope1.message.toString(), envelope2.message.toString());
    expect(envelope1.trace_id, envelope2.trace_id);

    _queue.endListen(null);
  }
}
