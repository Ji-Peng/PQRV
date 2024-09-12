#include "polyvec.h"

#include <stdint.h>
#include <string.h>

#include "fips202x.h"
#include "ntt.h"
#include "params.h"
#include "poly.h"

#define POLY_UNIFORM_NBLOCKS ((768 + SHAKE128_RATE - 1) / SHAKE128_RATE)

#if ETA == 2
#    define POLY_UNIFORM_ETA_NBLOCKS \
        ((136 + SHAKE256_RATE - 1) / SHAKE256_RATE)
#elif ETA == 4
#    define POLY_UNIFORM_ETA_NBLOCKS \
        ((227 + SHAKE256_RATE - 1) / SHAKE256_RATE)
#endif

#define POLY_UNIFORM_GAMMA1_NBLOCKS \
    ((POLYZ_PACKEDBYTES + SHAKE256_RATE - 1) / SHAKE256_RATE)

#if DILITHIUM_MODE == 2 && (defined(RV32IMV) || defined(RV32IMBV))
// 4x 3-way + 2x 2-way sha3
void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES])
{
    unsigned int i, j, ctr[3];
    ALIGNED_UINT8(POLY_UNIFORM_NBLOCKS * SHAKE128_RATE) buf[3];
    keccakx3_state *statex3;
    keccakx2_state *statex2;
    keccak_state statex1;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint8_t *seed = rho;
    const uint8_t buf_index[4][3][2] = {
        {{0, 0}, {0, 1}, {0, 2}},
        {{0, 3}, {1, 0}, {1, 1}},
        {{1, 2}, {1, 3}, {2, 0}},
        {{2, 1}, {2, 2}, {2, 3}},
    };
    const uint8_t buf_index_x2[2][4][2] = {
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
            buf[j].coeffs[32] = buf_index[i][j][1];
            buf[j].coeffs[33] = buf_index[i][j][0];
        }
        shake128x3_absorb_once(statex3, inN, 34);
        shake128x3_squeezeblocks(outN, POLY_UNIFORM_NBLOCKS, statex3);
        for (j = 0; j < 3; j++)
            ctr[j] = rej_uniform_vector(
                mat[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs,
                buf[j].coeffs);
        for (j = 0; j < 3; j++) {
            if (ctr[j] < N)
                keccakx3_get_oneway_state(statex3, &statex1, j);
            while (ctr[j] < N) {
                shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] +=
                    rej_uniform(mat[buf_index[i][j][0]]
                                        .vec[buf_index[i][j][1]]
                                        .coeffs +
                                    ctr[j],
                                N - ctr[j], buf[0].coeffs, SHAKE128_RATE);
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
            buf[j].coeffs[32] = buf_index_x2[i][j][1];
            buf[j].coeffs[33] = buf_index_x2[i][j][0];
        }
        shake128x2_absorb_once(statex2, inN, 34);
        shake128x2_squeezeblocks(outN, POLY_UNIFORM_NBLOCKS, statex2);
        for (j = 0; j < 2; j++)
            ctr[j] = rej_uniform_vector(mat[buf_index_x2[i][j][0]]
                                            .vec[buf_index_x2[i][j][1]]
                                            .coeffs,
                                        buf[j].coeffs);
        for (j = 0; j < 2; j++) {
            if (ctr[j] < N)
                keccakx2_get_oneway_state(statex2, &statex1, j);
            while (ctr[j] < N) {
                shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] +=
                    rej_uniform(mat[buf_index_x2[i][j][0]]
                                        .vec[buf_index_x2[i][j][1]]
                                        .coeffs +
                                    ctr[j],
                                N - ctr[j], buf[0].coeffs, SHAKE128_RATE);
            }
        }
    }
    for (i = 0; i < K; i++)
        for (j = 0; j < L; j++)
            normal2ntt_order_8l_rvv(mat[i].vec[j].coeffs, qdata);
    free(statex2);
}
#endif

#if DILITHIUM_MODE == 3 && (defined(RV32IMV) || defined(RV32IMBV))
// 10x 3-way sha3
void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES])
{
    unsigned int i, j, ctr[3];
    ALIGNED_UINT8(POLY_UNIFORM_NBLOCKS * SHAKE128_RATE) buf[3];
    keccakx3_state *statex3;
    keccak_state statex1;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint8_t *seed = rho;
    const uint8_t buf_index[10][3][2] = {
        {{0, 0}, {0, 1}, {0, 2}}, {{0, 3}, {0, 4}, {1, 0}},
        {{1, 1}, {1, 2}, {1, 3}}, {{1, 4}, {2, 0}, {2, 1}},
        {{2, 2}, {2, 3}, {2, 4}}, {{3, 0}, {3, 1}, {3, 2}},
        {{3, 3}, {3, 4}, {4, 0}}, {{4, 1}, {4, 2}, {4, 3}},
        {{4, 4}, {5, 0}, {5, 1}}, {{5, 2}, {5, 3}, {5, 4}},
    };

    if ((statex3 = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 10; i++) {
        for (j = 0; j < 3; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            buf[j].coeffs[32] = buf_index[i][j][1];
            buf[j].coeffs[33] = buf_index[i][j][0];
        }
        shake128x3_absorb_once(statex3, inN, 34);
        shake128x3_squeezeblocks(outN, POLY_UNIFORM_NBLOCKS, statex3);
        for (j = 0; j < 3; j++)
            ctr[j] = rej_uniform_vector(
                mat[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs,
                buf[j].coeffs);
        for (j = 0; j < 3; j++) {
            if (ctr[j] < N)
                keccakx3_get_oneway_state(statex3, &statex1, j);
            while (ctr[j] < N) {
                shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] +=
                    rej_uniform(mat[buf_index[i][j][0]]
                                        .vec[buf_index[i][j][1]]
                                        .coeffs +
                                    ctr[j],
                                N - ctr[j], buf[0].coeffs, SHAKE128_RATE);
            }
        }
    }
    for (i = 0; i < K; i++)
        for (j = 0; j < L; j++)
            normal2ntt_order_8l_rvv(mat[i].vec[j].coeffs, qdata);
    free(statex3);
}
#endif

#if DILITHIUM_MODE == 5 && (defined(RV32IMV) || defined(RV32IMBV))
// 18x 3-way + 1x 2-way sha3
void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES])
{
    unsigned int i, j, ctr[3];
    ALIGNED_UINT8(POLY_UNIFORM_NBLOCKS * SHAKE128_RATE) buf[3];
    keccakx3_state *statex3;
    keccakx2_state *statex2;
    keccak_state statex1;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint8_t *seed = rho;
    const uint8_t buf_index[18 + 1][3][2] = {
        {{0, 0}, {0, 1}, {0, 2}}, {{0, 3}, {0, 4}, {0, 5}},
        {{0, 6}, {1, 0}, {1, 1}}, {{1, 2}, {1, 3}, {1, 4}},
        {{1, 5}, {1, 6}, {2, 0}}, {{2, 1}, {2, 2}, {2, 3}},
        {{2, 4}, {2, 5}, {2, 6}}, {{3, 0}, {3, 1}, {3, 2}},
        {{3, 3}, {3, 4}, {3, 5}}, {{3, 6}, {4, 0}, {4, 1}},
        {{4, 2}, {4, 3}, {4, 4}}, {{4, 5}, {4, 6}, {5, 0}},
        {{5, 1}, {5, 2}, {5, 3}}, {{5, 4}, {5, 5}, {5, 6}},
        {{6, 0}, {6, 1}, {6, 2}}, {{6, 3}, {6, 4}, {6, 5}},
        {{6, 6}, {7, 0}, {7, 1}}, {{7, 2}, {7, 3}, {7, 4}},
        {{7, 5}, {7, 6}, {0, 0}},
    };

    if ((statex3 = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 18; i++) {
        for (j = 0; j < 3; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            buf[j].coeffs[32] = buf_index[i][j][1];
            buf[j].coeffs[33] = buf_index[i][j][0];
        }
        shake128x3_absorb_once(statex3, inN, 34);
        shake128x3_squeezeblocks(outN, POLY_UNIFORM_NBLOCKS, statex3);
        for (j = 0; j < 3; j++)
            ctr[j] = rej_uniform_vector(
                mat[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs,
                buf[j].coeffs);
        for (j = 0; j < 3; j++) {
            if (ctr[j] < N)
                keccakx3_get_oneway_state(statex3, &statex1, j);
            while (ctr[j] < N) {
                shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] +=
                    rej_uniform(mat[buf_index[i][j][0]]
                                        .vec[buf_index[i][j][1]]
                                        .coeffs +
                                    ctr[j],
                                N - ctr[j], buf[0].coeffs, SHAKE128_RATE);
            }
        }
    }
    free(statex3);
    if ((statex2 = malloc(sizeof(keccakx2_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 2; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, 32);
        buf[j].coeffs[32] = buf_index[i][j][1];
        buf[j].coeffs[33] = buf_index[i][j][0];
    }
    shake128x2_absorb_once(statex2, inN, 34);
    shake128x2_squeezeblocks(outN, POLY_UNIFORM_NBLOCKS, statex2);
    for (j = 0; j < 2; j++)
        ctr[j] = rej_uniform_vector(
            mat[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs,
            buf[j].coeffs);
    for (j = 0; j < 2; j++) {
        if (ctr[j] < N)
            keccakx2_get_oneway_state(statex2, &statex1, j);
        while (ctr[j] < N) {
            shake128_squeezeblocks(buf[0].coeffs, 1, &statex1);
            ctr[j] += rej_uniform(
                mat[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs +
                    ctr[j],
                N - ctr[j], buf[0].coeffs, SHAKE128_RATE);
        }
    }
    for (i = 0; i < K; i++)
        for (j = 0; j < L; j++)
            normal2ntt_order_8l_rvv(mat[i].vec[j].coeffs, qdata);
    free(statex2);
}
#endif

#if !defined(RV32IMV) && !defined(RV32IMBV)
void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES])
{
    unsigned int i, j;

    for (i = 0; i < K; ++i)
        for (j = 0; j < L; ++j)
            poly_uniform(&mat[i].vec[j], rho, (i << 8) + j);
}
#endif

#if DILITHIUM_MODE == 2 && (defined(RV32IMV) || defined(RV32IMBV))
// 2x 3-way + 1x 2-way sha3
void polyveclk_uniform_eta(polyvecl *v_l, polyveck *v_k,
                           const uint8_t seed[CRHBYTES], uint16_t nonce_l,
                           uint16_t nonce_k)
{
    unsigned int i, j, ctr[3];
    ALIGNED_UINT8(POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE) buf[3];
    keccakx3_state *statex3;
    keccakx2_state *statex2;
    keccak_state statex1;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint16_t buf_nonce[2 + 1][3] = {
        {nonce_l + 0, nonce_l + 1, nonce_l + 2},
        {nonce_l + 3, nonce_k + 0, nonce_k + 1},
        {nonce_k + 2, nonce_k + 3, 0},
    };
    int32_t *buf_polys[2 + 1][3] = {
        {v_l->vec[0].coeffs, v_l->vec[1].coeffs, v_l->vec[2].coeffs},
        {v_l->vec[3].coeffs, v_k->vec[0].coeffs, v_k->vec[1].coeffs},
        {v_k->vec[2].coeffs, v_k->vec[3].coeffs, 0},
    };

    if ((statex3 = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 2; i++) {
        for (j = 0; j < 3; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, CRHBYTES);
            buf[j].coeffs[CRHBYTES + 0] = buf_nonce[i][j];
            buf[j].coeffs[CRHBYTES + 1] = buf_nonce[i][j] >> 8;
        }
        shake256x3_absorb_once(statex3, inN, CRHBYTES + 2);
        shake256x3_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex3);
        for (j = 0; j < 3; j++)
            ctr[j] = rej_eta_vector(buf_polys[i][j], buf[j].coeffs);
        for (j = 0; j < 3; j++) {
            if (ctr[j] < N)
                keccakx3_get_oneway_state(statex3, &statex1, j);
            while (ctr[j] < N) {
                shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] += rej_eta(buf_polys[i][j] + ctr[j], N - ctr[j],
                                  buf[0].coeffs, SHAKE256_RATE);
            }
        }
    }
    free(statex3);
    if ((statex2 = malloc(sizeof(keccakx2_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 2; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[i][j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[i][j] >> 8;
    }
    shake256x2_absorb_once(statex2, inN, CRHBYTES + 2);
    shake256x2_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex2);
    for (j = 0; j < 2; j++)
        ctr[j] = rej_eta_vector(buf_polys[i][j], buf[j].coeffs);
    for (j = 0; j < 2; j++) {
        if (ctr[j] < N)
            keccakx2_get_oneway_state(statex2, &statex1, j);
        while (ctr[j] < N) {
            shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
            ctr[j] += rej_eta(buf_polys[i][j] + ctr[j], N - ctr[j],
                              buf[0].coeffs, SHAKE256_RATE);
        }
    }
    free(statex2);
}
#endif

#if DILITHIUM_MODE == 3 && (defined(RV32IMV) || defined(RV32IMBV))
// 3x 3-way + 1x 2-way sha3
void polyveclk_uniform_eta(polyvecl *v_l, polyveck *v_k,
                           const uint8_t seed[CRHBYTES], uint16_t nonce_l,
                           uint16_t nonce_k)
{
    unsigned int i, j, ctr[3];
    ALIGNED_UINT8(POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE) buf[3];
    keccakx3_state *statex3;
    keccakx2_state *statex2;
    keccak_state statex1;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint16_t buf_nonce[3 + 1][3] = {
        {nonce_l + 0, nonce_l + 1, nonce_l + 2},
        {nonce_l + 3, nonce_l + 4, nonce_k + 0},
        {nonce_k + 1, nonce_k + 2, nonce_k + 3},
        {nonce_k + 4, nonce_k + 5, 0},
    };
    int32_t *buf_polys[3 + 1][3] = {
        {v_l->vec[0].coeffs, v_l->vec[1].coeffs, v_l->vec[2].coeffs},
        {v_l->vec[3].coeffs, v_l->vec[4].coeffs, v_k->vec[0].coeffs},
        {v_k->vec[1].coeffs, v_k->vec[2].coeffs, v_k->vec[3].coeffs},
        {v_k->vec[4].coeffs, v_k->vec[5].coeffs, 0},
    };

    if ((statex3 = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 3; i++) {
        for (j = 0; j < 3; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, CRHBYTES);
            buf[j].coeffs[CRHBYTES + 0] = buf_nonce[i][j];
            buf[j].coeffs[CRHBYTES + 1] = buf_nonce[i][j] >> 8;
        }
        shake256x3_absorb_once(statex3, inN, CRHBYTES + 2);
        shake256x3_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex3);
        for (j = 0; j < 3; j++)
            ctr[j] = rej_eta_vector(buf_polys[i][j], buf[j].coeffs);
        for (j = 0; j < 3; j++) {
            if (ctr[j] < N)
                keccakx3_get_oneway_state(statex3, &statex1, j);
            while (ctr[j] < N) {
                shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] += rej_eta(buf_polys[i][j] + ctr[j], N - ctr[j],
                                  buf[0].coeffs, SHAKE256_RATE);
            }
        }
    }
    free(statex3);
    if ((statex2 = malloc(sizeof(keccakx2_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 2; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[i][j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[i][j] >> 8;
    }
    shake256x2_absorb_once(statex2, inN, CRHBYTES + 2);
    shake256x2_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex2);
    for (j = 0; j < 2; j++)
        ctr[j] = rej_eta_vector(buf_polys[i][j], buf[j].coeffs);
    for (j = 0; j < 2; j++) {
        if (ctr[j] < N)
            keccakx2_get_oneway_state(statex2, &statex1, j);
        while (ctr[j] < N) {
            shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
            ctr[j] += rej_eta(buf_polys[i][j] + ctr[j], N - ctr[j],
                              buf[0].coeffs, SHAKE256_RATE);
        }
    }
    free(statex2);
}
#endif

#if DILITHIUM_MODE == 5 && (defined(RV32IMV) || defined(RV32IMBV))
// 5x 3-way sha3
void polyveclk_uniform_eta(polyvecl *v_l, polyveck *v_k,
                           const uint8_t seed[CRHBYTES], uint16_t nonce_l,
                           uint16_t nonce_k)
{
    unsigned int i, j, ctr[3];
    ALIGNED_UINT8(POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE) buf[3];
    keccakx3_state *statex3;
    keccak_state statex1;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint16_t buf_nonce[5][3] = {
        {nonce_l + 0, nonce_l + 1, nonce_l + 2},
        {nonce_l + 3, nonce_l + 4, nonce_l + 5},
        {nonce_l + 6, nonce_k + 0, nonce_k + 1},
        {nonce_k + 2, nonce_k + 3, nonce_k + 4},
        {nonce_k + 5, nonce_k + 6, nonce_k + 7},
    };
    int32_t *buf_polys[5][3] = {
        {v_l->vec[0].coeffs, v_l->vec[1].coeffs, v_l->vec[2].coeffs},
        {v_l->vec[3].coeffs, v_l->vec[4].coeffs, v_l->vec[5].coeffs},
        {v_l->vec[6].coeffs, v_k->vec[0].coeffs, v_k->vec[1].coeffs},
        {v_k->vec[2].coeffs, v_k->vec[3].coeffs, v_k->vec[4].coeffs},
        {v_k->vec[5].coeffs, v_k->vec[6].coeffs, v_k->vec[7].coeffs},
    };

    if ((statex3 = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 5; i++) {
        for (j = 0; j < 3; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, CRHBYTES);
            buf[j].coeffs[CRHBYTES + 0] = buf_nonce[i][j];
            buf[j].coeffs[CRHBYTES + 1] = buf_nonce[i][j] >> 8;
        }
        shake256x3_absorb_once(statex3, inN, CRHBYTES + 2);
        shake256x3_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex3);
        for (j = 0; j < 3; j++)
            ctr[j] = rej_eta_vector(buf_polys[i][j], buf[j].coeffs);
        for (j = 0; j < 3; j++) {
            if (ctr[j] < N)
                keccakx3_get_oneway_state(statex3, &statex1, j);
            while (ctr[j] < N) {
                shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] += rej_eta(buf_polys[i][j] + ctr[j], N - ctr[j],
                                  buf[0].coeffs, SHAKE256_RATE);
            }
        }
    }
    free(statex3);
}
#endif

#if !defined(RV32IMV) && !defined(RV32IMBV)
void polyveclk_uniform_eta(polyvecl *v_l, polyveck *v_k,
                           const uint8_t seed[CRHBYTES], uint16_t nonce_l,
                           uint16_t nonce_k)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_uniform_eta(&v_l->vec[i], seed, nonce_l++);
    for (i = 0; i < K; ++i)
        poly_uniform_eta(&v_k->vec[i], seed, nonce_k++);
}
#endif

#if DILITHIUM_MODE == 2
#    if defined(RV32IMV)
// 2x 2-way sha3
void polyvecl_uniform_gamma1(polyvecl *v, const uint8_t seed[CRHBYTES],
                             uint16_t nonce)
{
    unsigned int j;
    ALIGNED_UINT8(POLY_UNIFORM_GAMMA1_NBLOCKS * SHAKE256_RATE) buf[2];
    keccakx2_state *statex2;
    const uint8_t *inN[2];
    uint8_t *outN[2];
    const uint16_t buf_nonce[4] = {
        L * nonce + 0,
        L * nonce + 1,
        L * nonce + 2,
        L * nonce + 3,
    };

    if ((statex2 = malloc(sizeof(keccakx2_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 2; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j] >> 8;
    }
    shake256x2_absorb_once(statex2, inN, CRHBYTES + 2);
    shake256x2_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex2);
    for (j = 0; j < 2; j++)
        polyz_unpack(&v->vec[j], buf[j].coeffs);
    for (j = 0; j < 2; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j + 2];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j + 2] >> 8;
    }
    shake256x2_absorb_once(statex2, inN, CRHBYTES + 2);
    shake256x2_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex2);
    for (j = 0; j < 2; j++)
        polyz_unpack(&v->vec[j + 2], buf[j].coeffs);
    free(statex2);
}
#    elif defined(RV32IMBV)
// 1x 4-way sha3
void polyvecl_uniform_gamma1(polyvecl *v, const uint8_t seed[CRHBYTES],
                             uint16_t nonce)
{
    unsigned int j;
    ALIGNED_UINT8(POLY_UNIFORM_GAMMA1_NBLOCKS * SHAKE256_RATE) buf[4];
    keccakx4_state *statex4;
    const uint8_t *inN[4];
    uint8_t *outN[4];
    const uint16_t buf_nonce[4] = {
        L * nonce + 0,
        L * nonce + 1,
        L * nonce + 2,
        L * nonce + 3,
    };

    if ((statex4 = malloc(sizeof(keccakx4_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 4; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j] >> 8;
    }
    shake256x4_absorb_once(statex4, inN, CRHBYTES + 2);
    shake256x4_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex4);
    for (j = 0; j < 4; j++)
        polyz_unpack(&v->vec[j], buf[j].coeffs);
    free(statex4);
}
#    endif
#endif

#if DILITHIUM_MODE == 3
#    if defined(RV32IMV) || defined(RV32IMBV)
// 1x 3-way + 1x 2-way sha3
void polyvecl_uniform_gamma1(polyvecl *v, const uint8_t seed[CRHBYTES],
                             uint16_t nonce)
{
    unsigned int j;
    ALIGNED_UINT8(POLY_UNIFORM_GAMMA1_NBLOCKS * SHAKE256_RATE) buf[3];
    keccakx3_state *statex3;
    keccakx2_state *statex2;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint16_t buf_nonce[3 + 2] = {
        L * nonce + 0, L * nonce + 1, L * nonce + 2,
        L * nonce + 3, L * nonce + 4,
    };

    if ((statex3 = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 3; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j] >> 8;
    }
    shake256x3_absorb_once(statex3, inN, CRHBYTES + 2);
    shake256x3_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex3);
    for (j = 0; j < 3; j++)
        polyz_unpack(&v->vec[j], buf[j].coeffs);
    free(statex3);
    if ((statex2 = malloc(sizeof(keccakx2_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 2; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j + 3];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j + 3] >> 8;
    }
    shake256x2_absorb_once(statex2, inN, CRHBYTES + 2);
    shake256x2_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex2);
    for (j = 0; j < 2; j++)
        polyz_unpack(&v->vec[j + 3], buf[j].coeffs);
    free(statex2);
}
#    endif
#endif

#if DILITHIUM_MODE == 5
#    if defined(RV32IMV)
// 1x 3-way + 2x 2-way sha3
void polyvecl_uniform_gamma1(polyvecl *v, const uint8_t seed[CRHBYTES],
                             uint16_t nonce)
{
    unsigned int j;
    ALIGNED_UINT8(POLY_UNIFORM_GAMMA1_NBLOCKS * SHAKE256_RATE) buf[3];
    keccakx2_state *statex2;
    keccakx3_state *statex3;
    const uint8_t *inN[3];
    uint8_t *outN[3];
    const uint16_t buf_nonce[4 + 3] = {
        L * nonce + 0, L * nonce + 1, L * nonce + 2, L * nonce + 3,
        L * nonce + 4, L * nonce + 5, L * nonce + 6,
    };

    if ((statex2 = malloc(sizeof(keccakx2_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 2; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j] >> 8;
    }
    shake256x2_absorb_once(statex2, inN, CRHBYTES + 2);
    shake256x2_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex2);
    for (j = 0; j < 2; j++)
        polyz_unpack(&v->vec[j], buf[j].coeffs);
    for (j = 0; j < 2; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j + 2];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j + 2] >> 8;
    }
    shake256x2_absorb_once(statex2, inN, CRHBYTES + 2);
    shake256x2_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex2);
    for (j = 0; j < 2; j++)
        polyz_unpack(&v->vec[j + 2], buf[j].coeffs);
    free(statex2);

    if ((statex3 = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 3; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[4 + j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[4 + j] >> 8;
    }
    shake256x3_absorb_once(statex3, inN, CRHBYTES + 2);
    shake256x3_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex3);
    for (j = 0; j < 3; j++)
        polyz_unpack(&v->vec[4 + j], buf[j].coeffs);
    free(statex3);
}
#    elif defined(RV32IMBV)
// 1x 3-way + 1x 4-way sha3
void polyvecl_uniform_gamma1(polyvecl *v, const uint8_t seed[CRHBYTES],
                             uint16_t nonce)
{
    unsigned int j;
    ALIGNED_UINT8(POLY_UNIFORM_GAMMA1_NBLOCKS * SHAKE256_RATE) buf[4];
    keccakx4_state *statex4;
    keccakx3_state *statex3;
    const uint8_t *inN[4];
    uint8_t *outN[4];
    const uint16_t buf_nonce[4 + 3] = {
        L * nonce + 0, L * nonce + 1, L * nonce + 2, L * nonce + 3,
        L * nonce + 4, L * nonce + 5, L * nonce + 6,
    };

    if ((statex4 = malloc(sizeof(keccakx4_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 4; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j] >> 8;
    }
    shake256x4_absorb_once(statex4, inN, CRHBYTES + 2);
    shake256x4_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex4);
    for (j = 0; j < 4; j++)
        polyz_unpack(&v->vec[j], buf[j].coeffs);
    free(statex4);
    if ((statex3 = malloc(sizeof(keccakx3_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 3; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[4 + j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[4 + j] >> 8;
    }
    shake256x3_absorb_once(statex3, inN, CRHBYTES + 2);
    shake256x3_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex3);
    for (j = 0; j < 3; j++)
        polyz_unpack(&v->vec[4 + j], buf[j].coeffs);
    free(statex3);
}
#    endif
#endif

#if !defined(RV32IMV) && !defined(RV32IMBV)
void polyvecl_uniform_gamma1(polyvecl *v, const uint8_t seed[CRHBYTES],
                             uint16_t nonce)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_uniform_gamma1(&v->vec[i], seed, L * nonce + i);
}
#endif

/**************************************************************/
/************ Vectors of polynomials of length L **************/
/**************************************************************/

void polyvecl_uniform_eta(polyvecl *v, const uint8_t seed[CRHBYTES],
                          uint16_t nonce)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_uniform_eta(&v->vec[i], seed, nonce++);
}

void polyvecl_reduce(polyvecl *v)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_reduce(&v->vec[i]);
}

/*************************************************
 * Name:        polyvecl_add
 *
 * Description: Add vectors of polynomials of length L.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyvecl *w: pointer to output vector
 *              - const polyvecl *u: pointer to first summand
 *              - const polyvecl *v: pointer to second summand
 **************************************************/
void polyvecl_add(polyvecl *w, const polyvecl *u, const polyvecl *v)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_add(&w->vec[i], &u->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyvecl_ntt
 *
 * Description: Forward NTT of all polynomials in vector of length L.
 *Output coefficients can be up to 16*Q larger than input coefficients.
 *
 * Arguments:   - polyvecl *v: pointer to input/output vector
 **************************************************/
void polyvecl_ntt(polyvecl *v)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_ntt(&v->vec[i]);
}

void polyvecl_intt(polyvecl *v)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_intt(&v->vec[i]);
}

/*************************************************
 * Name:        polyvecl_chknorm
 *
 * Description: Check infinity norm of polynomials in vector of length L.
 *              Assumes input polyvecl to be reduced by polyvecl_reduce().
 *
 * Arguments:   - const polyvecl *v: pointer to vector
 *              - int32_t B: norm bound
 *
 * Returns 0 if norm of all polynomials is strictly smaller than B <=
 *(Q-1)/8 and 1 otherwise.
 **************************************************/
int polyvecl_chknorm(const polyvecl *v, int32_t bound)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        if (poly_chknorm(&v->vec[i], bound))
            return 1;

    return 0;
}

/**************************************************************/
/************ Vectors of polynomials of length K **************/
/**************************************************************/

void polyveck_uniform_eta(polyveck *v, const uint8_t seed[CRHBYTES],
                          uint16_t nonce)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_uniform_eta(&v->vec[i], seed, nonce++);
}

/*************************************************
 * Name:        polyveck_reduce
 *
 * Description: Reduce coefficients of polynomials in vector of length K
 *              to representatives in [-6283009,6283007].
 *
 * Arguments:   - polyveck *v: pointer to input/output vector
 **************************************************/
void polyveck_reduce(polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_reduce(&v->vec[i]);
}

/*************************************************
 * Name:        polyveck_caddq
 *
 * Description: For all coefficients of polynomials in vector of length K
 *              add Q if coefficient is negative.
 *
 * Arguments:   - polyveck *v: pointer to input/output vector
 **************************************************/
void polyveck_caddq(polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_caddq(&v->vec[i]);
}

/*************************************************
 * Name:        polyveck_add
 *
 * Description: Add vectors of polynomials of length K.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyveck *w: pointer to output vector
 *              - const polyveck *u: pointer to first summand
 *              - const polyveck *v: pointer to second summand
 **************************************************/
void polyveck_add(polyveck *w, const polyveck *u, const polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_add(&w->vec[i], &u->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyveck_sub
 *
 * Description: Subtract vectors of polynomials of length K.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyveck *w: pointer to output vector
 *              - const polyveck *u: pointer to first input vector
 *              - const polyveck *v: pointer to second input vector to be
 *                                   subtracted from first input vector
 **************************************************/
void polyveck_sub(polyveck *w, const polyveck *u, const polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_sub(&w->vec[i], &u->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyveck_shiftl
 *
 * Description: Multiply vector of polynomials of Length K by 2^D without
 *modular reduction. Assumes input coefficients to be less than 2^{31-D}.
 *
 * Arguments:   - polyveck *v: pointer to input/output vector
 **************************************************/
void polyveck_shiftl(polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_shiftl(&v->vec[i]);
}

/*************************************************
 * Name:        polyveck_ntt
 *
 * Description: Forward NTT of all polynomials in vector of length K.
 *Output coefficients can be up to 16*Q larger than input coefficients.
 *
 * Arguments:   - polyveck *v: pointer to input/output vector
 **************************************************/
void polyveck_ntt(polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_ntt(&v->vec[i]);
}

/*************************************************
 * Name:        polyveck_intt
 *
 * Description: Inverse NTT and multiplication by 2^{32} of polynomials
 *              in vector of length K. Input coefficients need to be less
 *              than 2*Q.
 *
 * Arguments:   - polyveck *v: pointer to input/output vector
 **************************************************/
void polyveck_intt(polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_intt(&v->vec[i]);
}

/*************************************************
 * Name:        polyveck_chknorm
 *
 * Description: Check infinity norm of polynomials in vector of length K.
 *              Assumes input polyveck to be reduced by polyveck_reduce().
 *
 * Arguments:   - const polyveck *v: pointer to vector
 *              - int32_t B: norm bound
 *
 * Returns 0 if norm of all polynomials are strictly smaller than B <=
 *(Q-1)/8 and 1 otherwise.
 **************************************************/
int polyveck_chknorm(const polyveck *v, int32_t bound)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        if (poly_chknorm(&v->vec[i], bound))
            return 1;

    return 0;
}

/*************************************************
 * Name:        polyveck_power2round
 *
 * Description: For all coefficients a of polynomials in vector of length
 *K, compute a0, a1 such that a mod^+ Q = a1*2^D + a0 with -2^{D-1} < a0 <=
 *2^{D-1}. Assumes coefficients to be standard representatives.
 *
 * Arguments:   - polyveck *v1: pointer to output vector of polynomials
 *with coefficients a1
 *              - polyveck *v0: pointer to output vector of polynomials
 *with coefficients a0
 *              - const polyveck *v: pointer to input vector
 **************************************************/
void polyveck_power2round(polyveck *v1, polyveck *v0, const polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_power2round(&v1->vec[i], &v0->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyveck_decompose
 *
 * Description: For all coefficients a of polynomials in vector of length
 *K, compute high and low bits a0, a1 such a mod^+ Q = a1*ALPHA + a0 with
 *-ALPHA/2 < a0 <= ALPHA/2 except a1 = (Q-1)/ALPHA where we set a1 = 0 and
 *-ALPHA/2 <= a0 = a mod Q - Q < 0. Assumes coefficients to be standard
 *representatives.
 *
 * Arguments:   - polyveck *v1: pointer to output vector of polynomials
 *with coefficients a1
 *              - polyveck *v0: pointer to output vector of polynomials
 *with coefficients a0
 *              - const polyveck *v: pointer to input vector
 **************************************************/
void polyveck_decompose(polyveck *v1, polyveck *v0, const polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_decompose(&v1->vec[i], &v0->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyveck_make_hint
 *
 * Description: Compute hint vector.
 *
 * Arguments:   - polyveck *h: pointer to output vector
 *              - const polyveck *v0: pointer to low part of input vector
 *              - const polyveck *v1: pointer to high part of input vector
 *
 * Returns number of 1 bits.
 **************************************************/
unsigned int polyveck_make_hint(polyveck *h, const polyveck *v0,
                                const polyveck *v1)
{
    unsigned int i, s = 0;

    for (i = 0; i < K; ++i)
        s += poly_make_hint(&h->vec[i], &v0->vec[i], &v1->vec[i]);

    return s;
}

/*************************************************
 * Name:        polyveck_use_hint
 *
 * Description: Use hint vector to correct the high bits of input vector.
 *
 * Arguments:   - polyveck *w: pointer to output vector of polynomials with
 *                             corrected high bits
 *              - const polyveck *u: pointer to input vector
 *              - const polyveck *h: pointer to input hint vector
 **************************************************/
void polyveck_use_hint(polyveck *w, const polyveck *u, const polyveck *h)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_use_hint(&w->vec[i], &u->vec[i], &h->vec[i]);
}

void polyveck_pack_w1(uint8_t r[K * POLYW1_PACKEDBYTES],
                      const polyveck *w1)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        polyw1_pack(&r[i * POLYW1_PACKEDBYTES], &w1->vec[i]);
}

void polyvec_matrix_pointwise(polyveck *t, const polyvecl mat[K],
                              const polyvecl *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        polyvecl_pointwise_acc(&t->vec[i], &mat[i], v);
}

#if defined(VECTOR128)

void polyvecl_pointwise_poly(polyvecl *r, const poly *a, const polyvecl *v)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_pointwise(&r->vec[i], a, &v->vec[i]);
}

void polyveck_pointwise_poly(polyveck *r, const poly *a, const polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_pointwise(&r->vec[i], a, &v->vec[i]);
}

void polyvecl_pointwise_acc(poly *w, const polyvecl *u, const polyvecl *v)
{
    unsigned int i;

    poly_pointwise(w, &u->vec[0], &v->vec[0]);
    for (i = 1; i < L; ++i) {
        poly_pointwise_acc(w, &u->vec[i], &v->vec[i]);
    }
}

#elif defined(RV32)

void polyvecl_pointwise_poly(polyvecl *r, const poly *a, const polyvecl *v)
{
    polyvec_basemul_poly_8l_rv32im(r->vec[0].coeffs, a->coeffs,
                                   v->vec[0].coeffs, L);
}

void polyveck_pointwise_poly(polyveck *r, const poly *a, const polyveck *v)
{
    polyvec_basemul_poly_8l_rv32im(r->vec[0].coeffs, a->coeffs,
                                   v->vec[0].coeffs, K);
}

void polyvecl_pointwise_acc(poly *w, const polyvecl *u, const polyvecl *v)
{
    unsigned int i;
    poly_double w_double;

    poly_basemul_init(&w_double, &u->vec[0], &v->vec[0]);
    for (i = 1; i < L - 1; ++i)
        poly_basemul_acc(&w_double, &u->vec[i], &v->vec[i]);
    poly_basemul_acc_end(w, &u->vec[i], &v->vec[i], &w_double);
}

#else

void polyvecl_pointwise_acc(poly *w, const polyvecl *u, const polyvecl *v)
{
    unsigned int i;
    poly t;

    poly_pointwise(w, &u->vec[0], &v->vec[0]);
    for (i = 1; i < L; ++i) {
        poly_pointwise(&t, &u->vec[i], &v->vec[i]);
        poly_add(w, w, &t);
    }
}

#endif
