import 'IVariable.dart';

/// Defines a variables list.
abstract interface class IVariableCollection {
  /// Adds a new variable to the collection.
  /// - [variable] a variable to be added.
  void add(IVariable variable);

  /// Gets a number of variables stored in the collection.
  /// Returns a number of stored variables.
  abstract int length;

  /// Get a variable by its index.
  /// - [index] a variable index.
  /// Returns a retrieved variable.
  IVariable get(int index);

  /// Get all variables stores in the collection
  /// Returns a list with variables.
  List<IVariable> getAll();

  /// Finds variable index in the list by it's name.
  /// - [name] The variable name to be found.
  /// Returns Variable index in the list or -1 if variable was not found.
  int findIndexByName(String name);

  /// Finds variable in the list by it's name.
  /// - [name] The variable name to be found.
  /// Returns A variable or null if function was not found.
  IVariable? findByName(String name);

  /// Finds variable in the list or create a new one if variable was not found.
  /// - [name] The variable name to be found.
  /// Returns Found or created variable.
  IVariable locate(String name);

  /// Removes a variable by its index.
  /// - [index] a index of the variable to be removed.
  void remove(int index);

  /// Removes variable by it's name.
  /// - [name] The variable name to be remove
  void removeByName(String name);

  /// Clears the collection.
  void clear();

  /// Clears all stored variables (assigns null values).
  void clearValues();
}
