#ifndef NTT_H
#define NTT_H

#include <stdint.h>

#include "ntt_rv64im.h"
#include "params.h"

void ntt(int32_t a[N]);
void intt(int32_t a[N]);

#if defined(VECTOR128)
#    include "ntt_rvv.h"
#endif

#endif
