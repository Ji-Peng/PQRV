#include "indcpa.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#if defined(VECTOR128)
#    include <riscv_vector.h>
#endif

#include "fips202x.h"
#include "ntt.h"
#include "ntt_rvv.h"
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
#if defined(VECTOR128)
    for (i = 0; i < KYBER_K; i++)
        ntt2normal_order(pk->vec[i].coeffs, pk->vec[i].coeffs, qdata);
#endif
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
 * Arguments:   - polyvec *pk: pointer to output public-key polynomial
 *vector
 *              - uint8_t *seed: pointer to output seed to generate matrix
 *A
 *              - const uint8_t *packedpk: pointer to input serialized
 *public key
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
 *              - polyvec *sk: pointer to input vector of polynomials
 *(secret key)
 **************************************************/
static void pack_sk(uint8_t r[KYBER_INDCPA_SECRETKEYBYTES], polyvec *sk)
{
#if defined(VECTOR128)
    size_t i;
    for (i = 0; i < KYBER_K; i++)
        ntt2normal_order(sk->vec[i].coeffs, sk->vec[i].coeffs, qdata);
#endif
    polyvec_tobytes(r, sk);
}

/*************************************************
 * Name:        unpack_sk
 *
 * Description: De-serialize the secret key; inverse of pack_sk
 *
 * Arguments:   - polyvec *sk: pointer to output vector of polynomials
 *(secret key)
 *              - const uint8_t *packedsk: pointer to input serialized
 *secret key
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
static void pack_ciphertext(uint8_t r[KYBER_INDCPA_BYTES], polyvec *b,
                            poly *v)
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
 *              - const uint8_t *c: pointer to the input serialized
 *ciphertext
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
 *              - unsigned int len: requested number of 16-bit integers
 *(uniform mod q)
 *              - const uint8_t *buf: pointer to input buffer (assumed to
 *be uniformly random bytes)
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
        val0 =
            ((buf[pos + 0] >> 0) | ((uint16_t)buf[pos + 1] << 8)) & 0xFFF;
        val1 =
            ((buf[pos + 1] >> 4) | ((uint16_t)buf[pos + 2] << 4)) & 0xFFF;
        pos += 3;

        if (val0 < KYBER_Q)
            r[ctr++] = val0;
        if (ctr < len && val1 < KYBER_Q)
            r[ctr++] = val1;
    }

    return ctr;
}

#define GEN_MATRIX_NBLOCKS                                       \
    ((12 * KYBER_N / 8 * (1 << 12) / KYBER_Q + XOF_BLOCKBYTES) / \
     XOF_BLOCKBYTES)

#define REJ_UNIFORM_VECTOR_BUFLEN (GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES)

#if defined(VECTOR128)
static unsigned int rej_uniform_vector(int16_t *r, const uint8_t *buf)
{
    unsigned int ctr, pos;
    uint16_t val0, val1;
    unsigned long num0, num1;
    size_t vl;
    vuint8m1_t f0, f1, idx8;
    vuint16m1_t g0, g1, t0;
    vbool16_t mask_01, good0, good1;

    const uint16_t mask_12bits = 0xFFF;
    const uint16_t bound = KYBER_Q;
    const uint8_t idx8_t[16] __attribute__((aligned(16))) = {
        0, 1, 1, 2, 3, 4, 4, 5, 6, 7, 7, 8, 9, 10, 10, 11};
    const uint16_t mask_01_t[8] = {0, 1, 0, 1, 0, 1, 0, 1};

    // init useful vector variables
    vl = vsetvl_e8m1(128 / 8);
    idx8 = vle8_v_u8m1(idx8_t, vl);
    vl = vsetvl_e16m1(128 / 16);
    t0 = vle16_v_u16m1(mask_01_t, vl);
    mask_01 = vmseq_vx_u16m1_b16(t0, 1, vl);

    ctr = pos = 0;
    while (ctr <= KYBER_N - 16 && pos <= REJ_UNIFORM_VECTOR_BUFLEN - 24) {
        vl = vsetvl_e8m1(128 / 8);
        f0 = vle8_v_u8m1(&buf[pos], vl);
        f1 = vle8_v_u8m1(&buf[pos + 12], vl);
        pos += 24;
        f0 = vrgather_vv_u8m1(f0, idx8, vl);
        f1 = vrgather_vv_u8m1(f1, idx8, vl);

        vl = vsetvl_e16m1(128 / 16);
        g0 = vreinterpret_v_u8m1_u16m1(f0);
        g1 = vreinterpret_v_u8m1_u16m1(f1);
        g0 = vsrl_vx_u16m1_m(mask_01, g0, g0, 4, vl);
        g1 = vsrl_vx_u16m1_m(mask_01, g1, g1, 4, vl);

        g0 = vand_vx_u16m1(g0, mask_12bits, vl);
        g1 = vand_vx_u16m1(g1, mask_12bits, vl);

        good0 = vmsltu_vx_u16m1_b16(g0, bound, vl);
        good1 = vmsltu_vx_u16m1_b16(g1, bound, vl);
        num0 = vcpop_m_b16(good0, vl);
        num1 = vcpop_m_b16(good1, vl);

        g0 = vcompress_vm_u16m1(good0, g0, g0, vl);
        g1 = vcompress_vm_u16m1(good1, g1, g1, vl);

        vse16_v_u16m1((uint16_t *)&r[ctr], g0, vl);
        ctr += num0;
        vse16_v_u16m1((uint16_t *)&r[ctr], g1, vl);
        ctr += num1;
    }
    while (ctr < KYBER_N && pos <= REJ_UNIFORM_VECTOR_BUFLEN - 3) {
        val0 =
            ((buf[pos + 0] >> 0) | ((uint16_t)buf[pos + 1] << 8)) & 0xFFF;
        val1 = ((buf[pos + 1] >> 4) | ((uint16_t)buf[pos + 2] << 4));
        pos += 3;
        if (val0 < KYBER_Q)
            r[ctr++] = val0;
        if (val1 < KYBER_Q && ctr < KYBER_N)
            r[ctr++] = val1;
    }
    return ctr;
}
#endif

#define gen_a(A, B) gen_matrix(A, B, 0)
#define gen_at(A, B) gen_matrix(A, B, 1)

#if KYBER_K == 2

#    if defined(RV32IMV)
// using 2x 2-way sha3
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr[2];
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[2];
    keccakx2_state *statex2;
    keccak_state statex1;
    const uint8_t *inN[2];
    uint8_t *outN[2];
    const uint8_t buf_index[2][2][2] = {{{0, 0}, {0, 1}},
                                        {{1, 0}, {1, 1}}};

    if ((statex2 = malloc(sizeof(keccakx2_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }

    for (i = 0; i < 2; i++) {
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
        shake128x2_absorb_once(statex2, inN, 34);
        shake128x2_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, statex2);
        for (j = 0; j < 2; j++)
            ctr[j] = rej_uniform_vector(
                a[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs,
                buf[j].coeffs);
        for (j = 0; j < 2; j++) {
            if (ctr[j] < KYBER_N)
                keccakx2_get_oneway_state(statex2, &statex1, j);
            while (ctr[j] < KYBER_N) {
                shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] += rej_uniform(
                    a[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs +
                        ctr[j],
                    KYBER_N - ctr[j], buf[0].coeffs, SHAKE128_RATE);
            }
        }
    }
    for (i = 0; i < KYBER_K; i++)
        for (j = 0; j < KYBER_K; j++)
            normal2ntt_order(a[i].vec[j].coeffs, a[i].vec[j].coeffs,
                             qdata);
    free(statex2);
}

#    elif defined(RV32IMBV)
// using 1x 4-way sha3
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr[4];
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[4];
    keccakx4_state *statex4;
    keccak_state statex1;
    const uint8_t *inN[4];
    uint8_t *outN[4];
    const uint8_t buf_index[4][2] = {{0, 0}, {0, 1}, {1, 0}, {1, 1}};

    if ((statex4 = malloc(sizeof(keccakx4_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }

    for (j = 0; j < 4; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, 32);
        if (transposed) {
            buf[j].coeffs[32] = buf_index[j][0];
            buf[j].coeffs[33] = buf_index[j][1];
        } else {
            buf[j].coeffs[32] = buf_index[j][1];
            buf[j].coeffs[33] = buf_index[j][0];
        }
    }
    shake128x4_absorb_once(statex4, inN, 34);
    shake128x4_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, statex4);
    for (j = 0; j < 4; j++)
        ctr[j] = rej_uniform_vector(
            a[buf_index[j][0]].vec[buf_index[j][1]].coeffs, buf[j].coeffs);
    for (j = 0; j < 4; j++) {
        if (ctr[j] < KYBER_N)
            keccakx4_get_oneway_state(statex4, &statex1, j);
        while (ctr[j] < KYBER_N) {
            shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
            ctr[j] += rej_uniform(
                a[buf_index[j][0]].vec[buf_index[j][1]].coeffs + ctr[j],
                KYBER_N - ctr[j], buf[0].coeffs, SHAKE128_RATE);
        }
    }
    for (i = 0; i < KYBER_K; i++)
        for (j = 0; j < KYBER_K; j++)
            normal2ntt_order(a[i].vec[j].coeffs, a[i].vec[j].coeffs,
                             qdata);
    free(statex4);
}
#    endif
#endif

#if KYBER_K == 3 && (defined(RV32IMV) || defined(RV32IMBV))
// using 3x 3-way sha3
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr[3];
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[3];
    keccakx3_state *statex3;
    keccak_state statex1;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint8_t buf_index[(KYBER_K * KYBER_K) / 3][3][2] = {
        {{0, 0}, {0, 1}, {0, 2}},
        {{1, 0}, {1, 1}, {1, 2}},
        {{2, 0}, {2, 1}, {2, 2}}};

    if ((statex3 = malloc(sizeof(keccakx3_state))) == NULL) {
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
        shake128x3_absorb_once(statex3, inN, 34);
        shake128x3_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, statex3);
        for (j = 0; j < 3; j++)
            ctr[j] = rej_uniform_vector(
                a[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs,
                buf[j].coeffs);
        for (j = 0; j < 3; j++) {
            if (ctr[j] < KYBER_N)
                keccakx3_get_oneway_state(statex3, &statex1, j);
            while (ctr[j] < KYBER_N) {
                shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] += rej_uniform(
                    a[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs +
                        ctr[j],
                    KYBER_N - ctr[j], buf[0].coeffs, SHAKE128_RATE);
            }
        }
    }
    for (i = 0; i < KYBER_K; i++)
        for (j = 0; j < KYBER_K; j++)
            normal2ntt_order(a[i].vec[j].coeffs, a[i].vec[j].coeffs,
                             qdata);
    free(statex3);
}
#endif

#if KYBER_K == 4 && defined(RV32IMV)
// using 4x 3-way sha3 + 2x 2-way sha3
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr[3];
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[3];
    keccakx3_state *statex3;
    keccakx2_state *statex2;
    keccak_state statex1;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint8_t buf_index[4][3][2] = {
        {{0, 0}, {0, 1}, {0, 2}},
        {{0, 3}, {1, 0}, {1, 1}},
        {{1, 2}, {1, 3}, {2, 0}},
        {{2, 1}, {2, 2}, {2, 3}},
    };
    const uint8_t buf_index_x2[2][2][2] = {
        {{3, 0}, {3, 1}},
        {{3, 2}, {3, 3}},
    };

    if ((statex3 = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 4; i++) {
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
        shake128x3_absorb_once(statex3, inN, 34);
        shake128x3_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, statex3);
        for (j = 0; j < 3; j++)
            ctr[j] = rej_uniform_vector(
                a[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs,
                buf[j].coeffs);
        for (j = 0; j < 3; j++) {
            if (ctr[j] < KYBER_N)
                keccakx3_get_oneway_state(statex3, &statex1, j);
            while (ctr[j] < KYBER_N) {
                shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] += rej_uniform(
                    a[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs +
                        ctr[j],
                    KYBER_N - ctr[j], buf[0].coeffs, SHAKE128_RATE);
            }
        }
    }
    free(statex3);

    if ((statex2 = malloc(sizeof(keccakx2_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 2; i++) {
        for (j = 0; j < 2; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            if (transposed) {
                buf[j].coeffs[32] = buf_index_x2[i][j][0];
                buf[j].coeffs[33] = buf_index_x2[i][j][1];
            } else {
                buf[j].coeffs[32] = buf_index_x2[i][j][1];
                buf[j].coeffs[33] = buf_index_x2[i][j][0];
            }
        }
        shake128x2_absorb_once(statex2, inN, 34);
        shake128x2_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, statex2);
        for (j = 0; j < 2; j++)
            ctr[j] = rej_uniform_vector(
                a[buf_index_x2[i][j][0]].vec[buf_index_x2[i][j][1]].coeffs,
                buf[j].coeffs);
        for (j = 0; j < 2; j++) {
            if (ctr[j] < KYBER_N)
                keccakx2_get_oneway_state(statex2, &statex1, j);
            while (ctr[j] < KYBER_N) {
                shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] += rej_uniform(a[buf_index_x2[i][j][0]]
                                              .vec[buf_index_x2[i][j][1]]
                                              .coeffs +
                                          ctr[j],
                                      KYBER_N - ctr[j], buf[0].coeffs,
                                      SHAKE128_RATE);
            }
        }
    }
    free(statex2);

    for (i = 0; i < KYBER_K; i++)
        for (j = 0; j < KYBER_K; j++)
            normal2ntt_order(a[i].vec[j].coeffs, a[i].vec[j].coeffs,
                             qdata);
}
#elif KYBER_K == 4 && defined(RV32IMBV)
// using 4x 3-way sha3 + 1x 4-way sha3
void gen_matrix(polyvec *a, const uint8_t seed[32], int transposed)
{
    unsigned int i, j, ctr[4];
    ALIGNED_UINT8(GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES) buf[4];
    keccakx3_state *statex3;
    keccakx4_state *statex4;
    keccak_state statex1;
    const uint8_t *inN[4];
    uint8_t *outN[4];
    const uint8_t buf_index[4][3][2] = {
        {{0, 0}, {0, 1}, {0, 2}},
        {{0, 3}, {1, 0}, {1, 1}},
        {{1, 2}, {1, 3}, {2, 0}},
        {{2, 1}, {2, 2}, {2, 3}},
    };
    const uint8_t buf_index_x4[4][2] = {
        {3, 0},
        {3, 1},
        {3, 2},
        {3, 3},
    };

    if ((statex3 = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 4; i++) {
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
        shake128x3_absorb_once(statex3, inN, 34);
        shake128x3_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, statex3);
        for (j = 0; j < 3; j++)
            ctr[j] = rej_uniform_vector(
                a[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs,
                buf[j].coeffs);
        for (j = 0; j < 3; j++) {
            if (ctr[j] < KYBER_N)
                keccakx3_get_oneway_state(statex3, &statex1, j);
            while (ctr[j] < KYBER_N) {
                shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] += rej_uniform(
                    a[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs +
                        ctr[j],
                    KYBER_N - ctr[j], buf[0].coeffs, SHAKE128_RATE);
            }
        }
    }
    free(statex3);

    if ((statex4 = malloc(sizeof(keccakx4_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 4; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, 32);
        if (transposed) {
            buf[j].coeffs[32] = buf_index_x4[j][0];
            buf[j].coeffs[33] = buf_index_x4[j][1];
        } else {
            buf[j].coeffs[32] = buf_index_x4[j][1];
            buf[j].coeffs[33] = buf_index_x4[j][0];
        }
    }
    shake128x4_absorb_once(statex4, inN, 34);
    shake128x4_squeezeblocks(outN, GEN_MATRIX_NBLOCKS, statex4);
    for (j = 0; j < 4; j++)
        ctr[j] = rej_uniform_vector(
            a[buf_index_x4[j][0]].vec[buf_index_x4[j][1]].coeffs,
            buf[j].coeffs);
    for (j = 0; j < 4; j++) {
        if (ctr[j] < KYBER_N)
            keccakx4_get_oneway_state(statex4, &statex1, j);
        while (ctr[j] < KYBER_N) {
            shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
            ctr[j] += rej_uniform(
                a[buf_index_x4[j][0]].vec[buf_index_x4[j][1]].coeffs +
                    ctr[j],
                KYBER_N - ctr[j], buf[0].coeffs, SHAKE128_RATE);
        }
    }
    free(statex4);

    for (i = 0; i < KYBER_K; i++)
        for (j = 0; j < KYBER_K; j++)
            normal2ntt_order(a[i].vec[j].coeffs, a[i].vec[j].coeffs,
                             qdata);
}
#endif

#if !defined(RV32IMV) && !defined(RV32IMBV)
void gen_matrix(polyvec *a, const uint8_t seed[KYBER_SYMBYTES],
                int transposed)
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
                ctr += rej_uniform(a[i].vec[j].coeffs + ctr, KYBER_N - ctr,
                                   buf, buflen);
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
    polyvec_reduce(&skpv);
    polyvec_ntt(&e);

    // matrix-vector multiplication
#if defined(VECTOR128)
    polyvec_half skpv_cache;
    polyvec_basemul_acc_cache_init(&pkpv.vec[0], &a[0], &skpv,
                                   &skpv_cache);
    poly_tomont(&pkpv.vec[0]);
    for (i = 1; i < KYBER_K; i++) {
        polyvec_basemul_acc_cached(&pkpv.vec[i], &a[i], &skpv,
                                   &skpv_cache);
        poly_tomont(&pkpv.vec[i]);
    }
#elif defined(RV32)
    polyvec_half skpv_cache;
    polyvec_basemul_acc_cache_init(&pkpv.vec[0], &a[0], &skpv,
                                   &skpv_cache);
    poly_toplant(&pkpv.vec[0]);
    for (i = 1; i < KYBER_K; i++) {
        polyvec_basemul_acc_cached(&pkpv.vec[i], &a[i], &skpv,
                                   &skpv_cache);
        poly_toplant(&pkpv.vec[i]);
    }
#else
    for (i = 0; i < KYBER_K; i++) {
        polyvec_basemul_acc(&pkpv.vec[i], &a[i], &skpv);
        poly_tomont(&pkpv.vec[i]);
    }
#endif

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
 *                                   (of length
 *KYBER_INDCPA_PUBLICKEYBYTES)
 *              - const uint8_t *coins: pointer to input random coins used
 *as seed (of length KYBER_SYMBYTES) to deterministically generate all
 *randomness
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

    polyvec_gen_eta1_sp_eta2_ep_epp(&sp, &ep, &epp, coins);

    polyvec_ntt(&sp);

    // matrix-vector multiplication
#if defined(VECTOR128) || defined(RV32)
    polyvec_half sp_cache;
    polyvec_basemul_acc_cache_init(&b.vec[0], &at[0], &sp, &sp_cache);
    for (i = 1; i < KYBER_K; i++)
        polyvec_basemul_acc_cached(&b.vec[i], &at[i], &sp, &sp_cache);
    polyvec_basemul_acc_cached(&v, &pkpv, &sp, &sp_cache);
#else
    for (i = 0; i < KYBER_K; i++)
        polyvec_basemul_acc(&b.vec[i], &at[i], &sp);
    polyvec_basemul_acc(&v, &pkpv, &sp);
#endif

    polyvec_intt(&b);
    poly_intt(&v);

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
 *                                   (of length
 *KYBER_INDCPA_SECRETKEYBYTES)
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
    polyvec_basemul_acc(&mp, &skpv, &b);
    poly_intt(&mp);

    poly_sub(&mp, &v, &mp);
    poly_reduce(&mp);

    poly_tomsg(m, &mp);
}
