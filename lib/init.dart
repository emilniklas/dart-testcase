import 'package:testcase/testcase.dart';
import 'dart:mirrors';

main() {
  _getAllTestCases().forEach(_instantiateAndRunTestCase);
}

Iterable<Type> _getAllTestCases() {
  return _getAllTestCaseMirrors().map((m) => m.reflectedType);
}

Iterable<ClassMirror> _getAllTestCaseMirrors() {
  return _getAllClasses().toList()..retainWhere(_classIsTestCase);
}

Iterable<ClassMirror> _getAllClasses() {
  return currentMirrorSystem().libraries.values.expand(_classesInLibrary);
}

Iterable<ClassMirror> _classesInLibrary(LibraryMirror library) {
  return _allClassDeclarationsInLibrary(library).map(_castToClassMirror);
}

Iterable<DeclarationMirror> _allClassDeclarationsInLibrary(LibraryMirror library) {
  return library.declarations.values.where((d) => d is ClassMirror);
}

ClassMirror _castToClassMirror(d) {
  return d;
}

bool _classIsTestCase(ClassMirror classMirror) {
  return classMirror.isSubtypeOf(reflectType(TestCase)) && classMirror.reflectedType != TestCase;
}

_instantiateAndRunTestCase(Type testCaseType) {
  _runTestCase(_instantiateTestCase(testCaseType));
}

_runTestCase(TestCase testCase) {
  new TestCaseRunner(testCase).run();
}

_instantiateTestCase(Type testCaseType) {
  return reflectClass(testCaseType).newInstance(const Symbol(''), []).reflectee;
}