#include <math.h>
#include <riscv_vector.h>
#include <stdio.h>
#include <string.h>

#include "cpucycles.h"
#include "speed_print.h"

#define ARRAY_SIZE 11

float a_array[ARRAY_SIZE] = {1.18869953,  1.55298864,  -0.17365574,
                             -1.86193886, -1.52391526, -0.36566814,
                             0.70753702,  0.73992422,  -0.13493693,
                             1.09563677,  1.03797902};

float b_array[ARRAY_SIZE] = {1.19655525,  0.23393777, -0.11629651,
                             -0.54508896, -1.2424749, -1.54835913,
                             0.86935212,  0.12946646, 0.81831905,
                             -0.42723697, -0.89793257};

// float c_array[ARRAY_SIZE] = {
// 2.38525478,  1.78692641, -0.28995225, -2.40702783,
// -2.76639016 -1.91402727,1.57688914,  0.86939068,
// 0.68338213,  0.66839979,  0.14004644
// };

float c_array_ref[ARRAY_SIZE];
float c_array_vec[ARRAY_SIZE];

void add(const float *a, const float *b, float *c, size_t length)
{
    for (int i = 0; i < length; i++) {
        c[i] = a[i] + b[i];
    }
}

void add_vec(const float *a, const float *b, float *c, size_t length)
{
    while (length > 0) {
        size_t vl =
            vsetvl_e32m1(length);  // 设置向量寄存器每次操作的元素个数
        vfloat32m1_t va =
            vle32_v_f32m1(a, vl);  // 从数组a中加载vl个元素到向量寄存器va中
        vfloat32m1_t vb =
            vle32_v_f32m1(b, vl);  // 从数组b中加载vl个元素到向量寄存器vb中
        vfloat32m1_t vc = vfadd_vv_f32m1(
            va, vb,
            vl);  // 向量寄存器va和向量寄存器vb中vl个元素对应相加，结果为vc
        vse32_v_f32m1(c, vc, vl);  // 将向量寄存器中的vl个元素存到数组c中

        a += vl;
        b += vl;
        c += vl;
        length -= vl;
    }
}

void print_bytes(uint8_t *buf, size_t len)
{
    int i;
    for (i = 0; i < len - 1; i++)
        printf("%u, ", buf[i]);
    printf("%u\n", buf[i]);
}

void print_u16(uint8_t *buf, size_t len)
{
    int i;
    uint16_t *p = (uint16_t *)buf;
    for (i = 0; i < len - 1; i++)
        printf("%u, ", p[i]);
    printf("%u\n", p[i]);
}

void print_i16(int16_t *buf, size_t len)
{
    int i;
    int16_t *p = buf;
    for (i = 0; i < len - 1; i++)
        printf("%d, ", p[i]);
    printf("%d\n", p[i]);
}

void test_vzext()
{
    int i;
    uint8_t buf[16];
    uint32_t out[16];
    size_t vl;
    vuint8m1_t f0, t0, idx8;
    vuint32m4_t g0;
    vbool8_t mask_10, mask_01;

    const uint8_t idx8_t[16] __attribute__((aligned(16))) = {
        0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7};
    const uint8_t mask_10_t[16] = {1, 0, 1, 0, 1, 0, 1, 0,
                                   1, 0, 1, 0, 1, 0, 1, 0};

    for (i = 0; i < 16; i++)
        buf[i] = i;

    vl = vsetvl_e8m1(128 / 8);
    t0 = vle8_v_u8m1(mask_10_t, vl);
    mask_10 = vmseq_vx_u8m1_b8(t0, 1, vl);
    mask_01 = vmsne_vx_u8m1_b8(t0, 1, vl);
    idx8 = vle8_v_u8m1(idx8_t, vl);

    f0 = vle8_v_u8m1(buf, vl);
    f0 = vrgather_vv_u8m1(f0, idx8, vl);
    f0 = vand_vx_u8m1_m(mask_10, f0, f0, 0x0F, vl);
    f0 = vsrl_vx_u8m1_m(mask_01, f0, f0, 4, vl);

    vl = vsetvl_e32m4(128 / 32);
    printf("vl=%d\n", vl);
    vl *= 4;
    g0 = vzext_vf4_u32m4(f0, vl);
    // g0 = vrsub_vx_u32m4(g0, 1, vl);
    vse32_v_u32m4(out, g0, vl);

    printf("Input with uint8_t:\n");
    for (i = 0; i < 16; i++)
        printf("%d, ", buf[i]);
    printf("\nOutput with uint32_t:\n");
    for (i = 0; i < 16; i++)
        printf("%d, ", out[i]);
    printf("\n");
}

void rej_uniform_vector0(int16_t *r, unsigned int len, const uint8_t *buf,
                         unsigned int buflen)
{
    const uint8_t idx8_t[16] = {0, 1, 1, 2, 3, 4,  4,  5,
                                6, 7, 7, 8, 9, 10, 10, 11};
    const uint16_t mask_01_t[8] = {0, 1, 0, 1, 0, 1, 0, 1};
    const uint16_t mask_12bits_t[8] = {0xFFF, 0xFFF, 0xFFF, 0xFFF,
                                       0xFFF, 0xFFF, 0xFFF, 0xFFF};
    const uint16_t bound_t[8] = {3329, 3329, 3329, 3329,
                                 3329, 3329, 3329, 3329};
    uint8_t buf_v[16];
    size_t vl;
    vuint8m1_t f0, f1, idx8;
    vuint16m1_t g0, g1, t0, mask_12bits, bound;
    vbool16_t mask_01, good0, good1;
    unsigned long num0, num1;

    vl = vsetvl_e8m1(128 / 8);
    f0 = vle8_v_u8m1(buf, vl);
    f1 = vle8_v_u8m1(buf + 12, vl);
    idx8 = vle8_v_u8m1(idx8_t, vl);
    f0 = vrgather_vv_u8m1(f0, idx8, vl);
    f1 = vrgather_vv_u8m1(f1, idx8, vl);
    vse8_v_u8m1(buf_v, f0, vl);
    print_u16(buf_v, vl / 2);
    vse8_v_u8m1(buf_v, f1, vl);
    print_u16(buf_v, vl / 2);

    vl = vsetvl_e16m1(128 / 16);
    g0 = vreinterpret_v_u8m1_u16m1(f0);
    g1 = vreinterpret_v_u8m1_u16m1(f1);
    t0 = vle16_v_u16m1(mask_01_t, vl);
    mask_01 = vmseq_vx_u16m1_b16(t0, 1, vl);
    g0 = vsrl_vx_u16m1_m(mask_01, g0, g0, 4, vl);
    g1 = vsrl_vx_u16m1_m(mask_01, g1, g1, 4, vl);
    vse16_v_u16m1((uint16_t *)buf_v, g0, vl);
    print_u16(buf_v, vl);
    vse16_v_u16m1((uint16_t *)buf_v, g1, vl);
    print_u16(buf_v, vl);

    mask_12bits = vle16_v_u16m1(mask_12bits_t, vl);
    g0 = vand_vv_u16m1(g0, mask_12bits, vl);
    g1 = vand_vv_u16m1(g1, mask_12bits, vl);
    vse16_v_u16m1((uint16_t *)buf_v, g0, vl);
    print_u16(buf_v, vl);
    vse16_v_u16m1((uint16_t *)buf_v, g1, vl);
    print_u16(buf_v, vl);

    bound = vle16_v_u16m1(bound_t, vl);
    good0 = vmsltu_vv_u16m1_b16(g0, bound, vl);
    good1 = vmsltu_vv_u16m1_b16(g1, bound, vl);
    num0 = vcpop_m_b16(good0, vl);
    num1 = vcpop_m_b16(good1, vl);
    printf("num0=%u, num1=%u\n", num0, num1);

    g0 = vcompress_vm_u16m1(good0, g0, g0, vl);
    g1 = vcompress_vm_u16m1(good1, g1, g1, vl);
    vse16_v_u16m1((uint16_t *)buf_v, g0, vl);
    print_u16(buf_v, vl);
    vse16_v_u16m1((uint16_t *)buf_v, g1, vl);
    print_u16(buf_v, vl);

    vse16_v_u16m1((uint16_t *)r, g0, vl);
    vse16_v_u16m1((uint16_t *)r + num0, g1, vl);

    print_u16((uint8_t *)r, 32);
}

#define KYBER_Q 3329
#define KYBER_N 256
#define REJ_UNIFORM_AVX_BUFLEN 504

unsigned int rej_uniform(int16_t *r, unsigned int len, const uint8_t *buf,
                         unsigned int buflen)
{
    unsigned int ctr, pos;
    uint16_t val0, val1;

    ctr = pos = 0;
    while (ctr < len && pos + 3 <= buflen) {
        val0 =
            ((buf[pos + 0] >> 0) | ((uint16_t)buf[pos + 1] << 8)) & 0xFFF;
        val1 =
            ((buf[pos + 1] >> 4) | ((uint16_t)buf[pos + 2] << 4)) & 0xFFF;
        pos += 3;

        if (val0 < KYBER_Q)
            r[ctr++] = val0;
        if (ctr < len && val1 < KYBER_Q)
            r[ctr++] = val1;
    }

    return ctr;
}

unsigned int rej_uniform_vector(int16_t *r, const uint8_t *buf)
{
    unsigned int ctr, pos;
    uint16_t val0, val1;
    const uint8_t idx8_t[16] = {0, 1, 1, 2, 3, 4,  4,  5,
                                6, 7, 7, 8, 9, 10, 10, 11};
    const uint16_t mask_01_t[8] = {0, 1, 0, 1, 0, 1, 0, 1};
    const uint16_t mask_12bits_t[8] = {0xFFF, 0xFFF, 0xFFF, 0xFFF,
                                       0xFFF, 0xFFF, 0xFFF, 0xFFF};
    const uint16_t bound_t[8] = {3329, 3329, 3329, 3329,
                                 3329, 3329, 3329, 3329};
    size_t vl;
    vuint8m1_t f0, f1, idx8;
    vuint16m1_t g0, g1, t0, mask_12bits, bound;
    vbool16_t mask_01, good0, good1;
    unsigned long num0, num1;

    // init useful vector variables
    vl = vsetvl_e8m1(128 / 8);
    idx8 = vle8_v_u8m1(idx8_t, vl);
    vl = vsetvl_e16m1(128 / 16);
    t0 = vle16_v_u16m1(mask_01_t, vl);
    mask_12bits = vle16_v_u16m1(mask_12bits_t, vl);
    bound = vle16_v_u16m1(bound_t, vl);
    mask_01 = vmseq_vx_u16m1_b16(t0, 1, vl);

    ctr = pos = 0;
    while (ctr <= KYBER_N - 16 && pos <= REJ_UNIFORM_AVX_BUFLEN - 24) {
        vl = vsetvl_e8m1(128 / 8);
        f0 = vle8_v_u8m1(&buf[pos], vl);
        f1 = vle8_v_u8m1(&buf[pos + 12], vl);
        pos += 24;
        f0 = vrgather_vv_u8m1(f0, idx8, vl);
        f1 = vrgather_vv_u8m1(f1, idx8, vl);

        vl = vsetvl_e16m1(128 / 16);
        g0 = vreinterpret_v_u8m1_u16m1(f0);
        g1 = vreinterpret_v_u8m1_u16m1(f1);
        g0 = vsrl_vx_u16m1_m(mask_01, g0, g0, 4, vl);
        g1 = vsrl_vx_u16m1_m(mask_01, g1, g1, 4, vl);

        g0 = vand_vv_u16m1(g0, mask_12bits, vl);
        g1 = vand_vv_u16m1(g1, mask_12bits, vl);

        good0 = vmsltu_vv_u16m1_b16(g0, bound, vl);
        good1 = vmsltu_vv_u16m1_b16(g1, bound, vl);
        num0 = vcpop_m_b16(good0, vl);
        num1 = vcpop_m_b16(good1, vl);

        g0 = vcompress_vm_u16m1(good0, g0, g0, vl);
        g1 = vcompress_vm_u16m1(good1, g1, g1, vl);

        vse16_v_u16m1((uint16_t *)&r[ctr], g0, vl);
        ctr += num0;
        vse16_v_u16m1((uint16_t *)&r[ctr], g1, vl);
        ctr += num1;
    }
    while (ctr < KYBER_N && pos <= REJ_UNIFORM_AVX_BUFLEN - 3) {
        val0 =
            ((buf[pos + 0] >> 0) | ((uint16_t)buf[pos + 1] << 8)) & 0xFFF;
        val1 = ((buf[pos + 1] >> 4) | ((uint16_t)buf[pos + 2] << 4));
        pos += 3;
        if (val0 < KYBER_Q)
            r[ctr++] = val0;
        if (val1 < KYBER_Q && ctr < KYBER_N)
            r[ctr++] = val1;
    }
    return ctr;
}

#define ETA 2
#define SHAKE256_RATE 136
#define N 256

#if ETA == 2
#    define POLY_UNIFORM_ETA_NBLOCKS \
        ((136 + SHAKE256_RATE - 1) / SHAKE256_RATE)
#elif ETA == 4
#    define POLY_UNIFORM_ETA_NBLOCKS \
        ((227 + SHAKE256_RATE - 1) / SHAKE256_RATE)
#endif
#define POLY_UNIFORM_ETA_BUFLEN (POLY_UNIFORM_ETA_NBLOCKS * SHAKE256_RATE)

unsigned int rej_eta_vector(int32_t *a, const uint8_t *buf)
{
    unsigned int ctr, pos;
    uint32_t t0, t1;
    size_t vl;
    vuint8m1_t f0, f1, ft0, idx8;
    vuint32m4_t g0, g1;
    vuint32m4_t gt0, gt1;
    vbool8_t mask_10, mask_01;
    vbool8_t good0, good1;
    unsigned long num0, num1;

    const uint8_t idx8_t[16] __attribute__((aligned(16))) = {
        0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7};
    const uint8_t mask_10_t[16] = {1, 0, 1, 0, 1, 0, 1, 0,
                                   1, 0, 1, 0, 1, 0, 1, 0};

    vl = vsetvl_e8m1(128 / 8);
    ft0 = vle8_v_u8m1(mask_10_t, vl);
    mask_10 = vmseq_vx_u8m1_b8(ft0, 1, vl);
    mask_01 = vmsne_vx_u8m1_b8(ft0, 1, vl);
    idx8 = vle8_v_u8m1(idx8_t, vl);

    ctr = pos = 0;
    while (ctr <= N - 32 && pos <= POLY_UNIFORM_ETA_BUFLEN - 16) {
        vl = vsetvl_e8m1(128 / 8);
        f0 = vle8_v_u8m1(&buf[pos], vl);
        f1 = vle8_v_u8m1(&buf[pos + 8], vl);
        pos += vl;
        f0 = vrgather_vv_u8m1(f0, idx8, vl);
        f1 = vrgather_vv_u8m1(f1, idx8, vl);

        f0 = vand_vx_u8m1_m(mask_10, f0, f0, 0x0F, vl);
        f1 = vand_vx_u8m1_m(mask_10, f1, f1, 0x0F, vl);
        f0 = vsrl_vx_u8m1_m(mask_01, f0, f0, 4, vl);
        f1 = vsrl_vx_u8m1_m(mask_01, f1, f1, 4, vl);

        g0 = vzext_vf4_u32m4(f0, vl);
        g1 = vzext_vf4_u32m4(f1, vl);
#if ETA == 2
        good0 = vmsltu_vx_u32m4_b8(g0, 15, vl);
        good1 = vmsltu_vx_u32m4_b8(g1, 15, vl);
        gt0 = vmul_vx_u32m4(g0, 205, vl);
        gt1 = vmul_vx_u32m4(g1, 205, vl);
        gt0 = vsrl_vx_u32m4(gt0, 10, vl);
        gt1 = vsrl_vx_u32m4(gt1, 10, vl);
        gt0 = vmul_vx_u32m4(gt0, 5, vl);
        gt1 = vmul_vx_u32m4(gt1, 5, vl);
        g0 = vsub_vv_u32m4(g0, gt0, vl);
        g1 = vsub_vv_u32m4(g1, gt1, vl);
        num0 = vcpop_m_b8(good0, vl);
        num1 = vcpop_m_b8(good1, vl);
        g0 = vrsub_vx_u32m4(g0, 2, vl);
        g1 = vrsub_vx_u32m4(g1, 2, vl);
        g0 = vcompress_vm_u32m4(good0, g0, g0, vl);
        g1 = vcompress_vm_u32m4(good1, g1, g1, vl);
        vse32_v_u32m4((uint32_t *)&a[ctr], g0, vl);
        ctr += num0;
        vse32_v_u32m4((uint32_t *)&a[ctr], g1, vl);
        ctr += num1;
#elif ETA == 4
        good0 = vmsltu_vx_u32m4_b8(g0, 9, vl);
        good1 = vmsltu_vx_u32m4_b8(g1, 9, vl);
        g0 = vrsub_vx_u32m4(g0, 4, vl);
        g1 = vrsub_vx_u32m4(g1, 4, vl);
        num0 = vcpop_m_b8(good0, vl);
        num1 = vcpop_m_b8(good1, vl);
        g0 = vcompress_vm_u32m4(good0, g0, g0, vl);
        g1 = vcompress_vm_u32m4(good1, g1, g1, vl);
        vse32_v_u32m4((uint32_t *)&a[ctr], g0, vl);
        ctr += num0;
        vse32_v_u32m4((uint32_t *)&a[ctr], g1, vl);
        ctr += num1;
#endif
    }

    while (ctr < N && pos < POLY_UNIFORM_ETA_BUFLEN) {
        t0 = buf[pos] & 0x0F;
        t1 = buf[pos++] >> 4;

#if ETA == 2
        if (t0 < 15) {
            t0 = t0 - (205 * t0 >> 10) * 5;
            a[ctr++] = 2 - t0;
        }
        if (t1 < 15 && ctr < N) {
            t1 = t1 - (205 * t1 >> 10) * 5;
            a[ctr++] = 2 - t1;
        }
#elif ETA == 4
        if (t0 < 9)
            a[ctr++] = 4 - t0;
        if (t1 < 9 && ctr < N)
            a[ctr++] = 4 - t1;
#endif
    }

    return ctr;
}

unsigned int rej_eta(int32_t *a, unsigned int len, const uint8_t *buf,
                     unsigned int buflen)
{
    unsigned int ctr, pos;
    uint32_t t0, t1;

    ctr = pos = 0;
    while (ctr < len && pos < buflen) {
        t0 = buf[pos] & 0x0F;
        t1 = buf[pos++] >> 4;

#if ETA == 2
        if (t0 < 15) {
            t0 = t0 - (205 * t0 >> 10) * 5;
            a[ctr++] = 2 - t0;
        }
        if (t1 < 15 && ctr < len) {
            t1 = t1 - (205 * t1 >> 10) * 5;
            a[ctr++] = 2 - t1;
        }
#elif ETA == 4
        if (t0 < 9)
            a[ctr++] = 4 - t0;
        if (t1 < 9 && ctr < len)
            a[ctr++] = 4 - t1;
#endif
    }

    return ctr;
}

void test_dilithium_rej_eta()
{
    uint8_t buf[POLY_UNIFORM_ETA_BUFLEN];
    uint32_t a[N], b[N];
    unsigned int ctr0, ctr1;
    int i;

    for (i = 0; i < POLY_UNIFORM_ETA_BUFLEN; i++) {
        buf[i] = i * 10;
    }
    ctr0 = rej_eta_vector(a, buf);
    ctr1 = rej_eta(b, N, buf, POLY_UNIFORM_ETA_BUFLEN);

    printf("ctr0:%d,ctrl:%d\n", ctr0, ctr1);

    for (i = 0; i < N; i++) {
        printf("%d, ", a[i]);
    }
    printf("\n");
    for (i = 0; i < N; i++) {
        printf("%d, ", b[i]);
    }
    printf("\n");
}

static void cbd2_v(int16_t *r, const uint8_t buf[2 * KYBER_N / 4])
{
    // TODO: using m4
    unsigned int i, pos;
    size_t vl;
    const uint8_t idx8_0011_t[16] __attribute__((aligned(16))) = {
        0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7,
    };
    const uint8_t idx8_8899_t[16] = {
        8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15,
    };
    const uint8_t mask_0b0101_t[16] = {
        1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
    };

    vuint8m1_t f0, f1, f0t0, f0t1, f1t0, f1t1;
    vint16m2_t g0, g1;
    vuint8m1_t idx8_0011, idx8_8899;
    vbool8_t mask_0b0101;

    vl = vsetvl_e8m1(128 / 8);
    idx8_0011 = vle8_v_u8m1(idx8_0011_t, vl);
    idx8_8899 = vle8_v_u8m1(idx8_8899_t, vl);
    f0t0 = vle8_v_u8m1(mask_0b0101_t, vl);
    mask_0b0101 = vmseq_vx_u8m1_b8(f0t0, 1, vl);

    pos = 0;
    // 0100 0000
    for (i = 0; i < KYBER_N / 32; i++) {
        // f0=[a7,a6,a5,a4,a3,a2,a1,a0] low 8 bits
        f0 = vle8_v_u8m1(&buf[pos], vl);
        pos += vl;
        // f1=[0,a7,a6,a5,a4,a3,a2,a1] 0010 0000
        f1 = vsrl_vx_u8m1(f0, 1, vl);
        // f0=[0,a6,0,a4,0,a2,0,a0] 0100 0000
        f0 = vand_vx_u8m1(f0, 0x55, vl);
        // f1=[0,a7,0,a5,0,a3,0,a1] 0000 0000
        f1 = vand_vx_u8m1(f1, 0x55, vl);
        // f0=[0,a6+a7,0,a4+a5,0,a2+a3,0,a0+a1] 0100 0000
        f0 = vadd_vv_u8m1(f0, f1, vl);

        // f1=[0,0,0,a6+a7,0,a4+a5,0,a2+a3] 0001 0000
        f1 = vsrl_vx_u8m1(f0, 2, vl);
        // f0=[0,0,0,a4+a5,0,0,0,a0+a1] 0000 0000
        f0 = vand_vx_u8m1(f0, 0x33, vl);
        // f1=[0,0,0,a6+a7,0,0,0,a2+a3] 0001 0000
        f1 = vand_vx_u8m1(f1, 0x33, vl);

        // f0=[0,0,0,a4+a5+3,0,0,0,a0+a1+3]
        f0 = vadd_vx_u8m1(f0, 0x33, vl);
        // f0=[0,0,0,a4+a5+3-(a6+a7),0,0,0,a0+a1+3-(a2+a3)] 0011 0011
        f0 = vsub_vv_u8m1(f0, f1, vl);

        // f1=[0,0,0,0, 0,0,0,a4+a5+3-(a6+a7)]
        f1 = vsrl_vx_u8m1(f0, 4, vl);
        // f0=[0,0,0,0, 0,0,0,a0+a1+3-(a2+a3)]
        f0 = vand_vx_u8m1(f0, 0x0f, vl);
        // f1=[0,0,0,0, 0,0,0,a4+a5+3-(a6+a7)]
        // TODO: needed?
        f1 = vand_vx_u8m1(f1, 0x0f, vl);

        // f0=[0,0,0,0, 0,0,0,a0+a1-(a2+a3)]
        f0 = vsub_vx_u8m1(f0, 3, vl);
        // f1=[0,0,0,0, 0,0,0,a4+a5-(a6+a7)]
        f1 = vsub_vx_u8m1(f1, 3, vl);

        // In 4x8 bits view:
        // f0=[r6,r4,r2,r0]
        // f1=[r7,r5,r3,r1]
        // f0t0=[r2,r2,r0,r0] using vrgather
        // {0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7}
        // f1t0=[r3,r3,r1,r1]
        f0t0 = vrgather_vv_u8m1(f0, idx8_0011, vl);
        f1t0 = vrgather_vv_u8m1(f1, idx8_0011, vl);

        // f0t1=[r18,r18,r16,r16] using vrgather
        // {8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15}
        // f1t1=[r19,r19,r17,r17]
        f0t1 = vrgather_vv_u8m1(f0, idx8_8899, vl);
        f1t1 = vrgather_vv_u8m1(f1, idx8_8899, vl);
        print_bytes((uint8_t *)&f0t1, 16);
        print_bytes((uint8_t *)&f1t1, 16);
        // f0=[r3,r2,r1,r0] vmerge(f1t0,f0t0,mask_0b_0101)
        // f1=[r19,r18,r17,r16] vmerge(f1t1,f0t1,mask_0b_0101)
        f0 = vmerge_vvm_u8m1(mask_0b0101, f1t0, f0t0, vl);
        f1 = vmerge_vvm_u8m1(mask_0b0101, f1t1, f0t1, vl);
        g0 = vsext_vf2_i16m2(vreinterpret_v_u8m1_i8m1(f0), vl);
        g1 = vsext_vf2_i16m2(vreinterpret_v_u8m1_i8m1(f1), vl);
        vse16_v_i16m2(&r[i * 32 + 0], g0, vl);
        vse16_v_i16m2(&r[i * 32 + 16], g1, vl);
    }
}

static void cbd2_v_m4(int16_t *r, const uint8_t buf[2 * KYBER_N / 4])
{
    unsigned int i, j, pos;
    size_t vl;
    uint8_t idx_low_t[16 * 4] __attribute__((aligned(16)));
    uint8_t idx_high_t[16 * 4];
    uint8_t mask_0b0101_t[16 * 4];

    vuint8m4_t f0, f1, f0t0, f0t1, f1t0, f1t1;
    vint16m8_t g0, g1;
    vuint8m4_t idx_low, idx_high;
    vbool2_t mask_0b0101;

    // for (i = 0; i < 4; i++) {
    //     for (j = 0; j < 16; j += 2) {
    //         idx_low_t[i * 16 + j] = idx_low_t[i * 16 + j + 1] =
    //             i * 16 + (j >> 1);
    //         idx_high_t[i * 16 + j] = idx_high_t[i * 16 + j + 1] =
    //             i * 16 + 8 + (j >> 1);
    //     }
    // }
    for (i = 0; i < 16 * 4; i += 2) {
        idx_low_t[i] = idx_low_t[i + 1] = (i >> 1);
        idx_high_t[i] = idx_high_t[i + 1] = 32 + (i >> 1);
        mask_0b0101_t[i] = 1;
        mask_0b0101_t[i + 1] = 0;
    }

    print_bytes(idx_low_t, 16 * 4);
    print_bytes(idx_high_t, 16 * 4);
    vl = vsetvl_e8m4(128 / 8);
    vl *= 4;
    printf("vl=%d\n", vl);
    idx_low = vle8_v_u8m4(idx_low_t, vl);
    idx_high = vle8_v_u8m4(idx_high_t, vl);
    f0t0 = vle8_v_u8m4(mask_0b0101_t, vl);
    mask_0b0101 = vmseq_vx_u8m4_b2(f0t0, 1, vl);

    pos = 0;
    for (i = 0; i < 2; i++) {
        // f0=[a7,a6,a5,a4,a3,a2,a1,a0] low 8 bits
        f0 = vle8_v_u8m4(&buf[pos], vl);
        pos += vl;
        // f1=[0,a7,a6,a5,a4,a3,a2,a1]
        f1 = vsrl_vx_u8m4(f0, 1, vl);
        // f0=[0,a6,0,a4,0,a2,0,a0]
        f0 = vand_vx_u8m4(f0, 0x55, vl);
        // f1=[0,a7,0,a5,0,a3,0,a1]
        f1 = vand_vx_u8m4(f1, 0x55, vl);

        // f0=[0,a6+a7,0,a4+a5,0,a2+a3,0,a0+a1]
        f0 = vadd_vv_u8m4(f0, f1, vl);
        // f1=[0,0,0,a6+a7,0,a4+a5,0,a2+a3]
        f1 = vsrl_vx_u8m4(f0, 2, vl);

        // print_bytes((uint8_t *)&f0, 16);
        // print_bytes((uint8_t *)&f1, 16);

        // f0=[0,0,0,a4+a5,0,0,0,a0+a1]
        f0 = vand_vx_u8m4(f0, 0x33, vl);
        // f1=[0,0,0,a6+a7,0,0,0,a2+a3]
        f1 = vand_vx_u8m4(f1, 0x33, vl);

        // f0=[0,0,0,a4+a5+3,0,0,0,a0+a1+3]
        f0 = vadd_vx_u8m4(f0, 0x33, vl);
        // f0=[0,0,0,a4+a5+3-(a6+a7),0,0,0,a0+a1+3-(a2+a3)]
        f0 = vsub_vv_u8m4(f0, f1, vl);

        // f1=[0,0,0,0, 0,0,0,a4+a5+3-(a6+a7)]
        f1 = vsrl_vx_u8m4(f0, 4, vl);
        // f0=[0,0,0,0, 0,0,0,a0+a1+3-(a2+a3)]
        f0 = vand_vx_u8m4(f0, 0x0f, vl);
        // f1=[0,0,0,0, 0,0,0,a4+a5+3-(a6+a7)]
        // TODO: needed?
        f1 = vand_vx_u8m4(f1, 0x0f, vl);

        // f0=[0,0,0,0, 0,0,0,a0+a1-(a2+a3)]
        f0 = vsub_vx_u8m4(f0, 3, vl);
        // f1=[0,0,0,0, 0,0,0,a4+a5-(a6+a7)]
        f1 = vsub_vx_u8m4(f1, 3, vl);

        // In 4x8 bits view:
        // f0=[r6,r4,r2,r0]
        // f1=[r7,r5,r3,r1]
        // f0t0=[r2,r2,r0,r0] using vrgather
        // {0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7}
        // f1t0=[r3,r3,r1,r1]
        f0t0 = vrgather_vv_u8m4(f0, idx_low, vl);
        f1t0 = vrgather_vv_u8m4(f1, idx_low, vl);

        // f0t1=[r18,r18,r16,r16] using vrgather
        // {8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15}
        // f1t1=[r19,r19,r17,r17]
        f0t1 = vrgather_vv_u8m4(f0, idx_high, vl);
        f1t1 = vrgather_vv_u8m4(f1, idx_high, vl);

        print_bytes((uint8_t *)&f0t1, 16);
        print_bytes((uint8_t *)&f1t1, 16);
        print_bytes(&((uint8_t *)&f0t1)[16], 16);
        print_bytes(&((uint8_t *)&f1t1)[16], 16);
        print_bytes(&((uint8_t *)&f0t1)[32], 16);
        print_bytes(&((uint8_t *)&f1t1)[32], 16);
        print_bytes(&((uint8_t *)&f0t1)[48], 16);
        print_bytes(&((uint8_t *)&f1t1)[48], 16);

        // f0=[r3,r2,r1,r0] vmerge(f1t0,f0t0,mask_0b_0101)
        // f1=[r19,r18,r17,r16] vmerge(f1t1,f0t1,mask_0b_0101)
        f0 = vmerge_vvm_u8m4(mask_0b0101, f1t0, f0t0, vl);
        f1 = vmerge_vvm_u8m4(mask_0b0101, f1t1, f0t1, vl);
        g0 = vsext_vf2_i16m8(vreinterpret_v_u8m4_i8m4(f0), vl);
        g1 = vsext_vf2_i16m8(vreinterpret_v_u8m4_i8m4(f1), vl);
        vse16_v_i16m8(&r[i * 128 + 0], g0, vl);
        vse16_v_i16m8(&r[i * 128 + 64], g1, vl);
    }
}

static uint32_t load32_littleendian(const uint8_t x[4])
{
    uint32_t r;
    r = (uint32_t)x[0];
    r |= (uint32_t)x[1] << 8;
    r |= (uint32_t)x[2] << 16;
    r |= (uint32_t)x[3] << 24;
    return r;
}

static void cbd2(int16_t *r, const uint8_t buf[2 * KYBER_N / 4])
{
    unsigned int i, j;
    uint32_t t, d;
    int16_t a, b;

    for (i = 0; i < KYBER_N / 8; i++) {
        t = load32_littleendian(buf + 4 * i);
        d = t & 0x55555555;
        d += (t >> 1) & 0x55555555;

        for (j = 0; j < 8; j++) {
            a = (d >> (4 * j + 0)) & 0x3;
            b = (d >> (4 * j + 2)) & 0x3;
            r[8 * i + j] = a - b;
        }
    }
}

void test_cbd2()
{
    uint8_t buf[2 * KYBER_N / 4];
    int16_t r[KYBER_N];
    int i;
    for (i = 0; i < KYBER_N / 2; i++)
        buf[i] = i;

    buf[0] = 0b01000000;
    buf[1] = 0b01010001;

    cbd2_v(r, buf);
    for (i = 0; i < 256; i++)
        printf("%d, ", r[i]);
    printf("\n");

    cbd2_v_m4(r, buf);
    for (i = 0; i < 256; i++)
        printf("%d, ", r[i]);
    printf("\n");

    cbd2(r, buf);
    for (i = 0; i < 256; i++)
        printf("%d, ", r[i]);
    printf("\n");
}

static void cbd3_v(int16_t *r, const uint8_t buf[3 * KYBER_N / 4])
{
    unsigned int i, pos;
    size_t vl_e8, vl_e32;
    const uint8_t idx8_0122_t[16] __attribute__((aligned(16))) = {
        0, 1, 2, 2, 3, 4, 5, 5, 6, 7, 8, 8, 9, 10, 11, 11,
    };
    const uint32_t idx32_0011_t[4] = {0, 0, 1, 1};
    const uint32_t idx32_2233_t[4] = {2, 2, 3, 3};
    const uint32_t mask_0b0101_t[4] = {1, 0, 1, 0};
    uint32_t buf32[4];

    vuint8m1_t t0, idx8_0122;
    vuint32m1_t t1, idx32_0011, idx32_2233;
    vuint32m1_t f0, f1, f2, f3, f0t0, f0t1, f1t0, f1t1;
    vbool32_t mask_0b0101;

    vl_e32 = vsetvl_e32m1(128 / 32);
    t1 = vle32_v_u32m1(mask_0b0101_t, vl_e32);
    idx32_0011 = vle32_v_u32m1(idx32_0011_t, vl_e32);
    idx32_2233 = vle32_v_u32m1(idx32_2233_t, vl_e32);
    mask_0b0101 = vmseq_vx_u32m1_b32(t1, 1, vl_e32);
    vl_e8 = vsetvl_e8m1(128 / 8);
    idx8_0122 = vle8_v_u8m1(idx8_0122_t, vl_e8);
    pos = 0;
    for (i = 0; i < 1; i++) {
        t0 = vle8_v_u8m1(&buf[pos], vl_e8);
        pos += 12;
        t0 = vrgather_vv_u8m1(t0, idx8_0122, vl_e8);
        f0 = vreinterpret_v_u8m1_u32m1(t0);
        // f0 = vand_vx_u32m1(f0, 0x00FFFFFF, vl_e32);
        f1 = vsrl_vx_u32m1(f0, 1, vl_e32);
        f2 = vsrl_vx_u32m1(f0, 2, vl_e32);
        f0 = vand_vx_u32m1(f0, 0x249249, vl_e32);
        f1 = vand_vx_u32m1(f1, 0x249249, vl_e32);
        f2 = vand_vx_u32m1(f2, 0x249249, vl_e32);
        f0 = vadd_vv_u32m1(f0, f1, vl_e32);
        f0 = vadd_vv_u32m1(f0, f2, vl_e32);
        f1 = vsrl_vx_u32m1(f0, 3, vl_e32);
        f0 = vadd_vx_u32m1(f0, 0x6DB6DB, vl_e32);
        f0 = vsub_vv_u32m1(f0, f1, vl_e32);
        f1 = vsll_vx_u32m1(f0, 10, vl_e32);
        f2 = vsrl_vx_u32m1(f0, 12, vl_e32);
        f3 = vsrl_vx_u32m1(f0, 2, vl_e32);
        f0 = vand_vx_u32m1(f0, 7, vl_e32);
        f1 = vand_vx_u32m1(f1, 7 << 16, vl_e32);
        f2 = vand_vx_u32m1(f2, 7, vl_e32);
        f3 = vand_vx_u32m1(f3, 7 << 16, vl_e32);
        f0 = vadd_vv_u32m1(f0, f1, vl_e32);
        f1 = vadd_vv_u32m1(f2, f3, vl_e32);

        // vse32_v_u32m1(buf32, f0, vl_e32);
        // print_i16((int16_t *)buf32, 8);
        // vse32_v_u32m1(buf32, f1, vl_e32);
        // print_i16((int16_t *)buf32, 8);

        f0 = vreinterpret_v_u16m1_u32m1(
            vsub_vx_u16m1(vreinterpret_v_u32m1_u16m1(f0), 3, vl_e32 * 2));
        f1 = vreinterpret_v_u16m1_u32m1(
            vsub_vx_u16m1(vreinterpret_v_u32m1_u16m1(f1), 3, vl_e32 * 2));

        // vse32_v_u32m1(buf32, f0, vl_e32);
        // print_i16((int16_t *)buf32, 8);
        // vse32_v_u32m1(buf32, f1, vl_e32);
        // print_i16((int16_t *)buf32, 8);

        // 以32 bits为单位来看
        // f0=[r13r12,r9r8  ,r5r4,r1r0]
        // f1=[r15r14,r11r10,r7r6,r3r2]
        // f0t0=[r5r4,  r5r4,  r1r0,r1r0]
        // f1t0=[r7r6,  r7r6,  r3r2,r3r2] with {0,0,1,1}
        // f0t1=[r13r12,r13r12,r9r8,r9r8]
        // f1t1=[r15r14,r15r14,r11r10,r11r10] with {2,2,3,3}
        f0t0 = vrgather_vv_u32m1(f0, idx32_0011, vl_e32);
        f1t0 = vrgather_vv_u32m1(f1, idx32_0011, vl_e32);
        f0t1 = vrgather_vv_u32m1(f0, idx32_2233, vl_e32);
        f1t1 = vrgather_vv_u32m1(f1, idx32_2233, vl_e32);
        // f0=[r7r6,r5r4,r3r2,r1r0]
        // f1=[r15r14,r13r12,r11r10,r9r8]
        f0 = vmerge_vvm_u32m1(mask_0b0101, f1t0, f0t0, vl_e32);
        f1 = vmerge_vvm_u32m1(mask_0b0101, f1t1, f0t1, vl_e32);

        vse32_v_u32m1(buf32, f0, vl_e32);
        print_i16((int16_t *)buf32, 8);
        vse32_v_u32m1(buf32, f1, vl_e32);
        print_i16((int16_t *)buf32, 8);

        vse32_v_u32m1((uint32_t *)&r[i * 16 + 0], f0, vl_e32);
        vse32_v_u32m1((uint32_t *)&r[i * 16 + 8], f1, vl_e32);
    }
}

static uint32_t load24_littleendian(const uint8_t x[3])
{
    uint32_t r;
    r = (uint32_t)x[0];
    r |= (uint32_t)x[1] << 8;
    r |= (uint32_t)x[2] << 16;
    return r;
}

static void cbd3(int16_t *r, const uint8_t buf[3 * KYBER_N / 4])
{
    unsigned int i, j;
    uint32_t t, d;
    int16_t a, b;

    for (i = 0; i < KYBER_N / 4; i++) {
        t = load24_littleendian(buf + 3 * i);
        d = t & 0x00249249;
        d += (t >> 1) & 0x00249249;
        d += (t >> 2) & 0x00249249;

        for (j = 0; j < 4; j++) {
            a = (d >> (6 * j + 0)) & 0x7;
            b = (d >> (6 * j + 3)) & 0x7;
            r[4 * i + j] = a - b;
        }
    }
}

void test_cbd3()
{
    uint8_t buf[3 * KYBER_N / 4];
    int16_t r[KYBER_N];
    int i;
    for (i = 0; i < 3 * KYBER_N / 4; i++)
        buf[i] = i;
    // a0+a1+a2=0
    // a3+a4+a5=0
    // a6+a7+a8=1
    // a9+a10+a11=0
    // a12+a13+a14=2
    // a15+a16+a17=0
    // a18+a19+a20=0
    // a21+a22+a23=3
    buf[0] = 0b01000000;
    buf[1] = 0b00110000;
    buf[2] = 0b11100000;

    buf[3] = 0b01000000;
    buf[4] = 0b00110000;
    buf[5] = 0b11111100;

    // buf[6] = 0b01000000;
    // buf[7] = 0b00110000;
    // buf[8] = 0b11100000;

    // buf[9] = 0b01000000;
    // buf[10] = 0b00110000;
    // buf[11] = 0b11100000;

    cbd3_v(r, buf);
    for (i = 0; i < 256; i++)
        printf("%d, ", r[i]);
    printf("\n");

    cbd3(r, buf);
    for (i = 0; i < 256; i++)
        printf("%d, ", r[i]);
    printf("\n");
}

#define NTESTS 10000

uint64_t t[NTESTS];

int main()
{
    // printf("Test add function by rvv0.7.1 intrinsic \n");
    // add(a_array, b_array, c_array_ref, ARRAY_SIZE);
    // add_vec(a_array, b_array, c_array_vec, ARRAY_SIZE);

    // // 逐个比较普通实现与intrinsic实现的结果
    // for (int i = 0; i < ARRAY_SIZE; i++) {
    //     if (fabsf(c_array_ref[i] - c_array_vec[i]) > 1e-6) {
    //         printf("index[%d] failed, %f=!%f\n", i, c_array_ref[i],
    //                c_array_vec[i]);
    //     } else {
    //         printf("index[%d] successed, %f=%f\n", i, c_array_ref[i],
    //                c_array_vec[i]);
    //     }
    // }
    // unsigned int i, ctr = 0;
    // int16_t r[256] = {0};
    // uint8_t buf[REJ_UNIFORM_AVX_BUFLEN + 16 - 12];
    // for (int i = 0; i < REJ_UNIFORM_AVX_BUFLEN; i++)
    //     buf[i] = i;
    // ctr = rej_uniform(r, 256, buf, REJ_UNIFORM_AVX_BUFLEN);
    // printf("ctr=%d\n", ctr);
    // print_u16((uint8_t *)r, ctr);
    // memset(r, 0, sizeof(r));
    // ctr = rej_uniform_vector(r, buf);
    // printf("ctr=%d\n", ctr);
    // print_u16((uint8_t *)r, ctr);

    // for (i = 0; i < NTESTS; i++) {
    //     t[i] = cpucycles();
    //     rej_uniform(r, 256, buf, REJ_UNIFORM_AVX_BUFLEN);
    // }
    // print_results("rej_uniform: ", t, NTESTS);

    // for (i = 0; i < NTESTS; i++) {
    //     t[i] = cpucycles();
    //     rej_uniform_vector(r, buf);
    // }
    // print_results("rej_uniform_vector: ", t, NTESTS);
    // return 0;

    // test_vzext();

    // test_dilithium_rej_eta();
    // test_cbd2();
    test_cbd3();

    return 0;
}