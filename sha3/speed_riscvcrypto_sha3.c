#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cpucycles.h"
#include "speed_print.h"

extern void KeccakF1600_StatePermute(uint64_t *s);

#define NTESTS 10000
uint64_t t[NTESTS];

int main(void)
{
    uint64_t keccak_states[25];
    PERF(KeccakF1600_StatePermute(keccak_states), riscvcrypto - keccakf1600);
    return 0;
}