#ifndef DILITHIUM_NTT_RV64_H
#define DILITHIUM_NTT_RV64_H

#include <stdint.h>

extern void poly_reduce_rv64im(int32_t in[256]);

// 8-layer NTT implementation
extern void ntt_8l_rv64im(int32_t *r, const int64_t *zetas);
extern void intt_8l_rv64im(int32_t *r, const int64_t *zetas);
extern void poly_basemul_8l_init_rv64im(int64_t r[256],
                                        const int32_t a[256],
                                        const int32_t b[256]);
extern void poly_basemul_8l_acc_rv64im(int64_t r[256],
                                       const int32_t a[256],
                                       const int32_t b[256]);
extern void poly_basemul_8l_acc_end_rv64im(int32_t r[256],
                                           const int32_t a[256],
                                           const int32_t b[256],
                                           int64_t r_double[256]);
extern void poly_basemul_8l_rv64im(int32_t r[256], const int32_t a[256],
                                   const int32_t b[256]);

#endif