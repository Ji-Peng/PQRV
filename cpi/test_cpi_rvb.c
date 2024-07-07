#include <stdint.h>
#include <stdio.h>

#include "cpucycles.h"
#include "speed_print.h"

#define NTESTS 10000

uint64_t t[NTESTS];

extern void cpi_rori();
extern void cpi_rori_x1();
extern void cpi_rori_x2();
extern void cpi_rori_x4();
extern void cpi_andn();
extern void cpi_andn_x1();
extern void cpi_andn_x2();
extern void cpi_andn_x4();

int main(void)
{
    PERF(cpi_rori(), cpi_rori);
    PERF(cpi_rori_x1(), cpi_rori_x1);
    PERF(cpi_rori_x2(), cpi_rori_x2);
    PERF(cpi_rori_x4(), cpi_rori_x4);
    PERF(cpi_andn(), cpi_andn);
    PERF(cpi_andn_x1(), cpi_andn_x1);
    PERF(cpi_andn_x2(), cpi_andn_x2);
    PERF(cpi_andn_x4(), cpi_andn_x4);
    return 0;
}