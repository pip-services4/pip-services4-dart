import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_rpc/src/commands/commands.dart';
import 'package:test/test.dart';

import './CommandExec.dart';

void main() {
  group('Command', () {
    test('Get Name', () {
      var command = Command('name', null, CommandExec());

      // Check match by individual fields
      expect(command, isNotNull);
      expect(command.getName(), equals('name'));
    });

    test('Execute', () async {
      var command = Command('name', null, CommandExec());

      var map = {};
      map[8] = 'title 8';
      map[11] = 'title 11';
      var param = Parameters(map);

      var result = await command.execute(Context.fromTraceId('a'), param);
      expect(result, equals(123));
    });
  });
}
