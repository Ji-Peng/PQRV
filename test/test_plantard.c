#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "cpucycles.h"
#include "ntt_rv32im.h"
#include "speed_print.h"

#define KYBER_N 256
#define KYBER_Q 3329
#define MONT -1044  // 2^16 mod q
#define QINV -3327  // q^-1 mod 2^16
#define KYBER_K 2

typedef struct {
    int16_t coeffs[KYBER_N >> 1];
} poly_half;

typedef struct {
    int32_t coeffs[KYBER_N];
} poly_double;

typedef struct {
    int16_t coeffs[KYBER_N];
} poly;

typedef struct {
    poly vec[KYBER_K];
} polyvec;

typedef struct {
    poly_half vec[KYBER_K];
} polyvec_half;

const int16_t zetas_ref[128] = {
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
                r[j] = barrett_reduce(t + r[j + len]);
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
    int i;
    for (i = 0; i < KYBER_N / 4; i++) {
        basemul_ref(&r[4 * i], &a[4 * i], &b[4 * i], zetas_ref[64 + i]);
        basemul_ref(&r[4 * i + 2], &a[4 * i + 2], &b[4 * i + 2],
                    -zetas_ref[64 + i]);
    }
}

void poly_add_ref(poly *r, poly *a, poly *b)
{
    unsigned int i;
    for (i = 0; i < KYBER_N; i++)
        r->coeffs[i] = a->coeffs[i] + b->coeffs[i];
}

void poly_reduce_ref(poly *r)
{
    unsigned int i;
    for (i = 0; i < KYBER_N; i++)
        r->coeffs[i] = barrett_reduce(r->coeffs[i]);
}

void polyvec_basemul_acc_ref(poly *r, polyvec *a, polyvec *b)
{
    unsigned int i;
    poly t;

    poly_basemul_ref(r->coeffs, a->vec[0].coeffs, b->vec[0].coeffs);
    for (i = 1; i < KYBER_K; i++) {
        poly_basemul_ref(t.coeffs, a->vec[i].coeffs, b->vec[i].coeffs);
        poly_add_ref(r, r, &t);
    }

    poly_reduce_ref(r);
}

void poly_tomont_ref(poly *r)
{
    unsigned int i;
    const int16_t f = (1ULL << 32) % KYBER_Q;
    for (i = 0; i < KYBER_N; i++)
        r->coeffs[i] = montgomery_reduce((int32_t)r->coeffs[i] * f);
}

uint32_t zetas_basemul_rv32im[64] = {
    21932846,   3562152210, 752167598,  3417653460, 2112004045, 932791035,
    2951903026, 1419184148, 1817845876, 3434425636, 4233039261, 300609006,
    975366560,  2781600929, 3889854731, 3935010590, 2197155094, 2130066389,
    3598276897, 2308109491, 2382939200, 1228239371, 1884934581, 3466679822,
    1211467195, 2977706375, 3144137970, 3080919767, 945692709,  3015121229,
    345764865,  826997308,  2043625172, 2964804700, 2628071007, 4154339049,
    483812778,  3288636719, 2696449880, 2122325384, 1371447954, 411563403,
    3577634219, 976656727,  2708061387, 723783916,  3181552825, 3346694253,
    3617629408, 1408862808, 519937465,  1323711759, 1474661346, 2773859924,
    3580214553, 1143088323, 2221668274, 1563682897, 2417773720, 1327582262,
    2722253228, 3786641338, 1141798155, 2779020594};

// 4+3 layer merging strategy with CT butterfly
uint32_t zetas_ntt_rv32im[128] = {
    2230699446, 3328631909, 4243360600, 3408622288, 812805467,  2447447570,
    1094061961, 1370157786, 2475831253, 249002310,  1028263423, 3594406395,
    4205945745, 734105255,  2252632292, 381889553,  372858381,  427045412,
    21932846,   3562152210, 752167598,  3417653460, 3157039644, 4196914574,
    2265533966, 2112004045, 932791035,  2951903026, 1419184148, 1727534158,
    1544330386, 2972545705, 1817845876, 3434425636, 4233039261, 300609006,
    1904287092, 2937711185, 2651294021, 975366560,  2781600929, 3889854731,
    3935010590, 3929849920, 838608815,  2550660963, 2197155094, 2130066389,
    3598276897, 2308109491, 72249375,   3242190693, 815385801,  2382939200,
    1228239371, 1884934581, 3466679822, 2889974991, 3696329620, 42575525,
    1211467195, 2977706375, 3144137970, 3080919767, 1719793153, 1703020977,
    2470670584, 945692709,  3015121229, 345764865,  826997308,  1839778722,
    2991898216, 1851390229, 2043625172, 2964804700, 2628071007, 4154339049,
    2701610550, 1041165097, 583155668,  483812778,  3288636719, 2696449880,
    2122325384, 690239563,  1855260731, 3700200122, 1371447954, 411563403,
    3577634219, 976656727,  3718262466, 1979116802, 3098982111, 2708061387,
    723783916,  3181552825, 3346694253, 3087370604, 3415073125, 3376368103,
    3617629408, 1408862808, 519937465,  1323711759, 3714391964, 1910737929,
    836028480,  1474661346, 2773859924, 3580214553, 1143088323, 2546790461,
    3191874164, 4012420634, 2221668274, 1563682897, 2417773720, 1327582262,
    1059227441, 1583035408, 1174052340, 2722253228, 3786641338, 1141798155,
    2779020594, 0};

// 3+4 layer merging strategy with GS butterfly.
uint32_t zetas_intt_rv32im[128] = {
    1515946703, 3153169142, 508325959,  1572714069, 3120914957, 2711931889,
    3235739856, 2967385035, 1877193577, 2731284400, 2073299023, 282546663,
    1103093133, 1748176836, 3151878974, 714752744,  1521107373, 2820305951,
    3458938817, 2384229368, 580575333,  2971255538, 3775029832, 2886104489,
    677337889,  918599194,  879894172,  1207596693, 948273044,  1113414472,
    3571183381, 1586905910, 1195985186, 2315850495, 576704831,  3318310570,
    717333078,  3883403894, 2923519343, 594767175,  2439706566, 3604727734,
    2172641913, 1598517417, 1006330578, 3811154519, 3711811629, 3253802200,
    1593356747, 140628248,  1666896290, 1330162597, 2251342125, 2443577068,
    1303069081, 2455188575, 3467969989, 3949202432, 1279846068, 3349274588,
    1824296713, 2591946320, 2575174144, 1214047530, 1150829327, 1317260922,
    3083500102, 4252391772, 598637677,  1404992306, 828287475,  2410032716,
    3066727926, 1912028097, 3479581496, 1052776604, 4222717922, 1986857806,
    696690400,  2164900908, 2097812203, 1744306334, 3456358482, 365117377,
    359956707,  405112566,  1513366368, 3319600737, 1643673276, 1357256112,
    2390680205, 3994358291, 61928036,   860541661,  2477121421, 1322421592,
    2750636911, 2567433139, 2875783149, 1343064271, 3362176262, 2182963252,
    2029433331, 98052723,   1137927653, 877313837,  3542799699, 732815087,
    4273034451, 3867921885, 3922108916, 3913077744, 2042335005, 3560862042,
    89021552,   700560902,  3266703874, 4045964987, 1819136044, 2924809511,
    3200905336, 1847519727, 3482161830, 886345009,  51606697,   966335388,
    1802363867, 2435836064};

void ntt(poly *poly)
{
    ntt_rv32im(poly->coeffs, zetas_ntt_rv32im);
}

void intt(poly *poly)
{
    intt_rv32im(poly->coeffs, zetas_intt_rv32im);
}

void poly_basemul_acc(poly_double *r, const poly *a, const poly *b)
{
    poly_basemul_acc_rv32im(r->coeffs, a->coeffs, b->coeffs,
                            zetas_basemul_rv32im);
}

void poly_basemul_acc_end(poly *r, const poly *a, const poly *b,
                          poly_double *r_double)
{
    poly_basemul_acc_end_rv32im(r->coeffs, a->coeffs, b->coeffs,
                                zetas_basemul_rv32im, r_double->coeffs);
}

void poly_toplant(poly *r)
{
    poly_toplant_rv32im(r->coeffs);
}

void poly_reduce(poly *r)
{
    poly_barrett_rdc_rv32im(r->coeffs);
}

void poly_basemul_cache_init(poly_double *r, const poly *a, const poly *b,
                             poly_half *b_cache)
{
    poly_basemul_cache_init_rv32im(r->coeffs, a->coeffs, b->coeffs,
                                   b_cache->coeffs, zetas_basemul_rv32im);
}

void poly_basemul_acc_cache_init(poly_double *r, const poly *a, const poly *b,
                                 poly_half *b_cache)
{
    poly_basemul_acc_cache_init_rv32im(r->coeffs, a->coeffs, b->coeffs,
                                       b_cache->coeffs, zetas_basemul_rv32im);
}

void poly_basemul_acc_cache_init_end(poly *r, const poly *a, const poly *b,
                                     poly_half *b_cache, poly_double *r_double)
{
    poly_basemul_acc_cache_init_end_rv32im(
        r->coeffs, a->coeffs, b->coeffs, b_cache->coeffs, zetas_basemul_rv32im,
        r_double->coeffs);
}

void poly_basemul_acc_cached(poly_double *r, const poly *a, const poly *b,
                             poly_half *b_cache)
{
    poly_basemul_acc_cached_rv32im(r->coeffs, a->coeffs, b->coeffs,
                                   b_cache->coeffs);
}

void poly_basemul_acc_cache_end(poly *r, const poly *a, const poly *b,
                                poly_half *b_cache, poly_double *r_double)
{
    poly_basemul_acc_cache_end_rv32im(r->coeffs, a->coeffs, b->coeffs,
                                      b_cache->coeffs, r_double->coeffs);
}

void polyvec_basemul_cache_init(poly *r, const polyvec *a, const polyvec *b,
                                polyvec_half *b_cache)
{
    unsigned int i;
    poly_double r_double;
    poly_basemul_cache_init(&r_double, &a->vec[0], &b->vec[0],
                            &b_cache->vec[0]);
    for (i = 1; i < KYBER_K - 1; i++) {
        poly_basemul_acc_cache_init(&r_double, &a->vec[i], &b->vec[i],
                                    &b_cache->vec[i]);
    }
    poly_basemul_acc_cache_init_end(r, &a->vec[i], &b->vec[i], &b_cache->vec[i],
                                    &r_double);
}
void polyvec_basemul_acc_cached(poly *r, const polyvec *a, const polyvec *b,
                                polyvec_half *b_cache)
{
    unsigned int i;
    poly_double r_double;

    for (i = 0; i < KYBER_N; i++)
        r_double.coeffs[i] = 0;
    for (i = 0; i < KYBER_K - 1; i++) {
        poly_basemul_acc_cached(&r_double, &a->vec[i], &b->vec[i],
                                &b_cache->vec[i]);
    }
    poly_basemul_acc_cache_end(r, &a->vec[i], &b->vec[i], &b_cache->vec[i],
                               &r_double);
}
void polyvec_basemul_acc(poly *r, const polyvec *a, const polyvec *b)
{
    unsigned int i;
    poly_double r_double;

    for (i = 0; i < KYBER_N; i++)
        r_double.coeffs[i] = 0;
    for (i = 0; i < KYBER_K - 1; i++) {
        poly_basemul_acc(&r_double, &a->vec[i], &b->vec[i]);
    }
    poly_basemul_acc_end(r, &a->vec[i], &b->vec[i], &r_double);
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

void test_ntt()
{
    int i;
    poly a, b, c;
    poly_double c_double;
    for (i = 0; i < KYBER_N; i++)
        a.coeffs[i] = b.coeffs[i] = c_double.coeffs[i] = 0;
    a.coeffs[0] = b.coeffs[0] = 100;

    ntt(&a);
    ntt(&b);
    poly_basemul_acc(&c_double, &a, &b);
    poly_basemul_acc_end(&c, &a, &b, &c_double);
    intt(&c);
    // poly_toplant(a);
    print_poly(c.coeffs, 256);
}

void test_poly_toplant()
{
    int i;
    poly a;
    for (i = 0; i < KYBER_N; i++) {
        a.coeffs[i] = 1;
    }
    poly_toplant(&a);
    print_poly(a.coeffs, 256);
}

void test_poly_reduce()
{
    int i;
    poly a;
    for (i = 0; i < KYBER_N; i++) {
        a.coeffs[i] = 1 + KYBER_Q;
    }
    poly_reduce(&a);
    print_poly(a.coeffs, 256);
}

void test_basemul_cache()
{
    int i, j;
    poly a[3], b[3], c[3];
    poly_double c_double[3];
    poly_half b_half[3];
    for (i = 0; i < 3; i++) {
        memset(a[i].coeffs, 0, 256 * 2);
        memset(b[i].coeffs, 0, 256 * 2);
        memset(c[i].coeffs, 0, 256 * 2);
        memset(c_double[i].coeffs, 0, 256 * 4);
        memset(b_half[i].coeffs, 0, 256 * 1);
    }
    for (i = 0; i < 3; i++) {
        for (j = 0; j < KYBER_N; j++)
            a[i].coeffs[j] = b[i].coeffs[j] = i * j;
    }
    for (i = 0; i < 3; i++) {
        ntt(&a[i]);
        ntt(&b[i]);
    }
    poly_basemul_cache_init(&c_double[0], &a[0], &b[0], &b_half[0]);
    poly_basemul_acc_cache_init(&c_double[0], &a[1], &b[1], &b_half[1]);
    poly_basemul_acc_cache_init_end(&c[0], &a[2], &b[2], &b_half[2],
                                    &c_double[0]);
    intt(&c[0]);
    print_poly(c[0].coeffs, 256);
    poly_basemul_acc_cached(&c_double[1], &a[0], &b[0], &b_half[0]);
    poly_basemul_acc_cached(&c_double[1], &a[1], &b[1], &b_half[1]);
    poly_basemul_acc_cache_end(&c[1], &a[2], &b[2], &b_half[2], &c_double[1]);
    intt(&c[1]);
    print_poly(c[1].coeffs, 256);
}

void test_plant_ntt_ref()
{
    int i;
    poly a, b, c;
    poly_double c_double;
    for (i = 0; i < KYBER_N; i++)
        a.coeffs[i] = b.coeffs[i] = c_double.coeffs[i] = i;

    ntt(&a);
    ntt_ref(b.coeffs);
    if (poly_equal(a.coeffs, b.coeffs, 256))
        printf("ntt all right\n");
    else {
        printf("ntt error\n");
        print_poly(a.coeffs, 256);
        print_poly(b.coeffs, 256);
    }
}

void test_indcpa_basemul()
{
    int i, j, k;
    polyvec a[KYBER_K], pkpv1, pkpv2, skpv;
    for (i = 0; i < KYBER_K; i++) {
        for (j = 0; j < KYBER_K; j++) {
            for (k = 0; k < KYBER_N; k++) {
                a[i].vec[j].coeffs[k] = 0;
            }
        }
    }
    for (i = 0; i < KYBER_K; i++) {
        for (j = 0; j < KYBER_K; j++) {
            for (k = 0; k < 1; k++) {
                a[i].vec[j].coeffs[k] = 1;
            }
        }
    }
    for (i = 0; i < KYBER_K; i++) {
        for (k = 0; k < KYBER_N; k++) {
            skpv.vec[i].coeffs[k] = 0;
        }
    }
    for (i = 0; i < KYBER_K; i++) {
        for (k = 0; k < 1; k++) {
            skpv.vec[i].coeffs[k] = 1;
        }
    }
    for (i = 0; i < KYBER_K; i++) {
        polyvec_basemul_acc_ref(&pkpv1.vec[i], &a[i], &skpv);
        poly_tomont_ref(&pkpv1.vec[i]);
    }
    print_poly(pkpv1.vec[0].coeffs, 256);

    for (i = 0; i < KYBER_K; i++) {
        polyvec_basemul_acc(&pkpv2.vec[i], &a[i], &skpv);
        poly_toplant(&pkpv2.vec[i]);
    }
    print_poly(pkpv2.vec[0].coeffs, 256);
}

int main()
{
    // test_ntt();
    // test_poly_toplant();
    // test_poly_reduce();
    // test_basemul_cache();
    // test_plant_ntt_ref();
    test_indcpa_basemul();
    return 0;
}