import 'dart:ffi';

import 'package:ffi/ffi.dart';

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

final class Struct17BytesInt extends Struct {
  @Int64()
  external int a0;

  @Int64()
  external int a1;

  @Int8()
  external int a2;

  String toString() => "(${a0}, ${a1}, ${a2})";
}

typedef ReturnStruct17BytesIntFn = Struct17BytesInt Function(int, int, int);
typedef ReturnStruct17BytesInt = Struct17BytesInt Function(Int64, Int64, Int8);

typedef TestStruct = Int Function(Pointer);
typedef TestStructFn = int Function(Pointer);

Struct17BytesInt returnStruct(int a, int b, int c) {
  final resultPointer = calloc<Struct17BytesInt>();
  final result = resultPointer.ref;
  result.a0 = a;
  result.a1 = b;
  result.a2 = c;
  return result;
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

  final returnStruct17BytesIntLeaf =
      dylib.lookupFunction<ReturnStruct17BytesInt, ReturnStruct17BytesIntFn>(
          "ReturnStruct17BytesInt",
          isLeaf: true);
  final struct = returnStruct17BytesIntLeaf(1, 2, 3);
  print(struct);
  print(struct.a0);
  print(struct.a1);
  print(struct.a2);

  final testStruct = dylib
      .lookupFunction<TestStruct, TestStructFn>("TestStruct", isLeaf: false);
  final structCallback =
      Pointer.fromFunction<ReturnStruct17BytesInt>(returnStruct);
  testStruct(structCallback);
}
