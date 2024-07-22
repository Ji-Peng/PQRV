#include <stdint.h>
#include <stdio.h>

#include "cpucycles.h"
#include "speed_print.h"

#define NTESTS 10000

uint64_t t[NTESTS];

extern void cpi_ct_bfu_scalar_plant_x1();
extern void cpi_ct_bfu_scalar_plant_x2();
extern void cpi_ct_bfu_scalar_plant_x4();
extern void cpi_ct_bfu_scalar_plant_x8();
extern void cpi_gs_bfu_scalar_plant_x1();
extern void cpi_gs_bfu_scalar_plant_x2();
extern void cpi_gs_bfu_scalar_plant_x4();
extern void cpi_gs_bfu_scalar_plant_x8();

extern void cpi_ct_bfu_scalar_mont_x4();
extern void cpi_ct_bfu_scalar_mont_x4_v2();
extern void cpi_ct_bfu_scalar_mont_x4_v3();
extern void cpi_ct_bfu_scalar_mont_x8();
extern void cpi_ct_bfu_vector_mont_x1();
extern void cpi_tomont_x4_vector();
extern void cpi_hybrid_to_mont_vx4_sx4();
extern void cpi_ct_bfu_vv_x4();
extern void cpi_ct_bfu_vv_x8();

int main(void)
{
    int64_t buf[128];
    int vec_len;

    printf("e16\n");
    vec_len = init_vector_e16();
    PERF(cpi_ct_bfu_scalar_plant_x1(), cpi_ct_bfu_scalar_plant_x1);
    PERF(cpi_ct_bfu_scalar_plant_x2(), cpi_ct_bfu_scalar_plant_x2);
    PERF(cpi_ct_bfu_scalar_plant_x4(), cpi_ct_bfu_scalar_plant_x4);
    PERF(cpi_ct_bfu_scalar_plant_x8(), cpi_ct_bfu_scalar_plant_x8);
    PERF(cpi_gs_bfu_scalar_plant_x1(), cpi_gs_bfu_scalar_plant_x1);
    PERF(cpi_gs_bfu_scalar_plant_x2(), cpi_gs_bfu_scalar_plant_x2);
    PERF(cpi_gs_bfu_scalar_plant_x4(), cpi_gs_bfu_scalar_plant_x4);
    PERF(cpi_gs_bfu_scalar_plant_x8(), cpi_gs_bfu_scalar_plant_x8);

    PERF(cpi_ct_bfu_scalar_mont_x4(), cpi_ct_bfu_scalar_mont_x4);
    PERF(cpi_ct_bfu_scalar_mont_x4_v2(), cpi_ct_bfu_scalar_mont_x4_v2);
    PERF(cpi_ct_bfu_scalar_mont_x4_v3(), cpi_ct_bfu_scalar_mont_x4_v3);
    PERF(cpi_ct_bfu_scalar_mont_x8(), cpi_ct_bfu_scalar_mont_x8);
    PERF(cpi_ct_bfu_vector_mont_x1(), cpi_ct_bfu_vector_mont_x1);
    PERF(cpi_tomont_x4_vector(), cpi_tomont_x4_vector);
    PERF(cpi_hybrid_to_mont_vx4_sx4(), cpi_hybrid_to_mont_vx4_sx4);
    PERF(cpi_hybrid_to_mont_vx4_sx2(), cpi_hybrid_to_mont_vx4_sx2);
    PERF(cpi_hybrid_to_mont_vx4_sx1(), cpi_hybrid_to_mont_vx4_sx1);
    PERF(cpi_ct_bfu_vv_x4(), cpi_ct_bfu_vv_x4);
    PERF(cpi_ct_bfu_vv_x8(), cpi_ct_bfu_vv_x8);

    printf("e32\n");
    vec_len = init_vector_e32();
    PERF(cpi_ct_bfu_scalar_mont_x4(), cpi_ct_bfu_scalar_mont_x4);
    PERF(cpi_ct_bfu_scalar_mont_x4_v2(), cpi_ct_bfu_scalar_mont_x4_v2);
    PERF(cpi_ct_bfu_scalar_mont_x4_v3(), cpi_ct_bfu_scalar_mont_x4_v3);
    PERF(cpi_ct_bfu_scalar_mont_x8(), cpi_ct_bfu_scalar_mont_x8);
    PERF(cpi_ct_bfu_vector_mont_x1(), cpi_ct_bfu_vector_mont_x1);
    PERF(cpi_tomont_x4_vector(), cpi_tomont_x4_vector);
    PERF(cpi_hybrid_to_mont_vx4_sx4(), cpi_hybrid_to_mont_vx4_sx4);
    PERF(cpi_hybrid_to_mont_vx4_sx2(), cpi_hybrid_to_mont_vx4_sx2);
    PERF(cpi_hybrid_to_mont_vx4_sx1(), cpi_hybrid_to_mont_vx4_sx1);
    PERF(cpi_ct_bfu_vv_x4(), cpi_ct_bfu_vv_x4);
    PERF(cpi_ct_bfu_vv_x8(), cpi_ct_bfu_vv_x8);

    return 0;
}