import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

class CommandExec implements IExecutable {
  @override
  Future<dynamic> execute(IContext? context, Parameters args) async {
    if (context != null && ContextResolver.getTraceId(context) == 'wrongId')
      throw Exception('Test error');

    return await Future.value(123);
  }
}
