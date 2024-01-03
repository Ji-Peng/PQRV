#ifndef FIPS202x2_H
#define FIPS202x2_H

#include <stddef.h>
#include <stdint.h>

#define SHAKE128_RATE 168
#define SHAKE256_RATE 136
#define SHA3_256_RATE 136
#define SHA3_512_RATE 72

typedef struct uint64x2_t {
    uint64_t val[2];
} v128;

typedef struct keccak_x2 {
    v128 s[25];
    unsigned int pos;
} __attribute__((aligned(64))) keccakx2_state;

typedef struct state_3x {
    v128 s_x2[25];
    uint64_t s_x1[25];
} s_x3;

typedef struct keccak_x3 {
    s_x3 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx3_state;

void KeccakF1600x2_StatePermute(v128 state[25]);
void KeccakF1600x3_StatePermute(uint64_t *state);

#endif
