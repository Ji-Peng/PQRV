#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "cpucycles.h"
#include "speed_print.h"

#define KYBER_N 256
#define KYBER_Q 3329
#define KYBER_K 2
#define QINV 0x3c0f12886ba8f301       // q^-1 mod 2^64
#define PLANT_CONST 0x13afb7680bb055  // (((-2**64) % q) * qinv) % (2**64)
#define PLANT_CONST2 \
    0x1a390f4d9791e139     // (((-2**64) % q) * ((-2**64) % q) * qinv) % (2**64)
#define Q32 0xd0100000000  // q << 32

extern int64_t plant_mul_rv64im(int64_t a, int64_t bqinv);

int64_t plant_mul_rv64_c(int64_t a, int64_t bqinv)
{
    int64_t t;
    t = a * bqinv;
    t = t >> 32;
    t = t + 8;
    t = ((__int128_t)t * Q32) >> 64;
    return t;
}

int64_t plant_mul_rv64_c_v2(int64_t a, int64_t bqinv)
{
    int64_t t;
    t = a * bqinv;
    t = t >> 32;
    t = t * KYBER_Q + ((int64_t)1 << 31);
    t = t >> 32;
    return t;
}

int main()
{
    int64_t t;
    t = plant_mul_rv64_c(1, (int64_t)1 * QINV);
    t = plant_mul_rv64_c(t, PLANT_CONST2);
    printf("%ld\n", t);
    t = plant_mul_rv64_c_v2(1, (int64_t)1 * QINV);
    t = plant_mul_rv64_c_v2(t, PLANT_CONST2);
    printf("%ld\n", t);
    t = plant_mul_rv64im(1, (int64_t)1 * QINV);
    t = plant_mul_rv64im(t, PLANT_CONST2);
    printf("%ld\n", t);
    return 0;
}
