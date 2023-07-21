#include <stdio.h>

double test_double(double (*fn)(double a, double b, double c, double d, double e, double f, double g, double h, double i, double j, double k, double l), double a, double b, double c, double d, double e, double f, double g, double h, double i, double j, double k, double l)
{
    printf("Hello double: %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f\n", a, b, c, d, e, f, g, h, i, j, k, l);
    double result = fn(10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0, 110.0, 120.0);
    printf("Result: %f\n", result);
    return result + 1.1;
}


int test_int(int (*fn)(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k, int l), int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k, int l)
{
    printf("Hello int: %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", a, b, c, d, e, f, g, h, i, j, k, l);
    int result = fn(10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120);
    printf("Result: %d\n", result);
    return result + 1;
}
