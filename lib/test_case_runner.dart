part of testcase;

class Test {
  final String testOn;
  final Timeout timeout;
  final dynamic skip;
  final Map<String, dynamic> onPlatform;

  const Test({this.testOn, this.timeout, this.skip, this.onPlatform});
}

const test = const Test();

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
      _registerTest(symbol, _getTestMetaData(declaration));
  }

  _methodIsTest(DeclarationMirror declaration) {
    return (declaration.metadata.any((meta) => meta.reflectee is Test));
  }

  Test _getTestMetaData(DeclarationMirror declaration) {
    return declaration.metadata
        .firstWhere((m) => m.reflectee is Test)
        .reflectee;
  }

  _registerTest(Symbol symbol, Test testAnnotation) {
    dart_test.test(
        _describeTest(symbol), () => _runTest(symbol),
        testOn: testAnnotation.testOn,
        timeout: testAnnotation.timeout,
        skip: testAnnotation.skip,
        onPlatform: testAnnotation.onPlatform);
  }

  _runTest(Symbol symbol) {
    return reflect(testCase)
        .invoke(symbol, [])
        .reflectee;
  }

  String _describeTest(Symbol symbol) {
    return MirrorSystem.getName(symbol).replaceAll('_', ' ');
  }
}