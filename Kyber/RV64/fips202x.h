#ifndef FIPS202x_H
#define FIPS202x_H

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define SHAKE128_RATE 168
#define SHAKE256_RATE 136
#define SHA3_256_RATE 136
#define SHA3_512_RATE 72

#define CONCAT(P1, N, P2) P1##N##P2
#define FUNC(P1, N, P2) CONCAT(P1, N, P2)
#define KECCAK(P1, N, P2) CONCAT(P1, N, P2)
#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)
#define S(j, i) s[(i) * (((j) <= 1) + 1) + (j) * ((j) <= 1) + ((j) > 1) * j * 25]

#define DEFINE_SHA3_APIS(N)                                                      \
    void FUNC(KeccakF1600x, N, _StatePermute)(uint64_t * state);                 \
    void FUNC(shake128x, N, _squeeze)(uint8_t * *out, size_t outlen,             \
                                      KECCAK(keccakx, N, _state) * state);       \
    void FUNC(shake128x, N, _absorb_once)(KECCAK(keccakx, N, _state) * state,    \
                                          const uint8_t **in, size_t inlen);     \
    void FUNC(shake128x, N, _squeezeblocks)(uint8_t * *out, size_t nblocks,      \
                                            KECCAK(keccakx, N, _state) * state); \
    void FUNC(shake256x, N, _squeeze)(uint8_t * *out, size_t outlen,             \
                                      KECCAK(keccakx, N, _state) * state);       \
    void FUNC(shake256x, N, _absorb_once)(KECCAK(keccakx, N, _state) * state,    \
                                          const uint8_t **in, size_t inlen);     \
    void FUNC(shake256x, N, _squeezeblocks)(uint8_t * *out, size_t nblocks,      \
                                            KECCAK(keccakx, N, _state) * state); \
    void FUNC(shake128x, N, )(uint8_t * *out, size_t outlen, const uint8_t **in, \
                              size_t inlen);                                     \
    void FUNC(shake256x, N, )(uint8_t * *out, size_t outlen, const uint8_t **in, \
                              size_t inlen);                                     \
    void FUNC(sha3_256x, N, )(uint8_t * *out, const uint8_t **in, size_t inlen); \
    void FUNC(sha3_512x, N, )(uint8_t * *out, const uint8_t **in, size_t inlen)

#define IMPL_SHA3_APIS(N)                                                                     \
    extern void FUNC(KeccakF1600_StatePermute_RV64V_, N, x)(uint64_t * state);                \
    void FUNC(KeccakF1600x, N, _StatePermute)(uint64_t * state)                               \
    {                                                                                         \
        FUNC(KeccakF1600_StatePermute_RV64V_, N, x)(state);                                   \
    }                                                                                         \
    static void FUNC(keccakx, N, _absorb_once)(uint64_t * s, unsigned int r,                  \
                                               const uint8_t **in, size_t inlen, uint8_t p)   \
    {                                                                                         \
        unsigned int i, j;                                                                    \
        const uint8_t *in_t[N];                                                               \
                                                                                              \
        memcpy(in_t, in, sizeof(uint8_t *) * N);                                              \
        memset(s, 0, 25 * N * sizeof(uint64_t));                                              \
                                                                                              \
        while (inlen >= r) {                                                                  \
            for (i = 0; i < r / 8; i++)                                                       \
                for (j = 0; j < N; j++)                                                       \
                    S(j, (i)) ^= *(uint64_t *)(in_t[j] + 8 * i);                              \
                                                                                              \
            for (j = 0; j < N; j++)                                                           \
                in_t[j] += r;                                                                 \
            inlen -= r;                                                                       \
            FUNC(KeccakF1600x, N, _StatePermute)(s);                                          \
        }                                                                                     \
                                                                                              \
        for (i = 0; i < inlen; i++) {                                                         \
            for (j = 0; j < N; j++)                                                           \
                S(j, (i / 8)) ^= (uint64_t)in_t[j][i] << 8 * (i % 8);                         \
        }                                                                                     \
                                                                                              \
        for (j = 0; j < N; j++) {                                                             \
            S(j, (i / 8)) ^= (uint64_t)p << 8 * (i % 8);                                      \
            S(j, ((r - 1) / 8)) ^= 1ULL << 63;                                                \
        }                                                                                     \
    }                                                                                         \
    static unsigned int FUNC(keccakx, N, _squeeze)(                                           \
        uint8_t * *out, size_t outlen, uint64_t * s, unsigned int pos, unsigned int r)        \
    {                                                                                         \
        unsigned int i, j;                                                                    \
        uint8_t *out_t[N];                                                                    \
                                                                                              \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                                            \
        while (outlen) {                                                                      \
            if (pos == r) {                                                                   \
                FUNC(KeccakF1600x, N, _StatePermute)(s);                                      \
                pos = 0;                                                                      \
            }                                                                                 \
            for (i = pos; i < r && i < pos + outlen; i++)                                     \
                for (j = 0; j < N; j++)                                                       \
                    *out_t[j]++ = S(j, (i / 8)) >> 8 * (i % 8);                               \
                                                                                              \
            outlen -= i - pos;                                                                \
            pos = i;                                                                          \
        }                                                                                     \
                                                                                              \
        return pos;                                                                           \
    }                                                                                         \
    static void FUNC(keccakx, N, _squeezeblocks)(uint8_t * *out, size_t nblocks,              \
                                                 uint64_t * s, unsigned int r)                \
    {                                                                                         \
        unsigned int i, j;                                                                    \
        uint8_t *out_t[N];                                                                    \
                                                                                              \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                                            \
        while (nblocks) {                                                                     \
            FUNC(KeccakF1600x, N, _StatePermute)(s);                                          \
            for (i = 0; i < r / 8; i++)                                                       \
                for (j = 0; j < N; j++)                                                       \
                    *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));                              \
                                                                                              \
            for (j = 0; j < N; j++)                                                           \
                out_t[j] += r;                                                                \
            nblocks -= 1;                                                                     \
        }                                                                                     \
    }                                                                                         \
    void FUNC(shake128x, N, _squeeze)(uint8_t * *out, size_t outlen,                          \
                                      KECCAK(keccakx, N, _state) * state)                     \
    {                                                                                         \
        state->pos = FUNC(keccakx, N, _squeeze)(out, outlen, (uint64_t *)&state->s,           \
                                                state->pos, SHAKE128_RATE);                   \
    }                                                                                         \
    void FUNC(shake128x, N, _absorb_once)(KECCAK(keccakx, N, _state) * state,                 \
                                          const uint8_t **in, size_t inlen)                   \
    {                                                                                         \
        FUNC(keccakx, N, _absorb_once)                                                        \
        ((uint64_t *)&state->s, SHAKE128_RATE, in, inlen, 0x1F);                              \
        state->pos = SHAKE128_RATE;                                                           \
    }                                                                                         \
    void FUNC(shake128x, N, _squeezeblocks)(uint8_t * *out, size_t nblocks,                   \
                                            KECCAK(keccakx, N, _state) * state)               \
    {                                                                                         \
        FUNC(keccakx, N, _squeezeblocks)(out, nblocks, (uint64_t *)&state->s, SHAKE128_RATE); \
    }                                                                                         \
    void FUNC(shake256x, N, _squeeze)(uint8_t * *out, size_t outlen,                          \
                                      KECCAK(keccakx, N, _state) * state)                     \
    {                                                                                         \
        state->pos = FUNC(keccakx, N, _squeeze)(out, outlen, (uint64_t *)&state->s,           \
                                                state->pos, SHAKE256_RATE);                   \
    }                                                                                         \
    void FUNC(shake256x, N, _absorb_once)(KECCAK(keccakx, N, _state) * state,                 \
                                          const uint8_t **in, size_t inlen)                   \
    {                                                                                         \
        FUNC(keccakx, N, _absorb_once)                                                        \
        ((uint64_t *)&state->s, SHAKE256_RATE, in, inlen, 0x1F);                              \
        state->pos = SHAKE256_RATE;                                                           \
    }                                                                                         \
    void FUNC(shake256x, N, _squeezeblocks)(uint8_t * *out, size_t nblocks,                   \
                                            KECCAK(keccakx, N, _state) * state)               \
    {                                                                                         \
        FUNC(keccakx, N, _squeezeblocks)(out, nblocks, (uint64_t *)&state->s, SHAKE256_RATE); \
    }                                                                                         \
    void FUNC(shake128x, N, )(uint8_t * *out, size_t outlen, const uint8_t **in,              \
                              size_t inlen)                                                   \
    {                                                                                         \
        unsigned int j;                                                                       \
        size_t nblocks;                                                                       \
        KECCAK(keccakx, N, _state) * state;                                                   \
        if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {                   \
            printf("%s: malloc failed\n", STR(FUNC(shake128x, N, )));                         \
        }                                                                                     \
        uint8_t *out_t[N];                                                                    \
                                                                                              \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                                            \
        FUNC(shake128x, N, _absorb_once)(state, in, inlen);                                   \
        nblocks = outlen / SHAKE128_RATE;                                                     \
        FUNC(shake128x, N, _squeezeblocks)(out_t, nblocks, state);                            \
        outlen -= nblocks * SHAKE128_RATE;                                                    \
        for (j = 0; j < N; j++)                                                               \
            out_t[j] += nblocks * SHAKE128_RATE;                                              \
        FUNC(shake128x, N, _squeeze)(out_t, outlen, state);                                   \
        free(state);                                                                          \
    }                                                                                         \
    void FUNC(shake256x, N, )(uint8_t * *out, size_t outlen, const uint8_t **in,              \
                              size_t inlen)                                                   \
    {                                                                                         \
        unsigned int j;                                                                       \
        size_t nblocks;                                                                       \
        KECCAK(keccakx, N, _state) * state;                                                   \
        if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {                   \
            printf("%s: malloc failed\n", STR(FUNC(shake256x, N, )));                         \
        }                                                                                     \
        uint8_t *out_t[N];                                                                    \
                                                                                              \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                                            \
        FUNC(shake256x, N, _absorb_once)(state, in, inlen);                                   \
        nblocks = outlen / SHAKE256_RATE;                                                     \
        FUNC(shake256x, N, _squeezeblocks)(out_t, nblocks, state);                            \
        outlen -= nblocks * SHAKE256_RATE;                                                    \
        for (j = 0; j < N; j++)                                                               \
            out_t[j] += nblocks * SHAKE256_RATE;                                              \
        FUNC(shake256x, N, _squeeze)(out_t, outlen, state);                                   \
        free(state);                                                                          \
    }                                                                                         \
    void FUNC(sha3_256x, N, )(uint8_t * *out, const uint8_t **in, size_t inlen)               \
    {                                                                                         \
        unsigned int i, j;                                                                    \
        KECCAK(keccakx, N, _state) * state;                                                   \
        if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {                   \
            printf("%s: malloc failed\n", STR(FUNC(sha3_256x, N, )));                         \
        }                                                                                     \
        uint64_t *s;                                                                          \
        uint8_t *out_t[N];                                                                    \
                                                                                              \
        s = (uint64_t *)&(state->s);                                                          \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                                            \
        FUNC(keccakx, N, _absorb_once)(s, SHA3_256_RATE, in, inlen, 0x06);                    \
        FUNC(KeccakF1600x, N, _StatePermute)(s);                                              \
        for (i = 0; i < 4; i++)                                                               \
            for (j = 0; j < N; j++)                                                           \
                *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));                                  \
        free(state);                                                                          \
    }                                                                                         \
    void FUNC(sha3_512x, N, )(uint8_t * *out, const uint8_t **in, size_t inlen)               \
    {                                                                                         \
        unsigned int i, j;                                                                    \
        KECCAK(keccakx, N, _state) * state;                                                   \
        if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {                   \
            printf("%s: malloc failed\n", STR(FUNC(sha3_512x, N, )));                         \
        }                                                                                     \
        uint64_t *s;                                                                          \
        uint8_t *out_t[N];                                                                    \
                                                                                              \
        s = (uint64_t *)&(state->s);                                                          \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                                            \
        FUNC(keccakx, N, _absorb_once)(s, SHA3_512_RATE, in, inlen, 0x06);                    \
        FUNC(KeccakF1600x, N, _StatePermute)(s);                                              \
        for (i = 0; i < 8; i++)                                                               \
            for (j = 0; j < N; j++)                                                           \
                *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));                                  \
        free(state);                                                                          \
    }

#define IMPL_TEST_SHA3(N)                                         \
    void FUNC(test_sha3x, N, )(void)                              \
    {                                                             \
        unsigned int j, ok = 0;                                   \
        uint8_t out[64 * N];                                      \
        uint8_t *shake_out;                                       \
        uint8_t *outN[N];                                         \
        const uint8_t *inN[N];                                    \
                                                                  \
        if ((shake_out = (uint8_t *)malloc(252 * N)) == NULL) {   \
            printf("malloc failed\n");                            \
            return;                                               \
        }                                                         \
                                                                  \
        for (j = 0; j < N; j++) {                                 \
            outN[j] = out + 32 * j;                               \
            inN[j] = sha3_input;                                  \
        }                                                         \
        FUNC(sha3_256x, N, )(outN, inN, sizeof(sha3_input));      \
        ok = 0;                                                   \
        for (j = 0; j < N; j++)                                   \
            ok |= memcmp(outN[j], sha3_256_output, 32);           \
        if (ok != 0) {                                            \
            printf("sha3_256x" #N " FAILED: \n");                 \
            for (j = 0; j < N; j++)                               \
                print_bytes(outN[j], 32);                         \
        }                                                         \
                                                                  \
        for (j = 0; j < N; j++) {                                 \
            outN[j] = out + 64 * j;                               \
            inN[j] = sha3_input;                                  \
        }                                                         \
        FUNC(sha3_512x, N, )(outN, inN, sizeof(sha3_input));      \
        ok = 0;                                                   \
        for (j = 0; j < N; j++)                                   \
            ok |= memcmp(outN[j], sha3_512_output, 64);           \
        if (ok != 0) {                                            \
            printf("sha3_512x" #N " FAILED: \n");                 \
            for (j = 0; j < N; j++)                               \
                print_bytes(outN[j], 64);                         \
        }                                                         \
                                                                  \
        for (j = 0; j < N; j++) {                                 \
            outN[j] = shake_out + 252 * j;                        \
            inN[j] = sha3_input;                                  \
        }                                                         \
        FUNC(shake128x, N, )(outN, 252, inN, sizeof(sha3_input)); \
        ok = 0;                                                   \
        for (j = 0; j < N; j++)                                   \
            ok |= memcmp(outN[j], shake128_output, 252);          \
        if (ok != 0) {                                            \
            printf("shake128x" #N " FAILED: \n");                 \
            for (j = 0; j < N; j++)                               \
                print_bytes(outN[j], 252);                        \
        }                                                         \
                                                                  \
        for (j = 0; j < N; j++) {                                 \
            outN[j] = shake_out + 252 * j;                        \
            inN[j] = sha3_input;                                  \
        }                                                         \
        FUNC(shake256x, N, )(outN, 252, inN, sizeof(sha3_input)); \
        ok = 0;                                                   \
        for (j = 0; j < N; j++)                                   \
            ok |= memcmp(outN[j], shake256_output, 252);          \
        if (ok != 0) {                                            \
            printf("shake128x" #N " FAILED: \n");                 \
            for (j = 0; j < N; j++)                               \
                print_bytes(outN[j], 252);                        \
        }                                                         \
        free(shake_out);                                          \
    }

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
