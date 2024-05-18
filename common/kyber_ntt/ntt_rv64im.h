#ifndef NTT_RV64_H
#define NTT_RV64_H

#include <stdint.h>

extern void ntt_rv64im(int16_t *, uint64_t *);
extern void invntt_rv64im(int16_t *, uint64_t *);
extern void poly_barrett_rdc_rv64im(int16_t *r);
extern void poly_toplant_rv64im(int16_t *r);

extern void poly_basemul_acc_rv64im(int32_t *r, const int16_t *a,
                                    const int16_t *b, uint64_t *zetas);
extern void poly_basemul_acc_end_rv64im(int16_t *r, const int16_t *a,
                                        const int16_t *b, uint64_t *zetas,
                                        int32_t *r_double);
extern void poly_basemul_cache_init_rv64im(int32_t *r, const int16_t *a,
                                           const int16_t *b, int16_t *b_cache,
                                           uint64_t *zetas);
extern void poly_basemul_acc_cache_init_rv64im(int32_t *r, const int16_t *a,
                                               const int16_t *b,
                                               int16_t *b_cache,
                                               uint64_t *zetas);
extern void poly_basemul_acc_cache_init_end_rv64im(int16_t *r, const int16_t *a,
                                                   const int16_t *b,
                                                   int16_t *b_cache,
                                                   uint64_t *zetas,
                                                   int32_t *r_double);
extern void poly_basemul_acc_cached_rv64im(int32_t *r, const int16_t *a,
                                           const int16_t *b, int16_t *b_cache);
extern void poly_basemul_acc_cache_end_rv64im(int16_t *r, const int16_t *a,
                                              const int16_t *b,
                                              int16_t *b_cache,
                                              int32_t *r_double);

#endif