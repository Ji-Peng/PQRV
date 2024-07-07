#ifndef PRINT_SPEED_H
#define PRINT_SPEED_H

#include <stddef.h>
#include <stdint.h>

void print_results(const char *s, uint64_t *t, size_t tlen);
uint64_t get_average(uint64_t *t, size_t tlen);
uint64_t get_median(uint64_t *t, size_t tlen);
uint64_t median(uint64_t *l, size_t llen);

#define PERF(FUNC, LABEL)                                                 \
    do {                                                                  \
        uint64_t instret, cc_average;                                     \
        for (i = 0; i < 10; i++) {                                        \
            get_cpuinstret(FUNC, t[i]);                                   \
        }                                                                 \
        instret = median(t, 10);                                          \
        for (i = 0; i < NTESTS; i++) {                                    \
            t[i] = cpucycles();                                           \
            FUNC;                                                         \
        }                                                                 \
        cc_average = get_median(t, NTESTS);                               \
        printf("%-30s cycles/insts/CPI=%llu/%llu/%.2f\n", #LABEL,         \
               (unsigned long long)cc_average,                            \
               (unsigned long long)instret, (float)cc_average / instret); \
    } while (0)

#define PERF_N(FUNC, LABEL, N)                                           \
    do {                                                                 \
        uint64_t instret, cc_average, oneway_cc;                         \
        for (i = 0; i < 10; i++) {                                       \
            get_cpuinstret(FUNC, t[i]);                                  \
        }                                                                \
        instret = median(t, 10);                                         \
        for (i = 0; i < NTESTS; i++) {                                   \
            t[i] = cpucycles();                                          \
            FUNC;                                                        \
        }                                                                \
        cc_average = get_median(t, NTESTS);                              \
        oneway_cc = cc_average / N;                                      \
        printf("%-20s cycles/insts/CPI/1-wayCC=%llu/%llu/%.2f/%llu\n",   \
               #LABEL, (unsigned long long)cc_average,                   \
               (unsigned long long)instret, (float)cc_average / instret, \
               (unsigned long long)oneway_cc);                           \
    } while (0)

#endif
