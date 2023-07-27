import 'IFunction.dart';
import 'IFunctionCollection.dart';

/// Implements a functions list.
class FunctionCollection implements IFunctionCollection {
  List<IFunction> _functions = [];

  /// Adds a new function to the collection.
  /// - [function] a function to be added.
  @override
  void add(IFunction? func) {
    if (func == null) {
      throw Exception('Func cannot be null');
    }
    _functions.add(func);
  }

  /// Gets a number of functions stored in the collection.
  /// Returns a number of stored functions.
  @override
  int get length => _functions.length;

  @override
  set length(int len) {
    _functions.length = len;
  }

  /// Get a function by its index.
  /// - [index] a function index.
  /// Returns a retrieved function.
  @override
  IFunction get(int index) => _functions[index];

  /// Get all functions stores in the collection
  /// Returns a list with functions.
  @override
  List<IFunction> getAll() {
    var result = <IFunction>[];
    result.addAll(_functions);
    return result;
  }

  /// Finds function index in the list by it's name.
  /// - [name] The function name to be found.
  /// Returns Function index in the list or <code>-1</code> if function was not found.
  @override
  int findIndexByName(String name) {
    name = name.toUpperCase();
    for (var i = 0; i < _functions.length; i++) {
      var varName = _functions[i].name.toUpperCase();
      if (varName == name) {
        return i;
      }
    }
    return -1;
  }

  /// Finds function in the list by it's name.
  /// - [name] The function name to be found.
  /// Returns A function or `null` if function was not found.
  @override
  IFunction? findByName(String name) {
    var index = findIndexByName(name);
    return index >= 0 ? _functions[index] : null;
  }

  /// Removes a function by its index.
  /// - [index] a index of the function to be removed.
  @override
  void remove(int index) {
    _functions.removeAt(index);
  }

  /// Removes function by it's name.
  /// - [name] The function name to be removed.
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
    _functions = [];
  }
}
