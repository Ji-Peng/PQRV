/* Based on the public domain implementation in crypto_hash/keccakc512/simple/
 * from http://bench.cr.yp.to/supercop.html by Ronny Van Keer and the public
 * domain "TweetFips202" implementation from https://twitter.com/tweetfips202 by
 * Gilles Van Assche, Daniel J. Bernstein, and Peter Schwabe */

#include "fips202x.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#define NROUNDS 24
#define ROL(a, offset) ((a << offset) ^ (a >> (64 - offset)))

/*************************************************
 * Name:        KeccakF1600_StatePermute
 *
 * Description: The Keccak F1600 Permutation
 *
 * Arguments:   - uint64_t *state: pointer to input/output Keccak state
 **************************************************/
#ifdef VECTOR128
extern void KeccakF1600_StatePermute_RV64V_2x(uint64_t *state);
void KeccakF1600x2_StatePermute(uint64_t *state)
{
    KeccakF1600_StatePermute_RV64V_2x(state);
}

#    define S0(index) s[(index) * 2]
#    define S1(index) s[(index) * 2 + 1]

static void keccakx2_absorb_once(uint64_t *s, unsigned int r, const uint8_t **in, size_t inlen,
                                 uint8_t p)
{
    unsigned int i;
    const uint8_t *in_t[2];

    memcpy(in_t, in, sizeof(uint8_t *) * 2);
    memset(s, 0, 25 * 2 * sizeof(uint64_t));

    while (inlen >= r) {
        for (i = 0; i < r / 8; i++) {
            S0(i) ^= *(uint64_t *)(in_t[0] + 8 * i);
            S1(i) ^= *(uint64_t *)(in_t[1] + 8 * i);
        }
        in_t[0] += r;
        in_t[1] += r;
        inlen -= r;
        KeccakF1600x2_StatePermute(s);
    }

    for (i = 0; i < inlen; i++) {
        S0(i / 8) ^= (uint64_t)in_t[0][i] << 8 * (i % 8);
        S1(i / 8) ^= (uint64_t)in_t[1][i] << 8 * (i % 8);
    }

    S0(i / 8) ^= (uint64_t)p << 8 * (i % 8);
    S0((r - 1) / 8) ^= 1ULL << 63;

    S1(i / 8) ^= (uint64_t)p << 8 * (i % 8);
    S1((r - 1) / 8) ^= 1ULL << 63;
}

static unsigned int keccakx2_squeeze(uint8_t **out, size_t outlen, uint64_t *s,
                                     unsigned int pos, unsigned int r)
{
    unsigned int i;
    uint8_t *out_t[2];

    memcpy(out_t, out, sizeof(uint8_t *) * 2);
    while (outlen) {
        if (pos == r) {
            KeccakF1600x2_StatePermute(s);
            pos = 0;
        }
        for (i = pos; i < r && i < pos + outlen; i++) {
            *out_t[0]++ = S0(i / 8) >> 8 * (i % 8);
            *out_t[1]++ = S1(i / 8) >> 8 * (i % 8);
        }
        outlen -= i - pos;
        pos = i;
    }

    return pos;
}

static void keccakx2_squeezeblocks(uint8_t **out, size_t nblocks, uint64_t *s, unsigned int r)
{
    unsigned int i;
    uint8_t *out_t[2];

    memcpy(out_t, out, sizeof(uint8_t *) * 2);
    while (nblocks) {
        KeccakF1600x2_StatePermute(s);
        for (i = 0; i < r / 8; i++) {
            *(uint64_t *)(out_t[0] + 8 * i) = S0(i);
            *(uint64_t *)(out_t[1] + 8 * i) = S1(i);
        }
        out_t[0] += r;
        out_t[1] += r;
        nblocks -= 1;
    }
}

void shake128x2_squeeze(uint8_t **out, size_t outlen, keccakx2_state *state)
{
    state->pos =
        keccakx2_squeeze(out, outlen, (uint64_t *)&state->s, state->pos, SHAKE128_RATE);
}

void shake128x2_absorb_once(keccakx2_state *state, const uint8_t **in, size_t inlen)
{
    keccakx2_absorb_once((uint64_t *)&state->s, SHAKE128_RATE, in, inlen, 0x1F);
    state->pos = SHAKE128_RATE;
}

void shake128x2_squeezeblocks(uint8_t **out, size_t nblocks, keccakx2_state *state)
{
    keccakx2_squeezeblocks(out, nblocks, (uint64_t *)&state->s, SHAKE128_RATE);
}

void shake256x2_squeeze(uint8_t **out, size_t outlen, keccakx2_state *state)
{
    state->pos =
        keccakx2_squeeze(out, outlen, (uint64_t *)&state->s, state->pos, SHAKE256_RATE);
}

void shake256x2_absorb_once(keccakx2_state *state, const uint8_t **in, size_t inlen)
{
    keccakx2_absorb_once((uint64_t *)&state->s, SHAKE256_RATE, in, inlen, 0x1F);
    state->pos = SHAKE256_RATE;
}

void shake256x2_squeezeblocks(uint8_t **out, size_t nblocks, keccakx2_state *state)
{
    keccakx2_squeezeblocks(out, nblocks, (uint64_t *)&state->s, SHAKE256_RATE);
}

void shake128x2(uint8_t **out, size_t outlen, const uint8_t **in, size_t inlen)
{
    size_t nblocks;
    keccakx2_state state;
    uint8_t *out_t[2];

    memcpy(out_t, out, sizeof(uint8_t *) * 2);
    shake128x2_absorb_once(&state, in, inlen);
    nblocks = outlen / SHAKE128_RATE;
    shake128x2_squeezeblocks(out_t, nblocks, &state);
    outlen -= nblocks * SHAKE128_RATE;
    out_t[0] += nblocks * SHAKE128_RATE;
    out_t[1] += nblocks * SHAKE128_RATE;
    shake128x2_squeeze(out_t, outlen, &state);
}

void shake256x2(uint8_t **out, size_t outlen, const uint8_t **in, size_t inlen)
{
    size_t nblocks;
    keccakx2_state state;
    uint8_t *out_t[2];

    memcpy(out_t, out, sizeof(uint8_t *) * 2);
    shake256x2_absorb_once(&state, in, inlen);
    nblocks = outlen / SHAKE256_RATE;
    shake256x2_squeezeblocks(out_t, nblocks, &state);
    outlen -= nblocks * SHAKE256_RATE;
    out_t[0] += nblocks * SHAKE256_RATE;
    out_t[1] += nblocks * SHAKE256_RATE;
    shake256x2_squeeze(out_t, outlen, &state);
}

void sha3_256x2(uint8_t **out, const uint8_t **in, size_t inlen)
{
    unsigned int i;
    keccakx2_state state;
    uint64_t *s;
    uint8_t *out_t[2];

    s = (uint64_t *)&state.s;
    memcpy(out_t, out, sizeof(uint8_t *) * 2);
    keccakx2_absorb_once(s, SHA3_256_RATE, in, inlen, 0x06);
    KeccakF1600x2_StatePermute(s);
    for (i = 0; i < 4; i++) {
        *(uint64_t *)(out_t[0] + 8 * i) = S0(i);
        *(uint64_t *)(out_t[1] + 8 * i) = S1(i);
    }
}

void sha3_512x2(uint8_t **out, const uint8_t **in, size_t inlen)
{
    unsigned int i;
    keccakx2_state state;
    uint64_t *s;
    uint8_t *out_t[2];

    s = (uint64_t *)&state.s;
    memcpy(out_t, out, sizeof(uint8_t *) * 2);
    keccakx2_absorb_once(s, SHA3_512_RATE, in, inlen, 0x06);
    KeccakF1600x2_StatePermute(s);
    for (i = 0; i < 8; i++) {
        *(uint64_t *)(out_t[0] + 8 * i) = S0(i);
        *(uint64_t *)(out_t[1] + 8 * i) = S1(i);
    }
}

#    undef S0
#    undef S1
#endif

#if defined(VECTOR128) && defined(HYBRIDX3)
extern void KeccakF1600_StatePermute_RV64V_3x(uint64_t *state);
void KeccakF1600x3_StatePermute(uint64_t *state)
{
    KeccakF1600_StatePermute_RV64V_3x(state);
}

#    define S0(index) s[(index) * 2]
#    define S1(index) s[(index) * 2 + 1]
#    define S2(index) s[25 * 2 + (index)]

static void keccakx3_absorb_once(uint64_t *s, unsigned int r, const uint8_t **in, size_t inlen,
                                 uint8_t p)
{
    unsigned int i;

    for (i = 0; i < 25; i++) {
        S0(i) = S1(i) = S2(i) = 0;
    }

    while (inlen >= r) {
        for (i = 0; i < r / 8; i++) {
            S0(i) ^= *(uint64_t *)(in[0] + 8 * i);
            S1(i) ^= *(uint64_t *)(in[1] + 8 * i);
            S2(i) ^= *(uint64_t *)(in[2] + 8 * i);
        }
        in[0] += r;
        in[1] += r;
        in[2] += r;
        inlen -= r;
        KeccakF1600x3_StatePermute(s);
    }

    for (i = 0; i < inlen; i++) {
        S0(i / 8) ^= (uint64_t)in[0][i] << 8 * (i % 8);
        S1(i / 8) ^= (uint64_t)in[1][i] << 8 * (i % 8);
        S2(i / 8) ^= (uint64_t)in[2][i] << 8 * (i % 8);
    }

    S0(i / 8) ^= (uint64_t)p << 8 * (i % 8);
    S0((r - 1) / 8) ^= 1ULL << 63;

    S1(i / 8) ^= (uint64_t)p << 8 * (i % 8);
    S1((r - 1) / 8) ^= 1ULL << 63;

    S2(i / 8) ^= (uint64_t)p << 8 * (i % 8);
    S2((r - 1) / 8) ^= 1ULL << 63;
}

static unsigned int keccakx3_squeeze(uint8_t **out, size_t outlen, uint64_t *s,
                                     unsigned int pos, unsigned int r)
{
    unsigned int i;
    uint8_t *out0, *out1;

    out0 = out[0];
    out1 = out[1];
    while (outlen) {
        if (pos == r) {
            KeccakF1600x3_StatePermute(s);
            pos = 0;
        }
        for (i = pos; i < r && i < pos + outlen; i++) {
            *out0++ = S0(i / 8) >> 8 * (i % 8);
            *out1++ = S1(i / 8) >> 8 * (i % 8);
        }
        outlen -= i - pos;
        pos = i;
    }

    return pos;
}

static void keccakx3_squeezeblocks(uint8_t **out, size_t nblocks, uint64_t *s, unsigned int r)
{
    unsigned int i;
    uint64_t *p0, *p1;
    uint8_t *out0, *out1;

    out0 = out[0];
    out1 = out[1];
    while (nblocks) {
        KeccakF1600x3_StatePermute(s);
        for (i = 0; i < r / 8; i++) {
            p0 = (uint64_t *)(out0 + 8 * i);
            p1 = (uint64_t *)(out1 + 8 * i);
            *p0 = S0(i);
            *p1 = S1(i);
        }
        out0 += r;
        out1 += r;
        nblocks -= 1;
    }
}

void shake128x3_squeeze(uint8_t **out, size_t outlen, keccakx3_state *state)
{
    state->pos =
        keccakx3_squeeze(out, outlen, (uint64_t *)&state->s, state->pos, SHAKE128_RATE);
}

void shake128x3_absorb_once(keccakx3_state *state, const uint8_t **in, size_t inlen)
{
    keccakx3_absorb_once((uint64_t *)&state->s, SHAKE128_RATE, in, inlen, 0x1F);
    state->pos = SHAKE128_RATE;
}

void shake128x3_squeezeblocks(uint8_t **out, size_t nblocks, keccakx3_state *state)
{
    keccakx3_squeezeblocks(out, nblocks, (uint64_t *)&state->s, SHAKE128_RATE);
}

void shake256x3_squeeze(uint8_t **out, size_t outlen, keccakx3_state *state)
{
    state->pos =
        keccakx3_squeeze(out, outlen, (uint64_t *)&state->s, state->pos, SHAKE256_RATE);
}

void shake256x3_absorb_once(keccakx3_state *state, const uint8_t **in, size_t inlen)
{
    keccakx3_absorb_once((uint64_t *)&state->s, SHAKE256_RATE, in, inlen, 0x1F);
    state->pos = SHAKE256_RATE;
}

void shake256x3_squeezeblocks(uint8_t **out, size_t nblocks, keccakx3_state *state)
{
    keccakx3_squeezeblocks(out, nblocks, (uint64_t *)&state->s, SHAKE256_RATE);
}

void shake128x3(uint8_t **out, size_t outlen, const uint8_t **in, size_t inlen)
{
    size_t nblocks;
    keccakx3_state state;

    shake128x3_absorb_once(&state, in, inlen);
    nblocks = outlen / SHAKE128_RATE;
    shake128x3_squeezeblocks(out, nblocks, &state);
    outlen -= nblocks * SHAKE128_RATE;
    out[0] += nblocks * SHAKE128_RATE;
    out[1] += nblocks * SHAKE128_RATE;
    shake128x3_squeeze(out, outlen, &state);
}

void shake256x3(uint8_t **out, size_t outlen, const uint8_t **in, size_t inlen)
{
    size_t nblocks;
    keccakx3_state state;

    shake256x3_absorb_once(&state, in, inlen);
    nblocks = outlen / SHAKE256_RATE;
    shake256x3_squeezeblocks(out, nblocks, &state);
    outlen -= nblocks * SHAKE256_RATE;
    out[0] += nblocks * SHAKE256_RATE;
    out[1] += nblocks * SHAKE256_RATE;
    shake256x3_squeeze(out, outlen, &state);
}

void sha3_256x3(uint8_t **out, const uint8_t **in, size_t inlen)
{
    unsigned int i;
    keccakx3_state state;
    uint64_t *p0, *p1;
    uint64_t *s;
    uint8_t *out0, *out1;

    s = (uint64_t *)&state.s;
    out0 = out[0];
    out1 = out[1];
    keccakx3_absorb_once(s, SHA3_256_RATE, in, inlen, 0x06);
    KeccakF1600x3_StatePermute(s);
    for (i = 0; i < 4; i++) {
        p0 = (uint64_t *)(out0 + 8 * i);
        p1 = (uint64_t *)(out1 + 8 * i);
        *p0 = S0(i);
        *p1 = S1(i);
    }
}

void sha3_512x3(uint8_t **out, const uint8_t **in, size_t inlen)
{
    unsigned int i;
    keccakx3_state state;
    uint64_t *p0, *p1;
    uint64_t *s;
    uint8_t *out0, *out1;

    s = (uint64_t *)&state.s;
    out0 = out[0];
    out1 = out[1];
    keccakx3_absorb_once(s, SHA3_512_RATE, in, inlen, 0x06);
    KeccakF1600x3_StatePermute(s);
    for (i = 0; i < 8; i++) {
        p0 = (uint64_t *)(out0 + 8 * i);
        p1 = (uint64_t *)(out1 + 8 * i);
        *p0 = S0(i);
        *p1 = S1(i);
    }
}

#    undef S0
#    undef S1
#    undef S2
#endif
#if defined(VECTOR128) && defined(HYBRIDX4)
extern void KeccakF1600_StatePermute_RV64V_4x(uint64_t *state);
void KeccakF1600x4_StatePermute(uint64_t *state)
{
    KeccakF1600_StatePermute_RV64V_4x(state);
}
#endif

#if defined(VECTOR128) && defined(HYBRIDX5)
extern void KeccakF1600_StatePermute_RV64V_5x(uint64_t *state);
void KeccakF1600x5_StatePermute(uint64_t *state)
{
    KeccakF1600_StatePermute_RV64V_5x(state);
}
#endif

#if defined(VECTOR128) && defined(HYBRIDX6)
extern void KeccakF1600_StatePermute_RV64V_6x(uint64_t *state);
void KeccakF1600x6_StatePermute(uint64_t *state)
{
    KeccakF1600_StatePermute_RV64V_6x(state);
}
#endif

#if defined(VECTOR128) && defined(HYBRIDX8)
extern void KeccakF1600_StatePermute_RV64V_8x(uint64_t *state);
void KeccakF1600x8_StatePermute(uint64_t *state)
{
    KeccakF1600_StatePermute_RV64V_8x(state);
}
#endif
/*************************************************
 * Name:        keccak_squeeze
 *
 * Description: Squeeze step of Keccak. Squeezes arbitratrily many bytes.
 *              Modifies the state. Can be called multiple times to keep
 *              squeezing, i.e., is incremental.
 *
 * Arguments:   - uint8_t *out: pointer to output
 *              - size_t outlen: number of bytes to be squeezed (written to
 out)
 *              - uint64_t *s: pointer to input/output Keccak state
 *              - unsigned int pos: number of bytes in current block already
 *squeezed
 *              - unsigned int r: rate in bytes (e.g., 168 for SHAKE128)
 *
 * Returns new position pos in current block
 **************************************************/
// static unsigned int keccak_squeeze(uint8_t *out, size_t outlen, uint64_t
// s[25],
//                                    unsigned int pos, unsigned int r)
// {
//     unsigned int i;

//     while (outlen) {
//         if (pos == r) {
//             KeccakF1600_StatePermute(s);
//             pos = 0;
//         }
//         for (i = pos; i < r && i < pos + outlen; i++)
//             *out++ = s[i / 8] >> 8 * (i % 8);
//         outlen -= i - pos;
//         pos = i;
//     }

//     return pos;
// }

// /*************************************************
//  * Name:        keccak_absorb_once
//  *
//  * Description: Absorb step of Keccak;
//  *              non-incremental, starts by zeroeing the state.
//  *
//  * Arguments:   - uint64_t *s: pointer to (uninitialized) output Keccak state
//  *              - unsigned int r: rate in bytes (e.g., 168 for SHAKE128)
//  *              - const uint8_t *in: pointer to input to be absorbed into s
//  *              - size_t inlen: length of input in bytes
//  *              - uint8_t p: domain-separation byte for different
//  Keccak-derived *functions
//  **************************************************/
// static void keccak_absorb_once(uint64_t s[25], unsigned int r,
//                                const uint8_t *in, size_t inlen, uint8_t p)
// {
//     unsigned int i;

//     for (i = 0; i < 25; i++)
//         s[i] = 0;

//     while (inlen >= r) {
//         for (i = 0; i < r / 8; i++)
//             s[i] ^= load64(in + 8 * i);
//         in += r;
//         inlen -= r;
//         KeccakF1600_StatePermute(s);
//     }

//     for (i = 0; i < inlen; i++)
//         s[i / 8] ^= (uint64_t)in[i] << 8 * (i % 8);

//     s[i / 8] ^= (uint64_t)p << 8 * (i % 8);
//     s[(r - 1) / 8] ^= 1ULL << 63;
// }

// /*************************************************
//  * Name:        keccak_squeezeblocks
//  *
//  * Description: Squeeze step of Keccak. Squeezes full blocks of r bytes each.
//  *              Modifies the state. Can be called multiple times to keep
//  *              squeezing, i.e., is incremental. Assumes zero bytes of
//  current
//  *              block have already been squeezed.
//  *
//  * Arguments:   - uint8_t *out: pointer to output blocks
//  *              - size_t nblocks: number of blocks to be squeezed (written to
//  *out)
//  *              - uint64_t *s: pointer to input/output Keccak state
//  *              - unsigned int r: rate in bytes (e.g., 168 for SHAKE128)
//  **************************************************/
// static void keccak_squeezeblocks(uint8_t *out, size_t nblocks, uint64_t
// s[25],
//                                  unsigned int r)
// {
//     unsigned int i;

//     while (nblocks) {
//         KeccakF1600_StatePermute(s);
//         for (i = 0; i < r / 8; i++)
//             store64(out + 8 * i, s[i]);
//         out += r;
//         nblocks -= 1;
//     }
// }

// /*************************************************
//  * Name:        shake128_squeeze
//  *
//  * Description: Squeeze step of SHAKE128 XOF. Squeezes arbitraily many
//  *              bytes. Can be called multiple times to keep squeezing.
//  *
//  * Arguments:   - uint8_t *out: pointer to output blocks
//  *              - size_t outlen : number of bytes to be squeezed (written to
//  *output)
//  *              - keccak_state *s: pointer to input/output Keccak state
//  **************************************************/
// void shake128_squeeze(uint8_t *out, size_t outlen, keccak_state *state)
// {
//     state->pos =
//         keccak_squeeze(out, outlen, state->s, state->pos, SHAKE128_RATE);
// }

// /*************************************************
//  * Name:        shake128_absorb_once
//  *
//  * Description: Initialize, absorb into and finalize SHAKE128 XOF;
//  *non-incremental.
//  *
//  * Arguments:   - keccak_state *state: pointer to (uninitialized) output
//  Keccak *state
//  *              - const uint8_t *in: pointer to input to be absorbed into s
//  *              - size_t inlen: length of input in bytes
//  **************************************************/
// void shake128_absorb_once(keccak_state *state, const uint8_t *in, size_t
// inlen)
// {
//     keccak_absorb_once(state->s, SHAKE128_RATE, in, inlen, 0x1F);
//     state->pos = SHAKE128_RATE;
// }

// /*************************************************
//  * Name:        shake128_squeezeblocks
//  *
//  * Description: Squeeze step of SHAKE128 XOF. Squeezes full blocks of
//  *              SHAKE128_RATE bytes each. Can be called multiple times
//  *              to keep squeezing. Assumes new block has not yet been
//  *              started (state->pos = SHAKE128_RATE).
//  *
//  * Arguments:   - uint8_t *out: pointer to output blocks
//  *              - size_t nblocks: number of blocks to be squeezed (written to
//  *output)
//  *              - keccak_state *s: pointer to input/output Keccak state
//  **************************************************/
// void shake128_squeezeblocks(uint8_t *out, size_t nblocks, keccak_state
// *state)
// {
//     keccak_squeezeblocks(out, nblocks, state->s, SHAKE128_RATE);
// }

// /*************************************************
//  * Name:        shake256_squeeze
//  *
//  * Description: Squeeze step of SHAKE256 XOF. Squeezes arbitraily many
//  *              bytes. Can be called multiple times to keep squeezing.
//  *
//  * Arguments:   - uint8_t *out: pointer to output blocks
//  *              - size_t outlen : number of bytes to be squeezed (written to
//  *output)
//  *              - keccak_state *s: pointer to input/output Keccak state
//  **************************************************/
// void shake256_squeeze(uint8_t *out, size_t outlen, keccak_state *state)
// {
//     state->pos =
//         keccak_squeeze(out, outlen, state->s, state->pos, SHAKE256_RATE);
// }

// /*************************************************
//  * Name:        shake256_absorb_once
//  *
//  * Description: Initialize, absorb into and finalize SHAKE256 XOF;
//  *non-incremental.
//  *
//  * Arguments:   - keccak_state *state: pointer to (uninitialized) output
//  Keccak *state
//  *              - const uint8_t *in: pointer to input to be absorbed into s
//  *              - size_t inlen: length of input in bytes
//  **************************************************/
// void shake256_absorb_once(keccak_state *state, const uint8_t *in, size_t
// inlen)
// {
//     keccak_absorb_once(state->s, SHAKE256_RATE, in, inlen, 0x1F);
//     state->pos = SHAKE256_RATE;
// }

// /*************************************************
//  * Name:        shake256_squeezeblocks
//  *
//  * Description: Squeeze step of SHAKE256 XOF. Squeezes full blocks of
//  *              SHAKE256_RATE bytes each. Can be called multiple times
//  *              to keep squeezing. Assumes next block has not yet been
//  *              started (state->pos = SHAKE256_RATE).
//  *
//  * Arguments:   - uint8_t *out: pointer to output blocks
//  *              - size_t nblocks: number of blocks to be squeezed (written to
//  *output)
//  *              - keccak_state *s: pointer to input/output Keccak state
//  **************************************************/
// void shake256_squeezeblocks(uint8_t *out, size_t nblocks, keccak_state
// *state)
// {
//     keccak_squeezeblocks(out, nblocks, state->s, SHAKE256_RATE);
// }

// /*************************************************
//  * Name:        shake128
//  *
//  * Description: SHAKE128 XOF with non-incremental API
//  *
//  * Arguments:   - uint8_t *out: pointer to output
//  *              - size_t outlen: requested output length in bytes
//  *              - const uint8_t *in: pointer to input
//  *              - size_t inlen: length of input in bytes
//  **************************************************/
// void shake128(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen)
// {
//     size_t nblocks;
//     keccak_state state;

//     shake128_absorb_once(&state, in, inlen);
//     nblocks = outlen / SHAKE128_RATE;
//     shake128_squeezeblocks(out, nblocks, &state);
//     outlen -= nblocks * SHAKE128_RATE;
//     out += nblocks * SHAKE128_RATE;
//     shake128_squeeze(out, outlen, &state);
// }

// /*************************************************
//  * Name:        shake256
//  *
//  * Description: SHAKE256 XOF with non-incremental API
//  *
//  * Arguments:   - uint8_t *out: pointer to output
//  *              - size_t outlen: requested output length in bytes
//  *              - const uint8_t *in: pointer to input
//  *              - size_t inlen: length of input in bytes
//  **************************************************/
// void shake256(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen)
// {
//     size_t nblocks;
//     keccak_state state;

//     shake256_absorb_once(&state, in, inlen);
//     nblocks = outlen / SHAKE256_RATE;
//     shake256_squeezeblocks(out, nblocks, &state);
//     outlen -= nblocks * SHAKE256_RATE;
//     out += nblocks * SHAKE256_RATE;
//     shake256_squeeze(out, outlen, &state);
// }

// /*************************************************
//  * Name:        sha3_256
//  *
//  * Description: SHA3-256 with non-incremental API
//  *
//  * Arguments:   - uint8_t *h: pointer to output (32 bytes)
//  *              - const uint8_t *in: pointer to input
//  *              - size_t inlen: length of input in bytes
//  **************************************************/
// void sha3_256(uint8_t h[32], const uint8_t *in, size_t inlen)
// {
//     unsigned int i;
//     uint64_t s[25];

//     keccak_absorb_once(s, SHA3_256_RATE, in, inlen, 0x06);
//     KeccakF1600_StatePermute(s);
//     for (i = 0; i < 4; i++)
//         store64(h + 8 * i, s[i]);
// }

// /*************************************************
//  * Name:        sha3_512
//  *
//  * Description: SHA3-512 with non-incremental API
//  *
//  * Arguments:   - uint8_t *h: pointer to output (64 bytes)
//  *              - const uint8_t *in: pointer to input
//  *              - size_t inlen: length of input in bytes
//  **************************************************/
// void sha3_512(uint8_t h[64], const uint8_t *in, size_t inlen)
// {
//     unsigned int i;
//     uint64_t s[25];

//     keccak_absorb_once(s, SHA3_512_RATE, in, inlen, 0x06);
//     KeccakF1600_StatePermute(s);
//     for (i = 0; i < 8; i++)
//         store64(h + 8 * i, s[i]);
// }
