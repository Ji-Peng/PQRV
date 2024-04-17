#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "cpucycles.h"
#include "ntt_rvv.h"
#include "speed_print.h"

extern void test_vector_scalar_hybrid_1_0(int16_t *a, const int16_t *table);
extern void test_vector_scalar_hybrid_3_8(int16_t *a, const int16_t *table);
extern void test_vector_scalar_hybrid_7_1(int16_t *a, const int16_t *table);
extern void test_vector_scalar_hybrid_15_1(int16_t *a, const int16_t *table);

#define NTESTS 100000
uint64_t t[NTESTS];

int main()
{
    int i;
    int16_t a[256];
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        test_vector_scalar_hybrid_1_0(a, qdata);
    }
    print_results("test_vector_scalar_hybrid_1_0: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        test_vector_scalar_hybrid_3_8(a, qdata);
    }
    print_results("test_vector_scalar_hybrid_3_8: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        test_vector_scalar_hybrid_7_1(a, qdata);
    }
    print_results("test_vector_scalar_hybrid_7_1: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        test_vector_scalar_hybrid_15_1(a, qdata);
    }
    print_results("test_vector_scalar_hybrid_15_1: ", t, NTESTS);
}
