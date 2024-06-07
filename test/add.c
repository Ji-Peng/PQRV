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
    unsigned int i, ctr = 0;
    int16_t r[256] = {0};
    uint8_t buf[REJ_UNIFORM_AVX_BUFLEN + 16 - 12];
    for (int i = 0; i < REJ_UNIFORM_AVX_BUFLEN; i++)
        buf[i] = i;
    ctr = rej_uniform(r, 256, buf, REJ_UNIFORM_AVX_BUFLEN);
    printf("ctr=%d\n", ctr);
    print_u16((uint8_t *)r, ctr);
    memset(r, 0, sizeof(r));
    ctr = rej_uniform_vector(r, buf);
    printf("ctr=%d\n", ctr);
    print_u16((uint8_t *)r, ctr);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        rej_uniform(r, 256, buf, REJ_UNIFORM_AVX_BUFLEN);
    }
    print_results("rej_uniform: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        rej_uniform_vector(r, buf);
    }
    print_results("rej_uniform_vector: ", t, NTESTS);
    return 0;
}