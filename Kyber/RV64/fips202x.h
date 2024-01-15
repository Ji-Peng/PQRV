#ifndef FIPS202x_H
#define FIPS202x_H

#include <stddef.h>
#include <stdint.h>

#define SHAKE128_RATE 168
#define SHAKE256_RATE 136
#define SHA3_256_RATE 136
#define SHA3_512_RATE 72

#define DEFINE_SHA3_APIS(N)                                                               \
    void KeccakF1600x##N##_StatePermute(uint64_t *state);                                 \
    void shake128x##N##_squeeze(uint8_t **out, size_t outlen, keccakx##N##_state *state); \
    void shake128x##N##_absorb_once(keccakx##N##_state *state, const uint8_t **in,        \
                                    size_t inlen);                                        \
    void shake128x##N##_squeezeblocks(uint8_t **out, size_t nblocks,                      \
                                      keccakx##N##_state *state);                         \
    void shake256x##N##_squeeze(uint8_t **out, size_t outlen, keccakx##N##_state *state); \
    void shake256x##N##_absorb_once(keccakx##N##_state *state, const uint8_t **in,        \
                                    size_t inlen);                                        \
    void shake256x##N##_squeezeblocks(uint8_t **out, size_t nblocks,                      \
                                      keccakx##N##_state *state);                         \
    void shake128x##N(uint8_t **out, size_t outlen, const uint8_t **in, size_t inlen);    \
    void shake256x##N(uint8_t **out, size_t outlen, const uint8_t **in, size_t inlen);    \
    void sha3_256x##N(uint8_t **out, const uint8_t **in, size_t inlen);                   \
    void sha3_512x##N(uint8_t **out, const uint8_t **in, size_t inlen)

#ifdef VECTOR128
typedef struct uint64x2_t {
    uint64_t val[2];
} v128;
typedef struct keccak_x2 {
    v128 s[25];
    unsigned int pos;
} __attribute__((aligned(64))) keccakx2_state;

DEFINE_SHA3_APIS(2);

#endif

#if defined(VECTOR128) && defined(HYBRIDX3)
typedef struct state_3x {
    v128 s_x2[25];
    uint64_t s_x1[25];
} s_x3;
typedef struct keccak_x3 {
    s_x3 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx3_state;

DEFINE_SHA3_APIS(3);
#endif

#if defined(VECTOR128) && defined(HYBRIDX4)
typedef struct state_4x {
    v128 s_x2[25];
    uint64_t s_x1_0[25];
    uint64_t s_x1_1[25];
} s_x4;
typedef struct keccak_x4 {
    s_x4 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx4_state;

DEFINE_SHA3_APIS(4);
#endif

#if defined(VECTOR128) && defined(HYBRIDX5)
typedef struct state_5x {
    v128 s_x2[25];
    uint64_t s_x1_0[25];
    uint64_t s_x1_1[25];
    uint64_t s_x1_2[25];
} s_x5;
typedef struct keccak_x5 {
    s_x5 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx5_state;

DEFINE_SHA3_APIS(5);
#endif

#if defined(VECTOR128) && defined(HYBRIDX6)
typedef struct state_6x {
    v128 s_x2[25];
    uint64_t s_x1_0[25];
    uint64_t s_x1_1[25];
    uint64_t s_x1_2[25];
    uint64_t s_x1_3[25];
} s_x6;
typedef struct keccak_x6 {
    s_x6 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx6_state;

DEFINE_SHA3_APIS(6);
#endif

#if defined(VECTOR128) && defined(HYBRIDX8)
typedef struct state_8x {
    v128 s_x2[25];
    uint64_t s_x1_0[25];
    uint64_t s_x1_1[25];
    uint64_t s_x1_2[25];
    uint64_t s_x1_3[25];
    uint64_t s_x1_4[25];
    uint64_t s_x1_5[25];
} s_x8;
typedef struct keccak_x8 {
    s_x8 s;
    unsigned int pos;
} __attribute__((aligned(64))) keccakx8_state;

DEFINE_SHA3_APIS(8);
#endif

#endif
