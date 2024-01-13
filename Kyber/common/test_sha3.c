#include <stdio.h>
#include <string.h>

#include "cpucycles.h"
#include "speed_print.h"
#    include "fips202.h"
#ifdef VECTOR128
#    include "fips202x.h"
#endif

#if (1)
// for debug
void print_bytes(uint8_t *out, int len);
void print_stat(uint64_t *s);
void print_statx(uint64_t *s, int x);
void test_sha3_256(void);
void test_keccakf1600(void);
void test_keccakf1600x3(void);
void test_keccakf1600x4(void);
void test_keccakf1600x5(void);
void test_keccakf1600x6(void);
void test_keccakf1600x8(void);

#    ifndef VECTOR128
void print_bytes(uint8_t *out, int len)
{
    int i;
    for (i = 0; i < len - 1; i++) {
        printf("%d, ", out[i]);
    }
    printf("%d", out[i]);
    printf("\n");
}

#        ifdef RV32
void print_stat(uint64_t *s)
{
    for (int i = 0; i < 25; i++) {
        printf("%llu ", s[i]);
    }
    printf("\n");
}
#        else
void print_stat(uint64_t *s)
{
    for (int i = 0; i < 25; i++) {
        printf("%lu ", s[i]);
    }
    printf("\n");
}
#        endif

/**
 * The correct result should be:
 *
 * sha3_256 once: 190 47 181 116 251 237 130 151 42 99 10 169 144 68 179 193 166
 * 122 99 80 249 221 224 191 131 54 106 12 15 130 199 28
 *
 * sha3_256 twice: 144 122 237 223 209 118 6 246 47 97 126 39 59 24 191 232 217
 * 50 214 118 56 95 54 150 36 116 79 85 156 160 53 103
 */
void test_sha3_256(void)
{
    const uint8_t in1[] =
        "Hello world, I am testing sha3!Hello world, I am testing sha3!Hello "
        "world, I am testing sha3!Hello world, I am testing sha3!Hello world, "
        "I am testing sha3!Hello world, I am testing sha3!Hello world, I am "
        "testing sha3!Hello world, I am testing sha3!";
    const uint8_t out1[32] = {31,  139, 27,  72,  175, 159, 157, 39,
                              238, 238, 215, 9,   141, 60,  72,  150,
                              84,  233, 116, 90,  148, 220, 111, 29,
                              35,  200, 145, 232, 5,   6,   106, 167};
    const uint8_t out2[64] = {
        102, 185, 231, 18,  88,  159, 91,  48,  197, 118, 109, 20,  250,
        240, 235, 20,  28,  13,  96,  246, 117, 111, 28,  124, 111, 219,
        10,  171, 67,  35,  247, 184, 62,  117, 106, 151, 224, 166, 106,
        247, 183, 80,  8,   141, 1,   108, 211, 248, 91,  32,  75,  219,
        104, 242, 38,  144, 37,  83,  156, 231, 22,  86,  13,  183};
    uint8_t out[64];

    sha3_256(out, in1, sizeof(in1));
    if (memcmp(out, out1, 32) == 0) {
    } else {
        printf("sha3_256 FAILED: ");
        print_bytes(out, 32);
    }

    sha3_512(out, in1, sizeof(in1));
    if (memcmp(out, out2, 64) == 0) {
    } else {
        printf("sha3_512 FAILED: ");
        print_bytes(out, 64);
    }
}

void test_keccakf1600(void)
{
    uint64_t s[25];
    for (int i = 0; i < 25; i++) {
        s[i] = i;
    }
    KeccakF1600_StatePermute(s);
    print_stat(s);
}

#    else
void print_statx(uint64_t *s, int x)
{
    v128 *in = (v128 *)s;
    uint64_t t0, t1;
    uint64_t *in_x1_0 = (uint64_t *)&in[25];
    uint64_t *pt0;

    printf("vector-lane 0:\n");
    for (int i = 0; i < 25; i++) {
        if (in[i].val[0] != in[i].val[1]) {
            printf("ERROR, in[%d].val[0]!=val[1]\n", i);
        }
        printf("%lu ", in[i].val[0]);
    }
    printf("\n");
    if (x == 0)
        return;
    printf("scale-lane 0:\n");
    for (int i = 0; i < 25; i++) {
        t0 = in_x1_0[i];
        for (int j = 1; j < x; j++) {
            pt0 = &in_x1_0[j * 25];
            t1 = pt0[i];
            if (t0 != t1) {
                printf("ERROR, scale-lane[0]!=lane[%d] for s[%d]\n", j, i);
            }
        }
        printf("%lu ", t0);
    }
    printf("\n");
}
void test_keccakf1600(void)
{
    v128 s[25];
    for (int i = 0; i < 25; i++) {
        s[i].val[0] = s[i].val[1] = i;
    }
    KeccakF1600x2_StatePermute(s);
    print_statx((uint64_t *)s, 2 - 2);
}
void test_keccakf1600x3(void)
{
    keccakx3_state state;
    for (int i = 0; i < 25; i++) {
        state.s.s_x2[i].val[0] = state.s.s_x2[i].val[1] = state.s.s_x1[i] = i;
    }
    KeccakF1600x3_StatePermute((uint64_t *)&state.s);
    print_statx((uint64_t *)&state.s, 3 - 2);
}
void test_keccakf1600x4(void)
{
    keccakx4_state state;
    for (int i = 0; i < 25; i++) {
        state.s.s_x2[i].val[0] = state.s.s_x2[i].val[1] = state.s.s_x1_0[i] =
            state.s.s_x1_1[i] = i;
    }
    KeccakF1600x4_StatePermute((uint64_t *)&state.s);
    print_statx((uint64_t *)&state.s, 4 - 2);
}
void test_keccakf1600x5(void)
{
    keccakx5_state state;
    for (int i = 0; i < 25; i++) {
        state.s.s_x2[i].val[0] = state.s.s_x2[i].val[1] = state.s.s_x1_0[i] =
            state.s.s_x1_1[i] = state.s.s_x1_2[i] = i;
    }
    KeccakF1600x5_StatePermute((uint64_t *)&state.s);
    print_statx((uint64_t *)&state.s, 5 - 2);
}
void test_keccakf1600x6(void)
{
    keccakx6_state state;
    for (int i = 0; i < 25; i++) {
        state.s.s_x2[i].val[0] = state.s.s_x2[i].val[1] = state.s.s_x1_0[i] =
            state.s.s_x1_1[i] = state.s.s_x1_2[i] = state.s.s_x1_3[i] = i;
    }
    KeccakF1600x6_StatePermute((uint64_t *)&state.s);
    print_statx((uint64_t *)&state.s, 6 - 2);
}
void test_keccakf1600x8(void)
{
    keccakx8_state state;
    for (int i = 0; i < 25; i++) {
        state.s.s_x2[i].val[0] = state.s.s_x2[i].val[1] = state.s.s_x1_0[i] =
            state.s.s_x1_1[i] = state.s.s_x1_2[i] = state.s.s_x1_3[i] =
                state.s.s_x1_4[i] = state.s.s_x1_5[i] = i;
    }
    KeccakF1600x8_StatePermute((uint64_t *)&state.s);
    print_statx((uint64_t *)&state.s, 8 - 2);
}
#    endif
#endif

#define NTESTS 10000

uint64_t t[NTESTS];

#define PERF(FUNC, LABEL)                                                   \
    do {                                                                    \
        uint64_t instret, cc_average;                                       \
        get_cpuinstret(FUNC, instret);                                      \
        for (i = 0; i < NTESTS; i++) {                                      \
            t[i] = cpucycles();                                             \
            FUNC;                                                           \
        }                                                                   \
        cc_average = get_average(t, NTESTS);                                \
        printf("%-20s cycles/insts/CPI=%llu/%llu/%.2f\n", #LABEL,           \
               (unsigned long long)cc_average, (unsigned long long)instret, \
               (float)cc_average / instret);                                \
    } while (0)

#define PERF_N(FUNC, LABEL, N)                                                 \
    do {                                                                       \
        uint64_t instret, cc_average, oneway_cc;                               \
        get_cpuinstret(FUNC, instret);                                         \
        for (i = 0; i < NTESTS; i++) {                                         \
            t[i] = cpucycles();                                                \
            FUNC;                                                              \
        }                                                                      \
        cc_average = get_average(t, NTESTS);                                   \
        oneway_cc = cc_average / N;                                            \
        printf("%-20s cycles/insts/CPI/1-wayCC=%llu/%llu/%.2f/%llu\n", #LABEL, \
               (unsigned long long)cc_average, (unsigned long long)instret,    \
               (float)cc_average / instret, (unsigned long long)oneway_cc);    \
    } while (0)

int main(void)
{
    int i;
    keccak_state s;
    const uint8_t buff[16] = {0};
    uint8_t buff_out[4 * SHAKE128_RATE];
#ifdef VECTOR128
    keccakx2_state sx2;
    keccakx3_state sx3;
    keccakx4_state sx4;
    keccakx5_state sx5;
    keccakx6_state sx6;
    keccakx8_state sx8;
#endif

    test_sha3_256();
    // test_keccakf1600();
#ifdef VECTOR128
    // test_keccakf1600();
    // test_keccakf1600x3();
    // test_keccakf1600x4();
    // test_keccakf1600x5();
    // test_keccakf1600x6();
    // test_keccakf1600x8();
#endif

    printf("Test speed of SHA-3 related subroutines\n");
    PERF(KeccakF1600_StatePermute(s.s), KeccakF1600);
#ifdef VECTOR128
    PERF_N(KeccakF1600x2_StatePermute(sx2.s), KeccakF1600x2, 2);
    PERF_N(KeccakF1600x3_StatePermute((uint64_t *)&sx3.s), KeccakF1600x3, 3);
    PERF_N(KeccakF1600x4_StatePermute((uint64_t *)&sx4.s), KeccakF1600x4, 4);
    PERF_N(KeccakF1600x5_StatePermute((uint64_t *)&sx5.s), KeccakF1600x5, 5);
    PERF_N(KeccakF1600x6_StatePermute((uint64_t *)&sx6.s), KeccakF1600x6, 6);
    PERF_N(KeccakF1600x8_StatePermute((uint64_t *)&sx8.s), KeccakF1600x8, 8);
#endif
    // PERF(shake128_absorb_once(&s, buff, 16), shake128_absorb_once);
    // PERF(shake128_squeezeblocks(buff_out, 1, &s),
    //            shake128_squeezeblocks_1);
    // PERF(shake128_squeezeblocks(buff_out, 2, &s),
    // shake128_squeezeblocks_2); PERF(shake128_squeezeblocks(buff_out, 4,
    // &s), shake128_squeezeblocks_4);

    // PERF(shake256_absorb_once(&s, buff, 16), shake256_absorb_once);
    // PERF(shake256_squeezeblocks(buff_out, 1, &s),
    // shake256_squeezeblocks_1); PERF(shake256_squeezeblocks(buff_out, 2,
    // &s), shake256_squeezeblocks_2);
    // PERF(shake256_squeezeblocks(buff_out, 4, &s),
    // shake256_squeezeblocks_4);

    PERF(sha3_256(buff_out, buff, 16), sha3_256);
    // PERF(sha3_512(buff_out, buff, 16), sha3_512);

    return 0;
}