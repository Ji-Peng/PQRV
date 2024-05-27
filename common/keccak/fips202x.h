#ifndef FIPS202x_H
#define FIPS202x_H

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "fips202.h"

#define SHAKE128_RATE 168
#define SHAKE256_RATE 136
#define SHA3_256_RATE 136
#define SHA3_512_RATE 72

#define CONCAT(P1, N, P2) P1##N##P2
#define FUNC(P1, N, P2) CONCAT(P1, N, P2)
#define KECCAK(P1, N, P2) CONCAT(P1, N, P2)
#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)
// This looks quite complicated, don't worry, the compiler will process it
// into a very simple calculation.
// For example:
// j=0/1: S(j, i) == s[2*i+j]
// j >=2: S(j, i) == s[i+j*25]
#define S(j, i) \
    s[(i) * (((j) <= 1) + 1) + (j) * ((j) <= 1) + ((j) > 1) * j * 25]
#define POS(STATE, N) *(STATE + 25 * N)

#define DEFINE_SHA3_APIS(N)                                              \
    void FUNC(KeccakF1600x, N, _StatePermute)(uint64_t * state);         \
    void FUNC(shake128x, N, _init)(KECCAK(keccakx, N, _state) * state);  \
    void FUNC(shake128x, N, _absorb)(KECCAK(keccakx, N, _state) * state, \
                                     const uint8_t **in, size_t inlen);  \
    void FUNC(shake128x, N,                                              \
              _finalize)(KECCAK(keccakx, N, _state) * state);            \
    void FUNC(shake128x, N, _squeeze)(                                   \
        uint8_t * *out, size_t outlen,                                   \
        KECCAK(keccakx, N, _state) * state);                             \
    void FUNC(shake128x, N, _absorb_once)(                               \
        KECCAK(keccakx, N, _state) * state, const uint8_t **in,          \
        size_t inlen);                                                   \
    void FUNC(shake128x, N, _squeezeblocks)(                             \
        uint8_t * *out, size_t nblocks,                                  \
        KECCAK(keccakx, N, _state) * state);                             \
    void FUNC(shake256x, N, _init)(KECCAK(keccakx, N, _state) * state);  \
    void FUNC(shake256x, N, _absorb)(KECCAK(keccakx, N, _state) * state, \
                                     const uint8_t **in, size_t inlen);  \
    void FUNC(shake256x, N,                                              \
              _finalize)(KECCAK(keccakx, N, _state) * state);            \
    void FUNC(shake256x, N, _squeeze)(                                   \
        uint8_t * *out, size_t outlen,                                   \
        KECCAK(keccakx, N, _state) * state);                             \
    void FUNC(shake256x, N, _absorb_once)(                               \
        KECCAK(keccakx, N, _state) * state, const uint8_t **in,          \
        size_t inlen);                                                   \
    void FUNC(shake256x, N, _squeezeblocks)(                             \
        uint8_t * *out, size_t nblocks,                                  \
        KECCAK(keccakx, N, _state) * state);                             \
    void FUNC(shake128x, N, )(uint8_t * *out, size_t outlen,             \
                              const uint8_t **in, size_t inlen);         \
    void FUNC(shake256x, N, )(uint8_t * *out, size_t outlen,             \
                              const uint8_t **in, size_t inlen);         \
    void FUNC(sha3_256x, N, )(uint8_t * *out, const uint8_t **in,        \
                              size_t inlen);                             \
    void FUNC(sha3_512x, N, )(uint8_t * *out, const uint8_t **in,        \
                              size_t inlen);                             \
    void FUNC(keccakx, N, _get_oneway_state)(                            \
        KECCAK(keccakx, N, _state) * state, keccak_state * oneway_state, \
        unsigned int j)

#define IMPL_SHA3X_APIS(N)                                                \
    static void FUNC(keccakx, N, _init)(uint64_t * s)                     \
    {                                                                     \
        memset(s, 0, 25 * N * sizeof(uint64_t));                          \
    }                                                                     \
    static int FUNC(keccakx, N, _absorb)(                                 \
        uint64_t * s, unsigned int pos, unsigned int r,                   \
        const uint8_t **in, size_t inlen)                                 \
    {                                                                     \
        unsigned int i, j;                                                \
        const uint8_t *in_t[N];                                           \
                                                                          \
        memcpy(in_t, in, sizeof(uint8_t *) * N);                          \
                                                                          \
        while (pos + inlen >= r) {                                        \
            for (i = pos; i < r; i++)                                     \
                for (j = 0; j < N; j++)                                   \
                    S(j, (i / 8)) ^= (uint64_t)in_t[j][i - pos]           \
                                     << 8 * (i % 8);                      \
                                                                          \
            for (j = 0; j < N; j++) {                                     \
                in_t[j] += (r - pos);                                     \
            }                                                             \
            inlen -= (r - pos);                                           \
            FUNC(KeccakF1600x, N, _StatePermute)(s);                      \
            pos = 0;                                                      \
        }                                                                 \
        for (i = pos; i < pos + inlen; i++)                               \
            for (j = 0; j < N; j++)                                       \
                S(j, (i / 8)) ^= (uint64_t)in_t[j][i - pos]               \
                                 << 8 * (i % 8);                          \
        return i;                                                         \
    }                                                                     \
    static void FUNC(keccakx, N, _finalize)(                              \
        uint64_t * s, unsigned int pos, unsigned int r, uint8_t p)        \
    {                                                                     \
        unsigned int j;                                                   \
                                                                          \
        for (j = 0; j < N; j++) {                                         \
            S(j, (pos / 8)) ^= (uint64_t)p << 8 * (pos % 8);              \
            S(j, ((r - 1) / 8)) ^= 1ULL << 63;                            \
        }                                                                 \
    }                                                                     \
    static void FUNC(keccakx, N, _absorb_once)(                           \
        uint64_t * s, unsigned int r, const uint8_t **in, size_t inlen,   \
        uint8_t p)                                                        \
    {                                                                     \
        unsigned int i, j;                                                \
        const uint8_t *in_t[N];                                           \
                                                                          \
        memcpy(in_t, in, sizeof(uint8_t *) * N);                          \
        memset(s, 0, 25 * N * sizeof(uint64_t));                          \
                                                                          \
        while (inlen >= r) {                                              \
            for (i = 0; i < r / 8; i++)                                   \
                for (j = 0; j < N; j++)                                   \
                    S(j, (i)) ^= *(uint64_t *)(in_t[j] + 8 * i);          \
                                                                          \
            for (j = 0; j < N; j++)                                       \
                in_t[j] += r;                                             \
            inlen -= r;                                                   \
            FUNC(KeccakF1600x, N, _StatePermute)(s);                      \
        }                                                                 \
                                                                          \
        for (i = 0; i < inlen; i++) {                                     \
            for (j = 0; j < N; j++)                                       \
                S(j, (i / 8)) ^= (uint64_t)in_t[j][i] << 8 * (i % 8);     \
        }                                                                 \
                                                                          \
        for (j = 0; j < N; j++) {                                         \
            S(j, (i / 8)) ^= (uint64_t)p << 8 * (i % 8);                  \
            S(j, ((r - 1) / 8)) ^= 1ULL << 63;                            \
        }                                                                 \
    }                                                                     \
    static unsigned int FUNC(keccakx, N, _squeeze)(                       \
        uint8_t * *out, size_t outlen, uint64_t * s, unsigned int pos,    \
        unsigned int r)                                                   \
    {                                                                     \
        unsigned int i, j;                                                \
        uint8_t *out_t[N];                                                \
                                                                          \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                        \
        while (outlen) {                                                  \
            if (pos == r) {                                               \
                FUNC(KeccakF1600x, N, _StatePermute)(s);                  \
                pos = 0;                                                  \
            }                                                             \
            for (i = pos; i < r && i < pos + outlen; i++)                 \
                for (j = 0; j < N; j++)                                   \
                    *out_t[j]++ = S(j, (i / 8)) >> 8 * (i % 8);           \
                                                                          \
            outlen -= i - pos;                                            \
            pos = i;                                                      \
        }                                                                 \
                                                                          \
        return pos;                                                       \
    }                                                                     \
    static void FUNC(keccakx, N, _squeezeblocks)(                         \
        uint8_t * *out, size_t nblocks, uint64_t * s, unsigned int r)     \
    {                                                                     \
        unsigned int i, j;                                                \
        uint8_t *out_t[N];                                                \
                                                                          \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                        \
        while (nblocks) {                                                 \
            FUNC(KeccakF1600x, N, _StatePermute)(s);                      \
            for (i = 0; i < r / 8; i++)                                   \
                for (j = 0; j < N; j++)                                   \
                    *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));          \
                                                                          \
            for (j = 0; j < N; j++)                                       \
                out_t[j] += r;                                            \
            nblocks -= 1;                                                 \
        }                                                                 \
    }                                                                     \
    void FUNC(shake128x, N, _init)(KECCAK(keccakx, N, _state) * s)        \
    {                                                                     \
        FUNC(keccakx, N, _init)((uint64_t *)&s->s);                       \
        s->pos = 0;                                                       \
    }                                                                     \
    void FUNC(shake128x, N, _absorb)(KECCAK(keccakx, N, _state) * s,      \
                                     const uint8_t **in, size_t inlen)    \
    {                                                                     \
        s->pos = FUNC(keccakx, N, _absorb)((uint64_t *)&s->s, s->pos,     \
                                           SHAKE128_RATE, in, inlen);     \
    }                                                                     \
    void FUNC(shake128x, N, _finalize)(KECCAK(keccakx, N, _state) * s)    \
    {                                                                     \
        FUNC(keccakx, N, _finalize)                                       \
        ((uint64_t *)&s->s, s->pos, SHAKE128_RATE, 0x1F);                 \
        s->pos = SHAKE128_RATE;                                           \
    }                                                                     \
    void FUNC(shake128x, N, _squeeze)(uint8_t * *out, size_t outlen,      \
                                      KECCAK(keccakx, N, _state) * state) \
    {                                                                     \
        state->pos = FUNC(keccakx, N, _squeeze)(                          \
            out, outlen, (uint64_t *)&state->s, state->pos,               \
            SHAKE128_RATE);                                               \
    }                                                                     \
    void FUNC(shake128x, N, _absorb_once)(                                \
        KECCAK(keccakx, N, _state) * state, const uint8_t **in,           \
        size_t inlen)                                                     \
    {                                                                     \
        FUNC(keccakx, N, _absorb_once)                                    \
        ((uint64_t *)&state->s, SHAKE128_RATE, in, inlen, 0x1F);          \
        state->pos = SHAKE128_RATE;                                       \
    }                                                                     \
    void FUNC(shake128x, N, _squeezeblocks)(                              \
        uint8_t * *out, size_t nblocks,                                   \
        KECCAK(keccakx, N, _state) * state)                               \
    {                                                                     \
        FUNC(keccakx, N, _squeezeblocks)                                  \
        (out, nblocks, (uint64_t *)&state->s, SHAKE128_RATE);             \
    }                                                                     \
    void FUNC(shake256x, N, _init)(KECCAK(keccakx, N, _state) * s)        \
    {                                                                     \
        FUNC(keccakx, N, _init)((uint64_t *)&s->s);                       \
        s->pos = 0;                                                       \
    }                                                                     \
    void FUNC(shake256x, N, _absorb)(KECCAK(keccakx, N, _state) * s,      \
                                     const uint8_t **in, size_t inlen)    \
    {                                                                     \
        s->pos = FUNC(keccakx, N, _absorb)((uint64_t *)&s->s, s->pos,     \
                                           SHAKE256_RATE, in, inlen);     \
    }                                                                     \
    void FUNC(shake256x, N, _finalize)(KECCAK(keccakx, N, _state) * s)    \
    {                                                                     \
        FUNC(keccakx, N, _finalize)                                       \
        ((uint64_t *)&s->s, s->pos, SHAKE256_RATE, 0x1F);                 \
        s->pos = SHAKE256_RATE;                                           \
    }                                                                     \
    void FUNC(shake256x, N, _squeeze)(uint8_t * *out, size_t outlen,      \
                                      KECCAK(keccakx, N, _state) * state) \
    {                                                                     \
        state->pos = FUNC(keccakx, N, _squeeze)(                          \
            out, outlen, (uint64_t *)&state->s, state->pos,               \
            SHAKE256_RATE);                                               \
    }                                                                     \
    void FUNC(shake256x, N, _absorb_once)(                                \
        KECCAK(keccakx, N, _state) * state, const uint8_t **in,           \
        size_t inlen)                                                     \
    {                                                                     \
        FUNC(keccakx, N, _absorb_once)                                    \
        ((uint64_t *)&state->s, SHAKE256_RATE, in, inlen, 0x1F);          \
        state->pos = SHAKE256_RATE;                                       \
    }                                                                     \
    void FUNC(shake256x, N, _squeezeblocks)(                              \
        uint8_t * *out, size_t nblocks,                                   \
        KECCAK(keccakx, N, _state) * state)                               \
    {                                                                     \
        FUNC(keccakx, N, _squeezeblocks)                                  \
        (out, nblocks, (uint64_t *)&state->s, SHAKE256_RATE);             \
    }                                                                     \
    void FUNC(shake128x, N, )(uint8_t * *out, size_t outlen,              \
                              const uint8_t **in, size_t inlen)           \
    {                                                                     \
        unsigned int j;                                                   \
        size_t nblocks;                                                   \
        KECCAK(keccakx, N, _state) * state;                               \
        if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) ==       \
            NULL) {                                                       \
            printf("%s: malloc failed\n", STR(FUNC(shake128x, N, )));     \
        }                                                                 \
        uint8_t *out_t[N];                                                \
                                                                          \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                        \
        FUNC(shake128x, N, _absorb_once)(state, in, inlen);               \
        nblocks = outlen / SHAKE128_RATE;                                 \
        FUNC(shake128x, N, _squeezeblocks)(out_t, nblocks, state);        \
        outlen -= nblocks * SHAKE128_RATE;                                \
        for (j = 0; j < N; j++)                                           \
            out_t[j] += nblocks * SHAKE128_RATE;                          \
        FUNC(shake128x, N, _squeeze)(out_t, outlen, state);               \
        free(state);                                                      \
    }                                                                     \
    void FUNC(shake256x, N, )(uint8_t * *out, size_t outlen,              \
                              const uint8_t **in, size_t inlen)           \
    {                                                                     \
        unsigned int j;                                                   \
        size_t nblocks;                                                   \
        KECCAK(keccakx, N, _state) * state;                               \
        if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) ==       \
            NULL) {                                                       \
            printf("%s: malloc failed\n", STR(FUNC(shake256x, N, )));     \
        }                                                                 \
        uint8_t *out_t[N];                                                \
                                                                          \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                        \
        FUNC(shake256x, N, _absorb_once)(state, in, inlen);               \
        nblocks = outlen / SHAKE256_RATE;                                 \
        FUNC(shake256x, N, _squeezeblocks)(out_t, nblocks, state);        \
        outlen -= nblocks * SHAKE256_RATE;                                \
        for (j = 0; j < N; j++)                                           \
            out_t[j] += nblocks * SHAKE256_RATE;                          \
        FUNC(shake256x, N, _squeeze)(out_t, outlen, state);               \
        free(state);                                                      \
    }                                                                     \
    void FUNC(sha3_256x, N, )(uint8_t * *out, const uint8_t **in,         \
                              size_t inlen)                               \
    {                                                                     \
        unsigned int i, j;                                                \
        KECCAK(keccakx, N, _state) * state;                               \
        uint64_t *s;                                                      \
        uint8_t *out_t[N];                                                \
        if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) ==       \
            NULL) {                                                       \
            printf("%s: malloc failed\n", STR(FUNC(sha3_256x, N, )));     \
        }                                                                 \
                                                                          \
        s = (uint64_t *)&(state->s);                                      \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                        \
        FUNC(keccakx, N, _absorb_once)                                    \
        (s, SHA3_256_RATE, in, inlen, 0x06);                              \
        FUNC(KeccakF1600x, N, _StatePermute)(s);                          \
        for (i = 0; i < 4; i++)                                           \
            for (j = 0; j < N; j++)                                       \
                *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));              \
        free(state);                                                      \
    }                                                                     \
    void FUNC(sha3_512x, N, )(uint8_t * *out, const uint8_t **in,         \
                              size_t inlen)                               \
    {                                                                     \
        unsigned int i, j;                                                \
        KECCAK(keccakx, N, _state) * state;                               \
        uint64_t *s;                                                      \
        uint8_t *out_t[N];                                                \
        if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) ==       \
            NULL) {                                                       \
            printf("%s: malloc failed\n", STR(FUNC(sha3_512x, N, )));     \
        }                                                                 \
                                                                          \
        s = (uint64_t *)&(state->s);                                      \
        memcpy(out_t, out, sizeof(uint8_t *) * N);                        \
        FUNC(keccakx, N, _absorb_once)                                    \
        (s, SHA3_512_RATE, in, inlen, 0x06);                              \
        FUNC(KeccakF1600x, N, _StatePermute)(s);                          \
        for (i = 0; i < 8; i++)                                           \
            for (j = 0; j < N; j++)                                       \
                *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));              \
        free(state);                                                      \
    }                                                                     \
    void FUNC(keccakx, N, _get_oneway_state)(                             \
        KECCAK(keccakx, N, _state) * state, keccak_state * oneway_state,  \
        unsigned int j)                                                   \
    {                                                                     \
        unsigned int i;                                                   \
        uint64_t *s = (uint64_t *)&(state->s);                            \
        for (i = 0; i < 25; i++) {                                        \
            oneway_state->s[i] = S(j, i);                                 \
        }                                                                 \
        oneway_state->pos = state->pos;                                   \
    }

#define IMPL_SHA3_RV64_APIS(N)                                  \
    extern void FUNC(KeccakF1600_StatePermute_RV64V_, N,        \
                     x)(uint64_t * state);                      \
    void FUNC(KeccakF1600x, N, _StatePermute)(uint64_t * state) \
    {                                                           \
        FUNC(KeccakF1600_StatePermute_RV64V_, N, x)(state);     \
    }                                                           \
    IMPL_SHA3X_APIS(N)

#ifdef BIT_INTERLEAVING

/**
 * https://github.com/XKCP/XKCP/blob/master/lib/low/KeccakP-1600/plain-32bits-inplace/KeccakP-1600-inplace32BI.c
 * Credit to Henry S. Warren, Hacker's Delight, Addison-Wesley, 2002
 */
#    define prepareToBitInterleaving(low, high, temp, temp0, temp1) \
        temp0 = (low);                                              \
        temp = (temp0 ^ (temp0 >> 1)) & 0x22222222UL;               \
        temp0 = temp0 ^ temp ^ (temp << 1);                         \
        temp = (temp0 ^ (temp0 >> 2)) & 0x0C0C0C0CUL;               \
        temp0 = temp0 ^ temp ^ (temp << 2);                         \
        temp = (temp0 ^ (temp0 >> 4)) & 0x00F000F0UL;               \
        temp0 = temp0 ^ temp ^ (temp << 4);                         \
        temp = (temp0 ^ (temp0 >> 8)) & 0x0000FF00UL;               \
        temp0 = temp0 ^ temp ^ (temp << 8);                         \
        temp1 = (high);                                             \
        temp = (temp1 ^ (temp1 >> 1)) & 0x22222222UL;               \
        temp1 = temp1 ^ temp ^ (temp << 1);                         \
        temp = (temp1 ^ (temp1 >> 2)) & 0x0C0C0C0CUL;               \
        temp1 = temp1 ^ temp ^ (temp << 2);                         \
        temp = (temp1 ^ (temp1 >> 4)) & 0x00F000F0UL;               \
        temp1 = temp1 ^ temp ^ (temp << 4);                         \
        temp = (temp1 ^ (temp1 >> 8)) & 0x0000FF00UL;               \
        temp1 = temp1 ^ temp ^ (temp << 8)

#    define toBitInterleavingAndXOR(low, high, even, odd, temp, temp0, \
                                    temp1)                             \
        prepareToBitInterleaving(low, high, temp, temp0, temp1);       \
        even ^= (temp0 & 0x0000FFFF) | (temp1 << 16);                  \
        odd ^= (temp0 >> 16) | (temp1 & 0xFFFF0000)

#    define toBitInterleavingAndXOR64b(in, out, temp, temp0, temp1)       \
        prepareToBitInterleaving((uint32_t)(in & 0xFFFFFFFF),             \
                                 (uint32_t)(in >> 32), temp, temp0,       \
                                 temp1);                                  \
        out ^= ((uint64_t)((temp0 >> 16) | (temp1 & 0xFFFF0000)) << 32) | \
               ((temp0 & 0x0000FFFF) | (temp1 << 16))

#    define toBitInterleaving64b(in, out, temp, temp0, temp1)            \
        prepareToBitInterleaving((uint32_t)(in & 0xFFFFFFFF),            \
                                 (uint32_t)(in >> 32), temp, temp0,      \
                                 temp1);                                 \
        out = ((uint64_t)((temp0 >> 16) | (temp1 & 0xFFFF0000)) << 32) | \
              ((temp0 & 0x0000FFFF) | (temp1 << 16))

#    define prepareFromBitInterleaving(even, odd, temp, temp0, temp1) \
        temp0 = (even);                                               \
        temp1 = (odd);                                                \
        temp = (temp0 & 0x0000FFFF) | (temp1 << 16);                  \
        temp1 = (temp0 >> 16) | (temp1 & 0xFFFF0000);                 \
        temp0 = temp;                                                 \
        temp = (temp0 ^ (temp0 >> 8)) & 0x0000FF00UL;                 \
        temp0 = temp0 ^ temp ^ (temp << 8);                           \
        temp = (temp0 ^ (temp0 >> 4)) & 0x00F000F0UL;                 \
        temp0 = temp0 ^ temp ^ (temp << 4);                           \
        temp = (temp0 ^ (temp0 >> 2)) & 0x0C0C0C0CUL;                 \
        temp0 = temp0 ^ temp ^ (temp << 2);                           \
        temp = (temp0 ^ (temp0 >> 1)) & 0x22222222UL;                 \
        temp0 = temp0 ^ temp ^ (temp << 1);                           \
        temp = (temp1 ^ (temp1 >> 8)) & 0x0000FF00UL;                 \
        temp1 = temp1 ^ temp ^ (temp << 8);                           \
        temp = (temp1 ^ (temp1 >> 4)) & 0x00F000F0UL;                 \
        temp1 = temp1 ^ temp ^ (temp << 4);                           \
        temp = (temp1 ^ (temp1 >> 2)) & 0x0C0C0C0CUL;                 \
        temp1 = temp1 ^ temp ^ (temp << 2);                           \
        temp = (temp1 ^ (temp1 >> 1)) & 0x22222222UL;                 \
        temp1 = temp1 ^ temp ^ (temp << 1)

#    define fromBitInterleaving(even, odd, low, high, temp, temp0, temp1) \
        prepareFromBitInterleaving(even, odd, temp, temp0, temp1);        \
        low = temp0;                                                      \
        high = temp1

#    define fromBitInterleaving64b(in, out, temp, temp0, temp1)       \
        prepareFromBitInterleaving((uint32_t)(in & 0xFFFFFFFF),       \
                                   (uint32_t)(in >> 32), temp, temp0, \
                                   temp1);                            \
        out = (((uint64_t)temp1 << 32) | temp0)
#endif

#ifdef BIT_INTERLEAVING
#    define IMPL_SHA3_RV32_APIS(N)                                        \
        extern void FUNC(KeccakF1600_StatePermute_RV32V_, N,              \
                         x)(uint64_t * state);                            \
        void FUNC(KeccakF1600x, N, _StatePermute)(uint64_t * state)       \
        {                                                                 \
            FUNC(KeccakF1600_StatePermute_RV32V_, N, x)(state);           \
        }                                                                 \
        static void FUNC(keccakx, N, _init)(uint64_t * s)                 \
        {                                                                 \
            memset(s, 0, 25 * N * sizeof(uint64_t));                      \
        }                                                                 \
        static int FUNC(keccakx, N, _absorb)(                             \
            uint64_t * s, unsigned int pos, unsigned int r,               \
            const uint8_t **in, size_t inlen)                             \
        {                                                                 \
            unsigned int j, k, k_start, k_end;                            \
            const uint8_t *in_t[N];                                       \
            size_t index[N] = {0};                                        \
            uint8_t buf[8];                                               \
            uint64_t temp;                                                \
            uint32_t t, t0, t1;                                           \
                                                                          \
            memcpy(in_t, in, sizeof(uint8_t *) * N);                      \
            while (inlen > 0) {                                           \
                if (r - pos >= 8 && inlen >= 8) {                         \
                    k_start = 0;                                          \
                    k_end = 8;                                            \
                } else if (r - pos >= 8 && inlen < 8) {                   \
                    k_start = 0;                                          \
                    k_end = inlen;                                        \
                } else {                                                  \
                    k_start = 8 - (r - pos);                              \
                    k_end = 8;                                            \
                }                                                         \
                for (j = 0; j < N; j++) {                                 \
                    memset(buf, 0, 8 * sizeof(uint8_t));                  \
                    for (k = k_start; k < k_end; k++)                     \
                        buf[k] = in_t[j][index[j]++];                     \
                    if (j < 2) {                                          \
                        for (k = 0; k < 8; k++)                           \
                            S(j, ((pos + k) / 8)) ^=                      \
                                (uint64_t)buf[k] << 8 * ((pos + k) % 8);  \
                    } else {                                              \
                        temp = *(uint64_t *)buf;                          \
                        toBitInterleaving64b(temp, *(uint64_t *)buf, t,   \
                                             t0, t1);                     \
                        for (k = 0; k < 8; k++)                           \
                            S(j, ((pos + k) / 8)) ^=                      \
                                (uint64_t)buf[k] << 8 * ((pos + k) % 8);  \
                    }                                                     \
                }                                                         \
                pos += (k_end - k_start);                                 \
                inlen -= (k_end - k_start);                               \
                if (pos == r) {                                           \
                    FUNC(KeccakF1600x, N, _StatePermute)(s);              \
                    pos = 0;                                              \
                }                                                         \
            }                                                             \
            return pos;                                                   \
        }                                                                 \
        static void FUNC(keccakx, N, _finalize)(                          \
            uint64_t * s, unsigned int pos, unsigned int r, uint8_t p)    \
        {                                                                 \
            unsigned int j;                                               \
            uint8_t buf[8];                                               \
            uint64_t temp;                                                \
            uint32_t t, t0, t1;                                           \
                                                                          \
            for (j = 0; j < N; j++) {                                     \
                memset(buf, 0, 8 * sizeof(uint8_t));                      \
                buf[pos % 8] = p;                                         \
                if (j < 2) {                                              \
                    S(j, (pos >> 3)) ^= *(uint64_t *)buf;                 \
                    S(j, ((r - 1) / 8)) ^= (1ULL << 63);                  \
                } else {                                                  \
                    temp = *(uint64_t *)buf;                              \
                    toBitInterleaving64b(temp, *(uint64_t *)buf, t, t0,   \
                                         t1);                             \
                    S(j, (pos >> 3)) ^= *(uint64_t *)buf;                 \
                    toBitInterleavingAndXOR64b(                           \
                        (1ULL << 63), S(j, ((r - 1) / 8)), t, t0, t1);    \
                }                                                         \
            }                                                             \
        }                                                                 \
        static void FUNC(keccakx, N, _absorb_once)(                       \
            uint64_t * s, unsigned int r, const uint8_t **in,             \
            size_t inlen, uint8_t p)                                      \
        {                                                                 \
            unsigned int i, j, k;                                         \
            const uint8_t *in_t[N];                                       \
            uint8_t buf[N][8];                                            \
            uint32_t t, t0, t1;                                           \
                                                                          \
            memcpy(in_t, in, sizeof(uint8_t *) * N);                      \
            memset(s, 0, 25 * N * sizeof(uint64_t));                      \
            memset(buf, 0, N * 8 * sizeof(uint8_t));                      \
                                                                          \
            while (inlen >= r) {                                          \
                for (i = 0; i < r / 8; i++)                               \
                    for (j = 0; j < N; j++)                               \
                        if (j < 2) {                                      \
                            S(j, i) ^= *(uint64_t *)(in_t[j] + 8 * i);    \
                        } else {                                          \
                            toBitInterleavingAndXOR64b(                   \
                                *(uint64_t *)(in_t[j] + 8 * i), S(j, i),  \
                                t, t0, t1);                               \
                        }                                                 \
                for (j = 0; j < N; j++)                                   \
                    in_t[j] += r;                                         \
                inlen -= r;                                               \
                FUNC(KeccakF1600x, N, _StatePermute)(s);                  \
            }                                                             \
                                                                          \
            for (i = 0; inlen >= 8; i += 1, inlen -= 8)                   \
                for (j = 0; j < N; j++) {                                 \
                    if (j < 2) {                                          \
                        S(j, i) ^= *(uint64_t *)(in_t[j]);                \
                    } else {                                              \
                        toBitInterleavingAndXOR64b(                       \
                            *(uint64_t *)(in_t[j]), S(j, i), t, t0, t1);  \
                    }                                                     \
                    in_t[j] += 8;                                         \
                }                                                         \
            for (k = 0; k < inlen; k++)                                   \
                for (j = 0; j < N; j++)                                   \
                    buf[j][k] = in_t[j][k];                               \
                                                                          \
            for (j = 0; j < N; j++)                                       \
                buf[j][k] = p;                                            \
                                                                          \
            for (j = 0; j < N; j++)                                       \
                if (j < 2) {                                              \
                    S(j, i) ^= *(uint64_t *)(buf[j]);                     \
                    S(j, ((r - 1) / 8)) ^= (1ULL << 63);                  \
                } else {                                                  \
                    toBitInterleavingAndXOR64b(*(uint64_t *)(buf[j]),     \
                                               S(j, i), t, t0, t1);       \
                    toBitInterleavingAndXOR64b(                           \
                        (1ULL << 63), S(j, ((r - 1) / 8)), t, t0, t1);    \
                }                                                         \
        }                                                                 \
        static unsigned int FUNC(keccakx, N, _squeeze)(                   \
            uint8_t * *out, size_t outlen, uint64_t * s,                  \
            unsigned int pos, unsigned int r)                             \
        {                                                                 \
            unsigned int i, j;                                            \
            uint8_t *out_t[N];                                            \
            uint32_t t, t0, t1;                                           \
            uint8_t buf[N][8];                                            \
            unsigned int computed_index = -1;                             \
                                                                          \
            memcpy(out_t, out, sizeof(uint8_t *) * N);                    \
            while (outlen) {                                              \
                if (pos == r) {                                           \
                    FUNC(KeccakF1600x, N, _StatePermute)(s);              \
                    pos = 0;                                              \
                }                                                         \
                for (i = pos; i < r && i < pos + outlen; i++) {           \
                    if (computed_index != i / 8) {                        \
                        for (j = 2; j < N; j++) {                         \
                            fromBitInterleaving64b(S(j, (i / 8)),         \
                                                   *(uint64_t *)buf[j],   \
                                                   t, t0, t1);            \
                        }                                                 \
                        computed_index = i / 8;                           \
                    }                                                     \
                    for (j = 0; j < N; j++)                               \
                        if (j < 2)                                        \
                            *out_t[j]++ = S(j, (i / 8)) >> 8 * (i % 8);   \
                        else                                              \
                            *out_t[j]++ = buf[j][i % 8];                  \
                }                                                         \
                outlen -= i - pos;                                        \
                pos = i;                                                  \
            }                                                             \
                                                                          \
            return pos;                                                   \
        }                                                                 \
        static void FUNC(keccakx, N, _squeezeblocks)(                     \
            uint8_t * *out, size_t nblocks, uint64_t * s, unsigned int r) \
        {                                                                 \
            unsigned int i, j;                                            \
            uint8_t *out_t[N];                                            \
            uint32_t t, t0, t1;                                           \
                                                                          \
            memcpy(out_t, out, sizeof(uint8_t *) * N);                    \
            while (nblocks) {                                             \
                FUNC(KeccakF1600x, N, _StatePermute)(s);                  \
                for (i = 0; i < r / 8; i++)                               \
                    for (j = 0; j < N; j++)                               \
                        if (j < 2) {                                      \
                            *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));  \
                        } else {                                          \
                            fromBitInterleaving64b(                       \
                                S(j, (i)),                                \
                                *(uint64_t *)(out_t[j] + 8 * i), t, t0,   \
                                t1);                                      \
                        }                                                 \
                for (j = 0; j < N; j++)                                   \
                    out_t[j] += r;                                        \
                nblocks -= 1;                                             \
            }                                                             \
        }                                                                 \
        void FUNC(shake128x, N, _init)(KECCAK(keccakx, N, _state) * s)    \
        {                                                                 \
            FUNC(keccakx, N, _init)((uint64_t *)&s->s);                   \
            s->pos = 0;                                                   \
        }                                                                 \
        void FUNC(shake128x, N, _absorb)(KECCAK(keccakx, N, _state) * s,  \
                                         const uint8_t **in,              \
                                         size_t inlen)                    \
        {                                                                 \
            s->pos = FUNC(keccakx, N, _absorb)((uint64_t *)&s->s, s->pos, \
                                               SHAKE128_RATE, in, inlen); \
        }                                                                 \
        void FUNC(shake128x, N,                                           \
                  _finalize)(KECCAK(keccakx, N, _state) * s)              \
        {                                                                 \
            FUNC(keccakx, N, _finalize)                                   \
            ((uint64_t *)&s->s, s->pos, SHAKE128_RATE, 0x1F);             \
            s->pos = SHAKE128_RATE;                                       \
        }                                                                 \
        void FUNC(shake128x, N, _squeeze)(                                \
            uint8_t * *out, size_t outlen,                                \
            KECCAK(keccakx, N, _state) * state)                           \
        {                                                                 \
            state->pos = FUNC(keccakx, N, _squeeze)(                      \
                out, outlen, (uint64_t *)&state->s, state->pos,           \
                SHAKE128_RATE);                                           \
        }                                                                 \
        void FUNC(shake128x, N, _absorb_once)(                            \
            KECCAK(keccakx, N, _state) * state, const uint8_t **in,       \
            size_t inlen)                                                 \
        {                                                                 \
            FUNC(keccakx, N, _absorb_once)                                \
            ((uint64_t *)&state->s, SHAKE128_RATE, in, inlen, 0x1F);      \
            state->pos = SHAKE128_RATE;                                   \
        }                                                                 \
        void FUNC(shake128x, N, _squeezeblocks)(                          \
            uint8_t * *out, size_t nblocks,                               \
            KECCAK(keccakx, N, _state) * state)                           \
        {                                                                 \
            FUNC(keccakx, N, _squeezeblocks)                              \
            (out, nblocks, (uint64_t *)&state->s, SHAKE128_RATE);         \
        }                                                                 \
        void FUNC(shake256x, N, _init)(KECCAK(keccakx, N, _state) * s)    \
        {                                                                 \
            FUNC(keccakx, N, _init)((uint64_t *)&s->s);                   \
            s->pos = 0;                                                   \
        }                                                                 \
        void FUNC(shake256x, N, _absorb)(KECCAK(keccakx, N, _state) * s,  \
                                         const uint8_t **in,              \
                                         size_t inlen)                    \
        {                                                                 \
            s->pos = FUNC(keccakx, N, _absorb)((uint64_t *)&s->s, s->pos, \
                                               SHAKE256_RATE, in, inlen); \
        }                                                                 \
        void FUNC(shake256x, N,                                           \
                  _finalize)(KECCAK(keccakx, N, _state) * s)              \
        {                                                                 \
            FUNC(keccakx, N, _finalize)                                   \
            ((uint64_t *)&s->s, s->pos, SHAKE256_RATE, 0x1F);             \
            s->pos = SHAKE256_RATE;                                       \
        }                                                                 \
        void FUNC(shake256x, N, _squeeze)(                                \
            uint8_t * *out, size_t outlen,                                \
            KECCAK(keccakx, N, _state) * state)                           \
        {                                                                 \
            state->pos = FUNC(keccakx, N, _squeeze)(                      \
                out, outlen, (uint64_t *)&state->s, state->pos,           \
                SHAKE256_RATE);                                           \
        }                                                                 \
        void FUNC(shake256x, N, _absorb_once)(                            \
            KECCAK(keccakx, N, _state) * state, const uint8_t **in,       \
            size_t inlen)                                                 \
        {                                                                 \
            FUNC(keccakx, N, _absorb_once)                                \
            ((uint64_t *)&state->s, SHAKE256_RATE, in, inlen, 0x1F);      \
            state->pos = SHAKE256_RATE;                                   \
        }                                                                 \
        void FUNC(shake256x, N, _squeezeblocks)(                          \
            uint8_t * *out, size_t nblocks,                               \
            KECCAK(keccakx, N, _state) * state)                           \
        {                                                                 \
            FUNC(keccakx, N, _squeezeblocks)                              \
            (out, nblocks, (uint64_t *)&state->s, SHAKE256_RATE);         \
        }                                                                 \
        void FUNC(shake128x, N, )(uint8_t * *out, size_t outlen,          \
                                  const uint8_t **in, size_t inlen)       \
        {                                                                 \
            unsigned int j;                                               \
            size_t nblocks;                                               \
            KECCAK(keccakx, N, _state) * state;                           \
            uint8_t *out_t[N];                                            \
            if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) ==   \
                NULL) {                                                   \
                printf("%s: malloc failed\n", STR(FUNC(shake128x, N, ))); \
            }                                                             \
            memcpy(out_t, out, sizeof(uint8_t *) * N);                    \
            FUNC(shake128x, N, _absorb_once)(state, in, inlen);           \
            nblocks = outlen / SHAKE128_RATE;                             \
            FUNC(shake128x, N, _squeezeblocks)(out_t, nblocks, state);    \
            outlen -= nblocks * SHAKE128_RATE;                            \
            for (j = 0; j < N; j++)                                       \
                out_t[j] += nblocks * SHAKE128_RATE;                      \
            FUNC(shake128x, N, _squeeze)(out_t, outlen, state);           \
            free(state);                                                  \
        }                                                                 \
        void FUNC(shake256x, N, )(uint8_t * *out, size_t outlen,          \
                                  const uint8_t **in, size_t inlen)       \
        {                                                                 \
            unsigned int j;                                               \
            size_t nblocks;                                               \
            KECCAK(keccakx, N, _state) * state;                           \
            uint8_t *out_t[N];                                            \
            if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) ==   \
                NULL) {                                                   \
                printf("%s: malloc failed\n", STR(FUNC(shake256x, N, ))); \
            }                                                             \
            memcpy(out_t, out, sizeof(uint8_t *) * N);                    \
            FUNC(shake256x, N, _absorb_once)(state, in, inlen);           \
            nblocks = outlen / SHAKE256_RATE;                             \
            FUNC(shake256x, N, _squeezeblocks)(out_t, nblocks, state);    \
            outlen -= nblocks * SHAKE256_RATE;                            \
            for (j = 0; j < N; j++)                                       \
                out_t[j] += nblocks * SHAKE256_RATE;                      \
            FUNC(shake256x, N, _squeeze)(out_t, outlen, state);           \
            free(state);                                                  \
        }                                                                 \
        void FUNC(sha3_256x, N, )(uint8_t * *out, const uint8_t **in,     \
                                  size_t inlen)                           \
        {                                                                 \
            unsigned int i, j;                                            \
            KECCAK(keccakx, N, _state) * state;                           \
            uint64_t *s;                                                  \
            uint8_t *out_t[N];                                            \
            uint32_t t, t0, t1;                                           \
                                                                          \
            if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) ==   \
                NULL) {                                                   \
                printf("%s: malloc failed\n", STR(FUNC(sha3_256x, N, ))); \
            }                                                             \
            s = (uint64_t *)&(state->s);                                  \
            memcpy(out_t, out, sizeof(uint8_t *) * N);                    \
            FUNC(keccakx, N, _absorb_once)                                \
            (s, SHA3_256_RATE, in, inlen, 0x06);                          \
            FUNC(KeccakF1600x, N, _StatePermute)(s);                      \
            for (i = 0; i < 4; i++)                                       \
                for (j = 0; j < N; j++)                                   \
                    if (j < 2) {                                          \
                        *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));      \
                    } else {                                              \
                        fromBitInterleaving64b(                           \
                            S(j, (i)), *(uint64_t *)(out_t[j] + 8 * i),   \
                            t, t0, t1);                                   \
                    }                                                     \
            free(state);                                                  \
        }                                                                 \
        void FUNC(sha3_512x, N, )(uint8_t * *out, const uint8_t **in,     \
                                  size_t inlen)                           \
        {                                                                 \
            unsigned int i, j;                                            \
            KECCAK(keccakx, N, _state) * state;                           \
            uint64_t *s;                                                  \
            uint8_t *out_t[N];                                            \
            uint32_t t, t0, t1;                                           \
                                                                          \
            if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) ==   \
                NULL) {                                                   \
                printf("%s: malloc failed\n", STR(FUNC(sha3_512x, N, ))); \
            }                                                             \
            s = (uint64_t *)&(state->s);                                  \
            memcpy(out_t, out, sizeof(uint8_t *) * N);                    \
            FUNC(keccakx, N, _absorb_once)                                \
            (s, SHA3_512_RATE, in, inlen, 0x06);                          \
            FUNC(KeccakF1600x, N, _StatePermute)(s);                      \
            for (i = 0; i < 8; i++)                                       \
                for (j = 0; j < N; j++)                                   \
                    if (j < 2) {                                          \
                        *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));      \
                    } else {                                              \
                        fromBitInterleaving64b(                           \
                            S(j, (i)), *(uint64_t *)(out_t[j] + 8 * i),   \
                            t, t0, t1);                                   \
                    }                                                     \
            free(state);                                                  \
        }                                                                 \
        void FUNC(keccakx, N, _get_oneway_state)(                         \
            KECCAK(keccakx, N, _state) * state,                           \
            keccak_state * oneway_state, unsigned int j)                  \
        {                                                                 \
            unsigned int i;                                               \
            uint32_t t, t0, t1;                                           \
            uint64_t *s = (uint64_t *)&(state->s);                        \
            if (j < 2) {                                                  \
                for (i = 0; i < 25; i++) {                                \
                    toBitInterleaving64b(S(j, i), oneway_state->s[i], t,  \
                                         t0, t1);                         \
                }                                                         \
            } else {                                                      \
                for (i = 0; i < 25; i++) {                                \
                    oneway_state->s[i] = S(j, i);                         \
                }                                                         \
            }                                                             \
            oneway_state->pos = state->pos;                               \
        }
#else
#    define IMPL_SHA3_RV32_APIS(N)                                  \
        extern void FUNC(KeccakF1600_StatePermute_RV32V_, N,        \
                         x)(uint64_t * state);                      \
        void FUNC(KeccakF1600x, N, _StatePermute)(uint64_t * state) \
        {                                                           \
            FUNC(KeccakF1600_StatePermute_RV32V_, N, x)(state);     \
        }                                                           \
        IMPL_SHA3X_APIS(N)
#endif

#ifdef VECTOR128
typedef struct uint64x2_t {
    uint64_t val[2];
} v128;
typedef struct keccak_x2 {
    v128 s[25];
    unsigned int pos;
} __attribute__((aligned(16))) keccakx2_state;

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
} __attribute__((aligned(16))) keccakx3_state;

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
} __attribute__((aligned(16))) keccakx4_state;

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
} __attribute__((aligned(16))) keccakx5_state;

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
} __attribute__((aligned(16))) keccakx6_state;

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
} __attribute__((aligned(16))) keccakx8_state;

DEFINE_SHA3_APIS(8);
#endif

#if defined(VECTOR128) && defined(HYBRIDX10)
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
typedef struct keccak_x10 {
    s_x10 s;
    unsigned int pos;
} __attribute__((aligned(16))) keccakx10_state;

DEFINE_SHA3_APIS(10);
#endif

#if defined(VECTOR128) && defined(HYBRIDX14)
typedef struct state_14x {
    v128 s_x2[25];
    uint64_t s_x1_0[25];
    uint64_t s_x1_1[25];
    uint64_t s_x1_2[25];
    uint64_t s_x1_3[25];
    uint64_t s_x1_4[25];
    uint64_t s_x1_5[25];
    uint64_t s_x1_6[25];
    uint64_t s_x1_7[25];
    uint64_t s_x1_8[25];
    uint64_t s_x1_9[25];
    uint64_t s_x1_10[25];
    uint64_t s_x1_11[25];
} s_x14;
typedef struct keccak_x14 {
    s_x14 s;
    unsigned int pos;
} __attribute__((aligned(16))) keccakx14_state;

DEFINE_SHA3_APIS(14);
#endif

#define LOG(format, ...)                                      \
    do {                                                      \
        printf("%s@ %s:%d:\t", __func__, __FILE__, __LINE__); \
        printf(format, ##__VA_ARGS__);                        \
    } while (0)

#define ALIGNED_UINT8(N)   \
    struct {               \
        uint8_t coeffs[N]; \
    } __attribute__((aligned(16)))

#endif
