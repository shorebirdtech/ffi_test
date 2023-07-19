#include <stdio.h>

int hello_callback(int (*fn)())
{
    printf("Hello from C! %p\n", fn);
    int result = fn();
    printf("Result: %d\n", result);
    return result + 1;
}


int callback_two(int (*fn)())
{
    printf("Hello from Two! %p\n", fn);
    int result = fn();
    printf("Result: %d\n", result);
    return result + 1;
}
