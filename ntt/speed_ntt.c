#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cpucycles.h"

#ifdef RVV
#    include "ntt_rvv.h"
#else
#    include "ntt_rv32im.h"
#endif
#include "speed_print.h"

#define NTESTS 10000

uint64_t t[NTESTS];

#define PERF(FUNC, LABEL)                                                 \
    do {                                                                  \
        uint64_t instret, cc_average;                                     \
        get_cpuinstret(FUNC, instret);                                    \
        for (i = 0; i < NTESTS; i++) {                                    \
            t[i] = cpucycles();                                           \
            FUNC;                                                         \
        }                                                                 \
        cc_average = get_average(t, NTESTS);                              \
        printf("%-30s cycles/insts/CPI=%llu/%llu/%.2f\n", #LABEL,         \
               (unsigned long long)cc_average,                            \
               (unsigned long long)instret, (float)cc_average / instret); \
    } while (0)

int main()
{
    int i;
#ifdef DILITHIUM_NTT_RV32_H
    int32_t r[256], zetas[256 * 2];
    printf("Dilithium 8-layer NTT & Montgomery based & 3+3+2 layers merging\n");
    PERF(ntt_8l_rv32im(r, zetas), ntt);
    PERF(intt_8l_rv32im(r, zetas), intt);
#elif defined(KYBER_NTT_RV32_H)
    int16_t r[256], a[256], b[256], b_cache[256];
    int32_t r_double[256];
    uint32_t zetas[128];
    printf("Kyber 7-layer NTT & Plantard based & 4+3 layers merging & RV32IM\n");
    PERF(ntt_rv32im(r, zetas), ntt);
    PERF(invntt_rv32im(r, zetas), intt);
    PERF(poly_basemul_acc_rv32im(r_double, a, b, zetas), basemul_acc);
    PERF(poly_basemul_acc_end_rv32im(r, a, b, zetas, r_double),
         basemul_acc_end);
    PERF(poly_basemul_cache_init_rv32im(r_double, a, b, b_cache, zetas),
         basemul_cache_init);
    PERF(
        poly_basemul_acc_cache_init_rv32im(r_double, a, b, b_cache, zetas),
        basemul_acc_cache_init);
    PERF(poly_basemul_acc_cache_init_end_rv32im(r, a, b, b_cache, zetas,
                                                r_double),
         basemul_acc_cache_init_end);
    PERF(poly_basemul_acc_cached_rv32im(r_double, a, b, b_cache),
         basemul_acc_cached);
    PERF(poly_basemul_acc_cache_end_rv32im(r, a, b, b_cache, r_double),
         basemul_acc_cache_end);
    PERF(poly_plantard_rdc_rv32im(r), plantard_rdc);
    PERF(poly_toplant_rv32im(r), toplant);
#elif defined(KYBER_NTT_RVV_H)
    int16_t r[256];
    const int16_t qdata[1472];
    printf("Kyber 7-layer NTT & Montgomery based & 1+6 layers merging & RV32IMV\n");
    PERF(ntt_rvv(r, qdata), ntt);
    PERF(intt_rvv(r, qdata), intt);
#endif

    return 0;
}