import 'dart:ffi';

typedef NativeCallbackTest = Double Function(Pointer);
typedef NativeCallbackTestFn = double Function(Pointer);

typedef DoubleCallback = Double Function(Double, Double, Double, Double, Double,
    Double, Double, Double, Double, Double, Double, Double);
typedef IntCallback = Int Function(
    Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int);

// https://github.com/shorebirdtech/shorebird/issues/829
double double_callback(double a, double b, double c, double d, double e,
    double f, double g, double h, double i, double j, double k, double l) {
  print("Hello from Dart: $a, $b, $c, $d, $e, $f, $g, $h, $i, $j, $k, $l");
  return d;
}

int int_callback(int a, int b, int c, int d, int e, int f, int g, int h, int i,
    int j, int k, int l) {
  print("Hello from Dart: $a, $b, $c, $d, $e, $f, $g, $h, $i, $j, $k, $l");
  throw "foo";
  return c;
}

// https://github.com/shorebirdtech/shorebird/issues/654
// int throws_from_dart() {
//   throw Exception("Hello from Dart");
// }

void main() {
  final dylib = DynamicLibrary.open('libhello.so');

  final NativeCallbackTestFn hello_callback =
      dylib.lookupFunction<NativeCallbackTest, NativeCallbackTestFn>(
          "hello_callback",
          isLeaf: false);
  final callback =
      Pointer.fromFunction<DoubleCallback>(double_callback, 1213.0);
  try {
    final callbackResponse = hello_callback(callback);
    print(callbackResponse);
  } catch (e) {
    print(e);
  }

  final NativeCallbackTestFn callback_two = dylib
      .lookupFunction<NativeCallbackTest, NativeCallbackTestFn>("callback_two",
          isLeaf: false);
  final other = Pointer.fromFunction<IntCallback>(int_callback, 13234);
  try {
    final callbackResponse = callback_two(other);
    print(callbackResponse);
  } catch (e) {
    print(e);
  }
}
