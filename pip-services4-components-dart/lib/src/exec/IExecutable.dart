import 'dart:async';

import 'package:pip_services4_components/pip_services4_components.dart';

/// Interface for components that can be called to execute work.
///
/// See [Executor]
/// See [INotifiable]
/// See [Parameters]
///
/// ### Example ###
///
///     class EchoComponent implements IExecutable {
///         ...
///         Future<dynamic> execute(IContext? context, Parameters args)  {
///            return Future.delayed(Duration(), (){
///                return args.getAsObject('message');
///            })
///         }
///     }
///
///     var echo =  EchoComponent();
///     var message = 'Test';
///     echo.execute(Context.fromTraceId("123"), Parameters.fromTuples(['message', message])
///        .then((result) {
///             console.log('Request: ' + message + ' Response: ' + result);
///         })
///     );

abstract class IExecutable {
  /// Executes component with arguments and receives execution result.
  ///
  /// - [context] 	(optional) execution context to trace execution through call chain.
  /// - [args] 				execution arguments.
  /// Return 			  Future that receives execution result or error.

  Future<dynamic> execute(IContext? context, Parameters args);
}
