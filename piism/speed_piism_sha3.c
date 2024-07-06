#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cpucycles.h"
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
        cc_average = get_median(t, NTESTS);                              \
        printf("%-30s cycles/insts/CPI=%llu/%llu/%.2f\n", #LABEL,         \
               (unsigned long long)cc_average,                            \
               (unsigned long long)instret, (float)cc_average / instret); \
    } while (0)

extern void KeccakF1600_StatePermute_RV64ASM(int64_t *s);
extern void KeccakF1600_StatePermute_RV32ASM(int64_t *s);

int main()
{
    int i;
    int64_t s[25];

#if defined(RIGHT_IMPL)
    const int64_t s_vector[25] = {
        -8974354289817452267, 2159377575142921216,  -620061561459738243,
        2325963263767348549,  -3359813256411193238, -6784931981985721197,
        3517755057770134847,  5223775837645169598,  933274647126506074,
        3451250694486589320,  825065683101361807,   6192414258352188799,
        -4020238283036672406, 3326742392640380689,  -1696768488075387482,
        -599046453816643102,  -6848309820508596777, 6049795840392747215,
        8610635351954084385,  -212612302735021691,  -3116396655699483856,
        -6399644161802197025, 4763389569697138851,  6779624089296570504,
        -3363075966074205645,
    };
    for (i = 0; i < 25; i++)
        s[i] = i;
#    if defined(RV64)
    KeccakF1600_StatePermute_RV64ASM(s);
#    elif defined(RV32)
    KeccakF1600_StatePermute_RV32ASM(s);
#    else
#        message "error"
#    endif
    if (memcmp(s, s_vector, 25 * 8) != 0)
        printf("error\n");
#endif

#if defined(RV64)
    PERF(KeccakF1600_StatePermute_RV64ASM(s),
         KeccakF1600_StatePermute_RV64ASM);
#elif defined(RV32)
    PERF(KeccakF1600_StatePermute_RV32ASM(s),
         KeccakF1600_StatePermute_RV32ASM);
#else
#    message "error"
#endif

    return 0;
}