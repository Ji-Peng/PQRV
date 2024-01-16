#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cpucycles.h"
#include "fips202.h"
#include "speed_print.h"
#ifdef VECTOR128
#    include "fips202x.h"
#endif

// for debug
void print_bytes(uint8_t *out, int len);
void print_stat(uint64_t *s);
void print_statx(uint64_t *s, int x);
void test_sha3(void);
void test_sha3x2(void);
void test_sha3x3(void);
void test_sha3x4(void);
void test_sha3x5(void);
void test_sha3x6(void);
void test_sha3x8(void);
void test_keccakf1600(void);
void test_keccakf1600x2(void);
void test_keccakf1600x3(void);
void test_keccakf1600x4(void);
void test_keccakf1600x5(void);
void test_keccakf1600x6(void);
void test_keccakf1600x8(void);

void print_bytes(uint8_t *out, int len)
{
    int i;
    for (i = 0; i < len - 1; i++) {
        printf("%d, ", out[i]);
    }
    printf("%d\n", out[i]);
}

void print_stat(uint64_t *s)
{
    int i;
    for (i = 0; i < 25 - 1; i++) {
        printf("%llu, ", (unsigned long long)s[i]);
    }
    printf("%llu\n", (unsigned long long)s[i]);
}

const uint8_t sha3_input[249] = {
    1,   2,   3,   4,   5,   6,   7,   8,   9,   10,  11,  12,  13,  14,  15,  16,  17,  18,
    19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,
    37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  52,  53,  54,
    55,  56,  57,  58,  59,  60,  61,  62,  63,  64,  65,  66,  67,  68,  69,  70,  71,  72,
    73,  74,  75,  76,  77,  78,  79,  80,  81,  82,  83,  84,  85,  86,  87,  88,  89,  90,
    91,  92,  93,  94,  95,  96,  97,  98,  99,  100, 101, 102, 103, 104, 105, 106, 107, 108,
    109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126,
    127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144,
    145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162,
    163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180,
    181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198,
    199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216,
    217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234,
    235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249};
const uint8_t sha3_256_output[32] = {112, 90,  11,  42,  206, 54,  78, 106, 31,  174, 4,
                                     207, 36,  108, 124, 90,  120, 65, 224, 0,   68,  231,
                                     219, 217, 137, 138, 72,  196, 37, 35,  182, 66};
const uint8_t sha3_512_output[64] = {
    223, 203, 2,   144, 100, 62,  53,  137, 32,  52,  2,   99,  223, 207, 197, 181,
    184, 249, 220, 152, 207, 129, 163, 105, 145, 242, 32,  190, 153, 193, 184, 144,
    199, 181, 194, 26,  87,  53,  60,  63,  90,  20,  239, 69,  140, 130, 164, 39,
    175, 232, 206, 78,  42,  236, 74,  63,  220, 247, 134, 71,  220, 229, 35,  106};
const uint8_t shake128_output[252] = {
    169, 185, 130, 22,  180, 30,  178, 97,  160, 152, 47,  143, 145, 113, 158, 20,  245, 111,
    210, 107, 239, 151, 249, 56,  82,  232, 188, 33,  76,  230, 254, 195, 51,  165, 45,  157,
    37,  51,  34,  192, 220, 165, 195, 237, 52,  100, 185, 0,   24,  218, 36,  30,  94,  133,
    111, 71,  142, 83,  131, 119, 152, 247, 115, 8,   166, 91,  40,  183, 231, 242, 60,  128,
    72,  240, 121, 237, 1,   197, 26,  57,  165, 148, 125, 159, 74,  37,  2,   169, 85,  192,
    119, 118, 222, 229, 16,  196, 98,  138, 236, 236, 52,  192, 177, 170, 133, 206, 188, 133,
    84,  164, 67,  20,  85,  205, 51,  246, 38,  135, 233, 229, 89,  167, 184, 64,  14,  103,
    108, 35,  95,  38,  66,  50,  206, 167, 4,   228, 187, 38,  193, 69,  216, 37,  203, 28,
    159, 152, 5,   235, 80,  2,   216, 194, 204, 153, 57,  200, 32,  131, 23,  167, 207, 208,
    236, 84,  61,  95,  143, 185, 80,  172, 21,  253, 1,   141, 239, 8,   187, 202, 226, 37,
    46,  200, 92,  201, 213, 158, 112, 95,  68,  200, 121, 124, 146, 193, 234, 0,   184, 201,
    65,  179, 81,  237, 238, 8,   178, 135, 169, 2,   37,  21,  157, 33,  59,  232, 183, 23,
    112, 99,  80,  26,  38,  61,  154, 29,  145, 193, 154, 213, 24,  194, 152, 205, 242, 248,
    117, 91,  14,  175, 233, 124, 37,  250, 162, 229, 1,   182, 128, 226, 11,  150, 58,  204};
const uint8_t shake256_output[252] = {
    221, 253, 47,  206, 240, 244, 31,  20,  56,  7,   195, 202, 89,  250, 25,  63,  18,  242,
    103, 182, 194, 5,   63,  240, 170, 140, 164, 52,  212, 149, 62,  199, 114, 4,   79,  38,
    153, 217, 27,  135, 250, 154, 155, 251, 98,  94,  228, 201, 93,  255, 242, 10,  172, 114,
    68,  237, 226, 211, 61,  200, 19,  160, 224, 17,  169, 237, 192, 238, 94,  76,  166, 69,
    226, 82,  59,  15,  176, 49,  181, 52,  84,  183, 228, 243, 145, 32,  57,  218, 43,  250,
    104, 47,  250, 6,   204, 219, 209, 215, 141, 162, 93,  252, 244, 1,   200, 149, 87,  81,
    206, 15,  140, 32,  27,  29,  219, 104, 246, 220, 123, 200, 183, 158, 140, 77,  208, 144,
    137, 80,  172, 53,  124, 120, 46,  12,  233, 47,  15,  80,  30,  228, 170, 206, 252, 42,
    151, 153, 98,  35,  29,  25,  66,  29,  160, 255, 249, 202, 163, 18,  51,  156, 97,  54,
    178, 183, 199, 82,  71,  236, 141, 216, 190, 241, 240, 73,  108, 196, 111, 3,   11,  189,
    74,  64,  104, 145, 146, 107, 14,  188, 208, 185, 240, 152, 115, 150, 173, 159, 210, 105,
    176, 49,  202, 92,  73,  6,   168, 245, 67,  80,  246, 101, 92,  175, 88,  113, 167, 184,
    235, 3,   238, 251, 221, 38,  168, 107, 78,  43,  142, 212, 139, 251, 35,  164, 135, 115,
    78,  238, 12,  33,  136, 148, 216, 80,  138, 202, 39,  254, 220, 91,  112, 0,   15,  208};

void test_sha3(void)
{
    uint8_t out[64];
    uint8_t shake_out[252];

    sha3_256(out, sha3_input, sizeof(sha3_input));
    if (memcmp(out, sha3_256_output, 32) == 0) {
    } else {
        printf("sha3_256 FAILED: \n");
        print_bytes(out, 32);
    }

    sha3_512(out, sha3_input, sizeof(sha3_input));
    if (memcmp(out, sha3_512_output, 64) == 0) {
    } else {
        printf("sha3_512 FAILED: \n");
        print_bytes(out, 64);
    }

    shake128(shake_out, sizeof(shake_out), sha3_input, sizeof(sha3_input));
    if (memcmp(shake_out, shake128_output, sizeof(shake_out)) == 0) {
    } else {
        printf("shake128 FAILED: \n");
        print_bytes(shake_out, sizeof(shake_out));
    }

    shake256(shake_out, sizeof(shake_out), sha3_input, sizeof(sha3_input));
    if (memcmp(shake_out, shake256_output, sizeof(shake_out)) == 0) {
    } else {
        printf("shake256 FAILED: \n");
        print_bytes(shake_out, sizeof(shake_out));
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

#ifdef VECTOR128
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
        if (i != 24)
            printf("%llu, ", (unsigned long long)in[i].val[0]);
    }
    printf("%llu\n", (unsigned long long)in[24].val[0]);
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
        if (i != 24)
            printf("%llu, ", (unsigned long long)t0);
    }
    printf("%llu\n", (unsigned long long)in_x1_0[24]);
}

void test_keccakf1600x2(void)
{
    keccakx2_state state;
    for (int i = 0; i < 25; i++) {
        state.s[i].val[0] = state.s[i].val[1] = i;
    }
    KeccakF1600x2_StatePermute((uint64_t *)state.s);
    print_statx((uint64_t *)&state.s, 2 - 2);
}

IMPL_TEST_SHA3(2)
#endif

#if defined(VECTOR128) && defined(HYBRIDX3)
void test_keccakf1600x3(void)
{
    keccakx3_state state;
    for (int i = 0; i < 25; i++) {
        state.s.s_x2[i].val[0] = state.s.s_x2[i].val[1] = state.s.s_x1[i] = i;
    }
    KeccakF1600x3_StatePermute((uint64_t *)&state.s);
    print_statx((uint64_t *)&state.s, 3 - 2);
}

IMPL_TEST_SHA3(3)
#endif

#if defined(VECTOR128) && defined(HYBRIDX4)
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

IMPL_TEST_SHA3(4)
#endif

#if defined(VECTOR128) && defined(HYBRIDX5)
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

IMPL_TEST_SHA3(5)
#endif

#if defined(VECTOR128) && defined(HYBRIDX6)
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

IMPL_TEST_SHA3(6)
#endif

#if defined(VECTOR128) && defined(HYBRIDX8)
void test_keccakf1600x8(void)
{
    keccakx8_state state;
    for (int i = 0; i < 25; i++) {
        state.s.s_x2[i].val[0] = state.s.s_x2[i].val[1] = state.s.s_x1_0[i] =
            state.s.s_x1_1[i] = state.s.s_x1_2[i] = state.s.s_x1_3[i] = state.s.s_x1_4[i] =
                state.s.s_x1_5[i] = i;
    }
    KeccakF1600x8_StatePermute((uint64_t *)&state.s);
    print_statx((uint64_t *)&state.s, 8 - 2);
}

IMPL_TEST_SHA3(8)
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
        printf("%-30s cycles/insts/CPI=%llu/%llu/%.2f\n", #LABEL,           \
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
        printf("%-30s cycles/insts/CPI/1-wayCC=%llu/%llu/%.2f/%llu\n", #LABEL, \
               (unsigned long long)cc_average, (unsigned long long)instret,    \
               (float)cc_average / instret, (unsigned long long)oneway_cc);    \
    } while (0)

int main(void)
{
    int i;
    keccak_state s;
    const uint8_t buff[16] = {0};
    uint8_t buff_out[4 * SHAKE128_RATE];

    test_sha3();
    // test_keccakf1600();
    printf("Test speed of SHA-3 related subroutines\n");
    PERF(KeccakF1600_StatePermute(s.s), KeccakF1600);
    PERF(shake128_absorb_once(&s, buff, 16), shake128_absorb_once);
    PERF(shake128_squeezeblocks(buff_out, 1, &s), shake128_squeezeblocks_1);
    PERF(sha3_256(buff_out, buff, 16), sha3_256);
    PERF(sha3_512(buff_out, buff, 16), sha3_512);

#ifdef VECTOR128
    keccakx2_state sx2;
    test_sha3x2();
    // test_keccakf1600x2();
    PERF_N(KeccakF1600x2_StatePermute((uint64_t *)sx2.s), KeccakF1600x2, 2);
#endif

#if defined(VECTOR128) && defined(HYBRIDX3)
    keccakx3_state sx3;
    test_sha3x3();
    // test_keccakf1600x3();
    PERF_N(KeccakF1600x3_StatePermute((uint64_t *)&sx3.s), KeccakF1600x3, 3);
#endif

#if defined(VECTOR128) && defined(HYBRIDX4)
    keccakx4_state sx4;
    test_sha3x4();
    // test_keccakf1600x4();
    PERF_N(KeccakF1600x4_StatePermute((uint64_t *)&sx4.s), KeccakF1600x4, 4);
#endif

#if defined(VECTOR128) && defined(HYBRIDX5)
    keccakx5_state sx5;
    test_sha3x5();
    // test_keccakf1600x5();
    PERF_N(KeccakF1600x5_StatePermute((uint64_t *)&sx5.s), KeccakF1600x5, 5);
#endif

#if defined(VECTOR128) && defined(HYBRIDX6)
    keccakx6_state sx6;
    test_sha3x6();
    // test_keccakf1600x6();
    PERF_N(KeccakF1600x6_StatePermute((uint64_t *)&sx6.s), KeccakF1600x6, 6);
#endif

#if defined(VECTOR128) && defined(HYBRIDX8)
    keccakx8_state sx8;
    test_sha3x8();
    // test_keccakf1600x8();
    PERF_N(KeccakF1600x8_StatePermute((uint64_t *)&sx8.s), KeccakF1600x8, 8);
#endif

    return 0;
}