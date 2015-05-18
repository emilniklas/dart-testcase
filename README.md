# testcase

This library is a **mirror based** wrapper around the [test](//pub.dartlang.org/packages/test) package. The reason this package exists is to provide a more OO experience with testing dart.

## Usage

```dart
import 'package:testcase/testcase.dart';
export 'package:testcase/init.dart';

class Greeter {

  String sayHelloTo(String name) {
    return 'Hello, $name';
  }
}

class GreeterTest implements TestCase {

  Greeter greeter;

  setUp() {
    greeter = new Greeter();
  }

  tearDown() {}

  @test
  it_works() {
    // Directly exported from the test library. Keep doing your thang.
    expect(greeter.sayHelloTo('Emil'), equals('Hello, Emil'));
  }
}
```

## Note

To use the command 'pub run test' to run the tests (which you should), you've got
to have **test** in your `pubspec.yaml`, or else the binary won't be published.

```yaml
name: my_library
dev_dependencies:
  test: any
  testcase: any
```

```bash
$ alias pt="pub run test test/"
```