#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cpucycles.h"
#include "speed_print.h"

#define NTESTS 10000

uint64_t t[NTESTS];

extern void KeccakF1600_StatePermute_RV64ASM(int64_t *s);
extern void KeccakF1600_StatePermute_RV32ASM(int64_t *s);

int main()
{
    int64_t s[25];

#if defined(RIGHT_IMPL) && defined(BIT_INTERLEAVING)

    const int64_t s_vector[25] = {
        -7794534714317336601, 1843721435690433069,  2138935646612000135,
        6215123349678569521,  3080838460478313395,  1392601371457218089,
        5470722274413426,     3247115616321438500,  4227066554406548522,
        -2488992409115480387, 7017242854914042765,  -7818444064360710293,
        -1506626996271099987, -643827705697801990,  -8756708557171319683,
        -7639490838342592593, -3842121775357832175, 201367128575937062,
        -9217954465686912710, -4182324130797409258, -6472711092947184663,
        3852330016663066783,  -2040262361515459794, 2200779534912474816,
        -2166354862419432895,
    };

#elif defined(RIGHT_IMPL)
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
#endif

#if defined(RIGHT_IMPL)
    for (int i = 0; i < 25; i++)
        s[i] = i;
#    if defined(RV64)
    KeccakF1600_StatePermute_RV64ASM(s);
#    elif defined(RV32)
    KeccakF1600_StatePermute_RV32ASM(s);
#    else
#        message "error"
#    endif
    if (memcmp(s, s_vector, 25 * 8) != 0) {
        printf("error\n");
        for (int i = 0; i < 25; i++)
            printf("%lld, ", s[i]);
        printf("\n");
    }
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