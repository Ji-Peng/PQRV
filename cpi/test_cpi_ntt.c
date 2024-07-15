#include <stdint.h>
#include <stdio.h>

#include "cpucycles.h"
#include "speed_print.h"

#define NTESTS 10000

uint64_t t[NTESTS];

extern void cpi_ct_bfu_scalar_mont_x4();
extern void cpi_ct_bfu_scalar_mont_x4_v2();
extern void cpi_ct_bfu_scalar_mont_x4_v3();
extern void cpi_ct_bfu_scalar_mont_x8();
extern void cpi_ct_bfu_vector_mont_x1();
extern void cpi_hybrid_ct_bfu_4s_mont_1v_mont();
extern void cpi_hybrid_ct_bfu_8s_mont_1v_mont();
extern void cpi_tomont_x4_vector();
extern void cpi_hybrid_to_mont_vx4_sx4();
extern void cpi_hybrid_vmulx4_addix4();
extern void cpi_hybrid_vmulx4_addix2();
extern void cpi_hybrid_vmulx4_addix1();

int main(void)
{
    int64_t buf[128];
    int vec_len;

    vec_len = init_vector_e32();
    PERF(cpi_ct_bfu_scalar_mont_x4(), cpi_ct_bfu_scalar_mont_x4);
    PERF(cpi_ct_bfu_scalar_mont_x4_v2(), cpi_ct_bfu_scalar_mont_x4_v2);
    PERF(cpi_ct_bfu_scalar_mont_x4_v3(), cpi_ct_bfu_scalar_mont_x4_v3);
    PERF(cpi_ct_bfu_scalar_mont_x8(), cpi_ct_bfu_scalar_mont_x8);
    PERF(cpi_ct_bfu_vector_mont_x1(), cpi_ct_bfu_vector_mont_x1);
    PERF(cpi_hybrid_ct_bfu_4s_mont_1v_mont(), cpi_ct_bfu_4s_mont_1v_mont);
    PERF(cpi_hybrid_ct_bfu_8s_mont_1v_mont(), cpi_ct_bfu_8s_mont_1v_mont);
    PERF(cpi_tomont_x4_vector(), cpi_tomont_x4_vector);
    PERF(cpi_hybrid_to_mont_vx4_sx4(), cpi_hybrid_to_mont_vx4_sx4);
    PERF(cpi_hybrid_to_mont_vx4_sx2(), cpi_hybrid_to_mont_vx4_sx2);
    PERF(cpi_hybrid_to_mont_vx4_sx1(), cpi_hybrid_to_mont_vx4_sx1);
    PERF(cpi_hybrid_vmulx4_addix4(), cpi_hybrid_vmulx4_addix4);
    PERF(cpi_hybrid_vmulx4_addix2(), cpi_hybrid_vmulx4_addix2);
    PERF(cpi_hybrid_vmulx4_addix1(), cpi_hybrid_vmulx4_addix1);

    return 0;
}