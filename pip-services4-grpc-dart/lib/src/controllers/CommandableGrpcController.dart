import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_rpc/pip_services4_rpc.dart';

import 'GrpcController.dart';
import 'GrpcEndpoint.dart';
import '../clients/CommandableGrpcClient.dart';

/// Abstract controller that receives commands via GRPC protocol
/// to operations automatically generated for commands defined in [ICommandable components](https://pub.dev/documentation/pip_services4_rpc/latest/pip_services4_rpc/ICommandable-class.html).
/// Each command is exposed as invoke method that receives command name and parameters.
///
/// Commandable controllers require only 3 lines of code to implement a robust external
/// GRPC-based remote interface.
///
/// ### Configuration parameters ###
///
/// - [dependencies]:
///   - [endpoint]:              override for HTTP Endpoint dependency
///   - [controller]:            override for Controller dependency
/// - [connection(s)]:
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
/// - [*:endpoint:grpc:*:1.0]          (optional) [GrpcEndpoint] reference
///
/// See [CommandableGrpcClient]
/// See [GrpcController]
///
/// ### Example ###
///
///     class MyCommandableGrpcController extends CommandableGrpcController {
///        MyCommandableGrpcController():super('mydata') {
///           _dependencyResolver.put(
///               "service",
///               Descriptor("mygroup","service","*","*","1.0")
///           );
///        }
///     }
///
///     var controller = MyCommandableGrpcController();
///     controller.configure(ConfigParams.fromTuples([
///         "connection.protocol", "http",
///         "connection.host", "localhost",
///         "connection.port", 8080
///     ]));
///     controller.setReferences(References.fromTuples([
///         Descriptor("mygroup","service","default","default","1.0"), service
///     ]));
///
///     await controller.open("123");
///     print("The GRPC controller is running on port 8080");
///

abstract class CommandableGrpcController with GrpcController {
  final String _name;
  CommandSet? _commandSet;

  /// Creates a new instance of the service.
  ///
  /// - [name] a service name.
  CommandableGrpcController(String name) : _name = name {
    dependencyResolver.put('service', 'none');
  }

  /// Registers all service routes in gRPC endpoint.
  /// Call automaticaly in open component procedure
  @override
  void register() {
    var service = dependencyResolver.getOneRequired<ICommandable>('service');
    _commandSet = service.getCommandSet();

    var commands = _commandSet!.getCommands();
    for (var index = 0; index < commands.length; index++) {
      var command = commands[index];

      var method = '$_name.${command.getName()}';

      registerCommadableMethod(method, null,
          (IContext? context, Parameters args) async {
        var timing = instrument(context, method);
        try {
          var result = await command.execute(context, args);
          return result;
        } catch (err) {
          timing.endFailure(err as Exception);
        } finally {
          timing.endTiming();
        }
      });
    }
  }
}
