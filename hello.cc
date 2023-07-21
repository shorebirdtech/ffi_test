#include <stdio.h>
#include <stdint.h>
#include <iostream>

#define DART_EXPORT                                                            \
  extern "C" __attribute__((visibility("default"))) __attribute((used))

DART_EXPORT double test_double(double (*fn)(double a, double b, double c, double d, double e, double f, double g, double h, double i, double j, double k, double l), double a, double b, double c, double d, double e, double f, double g, double h, double i, double j, double k, double l)
{
    printf("Hello double: %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f\n", a, b, c, d, e, f, g, h, i, j, k, l);
    double result = fn(10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0, 110.0, 120.0);
    printf("Result: %f\n", result);
    return result + 1.1;
}


DART_EXPORT int test_int(int (*fn)(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k, int l), int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k, int l)
{
    printf("Hello int: %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", a, b, c, d, e, f, g, h, i, j, k, l);
    int result = fn(10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120);
    printf("Result: %d\n", result);
    return result + 1;
}


struct Struct17BytesInt {
  int64_t a0;
  int64_t a1;
  int8_t a2;
};


// Used for testing structs and unions by value.
// Return value returned in preallocated space passed by pointer on most ABIs.
// Is non word size on purpose, to test that structs are rounded up to word size
// on all ABIs.
DART_EXPORT Struct17BytesInt ReturnStruct17BytesInt(int64_t a0,
                                                    int64_t a1,
                                                    int8_t a2) {
  std::cout << "ReturnStruct17BytesInt"
            << "(" << a0 << ", " << a1 << ", " << static_cast<int>(a2) << ")"
            << "\n";

  Struct17BytesInt result = {};

  result.a0 = a0;
  result.a1 = a1;
  result.a2 = a2;

  std::cout << "result = "
            << "(" << result.a0 << ", " << result.a1 << ", "
            << static_cast<int>(result.a2) << ")"
            << "\n";

  return result;
}


DART_EXPORT int TestStruct(Struct17BytesInt (*fn)(int64_t a0, int64_t a1, int8_t a2)) {
    Struct17BytesInt result = fn(10, 20, 30);
    printf("Result: %lld, %lld, %d\n", result.a0, result.a1, result.a2);
    return result.a0 + result.a1 + result.a2;
}