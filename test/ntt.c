#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "cpucycles.h"
#include "speed_print.h"

#define KYBER_N 256
#define KYBER_Q 3329
#define MONT -1044  // 2^16 mod q
#define QINV -3327  // q^-1 mod 2^16

const int16_t zetas[128] = {
    -1044, -758,  -359,  -1517, 1493,  1422,  287,   202,  -171,  622,   1577,
    182,   962,   -1202, -1474, 1468,  573,   -1325, 264,  383,   -829,  1458,
    -1602, -130,  -681,  1017,  732,   608,   -1542, 411,  -205,  -1571, 1223,
    652,   -552,  1015,  -1293, 1491,  -282,  -1544, 516,  -8,    -320,  -666,
    -1618, -1162, 126,   1469,  -853,  -90,   -271,  830,  107,   -1421, -247,
    -951,  -398,  961,   -1508, -725,  448,   -1065, 677,  -1275, -1103, 430,
    555,   843,   -1251, 871,   1550,  105,   422,   587,  177,   -235,  -291,
    -460,  1574,  1653,  -246,  778,   1159,  -147,  -777, 1483,  -602,  1119,
    -1590, 644,   -872,  349,   418,   329,   -156,  -75,  817,   1097,  603,
    610,   1322,  -1285, -1465, 384,   -1215, -136,  1218, -1335, -874,  220,
    -1187, -1659, -1185, -1530, -1278, 794,   -1510, -854, -870,  478,   -108,
    -308,  996,   991,   958,   -1460, 1522,  1628};

int16_t montgomery_reduce(int32_t a)
{
    int16_t t;

    t = (int16_t)a * QINV;
    t = (a - (int32_t)t * KYBER_Q) >> 16;
    return t;
}

int16_t barrett_reduce(int16_t a)
{
    int16_t t;
    const int16_t v = ((1 << 26) + KYBER_Q / 2) / KYBER_Q;

    t = ((int32_t)v * a + (1 << 25)) >> 26;
    t *= KYBER_Q;
    return a - t;
}

int16_t fqmul(int16_t a, int16_t b)
{
    return montgomery_reduce((int32_t)a * b);
}

void ntt(int16_t r[256])
{
    unsigned int len, start, j, k;
    int16_t t, zeta;

    k = 1;
    for (len = 128; len >= 2; len >>= 1) {
        for (start = 0; start < 256; start = j + len) {
            zeta = zetas[k++];
            for (j = start; j < start + len; j++) {
                t = fqmul(zeta, r[j + len]);
                r[j + len] = r[j] - t;
                r[j] = r[j] + t;
            }
        }
    }
}

void invntt(int16_t r[256])
{
    unsigned int start, len, j, k;
    int16_t t, zeta;
    const int16_t f = 1441;  // mont^2/128

    k = 127;
    for (len = 2; len <= 128; len <<= 1) {
        for (start = 0; start < 256; start = j + len) {
            zeta = zetas[k--];
            for (j = start; j < start + len; j++) {
                t = r[j];
                r[j] = barrett_reduce(t + r[j + len]);
                r[j + len] = r[j + len] - t;
                r[j + len] = fqmul(zeta, r[j + len]);
            }
        }
    }

    for (j = 0; j < 256; j++)
        r[j] = fqmul(r[j], f);
}

void basemul(int16_t r[2], const int16_t a[2], const int16_t b[2], int16_t zeta)
{
    r[0] = fqmul(a[1], b[1]);
    r[0] = fqmul(r[0], zeta);
    r[0] += fqmul(a[0], b[0]);
    r[1] = fqmul(a[0], b[1]);
    r[1] += fqmul(a[1], b[0]);
}

void print_poly(int16_t *a, size_t n)
{
    int i;
    for (i = 0; i < n; i++) {
        if (i != 0 && i % 8 == 0)
            printf("\n");
        printf("%d, ", a[i]);
    }
    printf("\n\n");
}

extern const int16_t qdata[632];
extern void ntt_rvv(int16_t r[KYBER_N], const int16_t *table);
extern void to_normal_order(int16_t r[KYBER_N], const int16_t *table);

extern void test_shuffle4(int16_t r[16], const int16_t *table);
extern void test_shuffle2(int16_t r[16], const int16_t *table);
extern void test_shuffle1(int16_t r[16], const int16_t *table);
extern void test_unpack(int16_t r[16 * 4], const int16_t *table);

#define NTESTS 10000

uint64_t t[NTESTS];

int main()
{
    int i;
    int16_t a[KYBER_N], b[KYBER_N];
    for (i = 0; i < KYBER_N; i++)
        a[i] = b[i] = i * 10 + i;
    ntt(a);
    ntt_rvv(b, qdata);
    to_normal_order(b, qdata);
    if (memcmp(a, b, sizeof(a)) == 0)
        printf("all right\n");
    else {
        printf("error\n");
        print_poly(a, 256);
        print_poly(b, 256);
    }

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        ntt(a);
    }
    print_results("ntt: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        ntt_rvv(b, qdata);
    }
    print_results("ntt_rvv: ", t, NTESTS);

    // for (i = 0; i < KYBER_N; i++)
    //     a[i] = b[i] = i;

    // print_poly(a, 8);
    // print_poly(a + 8, 8);
    // test_shuffle4(a, qdata);
    // print_poly(a, 8);
    // print_poly(a + 8, 8);

    // test_shuffle2(a, qdata);
    // print_poly(a, 8);
    // print_poly(a + 8, 8);

    int16_t t[16] = {0, 1, 4, 5, 8, 9, 12, 13, 16, 17, 20, 21, 24, 25, 28, 29};
    test_shuffle1(t, qdata);
    print_poly(t, 8);
    print_poly(t + 8, 8);

    int16_t t1[16 * 4] = {0,  4,  8,  12, 16, 20, 24, 28, 1,  5,  9,
                          13, 17, 21, 25, 29, 2,  6,  10, 14, 18, 22,
                          26, 30, 3,  7,  11, 15, 19, 23, 27, 31};
    test_unpack(t1, qdata);
    print_poly(t1, 8);
    print_poly(t1 + 8, 8);
    print_poly(t1 + 16, 8);
    print_poly(t1 + 24, 8);
    return 0;
}