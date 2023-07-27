/// Represents a character interval that keeps a reference.
/// This class is internal and used by [CharReferenceMap].
class CharReferenceInterval<T> {
  final int _start;
  final int _end;
  final T _reference;

  CharReferenceInterval(int start, int end, T reference)
      : _start = start,
        _end = end,
        _reference = reference {
    if (start > end) {
      throw Exception('Start must be less or equal End');
    }
  }

  int get start => _start;

  int get end => _end;

  T get reference => _reference;

  bool inRange(int symbol) {
    return symbol >= _start && symbol <= _end;
  }
}
