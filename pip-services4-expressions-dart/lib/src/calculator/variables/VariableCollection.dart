import 'package:pip_services4_expressions/src/variants/variants.dart';

import 'IVariable.dart';
import 'IVariableCollection.dart';
import 'Variable.dart';

/// Implements a variables list.
class VariableCollection implements IVariableCollection {
  List<IVariable> _variables = [];

  /// Adds a new variable to the collection.
  /// - [variable] a variable to be added.
  @override
  void add(IVariable? variable) {
    if (variable == null) {
      throw Exception('Variable cannot be null');
    }
    _variables.add(variable);
  }

  /// Gets a number of variables stored in the collection.
  /// Returns a number of stored variables.
  @override
  int get length => _variables.length;

  /// Get a variable by its index.
  /// - [index] a variable index.
  /// Returns a retrieved variable.
  @override
  IVariable get(int index) {
    return _variables[index];
  }

  /// Get all variables stores in the collection
  /// Returns a list with variables.
  @override
  List<IVariable> getAll() {
    var result = <IVariable>[];
    result.addAll(_variables);
    return result;
  }

  /// Finds variable index in the list by it's name.
  /// - [name] The variable name to be found.
  /// Returns Variable index in the list or <code>-1</code> if variable was not found.
  @override
  int findIndexByName(String name) {
    name = name.toUpperCase();
    for (var i = 0; i < _variables.length; i++) {
      var varName = _variables[i].name.toUpperCase();
      if (varName == name) {
        return i;
      }
    }
    return -1;
  }

  /// Finds variable in the list by it's name.
  /// - [name] The variable name to be found.
  /// Returns A variable or null if function was not found.
  @override
  IVariable? findByName(String name) {
    var index = findIndexByName(name);
    return index >= 0 ? _variables[index] : null;
  }

  /// Finds variable in the list or create a new one if variable was not found.
  /// - [name] The variable name to be found.
  /// Returns Found or created variable.
  @override
  IVariable locate(String name) {
    var v = findByName(name);
    if (v == null) {
      v = Variable(name);
      add(v);
    }
    return v;
  }

  /// Removes a variable by its index.
  /// - [index] a index of the variable to be removed.
  @override
  void remove(int index) {
    _variables.removeAt(index);
  }

  /// Removes variable by it's name.
  /// - [name] The variable name to be removed.
  @override
  void removeByName(String name) {
    var index = findIndexByName(name);
    if (index >= 0) {
      remove(index);
    }
  }

  /// Clears the collection.
  @override
  void clear() {
    _variables = [];
  }

  /// Clears all stored variables (assigns null values).
  @override
  void clearValues() {
    for (var v in _variables) {
      v.value = Variant();
    }
  }

  @override
  set length(int l) => _variables.length = l;
}
