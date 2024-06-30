#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "cpucycles.h"
#include "ntt_rvv.h"
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

void intt(int16_t r[256])
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

void poly_basemul(int16_t *r, int16_t *a, int16_t *b)
{
    int i;
    for (i = 0; i < KYBER_N / 4; i++) {
        basemul(&r[4 * i], &a[4 * i], &b[4 * i], zetas[64 + i]);
        basemul(&r[4 * i + 2], &a[4 * i + 2], &b[4 * i + 2], -zetas[64 + i]);
    }
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

void print_poly_mod(int16_t *a, size_t n)
{
    int i;
    for (i = 0; i < n; i++) {
        if (i != 0 && i % 8 == 0)
            printf("\n");
        printf("%d, ", (a[i] + 3329 * 10) % 3329);
    }
    printf("\n\n");
}

int poly_equal(int16_t *a, int16_t *b, size_t n)
{
    size_t i;
    int ok = 1;
    for (i = 0; i < n; i++) {
        if (((a[i] + 3329 * 10) % 3329) != ((b[i] + 3329 * 10) % 3329)) {
            ok = 0;
            break;
        }
    }
    return ok;
}

#define NTESTS 10000

uint64_t t[NTESTS];

void test_ntt()
{
    int i;
    int16_t a[KYBER_N], b[KYBER_N];
    for (i = 0; i < KYBER_N; i++)
        a[i] = b[i] = i * 10 + i;
    ntt(a);
    ntt_rvv(b, qdata);
    ntt2normal_order(b, b, qdata);
    if (memcmp(a, b, sizeof(a)) == 0)
        printf("ntt all right\n");
    else {
        printf("error\n");
        print_poly(a, 256);
        print_poly(b, 256);
    }
}

void test_basemul()
{
    int i;
    int16_t a0[KYBER_N], b0[KYBER_N], r0[KYBER_N];
    int16_t a1[KYBER_N], b1[KYBER_N], r1[KYBER_N], b1_buf[KYBER_N >> 1];
    for (i = 0; i < KYBER_N; i++)
        a0[i] = b0[i] = a1[i] = b1[i] = i;
    ntt(a0);
    ntt(b0);
    poly_basemul(r0, a0, b0);
    ntt_rvv(a1, qdata);
    ntt_rvv(b1, qdata);
    poly_basemul_rvv(r1, a1, b1, qdata);
    ntt2normal_order(r1, r1, qdata);
    if (poly_equal(r0, r1, 256))
        printf("basemul all right\n");
    else {
        printf("basemul error\n");
        print_poly(r0, 256);
        print_poly(r1, 256);
    }

    for (i = 0; i < KYBER_N; i++)
        a0[i] = b0[i] = a1[i] = b1[i] = i;
    ntt(a0);
    ntt(b0);
    poly_basemul(r0, a0, b0);
    ntt_rvv(a1, qdata);
    ntt_rvv(b1, qdata);
    poly_basemul_cache_init_rvv(r1, a1, b1, qdata, b1_buf);
    poly_basemul_cached_rvv(r1, a1, b1, qdata, b1_buf);
    ntt2normal_order(r1, r1, qdata);
    if (poly_equal(r0, r1, 256))
        printf("basemul_cache_init/cached all right\n");
    else {
        printf("basemul_cache_init/cached error\n");
        print_poly(r0, 256);
        print_poly(r1, 256);
    }
}

void test_order()
{
    int16_t r[256] = {0,  2,  4,  6,  8,  10, 12, 14, 1,  3,  5,
                      7,  9,  11, 13, 15, 16, 18, 20, 22, 24, 26,
                      28, 30, 17, 19, 21, 23, 25, 27, 29, 31};
    print_poly(r, 32);
    ntt2normal_order(r, r, qdata);
    print_poly(r, 32);
    normal2ntt_order(r, r, qdata);
    print_poly(r, 32);
}

void test_intt()
{
    int i;
    int16_t a0[KYBER_N], b0[KYBER_N], r0[KYBER_N];
    int16_t a1[KYBER_N], b1[KYBER_N], r1[KYBER_N];

    for (i = 0; i < KYBER_N; i++)
        a0[i] = b0[i] = a1[i] = b1[i] = i * 10 + i;
    ntt(a0);
    intt(a0);

    ntt_rvv(a1, qdata);
    intt_rvv(a1, qdata);

    if (poly_equal(a0, a1, 256)) {
        printf("intt all right\n");
    } else {
        printf("intt error\n");
        print_poly_mod(a0, 256);
        print_poly_mod(a1, 256);
    }
}

void test_poly_reduce()
{
    int16_t a[KYBER_N];
    for (int i = 0; i < KYBER_N; i++) {
        a[i] = -3329;
    }
    poly_reduce_rvv(a);
    print_poly(a, 16);
}

int main()
{
    int i;
    int16_t a[KYBER_N], b[KYBER_N], b_buf[KYBER_N >> 1];

    test_ntt();
    test_basemul();
    test_intt();
    // test_poly_reduce();
    // test_order();

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

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul(a, b, b);
    }
    print_results("poly_basemul: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_rvv(a, a, b, qdata);
    }
    print_results("poly_basemul_rvv: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_cache_init_rvv(a, a, b, qdata, b_buf);
    }
    print_results("poly_basemul_cache_init_rvv: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_cached_rvv(a, a, b, qdata, b_buf);
    }
    print_results("poly_basemul_cached_rvv: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        intt(a);
    }
    print_results("intt: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        intt_rvv(b, qdata);
    }
    print_results("intt_rvv: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        ntt2normal_order(b, b, qdata);
    }
    print_results("ntt2normal_order: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        normal2ntt_order(b, b, qdata);
    }
    print_results("normal2ntt_order: ", t, NTESTS);

    return 0;
}