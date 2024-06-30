#ifndef POLY_H
#define POLY_H

#include <stdint.h>

#include "params.h"

/*
 * Elements of R_q = Z_q[X]/(X^n + 1). Represents polynomial
 * coeffs[0] + X*coeffs[1] + X^2*coeffs[2] + ... + X^{n-1}*coeffs[n-1]
 */
typedef struct {
    int16_t coeffs[KYBER_N];
} poly;

void poly_compress(uint8_t r[KYBER_POLYCOMPRESSEDBYTES], const poly *a);
void poly_decompress(poly *r, const uint8_t a[KYBER_POLYCOMPRESSEDBYTES]);
void poly_tobytes(uint8_t r[KYBER_POLYBYTES], const poly *a);
void poly_frombytes(poly *r, const uint8_t a[KYBER_POLYBYTES]);
void poly_frommsg(poly *r, const uint8_t msg[KYBER_INDCPA_MSGBYTES]);
void poly_tomsg(uint8_t msg[KYBER_INDCPA_MSGBYTES], const poly *r);
void poly_getnoise_eta1(poly *r, const uint8_t seed[KYBER_SYMBYTES],
                        uint8_t nonce);
void poly_getnoise_eta2(poly *r, const uint8_t seed[KYBER_SYMBYTES],
                        uint8_t nonce);
void poly_ntt(poly *r);
void poly_intt(poly *r);
void poly_reduce(poly *r);
void poly_add(poly *r, const poly *a, const poly *b);
void poly_sub(poly *r, const poly *a, const poly *b);

#if defined(VECTOR128)

typedef struct {
    int16_t coeffs[KYBER_N >> 1];
} poly_half;

void poly_basemul(poly *r, const poly *a, const poly *b);
void poly_basemul_acc(poly *r, const poly *a, const poly *b);
void poly_basemul_cache_init(poly *r, const poly *a, const poly *b,
                             poly_half *b_cache);
void poly_basemul_acc_cache_init(poly *r, const poly *a, const poly *b,
                                 poly_half *b_cache);
void poly_basemul_cached(poly *r, const poly *a, const poly *b,
                         poly_half *b_cache);
void poly_basemul_acc_cached(poly *r, const poly *a, const poly *b,
                             poly_half *b_cache);
void poly_tomont(poly *r);

#elif defined(RV64)

typedef struct {
    int16_t coeffs[KYBER_N >> 1];
} poly_half;

typedef struct {
    int32_t coeffs[KYBER_N];
} poly_double;

void poly_basemul_cache_init(poly_double *r, const poly *a, const poly *b,
                             poly_half *b_cache);
void poly_basemul_acc_cache_init(poly_double *r, const poly *a,
                                 const poly *b, poly_half *b_cache);
void poly_basemul_acc_cache_init_end(poly *r, const poly *a, const poly *b,
                                     poly_half *b_cache,
                                     poly_double *r_double);
void poly_basemul_acc_cached(poly_double *r, const poly *a, const poly *b,
                             poly_half *b_cache);
void poly_basemul_acc_cache_end(poly *r, const poly *a, const poly *b,
                                poly_half *b_cache, poly_double *r_double);
void poly_basemul_acc(poly_double *r, const poly *a, const poly *b);
void poly_basemul_acc_end(poly *r, const poly *a, const poly *b,
                          poly_double *r_double);
void poly_toplant(poly *r);

#else

void poly_basemul(poly *r, const poly *a, const poly *b);
void poly_tomont(poly *r);

#endif

#endif
