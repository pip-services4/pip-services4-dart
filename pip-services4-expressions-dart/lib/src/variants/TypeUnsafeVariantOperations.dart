import 'package:pip_services4_commons/pip_services4_commons.dart';

import 'AbstractVariantOperations.dart';
import 'Variant.dart';
import 'VariantType.dart';

/// Implements a type unsafe variant operations manager object.
class TypeUnsafeVariantOperations extends AbstractVariantOperations {
  /// Converts variant to specified type
  /// - [value] A variant value to be converted.
  /// - [newType] A type of object to be returned.
  /// Returns A converted Variant value.
  @override
  Variant convert(Variant variant, VariantType newType) {
    if (newType == VariantType.Null) {
      var result = Variant();
      return result;
    }
    if (newType == variant.type || newType == VariantType.Object) {
      return variant;
    }
    if (newType == VariantType.String) {
      var result = Variant();
      result.asString = StringConverter.toString2(variant.asObject);
      return result;
    }

    switch (variant.type) {
      case VariantType.Null:
        return _convertFromNull(newType);
      case VariantType.Integer:
        return _convertFromInteger(variant, newType);
      case VariantType.Long:
        return _convertFromLong(variant, newType);
      case VariantType.Float:
        return _convertFromFloat(variant, newType);
      case VariantType.Double:
        return _convertFromDouble(variant, newType);
      case VariantType.DateTime:
        return _convertFromDateTime(variant, newType);
      case VariantType.TimeSpan:
        return _convertFromTimeSpan(variant, newType);
      case VariantType.String:
        return _convertFromString(variant, newType);
      case VariantType.Boolean:
        return _convertFromBoolean(variant, newType);

      default:
        throw Exception(
            'Variant convertion from ${typeToString(variant.type)} to ${typeToString(newType)} is not supported.');
    }
  }

  Variant _convertFromNull(VariantType newType) {
    var result = Variant();
    switch (newType) {
      case VariantType.Integer:
        result.asInteger = 0;
        return result;
      case VariantType.Long:
        result.asLong = 0;
        return result;
      case VariantType.Float:
        result.asFloat = 0;
        return result;
      case VariantType.Double:
        result.asDouble = 0;
        return result;
      case VariantType.Boolean:
        result.asBoolean = false;
        return result;
      case VariantType.DateTime:
        result.asDateTime = DateTime.fromMillisecondsSinceEpoch(0);
        return result;
      case VariantType.TimeSpan:
        result.asTimeSpan = 0;
        return result;
      case VariantType.String:
        result.asString = 'null';
        return result;
      case VariantType.Object:
        result.asObject = null;
        return result;
      case VariantType.Array:
        result.asArray = null;
        return result;
      default:
        throw Exception(
            'Variant convertion from Null to ${typeToString(newType)} is not supported.');
    }
  }

  Variant _convertFromInteger(Variant value, VariantType newType) {
    var result = Variant();
    switch (newType) {
      case VariantType.Long:
        result.asLong = value.asInteger;
        return result;
      case VariantType.Float:
        result.asFloat = value.asInteger.toDouble();
        return result;
      case VariantType.Double:
        result.asDouble = value.asInteger.toDouble();
        return result;
      case VariantType.DateTime:
        result.asDateTime =
            DateTime.fromMillisecondsSinceEpoch(value.asInteger);
        return result;
      case VariantType.TimeSpan:
        result.asTimeSpan = value.asInteger;
        return result;
      case VariantType.Boolean:
        result.asBoolean = value.asInteger != 0;
        return result;
      default:
        throw Exception(
            'Variant convertion from ${typeToString(value.type)} to ${typeToString(newType)} is not supported.');
    }
  }

  Variant _convertFromLong(Variant value, VariantType newType) {
    var result = Variant();
    switch (newType) {
      case VariantType.Integer:
        result.asInteger = value.asLong;
        return result;
      case VariantType.Float:
        result.asFloat = value.asLong.toDouble();
        return result;
      case VariantType.Double:
        result.asDouble = value.asLong.toDouble();
        return result;
      case VariantType.DateTime:
        result.asDateTime = DateTime.fromMillisecondsSinceEpoch(value.asLong);
        return result;
      case VariantType.TimeSpan:
        result.asTimeSpan = value.asLong;
        return result;
      case VariantType.Boolean:
        result.asBoolean = value.asLong != 0;
        return result;
      default:
        throw Exception(
            'Variant convertion from ${typeToString(value.type)} to ${typeToString(newType)} is not supported.');
    }
  }

  Variant _convertFromFloat(Variant value, VariantType newType) {
    var result = Variant();
    switch (newType) {
      case VariantType.Integer:
        result.asInteger = value.asFloat.truncate();
        return result;
      case VariantType.Long:
        result.asLong = value.asFloat.truncate();
        return result;
      case VariantType.Double:
        result.asDouble = value.asFloat;
        return result;
      case VariantType.Boolean:
        result.asBoolean = value.asFloat != 0;
        return result;
      default:
        throw Exception(
            'Variant convertion from ${typeToString(value.type)} to ${typeToString(newType)} is not supported.');
    }
  }

  Variant _convertFromDouble(Variant value, VariantType newType) {
    var result = Variant();
    switch (newType) {
      case VariantType.Integer:
        result.asInteger = value.asDouble.truncate();
        return result;
      case VariantType.Long:
        result.asLong = value.asDouble.truncate();
        return result;
      case VariantType.Float:
        result.asFloat = value.asDouble;
        return result;
      case VariantType.Boolean:
        result.asBoolean = value.asDouble != 0;
        return result;
      default:
        throw Exception(
            'Variant convertion from ${typeToString(value.type)} to ${typeToString(newType)} is not supported.');
    }
  }

  Variant _convertFromString(Variant value, VariantType newType) {
    var result = Variant();
    switch (newType) {
      case VariantType.Integer:
        result.asInteger = IntegerConverter.toInteger(value.asString);
        return result;
      case VariantType.Long:
        result.asLong = LongConverter.toLong(value.asString);
        return result;
      case VariantType.Float:
        result.asFloat = FloatConverter.toFloat(value.asString);
        return result;
      case VariantType.Double:
        result.asDouble = DoubleConverter.toDouble(value.asString);
        return result;
      case VariantType.DateTime:
        result.asDateTime = DateTimeConverter.toDateTime(value.asString);
        return result;
      case VariantType.TimeSpan:
        result.asTimeSpan = LongConverter.toLong(value.asString);
        return result;
      case VariantType.Boolean:
        result.asBoolean = BooleanConverter.toBoolean(value.asString);
        return result;
      default:
        throw Exception(
            'Variant convertion from ${typeToString(value.type)} to ${typeToString(newType)} is not supported.');
    }
  }

  Variant _convertFromBoolean(Variant value, VariantType newType) {
    var result = Variant();
    switch (newType) {
      case VariantType.Integer:
        result.asInteger = value.asBoolean ? 1 : 0;
        return result;
      case VariantType.Long:
        result.asLong = value.asBoolean ? 1 : 0;
        return result;
      case VariantType.Float:
        result.asFloat = value.asBoolean ? 1 : 0;
        return result;
      case VariantType.Double:
        result.asDouble = value.asBoolean ? 1 : 0;
        return result;
      case VariantType.String:
        result.asString = value.asBoolean ? 'true' : 'false';
        return result;
      default:
        throw Exception(
            'Variant convertion from ${typeToString(value.type)} to ${typeToString(newType)} is not supported.');
    }
  }

  Variant _convertFromDateTime(Variant value, VariantType newType) {
    var result = Variant();
    switch (newType) {
      case VariantType.Integer:
        result.asInteger = value.asDateTime.millisecondsSinceEpoch;
        return result;
      case VariantType.Long:
        result.asLong = value.asDateTime.millisecondsSinceEpoch;
        return result;
      case VariantType.String:
        result.asString = StringConverter.toString2(value.asDateTime);
        return result;
      default:
        throw Exception(
            'Variant convertion from ${typeToString(value.type)} to ${typeToString(newType)} is not supported.');
    }
  }

  Variant _convertFromTimeSpan(Variant value, VariantType newType) {
    var result = Variant();
    switch (newType) {
      case VariantType.Integer:
        result.asInteger = value.asTimeSpan;
        return result;
      case VariantType.Long:
        result.asLong = value.asTimeSpan;
        return result;
      case VariantType.String:
        result.asString = StringConverter.toString2(value.asTimeSpan);
        return result;
      default:
        throw Exception(
            'Variant convertion from ${typeToString(value.type)} to ${typeToString(newType)} is not supported.');
    }
  }
}
