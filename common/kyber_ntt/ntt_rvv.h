#ifndef NTT_RVV_H
#define NTT_RVV_H

#include <stdint.h>

extern const int16_t qdata[1472];
extern void ntt_rvv(int16_t *r, const int16_t *table);
extern void intt_rvv(int16_t *r, const int16_t *table);
extern void poly_basemul_rvv(int16_t *r, const int16_t *a, const int16_t *b,
                             const int16_t *table);
extern void poly_reduce_rvv(int16_t *r);
extern void poly_tomont_rvv(int16_t *r);

extern void ntt2normal_order(int16_t *r, const int16_t *a,
                             const int16_t *table);
extern void normal2ntt_order(int16_t *r, const int16_t *a,
                             const int16_t *table);

#endif