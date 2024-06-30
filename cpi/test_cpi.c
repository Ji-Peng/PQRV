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
        cc_average = get_average(t, NTESTS);                              \
        printf("%-30s cycles/insts/CPI=%llu/%llu/%.2f\n", #LABEL,         \
               (unsigned long long)cc_average,                            \
               (unsigned long long)instret, (float)cc_average / instret); \
    } while (0)

extern void cpi_add();
extern void cpi_addi();
extern void cpi_addi_forward();
extern void cpi_xor();
extern void cpi_xori();
extern void cpi_addxor();
extern void cpi_addxor_forward();
extern void cpi_mul_mulh();
extern void cpi_mul();
extern void cpi_mulh();
extern void cpi_mulw();
extern void cpi_mulw_x1();
extern void cpi_mulw_x2();
extern void cpi_mulw_x4();
extern void cpi_mul_x1();
extern void cpi_mul_x2();
extern void cpi_mul_x4();

extern void cpi_muladd();
extern void cpi_mulx1addx2();
extern void cpi_mulx2addx4();
extern void cpi_mulx1addx3();
extern void cpi_mulx1addx4();
extern void cpi_shiftxor();
extern void cpi_lh(int8_t *);
extern void cpi_lw(int8_t *);
extern void cpi_ld(int8_t *);
extern void cpi_plantmul();
extern void cpi_plantmulx2();
extern void cpi_plantmulx4();
extern void cpi_plantmul_rv64();
extern void cpi_plantmul_rv64x2();
extern void cpi_plantmul_rv64x4();
extern void cpi_plant_ct_bfu_x1();
extern void cpi_plant_ct_bfu_x2();
extern void cpi_plant_ct_bfu_x4();
extern void cpi_plant_ct_bfu_x8();
extern void cpi_fake_plant_ct_bfu_x1();
extern void cpi_fake_plant_ct_bfu_x2();
extern void cpi_plant_gs_bfu_x1();
extern void cpi_plant_gs_bfu_x2();
extern void cpi_plant_gs_bfu_x4();
extern void cpi_plant_gs_bfu_x8();
extern void cpi_fake_plant_gs_bfu_x1();

extern int init_vector();
extern void cpi_vle16(int8_t *buf);
extern void cpi_vmulvx();
extern void cpi_vmulvx_x1();
extern void cpi_vmulvx_x2();
extern void cpi_vmulvx_x4();
extern void cpi_vmulvv();
extern void cpi_vmulvv_x1();
extern void cpi_vmulvv_x2();
extern void cpi_vmulvv_x4();
extern void cpi_vaddvv();
extern void cpi_vaddvx();
extern void cpi_vaddvx_x1();
extern void cpi_vaddvx_x2();
extern void cpi_vaddvx_x4();
extern void cpi_vsravi();
extern void cpi_vrgathervv();
extern void cpi_vmergevvm();

extern void cpi_ct_bfu_scalar_mont_x4();
extern void cpi_ct_bfu_scalar_mont_x4_v2();
extern void cpi_ct_bfu_scalar_mont_x4_v3();
extern void cpi_ct_bfu_scalar_mont_x8();
extern void cpi_ct_bfu_vector_mont_x1();
extern void cpi_hybrid_ct_bfu_4s_mont_1v_mont();
extern void cpi_hybrid_ct_bfu_8s_mont_1v_mont();

int main(void)
{
    int8_t buf[128];
#ifdef VECTOR128
    int vec_len = init_vector();
    printf("init_vector, the length of vector is %d bits\n", vec_len * 16);
    PERF(cpi_vle16(buf), cpi_vle16);
    PERF(cpi_vmulvx(), cpi_vmulvx);
    PERF(cpi_vmulvx_x1(), cpi_vmulvx_x1);
    PERF(cpi_vmulvx_x2(), cpi_vmulvx_x2);
    PERF(cpi_vmulvx_x4(), cpi_vmulvx_x4);
    PERF(cpi_vmulvv(), cpi_vmulvv);
    PERF(cpi_vmulvv_x1(), cpi_vmulvv_x1);
    PERF(cpi_vmulvv_x2(), cpi_vmulvv_x2);
    PERF(cpi_vmulvv_x4(), cpi_vmulvv_x4);
    PERF(cpi_vaddvv(), cpi_vaddvv);
    PERF(cpi_vaddvx(), cpi_vaddvx);
    PERF(cpi_vaddvx_x1(), cpi_vaddvx_x1);
    PERF(cpi_vaddvx_x2(), cpi_vaddvx_x2);
    PERF(cpi_vaddvx_x4(), cpi_vaddvx_x4);
    PERF(cpi_vsravi(), cpi_vsravi);
    PERF(cpi_vrgathervv(), cpi_vrgathervv);
    PERF(cpi_vmergevvm(), cpi_vmergevvm);
    PERF(cpi_ct_bfu_scalar_mont_x4(), cpi_ct_bfu_scalar_mont_x4);
    PERF(cpi_ct_bfu_scalar_mont_x4_v2(), cpi_ct_bfu_scalar_mont_x4_v2);
    PERF(cpi_ct_bfu_scalar_mont_x4_v3(), cpi_ct_bfu_scalar_mont_x4_v3);
    PERF(cpi_ct_bfu_scalar_mont_x8(), cpi_ct_bfu_scalar_mont_x8);
    PERF(cpi_ct_bfu_vector_mont_x1(), cpi_ct_bfu_vector_mont_x1);
    PERF(cpi_hybrid_ct_bfu_4s_mont_1v_mont(), cpi_ct_bfu_4s_mont_1v_mont);
    PERF(cpi_hybrid_ct_bfu_8s_mont_1v_mont(), cpi_ct_bfu_8s_mont_1v_mont);
#else
    PERF(cpi_add(), cpi_add);
    PERF(cpi_addi(), cpi_addi);
    PERF(cpi_addi_forward(), cpi_addi_forward);
    PERF(cpi_xor(), cpi_xor);
    PERF(cpi_xori(), cpi_xori);
    PERF(cpi_addxor(), cpi_addxor);
    PERF(cpi_addxor_forward(), cpi_addxor_forward);
    PERF(cpi_mul_mulh(), cpi_mul_mulh);
    PERF(cpi_mul(), cpi_mul);
    PERF(cpi_mulh(), cpi_mulh);
    PERF(cpi_mul_x1(), cpi_mul_x1);
    PERF(cpi_mul_x2(), cpi_mul_x2);
    PERF(cpi_mul_x4(), cpi_mul_x4);
#    ifdef RV64
    PERF(cpi_mulw(), cpi_mulw);
    PERF(cpi_mulw_x1(), cpi_mulw_x1);
    PERF(cpi_mulw_x2(), cpi_mulw_x2);
    PERF(cpi_mulw_x4(), cpi_mulw_x4);
#    endif
    PERF(cpi_muladd(), cpi_muladd);
    PERF(cpi_mulx1addx2(), cpi_mulx1addx2);
    PERF(cpi_mulx2addx4(), cpi_mulx2addx4);
    PERF(cpi_mulx1addx3(), cpi_mulx1addx3);
    PERF(cpi_mulx1addx4(), cpi_mulx1addx4);
    PERF(cpi_shiftxor(), cpi_shiftxor);
    PERF(cpi_lh(buf), cpi_lh);
    PERF(cpi_lw(buf), cpi_lw);
#    ifdef RV64
    PERF(cpi_ld(buf), cpi_ld);
#    endif
    PERF(cpi_plantmul(), cpi_plantmul);
    PERF(cpi_plantmulx2(), cpi_plantmulx2);
    PERF(cpi_plantmulx4(), cpi_plantmulx4);
#    ifdef RV64
    PERF(cpi_plantmul_rv64(), cpi_plantmul_rv64);
    PERF(cpi_plantmul_rv64x2(), cpi_plantmul_rv64x2);
    PERF(cpi_plantmul_rv64x4(), cpi_plantmul_rv64x4);
#    endif
    PERF(cpi_plant_ct_bfu_x1(), cpi_plant_ct_bfu_x1);
    PERF(cpi_plant_ct_bfu_x2(), cpi_plant_ct_bfu_x2);
    PERF(cpi_plant_ct_bfu_x4(), cpi_plant_ct_bfu_x4);
    PERF(cpi_plant_ct_bfu_x8(), cpi_plant_ct_bfu_x8);
    PERF(cpi_fake_plant_ct_bfu_x1(), cpi_fake_plant_ct_bfu_x1);
    PERF(cpi_fake_plant_ct_bfu_x2(), cpi_fake_plant_ct_bfu_x2);
    PERF(cpi_plant_gs_bfu_x1(), cpi_plant_gs_bfu_x1);
    PERF(cpi_plant_gs_bfu_x2(), cpi_plant_gs_bfu_x2);
    PERF(cpi_plant_gs_bfu_x4(), cpi_plant_gs_bfu_x4);
    PERF(cpi_plant_gs_bfu_x8(), cpi_plant_gs_bfu_x8);
    PERF(cpi_fake_plant_gs_bfu_x1(), cpi_fake_plant_gs_bfu_x1);
#endif
    return 0;
}