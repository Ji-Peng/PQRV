#ifndef CPUCYCLES_H
#define CPUCYCLES_H

#include <stdint.h>

#ifdef RV32
static inline uint64_t cpucycles(void)
{
    uint64_t result;
    uint32_t low, high;

    __asm__ volatile(
        "rdcycleh %[high]\n"
        "rdcycle %[low]\n"
        : [high] "=r"(high), [low] "=r"(low));

    result = ((uint64_t)high << 32) | low;
    return result;
}

static inline uint64_t cpuinstret(void)
{
    uint64_t result;
    uint32_t low, high;

    __asm__ volatile(
        "rdinstreth %[high]\n"
        "rdinstret %[low]\n"
        : [high] "=r"(high), [low] "=r"(low));

    result = ((uint64_t)high << 32) | low;
    return result;
}

static inline uint64_t cputime(void)
{
    uint64_t result;
    uint32_t low, high;

    __asm__ volatile(
        "rdtimeh %[high]\n"
        "rdtime %[low]\n"
        : [high] "=r"(high), [low] "=r"(low));

    result = ((uint64_t)high << 32) | low;
    return result;
}

#else
static inline uint64_t cpucycles(void)
{
    uint64_t result;

    __asm__ volatile("rdcycle %0" : "=r"(result));

    return result;
}

static inline uint64_t cpuinstret(void)
{
    uint64_t result;

    __asm__ volatile("rdinstret %0" : "=r"(result));

    return result;
}

static inline uint64_t cputime(void)
{
    uint64_t result;

    __asm__ volatile("rdtime %0" : "=r"(result));

    return result;
}

#endif

#define perf_profile(FUNC, LABEL)                        \
    do {                                                 \
        uint64_t start, end;                             \
        start = cpuinstret();                            \
        FUNC;                                            \
        end = cpuinstret();                              \
        printf("%s instructions retired: %llu\n", LABEL, \
               (unsigned long long)(end - start));       \
    } while (0)

#define get_cpuinstret(FUNC, VALUE) \
    do {                            \
        uint64_t start, end;        \
        start = cpuinstret();       \
        FUNC;                       \
        end = cpuinstret();         \
        VALUE = end - start;        \
    } while (0)

uint64_t cpucycles_overhead(void);

#endif