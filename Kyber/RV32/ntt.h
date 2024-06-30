#ifndef NTT_H
#define NTT_H

#include <stdint.h>

#include "params.h"

void ntt(int16_t poly[256]);
void intt(int16_t poly[256]);
void basemul(int16_t r[2], const int16_t a[2], const int16_t b[2],
             int16_t zeta);

#if defined(VECTOR128)
#    include "ntt_rvv.h"
#elif defined(RV32)
#    include "ntt_rv32im.h"
#else
extern const int16_t zetas[128];
#endif

#endif
