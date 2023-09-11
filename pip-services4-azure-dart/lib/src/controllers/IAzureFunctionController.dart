import 'AzureFunctionAction.dart';

/// An interface that allows to integrate Azure Function controller into Azure Function containers
/// and connect their actions to the function calls.
abstract interface class IAzureFunctionController {
  /// Get all actions supported by the controller.
  /// Return an array with supported actions.
  List<AzureFunctionAction> getActions();
}
