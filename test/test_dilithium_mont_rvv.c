#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "consts.h"
#include "cpucycles.h"
#include "speed_print.h"

#define N 256
#define Q 8380417
#define ROOT_OF_UNITY 1753
#define MONT -4186625   // 2^32 % Q
#define R2modQ 2365951  // 2^64 % Q
#define QINV 58728449   // q^(-1) mod 2^32
#define INVN -32736     // N^-1 mod Q

const int32_t zetas_8l_ref[N] = {
    0,        25847,    -2608894, -518909,  237124,   -777960,  -876248,
    466468,   1826347,  2353451,  -359251,  -2091905, 3119733,  -2884855,
    3111497,  2680103,  2725464,  1024112,  -1079900, 3585928,  -549488,
    -1119584, 2619752,  -2108549, -2118186, -3859737, -1399561, -3277672,
    1757237,  -19422,   4010497,  280005,   2706023,  95776,    3077325,
    3530437,  -1661693, -3592148, -2537516, 3915439,  -3861115, -3043716,
    3574422,  -2867647, 3539968,  -300467,  2348700,  -539299,  -1699267,
    -1643818, 3505694,  -3821735, 3507263,  -2140649, -1600420, 3699596,
    811944,   531354,   954230,   3881043,  3900724,  -2556880, 2071892,
    -2797779, -3930395, -1528703, -3677745, -3041255, -1452451, 3475950,
    2176455,  -1585221, -1257611, 1939314,  -4083598, -1000202, -3190144,
    -3157330, -3632928, 126922,   3412210,  -983419,  2147896,  2715295,
    -2967645, -3693493, -411027,  -2477047, -671102,  -1228525, -22981,
    -1308169, -381987,  1349076,  1852771,  -1430430, -3343383, 264944,
    508951,   3097992,  44288,    -1100098, 904516,   3958618,  -3724342,
    -8578,    1653064,  -3249728, 2389356,  -210977,  759969,   -1316856,
    189548,   -3553272, 3159746,  -1851402, -2409325, -177440,  1315589,
    1341330,  1285669,  -1584928, -812732,  -1439742, -3019102, -3881060,
    -3628969, 3839961,  2091667,  3407706,  2316500,  3817976,  -3342478,
    2244091,  -2446433, -3562462, 266997,   2434439,  -1235728, 3513181,
    -3520352, -3759364, -1197226, -3193378, 900702,   1859098,  909542,
    819034,   495491,   -1613174, -43260,   -522500,  -655327,  -3122442,
    2031748,  3207046,  -3556995, -525098,  -768622,  -3595838, 342297,
    286988,   -2437823, 4108315,  3437287,  -3342277, 1735879,  203044,
    2842341,  2691481,  -2590150, 1265009,  4055324,  1247620,  2486353,
    1595974,  -3767016, 1250494,  2635921,  -3548272, -2994039, 1869119,
    1903435,  -1050970, -1333058, 1237275,  -3318210, -1430225, -451100,
    1312455,  3306115,  -1962642, -1279661, 1917081,  -2546312, -1374803,
    1500165,  777191,   2235880,  3406031,  -542412,  -2831860, -1671176,
    -1846953, -2584293, -3724270, 594136,   -3776993, -2013608, 2432395,
    2454455,  -164721,  1957272,  3369112,  185531,   -1207385, -3183426,
    162844,   1616392,  3014001,  810149,   1652634,  -3694233, -1799107,
    -3038916, 3523897,  3866901,  269760,   2213111,  -975884,  1717735,
    472078,   -426683,  1723600,  -1803090, 1910376,  -1667432, -1104333,
    -260646,  -3833893, -2939036, -2235985, -420899,  -2286327, 183443,
    -976891,  1612842,  -3545687, -554416,  3919660,  -48306,   -1362209,
    3937738,  1400424,  -846154,  1976782};

int32_t montgomery_reduce(int64_t a)
{
    int32_t t;

    t = (int64_t)(int32_t)a * QINV;
    t = (a - (int64_t)t * Q) >> 32;
    return t;
}

void ntt_8l_ref(int32_t a[N])
{
    unsigned int len, start, j, k;
    int32_t zeta, t;

    k = 0;
    // 128,64,32,16
    // 8,4,2,1
    for (len = 128; len >= 1; len >>= 1) {
        for (start = 0; start < N; start = j + len) {
            zeta = zetas_8l_ref[++k];
            for (j = start; j < start + len; ++j) {
                t = montgomery_reduce((int64_t)zeta * a[j + len]);
                a[j + len] = a[j] - t;
                a[j] = a[j] + t;
            }
        }
    }
}

void intt_8l_ref(int32_t a[N])
{
    unsigned int start, len, j, k;
    int32_t t, zeta;
    const int32_t f = 41978;  // mont^2/256

    k = 256;
    for (len = 1; len <= 128; len <<= 1) {
        for (start = 0; start < N; start = j + len) {
            zeta = -zetas_8l_ref[--k];
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

void basemul_8l_ref(int32_t c[N], int32_t a[N], int32_t b[N])
{
    int i;
    for (i = 0; i < N; i++)
        c[i] = montgomery_reduce((int64_t)a[i] * b[i]);
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

extern const int32_t qdata[1000];
extern void ntt_8l_rvv(int32_t *r, const int32_t *qdata);
extern void intt_8l_rvv(int32_t *r, const int32_t *qdata);
extern void poly_basemul_8l_rvv(int32_t *r, int32_t *a, int32_t *b);
extern void poly_basemul_acc_8l_rvv(int32_t *r, int32_t *a, int32_t *b);
extern void ntt2normal_order_8l_rvv(int32_t *r, const int32_t *qdata);
extern void normal2ntt_order_8l_rvv(int32_t *r, const int32_t *qdata);
extern void poly_reduce_rvv(int32_t *r);

#define NTESTS 1000
uint64_t t[NTESTS];

int main()
{
    int32_t a[N], b[N], c0[N], c1[N], i, j;
    int64_t c_double[N];

    for (i = 0; i < N; i++)
        a[i] = 1;
    for (i = 0; i < N; i++)
        b[i] = 1;
    ntt_8l_ref(a);
    ntt_8l_rvv(b, qdata);
    ntt2normal_order_8l_rvv(b, qdata);
    if (poly_equal(a, b, N) == 0) {
        printf("ntt_8l_rvv error\n");
        print_poly(a, N);
        print_poly(b, N);
    }

    // for (i = 0; i < N; i++)
    //     a[i] = i;
    // for (i = 0; i < N; i++)
    //     b[i] = i;
    // intt_8l_ref(a);
    // normal2ntt_order_8l_rvv(b, qdata);
    // intt_8l_rvv(b, qdata);
    // if (poly_equal(a, b, N) == 0) {
    //     printf("intt_8l_rvv error\n");
    //     print_poly(a, N);
    //     print_poly(b, N);
    // }

    // for (i = 0; i < N; i++)
    //     a[i] = 1;
    // for (i = 0; i < N; i++)
    //     b[i] = 1;
    // ntt_8l_ref(a);
    // ntt_8l_ref(b);
    // basemul_8l_ref(c0, a, b);
    // intt_8l_ref(c0);
    // for (i = 0; i < N; i++)
    //     a[i] = 1;
    // for (i = 0; i < N; i++)
    //     b[i] = 1;
    // ntt_8l_rvv(a, qdata);
    // ntt_8l_rvv(b, qdata);
    // poly_basemul_8l_rvv(c1, a, b);
    // intt_8l_rvv(c1, qdata);
    // if (poly_equal(c0, c1, N) == 0) {
    //     printf("ntt-basemul-intt 8l rvv error\n");
    //     print_poly(c0, N);
    //     print_poly(c1, N);
    // }

    // poly_reduce_rvv(c1);
    // if (poly_equal(c0, c1, N) == 0) {
    //     printf("poly_reduce_rvv error\n");
    //     print_poly(c0, N);
    //     print_poly(c1, N);
    // }

    // for (i = 0; i < N; i++)
    //     a[i] = 2;
    // for (i = 0; i < N; i++)
    //     b[i] = 1;
    // ntt_8l_ref(a);
    // ntt_8l_ref(b);
    // basemul_8l_ref(c0, a, b);
    // intt_8l_ref(c0);
    // for (i = 0; i < N; i++)
    //     a[i] = 1;
    // for (i = 0; i < N; i++)
    //     b[i] = 1;
    // ntt_8l_rvv(a, qdata);
    // ntt_8l_rvv(b, qdata);
    // poly_basemul_8l_rvv(c1, a, b);
    // poly_basemul_acc_8l_rvv(c1, a, b);
    // intt_8l_rvv(c1, qdata);
    // if (poly_equal(c0, c1, N) == 0) {
    //     printf("ntt-basemul-acc-intt 8l rvv error\n");
    //     print_poly(c0, N);
    //     print_poly(c1, N);
    // }

    PERF(ntt_8l_rvv(b, qdata), ntt_8l_rvv);
    PERF(intt_8l_rvv(b, qdata), intt_8l_rvv);
    PERF(poly_basemul_8l_rvv(c1, a, b), poly_basemul_8l_rvv);
    PERF(poly_basemul_acc_8l_rvv(c1, a, b), poly_basemul_acc_8l_rvv);
    PERF(poly_reduce_rvv(c1), poly_reduce_rvv);
    PERF(ntt2normal_order_8l_rvv(b, qdata), ntt2normal_order_8l_rvv);
    PERF(normal2ntt_order_8l_rvv(b, qdata), normal2ntt_order_8l_rvv);
    return 0;
}