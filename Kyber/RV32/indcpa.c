#include "indcpa.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include "fips202x.h"
#include "ntt.h"
#include "params.h"
#include "poly.h"
#include "polyvec.h"
#include "randombytes.h"
#include "symmetric.h"

/*************************************************
 * Name:        pack_pk
 *
 * Description: Serialize the public key as concatenation of the
 *              serialized vector of polynomials pk
 *              and the public seed used to generate the matrix A.
 *
 * Arguments:   uint8_t *r: pointer to the output serialized public key
 *              polyvec *pk: pointer to the input public-key polyvec
 *              const uint8_t *seed: pointer to the input public seed
 **************************************************/
static void pack_pk(uint8_t r[KYBER_INDCPA_PUBLICKEYBYTES], polyvec *pk,
                    const uint8_t seed[KYBER_SYMBYTES])
{
    size_t i;
    polyvec_tobytes(r, pk);
    for (i = 0; i < KYBER_SYMBYTES; i++)
        r[i + KYBER_POLYVECBYTES] = seed[i];
}

/*************************************************
 * Name:        unpack_pk
 *
 * Description: De-serialize public key from a byte array;
 *              approximate inverse of pack_pk
 *
 * Arguments:   - polyvec *pk: pointer to output public-key polynomial vector
 *              - uint8_t *seed: pointer to output seed to generate matrix A
 *              - const uint8_t *packedpk: pointer to input serialized public
 *key
 **************************************************/
static void unpack_pk(polyvec *pk, uint8_t seed[KYBER_SYMBYTES],
                      const uint8_t packedpk[KYBER_INDCPA_PUBLICKEYBYTES])
{
    size_t i;
    polyvec_frombytes(pk, packedpk);
    for (i = 0; i < KYBER_SYMBYTES; i++)
        seed[i] = packedpk[i + KYBER_POLYVECBYTES];
}

/*************************************************
 * Name:        pack_sk
 *
 * Description: Serialize the secret key
 *
 * Arguments:   - uint8_t *r: pointer to output serialized secret key
 *              - polyvec *sk: pointer to input vector of polynomials (secret
 *key)
 **************************************************/
static void pack_sk(uint8_t r[KYBER_INDCPA_SECRETKEYBYTES], polyvec *sk)
{
    polyvec_tobytes(r, sk);
}

/*************************************************
 * Name:        unpack_sk
 *
 * Description: De-serialize the secret key; inverse of pack_sk
 *
 * Arguments:   - polyvec *sk: pointer to output vector of polynomials (secret
 *key)
 *              - const uint8_t *packedsk: pointer to input serialized secret
 *key
 **************************************************/
static void unpack_sk(polyvec *sk,
                      const uint8_t packedsk[KYBER_INDCPA_SECRETKEYBYTES])
{
    polyvec_frombytes(sk, packedsk);
}

/*************************************************
 * Name:        pack_ciphertext
 *
 * Description: Serialize the ciphertext as concatenation of the
 *              compressed and serialized vector of polynomials b
 *              and the compressed and serialized polynomial v
 *
 * Arguments:   uint8_t *r: pointer to the output serialized ciphertext
 *              poly *pk: pointer to the input vector of polynomials b
 *              poly *v: pointer to the input polynomial v
 **************************************************/
static void pack_ciphertext(uint8_t r[KYBER_INDCPA_BYTES], polyvec *b, poly *v)
{
    polyvec_compress(r, b);
    poly_compress(r + KYBER_POLYVECCOMPRESSEDBYTES, v);
}

/*************************************************
 * Name:        unpack_ciphertext
 *
 * Description: De-serialize and decompress ciphertext from a byte array;
 *              approximate inverse of pack_ciphertext
 *
 * Arguments:   - polyvec *b: pointer to the output vector of polynomials b
 *              - poly *v: pointer to the output polynomial v
 *              - const uint8_t *c: pointer to the input serialized ciphertext
 **************************************************/
static void unpack_ciphertext(polyvec *b, poly *v,
                              const uint8_t c[KYBER_INDCPA_BYTES])
{
    polyvec_decompress(b, c);
    poly_decompress(v, c + KYBER_POLYVECCOMPRESSEDBYTES);
}

/*************************************************
 * Name:        rej_uniform
 *
 * Description: Run rejection sampling on uniform random bytes to generate
 *              uniform random integers mod q
 *
 * Arguments:   - int16_t *r: pointer to output buffer
 *              - unsigned int len: requested number of 16-bit integers (uniform
 *mod q)
 *              - const uint8_t *buf: pointer to input buffer (assumed to be
 *uniformly random bytes)
 *              - unsigned int buflen: length of input buffer in bytes
 *
 * Returns number of sampled 16-bit integers (at most len)
 **************************************************/
static unsigned int rej_uniform(int16_t *r, unsigned int len,
                                const uint8_t *buf, unsigned int buflen)
{
    unsigned int ctr, pos;
    uint16_t val0, val1;

    ctr = pos = 0;
    while (ctr < len && pos + 3 <= buflen) {
        val0 = ((buf[pos + 0] >> 0) | ((uint16_t)buf[pos + 1] << 8)) & 0xFFF;
        val1 = ((buf[pos + 1] >> 4) | ((uint16_t)buf[pos + 2] << 4)) & 0xFFF;
        pos += 3;

        if (val0 < KYBER_Q)
            r[ctr++] = val0;
        if (ctr < len && val1 < KYBER_Q)
            r[ctr++] = val1;
    }

    return ctr;
}

#define gen_a(A, B) gen_matrix(A, B, 0)
#define gen_at(A, B) gen_matrix(A, B, 1)

#define GEN_MATRIX_NBLOCKS \
    ((12 * KYBER_N / 8 * (1 << 12) / KYBER_Q + XOF_BLOCKBYTES) / XOF_BLOCKBYTES)

#if defined(HYBRIDX4)
#    if KYBER_K == 2
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int j, ctr0, ctr1, ctr2, ctr3;
    unsigned int buflen;
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[4];
    keccakx4_state *state;
    const uint8_t *inN[4];
    uint8_t *outN[4];

    if ((state = malloc(sizeof(keccakx4_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }

    for (j = 0; j < 4; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, 32);
    }
    if (transposed) {
        buf[0].coeffs[32] = 0;
        buf[0].coeffs[33] = 0;
        buf[1].coeffs[32] = 0;
        buf[1].coeffs[33] = 1;
        buf[2].coeffs[32] = 1;
        buf[2].coeffs[33] = 0;
        buf[3].coeffs[32] = 1;
        buf[3].coeffs[33] = 1;
    } else {
        buf[0].coeffs[32] = 0;
        buf[0].coeffs[33] = 0;
        buf[1].coeffs[32] = 1;
        buf[1].coeffs[33] = 0;
        buf[2].coeffs[32] = 0;
        buf[2].coeffs[33] = 1;
        buf[3].coeffs[32] = 1;
        buf[3].coeffs[33] = 1;
    }
    shake128x4_absorb_once(state, inN, 34);
    shake128x4_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, state);
    buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
    ctr0 = rej_uniform(a[0].vec[0].coeffs, KYBER_N, buf[0].coeffs, buflen);
    ctr1 = rej_uniform(a[0].vec[1].coeffs, KYBER_N, buf[1].coeffs, buflen);
    ctr2 = rej_uniform(a[1].vec[0].coeffs, KYBER_N, buf[2].coeffs, buflen);
    ctr3 = rej_uniform(a[1].vec[1].coeffs, KYBER_N, buf[3].coeffs, buflen);
    while (ctr0 < KYBER_N || ctr1 < KYBER_N || ctr2 < KYBER_N ||
           ctr3 < KYBER_N) {
        shake128x4_squeezeblocks(outN, 1, state);
        ctr0 += rej_uniform(a[0].vec[0].coeffs + ctr0, KYBER_N - ctr0,
                            buf[0].coeffs, SHAKE128_RATE);
        ctr1 += rej_uniform(a[0].vec[1].coeffs + ctr1, KYBER_N - ctr1,
                            buf[1].coeffs, SHAKE128_RATE);
        ctr2 += rej_uniform(a[1].vec[0].coeffs + ctr2, KYBER_N - ctr2,
                            buf[2].coeffs, SHAKE128_RATE);
        ctr3 += rej_uniform(a[1].vec[1].coeffs + ctr3, KYBER_N - ctr3,
                            buf[3].coeffs, SHAKE128_RATE);
    }
    free(state);
}
#    elif KYBER_K == 3
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr0, ctr1, ctr2, ctr3;
    unsigned int buflen;
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[4];
    keccakx4_state *state;
    keccak_state statex1;
    const uint8_t *inN[4];
    uint8_t *outN[4];
    const uint8_t buf_index[(KYBER_K * KYBER_K) / 4][4][2] = {
        {{0, 0}, {0, 1}, {0, 2}, {1, 0}}, {{1, 1}, {1, 2}, {2, 0}, {2, 1}}};

    if ((state = malloc(sizeof(keccakx4_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }

    for (i = 0; i < (KYBER_K * KYBER_K) / 4; i++) {
        for (j = 0; j < 4; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            if (transposed) {
                buf[j].coeffs[32] = buf_index[i][j][0];
                buf[j].coeffs[33] = buf_index[i][j][1];
            } else {
                buf[j].coeffs[32] = buf_index[i][j][1];
                buf[j].coeffs[33] = buf_index[i][j][0];
            }
        }
        shake128x4_absorb_once(state, inN, 34);
        shake128x4_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, state);
        buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
        ctr0 = rej_uniform(a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs,
                           KYBER_N, buf[0].coeffs, buflen);
        ctr1 = rej_uniform(a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs,
                           KYBER_N, buf[1].coeffs, buflen);
        ctr2 = rej_uniform(a[buf_index[i][2][0]].vec[buf_index[i][2][1]].coeffs,
                           KYBER_N, buf[2].coeffs, buflen);
        ctr3 = rej_uniform(a[buf_index[i][3][0]].vec[buf_index[i][3][1]].coeffs,
                           KYBER_N, buf[3].coeffs, buflen);
        while (ctr0 < KYBER_N || ctr1 < KYBER_N || ctr2 < KYBER_N ||
               ctr3 < KYBER_N) {
            shake128x4_squeezeblocks(outN, 1, state);
            ctr0 += rej_uniform(
                a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs + ctr0,
                KYBER_N - ctr0, buf[0].coeffs, SHAKE128_RATE);
            ctr1 += rej_uniform(
                a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs + ctr1,
                KYBER_N - ctr1, buf[1].coeffs, SHAKE128_RATE);
            ctr2 += rej_uniform(
                a[buf_index[i][2][0]].vec[buf_index[i][2][1]].coeffs + ctr2,
                KYBER_N - ctr2, buf[2].coeffs, SHAKE128_RATE);
            ctr3 += rej_uniform(
                a[buf_index[i][3][0]].vec[buf_index[i][3][1]].coeffs + ctr3,
                KYBER_N - ctr3, buf[3].coeffs, SHAKE128_RATE);
        }
    }
    memcpy(buf[0].coeffs, seed, 32);
    buf[0].coeffs[32] = 2;
    buf[0].coeffs[33] = 2;
    shake128_absorb_once(&statex1, buf[0].coeffs, 34);
    shake128_squeezeblocks(buf[0].coeffs, GEN_MATRIX_NBLOCKS, &statex1);
    buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
    ctr0 = rej_uniform(a[2].vec[2].coeffs, KYBER_N, buf[0].coeffs, buflen);
    while (ctr0 < KYBER_N) {
        shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
        ctr0 += rej_uniform(a[2].vec[2].coeffs + ctr0, KYBER_N - ctr0,
                            buf[0].coeffs, SHAKE128_RATE);
    }
    free(state);
}
#    elif KYBER_K == 4
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr0, ctr1, ctr2, ctr3;
    unsigned int buflen;
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[4];
    keccakx4_state *state;
    const uint8_t *inN[4];
    uint8_t *outN[4];
    const uint8_t buf_index[(KYBER_K * KYBER_K) / 4][4][2] = {
        {{0, 0}, {0, 1}, {0, 2}, {0, 3}},
        {{1, 0}, {1, 1}, {1, 2}, {1, 3}},
        {{2, 0}, {2, 1}, {2, 2}, {2, 3}},
        {{3, 0}, {3, 1}, {3, 2}, {3, 3}}};

    if ((state = malloc(sizeof(keccakx4_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }

    for (i = 0; i < (KYBER_K * KYBER_K) / 4; i++) {
        for (j = 0; j < 4; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            if (transposed) {
                buf[j].coeffs[32] = buf_index[i][j][0];
                buf[j].coeffs[33] = buf_index[i][j][1];
            } else {
                buf[j].coeffs[32] = buf_index[i][j][1];
                buf[j].coeffs[33] = buf_index[i][j][0];
            }
        }
        shake128x4_absorb_once(state, inN, 34);
        shake128x4_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, state);
        buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
        ctr0 = rej_uniform(a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs,
                           KYBER_N, buf[0].coeffs, buflen);
        ctr1 = rej_uniform(a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs,
                           KYBER_N, buf[1].coeffs, buflen);
        ctr2 = rej_uniform(a[buf_index[i][2][0]].vec[buf_index[i][2][1]].coeffs,
                           KYBER_N, buf[2].coeffs, buflen);
        ctr3 = rej_uniform(a[buf_index[i][3][0]].vec[buf_index[i][3][1]].coeffs,
                           KYBER_N, buf[3].coeffs, buflen);
        while (ctr0 < KYBER_N || ctr1 < KYBER_N || ctr2 < KYBER_N ||
               ctr3 < KYBER_N) {
            shake128x4_squeezeblocks(outN, 1, state);
            ctr0 += rej_uniform(
                a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs + ctr0,
                KYBER_N - ctr0, buf[0].coeffs, SHAKE128_RATE);
            ctr1 += rej_uniform(
                a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs + ctr1,
                KYBER_N - ctr1, buf[1].coeffs, SHAKE128_RATE);
            ctr2 += rej_uniform(
                a[buf_index[i][2][0]].vec[buf_index[i][2][1]].coeffs + ctr2,
                KYBER_N - ctr2, buf[2].coeffs, SHAKE128_RATE);
            ctr3 += rej_uniform(
                a[buf_index[i][3][0]].vec[buf_index[i][3][1]].coeffs + ctr3,
                KYBER_N - ctr3, buf[3].coeffs, SHAKE128_RATE);
        }
    }
    free(state);
}
#    endif
#elif defined(HYBRIDX3)
#    if KYBER_K == 2
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int j, ctr0, ctr1, ctr2;
    unsigned int buflen;
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[3];
    keccakx3_state *state;
    keccak_state statex1;
    const uint8_t *inN[3];
    uint8_t *outN[3];

    if ((state = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }

    for (j = 0; j < 3; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, 32);
    }
    if (transposed) {
        buf[0].coeffs[32] = 0;
        buf[0].coeffs[33] = 0;
        buf[1].coeffs[32] = 0;
        buf[1].coeffs[33] = 1;
        buf[2].coeffs[32] = 1;
        buf[2].coeffs[33] = 0;
    } else {
        buf[0].coeffs[32] = 0;
        buf[0].coeffs[33] = 0;
        buf[1].coeffs[32] = 1;
        buf[1].coeffs[33] = 0;
        buf[2].coeffs[32] = 0;
        buf[2].coeffs[33] = 1;
    }
    shake128x3_absorb_once(state, inN, 34);
    shake128x3_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, state);
    buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
    ctr0 = rej_uniform(a[0].vec[0].coeffs, KYBER_N, buf[0].coeffs, buflen);
    ctr1 = rej_uniform(a[0].vec[1].coeffs, KYBER_N, buf[1].coeffs, buflen);
    ctr2 = rej_uniform(a[1].vec[0].coeffs, KYBER_N, buf[2].coeffs, buflen);
    while (ctr0 < KYBER_N || ctr1 < KYBER_N || ctr2 < KYBER_N) {
        shake128x3_squeezeblocks(outN, 1, state);
        ctr0 += rej_uniform(a[0].vec[0].coeffs + ctr0, KYBER_N - ctr0,
                            buf[0].coeffs, SHAKE128_RATE);
        ctr1 += rej_uniform(a[0].vec[1].coeffs + ctr1, KYBER_N - ctr1,
                            buf[1].coeffs, SHAKE128_RATE);
        ctr2 += rej_uniform(a[1].vec[0].coeffs + ctr2, KYBER_N - ctr2,
                            buf[2].coeffs, SHAKE128_RATE);
    }

    memcpy(buf[0].coeffs, seed, 32);
    buf[0].coeffs[32] = 1;
    buf[0].coeffs[33] = 1;
    shake128_absorb_once(&statex1, buf[0].coeffs, 34);
    shake128_squeezeblocks(buf[0].coeffs, GEN_MATRIX_NBLOCKS, &statex1);
    buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
    ctr0 = rej_uniform(a[1].vec[1].coeffs, KYBER_N, buf[0].coeffs, buflen);
    while (ctr0 < KYBER_N) {
        shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
        ctr0 += rej_uniform(a[1].vec[1].coeffs + ctr0, KYBER_N - ctr0,
                            buf[0].coeffs, SHAKE128_RATE);
    }

    free(state);
}
#    elif KYBER_K == 3
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr0, ctr1, ctr2;
    unsigned int buflen;
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[3];
    keccakx3_state *state;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint8_t buf_index[(KYBER_K * KYBER_K) / 3][3][2] = {
        {{0, 0}, {0, 1}, {0, 2}},
        {{1, 0}, {1, 1}, {1, 2}},
        {{2, 0}, {2, 1}, {2, 2}}};

    if ((state = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }

    for (i = 0; i < (KYBER_K * KYBER_K) / 3; i++) {
        for (j = 0; j < 3; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            if (transposed) {
                buf[j].coeffs[32] = buf_index[i][j][0];
                buf[j].coeffs[33] = buf_index[i][j][1];
            } else {
                buf[j].coeffs[32] = buf_index[i][j][1];
                buf[j].coeffs[33] = buf_index[i][j][0];
            }
        }
        shake128x3_absorb_once(state, inN, 34);
        shake128x3_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, state);
        buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
        ctr0 = rej_uniform(a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs,
                           KYBER_N, buf[0].coeffs, buflen);
        ctr1 = rej_uniform(a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs,
                           KYBER_N, buf[1].coeffs, buflen);
        ctr2 = rej_uniform(a[buf_index[i][2][0]].vec[buf_index[i][2][1]].coeffs,
                           KYBER_N, buf[2].coeffs, buflen);
        while (ctr0 < KYBER_N || ctr1 < KYBER_N || ctr2 < KYBER_N) {
            shake128x3_squeezeblocks(outN, 1, state);
            ctr0 += rej_uniform(
                a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs + ctr0,
                KYBER_N - ctr0, buf[0].coeffs, SHAKE128_RATE);
            ctr1 += rej_uniform(
                a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs + ctr1,
                KYBER_N - ctr1, buf[1].coeffs, SHAKE128_RATE);
            ctr2 += rej_uniform(
                a[buf_index[i][2][0]].vec[buf_index[i][2][1]].coeffs + ctr2,
                KYBER_N - ctr2, buf[2].coeffs, SHAKE128_RATE);
        }
    }
    free(state);
}
#    elif KYBER_K == 4
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr0, ctr1, ctr2;
    unsigned int buflen;
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[3];
    keccakx3_state *state;
    keccak_state statex1;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint8_t buf_index[(KYBER_K * KYBER_K) / 3][3][2] = {
        {{0, 0}, {0, 1}, {0, 2}},
        {{0, 3}, {1, 0}, {1, 1}},
        {{1, 2}, {1, 3}, {2, 0}},
        {{2, 1}, {2, 2}, {2, 3}},
        {{3, 0}, {3, 1}, {3, 2}}};

    if ((state = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }

    for (i = 0; i < (KYBER_K * KYBER_K) / 3; i++) {
        for (j = 0; j < 3; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            if (transposed) {
                buf[j].coeffs[32] = buf_index[i][j][0];
                buf[j].coeffs[33] = buf_index[i][j][1];
            } else {
                buf[j].coeffs[32] = buf_index[i][j][1];
                buf[j].coeffs[33] = buf_index[i][j][0];
            }
        }
        shake128x3_absorb_once(state, inN, 34);
        shake128x3_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, state);
        buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
        ctr0 = rej_uniform(a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs,
                           KYBER_N, buf[0].coeffs, buflen);
        ctr1 = rej_uniform(a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs,
                           KYBER_N, buf[1].coeffs, buflen);
        ctr2 = rej_uniform(a[buf_index[i][2][0]].vec[buf_index[i][2][1]].coeffs,
                           KYBER_N, buf[2].coeffs, buflen);
        while (ctr0 < KYBER_N || ctr1 < KYBER_N || ctr2 < KYBER_N) {
            shake128x3_squeezeblocks(outN, 1, state);
            ctr0 += rej_uniform(
                a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs + ctr0,
                KYBER_N - ctr0, buf[0].coeffs, SHAKE128_RATE);
            ctr1 += rej_uniform(
                a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs + ctr1,
                KYBER_N - ctr1, buf[1].coeffs, SHAKE128_RATE);
            ctr2 += rej_uniform(
                a[buf_index[i][2][0]].vec[buf_index[i][2][1]].coeffs + ctr2,
                KYBER_N - ctr2, buf[2].coeffs, SHAKE128_RATE);
        }
    }
    memcpy(buf[0].coeffs, seed, 32);
    buf[0].coeffs[32] = 3;
    buf[0].coeffs[33] = 3;
    shake128_absorb_once(&statex1, buf[0].coeffs, 34);
    shake128_squeezeblocks(buf[0].coeffs, GEN_MATRIX_NBLOCKS, &statex1);
    buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
    ctr0 = rej_uniform(a[3].vec[3].coeffs, KYBER_N, buf[0].coeffs, buflen);
    while (ctr0 < KYBER_N) {
        shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
        ctr0 += rej_uniform(a[3].vec[3].coeffs + ctr0, KYBER_N - ctr0,
                            buf[0].coeffs, SHAKE128_RATE);
    }

    free(state);
}
#    endif
#elif defined(VECTOR128)
#    if KYBER_K == 2
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr0, ctr1;
    unsigned int buflen;
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[2];
    keccakx2_state *state;
    const uint8_t *inN[2];
    uint8_t *outN[2];
    const uint8_t buf_index[(KYBER_K * KYBER_K) / 2][2][2] = {{{0, 0}, {0, 1}},
                                                              {{1, 0}, {1, 1}}};

    if ((state = malloc(sizeof(keccakx2_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < (KYBER_K * KYBER_K) / 2; i++) {
        for (j = 0; j < 2; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            if (transposed) {
                buf[j].coeffs[32] = buf_index[i][j][0];
                buf[j].coeffs[33] = buf_index[i][j][1];
            } else {
                buf[j].coeffs[32] = buf_index[i][j][1];
                buf[j].coeffs[33] = buf_index[i][j][0];
            }
        }
        shake128x2_absorb_once(state, inN, 34);
        shake128x2_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, state);
        buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
        ctr0 = rej_uniform(a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs,
                           KYBER_N, buf[0].coeffs, buflen);
        ctr1 = rej_uniform(a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs,
                           KYBER_N, buf[1].coeffs, buflen);
        while (ctr0 < KYBER_N || ctr1 < KYBER_N) {
            shake128x2_squeezeblocks(outN, 1, state);
            ctr0 += rej_uniform(
                a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs + ctr0,
                KYBER_N - ctr0, buf[0].coeffs, SHAKE128_RATE);
            ctr1 += rej_uniform(
                a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs + ctr1,
                KYBER_N - ctr1, buf[1].coeffs, SHAKE128_RATE);
        }
    }
    free(state);
}
#    elif KYBER_K == 3
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr0, ctr1;
    unsigned int buflen;
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[2];
    keccakx2_state *state;
    keccak_state statex1;
    const uint8_t *inN[2];
    uint8_t *outN[2];
    const uint8_t buf_index[(KYBER_K * KYBER_K) / 2][2][2] = {
        {{0, 0}, {0, 1}}, {{0, 2}, {1, 0}}, {{1, 1}, {1, 2}}, {{2, 0}, {2, 1}}};

    if ((state = malloc(sizeof(keccakx2_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < (KYBER_K * KYBER_K) / 2; i++) {
        for (j = 0; j < 2; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            if (transposed) {
                buf[j].coeffs[32] = buf_index[i][j][0];
                buf[j].coeffs[33] = buf_index[i][j][1];
            } else {
                buf[j].coeffs[32] = buf_index[i][j][1];
                buf[j].coeffs[33] = buf_index[i][j][0];
            }
        }
        shake128x2_absorb_once(state, inN, 34);
        shake128x2_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, state);
        buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
        ctr0 = rej_uniform(a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs,
                           KYBER_N, buf[0].coeffs, buflen);
        ctr1 = rej_uniform(a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs,
                           KYBER_N, buf[1].coeffs, buflen);
        while (ctr0 < KYBER_N || ctr1 < KYBER_N) {
            shake128x2_squeezeblocks(outN, 1, state);
            ctr0 += rej_uniform(
                a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs + ctr0,
                KYBER_N - ctr0, buf[0].coeffs, SHAKE128_RATE);
            ctr1 += rej_uniform(
                a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs + ctr1,
                KYBER_N - ctr1, buf[1].coeffs, SHAKE128_RATE);
        }
    }
    memcpy(buf[0].coeffs, seed, 32);
    buf[0].coeffs[32] = 2;
    buf[0].coeffs[33] = 2;
    shake128_absorb_once(&statex1, buf[0].coeffs, 34);
    shake128_squeezeblocks(buf[0].coeffs, GEN_MATRIX_NBLOCKS, &statex1);
    buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
    ctr0 = rej_uniform(a[2].vec[2].coeffs, KYBER_N, buf[0].coeffs, buflen);
    while (ctr0 < KYBER_N) {
        shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
        ctr0 += rej_uniform(a[2].vec[2].coeffs + ctr0, KYBER_N - ctr0,
                            buf[0].coeffs, SHAKE128_RATE);
    }
    free(state);
}
#    elif KYBER_K == 4
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr0, ctr1;
    unsigned int buflen;
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[2];
    keccakx2_state *state;
    const uint8_t *inN[2];
    uint8_t *outN[2];
    const uint8_t buf_index[(KYBER_K * KYBER_K) / 2][2][2] = {
        {{0, 0}, {0, 1}}, {{0, 2}, {0, 3}}, {{1, 0}, {1, 1}}, {{1, 2}, {1, 3}},
        {{2, 0}, {2, 1}}, {{2, 2}, {2, 3}}, {{3, 0}, {3, 1}}, {{3, 2}, {3, 3}}};

    if ((state = malloc(sizeof(keccakx2_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < (KYBER_K * KYBER_K) / 2; i++) {
        for (j = 0; j < 2; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            if (transposed) {
                buf[j].coeffs[32] = buf_index[i][j][0];
                buf[j].coeffs[33] = buf_index[i][j][1];
            } else {
                buf[j].coeffs[32] = buf_index[i][j][1];
                buf[j].coeffs[33] = buf_index[i][j][0];
            }
        }
        shake128x2_absorb_once(state, inN, 34);
        shake128x2_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, state);
        buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
        ctr0 = rej_uniform(a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs,
                           KYBER_N, buf[0].coeffs, buflen);
        ctr1 = rej_uniform(a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs,
                           KYBER_N, buf[1].coeffs, buflen);
        while (ctr0 < KYBER_N || ctr1 < KYBER_N) {
            shake128x2_squeezeblocks(outN, 1, state);
            ctr0 += rej_uniform(
                a[buf_index[i][0][0]].vec[buf_index[i][0][1]].coeffs + ctr0,
                KYBER_N - ctr0, buf[0].coeffs, SHAKE128_RATE);
            ctr1 += rej_uniform(
                a[buf_index[i][1][0]].vec[buf_index[i][1][1]].coeffs + ctr1,
                KYBER_N - ctr1, buf[1].coeffs, SHAKE128_RATE);
        }
    }
    free(state);
}
#    endif
#else
void gen_matrix(polyvec *a, const uint8_t seed[KYBER_SYMBYTES], int transposed)
{
    unsigned int ctr, i, j, k;
    unsigned int buflen, off;
    uint8_t buf[GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES + 2];
    xof_state state;

    for (i = 0; i < KYBER_K; i++) {
        for (j = 0; j < KYBER_K; j++) {
            if (transposed)
                xof_absorb(&state, seed, i, j);
            else
                xof_absorb(&state, seed, j, i);

            xof_squeezeblocks(buf, GEN_MATRIX_NBLOCKS, &state);
            buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
            ctr = rej_uniform(a[i].vec[j].coeffs, KYBER_N, buf, buflen);

            while (ctr < KYBER_N) {
                off = buflen % 3;
                for (k = 0; k < off; k++)
                    buf[k] = buf[buflen - off + k];
                xof_squeezeblocks(buf + off, 1, &state);
                buflen = off + XOF_BLOCKBYTES;
                ctr += rej_uniform(a[i].vec[j].coeffs + ctr, KYBER_N - ctr, buf,
                                   buflen);
            }
        }
    }
}
#endif

/*************************************************
* Name:        indcpa_keypair
*
* Description: Generates public and private key for the CPA-secure
*              public-key encryption scheme underlying Kyber
*
* Arguments:   - uint8_t *pk: pointer to output public key
*                             (of length KYBER_INDCPA_PUBLICKEYBYTES bytes)
*              - uint8_t *sk: pointer to output private key
                              (of length KYBER_INDCPA_SECRETKEYBYTES bytes)
**************************************************/
void indcpa_keypair(uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES],
                    uint8_t sk[KYBER_INDCPA_SECRETKEYBYTES])
{
    unsigned int i;
    uint8_t buf[2 * KYBER_SYMBYTES];
    const uint8_t *publicseed = buf;
    const uint8_t *noiseseed = buf + KYBER_SYMBYTES;
    polyvec a[KYBER_K], e, pkpv, skpv;

    randombytes(buf, KYBER_SYMBYTES);
    hash_g(buf, buf, KYBER_SYMBYTES);

    gen_a(a, publicseed);

    polyvec_gen_eta1_skpv_e(&skpv, &e, noiseseed);

    polyvec_ntt(&skpv);
    polyvec_ntt(&e);

    // matrix-vector multiplication
    for (i = 0; i < KYBER_K; i++) {
        polyvec_basemul_acc_montgomery(&pkpv.vec[i], &a[i], &skpv);
        poly_tomont(&pkpv.vec[i]);
    }

    polyvec_add(&pkpv, &pkpv, &e);
    polyvec_reduce(&pkpv);

    pack_sk(sk, &skpv);
    pack_pk(pk, &pkpv, publicseed);
}

/*************************************************
 * Name:        indcpa_enc
 *
 * Description: Encryption function of the CPA-secure
 *              public-key encryption scheme underlying Kyber.
 *
 * Arguments:   - uint8_t *c: pointer to output ciphertext
 *                            (of length KYBER_INDCPA_BYTES bytes)
 *              - const uint8_t *m: pointer to input message
 *                                  (of length KYBER_INDCPA_MSGBYTES bytes)
 *              - const uint8_t *pk: pointer to input public key
 *                                   (of length KYBER_INDCPA_PUBLICKEYBYTES)
 *              - const uint8_t *coins: pointer to input random coins used as
 *seed (of length KYBER_SYMBYTES) to deterministically generate all randomness
 **************************************************/
void indcpa_enc(uint8_t c[KYBER_INDCPA_BYTES],
                const uint8_t m[KYBER_INDCPA_MSGBYTES],
                const uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES],
                const uint8_t coins[KYBER_SYMBYTES])
{
    unsigned int i;
    uint8_t seed[KYBER_SYMBYTES];
    polyvec sp, pkpv, ep, at[KYBER_K], b;
    poly v, k, epp;

    unpack_pk(&pkpv, seed, pk);
    poly_frommsg(&k, m);
    gen_at(at, seed);

    polyvec_gen_eta1_sp_eta2_ep_epp(&sp,&ep,&epp,coins);

    polyvec_ntt(&sp);

    // matrix-vector multiplication
    for (i = 0; i < KYBER_K; i++)
        polyvec_basemul_acc_montgomery(&b.vec[i], &at[i], &sp);

    polyvec_basemul_acc_montgomery(&v, &pkpv, &sp);

    polyvec_invntt_tomont(&b);
    poly_invntt_tomont(&v);

    polyvec_add(&b, &b, &ep);
    poly_add(&v, &v, &epp);
    poly_add(&v, &v, &k);
    polyvec_reduce(&b);
    poly_reduce(&v);

    pack_ciphertext(c, &b, &v);
}

/*************************************************
 * Name:        indcpa_dec
 *
 * Description: Decryption function of the CPA-secure
 *              public-key encryption scheme underlying Kyber.
 *
 * Arguments:   - uint8_t *m: pointer to output decrypted message
 *                            (of length KYBER_INDCPA_MSGBYTES)
 *              - const uint8_t *c: pointer to input ciphertext
 *                                  (of length KYBER_INDCPA_BYTES)
 *              - const uint8_t *sk: pointer to input secret key
 *                                   (of length KYBER_INDCPA_SECRETKEYBYTES)
 **************************************************/
void indcpa_dec(uint8_t m[KYBER_INDCPA_MSGBYTES],
                const uint8_t c[KYBER_INDCPA_BYTES],
                const uint8_t sk[KYBER_INDCPA_SECRETKEYBYTES])
{
    polyvec b, skpv;
    poly v, mp;

    unpack_ciphertext(&b, &v, c);
    unpack_sk(&skpv, sk);

    polyvec_ntt(&b);
    polyvec_basemul_acc_montgomery(&mp, &skpv, &b);
    poly_invntt_tomont(&mp);

    poly_sub(&mp, &v, &mp);
    poly_reduce(&mp);

    poly_tomsg(m, &mp);
}
