import 'LambdaAction.dart';

/// An interface that allows to integrate lambda services into lambda function containers
/// and connect their actions to the function calls.
abstract interface class ILambdaController {
  /// Get all actions supported by the controller.
  /// Return an array with supported actions.
  List<LambdaAction> getActions();
}
