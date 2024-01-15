/* Based on the public domain implementation in crypto_hash/keccakc512/simple/
 * from http://bench.cr.yp.to/supercop.html by Ronny Van Keer and the public
 * domain "TweetFips202" implementation from https://twitter.com/tweetfips202 by
 * Gilles Van Assche, Daniel J. Bernstein, and Peter Schwabe */

#include "fips202.h"

#include <stddef.h>
#include <stdint.h>

#define NROUNDS 24
#define ROL(a, offset) ((a << offset) ^ (a >> (64 - offset)))

/*************************************************
 * Name:        KeccakF1600_StatePermute
 *
 * Description: The Keccak F1600 Permutation
 *
 * Arguments:   - uint64_t *state: pointer to input/output Keccak state
 **************************************************/
extern void KeccakF1600_StatePermute_RV32ASM(uint64_t state[25]);
void KeccakF1600_StatePermute(uint64_t state[25])
{
    KeccakF1600_StatePermute_RV32ASM(state);
}

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

#    define toBitInterleavingAndXOR(low, high, even, odd, temp, temp0, temp1) \
        prepareToBitInterleaving(low, high, temp, temp0, temp1);              \
        even ^= (temp0 & 0x0000FFFF) | (temp1 << 16);                         \
        odd ^= (temp0 >> 16) | (temp1 & 0xFFFF0000)

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
#endif
/*************************************************
 * Name:        keccak_squeeze
 *
 * Description: Squeeze step of Keccak. Squeezes arbitratrily many bytes.
 *              Modifies the state. Can be called multiple times to keep
 *              squeezing, i.e., is incremental.
 *
 * Arguments:   - uint8_t *out: pointer to output
 *              - size_t outlen: number of bytes to be squeezed (written to out)
 *              - uint64_t *s: pointer to input/output Keccak state
 *              - unsigned int pos: number of bytes in current block already
 *squeezed
 *              - unsigned int r: rate in bytes (e.g., 168 for SHAKE128)
 *
 * Returns new position pos in current block
 **************************************************/
static unsigned int keccak_squeeze(uint8_t *out, size_t outlen, uint64_t s[25],
                                   unsigned int pos, unsigned int r)
{
    unsigned int i;

    while (outlen) {
        if (pos == r) {
            KeccakF1600_StatePermute(s);
            pos = 0;
        }
        for (i = pos; i < r && i < pos + outlen; i++)
            *out++ = s[i / 8] >> 8 * (i % 8);
        outlen -= i - pos;
        pos = i;
    }

    return pos;
}

/*************************************************
 * Name:        keccak_absorb_once
 *
 * Description: Absorb step of Keccak;
 *              non-incremental, starts by zeroeing the state.
 *
 * Arguments:   - uint64_t *s: pointer to (uninitialized) output Keccak state
 *              - unsigned int r: rate in bytes (e.g., 168 for SHAKE128)
 *              - const uint8_t *in: pointer to input to be absorbed into s
 *              - size_t inlen: length of input in bytes
 *              - uint8_t p: domain-separation byte for different Keccak-derived
 *functions
 **************************************************/
static void keccak_absorb_once(uint64_t s[25], unsigned int r,
                               const uint8_t *in, size_t inlen, uint8_t p)
{
    unsigned int i, j;
    uint32_t *s_32b = (uint32_t *)s;
    uint8_t buf[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    uint32_t *p0, *p1;
#ifdef BIT_INTERLEAVING
    uint32_t t, t0, t1;
#endif

    for (i = 0; i < 25; i++)
        s[i] = 0;

    while (inlen >= r) {
        for (i = 0; i < r / 8; i++) {
            p0 = (uint32_t *)(in + 8 * i);
            p1 = (uint32_t *)(in + 8 * i + 4);
#ifndef BIT_INTERLEAVING
            s_32b[2 * i] ^= *p0;
            s_32b[2 * i + 1] ^= *p1;
#else
            toBitInterleavingAndXOR(*p0, *p1, s_32b[2 * i], s_32b[2 * i + 1], t,
                                    t0, t1);
#endif
        }
        in += r;
        inlen -= r;
        KeccakF1600_StatePermute(s);
    }

    for (i = 0; inlen >= 8; i += 1, in += 8, inlen -= 8) {
        p0 = (uint32_t *)(in);
        p1 = (uint32_t *)(in + 4);
#ifndef BIT_INTERLEAVING
        s_32b[2 * i] ^= *p0;
        s_32b[2 * i + 1] ^= *p1;
#else
        toBitInterleavingAndXOR(*p0, *p1, s_32b[2 * i], s_32b[2 * i + 1], t, t0,
                                t1);
#endif
    }

    for (j = 0; j < inlen; j++) {
        buf[j] = in[j];
    }
    buf[j] = p;
    p0 = (uint32_t *)(buf);
    p1 = (uint32_t *)(buf + 4);
#ifndef BIT_INTERLEAVING
    s_32b[2 * i] ^= *p0;
    s_32b[2 * i + 1] ^= *p1;
    s_32b[2 * ((r - 1) / 8)] ^= ((1ULL << 63) & 0xFFFFFFFF);
    s_32b[2 * ((r - 1) / 8) + 1] ^= ((1ULL << 63) >> 32);
#else
    toBitInterleavingAndXOR(*p0, *p1, s_32b[2 * i], s_32b[2 * i + 1], t, t0,
                            t1);
    toBitInterleavingAndXOR(((1ULL << 63) & 0xFFFFFFFF), ((1ULL << 63) >> 32),
                            s_32b[2 * ((r - 1) / 8)],
                            s_32b[2 * ((r - 1) / 8) + 1], t, t0, t1);
#endif
    // for (i = 0; i < inlen; i++)
    //     s[i / 8] ^= (uint64_t)in[i] << 8 * (i % 8);
    // s[i / 8] ^= (uint64_t)p << 8 * (i % 8);
    // s[(r - 1) / 8] ^= 1ULL << 63;
}

/*************************************************
 * Name:        keccak_squeezeblocks
 *
 * Description: Squeeze step of Keccak. Squeezes full blocks of r bytes each.
 *              Modifies the state. Can be called multiple times to keep
 *              squeezing, i.e., is incremental. Assumes zero bytes of current
 *              block have already been squeezed.
 *
 * Arguments:   - uint8_t *out: pointer to output blocks
 *              - size_t nblocks: number of blocks to be squeezed (written to
 *out)
 *              - uint64_t *s: pointer to input/output Keccak state
 *              - unsigned int r: rate in bytes (e.g., 168 for SHAKE128)
 **************************************************/
static void keccak_squeezeblocks(uint8_t *out, size_t nblocks, uint64_t s[25],
                                 unsigned int r)
{
    unsigned int i;
    uint32_t *s_32b = (uint32_t *)s;
    uint32_t *p0, *p1;
#ifdef BIT_INTERLEAVING
    uint32_t t, t0, t1;
#endif

    while (nblocks) {
        KeccakF1600_StatePermute(s);
        for (i = 0; i < r / 8; i++) {
            p0 = (uint32_t *)(out + 8 * i);
            p1 = (uint32_t *)(out + 8 * i + 4);
#ifndef BIT_INTERLEAVING
            *p0 = s_32b[2 * i];
            *p1 = s_32b[2 * i + 1];
#else
            fromBitInterleaving(s_32b[2 * i], s_32b[2 * i + 1], *p0, *p1, t, t0,
                                t1);
#endif
        }
        out += r;
        nblocks -= 1;
    }
}

/*************************************************
 * Name:        shake128_squeeze
 *
 * Description: Squeeze step of SHAKE128 XOF. Squeezes arbitraily many
 *              bytes. Can be called multiple times to keep squeezing.
 *
 * Arguments:   - uint8_t *out: pointer to output blocks
 *              - size_t outlen : number of bytes to be squeezed (written to
 *output)
 *              - keccak_state *s: pointer to input/output Keccak state
 **************************************************/
void shake128_squeeze(uint8_t *out, size_t outlen, keccak_state *state)
{
    state->pos =
        keccak_squeeze(out, outlen, state->s, state->pos, SHAKE128_RATE);
}

/*************************************************
 * Name:        shake128_absorb_once
 *
 * Description: Initialize, absorb into and finalize SHAKE128 XOF;
 *non-incremental.
 *
 * Arguments:   - keccak_state *state: pointer to (uninitialized) output Keccak
 *state
 *              - const uint8_t *in: pointer to input to be absorbed into s
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake128_absorb_once(keccak_state *state, const uint8_t *in, size_t inlen)
{
    keccak_absorb_once(state->s, SHAKE128_RATE, in, inlen, 0x1F);
    state->pos = SHAKE128_RATE;
}

/*************************************************
 * Name:        shake128_squeezeblocks
 *
 * Description: Squeeze step of SHAKE128 XOF. Squeezes full blocks of
 *              SHAKE128_RATE bytes each. Can be called multiple times
 *              to keep squeezing. Assumes new block has not yet been
 *              started (state->pos = SHAKE128_RATE).
 *
 * Arguments:   - uint8_t *out: pointer to output blocks
 *              - size_t nblocks: number of blocks to be squeezed (written to
 *output)
 *              - keccak_state *s: pointer to input/output Keccak state
 **************************************************/
void shake128_squeezeblocks(uint8_t *out, size_t nblocks, keccak_state *state)
{
    keccak_squeezeblocks(out, nblocks, state->s, SHAKE128_RATE);
}

/*************************************************
 * Name:        shake256_squeeze
 *
 * Description: Squeeze step of SHAKE256 XOF. Squeezes arbitraily many
 *              bytes. Can be called multiple times to keep squeezing.
 *
 * Arguments:   - uint8_t *out: pointer to output blocks
 *              - size_t outlen : number of bytes to be squeezed (written to
 *output)
 *              - keccak_state *s: pointer to input/output Keccak state
 **************************************************/
void shake256_squeeze(uint8_t *out, size_t outlen, keccak_state *state)
{
    state->pos =
        keccak_squeeze(out, outlen, state->s, state->pos, SHAKE256_RATE);
}

/*************************************************
 * Name:        shake256_absorb_once
 *
 * Description: Initialize, absorb into and finalize SHAKE256 XOF;
 *non-incremental.
 *
 * Arguments:   - keccak_state *state: pointer to (uninitialized) output Keccak
 *state
 *              - const uint8_t *in: pointer to input to be absorbed into s
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake256_absorb_once(keccak_state *state, const uint8_t *in, size_t inlen)
{
    keccak_absorb_once(state->s, SHAKE256_RATE, in, inlen, 0x1F);
    state->pos = SHAKE256_RATE;
}

/*************************************************
 * Name:        shake256_squeezeblocks
 *
 * Description: Squeeze step of SHAKE256 XOF. Squeezes full blocks of
 *              SHAKE256_RATE bytes each. Can be called multiple times
 *              to keep squeezing. Assumes next block has not yet been
 *              started (state->pos = SHAKE256_RATE).
 *
 * Arguments:   - uint8_t *out: pointer to output blocks
 *              - size_t nblocks: number of blocks to be squeezed (written to
 *output)
 *              - keccak_state *s: pointer to input/output Keccak state
 **************************************************/
void shake256_squeezeblocks(uint8_t *out, size_t nblocks, keccak_state *state)
{
    keccak_squeezeblocks(out, nblocks, state->s, SHAKE256_RATE);
}

/*************************************************
 * Name:        shake128
 *
 * Description: SHAKE128 XOF with non-incremental API
 *
 * Arguments:   - uint8_t *out: pointer to output
 *              - size_t outlen: requested output length in bytes
 *              - const uint8_t *in: pointer to input
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake128(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen)
{
    size_t nblocks;
    keccak_state state;

    shake128_absorb_once(&state, in, inlen);
    nblocks = outlen / SHAKE128_RATE;
    shake128_squeezeblocks(out, nblocks, &state);
    outlen -= nblocks * SHAKE128_RATE;
    out += nblocks * SHAKE128_RATE;
    shake128_squeeze(out, outlen, &state);
}

/*************************************************
 * Name:        shake256
 *
 * Description: SHAKE256 XOF with non-incremental API
 *
 * Arguments:   - uint8_t *out: pointer to output
 *              - size_t outlen: requested output length in bytes
 *              - const uint8_t *in: pointer to input
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake256(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen)
{
    size_t nblocks;
    keccak_state state;

    shake256_absorb_once(&state, in, inlen);
    nblocks = outlen / SHAKE256_RATE;
    shake256_squeezeblocks(out, nblocks, &state);
    outlen -= nblocks * SHAKE256_RATE;
    out += nblocks * SHAKE256_RATE;
    shake256_squeeze(out, outlen, &state);
}

/*************************************************
 * Name:        sha3_256
 *
 * Description: SHA3-256 with non-incremental API
 *
 * Arguments:   - uint8_t *h: pointer to output (32 bytes)
 *              - const uint8_t *in: pointer to input
 *              - size_t inlen: length of input in bytes
 **************************************************/
void sha3_256(uint8_t h[32], const uint8_t *in, size_t inlen)
{
    unsigned int i;
    uint64_t s[25];
    uint32_t *s_32b = (uint32_t *)s;
    uint32_t *p0, *p1;
#ifdef BIT_INTERLEAVING
    uint32_t t, t0, t1;
#endif

    keccak_absorb_once(s, SHA3_256_RATE, in, inlen, 0x06);
    KeccakF1600_StatePermute(s);
    for (i = 0; i < 4; i++) {
        p0 = (uint32_t *)(h + 8 * i);
        p1 = (uint32_t *)(h + 8 * i + 4);
#ifndef BIT_INTERLEAVING
        *p0 = s_32b[2 * i];
        *p1 = s_32b[2 * i + 1];
#else
        fromBitInterleaving(s_32b[2 * i], s_32b[2 * i + 1], *p0, *p1, t, t0,
                            t1);
#endif
    }
}

/*************************************************
 * Name:        sha3_512
 *
 * Description: SHA3-512 with non-incremental API
 *
 * Arguments:   - uint8_t *h: pointer to output (64 bytes)
 *              - const uint8_t *in: pointer to input
 *              - size_t inlen: length of input in bytes
 **************************************************/
void sha3_512(uint8_t h[64], const uint8_t *in, size_t inlen)
{
    unsigned int i;
    uint64_t s[25];
    uint32_t *s_32b = (uint32_t *)s;
    uint32_t *p0, *p1;
#ifdef BIT_INTERLEAVING
    uint32_t t, t0, t1;
#endif

    keccak_absorb_once(s, SHA3_512_RATE, in, inlen, 0x06);
    KeccakF1600_StatePermute(s);
    for (i = 0; i < 8; i++) {
        p0 = (uint32_t *)(h + 8 * i);
        p1 = (uint32_t *)(h + 8 * i + 4);
#ifndef BIT_INTERLEAVING
        *p0 = s_32b[2 * i];
        *p1 = s_32b[2 * i + 1];
#else
        fromBitInterleaving(s_32b[2 * i], s_32b[2 * i + 1], *p0, *p1, t, t0,
                            t1);
#endif
    }
}
