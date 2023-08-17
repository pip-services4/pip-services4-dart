import 'dart:async';
import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_messaging/pip_services4_messaging.dart';
import 'package:pip_services4_rabbitmq/pip_services4_rabbitmq.dart';

class TestMessageReciver implements IMessageReceiver {
  MessageEnvelope? message;

  @override
  Future receiveMessage(MessageEnvelope envelope, IMessageQueue queue) async {
    message = envelope;
    return null;
  }
}

void main() async {
  late RabbitMQMessageQueue queue;
  var rabbitmqHost = Platform.environment['RABBITMQ_HOST'] ?? 'localhost';
  var rabbitmqPort = Platform.environment['RABBITMQ_PORT'] ?? '5672';
  var rabbitmqExchange = Platform.environment['RABBITMQ_EXCHANGE'] ?? 'test';
  var rabbitmqQueue = Platform.environment['RABBITMQ_QUEUE'] ?? 'test';
  var rabbitmqUser = Platform.environment['RABBITMQ_USER'] ?? 'user';
  var rabbitmqPassword = Platform.environment['RABBITMQ_PASS'] ?? 'pass123';

  // ignore: unnecessary_null_comparison
  if (rabbitmqHost == null && rabbitmqPort == null) {
    return;
  }

  var queueConfig = ConfigParams.fromTuples([
    'exchange', rabbitmqExchange,
    'queue', rabbitmqQueue,
    'options.auto_create', true,
    //'connection.protocol', 'amqp',
    'connection.host', rabbitmqHost,
    'connection.port', rabbitmqPort,
    'credential.username', rabbitmqUser,
    'credential.password', rabbitmqPassword,
  ]);
  queue = RabbitMQMessageQueue('testQueue');
  queue.configure(queueConfig);

  await queue.open(null);
  await queue.clear(null);
  // Synchronus communication
  var envelope1 =
      MessageEnvelope(Context.fromTraceId('123'), 'Test', 'Test message');
  // ignore: unused_local_variable
  MessageEnvelope envelope2;
  var reciver = TestMessageReciver();
  queue.beginListen(null, reciver);

  await Future.delayed(Duration(milliseconds: 1000), () {});
  await queue.send(null, envelope1);

  await Future.delayed(Duration(milliseconds: 1000), () {});
  // read recived message
  envelope2 = reciver.message!; // envelope1.message = envelope2.message

  queue.endListen(null);
  await queue.close(null);
}
