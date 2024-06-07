#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "cpucycles.h"
#include "ntt_rv32im.h"
#include "speed_print.h"

#define N 256
#define Q 8380417
#define ROOT_OF_UNITY 1753
#define MONT -4186625   // 2^32 % Q
#define R2modQ 2365951  // 2^64 % Q
#define QINV 58728449   // q^(-1) mod 2^32
#define INVN -32736     // N^-1 mod Q

int32_t zetas_ntt[] = {
    25847,    -2608894, -518909,  237124,   -777960,  -876248,  466468,
    1826347,  2353451,  -359251,  -2091905, 3119733,  -2884855, 3111497,
    2680103,  2725464,  1024112,  -1079900, 3585928,  -549488,  -1119584,
    2619752,  -2108549, -2118186, -3859737, -1399561, -3277672, 1757237,
    -19422,   4010497,  280005,   2706023,  95776,    3077325,  3530437,
    -1661693, -3592148, -2537516, 3915439,  -3861115, -3043716, 3574422,
    -2867647, 3539968,  -300467,  2348700,  -539299,  -1699267, -1643818,
    3505694,  -3821735, 3507263,  -2140649, -1600420, 3699596,  811944,
    531354,   954230,   3881043,  3900724,  -2556880, 2071892,  -2797779};

int32_t zetas_intt[] = {
    2797779,  -2071892, 2556880,  -3900724, -3881043, -954230,  -531354,
    -811944,  -3699596, 1600420,  2140649,  -3507263, 3821735,  -3505694,
    1643818,  1699267,  539299,   -2348700, 300467,   -3539968, 2867647,
    -3574422, 3043716,  3861115,  -3915439, 2537516,  3592148,  1661693,
    -3530437, -3077325, -95776,   -2706023, -280005,  -4010497, 19422,
    -1757237, 3277672,  1399561,  3859737,  2118186,  2108549,  -2619752,
    1119584,  549488,   -3585928, 1079900,  -1024112, -2725464, -2680103,
    -3111497, 2884855,  -3119733, 2091905,  359251,   -2353451, -1826347,
    -466468,  876248,   777960,   -237124,  518909,   2608894,  -25847};

int32_t zetas_basemul[] = {
    2706023,  95776,    3077325,  3530437,  -1661693, -3592148, -2537516,
    3915439,  -3861115, -3043716, 3574422,  -2867647, 3539968,  -300467,
    2348700,  -539299,  -1699267, -1643818, 3505694,  -3821735, 3507263,
    -2140649, -1600420, 3699596,  811944,   531354,   954230,   3881043,
    3900724,  -2556880, 2071892,  -2797779};

int32_t zetas_33merging_ntt[] = {
    25847,    1830765815,  -2608894, -1929875198, -518909,  -1927777021,
    237124,   1640767044,  -777960,  1477910808,  -876248,  1612161320,
    466468,   1640734244,  1826347,  308362795,   2725464,  1727305304,
    1024112,  2082316400,  2706023,  -1846138265, 95776,    -1631226336,
    3077325,  -1404529459, 3530437,  1838055109,  2353451,  -1815525077,
    -1079900, -1364982364, 3585928,  858240904,   -1661693, 1594295555,
    -3592148, -1076973524, -2537516, -1898723372, 3915439,  -594436433,
    -359251,  -1374673747, -549488,  1806278032,  -1119584, 222489248,
    -3861115, -202001019,  -3043716, -475984260,  3574422,  -561427818,
    -2867647, 1797021249,  -2091905, -1091570561, 2619752,  -346752664,
    -2108549, 684667771,   3539968,  -1061813248, -300467,  2059733581,
    2348700,  -1661512036, -539299,  -1104976547, 3119733,  -1929495947,
    -2118186, 1654287830,  -3859737, -878576921,  -1699267, -1750224323,
    -1643818, -901666090,  3505694,  418987550,   -3821735, 1831915353,
    -2884855, 515185417,   -1399561, -1257667337, -3277672, -748618600,
    3507263,  -1925356481, -2140649, 992097815,   -1600420, 879957084,
    3699596,  2024403852,  3111497,  -285697463,  1757237,  329347125,
    -19422,   1837364258,  811944,   1484874664,  531354,   -1636082790,
    954230,   -285388938,  3881043,  -1983539117, 2680103,  625853735,
    4010497,  -1443016191, 280005,   -1170414139, 3900724,  -1495136972,
    -2556880, -950076368,  2071892,  -1714807468, -2797779, -952438995,
};

int32_t zetas_33merging_intt[] = {
    2797779,  952438995,   -2071892, 1714807468,  2556880,  950076368,
    -3900724, 1495136972,  -280005,  1170414139,  -4010497, 1443016191,
    -2680103, -625853735,  -3881043, 1983539117,  -954230,  285388938,
    -531354,  1636082790,  -811944,  -1484874664, 19422,    -1837364258,
    -1757237, -329347125,  -3111497, 285697463,   -3699596, -2024403852,
    1600420,  -879957084,  2140649,  -992097815,  -3507263, 1925356481,
    3277672,  748618600,   1399561,  1257667337,  2884855,  -515185417,
    3821735,  -1831915353, -3505694, -418987550,  1643818,  901666090,
    1699267,  1750224323,  3859737,  878576921,   2118186,  -1654287830,
    -3119733, 1929495947,  539299,   1104976547,  -2348700, 1661512036,
    300467,   -2059733581, -3539968, 1061813248,  2108549,  -684667771,
    -2619752, 346752664,   2091905,  1091570561,  2867647,  -1797021249,
    -3574422, 561427818,   3043716,  475984260,   3861115,  202001019,
    1119584,  -222489248,  549488,   -1806278032, 359251,   1374673747,
    -3915439, 594436433,   2537516,  1898723372,  3592148,  1076973524,
    1661693,  -1594295555, -3585928, -858240904,  1079900,  1364982364,
    -2353451, 1815525077,  -3530437, -1838055109, -3077325, 1404529459,
    -95776,   1631226336,  -2706023, 1846138265,  -1024112, -2082316400,
    -2725464, -1727305304, -1826347, -308362795,  -466468,  -1640734244,
    876248,   -1612161320, 777960,   -1477910808, -237124,  -1640767044,
    518909,   1927777021,  2608894,  1929875198,  -857982,  604186754,
};

int32_t zetas_33merging_basemul[] = {
    2706023,  -1846138265, 95776,    -1631226336, 3077325,  -1404529459,
    3530437,  1838055109,  -1661693, 1594295555,  -3592148, -1076973524,
    -2537516, -1898723372, 3915439,  -594436433,  -3861115, -202001019,
    -3043716, -475984260,  3574422,  -561427818,  -2867647, 1797021249,
    3539968,  -1061813248, -300467,  2059733581,  2348700,  -1661512036,
    -539299,  -1104976547, -1699267, -1750224323, -1643818, -901666090,
    3505694,  418987550,   -3821735, 1831915353,  3507263,  -1925356481,
    -2140649, 992097815,   -1600420, 879957084,   3699596,  2024403852,
    811944,   1484874664,  531354,   -1636082790, 954230,   -285388938,
    3881043,  -1983539117, 3900724,  -1495136972, -2556880, -950076368,
    2071892,  -1714807468, -2797779, -952438995,
};

int32_t montgomery_reduce(int64_t a)
{
    int32_t t;

    t = (int64_t)(int32_t)a * QINV;
    t = (a - (int64_t)t * Q) >> 32;
    return t;
}

void ntt(int32_t a[N])
{
    unsigned int len, start, j, k;
    int32_t zeta, t;

    k = 0;
    // len >= 4
    for (len = 128; len >= 4; len >>= 1) {
        for (start = 0; start < N; start = j + len) {
            zeta = zetas_ntt[k++];
            for (j = start; j < start + len; ++j) {
                t = montgomery_reduce((int64_t)zeta * a[j + len]);
                a[j + len] = a[j] - t;
                a[j] = a[j] + t;
            }
        }
    }
}

void intt(int32_t a[N])
{
    unsigned int start, len, j, k;
    int32_t t, zeta;
    const int32_t f = 167912;  // mont^2/64

    k = 0;
    for (len = 4; len <= 128; len <<= 1) {
        for (start = 0; start < N; start = j + len) {
            zeta = zetas_intt[k++];
            for (j = start; j < start + len; ++j) {
                t = a[j];
                a[j] = t + a[j + len];
                a[j + len] = t - a[j + len];
                a[j + len] = montgomery_reduce((int64_t)zeta * a[j + len]);
            }
        }
    }
    for (j = 0; j < N; ++j) {
        a[j] = montgomery_reduce((int64_t)f * a[j]);
    }
}

void basemul(int32_t r[N], int32_t a[N], int32_t b[N])
{
    int64_t t;
    int32_t a0, a1, a2, a3, i;
    int32_t b0, b1, b2, b3;
    int32_t zeta;
    for (i = 0; i < N / 4; i++) {
        zeta = zetas_basemul[i >> 1];
        if (i & 1 == 1)
            zeta = -zeta;
        // get values from memory for storing result
        a0 = a[4 * i + 0];
        a1 = a[4 * i + 1];
        a2 = a[4 * i + 2];
        a3 = a[4 * i + 3];
        b0 = b[4 * i + 0];
        b1 = b[4 * i + 1];
        b2 = b[4 * i + 2];
        b3 = b[4 * i + 3];
        // r0=a0b0+zeta*(a1b3+a2b2+a3b1)
        t = (int64_t)a1 * b3;
        t += (int64_t)a2 * b2;
        t += (int64_t)a3 * b1;
        r[4 * i + 0] = montgomery_reduce(t);
        r[4 * i + 0] = montgomery_reduce((int64_t)r[4 * i + 0] * zeta);
        r[4 * i + 0] += montgomery_reduce((int64_t)a0 * b0);
        // r1=a0b1+a1b0+zeta*(a2b3+a3b2)
        t = (int64_t)a2 * b3;
        t += (int64_t)a3 * b2;
        r[4 * i + 1] = montgomery_reduce(t);
        r[4 * i + 1] = montgomery_reduce((int64_t)r[4 * i + 1] * zeta);
        t = (int64_t)a0 * b1;
        t += (int64_t)a1 * b0;
        r[4 * i + 1] += montgomery_reduce(t);
        // r2=a0b2+a1b1+a2b0+zeta*(a3b3)
        r[4 * i + 2] = montgomery_reduce((int64_t)a3 * b3);
        r[4 * i + 2] = montgomery_reduce((int64_t)r[4 * i + 2] * zeta);
        t = (int64_t)a0 * b2;
        t += (int64_t)a1 * b1;
        t += (int64_t)a2 * b0;
        r[4 * i + 2] += montgomery_reduce(t);
        // r3=a0b3+a1b2+a2b1+a3b0
        t = (int64_t)a0 * b3;
        t += (int64_t)a1 * b2;
        t += (int64_t)a2 * b1;
        t += (int64_t)a3 * b0;
        r[4 * i + 3] = montgomery_reduce(t);
    }
}

void print_poly(int32_t *a, size_t n)
{
    int i;
    for (i = 0; i < n; i++) {
        if (i != 0 && i % 16 == 0)
            printf("\n");
        printf("%d, ", a[i]);
    }
    printf("\n\n");
}

int poly_equal(int32_t *a, int32_t *b, size_t n)
{
    size_t i;
    int ok = 1;
    for (i = 0; i < n; i++) {
        if (((a[i] + Q * 10) % Q) != ((b[i] + Q * 10) % Q)) {
            ok = 0;
            break;
        }
    }
    return ok;
}

void poly_naivemul(int32_t *c, int32_t *a, int32_t *b)
{
    unsigned int i, j;
    int32_t r[2 * N] = {0};

    for (i = 0; i < N; i++)
        for (j = 0; j < N; j++)
            r[i + j] = (r[i + j] + (int64_t)a[i] * b[j]) % Q;

    for (i = N; i < 2 * N; i++)
        r[i - N] = (r[i - N] - r[i]) % Q;

    for (i = 0; i < N; i++)
        c[i] = r[i];
}

// extern void ntt_rv32im(int32_t *r, int32_t *zetas);
// extern void intt_rv32im(int32_t *r, int32_t *zetas);
// extern void poly_barrett_rdc_rv32im(int32_t *r);
// extern void poly_tomont_rv32im(int32_t *r);

// extern void poly_basemul_acc_rv32im(int64_t *r, const int32_t *a,
//                                     const int32_t *b, int32_t *zetas);
// extern void poly_basemul_acc_end_rv32im(int32_t *r, const int32_t *a,
//                                         const int32_t *b, int32_t
//                                         *zetas, int64_t *r_double);
// extern void poly_basemul_cache_init_rv32im(int64_t *r, const int32_t *a,
//                                            const int32_t *b,
//                                            int32_t *b_cache,
//                                            int32_t *zetas);
// extern void poly_basemul_acc_cached_rv32im(int64_t *r, const int32_t *a,
//                                            const int32_t *b,
//                                            int32_t *b_cache);
// extern void poly_basemul_acc_cache_init_end_rv32im(
//     int32_t *r, const int32_t *a, const int32_t *b, int32_t *b_cache,
//     int32_t *zetas, int64_t *r_double);
// extern void poly_basemul_acc_cache_end_rv32im(int32_t *r, const int32_t
// *a,
//                                               const int32_t *b,
//                                               int32_t *b_cache,
//                                               int64_t *r_double);

extern void poly_basemul_rv32im(int32_t *r, const int32_t *a,
                                const int32_t *b, int32_t *zetas);

#define NTESTS 1000
uint64_t t[NTESTS];

int main()
{
    int32_t a[N], b[N], b_cache[192], c0[N], c1[N], i, j;
    int64_t c_double[N];

    for (i = 0; i < N; i++)
        a[i] = 2;
    for (i = 0; i < N; i++)
        b[i] = 1;
    ntt(a);
    ntt(b);
    basemul(c0, a, b);
    intt(c0);

    // for (i = 0; i < N; i++)
    //     a[i] = 2;
    // for (i = 0; i < N; i++)
    //     b[i] = 1;
    // poly_naivemul(c, a, b);
    // print_poly(c, N);

    memset(c1, 0, N * sizeof(int32_t));
    memset(c_double, 0, N * sizeof(int64_t));
    for (i = 0; i < N; i++)
        a[i] = 2;
    for (i = 0; i < N; i++)
        b[i] = 1;
    ntt_rv32im(a, zetas_33merging_ntt);
    ntt_rv32im(b, zetas_33merging_ntt);
    poly_basemul_rv32im(c1, a, b, zetas_33merging_basemul);
    intt_rv32im(c1, zetas_33merging_intt);
    if (poly_equal(c0, c1, N) == 0) {
        print_poly(c0, N);
        print_poly(c1, N);
    }

    memset(c1, 0, N * sizeof(int32_t));
    memset(c_double, 0, N * sizeof(int64_t));
    for (i = 0; i < N; i++)
        a[i] = 1;
    for (i = 0; i < N; i++)
        b[i] = 1;
    ntt_rv32im(a, zetas_33merging_ntt);
    ntt_rv32im(b, zetas_33merging_ntt);
    poly_basemul_acc_rv32im(c_double, a, b, zetas_33merging_basemul);
    poly_basemul_acc_end_rv32im(c1, a, b, zetas_33merging_basemul,
                                c_double);
    intt_rv32im(c1, zetas_33merging_intt);
    if (poly_equal(c0, c1, N) == 0) {
        print_poly(c0, N);
        print_poly(c1, N);
    }

for (i = 0; i < N; i++)
        a[i] = 1;
    for (i = 0; i < N; i++)
        b[i] = 1;
    ntt(a);
    ntt(b);
    basemul(c0, a, b);
    intt(c0);

    memset(c1, 0, N * sizeof(int32_t));
    memset(c_double, 0, N * sizeof(int64_t));
    memset(b_cache, 0, 192 * sizeof(int32_t));
    for (i = 0; i < N; i++)
        a[i] = 1;
    for (i = 0; i < N; i++)
        b[i] = 1;
    ntt_rv32im(a, zetas_33merging_ntt);
    ntt_rv32im(b, zetas_33merging_ntt);
    poly_basemul_cache_init_rv32im(c_double, a, b, b_cache,
                                   zetas_33merging_basemul);
    poly_basemul_cache_end_rv32im(c1, a, b, b_cache);
    intt_rv32im(c1, zetas_33merging_intt);
    if (poly_equal(c0, c1, N) == 0) {
        print_poly(c0, N);
        print_poly(c1, N);
    }

    for (i = 0; i < N; i++)
        a[i] = 3;
    for (i = 0; i < N; i++)
        b[i] = 1;
    ntt(a);
    ntt(b);
    basemul(c0, a, b);
    intt(c0);

    memset(c1, 0, N * sizeof(int32_t));
    memset(c_double, 0, N * sizeof(int64_t));
    memset(b_cache, 0, 192 * sizeof(int32_t));
    for (i = 0; i < N; i++)
        a[i] = 1;
    for (i = 0; i < N; i++)
        b[i] = 1;
    ntt_rv32im(a, zetas_33merging_ntt);
    ntt_rv32im(b, zetas_33merging_ntt);
    poly_basemul_cache_init_rv32im(c_double, a, b, b_cache,
                                   zetas_33merging_basemul);
    poly_basemul_acc_cache_init_rv32im(c_double, a, b, b_cache,
                                       zetas_33merging_basemul);
    poly_basemul_acc_cache_end_rv32im(c1, a, b, b_cache, c_double);
    intt_rv32im(c1, zetas_33merging_intt);
    if (poly_equal(c0, c1, N) == 0) {
        print_poly(c0, N);
        print_poly(c1, N);
    }

    memset(c1, 0, N * sizeof(int32_t));
    memset(c_double, 0, N * sizeof(int64_t));
    poly_basemul_cache_init_rv32im(c_double, a, b, b_cache,
                                   zetas_33merging_basemul);
    poly_basemul_acc_cached_rv32im(c_double, a, b, b_cache);
    poly_basemul_acc_cache_init_end_rv32im(
        c1, a, b, b_cache, zetas_33merging_basemul, c_double);
    intt_rv32im(c1, zetas_33merging_intt);
    if (poly_equal(c0, c1, N) == 0) {
        print_poly(c0, N);
        print_poly(c1, N);
    }

    memset(c1, 0, N * sizeof(int32_t));
    memset(c_double, 0, N * sizeof(int64_t));
    poly_basemul_acc_cached_rv32im(c_double, a, b, b_cache);
    poly_basemul_acc_cached_rv32im(c_double, a, b, b_cache);
    poly_basemul_acc_cache_end_rv32im(c1, a, b, b_cache, c_double);
    intt_rv32im(c1, zetas_33merging_intt);
    if (poly_equal(c0, c1, N) == 0) {
        print_poly(c0, N);
        print_poly(c1, N);
    }

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        ntt_rv32im(a, zetas_33merging_ntt);
    }
    print_results("ntt_rv32im:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_basemul_rv32im(c0, a, b, zetas_33merging_basemul);
    }
    print_results("poly_basemul_rv32im:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_basemul_acc_rv32im(c_double, a, b, zetas_33merging_basemul);
    }
    print_results("poly_basemul_acc_rv32im:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_basemul_acc_end_rv32im(c0, a, b, zetas_33merging_basemul,
                                    c_double);
    }
    print_results("poly_basemul_acc_end_rv32im:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_basemul_cache_init_rv32im(c_double, a, b, b_cache,
                                       zetas_33merging_basemul);
    }
    print_results("poly_basemul_cache_init_rv32im:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_basemul_acc_cache_init_rv32im(c_double, a, b, b_cache,
                                           zetas_33merging_basemul);
    }
    print_results("poly_basemul_acc_cache_init_rv32im:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_basemul_acc_cached_rv32im(c_double, a, b, b_cache);
    }
    print_results("poly_basemul_acc_cached_rv32im:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_basemul_acc_cache_init_end_rv32im(
            c1, a, b, b_cache, zetas_33merging_basemul, c_double);
    }
    print_results("poly_basemul_acc_cache_init_end_rv32im:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_basemul_cache_end_rv32im(c1, a, b, b_cache);
    }
    print_results("poly_basemul_cache_end_rv32im:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_basemul_acc_cache_end_rv32im(c1, a, b, b_cache, c_double);
    }
    print_results("poly_basemul_acc_cache_end_rv32im:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        intt_rv32im(c0, zetas_33merging_intt);
    }
    print_results("intt_rv32im:", t, NTESTS);

    return 0;
}