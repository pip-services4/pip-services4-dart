class TestClass {
  var _value2;

  TestClass(value1, value2) {
    this.value1 = value1;
    this.value2 = value2;
  }

  var value1;

  dynamic get value2 {
    return _value2;
  }

  set value2(value) {
    _value2 = value;
  }
}
