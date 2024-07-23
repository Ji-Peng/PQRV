#include <stdint.h>
#include <stdio.h>

#include "cpucycles.h"
#include "speed_print.h"

#define NTESTS 10000

uint64_t t[NTESTS];

extern void init_vector_e32_m1();
extern void init_vector_e32_m8();

extern void cpi_m1_vle32(int32_t *a);
extern void cpi_m1_vlse32(int32_t *a);
extern void cpi_m1_vmulvx();
extern void cpi_m1_vle32_vmul_vse32();
extern void cpi_m1_vle32_vmul_vse32_opt();
extern void cpi_m1_vle32_vmul_vse32_opt_v2();

extern void cpi_m8_vle32(int32_t *a);
extern void cpi_m8_vlse32(int32_t *a);
extern void cpi_m8_vmulvx();
extern void cpi_m8_vle32_vmul_vse32();

int main(void)
{
    int32_t buf[256];
    init_vector_e32_m1();
    PERF(cpi_m1_vle32(buf), cpi_m1_vle32);
    PERF(cpi_m1_vlse32(buf), cpi_m1_vlse32);
    PERF(cpi_m1_vmulvx(), cpi_m1_vmulvx);
    PERF(cpi_m1_vle32_vmul_vse32(buf), cpi_m1_vle32_vmul_vse32);
    PERF(cpi_m1_vle32_vmul_vse32_opt(buf), cpi_m1_vle32_vmul_vse32_opt);
    PERF(cpi_m1_vle32_vmul_vse32_opt_v2(buf),
         cpi_m1_vle32_vmul_vse32_opt_v2);

    init_vector_e32_m8();
    PERF(cpi_m8_vle32(buf), cpi_m8_vle32);
    PERF(cpi_m8_vlse32(buf), cpi_m8_vlse32);
    PERF(cpi_m8_vmulvx(), cpi_m8_vmulvx);
    PERF(cpi_m8_vle32_vmul_vse32(buf), cpi_m8_vle32_vmul_vse32);
    return 0;
}