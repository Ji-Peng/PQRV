#ifndef NTT_H
#define NTT_H

#include <stdint.h>

#include "params.h"

void ntt(int32_t a[N]);
void intt(int32_t a[N]);

#if defined(VECTOR128)
#    include "ntt_rvv.h"
#elif defined(RV32)
#    include "ntt_rv32im.h"
#endif

#endif
