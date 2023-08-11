import 'package:test/test.dart';
import 'package:pip_services4_messaging/pip_services4_messaging.dart';
import './MessageQueueFixture.dart';

void main() {
  group('MemoryMessageQueue', () {
    late MemoryMessageQueue queue;
    late MessageQueueFixture fixture;

    setUpAll(() async {
      queue = MemoryMessageQueue('TestQueue');
      fixture = MessageQueueFixture(queue);
      await queue.open(null);
    });

    tearDownAll(() async {
      await queue.close(null);
    });

    setUp(() async {
      await queue.clear(
        null,
      );
    });

    test('Send Receive Message', () async {
      await fixture.testSendReceiveMessage();
    });

    test('Receive Send Message', () async {
      await fixture.testReceiveSendMessage();
    });

    test('Receive And Complete Message', () async {
      await fixture.testReceiveCompleteMessage();
    });

    test('Receive And Abandon Message', () async {
      await fixture.testReceiveAbandonMessage();
    });

    test('Send Peek Message', () async {
      await fixture.testSendPeekMessage();
    });

    test('Peek No Message', () async {
      await fixture.testPeekNoMessage();
    });

    test('Move To Dead Message', () async {
      await fixture.testMoveToDeadMessage();
    });

    test('On Message', () async {
      await fixture.testOnMessage();
    });

    test('Send Message As Object', () async {
      await fixture.testSendAsObject();
    });
  });
}
