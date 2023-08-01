import 'dart:async';
import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';

import './ICommand.dart';
import './ICommandInterceptor.dart';

/// Implements a [ICommand command] wrapped by an interceptor.
/// It allows to build command call chains. The interceptor can alter execution
/// and delegate calls to a next command, which can be intercepted or concrete.

/// See [ICommand]
/// See [ICommandInterceptor]

/// ### Example ###

///     class CommandLogger implements ICommandInterceptor {

///         String getName(ICommand command) {
///             return command.getName();
///         }

///         void execute(IContext? context, ICommand command , Parameters args,) async {
///             print('Executed command ' + command.getName());
///             return await command.execute(context, args);
///         }

///         List<ValidationResult> validate(ICommand command, Parameters args) {
///             return command.validate(args);
///         }
///     }

///     var logger =  CommandLogger();
///     var loggedCommand =  InterceptedCommand(logger, command);

///     // Each called command will output: Executed command <command name>

class InterceptedCommand implements ICommand {
  final ICommandInterceptor _interceptor;
  final ICommand _next;

  /// Creates a new InterceptedCommand, which serves as a link in an execution chain. Contains information
  /// about the interceptor that is being used and the next command in the chain.
  /// - [interceptor]   the interceptor that is intercepting the command.
  /// - [next]          (link to) the next command in the command's execution chain.
  InterceptedCommand(ICommandInterceptor interceptor, ICommand next)
      : _interceptor = interceptor,
        _next = next;

  /// Returns the name of the command that is being intercepted.
  @override
  String getName() {
    return _interceptor.getName(_next);
  }

  /// Executes the next command in the execution chain using the given [Parameters parameters] (arguments).
  /// - [context]     (optional) a context to trace execution through call chain.
  /// - [args]          the parameters (arguments) to pass to the command for execution.
  /// Returns           the function that is to be called once execution is complete. If an exception is raised, then
  ///                   it will be called with the error.
  /// See [Parameters]
  @override
  Future<dynamic> execute(IContext? context, Parameters args) async {
    return await _interceptor.execute(context, _next, args);
  }

  /// Validates the [Parameters parameters] (arguments) that are to be passed to the command that is next
  /// in the execution chain.
  /// - [args]      the parameters (arguments) to validate for the next command.
  /// Returns         an array of ValidationResults.
  /// See [Parameters]
  /// See [ValidationResult]
  @override
  List<ValidationResult> validate(Parameters args) {
    return _interceptor.validate(_next, args);
  }
}
