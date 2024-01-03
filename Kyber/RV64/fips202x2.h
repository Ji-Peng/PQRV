#ifndef FIPS202x2_H
#define FIPS202x2_H

#include <stddef.h>
#include <stdint.h>

#define SHAKE128_RATE 168
#define SHAKE256_RATE 136
#define SHA3_256_RATE 136
#define SHA3_512_RATE 72

typedef struct {
    uint64_t val[2];
} v128;

typedef struct {
    v128 s[25];
    unsigned int pos;
} __attribute__((aligned(64))) keccakx2_state;

void KeccakF1600x2_StatePermute(v128 state[25]);

void sha3x2_256(uint8_t h[32], const uint8_t *in, size_t inlen);

#endif
