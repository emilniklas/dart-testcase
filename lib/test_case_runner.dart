part of testcase;

const test = 'test';

abstract class TestCaseRunner {

  factory TestCaseRunner(TestCase testCase) => new _TestCaseRunner(testCase);

  run();
}

class _TestCaseRunner implements TestCaseRunner {

  TestCase testCase;

  _TestCaseRunner(this.testCase);

  run() {
    group('${_unitName(testCase)}:', _declareTestGroup);
  }

  String _unitName(TestCase testCase) {
    return testCase.runtimeType.toString()
    .replaceFirst(new RegExp(r'test$', caseSensitive: false), '');
  }

  _declareTestGroup() {
    setUp(testCase.setUp);
    tearDown(testCase.tearDown);
    reflectClass(testCase.runtimeType).declarations.forEach(_registerIfTest);
  }

  _registerIfTest(Symbol symbol, DeclarationMirror declaration) {
    if (_methodIsTest(declaration))
      _registerTest(symbol);
  }

  _methodIsTest(DeclarationMirror declaration) {
    return (declaration.metadata.any((meta) => meta.reflectee == test));
  }

  _registerTest(Symbol symbol) {
    dart_test.test(_describeTest(symbol), () => _runTest(symbol));
  }

  _runTest(Symbol symbol) {
    return reflect(testCase).invoke(symbol, []).reflectee;
  }

  String _describeTest(Symbol symbol) {
    return MirrorSystem.getName(symbol).replaceAll('_', ' ');
  }
}