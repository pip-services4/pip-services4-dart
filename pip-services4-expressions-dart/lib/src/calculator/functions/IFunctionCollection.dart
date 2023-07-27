import 'package:pip_services4_expressions/src/calculator/functions/IFunction.dart';

/// Defines a functions list.
abstract interface class IFunctionCollection {
  /// Adds a new function to the collection.
  /// - [function] a function to be added.
  void add(IFunction func);

  /// Gets a number of functions stored in the collection.
  /// Returns a number of stored functions.
  abstract int length;

  /// Get a function by its index.
  /// - [index] a function index.
  /// Returns a retrieved function.
  IFunction get(int index);

  /// Get all functions stores in the collection
  /// Returns a list with functions.
  List<IFunction> getAll();

  /// Finds function index in the list by it's name.
  /// - [name] The function name to be found.
  /// Returns Function index in the list or `-1` if function was not found.
  int findIndexByName(String name);

  /// Finds function in the list by it's name.
  /// - [name] The function name to be found.
  /// Returns A function or `null` if function was not found.
  IFunction? findByName(String name);

  /// Removes a function by its index.
  /// - [index] a index of the function to be removed.
  void remove(int index);

  /// Removes function by it's name.
  /// - [name] The function name to be removed.
  void removeByName(String name);

  /// Clears the collection.
  void clear();
}
