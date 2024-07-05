#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "cpucycles.h"
#include "ntt_rvv.h"
#include "speed_print.h"

#define KYBER_N 256
#define KYBER_Q 3329
#define KYBER_ROOT_OF_UNITY 17

const int16_t zetas_ref[128] = {
    -1044, -758,  -359,  -1517, 1493,  1422,  287,   202,   -171,  622,
    1577,  182,   962,   -1202, -1474, 1468,  573,   -1325, 264,   383,
    -829,  1458,  -1602, -130,  -681,  1017,  732,   608,   -1542, 411,
    -205,  -1571, 1223,  652,   -552,  1015,  -1293, 1491,  -282,  -1544,
    516,   -8,    -320,  -666,  -1618, -1162, 126,   1469,  -853,  -90,
    -271,  830,   107,   -1421, -247,  -951,  -398,  961,   -1508, -725,
    448,   -1065, 677,   -1275, -1103, 430,   555,   843,   -1251, 871,
    1550,  105,   422,   587,   177,   -235,  -291,  -460,  1574,  1653,
    -246,  778,   1159,  -147,  -777,  1483,  -602,  1119,  -1590, 644,
    -872,  349,   418,   329,   -156,  -75,   817,   1097,  603,   610,
    1322,  -1285, -1465, 384,   -1215, -136,  1218,  -1335, -874,  220,
    -1187, -1659, -1185, -1530, -1278, 794,   -1510, -854,  -870,  478,
    -108,  -308,  996,   991,   958,   -1460, 1522,  1628};

int16_t montgomery_reduce_ref(int32_t a)
{
    int16_t t;
    int16_t qinv = -3327;  // q^-1 mod 2^16

    t = (int16_t)a * qinv;
    t = (a - (int32_t)t * KYBER_Q) >> 16;
    return t;
}
int16_t barrett_reduce_ref(int16_t a)
{
    int16_t t;
    const int16_t v = ((1 << 26) + KYBER_Q / 2) / KYBER_Q;

    t = ((int32_t)v * a + (1 << 25)) >> 26;
    t *= KYBER_Q;
    return a - t;
}

static int16_t fqmul(int16_t a, int16_t b)
{
    return montgomery_reduce_ref((int32_t)a * b);
}
void ntt_ref(int16_t r[256])
{
    unsigned int len, start, j, k;
    int16_t t, zeta;

    k = 1;
    for (len = 128; len >= 2; len >>= 1) {
        for (start = 0; start < 256; start = j + len) {
            zeta = zetas_ref[k++];
            for (j = start; j < start + len; j++) {
                t = fqmul(zeta, r[j + len]);
                r[j + len] = r[j] - t;
                r[j] = r[j] + t;
            }
        }
    }
}

void intt_ref(int16_t r[256])
{
    unsigned int start, len, j, k;
    int16_t t, zeta;
    const int16_t f = 1441;  // mont^2/128

    k = 127;
    for (len = 2; len <= 128; len <<= 1) {
        for (start = 0; start < 256; start = j + len) {
            zeta = zetas_ref[k--];
            for (j = start; j < start + len; j++) {
                t = r[j];
                r[j] = barrett_reduce_ref(t + r[j + len]);
                r[j + len] = r[j + len] - t;
                r[j + len] = fqmul(zeta, r[j + len]);
            }
        }
    }

    for (j = 0; j < 256; j++)
        r[j] = fqmul(r[j], f);
}

void basemul_ref(int16_t r[2], const int16_t a[2], const int16_t b[2],
                 int16_t zeta)
{
    r[0] = fqmul(a[1], b[1]);
    r[0] = fqmul(r[0], zeta);
    r[0] += fqmul(a[0], b[0]);
    r[1] = fqmul(a[0], b[1]);
    r[1] += fqmul(a[1], b[0]);
}
void poly_basemul_ref(int16_t *r, int16_t *a, int16_t *b)
{
    unsigned int i;
    for (i = 0; i < KYBER_N / 4; i++) {
        basemul_ref(&r[4 * i], &a[4 * i], &b[4 * i], zetas_ref[64 + i]);
        basemul_ref(&r[4 * i + 2], &a[4 * i + 2], &b[4 * i + 2],
                    -zetas_ref[64 + i]);
    }
}

void poly_tomont_ref(int16_t *r)
{
    unsigned int i;
    const int16_t f = (1ULL << 32) % KYBER_Q;
    for (i = 0; i < KYBER_N; i++)
        r[i] = montgomery_reduce_ref((int32_t)r[i] * f);
}
void print_poly(int16_t *a, size_t n)
{
    int i;
    for (i = 0; i < n; i++) {
        if (i != 0 && i % 16 == 0)
            printf("\n");
        printf("%d, ", a[i]);
    }
    printf("\n\n");
}

int poly_equal(int16_t *a, int16_t *b, size_t n)
{
    size_t i;
    int ok = 1;
    for (i = 0; i < n; i++) {
        if (((a[i] + KYBER_Q * 10) % KYBER_Q) !=
            ((b[i] + KYBER_Q * 10) % KYBER_Q)) {
            ok = 0;
            break;
        }
    }
    return ok;
}

#define NTESTS 1000
uint64_t t[NTESTS];

int main()
{
    int16_t a[KYBER_N], b[KYBER_N], c0[KYBER_N], c1[KYBER_N], i, j;

    for (i = 0; i < KYBER_N; i++)
        a[i] = 1;
    for (i = 0; i < KYBER_N; i++)
        b[i] = 1;
    ntt_ref(a);
    ntt_rvv(b, qdata);
    ntt2normal_order(b, b, qdata);
    if (poly_equal(a, b, KYBER_N) != 1) {
        print_poly(a, KYBER_N);
        print_poly(b, KYBER_N);
    }

    return 0;
}