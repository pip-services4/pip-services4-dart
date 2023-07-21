import './IReferences.dart';

/// Interface for components that depends on other components.
///
/// If component requires explicit notification to unset references
/// it shall additionally implement [IUnreferenceable] interface.
///
/// See [IReferences]
/// See [IUnreferenceable]
/// See [Referencer]
///
/// ### Example ###
///
///     class MyController implements IReferenceable {
///         IMyPersistence persistence ;
///         ...
///         void setReferences(IReferences references ) {
///             persistence = references.getOneRequired<IMyPersistence>(
///                  Descriptor('mygroup', 'persistence', '*', '*', '1.0')
///             );
///         }
///         ...
///     }

abstract class IReferenceable {
  /// Sets references to dependent components.
  ///
  /// - references 	references to locate the component dependencies.
  /// See [IReferences]

  void setReferences(IReferences references);
}
