class TestClass {
  //int _privateField = 123;
  String publicField = 'ABC';
  DateTime _publicProp = DateTime.now().toUtc();

  TestClass([int? arg1]);

  DateTime get publicProp {
    return _publicProp;
  }

  set publicProp(DateTime value) {
    _publicProp = value;
  }

  int publicMethod(int arg1, int arg2) {
    return arg1 + arg2;
  }
}
