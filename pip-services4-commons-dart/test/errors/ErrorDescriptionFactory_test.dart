import 'dart:convert';
import 'package:pip_services4_commons/src/errors/errors.dart';
import 'package:test/test.dart';

void main() {
  group('ErrorDescriptionFactory', () {
    test('Create From ApplicationException', () {
      var key = 'key';
      var details = 'details';

      var ex = ApplicationException('category', 'traceId', 'code', 'message');
      ex.status = 777;
      ex.cause = 'cause';
      ex.stack_trace = 'stackTrace';
      ex.withDetails(key, details);

      var descr = ErrorDescriptionFactory.create(ex);

      expect(descr, isNotNull);
      expect(descr.category, equals(ex.category));
      expect(descr.trace_id, equals(ex.trace_id));
      expect(descr.code, equals(ex.code));
      expect(descr.message, equals(ex.message));
      expect(descr.status, equals(ex.status));
      expect(descr.cause, equals(ex.cause));
      expect(descr.stack_trace, equals(ex.stack_trace));
      expect(descr.details!.getValue(), equals(ex.details!.getValue()));
    });

    test('Create From Error', () {
      var ex = Exception('message');

      var descr = ErrorDescriptionFactory.create(ex);

      expect(descr, isNotNull);
      expect(descr.category, equals(ErrorCategory.Unknown));
      expect(descr.code, equals('UNKNOWN'));
      expect(descr.message, equals(ex.toString()));
      expect(descr.status, equals(500));
      expect(descr.stack_trace, isNull);
    });

    test('JSON serialization', () {
      var key = 'key';
      var details = 'details';

      var ex = ApplicationException('category', 'traceId', 'code', 'message');
      ex.status = 777;
      ex.cause = 'cause';
      ex.stack_trace = 'stackTrace';
      ex.withDetails(key, details);

      var descr = ErrorDescriptionFactory.create(ex);

      var json = jsonEncode(descr);
      var descr2 = jsonDecode(json);

      expect(descr2, isNotNull);
      expect(descr2['category'], equals(ex.category));
      expect(descr2['trace_id'], equals(ex.trace_id));
      expect(descr2['code'], equals(ex.code));
      expect(descr2['message'], equals(ex.message));
      expect(descr2['status'], equals(ex.status));
      expect(descr2['cause'], equals(ex.cause));
      expect(descr2['stack_trace'], equals(ex.stack_trace));
      expect(descr2['details'], equals(ex.details!.getValue()));
    });
  });
}
