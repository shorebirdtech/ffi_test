import 'dart:ffi';

import 'package:ffi/ffi.dart';

typedef NativeDoubleFn = Double Function(Pointer, Double, Double, Double,
    Double, Double, Double, Double, Double, Double, Double, Double, Double);
typedef DartDoubleFn = double Function(Pointer, double, double, double, double,
    double, double, double, double, double, double, double, double);

typedef NativeIntFn = Int Function(
    Pointer, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int);
typedef DartIntFn = int Function(
    Pointer, int, int, int, int, int, int, int, int, int, int, int, int);

typedef DoubleCallback = Double Function(Double, Double, Double, Double, Double,
    Double, Double, Double, Double, Double, Double, Double);
typedef IntCallbackFn = Int Function(
    Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int);

// https://github.com/shorebirdtech/shorebird/issues/829
double doubleCallback(double a, double b, double c, double d, double e,
    double f, double g, double h, double i, double j, double k, double l) {
  print("Hello from Dart: $a, $b, $c, $d, $e, $f, $g, $h, $i, $j, $k, $l");
  return d;
}

int intCallback(int a, int b, int c, int d, int e, int f, int g, int h, int i,
    int j, int k, int l) {
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

typedef NativeThrowsFn = Handle Function(Int a, Int b);
typedef DartThrowsFn = Object Function(int a, int b);

Object alwaysThrows(int a, int b) {
  print("alwaysThrows($a, $b)");
  final sum = a + b;
  print("throwing $sum...");
  throw sum;
}

void main() {
  final dylib = DynamicLibrary.open('libhello.so');

  final DartDoubleFn testDouble =
      dylib.lookupFunction<NativeDoubleFn, DartDoubleFn>("test_double",
          isLeaf: false);
  final doubleFnPointer =
      Pointer.fromFunction<DoubleCallback>(doubleCallback, 1213.0);
  try {
    final callbackResponse = testDouble(doubleFnPointer, 1.0, 2.0, 3.0, 4.0,
        5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0);
    print(callbackResponse);
  } catch (e) {
    print(e);
  }

  final DartIntFn testInt =
      dylib.lookupFunction<NativeIntFn, DartIntFn>("test_int", isLeaf: false);
  final intFnPointer = Pointer.fromFunction<IntCallbackFn>(intCallback, 13234);
  try {
    final callbackResponse =
        testInt(intFnPointer, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
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

  // This test has no user-supplied native code.  It wraps a Dart function as a
  // native function pointer, and then wraps that function pointer as a Dart
  // function and calls it.
  //
  // It's a regression test for a problem where the `asFunction` trampoline
  // called the native entry stub which did not correctly call
  // Dart_PropagateError in the simulator.
  final testThrowPointer = Pointer.fromFunction<NativeThrowsFn>(alwaysThrows);
  final testThrow = testThrowPointer.asFunction<DartThrowsFn>();
  try {
    testThrow(3, 4);
  } catch (e) {
    print('... caught $e');
  }
}
