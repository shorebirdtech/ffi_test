import 'dart:ffi';

typedef NativeDouble = Double Function(Pointer, Double, Double, Double, Double,
    Double, Double, Double, Double, Double, Double, Double, Double);
typedef NativeDoubleFn = double Function(Pointer, double, double, double,
    double, double, double, double, double, double, double, double, double);

typedef NativeInt = Int Function(
    Pointer, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int);
typedef NativeIntFn = int Function(
    Pointer, int, int, int, int, int, int, int, int, int, int, int, int);

typedef DoubleCallback = Double Function(Double, Double, Double, Double, Double,
    Double, Double, Double, Double, Double, Double, Double);
typedef IntCallback = Int Function(
    Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int);

// https://github.com/shorebirdtech/shorebird/issues/829
double double_fn(double a, double b, double c, double d, double e, double f,
    double g, double h, double i, double j, double k, double l) {
  print("Hello from Dart: $a, $b, $c, $d, $e, $f, $g, $h, $i, $j, $k, $l");
  return d;
}

int int_fn(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j,
    int k, int l) {
  print("Hello from Dart: $a, $b, $c, $d, $e, $f, $g, $h, $i, $j, $k, $l");
  return c;
}

void main() {
  final dylib = DynamicLibrary.open('libhello.so');

  final NativeDoubleFn test_double =
      dylib.lookupFunction<NativeDouble, NativeDoubleFn>("test_double",
          isLeaf: false);
  final double_fn_pointer =
      Pointer.fromFunction<DoubleCallback>(double_fn, 1213.0);
  try {
    final callbackResponse = test_double(double_fn_pointer, 1.0, 2.0, 3.0, 4.0,
        5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0);
    print(callbackResponse);
  } catch (e) {
    print(e);
  }

  final NativeIntFn test_int =
      dylib.lookupFunction<NativeInt, NativeIntFn>("test_int", isLeaf: false);
  final int_fn_pointer = Pointer.fromFunction<IntCallback>(int_fn, 13234);
  try {
    final callbackResponse =
        test_int(int_fn_pointer, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
    print(callbackResponse);
  } catch (e) {
    print(e);
  }
}
