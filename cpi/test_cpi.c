#include <stdint.h>
#include <stdio.h>

#include "cpucycles.h"
#include "speed_print.h"

#define NTESTS 10000

uint64_t t[NTESTS];

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
extern void cpi_lh_addi(int8_t *);
extern void cpi_lw(int8_t *);
extern void cpi_lw_addi(int8_t *);
extern void cpi_ld(int8_t *);
extern void cpi_ld_addi(int8_t *);
extern void cpi_sh(int8_t *);
extern void cpi_sh_lh_addi(int8_t *);
extern void cpi_sw(int8_t *);
extern void cpi_addi_sw_v0(int8_t *);
extern void cpi_addi_sw_v1(int8_t *);
extern void cpi_addi_sw_v2(int8_t *);
extern void cpi_sw_lw_addi(int8_t *);
extern void cpi_sd(int8_t *);
extern void cpi_sd_ld_addi(int8_t *);
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
extern void cpi_fake_plant_ct_bfu_x8();
extern void cpi_fake_plant_ct_bfu_x1();
extern void cpi_fake_plant_ct_bfu_x2();
extern void cpi_plant_gs_bfu_x1();
extern void cpi_plant_gs_bfu_x2();
extern void cpi_plant_gs_bfu_x4();
extern void cpi_plant_gs_bfu_x8();
extern void cpi_fake_plant_gs_bfu_x1();

extern int init_vector_e16();
extern int init_vector_e32();
extern void cpi_vle16(int8_t *buf);
extern void cpi_vle16_add(int8_t *buf);
extern void cpi_vle16_add_v2(int8_t *buf0, int8_t *buf1, int8_t *buf2,
                             int8_t *buf3);
extern void cpi_vse16(int8_t *buf0, int8_t *buf1, int8_t *buf2,
                      int8_t *buf3);
extern void cpi_vaddvv();
extern void cpi_vaddvx();
extern void cpi_vaddvx_x1();
extern void cpi_vaddvx_x2();
extern void cpi_vaddvx_x4();
extern void cpi_vandvv();
extern void cpi_vandvx();
extern void cpi_vandvx_and_hybrid_v1();
extern void cpi_vandvx_and_hybrid_v2();
extern void cpi_vandvx_and_hybrid_v3();
extern void cpi_vandvx_and_hybrid_v4();
extern void cpi_vandvx_and_hybrid_v4_1();
extern void cpi_vandvx_and_hybrid_v5();
extern void cpi_vandvx_and_hybrid_v6();
extern void cpi_vandvv_x1();
extern void cpi_vandvv_x2();
extern void cpi_vandvv_x4();
extern void cpi_vnotv();
extern void cpi_vnotv_x1();
extern void cpi_vnotv_x2();
extern void cpi_vnotv_x4();
extern void cpi_vxorvv();
extern void cpi_vxorvv_x1();
extern void cpi_vxorvv_x2();
extern void cpi_vxorvv_x4();
extern void cpi_vsllvi();
extern void cpi_vsllvi_x1();
extern void cpi_vsllvi_x2();
extern void cpi_vsllvi_x4();
extern void cpi_vsrlvx();
extern void cpi_vsrlvx_x1();
extern void cpi_vsrlvx_x2();
extern void cpi_vsrlvx_x4();
extern void cpi_vsravi();
extern void cpi_vsravi_x1();
extern void cpi_vsravi_x2();
extern void cpi_vsravi_x4();
extern void cpi_vmulvx();
extern void cpi_vmulvx_x1();
extern void cpi_vmulvx_x2();
extern void cpi_vmulvx_x4();
extern void cpi_vmulvv();
extern void cpi_vmulvv_x1();
extern void cpi_vmulvv_x2();
extern void cpi_vmulvv_x4();
extern void cpi_vmulhvv();
extern void cpi_vmulhvv_x1();
extern void cpi_vmulhvv_x2();
extern void cpi_vmulhvv_x4();
extern void cpi_vrgathervv();
extern void cpi_vrgathervv_x1();
extern void cpi_vrgathervv_x2();
extern void cpi_vrgathervv_x4();
extern void cpi_vmergevvm();
extern void cpi_vmergevvm_x1();
extern void cpi_vmergevvm_x2();
extern void cpi_vmergevvm_x4();

int main(void)
{
    int64_t buf[128];
#ifdef VECTOR128
    int vec_len = init_vector_e16();
    printf("init_vector_e16, the length of vector is %d bits\n",
           vec_len * 16);
    PERF(cpi_vle16((int8_t *)buf), cpi_vle16);
    PERF(cpi_vle16_add((int8_t *)buf), cpi_vle16_add);
    PERF(cpi_vle16_add_v2((int8_t *)buf, (int8_t *)&buf[2 * 1],
                          (int8_t *)&buf[2 * 2], (int8_t *)&buf[2 * 3]),
         cpi_vle16_add_v2);
    PERF(cpi_vse16((int8_t *)buf, (int8_t *)&buf[2 * 1],
                   (int8_t *)&buf[2 * 2], (int8_t *)&buf[2 * 3]),
         cpi_vse16);
    PERF(cpi_vaddvv(), cpi_vaddvv);
    PERF(cpi_vaddvx(), cpi_vaddvx);
    PERF(cpi_vaddvx_x1(), cpi_vaddvx_x1);
    PERF(cpi_vaddvx_x2(), cpi_vaddvx_x2);
    PERF(cpi_vaddvx_x4(), cpi_vaddvx_x4);
    PERF(cpi_vandvv(), cpi_vandvv);
    PERF(cpi_vandvx(), cpi_vandvx);
    PERF(cpi_vandvx_and_hybrid_v1(), cpi_vandvx_and_hybrid_v1);
    PERF(cpi_vandvx_and_hybrid_v2(), cpi_vandvx_and_hybrid_v2);
    PERF(cpi_vandvx_and_hybrid_v3(), cpi_vandvx_and_hybrid_v3);
    PERF(cpi_vandvx_and_hybrid_v4(), cpi_vandvx_and_hybrid_v4);
    PERF(cpi_vandvx_and_hybrid_v4_1(), cpi_vandvx_and_hybrid_v4_1);
    PERF(cpi_vandvx_and_hybrid_v5(), cpi_vandvx_and_hybrid_v5);
    PERF(cpi_vandvx_and_hybrid_v6(), cpi_vandvx_and_hybrid_v6);
    PERF(cpi_vandvv_x1(), cpi_vandvv_x1);
    PERF(cpi_vandvv_x2(), cpi_vandvv_x2);
    PERF(cpi_vandvv_x4(), cpi_vandvv_x4);
    PERF(cpi_vnotv(), cpi_vnotv);
    PERF(cpi_vnotv_x1(), cpi_vnotv_x1);
    PERF(cpi_vnotv_x2(), cpi_vnotv_x2);
    PERF(cpi_vnotv_x4(), cpi_vnotv_x4);
    PERF(cpi_vxorvv(), cpi_vxorvv);
    PERF(cpi_vxorvv_x1(), cpi_vxorvv_x1);
    PERF(cpi_vxorvv_x2(), cpi_vxorvv_x2);
    PERF(cpi_vxorvv_x4(), cpi_vxorvv_x4);
    PERF(cpi_vsllvi(), cpi_vsllvi);
    PERF(cpi_vsllvi_x1(), cpi_vsllvi_x1);
    PERF(cpi_vsllvi_x2(), cpi_vsllvi_x2);
    PERF(cpi_vsllvi_x4(), cpi_vsllvi_x4);
    PERF(cpi_vsrlvx(), cpi_vsrlvx);
    PERF(cpi_vsrlvx_x1(), cpi_vsrlvx_x1);
    PERF(cpi_vsrlvx_x2(), cpi_vsrlvx_x2);
    PERF(cpi_vsrlvx_x4(), cpi_vsrlvx_x4);
    PERF(cpi_vsravi(), cpi_vsravi);
    PERF(cpi_vsravi_x1(), cpi_vsravi_x1);
    PERF(cpi_vsravi_x2(), cpi_vsravi_x2);
    PERF(cpi_vsravi_x4(), cpi_vsravi_x4);
    PERF(cpi_vmulvx(), cpi_vmulvx);
    PERF(cpi_vmulvx_x1(), cpi_vmulvx_x1);
    PERF(cpi_vmulvx_x2(), cpi_vmulvx_x2);
    PERF(cpi_vmulvx_x4(), cpi_vmulvx_x4);
    PERF(cpi_vmulvv(), cpi_vmulvv);
    PERF(cpi_vmulvv_x1(), cpi_vmulvv_x1);
    PERF(cpi_vmulvv_x2(), cpi_vmulvv_x2);
    PERF(cpi_vmulvv_x4(), cpi_vmulvv_x4);
    PERF(cpi_vrgathervv(), cpi_vrgathervv);
    PERF(cpi_vrgathervv_x1(), cpi_vrgathervv_x1);
    PERF(cpi_vrgathervv_x2(), cpi_vrgathervv_x2);
    PERF(cpi_vrgathervv_x4(), cpi_vrgathervv_x4);
    PERF(cpi_vmergevvm(), cpi_vmergevvm);
    PERF(cpi_vmergevvm_x1(), cpi_vmergevvm_x1);
    PERF(cpi_vmergevvm_x2(), cpi_vmergevvm_x2);
    PERF(cpi_vmergevvm_x4(), cpi_vmergevvm_x4);
    vec_len = init_vector_e32();
    printf("\ninit_vector_e32, the length of vector is %d bits\n",
           vec_len * 32);
    PERF(cpi_vaddvv(), cpi_vaddvv);
    PERF(cpi_vaddvx(), cpi_vaddvx);
    PERF(cpi_vaddvx_x1(), cpi_vaddvx_x1);
    PERF(cpi_vaddvx_x2(), cpi_vaddvx_x2);
    PERF(cpi_vaddvx_x4(), cpi_vaddvx_x4);
    PERF(cpi_vandvv(), cpi_vandvv);
    PERF(cpi_vandvx(), cpi_vandvx);
    PERF(cpi_vandvv_x1(), cpi_vandvv_x1);
    PERF(cpi_vandvv_x2(), cpi_vandvv_x2);
    PERF(cpi_vandvv_x4(), cpi_vandvv_x4);
    PERF(cpi_vnotv(), cpi_vnotv);
    PERF(cpi_vnotv_x1(), cpi_vnotv_x1);
    PERF(cpi_vnotv_x2(), cpi_vnotv_x2);
    PERF(cpi_vnotv_x4(), cpi_vnotv_x4);
    PERF(cpi_vxorvv(), cpi_vxorvv);
    PERF(cpi_vxorvv_x1(), cpi_vxorvv_x1);
    PERF(cpi_vxorvv_x2(), cpi_vxorvv_x2);
    PERF(cpi_vxorvv_x4(), cpi_vxorvv_x4);
    PERF(cpi_vsllvi(), cpi_vsllvi);
    PERF(cpi_vsllvi_x1(), cpi_vsllvi_x1);
    PERF(cpi_vsllvi_x2(), cpi_vsllvi_x2);
    PERF(cpi_vsllvi_x4(), cpi_vsllvi_x4);
    PERF(cpi_vsrlvx(), cpi_vsrlvx);
    PERF(cpi_vsrlvx_x1(), cpi_vsrlvx_x1);
    PERF(cpi_vsrlvx_x2(), cpi_vsrlvx_x2);
    PERF(cpi_vsrlvx_x4(), cpi_vsrlvx_x4);
    PERF(cpi_vsravi(), cpi_vsravi);
    PERF(cpi_vsravi_x1(), cpi_vsravi_x1);
    PERF(cpi_vsravi_x2(), cpi_vsravi_x2);
    PERF(cpi_vsravi_x4(), cpi_vsravi_x4);
    PERF(cpi_vmulvx(), cpi_vmulvx);
    PERF(cpi_vmulvx_x1(), cpi_vmulvx_x1);
    PERF(cpi_vmulvx_x2(), cpi_vmulvx_x2);
    PERF(cpi_vmulvx_x4(), cpi_vmulvx_x4);
    PERF(cpi_vmulvv(), cpi_vmulvv);
    PERF(cpi_vmulvv_x1(), cpi_vmulvv_x1);
    PERF(cpi_vmulvv_x2(), cpi_vmulvv_x2);
    PERF(cpi_vmulvv_x4(), cpi_vmulvv_x4);
    PERF(cpi_vrgathervv(), cpi_vrgathervv);
    PERF(cpi_vrgathervv_x1(), cpi_vrgathervv_x1);
    PERF(cpi_vrgathervv_x2(), cpi_vrgathervv_x2);
    PERF(cpi_vrgathervv_x4(), cpi_vrgathervv_x4);
    PERF(cpi_vmergevvm(), cpi_vmergevvm);
    PERF(cpi_vmergevvm_x1(), cpi_vmergevvm_x1);
    PERF(cpi_vmergevvm_x2(), cpi_vmergevvm_x2);
    PERF(cpi_vmergevvm_x4(), cpi_vmergevvm_x4);
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
    PERF(cpi_lh((int8_t *)buf), cpi_lh);
    PERF(cpi_lh_addi((int8_t *)buf), cpi_lh_addi);
    PERF(cpi_lw((int8_t *)buf), cpi_lw);
    PERF(cpi_lw_addi((int8_t *)buf), cpi_lw_addi);
#    ifdef RV64
    PERF(cpi_ld((int8_t *)buf), cpi_ld);
    PERF(cpi_ld_addi((int8_t *)buf), cpi_ld_addi);
#    endif
    PERF(cpi_sh((int8_t *)buf), cpi_sh);
    PERF(cpi_sh_lh_addi((int8_t *)buf), cpi_sh_lh_addi);
    PERF(cpi_sw((int8_t *)buf), cpi_sw);
    PERF(cpi_addi_sw_v0((int8_t *)buf), cpi_addi_sw_v0);
    PERF(cpi_addi_sw_v1((int8_t *)buf), cpi_addi_sw_v1);
    PERF(cpi_addi_sw_v2((int8_t *)buf), cpi_addi_sw_v2);
    PERF(cpi_sw_lw_addi((int8_t *)buf), cpi_sw_lw_addi);
#    ifdef RV64
    PERF(cpi_sd((int8_t *)buf), cpi_sd);
    PERF(cpi_sd_ld_addi((int8_t *)buf), cpi_sd_ld_addi);
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
    PERF(cpi_fake_plant_ct_bfu_x8(), cpi_fake_plant_ct_bfu_x8);
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