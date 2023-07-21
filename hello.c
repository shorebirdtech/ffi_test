#include <stdio.h>

double hello_callback(double (*fn)(double a, double b, double c, double d, double e, double f, double g, double h, double i, double j, double k, double l))
{
    printf("Hello from C! %p\n", fn);
    double result = fn(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0);
    printf("Result: %f\n", result);
    return result + 1.1;
}


double callback_two(int (*fn)(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k, int l))
{
    printf("Hello from Two! %p\n", fn);
    double result = fn(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
    printf("Result: %f\n", result);
    return result + 1.7;
}
