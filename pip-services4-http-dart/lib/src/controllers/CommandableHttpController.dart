import 'dart:convert';

import 'package:pip_services4_commons/pip_services4_commons.dart';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';
import 'package:shelf/shelf.dart';
import 'RestController.dart';
import 'CommandableSwaggerDocument.dart';
import 'HttpEndpoint.dart';
import '../clients/CommandableHttpClient.dart';

/// Abstract controller that receives remove calls via HTTP/REST protocol
/// to operations automatically generated for commands defined in [ICommandable components](https://pub.dev/documentation/pip_services4_rpc/latest/pip_services4_rpc/ICommandable-class.html).
/// Each command is exposed as POST operation that receives all parameters in body object.
///
/// Commandable controller require only 3 lines of code to implement a robust external
/// HTTP-based remote interface.
///
/// ### Configuration parameters ###
///
/// - [base_route]:              base route for remote URI
/// - [dependencies]:
///   - [endpoint]:              override for HTTP Endpoint dependency
///   - [controller]:            override for Controller dependency
/// - [connection](s):
///   - [discovery_key]:         (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html)
///   - [protocol]:              connection protocol: http or https
///   - [host]:                  host name or IP address
///   - [port]:                  port number
///   - [uri]:                   resource URI or connection string with all parameters in it
///
/// ### References ###
///
/// - [\*:logger:\*:\*:1.0]         (optional) [ILogger](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ILogger-class.html) components to pass log messages
/// - [\*:counters:\*:\*:1.0]         (optional) [ICounters](https://pub.dev/documentation/pip_services4_observability/latest/pip_services4_observability/ICounters-class.html) components to pass collected measurements
/// - [\*:discovery:\*:\*:1.0]        (optional) [IDiscovery](https://pub.dev/documentation/pip_services4_config/latest/pip_services4_config/IDiscovery-class.html) services to resolve connection
/// - [\*:endpoint:http:\*:1.0]          (optional)  [HttpEndpoint] reference
///
/// See [CommandableHttpClient]
/// See [RestController]
///
/// ### Example ###
///
///     class MyCommandableHttpController extends CommandableHttpController {
///        MyCommandableHttpController(): super() {
///           dependencyResolver.put(
///               "service",
///                Descriptor("mygroup","service","*","*","1.0")
///           );
///        }
///     }
///
///     var controller = MyCommandableHttpController();
///     controller.configure(ConfigParams.fromTuples([
///         "connection.protocol", "http",
///         "connection.host", "localhost",
///         "connection.port", 8080
///     ]));
///     controller.setReferences(References.fromTuples([
///        new Descriptor("mygroup","controller","default","default","1.0"), controller
///     ]));
///
///      await controller.open("123");
///      print("The REST controller is running on port 8080");
///

abstract class CommandableHttpController extends RestController {
  CommandSet? _commandSet;
  bool swaggerAuto = true;

  /// Creates a new instance of the controller.
  ///
  /// - [baseRoute] a controller base route.
  CommandableHttpController(String baseRoute) : super() {
    this.baseRoute = baseRoute;
    dependencyResolver.put('service', 'none');
  }

  ///  Configures component by passing configuration parameters.
  ///
  ///  - config    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    super.configure(config);
    swaggerAuto = config.getAsBooleanWithDefault('swagger.auto', swaggerAuto);
  }

  /// Registers all controller routes in HTTP endpoint.
  @override
  void register() {
    var controller = dependencyResolver.getOneRequired<ICommandable>('service');
    _commandSet = controller.getCommandSet();

    var commands = _commandSet?.getCommands() ?? [];
    for (var index = 0; index < commands.length; index++) {
      var command = commands[index];

      var route = command.getName();
      route = route[0] != '/' ? '/$route' : route;

      registerRoute('post', route, null, (Request req) async {
        var params = {};

        if (req.headers['Content-Type'] != null && req.headers.isNotEmpty) {
          var body = await req.readAsString();
          params = body.isNotEmpty ? json.decode(body) : {};
          req = req.change(body: body);
        }

        var traceId = getTraceId(req);
        var context = traceId != null ? Context.fromTraceId(traceId) : null;
        var args = Parameters.fromValue(params);
        var timing =
            instrument(context, '${baseRoute ?? ''}.${command.getName()}');
        try {
          var result = await command.execute(context, args);
          timing.endTiming();
          return await sendResult(req, result);
        } catch (err) {
          timing.endFailure(err as Exception);
          return await sendError(req, ApplicationException().wrap(err));
        }
      });
    }
    if (swaggerAuto) {
      var swaggerConfig = config!.getSection('swagger');

      var doc =
          CommandableSwaggerDocument(baseRoute ?? '', swaggerConfig, commands);
      registerOpenApiSpec_(doc.toString());
    }
  }
}
