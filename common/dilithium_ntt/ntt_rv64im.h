#ifndef DILITHIUM_NTT_RV64_H
#define DILITHIUM_NTT_RV64_H

#include <stdint.h>

extern void ntt_rv64im(int32_t *r, int64_t *zetas);
extern void invntt_rv64im(int32_t *r, int64_t *zetas);
extern void poly_plantard_rdc_rv64im(int32_t *r);
extern void poly_toplant_rv64im(int32_t *r);

extern void poly_basemul_acc_rv64im(int64_t *r, const int32_t *a,
                                    const int32_t *b, int64_t *zetas);
extern void poly_basemul_acc_end_rv64im(int32_t *r, const int32_t *a,
                                        const int32_t *b, int64_t *zetas,
                                        int64_t *r_double);
extern void poly_basemul_cache_init_rv64im(int32_t *r, const int32_t *a,
                                           const int32_t *b,
                                           int32_t *b_cache,
                                           int64_t *zetas);
extern void poly_basemul_acc_cache_init_rv64im(int64_t *r,
                                               const int32_t *a,
                                               const int32_t *b,
                                               int32_t *b_cache,
                                               int64_t *zetas);
extern void poly_basemul_acc_cache_init_end_rv64im(
    int32_t *r, const int32_t *a, const int32_t *b, int32_t *b_cache,
    int64_t *zetas, int64_t *r_double);
extern void poly_basemul_acc_cached_rv64im(int64_t *r, const int32_t *a,
                                           const int32_t *b,
                                           int32_t *b_cache);
extern void poly_basemul_acc_cache_end_rv64im(int32_t *r, const int32_t *a,
                                              const int32_t *b,
                                              int32_t *b_cache,
                                              int64_t *r_double);

#endif