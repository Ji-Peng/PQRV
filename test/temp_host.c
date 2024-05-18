#include <stdint.h>
#include <stdio.h>

int main()
{
    int64_t t;
    t = 1 << 10;
    t += 1;
    printf("%ld\n", t >> 2);
    t = -1024;
    t += 1;
    printf("%ld\n", t >> 2);
    t = -1024;
    t -= 1;
    printf("%ld\n", t >> 2);
    return 0;
}