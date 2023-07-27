import 'package:pip_services4_expressions/src/variants/VariantType.dart';

import 'package:pip_services4_expressions/src/variants/Variant.dart';

import 'IVariantOperations.dart';

abstract class AbstractVariantOperations implements IVariantOperations {
  /// Convert variant type to string representation
  /// - [value] a variant type to be converted.
  /// Returns a string representation of the type.
  @override
  String typeToString(VariantType value) {
    switch (value) {
      case VariantType.Null:
        return 'Null';
      case VariantType.Integer:
        return 'Integer';
      case VariantType.Long:
        return 'Long';
      case VariantType.Float:
        return 'Float';
      case VariantType.Double:
        return 'Double';
      case VariantType.String:
        return 'String';
      case VariantType.Boolean:
        return 'Boolean';
      case VariantType.DateTime:
        return 'DateTime';
      case VariantType.TimeSpan:
        return 'TimeSpan';
      case VariantType.Object:
        return 'Object';
      case VariantType.Array:
        return 'Array';
      default:
        return 'Unknown';
    }
  }

  /// Converts variant to specified type
  /// - [value] A variant value to be converted.
  /// - [newType] A type of object to be returned.
  /// Returns A converted Variant value.
  @override
  Variant convert(Variant value, VariantType newType);

  /// Performs '+' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant add(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asInteger = value1.asInteger + value2.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = value1.asLong + value2.asLong;
        return result;
      case VariantType.Float:
        result.asFloat = value1.asFloat + value2.asFloat;
        return result;
      case VariantType.Double:
        result.asDouble = value1.asDouble + value2.asDouble;
        return result;
      case VariantType.TimeSpan:
        result.asTimeSpan = value1.asTimeSpan + value2.asTimeSpan;
        return result;
      case VariantType.String:
        result.asString = value1.asString + value2.asString;
        return result;

      default:
        throw Exception(
            "Operation '+' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs '/' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant div(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asInteger = value1.asInteger ~/ value2.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = value1.asLong ~/ value2.asLong;
        return result;
      case VariantType.Float:
        result.asFloat = value1.asFloat / value2.asFloat;
        return result;
      case VariantType.Double:
        result.asDouble = value1.asDouble / value2.asDouble;
        return result;
      default:
        throw Exception(
            "Operation '/' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs '*' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant mul(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asInteger = value1.asInteger * value2.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = value1.asLong * value2.asLong;
        return result;
      case VariantType.Float:
        result.asFloat = value1.asFloat * value2.asFloat;
        return result;
      case VariantType.Double:
        result.asDouble = value1.asDouble * value2.asDouble;
        return result;

      default:
        throw Exception(
            "Operation '*' is not supported for type ${typeToString(value1.type)}");
    }
  }

  @override
  Variant sub(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asInteger = value1.asInteger - value2.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = value1.asLong - value2.asLong;
        return result;
      case VariantType.Float:
        result.asFloat = value1.asFloat - value2.asFloat;
        return result;
      case VariantType.Double:
        result.asDouble = value1.asDouble - value2.asDouble;
        return result;
      case VariantType.TimeSpan:
        result.asTimeSpan = value1.asTimeSpan - value2.asTimeSpan;
        return result;
      case VariantType.DateTime:
        result.asTimeSpan = value1.asDateTime.microsecondsSinceEpoch -
            value2.asDateTime.microsecondsSinceEpoch;
        return result;
      default:
        throw Exception(
            "Operation '-' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs '%' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant mod(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asInteger = value1.asInteger % value2.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = value1.asLong % value2.asLong;
        return result;
      default:
        throw Exception(
            "Operation '%' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs '^' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant pow(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
      case VariantType.Long:
      case VariantType.Float:
      case VariantType.Double:
        // Converts second operant to the type of the first operand.
        value1 = convert(value1, VariantType.Double);
        value2 = convert(value2, VariantType.Double);
        result.asDouble = value1.asDouble * value2.asDouble;
        return result;

      default:
        throw Exception(
            "Operation '^' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs AND operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant and(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asInteger = value1.asInteger & value2.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = value1.asLong & value2.asLong;
        return result;
      case VariantType.Boolean:
        result.asBoolean = value1.asBoolean && value2.asBoolean;
        return result;
      default:
        throw Exception(
            'Operation AND is not supported for type ${typeToString(value1.type)}');
    }
  }

  /// Performs OR operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant or(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asInteger = value1.asInteger | value2.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = value1.asLong | value2.asLong;
        return result;
      case VariantType.Boolean:
        result.asBoolean = value1.asBoolean || value2.asBoolean;
        return result;
      default:
        throw Exception(
            'Operation OR is not supported for type ${typeToString(value1.type)}');
    }
  }

  /// Performs XOR operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant xor(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asInteger = value1.asInteger ^ value2.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = value1.asLong ^ value2.asLong;
        return result;
      case VariantType.Boolean:
        result.asBoolean = (value1.asBoolean && !value2.asBoolean) ||
            (!value1.asBoolean && value2.asBoolean);
        return result;

      default:
        throw Exception(
            'Operation XOR is not supported for type ${typeToString(value1.type)}');
    }
  }

  /// Performs << operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant lsh(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, VariantType.Integer);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asInteger = value1.asInteger << value2.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = value1.asLong << value2.asInteger;
        return result;
      default:
        throw Exception(
            "Operation '<<' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs >> operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant rsh(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, VariantType.Integer);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asInteger = value1.asInteger >> value2.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = value1.asLong >> value2.asInteger;
        return result;
      default:
        throw Exception(
            "Operation '>>' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs NOT operation for a variant.
  /// value The operand for this operation.
  /// Returns A result variant object.
  @override
  Variant not(Variant value) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value.type == VariantType.Null) {
      return result;
    }

    // Performs operation.
    switch (value.type) {
      case VariantType.Integer:
        result.asInteger = ~value.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = ~value.asLong;
        return result;
      case VariantType.Boolean:
        result.asBoolean = !value.asBoolean;
        return result;
      default:
        throw Exception(
            'Operation NOT is not supported for type ${typeToString(value.type)}');
    }
  }

  /// Performs '-' operation for a variant.
  /// value The operand for this operation.
  /// Returns A result variant object.
  @override
  Variant negative(Variant value) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value.type == VariantType.Null) {
      return result;
    }

    // Performs operation.
    switch (value.type) {
      case VariantType.Integer:
        result.asInteger = -value.asInteger;
        return result;
      case VariantType.Long:
        result.asLong = -value.asLong;
        return result;
      case VariantType.Float:
        result.asFloat = -value.asFloat;
        return result;
      case VariantType.Double:
        result.asDouble = -value.asDouble;
        return result;
      default:
        throw Exception(
            "Operation unary '-' is not supported for type ${typeToString(value.type)}");
    }
  }

  /// Performs '=' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant equal(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null && value2.type == VariantType.Null) {
      result.asBoolean = true;
      return result;
    }
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      result.asBoolean = false;
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asBoolean = value1.asInteger == value2.asInteger;
        return result;
      case VariantType.Long:
        result.asBoolean = value1.asLong == value2.asLong;
        return result;
      case VariantType.Float:
        result.asBoolean = value1.asFloat == value2.asFloat;
        return result;
      case VariantType.Double:
        result.asBoolean = value1.asDouble == value2.asDouble;
        return result;

      case VariantType.String:
        result.asBoolean = value1.asString == value2.asString;

        if (double.tryParse(value1.asString) != null &&
            double.tryParse(value2.asString) != null &&
            result.asBoolean == false) {
          result.asBoolean = double.tryParse(value1.asString) ==
              double.tryParse(value2.asString);
        }

        return result;
      case VariantType.TimeSpan:
        result.asBoolean = value1.asTimeSpan == value2.asTimeSpan;
        return result;
      case VariantType.DateTime:
        result.asBoolean = value1.asDateTime.microsecondsSinceEpoch ==
            value2.asDateTime.microsecondsSinceEpoch;
        return result;
      case VariantType.Boolean:
        result.asBoolean = value1.asBoolean == value2.asBoolean;
        return result;
      case VariantType.Object:
        result.asObject = value1.asObject == value2.asObject;
        return result;
      default:
        throw Exception(
            "Operation '=' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs '<>' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant notEqual(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null && value2.type == VariantType.Null) {
      result.asBoolean = false;
      return result;
    }
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      result.asBoolean = true;
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asBoolean = value1.asInteger != value2.asInteger;
        return result;
      case VariantType.Long:
        result.asBoolean = value1.asLong != value2.asLong;
        return result;
      case VariantType.Float:
        result.asBoolean = value1.asFloat != value2.asFloat;
        return result;
      case VariantType.Double:
        result.asBoolean = value1.asDouble != value2.asDouble;
        return result;
      case VariantType.String:
        result.asBoolean = value1.asString != value2.asString;
        return result;
      case VariantType.TimeSpan:
        result.asBoolean = value1.asTimeSpan != value2.asTimeSpan;
        return result;
      case VariantType.DateTime:
        result.asBoolean = value1.asDateTime.millisecondsSinceEpoch !=
            value2.asDateTime.millisecondsSinceEpoch;
        return result;
      case VariantType.Boolean:
        result.asBoolean = value1.asBoolean != value2.asBoolean;
        return result;
      case VariantType.Object:
        result.asObject = value1.asObject != value2.asObject;
        return result;
      default:
        throw Exception(
            "Operation '<>' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs '>' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant more(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asBoolean = value1.asInteger > value2.asInteger;
        return result;
      case VariantType.Long:
        result.asBoolean = value1.asLong > value2.asLong;
        return result;
      case VariantType.Float:
        result.asBoolean = value1.asFloat > value2.asFloat;
        return result;
      case VariantType.Double:
        result.asBoolean = value1.asDouble > value2.asDouble;
        return result;
      case VariantType.String:
        result.asBoolean = value1.asString.length > value2.asString.length;
        return result;
      case VariantType.TimeSpan:
        result.asBoolean = value1.asTimeSpan > value2.asTimeSpan;
        return result;
      case VariantType.DateTime:
        result.asBoolean = value1.asDateTime.millisecondsSinceEpoch >
            value2.asDateTime.millisecondsSinceEpoch;
        return result;
      default:
        throw Exception(
            "Operation '>' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs '<' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant less(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asBoolean = value1.asInteger < value2.asInteger;
        return result;
      case VariantType.Long:
        result.asBoolean = value1.asLong < value2.asLong;
        return result;
      case VariantType.Float:
        result.asBoolean = value1.asFloat < value2.asFloat;
        return result;
      case VariantType.Double:
        result.asBoolean = value1.asDouble < value2.asDouble;
        return result;
      case VariantType.String:
        result.asBoolean = value1.asString.length < value2.asString.length;
        return result;
      case VariantType.TimeSpan:
        result.asBoolean = value1.asTimeSpan < value2.asTimeSpan;
        return result;
      case VariantType.DateTime:
        result.asBoolean = value1.asDateTime.millisecondsSinceEpoch <
            value2.asDateTime.millisecondsSinceEpoch;
        return result;
      default:
        throw Exception(
            "Operation '<' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs '>=' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant moreEqual(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asBoolean = value1.asInteger >= value2.asInteger;
        return result;
      case VariantType.Long:
        result.asBoolean = value1.asLong >= value2.asLong;
        return result;
      case VariantType.Float:
        result.asBoolean = value1.asFloat >= value2.asFloat;
        return result;
      case VariantType.Double:
        result.asBoolean = value1.asDouble >= value2.asDouble;
        return result;
      case VariantType.String:
        result.asBoolean = value1.asString.length >= value2.asString.length;
        return result;
      case VariantType.TimeSpan:
        result.asBoolean = value1.asTimeSpan >= value2.asTimeSpan;
        return result;
      case VariantType.DateTime:
        result.asBoolean = value1.asDateTime.microsecondsSinceEpoch >=
            value2.asDateTime.microsecondsSinceEpoch;
        return result;
      default:
        throw Exception(
            "Operation '>=' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs '<=' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant lessEqual(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Converts second operant to the type of the first operand.
    value2 = convert(value2, value1.type);

    // Performs operation.
    switch (value1.type) {
      case VariantType.Integer:
        result.asBoolean = value1.asInteger <= value2.asInteger;
        return result;
      case VariantType.Long:
        result.asBoolean = value1.asLong <= value2.asLong;
        return result;
      case VariantType.Float:
        result.asBoolean = value1.asFloat <= value2.asFloat;
        return result;
      case VariantType.Double:
        result.asBoolean = value1.asDouble <= value2.asDouble;
        return result;
      case VariantType.String:
        result.asBoolean = value1.asString.length <= value2.asString.length;
        return result;
      case VariantType.TimeSpan:
        result.asBoolean = value1.asTimeSpan <= value2.asTimeSpan;
        return result;
      case VariantType.DateTime:
        result.asBoolean = value1.asDateTime.microsecondsSinceEpoch <=
            value2.asDateTime.microsecondsSinceEpoch;
        return result;
      default:
        throw Exception(
            "Operation '<=' is not supported for type ${typeToString(value1.type)}");
    }
  }

  /// Performs IN operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant in_(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    // Processes null arrays.
    if (value1.asObject == null) {
      result.asBoolean = false;
      return result;
    }

    if (value1.type == VariantType.Array) {
      var array = value1.asArray;
      for (var element in array) {
        var eq = equal(value2, element);
        if (eq.type == VariantType.Boolean && eq.asBoolean) {
          result.asBoolean = true;
          return result;
        }
      }
      result.asBoolean = false;
      return result;
    }
    return equal(value1, value2);
  }

  /// Performs [] operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  @override
  Variant getElement(Variant value1, Variant value2) {
    var result = Variant();

    // Processes VariantType.Null values.
    if (value1.type == VariantType.Null || value2.type == VariantType.Null) {
      return result;
    }

    value2 = convert(value2, VariantType.Integer);

    if (value1.type == VariantType.Array) {
      return value1.getByIndex(value2.asInteger);
    } else if (value1.type == VariantType.String) {
      result.asString = value1.asString[value2.asInteger];
      return result;
    }
    throw Exception(
        "Operation '[]' is not supported for type ${typeToString(value1.type)}");
  }
}
