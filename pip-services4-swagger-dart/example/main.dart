import 'dart:async';
import 'dart:io';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_http/pip_services4_http.dart';
import 'package:pip_services4_observability/pip_services4_observability.dart';
import 'package:pip_services4_swagger/src/controllers/SwaggerController.dart';

import 'services/DummyService.dart';
import 'controllers/DummyCommandableHttpController.dart';
import 'controllers/DummyRestController.dart';

void main(List<String> args) async {
  // Create components
  var logger = ConsoleLogger();
  var service = DummyService();
  var httpEndpoint = HttpEndpoint();
  var restController = DummyRestController();
  var httpController = DummyCommandableHttpController();
  var statusController = StatusRestController();
  var heartbeatController = HeartbeatRestController();
  var swaggerController = SwaggerController();

  var components = [
    service,
    httpEndpoint,
    restController,
    httpController,
    statusController,
    heartbeatController,
    swaggerController
  ];

  // Configure components
  logger.configure(ConfigParams.fromTuples(['level', 'trace']));

  httpEndpoint.configure(ConfigParams.fromTuples([
    'connection.protocol',
    'http',
    'connection.host',
    'localhost',
    'connection.port',
    8080
  ]));

  restController.configure(ConfigParams.fromTuples(['swagger.enable', true]));

  httpController.configure(ConfigParams.fromTuples(
      ['base_route', 'dummies2', 'swagger.enable', true]));

  try {
    // Set references
    var references = References.fromTuples([
      Descriptor('pip-services', 'logger', 'console', 'default', '1.0'),
      logger,
      Descriptor('pip-services', 'counters', 'log', 'default', '1.0'),
      LogCounters(),
      Descriptor('pip-services', 'endpoint', 'http', 'default', '1.0'),
      httpEndpoint,
      Descriptor(
          'pip-services-dummies', 'service', 'default', 'default', '1.0'),
      service,
      Descriptor(
          'pip-services-dummies', 'controller', 'rest', 'default', '1.0'),
      restController,
      Descriptor('pip-services-dummies', 'controller', 'commandable-http',
          'default', '1.0'),
      httpController,
      Descriptor('pip-services', 'status-controller', 'rest', 'default', '1.0'),
      statusController,
      Descriptor(
          'pip-services', 'heartbeat-controller', 'rest', 'default', '1.0'),
      heartbeatController,
      Descriptor(
          'pip-services', 'swagger-controller', 'http', 'default', '1.0'),
      swaggerController
    ]);

    Referencer.setReferences(references, components);

    // Open components
    await Opener.open(null, components);

    print('Press Ctrl-C to stop the microservice...');

    // Wait until user presses ENTER
    var keyPresed = false;

    stdin.listen((List<int> event) {
      keyPresed = true;
    });

    while (!keyPresed) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    await Closer.close(null, components);

    exit(0);
  } catch (ex) {
    logger.error(null, ex as Exception, 'Failed to execute the microservice');
    exit(1);
  }
}
