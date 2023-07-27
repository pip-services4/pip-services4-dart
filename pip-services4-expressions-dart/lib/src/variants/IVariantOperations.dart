import 'Variant.dart';
import 'VariantType.dart';

/// Defines an interface for variant operations manager.
abstract interface class IVariantOperations {
  /// Converts variant to specified type
  /// - [value] A variant value to be converted.
  /// - [newType] A type of object to be returned.
  /// Returns A converted Variant value.
  Variant convert(Variant variant, VariantType newType);

  /// Performs '+' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant add(Variant value1, Variant value2);

  /// Performs '-' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant sub(Variant value1, Variant value2);

  /// Performs '*' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant mul(Variant value1, Variant value2);

  /// Performs '/' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant div(Variant value1, Variant value2);

  /// Performs '%' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant mod(Variant value1, Variant value2);

  /// Performs '^' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant pow(Variant value1, Variant value2);

  /// Performs AND operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant and(Variant value1, Variant value2);

  /// Performs OR operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant or(Variant value1, Variant value2);

  /// Performs XOR operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant xor(Variant value1, Variant value2);

  /// Performs << operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant lsh(Variant value1, Variant value2);

  /// Performs >> operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant rsh(Variant value1, Variant value2);

  /// Performs NOT operation for a variant.
  /// value The operand for this operation.
  /// Returns A result variant object.
  Variant not(Variant value);

  /// Performs '-' operation for a variant.
  /// value The operand for this operation.
  /// Returns A result variant object.
  Variant negative(Variant value);

  /// Performs '=' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant equal(Variant value1, Variant value2);

  /// Performs '<>' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant notEqual(Variant value1, Variant value2);

  /// Performs '>' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant more(Variant value1, Variant value2);

  /// Performs '<' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant less(Variant value1, Variant value2);

  /// Performs '>=' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant moreEqual(Variant value1, Variant value2);

  /// Performs '<=' operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant lessEqual(Variant value1, Variant value2);

  /// Performs IN operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant in_(Variant value1, Variant value2);

  /// Performs [] operation for two variants.
  /// - [value1] The first operand for this operation.
  /// - [value2] The second operand for this operation.
  /// Returns A result variant object.
  Variant getElement(Variant value1, Variant value2);

  /// Convert variant type to string representation
  /// - [value] a variant type to be converted.
  /// Returns a string representation of the type.
  String typeToString(VariantType value);
}
