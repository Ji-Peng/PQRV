#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cpucycles.h"
#include "speed_print.h"

extern void keccakf1600(uint64_t *lanes);

#define NTESTS 10000
uint64_t t[NTESTS];

int main(void)
{
    uint64_t keccak_states[25];
    PERF(keccakf1600(keccak_states), Ko - keccakf1600);
    return 0;
}