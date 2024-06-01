#include <stdint.h>
#include <stdio.h>

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

void invntt_tomont(int32_t a[N])
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

int main()
{
    int32_t a[N], b[N], c[N], i, j;
    for (i = 0; i < N; i++)
        a[i] = b[i] = 1;
    // i = N - 1;
    // a[i] = b[i] = 1;
    ntt(a);
    ntt(b);
    basemul(c, a, b);
    invntt_tomont(c);
    print_poly(c, N);
    for (i = 0; i < N; i++)
        a[i] = b[i] = 1;
    // i = N - 1;
    // a[i] = b[i] = 1;
    poly_naivemul(c, a, b);
    print_poly(c, N);

    // for (i = 0; i < N; i++)
    //     a[i] = 0;
    // a[0] = 64;
    // ntt(a);
    // for (i = 0; i < N; i++)
    //     montgomery_reduce(a[i]);
    // invntt_tomont(a);
    // print_poly(a, N);
    return 0;
}