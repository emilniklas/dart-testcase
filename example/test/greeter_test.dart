import 'package:testcase/testcase.dart';
export 'package:testcase/init.dart';
import '../lib/greeter.dart';

class GreeterTest implements TestCase {

  Greeter greeter;

  setUp() {
    greeter = new Greeter();
  }

  tearDown() {}

  @test
  it_works() {
    expect(greeter.sayHelloTo('Emil'), equals('Hello, Emil'));
  }
}
