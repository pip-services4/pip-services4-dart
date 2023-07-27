import 'CharReferenceInterval.dart';

/// This class keeps references associated with specific characters
class CharReferenceMap<T> {
  List<T?> _initialInterval = [];
  List<CharReferenceInterval<T>> _otherIntervals = [];

  CharReferenceMap() {
    clear();
  }

  void addDefaultInterval(T reference) {
    addInterval(0x0000, 0xfffe, reference);
  }

  void addInterval(int start, int end, T reference) {
    if (start > end) {
      throw Exception('Start must be less or equal End');
    }
    end = end == 0xffff ? 0xfffe : end;

    for (var index = start; index < 0x0100 && index <= end; index++) {
      _initialInterval[index] = reference;
    }
    if (end >= 0x0100) {
      start = start < 0x0100 ? 0x0100 : start;
      _otherIntervals.insert(
          0, CharReferenceInterval<T>(start, end, reference));
    }
  }

  void clear() {
    _initialInterval = [];
    for (var index = 0; index < 0x0100; index++) {
      _initialInterval.insert(index, null);
    }
    _otherIntervals = [];
  }

  T? lookup(int symbol) {
    if (-1 < symbol && symbol < 0x0100) {
      return _initialInterval[symbol];
    } else {
      for (var interval in _otherIntervals) {
        if (interval.inRange(symbol)) {
          return interval.reference;
        }
      }
      return null;
    }
  }
}
