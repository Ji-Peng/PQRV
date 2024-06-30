#ifndef KYBER_NTT_RV32_H
#define KYBER_NTT_RV32_H

#include <stdint.h>

extern void ntt_rv32im(int16_t *, uint32_t *);
extern void intt_rv32im(int16_t *, uint32_t *);
extern void poly_plantard_rdc_rv32im(int16_t *r);
extern void poly_toplant_rv32im(int16_t *r);

extern void poly_basemul_acc_rv32im(int32_t *r, const int16_t *a,
                                    const int16_t *b, uint32_t *zetas);
extern void poly_basemul_acc_end_rv32im(int16_t *r, const int16_t *a,
                                        const int16_t *b, uint32_t *zetas,
                                        int32_t *r_double);
extern void poly_basemul_cache_init_rv32im(int32_t *r, const int16_t *a,
                                           const int16_t *b, int16_t *b_cache,
                                           uint32_t *zetas);
extern void poly_basemul_acc_cache_init_rv32im(int32_t *r, const int16_t *a,
                                               const int16_t *b,
                                               int16_t *b_cache,
                                               uint32_t *zetas);
extern void poly_basemul_acc_cache_init_end_rv32im(int16_t *r, const int16_t *a,
                                                   const int16_t *b,
                                                   int16_t *b_cache,
                                                   uint32_t *zetas,
                                                   int32_t *r_double);
extern void poly_basemul_acc_cached_rv32im(int32_t *r, const int16_t *a,
                                           const int16_t *b, int16_t *b_cache);
extern void poly_basemul_acc_cache_end_rv32im(int16_t *r, const int16_t *a,
                                              const int16_t *b,
                                              int16_t *b_cache,
                                              int32_t *r_double);

#endif