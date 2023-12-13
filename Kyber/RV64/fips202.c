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
 * Name:        load64
 *
 * Description: Load 8 bytes into uint64_t in little-endian order
 *
 * Arguments:   - const uint8_t *x: pointer to input byte array
 *
 * Returns the loaded 64-bit unsigned integer
 **************************************************/
static uint64_t load64(const uint8_t x[8])
{
    unsigned int i;
    uint64_t r = 0;

    for (i = 0; i < 8; i++)
        r |= (uint64_t)x[i] << 8 * i;

    return r;
}

/*************************************************
 * Name:        store64
 *
 * Description: Store a 64-bit integer to array of 8 bytes in little-endian
 *order
 *
 * Arguments:   - uint8_t *x: pointer to the output byte array (allocated)
 *              - uint64_t u: input 64-bit unsigned integer
 **************************************************/
static void store64(uint8_t x[8], uint64_t u)
{
    unsigned int i;

    for (i = 0; i < 8; i++)
        x[i] = u >> 8 * i;
}

/*************************************************
 * Name:        KeccakF1600_StatePermute
 *
 * Description: The Keccak F1600 Permutation
 *
 * Arguments:   - uint64_t *state: pointer to input/output Keccak state
 **************************************************/
#if (1)
extern void KeccakF1600_StatePermute_RV64(uint64_t state[25]);
void KeccakF1600_StatePermute(uint64_t state[25])
{
    KeccakF1600_StatePermute_RV64(state);
}
#else
/* Keccak round constants */
static const uint64_t KeccakF_RoundConstants[NROUNDS] = {
    (uint64_t)0x0000000000000001ULL, (uint64_t)0x0000000000008082ULL,
    (uint64_t)0x800000000000808aULL, (uint64_t)0x8000000080008000ULL,
    (uint64_t)0x000000000000808bULL, (uint64_t)0x0000000080000001ULL,
    (uint64_t)0x8000000080008081ULL, (uint64_t)0x8000000000008009ULL,
    (uint64_t)0x000000000000008aULL, (uint64_t)0x0000000000000088ULL,
    (uint64_t)0x0000000080008009ULL, (uint64_t)0x000000008000000aULL,
    (uint64_t)0x000000008000808bULL, (uint64_t)0x800000000000008bULL,
    (uint64_t)0x8000000000008089ULL, (uint64_t)0x8000000000008003ULL,
    (uint64_t)0x8000000000008002ULL, (uint64_t)0x8000000000000080ULL,
    (uint64_t)0x000000000000800aULL, (uint64_t)0x800000008000000aULL,
    (uint64_t)0x8000000080008081ULL, (uint64_t)0x8000000000008080ULL,
    (uint64_t)0x0000000080000001ULL, (uint64_t)0x8000000080008008ULL};

#    define ChiOp(S00, S01, S02, out) \
        out = ~S01;                   \
        out = out & S02;              \
        out = S00 ^ out

#    define PiChiOp(S00, S01, S02, S03, S04, T00, T01, T02, T03) \
        T00 = S00;                                               \
        ChiOp(T00, S01, S02, S00);                               \
        T01 = S03;                                               \
        ChiOp(T01, S04, T00, S03);                               \
        T02 = S04;                                               \
        ChiOp(T02, T00, S01, S04);                               \
        T00 = S01;                                               \
        ChiOp(T00, S02, T01, S01);                               \
        T03 = S02;                                               \
        ChiOp(T03, T01, T02, S02)

#    define ARound(S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, S10, S11, \
                   S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22, S23, \
                   S24)                                                        \
        C0 = S00 ^ S05 ^ S10 ^ S15 ^ S20;                                      \
        C2 = S02 ^ S07 ^ S12 ^ S17 ^ S22;                                      \
        D1 = C0 ^ ROL(C2, 1);                                                  \
        C1 = S01 ^ S06 ^ S11 ^ S16 ^ S21;                                      \
        S06 ^= D1;                                                             \
        S16 ^= D1;                                                             \
        S01 ^= D1;                                                             \
        S11 ^= D1;                                                             \
        S21 ^= D1;                                                             \
        C4 = S04 ^ S09 ^ S14 ^ S19 ^ S24;                                      \
        D3 = C2 ^ ROL(C4, 1);                                                  \
        C3 = S03 ^ S08 ^ S13 ^ S18 ^ S23;                                      \
        S18 ^= D3;                                                             \
        S03 ^= D3;                                                             \
        S13 ^= D3;                                                             \
        S23 ^= D3;                                                             \
        S08 ^= D3;                                                             \
        D4 = C3 ^ ROL(C0, 1);                                                  \
        S24 ^= D4;                                                             \
        S09 ^= D4;                                                             \
        S19 ^= D4;                                                             \
        S04 ^= D4;                                                             \
        S14 ^= D4;                                                             \
        D2 = C1 ^ ROL(C3, 1);                                                  \
        S12 ^= D2;                                                             \
        S22 ^= D2;                                                             \
        S07 ^= D2;                                                             \
        S17 ^= D2;                                                             \
        S02 ^= D2;                                                             \
        D0 = C4 ^ ROL(C1, 1);                                                  \
        S00 ^= D0;                                                             \
        S05 ^= D0;                                                             \
        S10 ^= D0;                                                             \
        S15 ^= D0;                                                             \
        S20 ^= D0;                                                             \
        S00 = S00;                                                             \
        S01 = ROL(S01, 1);                                                     \
        S02 = ROL(S02, 62);                                                    \
        S03 = ROL(S03, 28);                                                    \
        S04 = ROL(S04, 27);                                                    \
        S05 = ROL(S05, 36);                                                    \
        S06 = ROL(S06, 44);                                                    \
        S07 = ROL(S07, 6);                                                     \
        S08 = ROL(S08, 55);                                                    \
        S09 = ROL(S09, 20);                                                    \
        S10 = ROL(S10, 3);                                                     \
        S11 = ROL(S11, 10);                                                    \
        S12 = ROL(S12, 43);                                                    \
        S13 = ROL(S13, 25);                                                    \
        S14 = ROL(S14, 39);                                                    \
        S15 = ROL(S15, 41);                                                    \
        S16 = ROL(S16, 45);                                                    \
        S17 = ROL(S17, 15);                                                    \
        S18 = ROL(S18, 21);                                                    \
        S19 = ROL(S19, 8);                                                     \
        S20 = ROL(S20, 18);                                                    \
        S21 = ROL(S21, 2);                                                     \
        S22 = ROL(S22, 61);                                                    \
        S23 = ROL(S23, 56);                                                    \
        S24 = ROL(S24, 14);                                                    \
        PiChiOp(S00, S06, S12, S18, S24, C0, C1, C2, C3);                      \
        PiChiOp(S03, S09, S10, S16, S22, C0, C1, C2, C3);                      \
        PiChiOp(S01, S07, S13, S19, S20, C0, C1, C2, C3);                      \
        PiChiOp(S04, S05, S11, S17, S23, C0, C1, C2, C3);                      \
        PiChiOp(S02, S08, S14, S15, S21, C0, C1, C2, C3);                      \
        S00 ^= (uint64_t)KeccakF_RoundConstants[round++]

void KeccakF1600_StatePermute(uint64_t state[25])
{
    int round;

    uint64_t S00, S01, S02, S03, S04;
    uint64_t S05, S06, S07, S08, S09;
    uint64_t S10, S11, S12, S13, S14;
    uint64_t S15, S16, S17, S18, S19;
    uint64_t S20, S21, S22, S23, S24;

    uint64_t C0, C1, C2, C3, C4;
    uint64_t D0, D1, D2, D3, D4;

    // copyFromState(A, state)
    S00 = state[0];
    S01 = state[1];
    S02 = state[2];
    S03 = state[3];
    S04 = state[4];
    S05 = state[5];
    S06 = state[6];
    S07 = state[7];
    S08 = state[8];
    S09 = state[9];
    S10 = state[10];
    S11 = state[11];
    S12 = state[12];
    S13 = state[13];
    S14 = state[14];
    S15 = state[15];
    S16 = state[16];
    S17 = state[17];
    S18 = state[18];
    S19 = state[19];
    S20 = state[20];
    S21 = state[21];
    S22 = state[22];
    S23 = state[23];
    S24 = state[24];

    // for (round = 0; round < NROUNDS; round += 1) {
    // }
    round = 0;
    ARound(S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, S10, S11, S12, S13,
           S14, S15, S16, S17, S18, S19, S20, S21, S22, S23, S24);
    ARound(S00, S06, S12, S18, S24, S03, S09, S10, S16, S22, S01, S07, S13, S19,
           S20, S04, S05, S11, S17, S23, S02, S08, S14, S15, S21);
    ARound(S00, S09, S13, S17, S21, S18, S22, S01, S05, S14, S06, S10, S19, S23,
           S02, S24, S03, S07, S11, S15, S12, S16, S20, S04, S08);
    ARound(S00, S22, S19, S11, S08, S17, S14, S06, S03, S20, S09, S01, S23, S15,
           S12, S21, S18, S10, S07, S04, S13, S05, S02, S24, S16);
    ARound(S00, S14, S23, S07, S16, S11, S20, S09, S18, S02, S22, S06, S15, S04,
           S13, S08, S17, S01, S10, S24, S19, S03, S12, S21, S05);
    ARound(S00, S20, S15, S10, S05, S07, S02, S22, S17, S12, S14, S09, S04, S24,
           S19, S16, S11, S06, S01, S21, S23, S18, S13, S08, S03);
    ARound(S00, S02, S04, S01, S03, S10, S12, S14, S11, S13, S20, S22, S24, S21,
           S23, S05, S07, S09, S06, S08, S15, S17, S19, S16, S18);
    ARound(S00, S12, S24, S06, S18, S01, S13, S20, S07, S19, S02, S14, S21, S08,
           S15, S03, S10, S22, S09, S16, S04, S11, S23, S05, S17);
    ARound(S00, S13, S21, S09, S17, S06, S19, S02, S10, S23, S12, S20, S08, S16,
           S04, S18, S01, S14, S22, S05, S24, S07, S15, S03, S11);
    ARound(S00, S19, S08, S22, S11, S09, S23, S12, S01, S15, S13, S02, S16, S05,
           S24, S17, S06, S20, S14, S03, S21, S10, S04, S18, S07);
    ARound(S00, S23, S16, S14, S07, S22, S15, S13, S06, S04, S19, S12, S05, S03,
           S21, S11, S09, S02, S20, S18, S08, S01, S24, S17, S10);
    ARound(S00, S15, S05, S20, S10, S14, S04, S19, S09, S24, S23, S13, S03, S18,
           S08, S07, S22, S12, S02, S17, S16, S06, S21, S11, S01);
    ARound(S00, S04, S03, S02, S01, S20, S24, S23, S22, S21, S15, S19, S18, S17,
           S16, S10, S14, S13, S12, S11, S05, S09, S08, S07, S06);
    ARound(S00, S24, S18, S12, S06, S02, S21, S15, S14, S08, S04, S23, S17, S11,
           S05, S01, S20, S19, S13, S07, S03, S22, S16, S10, S09);
    ARound(S00, S21, S17, S13, S09, S12, S08, S04, S20, S16, S24, S15, S11, S07,
           S03, S06, S02, S23, S19, S10, S18, S14, S05, S01, S22);
    ARound(S00, S08, S11, S19, S22, S13, S16, S24, S02, S05, S21, S04, S07, S10,
           S18, S09, S12, S15, S23, S01, S17, S20, S03, S06, S14);
    ARound(S00, S16, S07, S23, S14, S19, S05, S21, S12, S03, S08, S24, S10, S01,
           S17, S22, S13, S04, S15, S06, S11, S02, S18, S09, S20);
    ARound(S00, S05, S10, S15, S20, S23, S03, S08, S13, S18, S16, S21, S01, S06,
           S11, S14, S19, S24, S04, S09, S07, S12, S17, S22, S02);
    ARound(S00, S03, S01, S04, S02, S15, S18, S16, S19, S17, S05, S08, S06, S09,
           S07, S20, S23, S21, S24, S22, S10, S13, S11, S14, S12);
    ARound(S00, S18, S06, S24, S12, S04, S17, S05, S23, S11, S03, S16, S09, S22,
           S10, S02, S15, S08, S21, S14, S01, S19, S07, S20, S13);
    ARound(S00, S17, S09, S21, S13, S24, S11, S03, S15, S07, S18, S05, S22, S14,
           S01, S12, S04, S16, S08, S20, S06, S23, S10, S02, S19);
    ARound(S00, S11, S22, S08, S19, S21, S07, S18, S04, S10, S17, S03, S14, S20,
           S06, S13, S24, S05, S16, S02, S09, S15, S01, S12, S23);
    ARound(S00, S07, S14, S16, S23, S08, S10, S17, S24, S01, S11, S18, S20, S02,
           S09, S19, S21, S03, S05, S12, S22, S04, S06, S13, S15);
    ARound(S00, S10, S20, S05, S15, S16, S01, S11, S21, S06, S07, S17, S02, S12,
           S22, S23, S08, S18, S03, S13, S14, S24, S09, S19, S04);

    // copyToState(state, A)
    // state[0] = S00;
    // state[1] = S06;
    // state[2] = S12;
    // state[3] = S18;
    // state[4] = S24;
    // state[5] = S03;
    // state[6] = S09;
    // state[7] = S10;
    // state[8] = S16;
    // state[9] = S22;
    // state[10] = S01;
    // state[11] = S07;
    // state[12] = S13;
    // state[13] = S19;
    // state[14] = S20;
    // state[15] = S04;
    // state[16] = S05;
    // state[17] = S11;
    // state[18] = S17;
    // state[19] = S23;
    // state[20] = S02;
    // state[21] = S08;
    // state[22] = S14;
    // state[23] = S15;
    // state[24] = S21;
    state[0] = S00;
    state[1] = S01;
    state[2] = S02;
    state[3] = S03;
    state[4] = S04;
    state[5] = S05;
    state[6] = S06;
    state[7] = S07;
    state[8] = S08;
    state[9] = S09;
    state[10] = S10;
    state[11] = S11;
    state[12] = S12;
    state[13] = S13;
    state[14] = S14;
    state[15] = S15;
    state[16] = S16;
    state[17] = S17;
    state[18] = S18;
    state[19] = S19;
    state[20] = S20;
    state[21] = S21;
    state[22] = S22;
    state[23] = S23;
    state[24] = S24;
}
#endif

/*************************************************
 * Name:        keccak_init
 *
 * Description: Initializes the Keccak state.
 *
 * Arguments:   - uint64_t *s: pointer to Keccak state
 **************************************************/
static void keccak_init(uint64_t s[25])
{
    unsigned int i;
    for (i = 0; i < 25; i++)
        s[i] = 0;
}

/*************************************************
 * Name:        keccak_absorb
 *
 * Description: Absorb step of Keccak; incremental.
 *
 * Arguments:   - uint64_t *s: pointer to Keccak state
 *              - unsigned int pos: position in current block to be absorbed
 *              - unsigned int r: rate in bytes (e.g., 168 for SHAKE128)
 *              - const uint8_t *in: pointer to input to be absorbed into s
 *              - size_t inlen: length of input in bytes
 *
 * Returns new position pos in current block
 **************************************************/
static unsigned int keccak_absorb(uint64_t s[25], unsigned int pos,
                                  unsigned int r, const uint8_t *in,
                                  size_t inlen)
{
    unsigned int i;

    while (pos + inlen >= r) {
        for (i = pos; i < r; i++)
            s[i / 8] ^= (uint64_t)*in++ << 8 * (i % 8);
        inlen -= r - pos;
        KeccakF1600_StatePermute(s);
        pos = 0;
    }

    for (i = pos; i < pos + inlen; i++)
        s[i / 8] ^= (uint64_t)*in++ << 8 * (i % 8);

    return i;
}

/*************************************************
 * Name:        keccak_finalize
 *
 * Description: Finalize absorb step.
 *
 * Arguments:   - uint64_t *s: pointer to Keccak state
 *              - unsigned int pos: position in current block to be absorbed
 *              - unsigned int r: rate in bytes (e.g., 168 for SHAKE128)
 *              - uint8_t p: domain separation byte
 **************************************************/
static void keccak_finalize(uint64_t s[25], unsigned int pos, unsigned int r,
                            uint8_t p)
{
    s[pos / 8] ^= (uint64_t)p << 8 * (pos % 8);
    s[r / 8 - 1] ^= 1ULL << 63;
}

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
    unsigned int i;

    for (i = 0; i < 25; i++)
        s[i] = 0;

    while (inlen >= r) {
        for (i = 0; i < r / 8; i++)
            s[i] ^= load64(in + 8 * i);
        in += r;
        inlen -= r;
        KeccakF1600_StatePermute(s);
    }

    for (i = 0; i < inlen; i++)
        s[i / 8] ^= (uint64_t)in[i] << 8 * (i % 8);

    s[i / 8] ^= (uint64_t)p << 8 * (i % 8);
    s[(r - 1) / 8] ^= 1ULL << 63;
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

    while (nblocks) {
        KeccakF1600_StatePermute(s);
        for (i = 0; i < r / 8; i++)
            store64(out + 8 * i, s[i]);
        out += r;
        nblocks -= 1;
    }
}

/*************************************************
 * Name:        shake128_init
 *
 * Description: Initilizes Keccak state for use as SHAKE128 XOF
 *
 * Arguments:   - keccak_state *state: pointer to (uninitialized) Keccak state
 **************************************************/
void shake128_init(keccak_state *state)
{
    keccak_init(state->s);
    state->pos = 0;
}

/*************************************************
 * Name:        shake128_absorb
 *
 * Description: Absorb step of the SHAKE128 XOF; incremental.
 *
 * Arguments:   - keccak_state *state: pointer to (initialized) output Keccak
 *state
 *              - const uint8_t *in: pointer to input to be absorbed into s
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake128_absorb(keccak_state *state, const uint8_t *in, size_t inlen)
{
    state->pos = keccak_absorb(state->s, state->pos, SHAKE128_RATE, in, inlen);
}

/*************************************************
 * Name:        shake128_finalize
 *
 * Description: Finalize absorb step of the SHAKE128 XOF.
 *
 * Arguments:   - keccak_state *state: pointer to Keccak state
 **************************************************/
void shake128_finalize(keccak_state *state)
{
    keccak_finalize(state->s, state->pos, SHAKE128_RATE, 0x1F);
    state->pos = SHAKE128_RATE;
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
 * Name:        shake256_init
 *
 * Description: Initilizes Keccak state for use as SHAKE256 XOF
 *
 * Arguments:   - keccak_state *state: pointer to (uninitialized) Keccak state
 **************************************************/
void shake256_init(keccak_state *state)
{
    keccak_init(state->s);
    state->pos = 0;
}

/*************************************************
 * Name:        shake256_absorb
 *
 * Description: Absorb step of the SHAKE256 XOF; incremental.
 *
 * Arguments:   - keccak_state *state: pointer to (initialized) output Keccak
 *state
 *              - const uint8_t *in: pointer to input to be absorbed into s
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake256_absorb(keccak_state *state, const uint8_t *in, size_t inlen)
{
    state->pos = keccak_absorb(state->s, state->pos, SHAKE256_RATE, in, inlen);
}

/*************************************************
 * Name:        shake256_finalize
 *
 * Description: Finalize absorb step of the SHAKE256 XOF.
 *
 * Arguments:   - keccak_state *state: pointer to Keccak state
 **************************************************/
void shake256_finalize(keccak_state *state)
{
    keccak_finalize(state->s, state->pos, SHAKE256_RATE, 0x1F);
    state->pos = SHAKE256_RATE;
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

    keccak_absorb_once(s, SHA3_256_RATE, in, inlen, 0x06);
    KeccakF1600_StatePermute(s);
    for (i = 0; i < 4; i++)
        store64(h + 8 * i, s[i]);
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

    keccak_absorb_once(s, SHA3_512_RATE, in, inlen, 0x06);
    KeccakF1600_StatePermute(s);
    for (i = 0; i < 8; i++)
        store64(h + 8 * i, s[i]);
}
