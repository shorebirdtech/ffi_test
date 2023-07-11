#include <stdio.h>

int hello_callback(int (*fn)())
{
    int result = fn();
    return result + 1;
}
