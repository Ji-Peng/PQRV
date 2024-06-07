#ifndef NTT_H
#define NTT_H

#include <stdint.h>

#include "params.h"

void ntt(int32_t a[N]);
void intt(int32_t a[N]);

#if defined(RV32)
#    include "ntt_rv32im.h"
void ntt_6l(int32_t a[N]);
void intt_6l(int32_t a[N]);
#else

#endif

#endif
