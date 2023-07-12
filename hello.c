#include <stdio.h>


int hello_callback(int (*fn)())
{
    printf("Hello from C!\n");
    int result = fn();
    return result + 1;
}
