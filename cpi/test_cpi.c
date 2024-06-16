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
extern void cpi_muladd();
extern void cpi_mulx1addx2();
extern void cpi_mulx2addx4();
extern void cpi_mulx1addx3();
extern void cpi_mulx1addx4();
extern void cpi_shiftxor();
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

int main(void)
{
    // PERF(cpi_add(), cpi_add);
    // PERF(cpi_addi(), cpi_addi);
    // PERF(cpi_addi_forward(), cpi_addi_forward);
    // PERF(cpi_xor(), cpi_xor);
    // PERF(cpi_xori(), cpi_xori);
    // PERF(cpi_addxor(), cpi_addxor);
    // PERF(cpi_addxor_forward(), cpi_addxor_forward);
    // PERF(cpi_mul_mulh(), cpi_mul_mulh);
    // PERF(cpi_mul(), cpi_mul);
    // PERF(cpi_mulh(), cpi_mulh);
    // PERF(cpi_muladd(), cpi_muladd);
    // PERF(cpi_mulx1addx2(), cpi_mulx1addx2);
    // PERF(cpi_mulx2addx4(), cpi_mulx2addx4);
    // PERF(cpi_mulx1addx3(), cpi_mulx1addx3);
    // PERF(cpi_mulx1addx4(), cpi_mulx1addx4);
    // PERF(cpi_shiftxor(), cpi_shiftxor);
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
    return 0;
}