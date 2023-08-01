import 'package:pip_services4_components/pip_services4_components.dart';
import 'package:pip_services4_data/pip_services4_data.dart';
import './Command.dart';
import './ICommandInterceptor.dart';
import './InterceptedCommand.dart';

/// An interface for Commands, which are part of the Command design pattern.
/// Each command wraps a method or function and allows to call them in uniform and safe manner.
///
/// See [Command]
/// See [IExecutable]
/// See [ICommandInterceptor]
/// See [InterceptedCommand]

abstract interface class ICommand extends IExecutable {
  /// Gets the command name.
  ///
  /// Returns the command name.

  String getName();

  /// Validates command arguments before execution using defined schema.
  ///
  /// - args  the parameters (arguments) to validate.
  /// Returns     an array of ValidationResults.
  ///
  /// See [Parameters]
  /// See [ValidationResult]

  List<ValidationResult> validate(Parameters args);
}
