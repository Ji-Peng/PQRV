#ifndef FIPS202x_H
#define FIPS202x_H

#include <stddef.h>
#include <stdint.h>

#define SHAKE128_RATE 168
#define SHAKE256_RATE 136
#define SHA3_256_RATE 136
#define SHA3_512_RATE 72

typedef struct uint64x2_t {
    uint64_t val[2];
} v128;

typedef struct state_3x {
    v128 s_x2[25];
    uint64_t s_x1[25];
} s_x3;

typedef struct state_4x {
    v128 s_x2[25];
    uint64_t s_x1_0[25];
    uint64_t s_x1_1[25];
} s_x4;

typedef struct state_5x {
    v128 s_x2[25];
    uint64_t s_x1_0[25];
    uint64_t s_x1_1[25];
    uint64_t s_x1_2[25];
} s_x5;

typedef struct state_6x {
    v128 s_x2[25];
    uint64_t s_x1_0[25];
    uint64_t s_x1_1[25];
    uint64_t s_x1_2[25];
    uint64_t s_x1_3[25];
} s_x6;

typedef struct state_8x {
    v128 s_x2[25];
    uint64_t s_x1_0[25];
    uint64_t s_x1_1[25];
    uint64_t s_x1_2[25];
    uint64_t s_x1_3[25];
    uint64_t s_x1_4[25];
    uint64_t s_x1_5[25];
} s_x8;

typedef struct state_10x {
    v128 s_x2[25];
    uint64_t s_x1_0[25];
    uint64_t s_x1_1[25];
    uint64_t s_x1_2[25];
    uint64_t s_x1_3[25];
    uint64_t s_x1_4[25];
    uint64_t s_x1_5[25];
    uint64_t s_x1_6[25];
    uint64_t s_x1_7[25];
} s_x10;

typedef struct keccak_x2 {
    v128 s[25];
    unsigned int pos;
} __attribute__((aligned(64))) keccakx2_state;

typedef struct keccak_x3 {
    s_x3 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx3_state;

typedef struct keccak_x4 {
    s_x4 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx4_state;

typedef struct keccak_x5 {
    s_x5 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx5_state;

typedef struct keccak_x6 {
    s_x6 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx6_state;

typedef struct keccak_x8 {
    s_x8 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx8_state;

typedef struct keccak_x10 {
    s_x10 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx10_state;

void KeccakF1600x2_StatePermute(v128 state[25]);
void KeccakF1600x3_StatePermute(uint64_t *state);
void KeccakF1600x4_StatePermute(uint64_t *state);
void KeccakF1600x5_StatePermute(uint64_t *state);
void KeccakF1600x6_StatePermute(uint64_t *state);
void KeccakF1600x8_StatePermute(uint64_t *state);
void KeccakF1600x10_StatePermute(uint64_t *state);

#endif
