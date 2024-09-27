#ifndef POLY_H
#define POLY_H

#include <stdint.h>

#include "params.h"

typedef struct {
    int32_t coeffs[N];
} poly;

unsigned int rej_uniform(int32_t *a, unsigned int len, const uint8_t *buf,
                         unsigned int buflen);
unsigned int rej_eta(int32_t *a, unsigned int len, const uint8_t *buf,
                     unsigned int buflen);

#if defined(VECTOR128)
unsigned int rej_uniform_vector(int32_t *a, const uint8_t *buf);
unsigned int rej_eta_vector(int32_t *a, const uint8_t *buf);
#endif

void poly_reduce(poly *a);
void poly_caddq(poly *a);
void poly_add(poly *c, const poly *a, const poly *b);
void poly_sub(poly *c, const poly *a, const poly *b);
void poly_shiftl(poly *a);
void poly_power2round(poly *a1, poly *a0, const poly *a);
void poly_decompose(poly *a1, poly *a0, const poly *a);
unsigned int poly_make_hint(poly *h, const poly *a0, const poly *a1);
void poly_use_hint(poly *b, const poly *a, const poly *h);
int poly_chknorm(const poly *a, int32_t B);
void poly_uniform(poly *a, const uint8_t seed[SEEDBYTES], uint16_t nonce);
void poly_uniform_eta(poly *a, const uint8_t seed[CRHBYTES],
                      uint16_t nonce);
void poly_uniform_gamma1(poly *a, const uint8_t seed[CRHBYTES],
                         uint16_t nonce);
void poly_challenge(poly *c, const uint8_t seed[SEEDBYTES]);
void polyeta_pack(uint8_t *r, const poly *a);
void polyeta_unpack(poly *r, const uint8_t *a);
void polyt1_pack(uint8_t *r, const poly *a);
void polyt1_unpack(poly *r, const uint8_t *a);
void polyt0_pack(uint8_t *r, const poly *a);
void polyt0_unpack(poly *r, const uint8_t *a);
void polyz_pack(uint8_t *r, const poly *a);
void polyz_unpack(poly *r, const uint8_t *a);
void polyw1_pack(uint8_t *r, const poly *a);
void poly_ntt(poly *a);
void poly_intt(poly *a);
void poly_pointwise(poly *c, const poly *a, const poly *b);

#if defined(VECTOR128)

void poly_pointwise_acc(poly *c, const poly *a, const poly *b);

#elif defined(RV64)

typedef struct {
    int32_t coeffs[(N >> 2) * 3];
} poly_cache;

typedef struct {
    int64_t coeffs[N];
} poly_double;

// 8-layer NTT
void poly_basemul_init(poly_double *r, const poly *a, const poly *b);
void poly_basemul_acc(poly_double *r, const poly *a, const poly *b);
void poly_basemul_acc_end(poly *r, const poly *a, const poly *b,
                          poly_double *r_double);

// todo
// 6-layer NTT
void poly_ntt_6l(poly *a);
void poly_intt_6l(poly *a);
void poly_basemul_6l_cache_init(poly *r, const poly *a, const poly *b,
                                poly_cache *b_cache);
void poly_basemul_6l_cached(poly *r, const poly *a, const poly *b,
                            poly_cache *b_cache);

#endif

#endif
