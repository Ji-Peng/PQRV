#ifndef DILITHIUM_NTT_RV32_H
#define DILITHIUM_NTT_RV32_H

#include <stdint.h>

extern void poly_reduce_rv32im(int32_t in[256]);

// 8-layer NTT implementation
extern void ntt_8l_rv32im(int32_t *r, int32_t *zetas);
extern void intt_8l_rv32im(int32_t *r, int32_t *zetas);
extern void poly_basemul_8l_init_rv32im(int64_t r[256],
                                        const int32_t a[256],
                                        const int32_t b[256]);
extern void poly_basemul_8l_acc_rv32im(int64_t r[256],
                                       const int32_t a[256],
                                       const int32_t b[256]);
extern void poly_basemul_8l_acc_end_rv32im(int32_t r[256],
                                           const int32_t a[256],
                                           const int32_t b[256],
                                           int64_t r_double[256]);
extern void poly_basemul_8l_rv32im(int32_t r[256], const int32_t a[256],
                                   const int32_t b[256]);
extern void polyvec_basemul_poly_8l_rv32im(int32_t *r_vec,
                                           const int32_t *a_poly,
                                           const int32_t *b_vec,
                                           int32_t veclen);

// 6-layer NTT implementation
extern void ntt_6l_rv32im(int32_t *r, int32_t *zetas);
extern void intt_6l_rv32im(int32_t *r, int32_t *zetas);
extern void poly_basemul_6l_cache_init_rv32im(int32_t *r,
                                                  const int32_t *a,
                                                  const int32_t *b,
                                                  int32_t *b_cache,
                                                  int32_t *zetas);
extern void poly_basemul_6l_cached_rv32im(int32_t *r, const int32_t *a,
                                             const int32_t *b,
                                             int32_t *b_cache);

#endif