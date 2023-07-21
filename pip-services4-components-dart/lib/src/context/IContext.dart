/// Interface to specify execution context.
/// see [Context]
abstract interface class IContext {
  /// Gets a map element specified by its key.
  ///
  /// - [key] a key of the element to get.
  /// Return the value of the map element.
  dynamic get(String key);
}
