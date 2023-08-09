import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:shelf/shelf.dart';
import 'RestController.dart';
import '../clients/RestClient.dart';

/// Controller returns heartbeat via HTTP/REST protocol.
///
/// The controller responds on /heartbeat route (can be changed)
/// with a string with the current time in UTC.
///
/// This controller route can be used to health checks by loadbalancers and
/// container orchestrators.
///
/// ### Configuration parameters ###
///
/// - [base_route]:              base route for remote URI (default: '')
/// - [route]:                   route to heartbeat operation (default: 'heartbeat')
/// - [dependencies]:
///   - [endpoint]:              override for HTTP Endpoint dependency
/// - [connection(s)]:
///   - [discovery_key]:         (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services4_components/latest/pip_services4_components/IDiscovery-class.html)
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
/// - [\*:endpoint:http:\*:1.0]           (optional) [HttpEndpoint] reference
///
/// See [RestController]
/// See [RestClient]
///
/// ### Example ###
///
///     var controller = new HeartbeatController();
///     controller.configure(ConfigParams.fromTuples(
///         'route', 'ping',
///         'connection.protocol', 'http',
///         'connection.host', 'localhost',
///         'connection.port', 8080
///     ));
///
///     controller.open('123', (err) => {
///        console.log('The Heartbeat controller is accessible at http://+:8080/ping');
///     });

class HeartbeatRestController extends RestController {
  var _route = 'heartbeat';

  /// Creates a new instance of this controller.
  HeartbeatRestController() : super();

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    super.configure(config);

    _route = config.getAsStringWithDefault('route', _route);
  }

  /// Registers all controller routes in HTTP endpoint.
  @override
  void register() {
    registerRoute('get', _route, null, (Request req) async {
      return await _heartbeat(req);
    });
  }

  /// Handles heartbeat requests
  ///
  /// - [req]   an HTTP RequestContext
  /// - [res]   an HTTP ResponseContext
  FutureOr<Response> _heartbeat(Request req) async {
    return await sendResult(req, DateTime.now().toUtc().toIso8601String());
  }
}
