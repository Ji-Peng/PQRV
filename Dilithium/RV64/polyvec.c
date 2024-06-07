#include "polyvec.h"

#include <stdint.h>
#include <string.h>

#include "fips202x.h"
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

#if DILITHIUM_MODE == 2
#    if defined(RV64IMV) || defined(RV64IMBV)
// 2x 8-way sha3
void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES])
{
    unsigned int i, j, ctr[8];
    unsigned int buflen = POLY_UNIFORM_NBLOCKS * SHAKE128_RATE;
    ALIGNED_UINT8(POLY_UNIFORM_NBLOCKS * SHAKE128_RATE) buf[8];
    keccakx8_state *statex8;
    keccak_state statex1;
    const uint8_t *inN[8];
    uint8_t *outN[8];
    const uint8_t *seed = rho;
    const uint8_t buf_index[2][8][2] = {
        {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 0}, {1, 1}, {1, 2}, {1, 3}},
        {{2, 0}, {2, 1}, {2, 2}, {2, 3}, {3, 0}, {3, 1}, {3, 2}, {3, 3}},
    };

    if ((statex8 = malloc(sizeof(keccakx8_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 2; i++) {
        for (j = 0; j < 8; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            buf[j].coeffs[32] = buf_index[i][j][1];
            buf[j].coeffs[33] = buf_index[i][j][0];
        }
        shake128x8_absorb_once(statex8, inN, 34);
        shake128x8_squeezeblocks(outN, POLY_UNIFORM_NBLOCKS, statex8);
        for (j = 0; j < 8; j++)
            ctr[j] = rej_uniform(
                mat[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs, N,
                buf[j].coeffs, buflen);
        for (j = 0; j < 8; j++) {
            if (ctr[j] < N)
                keccakx8_get_oneway_state(statex8, &statex1, j);
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
    free(statex8);
}
#    endif
#endif

#if DILITHIUM_MODE == 3
#    if defined(RV64IMV)
// 5x 6-way sha3
void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES])
{
    unsigned int i, j, ctr[6];
    unsigned int buflen = POLY_UNIFORM_NBLOCKS * SHAKE128_RATE;
    ALIGNED_UINT8(POLY_UNIFORM_NBLOCKS * SHAKE128_RATE) buf[6];
    keccakx6_state *statex6;
    keccak_state statex1;
    const uint8_t *inN[6];
    uint8_t *outN[6];
    const uint8_t *seed = rho;
    const uint8_t buf_index[5][6][2] = {
        {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}, {1, 0}},
        {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {2, 0}, {2, 1}},
        {{2, 2}, {2, 3}, {2, 4}, {3, 0}, {3, 1}, {3, 2}},
        {{3, 3}, {3, 4}, {4, 0}, {4, 1}, {4, 2}, {4, 3}},
        {{4, 4}, {5, 0}, {5, 1}, {5, 2}, {5, 3}, {5, 4}},
    };

    if ((statex6 = malloc(sizeof(keccakx6_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 5; i++) {
        for (j = 0; j < 6; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            buf[j].coeffs[32] = buf_index[i][j][1];
            buf[j].coeffs[33] = buf_index[i][j][0];
        }
        shake128x6_absorb_once(statex6, inN, 34);
        shake128x6_squeezeblocks(outN, POLY_UNIFORM_NBLOCKS, statex6);
        for (j = 0; j < 6; j++)
            ctr[j] = rej_uniform(
                mat[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs, N,
                buf[j].coeffs, buflen);
        for (j = 0; j < 6; j++) {
            if (ctr[j] < N)
                keccakx6_get_oneway_state(statex6, &statex1, j);
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
    free(statex6);
}
#    elif defined(RV64IMBV)
// 3x 10-way sha3
void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES])
{
    unsigned int i, j, ctr[10];
    unsigned int buflen = POLY_UNIFORM_NBLOCKS * SHAKE128_RATE;
    ALIGNED_UINT8(POLY_UNIFORM_NBLOCKS * SHAKE128_RATE) buf[10];
    keccakx10_state *statex10;
    keccak_state statex1;
    const uint8_t *inN[10];
    uint8_t *outN[10];
    const uint8_t *seed = rho;
    // clang-format off
    const uint8_t buf_index[3][10][2] = {
        {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}, {1, 0}, {1, 1}, {1, 2}, {1, 3}, {1, 4}},
        {{2, 0}, {2, 1}, {2, 2}, {2, 3}, {2, 4}, {3, 0}, {3, 1}, {3, 2}, {3, 3}, {3, 4}},
        {{4, 0}, {4, 1}, {4, 2}, {4, 3}, {4, 4}, {5, 0}, {5, 1}, {5, 2}, {5, 3}, {5, 4}},
    };
    // clang-format off

    if ((statex10 = malloc(sizeof(keccakx10_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 3; i++) {
        for (j = 0; j < 10; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            buf[j].coeffs[32] = buf_index[i][j][1];
            buf[j].coeffs[33] = buf_index[i][j][0];
        }
        shake128x10_absorb_once(statex10, inN, 34);
        shake128x10_squeezeblocks(outN, POLY_UNIFORM_NBLOCKS, statex10);
        for (j = 0; j < 10; j++)
            ctr[j] = rej_uniform(
                mat[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs, N,
                buf[j].coeffs, buflen);
        for (j = 0; j < 10; j++) {
            if (ctr[j] < N)
                keccakx10_get_oneway_state(statex10, &statex1, j);
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
    free(statex10);
}
#    endif
#endif

#if DILITHIUM_MODE == 5
#    if defined(RV64IMV)
// 7x 8-way sha3
void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES])
{
    unsigned int i, j, ctr[8];
    unsigned int buflen = POLY_UNIFORM_NBLOCKS * SHAKE128_RATE;
    ALIGNED_UINT8(POLY_UNIFORM_NBLOCKS * SHAKE128_RATE) buf[8];
    keccakx8_state *statex8;
    keccak_state statex1;
    const uint8_t *inN[8];
    uint8_t *outN[8];
    const uint8_t *seed = rho;
    const uint8_t buf_index[7][8][2] = {
        {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}, {0, 5}, {0, 6}, {1, 0}},
        {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {2, 0}, {2, 1}},
        {{2, 2}, {2, 3}, {2, 4}, {2, 5}, {2, 6}, {3, 0}, {3, 1}, {3, 2}},
        {{3, 3}, {3, 4}, {3, 5}, {3, 6}, {4, 0}, {4, 1}, {4, 2}, {4, 3}},
        {{4, 4}, {4, 5}, {4, 6}, {5, 0}, {5, 1}, {5, 2}, {5, 3}, {5, 4}},
        {{5, 5}, {5, 6}, {6, 0}, {6, 1}, {6, 2}, {6, 3}, {6, 4}, {6, 5}},
        {{6, 6}, {7, 0}, {7, 1}, {7, 2}, {7, 3}, {7, 4}, {7, 5}, {7, 6}},
    };

    if ((statex8 = malloc(sizeof(keccakx8_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 7; i++) {
        for (j = 0; j < 8; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            buf[j].coeffs[32] = buf_index[i][j][1];
            buf[j].coeffs[33] = buf_index[i][j][0];
        }
        shake128x8_absorb_once(statex8, inN, 34);
        shake128x8_squeezeblocks(outN, POLY_UNIFORM_NBLOCKS, statex8);
        for (j = 0; j < 8; j++)
            ctr[j] = rej_uniform(
                mat[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs, N,
                buf[j].coeffs, buflen);
        for (j = 0; j < 8; j++) {
            if (ctr[j] < N)
                keccakx8_get_oneway_state(statex8, &statex1, j);
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
    free(statex8);
}
#    elif defined(RV64IMBV)
// 4x 14-way sha3
void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES])
{
    unsigned int i, j, ctr[14];
    unsigned int buflen = POLY_UNIFORM_NBLOCKS * SHAKE128_RATE;
    ALIGNED_UINT8(POLY_UNIFORM_NBLOCKS * SHAKE128_RATE) buf[14];
    keccakx14_state *statex14;
    keccak_state statex1;
    const uint8_t *inN[14];
    uint8_t *outN[14];
    const uint8_t *seed = rho;
    // clang-format off
    const uint8_t buf_index[4][14][2] = {
        {{0, 0},{0, 1},{0, 2},{0, 3},{0, 4},{0, 5},{0, 6},
         {1, 0},{1, 1},{1, 2},{1, 3},{1, 4},{1, 5},{1, 6}},
        {{2, 0},{2, 1},{2, 2},{2, 3},{2, 4},{2, 5},{2, 6},
         {3, 0},{3, 1},{3, 2},{3, 3},{3, 4},{3, 5},{3, 6}},
        {{4, 0},{4, 1},{4, 2},{4, 3},{4, 4},{4, 5},{4, 6},
         {5, 0},{5, 1},{5, 2},{5, 3},{5, 4},{5, 5},{5, 6}},
        {{6, 0},{6, 1},{6, 2},{6, 3},{6, 4},{6, 5},{6, 6},
         {7, 0},{7, 1},{7, 2},{7, 3},{7, 4},{7, 5},{7, 6}},
    };
    // clang-format on

    if ((statex14 = malloc(sizeof(keccakx14_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 14; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, 32);
            buf[j].coeffs[32] = buf_index[i][j][1];
            buf[j].coeffs[33] = buf_index[i][j][0];
        }
        shake128x14_absorb_once(statex14, inN, 34);
        shake128x14_squeezeblocks(outN, POLY_UNIFORM_NBLOCKS, statex14);
        for (j = 0; j < 14; j++)
            ctr[j] = rej_uniform(
                mat[buf_index[i][j][0]].vec[buf_index[i][j][1]].coeffs, N,
                buf[j].coeffs, buflen);
        for (j = 0; j < 14; j++) {
            if (ctr[j] < N)
                keccakx14_get_oneway_state(statex14, &statex1, j);
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
    free(statex14);
}
#    endif
#endif

#if !defined(RV64IMV) && !defined(RV64IMBV)
void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES])
{
    unsigned int i, j;

    for (i = 0; i < K; ++i)
        for (j = 0; j < L; ++j)
            poly_uniform(&mat[i].vec[j], rho, (i << 8) + j);
}
#endif

#if DILITHIUM_MODE == 2
#    if defined(RV64IMV) || defined(RV64IMBV)
// 1x 8-way sha3
void polyveclk_uniform_eta(polyvecl *v_l, polyveck *v_k,
                           const uint8_t seed[CRHBYTES], uint16_t nonce_l,
                           uint16_t nonce_k)
{
    unsigned int i, j, ctr[8];
    unsigned int buflen = POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE;
    ALIGNED_UINT8(POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE) buf[8];
    keccakx8_state *statex8;
    keccak_state statex1;
    const uint8_t *inN[8];
    uint8_t *outN[8];
    const uint16_t buf_nonce[8] = {
        nonce_l, nonce_l + 1, nonce_l + 2, nonce_l + 3,
        nonce_k, nonce_k + 1, nonce_k + 2, nonce_k + 3,
    };
    int32_t *buf_polys[8] = {
        v_l->vec[0].coeffs, v_l->vec[1].coeffs, v_l->vec[2].coeffs,
        v_l->vec[3].coeffs, v_k->vec[0].coeffs, v_k->vec[1].coeffs,
        v_k->vec[2].coeffs, v_k->vec[3].coeffs,
    };

    if ((statex8 = malloc(sizeof(keccakx8_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < (K + L) >> 2; i++) {
        for (j = 0; j < 8; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, CRHBYTES);
            buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j];
            buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j] >> 8;
        }
        shake256x8_absorb_once(statex8, inN, CRHBYTES + 2);
        shake256x8_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex8);
        for (j = 0; j < 8; j++)
            ctr[j] = rej_eta(buf_polys[j], N, buf[j].coeffs, buflen);
        for (j = 0; j < 8; j++) {
            if (ctr[j] < N)
                keccakx8_get_oneway_state(statex8, &statex1, j);
            while (ctr[j] < N) {
                shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] += rej_eta(buf_polys[j] + ctr[j], N - ctr[j],
                                  buf[0].coeffs, SHAKE256_RATE);
            }
        }
    }
    free(statex8);
}
#    endif
#endif

#if DILITHIUM_MODE == 3
#    if defined(RV64IMV)
// 1x 6-way + 1x 5-way sha3
void polyveclk_uniform_eta(polyvecl *v_l, polyveck *v_k,
                           const uint8_t seed[CRHBYTES], uint16_t nonce_l,
                           uint16_t nonce_k)
{
    unsigned int i, j, ctr[6];
    unsigned int buflen = POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE;
    ALIGNED_UINT8(POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE) buf[6];
    keccakx6_state *statex6;
    keccakx5_state *statex5;
    keccak_state statex1;
    const uint8_t *inN[6];
    uint8_t *outN[6];
    const uint16_t buf_nonce[2][6] = {
        {nonce_l + 0, nonce_l + 1, nonce_l + 2, nonce_l + 3, nonce_l + 4,
         nonce_k + 0},
        {nonce_k + 1, nonce_k + 2, nonce_k + 3, nonce_k + 4, nonce_k + 5,
         0},
    };
    int32_t *buf_polys[2][6] = {
        {v_l->vec[0].coeffs, v_l->vec[1].coeffs, v_l->vec[2].coeffs,
         v_l->vec[3].coeffs, v_l->vec[4].coeffs, v_k->vec[0].coeffs},
        {v_k->vec[1].coeffs, v_k->vec[2].coeffs, v_k->vec[3].coeffs,
         v_k->vec[4].coeffs, v_k->vec[5].coeffs, 0},
    };

    if ((statex6 = malloc(sizeof(keccakx6_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (i = 0; i < 1; i++) {
        for (j = 0; j < 6; j++) {
            outN[j] = buf[j].coeffs;
            inN[j] = buf[j].coeffs;
            memcpy(buf[j].coeffs, seed, CRHBYTES);
            buf[j].coeffs[CRHBYTES + 0] = buf_nonce[i][j];
            buf[j].coeffs[CRHBYTES + 1] = buf_nonce[i][j] >> 8;
        }
        shake256x6_absorb_once(statex6, inN, CRHBYTES + 2);
        shake256x6_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex6);
        for (j = 0; j < 6; j++)
            ctr[j] = rej_eta(buf_polys[i][j], N, buf[j].coeffs, buflen);
        for (j = 0; j < 6; j++) {
            if (ctr[j] < N)
                keccakx6_get_oneway_state(statex6, &statex1, j);
            while (ctr[j] < N) {
                shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
                ctr[j] += rej_eta(buf_polys[i][j] + ctr[j], N - ctr[j],
                                  buf[0].coeffs, SHAKE256_RATE);
            }
        }
    }
    free(statex6);
    if ((statex5 = malloc(sizeof(keccakx5_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 5; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[i][j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[i][j] >> 8;
    }
    shake256x5_absorb_once(statex5, inN, CRHBYTES + 2);
    shake256x5_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex5);
    for (j = 0; j < 5; j++)
        ctr[j] = rej_eta(buf_polys[i][j], N, buf[j].coeffs, buflen);
    for (j = 0; j < 5; j++) {
        if (ctr[j] < N)
            keccakx5_get_oneway_state(statex5, &statex1, j);
        while (ctr[j] < N) {
            shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
            ctr[j] += rej_eta(buf_polys[i][j] + ctr[j], N - ctr[j],
                              buf[0].coeffs, SHAKE256_RATE);
        }
    }
    free(statex5);
}
#    elif defined(RV64IMBV)
// 1x 10-way + 1x 1-way sha3
void polyveclk_uniform_eta(polyvecl *v_l, polyveck *v_k,
                           const uint8_t seed[CRHBYTES], uint16_t nonce_l,
                           uint16_t nonce_k)
{
    unsigned int j, ctr[10];
    unsigned int buflen = POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE;
    ALIGNED_UINT8(POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE) buf[10];
    keccakx10_state *statex10;
    keccak_state statex1;
    const uint8_t *inN[10];
    uint8_t *outN[10];
    const uint16_t buf_nonce[10] = {
        nonce_l + 0, nonce_l + 1, nonce_l + 2, nonce_l + 3, nonce_l + 4,
        nonce_k + 0, nonce_k + 1, nonce_k + 2, nonce_k + 3, nonce_k + 4,
    };
    int32_t *buf_polys[10] = {
        v_l->vec[0].coeffs, v_l->vec[1].coeffs, v_l->vec[2].coeffs,
        v_l->vec[3].coeffs, v_l->vec[4].coeffs, v_k->vec[0].coeffs,
        v_k->vec[1].coeffs, v_k->vec[2].coeffs, v_k->vec[3].coeffs,
        v_k->vec[4].coeffs,
    };

    if ((statex10 = malloc(sizeof(keccakx10_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 10; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j] >> 8;
    }
    shake256x10_absorb_once(statex10, inN, CRHBYTES + 2);
    shake256x10_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex10);
    for (j = 0; j < 10; j++)
        ctr[j] = rej_eta(buf_polys[j], N, buf[j].coeffs, buflen);
    for (j = 0; j < 10; j++) {
        if (ctr[j] < N)
            keccakx10_get_oneway_state(statex10, &statex1, j);
        while (ctr[j] < N) {
            shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
            ctr[j] += rej_eta(buf_polys[j] + ctr[j], N - ctr[j],
                              buf[0].coeffs, SHAKE256_RATE);
        }
    }
    free(statex10);
    memcpy(buf[0].coeffs, seed, CRHBYTES);
    buf[0].coeffs[CRHBYTES + 0] = (nonce_k + 5);
    buf[0].coeffs[CRHBYTES + 1] = (nonce_k + 5) >> 8;
    shake256_absorb_once(&statex1, buf[0].coeffs, CRHBYTES + 2);
    shake256_squeezeblocks(buf[0].coeffs, POLY_UNIFORM_ETA_NBLOCKS,
                           &statex1);
    ctr[0] = rej_eta(v_k->vec[5].coeffs, N, buf[0].coeffs, buflen);
    while (ctr[0] < N) {
        shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
        ctr[0] += rej_eta(v_k->vec[5].coeffs + ctr[0], N - ctr[0],
                          buf[0].coeffs, SHAKE256_RATE);
    }
}
#    endif
#endif

#if DILITHIUM_MODE == 5
#    if defined(RV64IMV)
// 1x 10-way + 1x 5-way sha3
void polyveclk_uniform_eta(polyvecl *v_l, polyveck *v_k,
                           const uint8_t seed[CRHBYTES], uint16_t nonce_l,
                           uint16_t nonce_k)
{
    unsigned int j, ctr[10];
    unsigned int buflen = POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE;
    ALIGNED_UINT8(POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE) buf[10];
    keccakx10_state *statex10;
    keccakx5_state *statex5;
    keccak_state statex1;
    const uint8_t *inN[10];
    uint8_t *outN[10];
    const uint16_t buf_nonce[10] = {
        nonce_l + 0, nonce_l + 1, nonce_l + 2, nonce_l + 3, nonce_l + 4,
        nonce_l + 5, nonce_l + 6, nonce_k + 0, nonce_k + 1, nonce_k + 2,

    };
    int32_t *buf_polys[10] = {
        v_l->vec[0].coeffs, v_l->vec[1].coeffs, v_l->vec[2].coeffs,
        v_l->vec[3].coeffs, v_l->vec[4].coeffs, v_l->vec[5].coeffs,
        v_l->vec[6].coeffs, v_k->vec[0].coeffs, v_k->vec[1].coeffs,
        v_k->vec[2].coeffs,
    };
    const uint16_t buf_nonce_x5[5] = {
        nonce_k + 3, nonce_k + 4, nonce_k + 5, nonce_k + 6, nonce_k + 7,
    };
    int32_t *buf_polys_x5[5] = {
        v_k->vec[3].coeffs, v_k->vec[4].coeffs, v_k->vec[5].coeffs,
        v_k->vec[6].coeffs, v_k->vec[7].coeffs,
    };

    if ((statex10 = malloc(sizeof(keccakx10_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 10; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j] >> 8;
    }
    shake256x10_absorb_once(statex10, inN, CRHBYTES + 2);
    shake256x10_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex10);
    for (j = 0; j < 10; j++)
        ctr[j] = rej_eta(buf_polys[j], N, buf[j].coeffs, buflen);
    for (j = 0; j < 10; j++) {
        if (ctr[j] < N)
            keccakx10_get_oneway_state(statex10, &statex1, j);
        while (ctr[j] < N) {
            shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
            ctr[j] += rej_eta(buf_polys[j] + ctr[j], N - ctr[j],
                              buf[0].coeffs, SHAKE256_RATE);
        }
    }
    free(statex10);
    if ((statex5 = malloc(sizeof(keccakx5_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 5; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce_x5[j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce_x5[j] >> 8;
    }
    shake256x5_absorb_once(statex5, inN, CRHBYTES + 2);
    shake256x5_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex5);
    for (j = 0; j < 5; j++)
        ctr[j] = rej_eta(buf_polys_x5[j], N, buf[j].coeffs, buflen);
    for (j = 0; j < 5; j++) {
        if (ctr[j] < N)
            keccakx5_get_oneway_state(statex5, &statex1, j);
        while (ctr[j] < N) {
            shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
            ctr[j] += rej_eta(buf_polys_x5[j] + ctr[j], N - ctr[j],
                              buf[0].coeffs, SHAKE256_RATE);
        }
    }
    free(statex5);
}
#    elif defined(RV64IMBV)
// 1x 14-way + 1x 1-way sha3
void polyveclk_uniform_eta(polyvecl *v_l, polyveck *v_k,
                           const uint8_t seed[CRHBYTES], uint16_t nonce_l,
                           uint16_t nonce_k)
{
    unsigned int j, ctr[14];
    unsigned int buflen = POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE;
    ALIGNED_UINT8(POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE) buf[14];
    keccakx14_state *statex14;
    keccak_state statex1;
    const uint8_t *inN[14];
    uint8_t *outN[14];
    const uint16_t buf_nonce[14] = {
        nonce_l + 0, nonce_l + 1, nonce_l + 2, nonce_l + 3, nonce_l + 4,
        nonce_l + 5, nonce_l + 6, nonce_k + 0, nonce_k + 1, nonce_k + 2,
        nonce_k + 3, nonce_k + 4, nonce_k + 5, nonce_k + 6,
    };
    int32_t *buf_polys[14] = {
        v_l->vec[0].coeffs, v_l->vec[1].coeffs, v_l->vec[2].coeffs,
        v_l->vec[3].coeffs, v_l->vec[4].coeffs, v_l->vec[5].coeffs,
        v_l->vec[6].coeffs, v_k->vec[0].coeffs, v_k->vec[1].coeffs,
        v_k->vec[2].coeffs, v_k->vec[3].coeffs, v_k->vec[4].coeffs,
        v_k->vec[5].coeffs, v_k->vec[6].coeffs,
    };

    if ((statex14 = malloc(sizeof(keccakx14_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 14; j++) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j] >> 8;
    }
    shake256x14_absorb_once(statex14, inN, CRHBYTES + 2);
    shake256x14_squeezeblocks(outN, POLY_UNIFORM_ETA_NBLOCKS, statex14);
    for (j = 0; j < 14; j++)
        ctr[j] = rej_eta(buf_polys[j], N, buf[j].coeffs, buflen);
    for (j = 0; j < 14; j++) {
        if (ctr[j] < N)
            keccakx14_get_oneway_state(statex14, &statex1, j);
        while (ctr[j] < N) {
            shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
            ctr[j] += rej_eta(buf_polys[j] + ctr[j], N - ctr[j],
                              buf[0].coeffs, SHAKE256_RATE);
        }
    }
    free(statex14);
    memcpy(buf[0].coeffs, seed, CRHBYTES);
    buf[0].coeffs[CRHBYTES + 0] = (nonce_k + 7);
    buf[0].coeffs[CRHBYTES + 1] = (nonce_k + 7) >> 8;
    shake256_absorb_once(&statex1, buf[0].coeffs, CRHBYTES + 2);
    shake256_squeezeblocks(buf[0].coeffs, POLY_UNIFORM_ETA_NBLOCKS,
                           &statex1);
    ctr[0] = rej_eta(v_k->vec[7].coeffs, N, buf[0].coeffs, buflen);
    while (ctr[0] < N) {
        shake256_squeezeblocks(buf[0].coeffs, 1, &statex1);
        ctr[0] += rej_eta(v_k->vec[7].coeffs + ctr[0], N - ctr[0],
                          buf[0].coeffs, SHAKE256_RATE);
    }
}
#    endif
#endif

#if !defined(RV64IMV) && !defined(RV64IMBV)
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
#    if defined(RV64IMV)
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
#    if defined(RV64IMV)
// 1x 5-way sha3
void polyvecl_uniform_gamma1(polyvecl *v, const uint8_t seed[CRHBYTES],
                             uint16_t nonce)
{
    unsigned int j;
    ALIGNED_UINT8(POLY_UNIFORM_GAMMA1_NBLOCKS * SHAKE256_RATE) buf[5];
    keccakx5_state *statex5;
    const uint8_t *inN[5];
    uint8_t *outN[5];
    const uint16_t buf_nonce[5] = {
        L * nonce + 0, L * nonce + 1, L * nonce + 2,
        L * nonce + 3, L * nonce + 4,
    };

    if ((statex5 = malloc(sizeof(keccakx5_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 5; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j] >> 8;
    }
    shake256x5_absorb_once(statex5, inN, CRHBYTES + 2);
    shake256x5_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex5);
    for (j = 0; j < 5; j++)
        polyz_unpack(&v->vec[j], buf[j].coeffs);
    free(statex5);
}
#    endif
#endif

#if DILITHIUM_MODE == 5
#    if defined(RV64IMV)
// 1x 6-way + 1x 1-way sha3
void polyvecl_uniform_gamma1(polyvecl *v, const uint8_t seed[CRHBYTES],
                             uint16_t nonce)
{
    unsigned int j;
    ALIGNED_UINT8(POLY_UNIFORM_GAMMA1_NBLOCKS * SHAKE256_RATE) buf[6];
    keccakx6_state *statex6;
    keccak_state statex1;
    const uint8_t *inN[6];
    uint8_t *outN[6];
    const uint16_t buf_nonce[6] = {
        L * nonce + 0, L * nonce + 1, L * nonce + 2,
        L * nonce + 3, L * nonce + 4, L * nonce + 5,
    };

    if ((statex6 = malloc(sizeof(keccakx6_state))) == NULL) {
        LOG("%s", "malloc failed\n");
        return;
    }
    for (j = 0; j < 6; ++j) {
        outN[j] = buf[j].coeffs;
        inN[j] = buf[j].coeffs;
        memcpy(buf[j].coeffs, seed, CRHBYTES);
        buf[j].coeffs[CRHBYTES + 0] = buf_nonce[j];
        buf[j].coeffs[CRHBYTES + 1] = buf_nonce[j] >> 8;
    }
    shake256x6_absorb_once(statex6, inN, CRHBYTES + 2);
    shake256x6_squeezeblocks(outN, POLY_UNIFORM_GAMMA1_NBLOCKS, statex6);
    for (j = 0; j < 6; j++)
        polyz_unpack(&v->vec[j], buf[j].coeffs);
    free(statex6);
    memcpy(buf[0].coeffs, seed, CRHBYTES);
    buf[0].coeffs[CRHBYTES + 0] = (L * nonce + 6);
    buf[0].coeffs[CRHBYTES + 1] = (L * nonce + 6) >> 8;
    shake256_absorb_once(&statex1, buf[0].coeffs, CRHBYTES + 2);
    shake256_squeezeblocks(buf[0].coeffs, POLY_UNIFORM_GAMMA1_NBLOCKS,
                           &statex1);
    polyz_unpack(&v->vec[6], buf[0].coeffs);
}
#    endif
#endif

#if (!defined(RV64IMV) && !defined(RV64IMBV)) || defined(RV64IMBV)
void polyvecl_uniform_gamma1(polyvecl *v, const uint8_t seed[CRHBYTES],
                             uint16_t nonce)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_uniform_gamma1(&v->vec[i], seed, L * nonce + i);
}
#endif

void polyvec_matrix_pointwise(polyveck *t,
                                         const polyvecl mat[K],
                                         const polyvecl *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        polyvecl_pointwise_acc(&t->vec[i], &mat[i], v);
}

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

void polyvecl_invntt(polyvecl *v)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_invntt(&v->vec[i]);
}

void polyvecl_pointwise_poly(polyvecl *r, const poly *a,
                                        const polyvecl *v)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_pointwise(&r->vec[i], a, &v->vec[i]);
}

/*************************************************
 * Name:        polyvecl_pointwise_acc
 *
 * Description: Pointwise multiply vectors of polynomials of length L,
 *multiply resulting vector by 2^{-32} and add (accumulate) polynomials in
 *it. Input/output vectors are in NTT domain representation.
 *
 * Arguments:   - poly *w: output polynomial
 *              - const polyvecl *u: pointer to first input vector
 *              - const polyvecl *v: pointer to second input vector
 **************************************************/
void polyvecl_pointwise_acc(poly *w, const polyvecl *u,
                                       const polyvecl *v)
{
    unsigned int i;
    poly t;

    poly_pointwise(w, &u->vec[0], &v->vec[0]);
    for (i = 1; i < L; ++i) {
        poly_pointwise(&t, &u->vec[i], &v->vec[i]);
        poly_add(w, w, &t);
    }
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
 * Name:        polyveck_invntt
 *
 * Description: Inverse NTT and multiplication by 2^{32} of polynomials
 *              in vector of length K. Input coefficients need to be less
 *              than 2*Q.
 *
 * Arguments:   - polyveck *v: pointer to input/output vector
 **************************************************/
void polyveck_invntt(polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_invntt(&v->vec[i]);
}

void polyveck_pointwise_poly(polyveck *r, const poly *a,
                                        const polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_pointwise(&r->vec[i], a, &v->vec[i]);
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
