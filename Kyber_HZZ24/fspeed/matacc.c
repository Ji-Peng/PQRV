#include "matacc.h"

#include "ntt.h"
#include "poly.h"
#include "polyvec.h"
#include "randombytes.h"
#include "symmetric.h"

extern void doublebasemul_asm_cache_16_32(int32_t r_tmp_ptr[4],
                                          int16_t bprimeptr[2], int16_t bptr[4],
                                          int16_t cptr[4], int32_t zeta);
extern void doublebasemul_asm_acc_cache_32_32(int32_t r_tmp_ptr[4],
                                              int16_t bprimeptr[2],
                                              int16_t bptr[4], int16_t cptr[4],
                                              int32_t zeta);
extern void doublebasemul_asm_acc_cache_32_16(int16_t r[4],
                                              int32_t r_tmp_ptr[4],
                                              int16_t bprimeptr[2],
                                              int16_t b_ptr[4],
                                              int16_t c_ptr[4], int32_t zetas);

extern void doublebasemul_asm_opt_16_32(int32_t r_tmp_ptr[4],
                                        int16_t bprimeptr[2], int16_t bptr[4],
                                        int16_t cptr[4]);
extern void doublebasemul_asm_acc_opt_32_32(int32_t r_tmp_ptr[4],
                                            int16_t bprimeptr[2],
                                            int16_t bptr[4], int16_t cptr[4]);
extern void doublebasemul_asm_acc_opt_32_16(int16_t r[4], int32_t r_tmp_ptr[4],
                                            int16_t bprimeptr[2],
                                            int16_t bptr[4], int16_t cptr[4]);

void matacc_cache_32(int16_t *r, int32_t *r_tmp, int16_t *b, int16_t c[4],
                     unsigned char buf[XOF_BLOCKBYTES + 2],
                     const uint32_t zetas[64], xof_state *state,
                     int16_t *bprimeptr, int type)
{
    unsigned int buflen, off;
    unsigned int ctr, pos, k, l;
    uint16_t val0, val1;
    buflen = XOF_BLOCKBYTES;
    ctr = pos = 0;
    k = 0;
    while (ctr < KYBER_N / 4) {
        val0 = ((buf[pos + 0] >> 0) | ((uint16_t)buf[pos + 1] << 8)) & 0xFFF;
        val1 = ((buf[pos + 1] >> 4) | ((uint16_t)buf[pos + 2] << 4)) & 0xFFF;
        pos += 3;

        if (val0 < KYBER_Q) {
            c[k++] = (int16_t)val0;
            if (k == 4) {
                if (type == 0) {
                    doublebasemul_asm_cache_16_32(&r_tmp[4 * ctr],
                                                  &bprimeptr[2 * ctr],
                                                  &b[4 * ctr], c, zetas[ctr]);
                } else if (type == 1) {
                    doublebasemul_asm_acc_cache_32_32(
                        &r_tmp[4 * ctr], &bprimeptr[2 * ctr], &b[4 * ctr], c,
                        zetas[ctr]);
                } else {
                    doublebasemul_asm_acc_cache_32_16(
                        &r[4 * ctr], &r_tmp[4 * ctr], &bprimeptr[2 * ctr],
                        &b[4 * ctr], c, zetas[ctr]);
                }
                ctr++;
                k = 0;
            }
        }

        if (val1 < KYBER_Q && ctr < KYBER_N / 4) {
            c[k++] = (int16_t)val1;
            if (k == 4) {
                if (type == 0) {
                    doublebasemul_asm_cache_16_32(&r_tmp[4 * ctr],
                                                  &bprimeptr[2 * ctr],
                                                  &b[4 * ctr], c, zetas[ctr]);
                } else if (type == 1) {
                    doublebasemul_asm_acc_cache_32_32(
                        &r_tmp[4 * ctr], &bprimeptr[2 * ctr], &b[4 * ctr], c,
                        zetas[ctr]);
                } else {
                    doublebasemul_asm_acc_cache_32_16(
                        &r[4 * ctr], &r_tmp[4 * ctr], &bprimeptr[2 * ctr],
                        &b[4 * ctr], c, zetas[ctr]);
                }
                ctr++;
                k = 0;
            }
        }

        if (pos + 3 > buflen && ctr < KYBER_N / 4) {
            off = buflen % 3;
            for (l = 0; l < off; l++)
                buf[l] = buf[buflen - off + l];
            xof_squeezeblocks(buf + off, 1, state);
            buflen = off + XOF_BLOCKBYTES;
            pos = 0;
        }
    }
}

void matacc_opt_32(int16_t *r, int32_t *r_tmp, int16_t *b, int16_t c[4],
                   unsigned char buf[XOF_BLOCKBYTES + 2], xof_state *state,
                   int16_t *bprimeptr, int type)
{
    unsigned int buflen, off;
    unsigned int ctr, pos, k, l;
    uint16_t val0, val1;
    buflen = XOF_BLOCKBYTES;
    ctr = pos = 0;
    k = 0;
    while (ctr < KYBER_N / 4) {
        val0 = ((buf[pos + 0] >> 0) | ((uint16_t)buf[pos + 1] << 8)) & 0xFFF;
        val1 = ((buf[pos + 1] >> 4) | ((uint16_t)buf[pos + 2] << 4)) & 0xFFF;
        pos += 3;

        if (val0 < KYBER_Q) {
            c[k++] = (int16_t)val0;
            if (k == 4) {
                if (type == 0) {
                    doublebasemul_asm_opt_16_32(
                        &r_tmp[4 * ctr], &bprimeptr[2 * ctr], &b[4 * ctr], c);
                } else if (type == 1) {
                    doublebasemul_asm_acc_opt_32_32(
                        &r_tmp[4 * ctr], &bprimeptr[2 * ctr], &b[4 * ctr], c);
                } else {
                    doublebasemul_asm_acc_opt_32_16(
                        &r[4 * ctr], &r_tmp[4 * ctr], &bprimeptr[2 * ctr],
                        &b[4 * ctr], c);
                }
                ctr++;

                k = 0;
            }
        }

        if (val1 < KYBER_Q && ctr < KYBER_N / 4) {
            c[k++] = (int16_t)val1;
            if (k == 4) {
                if (type == 0) {
                    doublebasemul_asm_opt_16_32(
                        &r_tmp[4 * ctr], &bprimeptr[2 * ctr], &b[4 * ctr], c);
                } else if (type == 1) {
                    doublebasemul_asm_acc_opt_32_32(
                        &r_tmp[4 * ctr], &bprimeptr[2 * ctr], &b[4 * ctr], c);
                } else {
                    doublebasemul_asm_acc_opt_32_16(
                        &r[4 * ctr], &r_tmp[4 * ctr], &bprimeptr[2 * ctr],
                        &b[4 * ctr], c);
                }
                ctr++;
                k = 0;
            }
        }

        if (pos + 3 > buflen && ctr < KYBER_N / 4) {
            off = buflen % 3;
            for (l = 0; l < off; l++)
                buf[l] = buf[buflen - off + l];
            xof_squeezeblocks(buf + off, 1, state);
            buflen = off + XOF_BLOCKBYTES;
            pos = 0;
        }
    }
}

/*************************************************
 * Name:        matacc_cache32
 *
 * Description: Multiplies a row of A or A^T, generated on-the-fly,
 *              with a vector of polynomials and accumulates into the result.
 *              Using asymmetric multiplication and better accumulation.
 *
 * Arguments:   - poly *r:                    pointer to output polynomial to
 *accumulate in
 *              - const polyvec *b:           pointer to input vector of
 *polynomials to multiply with
 *              - polyvec_half *b_prime:           pointer to output vector of
 *polynomials to store b multiplied by zetas
 *              - unsigned char i:            byte to indicate the index <
 *KYBER_K of the row of A or A^T
 *              - const unsigned char *seed:  pointer to the public seed used to
 *generate A
 *              - int transposed:             boolean indicatin whether A or A^T
 *is generated
 **************************************************/
void matacc_cache32(poly *r, int32_t *r_tmp, polyvec *b, polyvec_half *b_prime,
                    unsigned char i, const unsigned char *seed, int transposed)
{
    unsigned char buf[XOF_BLOCKBYTES + 2];
    xof_state state;
    int16_t c[4];
    // int32_t r_tmp[KYBER_N]; // stores intermediate accumulated values to save
    // reductions
    int j = 0;

    // 16-32

    if (transposed)
        xof_absorb(&state, seed, i, j);
    else
        xof_absorb(&state, seed, j, i);

    xof_squeezeblocks(buf, 1, &state);

    matacc_cache_32(r->coeffs, r_tmp, b->vec[j].coeffs, c, buf, zetas, &state,
                    b_prime->vec[j].coeffs, 0);
    xof_ctx_release(&state);
    // 32-32 KYBER_K - 2 times
    for (j = 1; j < KYBER_K - 1; j++) {
        if (transposed)
            xof_absorb(&state, seed, i, j);
        else
            xof_absorb(&state, seed, j, i);

        xof_squeezeblocks(buf, 1, &state);
        matacc_cache_32(r->coeffs, r_tmp, b->vec[j].coeffs, c, buf, zetas,
                        &state, b_prime->vec[j].coeffs, 1);
        xof_ctx_release(&state);
    }

    // 32-16

    if (transposed)
        xof_absorb(&state, seed, i, j);
    else
        xof_absorb(&state, seed, j, i);

    xof_squeezeblocks(buf, 1, &state);
    matacc_cache_32(r->coeffs, r_tmp, b->vec[j].coeffs, c, buf, zetas, &state,
                    b_prime->vec[j].coeffs, 2);
    xof_ctx_release(&state);
}

/*************************************************
 * Name:        matacc_opt32
 *
 * Description: Multiplies a row of A or A^T, generated on-the-fly,
 *              with a vector of polynomials and accumulates into the result.
 *              Using asymmetric multiplication and better accumulation.
 *
 * Arguments:   - poly *r:                    pointer to output polynomial to
 *accumulate in
 *              - const polyvec *b:           pointer to input vector of
 *polynomials to multiply with
 *              - const polyvec_half *b_prime:     pointer to input vector of
 *polynomials to store b multiplied by zetas
 *              - unsigned char i:            byte to indicate the index <
 *KYBER_K of the row of A or A^T
 *              - const unsigned char *seed:  pointer to the public seed used to
 *generate A
 *              - int transposed:             boolean indicatin whether A or A^T
 *is generated
 **************************************************/
void matacc_opt32(poly *r, int32_t *r_tmp, polyvec *b, polyvec_half *b_prime,
                  unsigned char i, const unsigned char *seed, int transposed)
{
    unsigned char buf[XOF_BLOCKBYTES + 2];
    xof_state state;
    int16_t c[4];
    // int32_t r_tmp[KYBER_N]; // stores intermediate accumulated values to save
    // reductions
    int j = 0;

    // 16-32

    if (transposed)
        xof_absorb(&state, seed, i, j);
    else
        xof_absorb(&state, seed, j, i);

    xof_squeezeblocks(buf, 1, &state);

    matacc_opt_32(r->coeffs, r_tmp, b->vec[j].coeffs, c, buf, &state,
                  b_prime->vec[j].coeffs, 0);
    xof_ctx_release(&state);
    // 32-32 KYBER_K - 2 times
    for (j = 1; j < KYBER_K - 1; j++) {
        if (transposed)
            xof_absorb(&state, seed, i, j);
        else
            xof_absorb(&state, seed, j, i);

        xof_squeezeblocks(buf, 1, &state);

        matacc_opt_32(r->coeffs, r_tmp, b->vec[j].coeffs, c, buf, &state,
                      b_prime->vec[j].coeffs, 1);
        xof_ctx_release(&state);
    }

    // 32-16

    if (transposed)
        xof_absorb(&state, seed, i, j);
    else
        xof_absorb(&state, seed, j, i);

    xof_squeezeblocks(buf, 1, &state);

    matacc_opt_32(r->coeffs, r_tmp, b->vec[j].coeffs, c, buf, &state,
                  b_prime->vec[j].coeffs, 2);
    xof_ctx_release(&state);
}
