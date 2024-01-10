#include <stdint.h>
#include <stdio.h>

extern void vmul64(uint64_t *in0, uint64_t *in1, uint64_t *out);

int main(void)
{
    uint64_t in0[] = {2147483647, 35184372088831};
    uint64_t in1[] = {2147483647, 2147483647};
    uint64_t out[4];

    vmul64(in0, in1, out);

    printf("out0-l=%lld,out0-h=%lld,out1-l=%lld,out1-h=%lld\n", out[0], out[2],
           out[1], out[3]);
    return 0;
}