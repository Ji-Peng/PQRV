#include <stdint.h>
#include <stdio.h>

#include "cpucycles.h"
#include "speed_print.h"

#define NTESTS 10000

uint64_t t[NTESTS];

#define PERF(FUNC, LABEL)                                                 \
    do {                                                                  \
        uint64_t instret, cc_average;                                     \
        for (int warmup_i = 0; warmup_i < 1000; warmup_i++)               \
            FUNC;                                                         \
        get_cpuinstret(FUNC, instret);                                    \
        for (int i = 0; i < NTESTS; i++) {                                \
            t[i] = cpucycles();                                           \
            FUNC;                                                         \
        }                                                                 \
        cc_average = get_median(t, NTESTS);                              \
        printf("%-30s cycles/insts/CPI=%llu/%llu/%.2f\n", #LABEL,         \
               (unsigned long long)cc_average,                            \
               (unsigned long long)instret, (float)cc_average / instret); \
    } while (0)

extern void cpi_rori();
extern void cpi_rori_x1();
extern void cpi_rori_x2();
extern void cpi_rori_x4();
extern void cpi_andn();
extern void cpi_andn_x1();
extern void cpi_andn_x2();
extern void cpi_andn_x4();

int main(void)
{
    PERF(cpi_rori(), cpi_rori);
    PERF(cpi_rori_x1(), cpi_rori_x1);
    PERF(cpi_rori_x2(), cpi_rori_x2);
    PERF(cpi_rori_x4(), cpi_rori_x4);
    PERF(cpi_andn(), cpi_andn);
    PERF(cpi_andn_x1(), cpi_andn_x1);
    PERF(cpi_andn_x2(), cpi_andn_x2);
    PERF(cpi_andn_x4(), cpi_andn_x4);
    return 0;
}