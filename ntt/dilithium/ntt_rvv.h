#ifndef DILITHIUM_NTT_RVV_H
#define DILITHIUM_NTT_RVV_H

#include <stdint.h>

extern const int32_t qdata[1296];
extern void ntt_8l_rvv(int32_t *r, const int32_t *qdata);
extern void intt_8l_rvv(int32_t *r, const int32_t *qdata);
extern void poly_basemul_8l_rvv(int32_t *r, const int32_t *a,
                                const int32_t *b);
extern void poly_basemul_acc_8l_rvv(int32_t *r, const int32_t *a,
                                    const int32_t *b);
extern void ntt2normal_order_8l_rvv(int32_t *r, const int32_t *qdata);
extern void normal2ntt_order_8l_rvv(int32_t *r, const int32_t *qdata);
extern void poly_reduce_rvv(int32_t *r);

#endif