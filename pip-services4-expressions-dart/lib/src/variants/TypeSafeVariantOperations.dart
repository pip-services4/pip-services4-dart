import 'AbstractVariantOperations.dart';
import 'Variant.dart';
import 'VariantType.dart';

/// Implements a strongly typed (type safe) variant operations manager object.
class TypeSafeVariantOperations extends AbstractVariantOperations {
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

    switch (variant.type) {
      case VariantType.Integer:
        return _convertFromInteger(variant, newType);
      case VariantType.Long:
        return _convertFromLong(variant, newType);
      case VariantType.Float:
        return _convertFromFloat(variant, newType);
      case VariantType.Double:
        break;
      case VariantType.String:
        break;
      case VariantType.Boolean:
        break;
      case VariantType.Object:
        return variant;
      case VariantType.Array:
        break;

      default:
        break;
    }

    throw Exception(
        'Variant convertion from ${typeToString(variant.type)} to ${typeToString(newType)} is not supported.');
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
      default:
        throw Exception(
            'Variant convertion from ${typeToString(value.type)} to ${typeToString(newType)} is not supported.');
    }
  }

  Variant _convertFromLong(Variant value, VariantType newType) {
    var result = Variant();
    switch (newType) {
      case VariantType.Long:
        result.asLong = value.asLong;
        return result;
      case VariantType.Float:
        result.asFloat = value.asLong.toDouble();
        return result;
      case VariantType.Double:
        result.asDouble = value.asLong.toDouble();
        return result;
      default:
        throw Exception(
            'Variant convertion from ${typeToString(value.type)} to ${typeToString(newType)} is not supported.');
    }
  }

  Variant _convertFromFloat(Variant value, VariantType newType) {
    var result = Variant();
    switch (newType) {
      case VariantType.Double:
        result.asDouble = value.asFloat;
        return result;

      default:
        throw Exception(
            'Variant convertion from ${typeToString(value.type)} to ${typeToString(newType)} is not supported.');
    }
  }
}
