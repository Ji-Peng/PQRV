#include <stdint.h>
#include <stdio.h>

void test_add64(int64_t a, int64_t b)
{
    int64_t c;
    c = a + b;
    printf("%ld\n", c);
}

int main()
{
    int64_t a, b;
    test_add64(a, b);
}