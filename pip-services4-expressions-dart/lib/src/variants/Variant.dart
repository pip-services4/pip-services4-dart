import 'package:pip_services4_commons/pip_services4_commons.dart';

import 'VariantType.dart';

/// Defines container for variant values.
class Variant {
  VariantType _type = VariantType.Null;
  dynamic _value;

  static final Empty = Variant(null);

  /// Constructs this class and assignes another variant value.
  ///
  /// - [value] a value to be assigned to this variant.
  Variant([dynamic value]) {
    asObject = value;
  }

  /// Gets a type of the variant value
  ///
  /// Returns the variant value type
  VariantType get type => _type;

  /// Gets variant value as integer
  int get asInteger => _value;

  /// Sets variant value as integer
  /// - [value] a value to be set
  set asInteger(dynamic value) {
    _type = VariantType.Integer;
    _value = value;
  }

  /// Gets variant value as long
  int get asLong => _value;

  /// Sets variant value as long
  /// - [value] a value to be set
  set asLong(int value) {
    _type = VariantType.Long;
    _value = value;
  }

  /// Gets variant value as boolean
  bool get asBoolean => _value;

  /// Sets variant value as boolean
  /// - [value] a value to be set
  set asBoolean(bool value) {
    _type = VariantType.Boolean;
    _value = value;
  }

  /// Gets variant value as float
  double get asFloat => FloatConverter.toFloat(_value);

  /// Sets variant value as float
  /// - [value] a value to be set
  set asFloat(double value) {
    _type = VariantType.Float;
    _value = value;
  }

  /// Gets variant value as double
  double get asDouble => DoubleConverter.toDouble(_value);

  set asDouble(double value) {
    _type = VariantType.Double;
    _value = value;
  }

  /// Gets variant value as string
  String get asString => _value;

  set asString(String value) {
    _type = VariantType.String;
    _value = value;
  }

  /// Gets variant value as DateTime
  DateTime get asDateTime => _value;

  /// Sets variant value as DateTime
  /// - [value] a value to be set
  set asDateTime(DateTime value) {
    _type = VariantType.DateTime;
    _value = value;
  }

  /// Gets variant value as TimeSpan
  int get asTimeSpan => _value;

  /// Sets variant value as TimeSpan
  /// - [value] a value to be set
  set asTimeSpan(int value) {
    _type = VariantType.TimeSpan;
    _value = value;
  }

  /// Gets variant value as Object
  dynamic get asObject => _value;

  /// Sets variant value as Object
  ///
  /// - [value] a value to be set
  set asObject(dynamic value) {
    _value = value;

    if (value == null) {
      _type = VariantType.Null;
    } else if (value is int) {
      _type = VariantType.Integer;
    } else if (value is num) {
      _type = VariantType.Double;
    } else if (value is bool) {
      _type = VariantType.Boolean;
    } else if (value is DateTime) {
      _type = VariantType.DateTime;
    } else if (value is String) {
      _type = VariantType.String;
    } else if (value is List) {
      _type = VariantType.Array;
    } else if (value is Variant) {
      _type = value._type;
      _value = value._value;
    } else {
      _type = VariantType.Object;
    }
  }

  /// Gets variant value as variant array
  List<Variant> get asArray => _value;

  /// Sets variant value as variant array
  /// - [value] a value to be set
  set asArray(List<Variant>? value) {
    _type = VariantType.Array;
    if (value != null) {
      _value = [...value];
    } else {
      _value = null;
    }
  }

  /// Gets length of the array
  /// Returns The length of the array or 0
  int get length {
    if (_type == VariantType.Array) return _value is List ? _value.length : 0;
    return 0;
  }

  /// Sets a new array length
  /// - [value] a new array length
  set length(int value) {
    if (_type == VariantType.Array) {
      _value = [..._value];

      while (_value.length < value) {
        _value.add(null);
      }
    } else {
      throw Exception('Cannot set array length for non-array data type.');
    }
  }

  /// Gets an array element by its index.
  /// - [index] an element index
  /// - Returns a requested array element
  Variant getByIndex(int index) {
    if (_type == VariantType.Array) {
      if (_value is List && _value.length > index) {
        return _value[index];
      }
      throw Exception('Requested element of array is not accessible.');
    }
    throw Exception('Cannot access array element for none-array data type.');
  }

  /// Sets an array element by its index.
  /// - [index] an element index
  /// - [element] an element value
  void setByIndex(int index, Variant element) {
    if (_type == VariantType.Array) {
      if (_value is List) {
        while (_value.length <= index) {
          _value.add(null);
        }

        _value[index] = element;
      } else {
        throw Exception('Requested element of array is not accessible.');
      }
    } else {
      throw Exception('Cannot access array element for none-array data type.');
    }
  }

  /// Checks is this variant value Null.
  /// Returns true if this variant value is Null.
  bool isNull() {
    return _type == VariantType.Null;
  }

  bool isEmpty() {
    return _value == null;
  }

  /// Assignes a new value to this object.
  /// - [value] A new value to be assigned.
  void assing(Variant? value) {
    if (value != null) {
      _type = value._type;
      _value = value._value;
    } else {
      _type = VariantType.Null;
      _value = null;
    }
  }

  /// Clears this object and assignes a VariantType.Null type.
  void clear() {
    _type = VariantType.Null;
    _value = null;
  }

  /// Returns a string value for this object.
  /// Returns a string value for this object.
  String toString2() {
    return _value == null ? 'null' : StringConverter.toString2(_value);
  }

  /// Compares this object to the specified one.
  /// - [obj] An object to be compared.
  /// Returns true if objects are equal.
  bool equals(dynamic obj) {
    if (obj is Variant) {
      var varObj = obj;
      var value1 = _value;
      var value2 = varObj._value;
      if (value1 == null || value2 == null) {
        return value1 == value2;
      }
      return (_type == varObj._type) && (value1 == value2);
    }
    return false;
  }

  /// Cloning the variant value
  /// Returns The cloned value of this variant
  Variant clone() {
    return Variant(this);
  }

  /// Creates a new variant from Integer value.
  /// - [value] a variant value.
  /// Returns a created variant object.
  static Variant fromInteger(int value) {
    var result = Variant();
    result.asInteger = value;
    return result;
  }

  /// Creates a new variant from Long value.
  /// - [value] a variant value.
  /// Returns a created variant object.
  static Variant fromLong(int value) {
    var result = Variant();
    result.asLong = value;
    return result;
  }

  /// Creates a new variant from Boolean value.
  /// value a variant value.
  /// Returns a created variant object.
  static Variant fromBoolean(bool value) {
    var result = Variant();
    result.asBoolean = value;
    return result;
  }

  /// Creates a new variant from Float value.
  /// - [value] a variant value.
  /// Returns a created variant object.
  static Variant fromFloat(double value) {
    var result = Variant();
    result.asFloat = value;
    return result;
  }

  /// Creates a new variant from Double value.
  /// - [value] a variant value.
  /// Returns a created variant object.
  static Variant fromDouble(double value) {
    var result = Variant();
    result.asDouble = value;
    return result;
  }

  /// Creates a new variant from String value.
  /// - [value] a variant value.
  /// Returns a created variant object.
  static Variant fromString(String value) {
    var result = Variant();
    result.asString = value;
    return result;
  }

  /// Creates a new variant from DateTime value.
  /// - [value] a variant value.
  /// Returns a created variant object.
  static Variant fromDateTime(DateTime value) {
    var result = Variant();
    result.asDateTime = value;
    return result;
  }

  /// Creates a new variant from TimeSpan value.
  /// - [value] a variant value.
  /// Returns a created variant object.
  static Variant fromTimeSpan(int value) {
    var result = Variant();
    result.asTimeSpan = value;
    return result;
  }

  /// Creates a new variant from Object value.
  /// - [value] a variant value.
  /// Returns a created variant object.
  static Variant fromObject(dynamic value) {
    var result = Variant();
    result.asObject = value;
    return result;
  }

  /// Creates a new variant from Array value.
  /// - [value] a variant value.
  /// Returns a created variant object.
  static Variant fromArray(List<Variant> value) {
    var result = Variant();
    result.asArray = value;
    return result;
  }
}
