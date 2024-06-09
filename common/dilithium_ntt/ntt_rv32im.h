#ifndef DILITHIUM_NTT_RV32_H
#define DILITHIUM_NTT_RV32_H

#include <stdint.h>

extern void ntt_6l_rv32im(int32_t *r, int32_t *zetas);
extern void intt_6l_rv32im(int32_t *r, int32_t *zetas);
extern void ntt_8l_rv32im(int32_t *r, int32_t *zetas);
extern void intt_8l_rv32im(int32_t *r, int32_t *zetas);
// todo: needed?
extern void poly_barrett_rdc_rv32im(int32_t *r);
extern void poly_tomont_rv32im(int32_t *r);

extern void poly_basemul_6l_init_rv32im(int64_t *r, const int32_t *a,
                                        const int32_t *b, int32_t *zetas);
extern void poly_basemul_6l_acc_rv32im(int64_t *r, const int32_t *a,
                                       const int32_t *b, int32_t *zetas);
extern void poly_basemul_6l_acc_end_rv32im(int32_t *r, const int32_t *a,
                                           const int32_t *b,
                                           int32_t *zetas,
                                           int64_t *r_double);
extern void poly_basemul_6l_cache_init_rv32im(int64_t *r, const int32_t *a,
                                              const int32_t *b,
                                              int32_t *b_cache,
                                              int32_t *zetas);
extern void poly_basemul_6l_acc_cache_init_rv32im(int64_t *r,
                                                  const int32_t *a,
                                                  const int32_t *b,
                                                  int32_t *b_cache,
                                                  int32_t *zetas);
extern void poly_basemul_6l_acc_cache_init_end_rv32im(
    int32_t *r, const int32_t *a, const int32_t *b, int32_t *b_cache,
    int32_t *zetas, int64_t *r_double);
extern void poly_basemul_6l_cache_init_end_rv32im(int32_t *r,
                                                  const int32_t *a,
                                                  const int32_t *b,
                                                  int32_t *b_cache,
                                                  int32_t *zetas);
extern void poly_basemul_6l_cached_rv32im(int64_t *r, const int32_t *a,
                                          const int32_t *b,
                                          int32_t *b_cache);
extern void poly_basemul_6l_acc_cached_rv32im(int64_t *r, const int32_t *a,
                                              const int32_t *b,
                                              int32_t *b_cache);
extern void poly_basemul_6l_acc_cache_end_rv32im(int32_t *r,
                                                 const int32_t *a,
                                                 const int32_t *b,
                                                 int32_t *b_cache,
                                                 int64_t *r_double);
extern void poly_basemul_6l_cache_end_rv32im(int32_t *r, const int32_t *a,
                                             const int32_t *b,
                                             int32_t *b_cache);

#endif