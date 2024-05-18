#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define KYBER_Q 3329
#define QINV 0x3c0f12886ba8f301  // Q^{-1} mod^{+-} 2^64
#define R2modQ 341               // -2^64 mod^{+-} Q
#define INVN 3303                // NTT_N^{-1} mod Q

int16_t root = 17;

// 4+3 layer merging
int32_t treeNTTMerged_7layer[] = {
    64,  32,  96,  16,  80,  48,  112, 8,   72,  40,  104, 24,  88,  56,  120,
    4,   2,   66,  1,   65,  33,  97,  68,  34,  98,  17,  81,  49,  113, 36,
    18,  82,  9,   73,  41,  105, 100, 50,  114, 25,  89,  57,  121, 20,  10,
    74,  5,   69,  37,  101, 84,  42,  106, 21,  85,  53,  117, 52,  26,  90,
    13,  77,  45,  109, 116, 58,  122, 29,  93,  61,  125, 12,  6,   70,  3,
    67,  35,  99,  76,  38,  102, 19,  83,  51,  115, 44,  22,  86,  11,  75,
    43,  107, 108, 54,  118, 27,  91,  59,  123, 28,  14,  78,  7,   71,  39,
    103, 92,  46,  110, 23,  87,  55,  119, 60,  30,  94,  15,  79,  47,  111,
    124, 62,  126, 31,  95,  63,  127};

int32_t treeINTTMerged_7layer[] = {
    1,   65,  33,  97,  2,   66,  4,   17,  81,  49,  113, 34,  98,  68,  9,
    73,  41,  105, 18,  82,  36,  25,  89,  57,  121, 50,  114, 100, 5,   69,
    37,  101, 10,  74,  20,  21,  85,  53,  117, 42,  106, 84,  13,  77,  45,
    109, 26,  90,  52,  29,  93,  61,  125, 58,  122, 116, 3,   67,  35,  99,
    6,   70,  12,  19,  83,  51,  115, 38,  102, 76,  11,  75,  43,  107, 22,
    86,  44,  27,  91,  59,  123, 54,  118, 108, 7,   71,  39,  103, 14,  78,
    28,  23,  87,  55,  119, 46,  110, 92,  15,  79,  47,  111, 30,  94,  60,
    31,  95,  63,  127, 62,  126, 124, 8,   72,  40,  104, 24,  88,  56,  120,
    16,  80,  48,  112, 32,  96,  64};

int32_t treeMulTable_7layer[] = {
    1,  129, 65, 193, 33, 161, 97,  225, 17, 145, 81, 209, 49, 177, 113, 241,
    9,  137, 73, 201, 41, 169, 105, 233, 25, 153, 89, 217, 57, 185, 121, 249,
    5,  133, 69, 197, 37, 165, 101, 229, 21, 149, 85, 213, 53, 181, 117, 245,
    13, 141, 77, 205, 45, 173, 109, 237, 29, 157, 93, 221, 61, 189, 125, 253,
    3,  131, 67, 195, 35, 163, 99,  227, 19, 147, 83, 211, 51, 179, 115, 243,
    11, 139, 75, 203, 43, 171, 107, 235, 27, 155, 91, 219, 59, 187, 123, 251,
    7,  135, 71, 199, 39, 167, 103, 231, 23, 151, 87, 215, 55, 183, 119, 247,
    15, 143, 79, 207, 47, 175, 111, 239, 31, 159, 95, 223, 63, 191, 127, 255};

void cmod_int16(void *des, void *src, void *mod)
{
    int16_t mod_v = *(int16_t *)mod;
    int16_t t = (*(int16_t *)src) % mod_v;
    if (t >= (mod_v >> 1)) {
        t -= mod_v;
    }
    if (t < -(mod_v >> 1)) {
        t += mod_v;
    }
    *(int16_t *)des = t;
}

void cmod_int32(void *des, void *src, void *mod)
{
    int32_t mod_v = *(int32_t *)mod;
    int32_t t = (*(int32_t *)src) % mod_v;
    if (t >= (mod_v >> 1)) {
        t -= mod_v;
    }
    if (t < -(mod_v >> 1)) {
        t += mod_v;
    }
    *(int32_t *)des = t;
}

void cmod_int64(void *des, void *src, void *mod)
{
    int64_t mod_v = *(int64_t *)mod;
    int64_t t = (*(int64_t *)src) % mod_v;
    if (t >= (mod_v >> 1)) {
        t -= mod_v;
    }
    if (t < -(mod_v >> 1)) {
        t += mod_v;
    }
    *(int64_t *)des = t;
}

void mulmod_int16(void *des, void *src1, void *src2, void *mod)
{
    int32_t src1_v;
    int32_t src2_v;
    int32_t tmp_v;
    int32_t mod_v;
    int32_t des_v;

    src1_v = (int32_t)(*(int16_t *)src1);
    src2_v = (int32_t)(*(int16_t *)src2);
    tmp_v = src1_v * src2_v;
    mod_v = (int32_t)(*(int16_t *)mod);

    cmod_int32(&des_v, &tmp_v, &mod_v);

    *(int16_t *)des = (int16_t)des_v;
}

void addmod_int32(void *des, void *src1, void *src2, void *mod)
{
    int64_t src1_v;
    int64_t src2_v;
    int64_t tmp_v;
    int64_t mod_v;
    int64_t des_v;

    src1_v = (int64_t)(*(int32_t *)src1);
    src2_v = (int64_t)(*(int32_t *)src2);
    tmp_v = src1_v + src2_v;
    mod_v = (int64_t)(*(int32_t *)mod);

    cmod_int64(&des_v, &tmp_v, &mod_v);

    *(int32_t *)des = (int32_t)des_v;
}

void submod_int32(void *des, void *src1, void *src2, void *mod)
{
    int64_t src1_v;
    int64_t src2_v;
    int64_t tmp_v;
    int64_t mod_v;
    int64_t des_v;

    src1_v = (int64_t)(*(int32_t *)src1);
    src2_v = (int64_t)(*(int32_t *)src2);
    tmp_v = src1_v - src2_v;
    mod_v = (int64_t)(*(int32_t *)mod);

    cmod_int64(&des_v, &tmp_v, &mod_v);

    *(int32_t *)des = (int32_t)des_v;
}

void submod_int16(void *des, void *src1, void *src2, void *mod)
{
    int32_t src1_v;
    int32_t src2_v;
    int32_t tmp_v;
    int32_t mod_v;
    int32_t des_v;

    src1_v = (int32_t)(*(int16_t *)src1);
    src2_v = (int32_t)(*(int16_t *)src2);
    tmp_v = src1_v - src2_v;
    mod_v = (int32_t)(*(int16_t *)mod);

    cmod_int32(&des_v, &tmp_v, &mod_v);

    *(int16_t *)des = (int16_t)des_v;
}

void mulmod_int32(void *des, void *src1, void *src2, void *mod)
{
    int64_t src1_v;
    int64_t src2_v;
    int64_t tmp_v;
    int64_t mod_v;
    int64_t des_v;

    src1_v = (int64_t)(*(int32_t *)src1);
    src2_v = (int64_t)(*(int32_t *)src2);
    tmp_v = src1_v * src2_v;
    mod_v = (int64_t)(*(int32_t *)mod);

    cmod_int64(&des_v, &tmp_v, &mod_v);

    *(int32_t *)des = (int32_t)des_v;
}

// get the lower 32-bit
void mul_int32(void *des, void *src1, void *src2)
{
    uint64_t src1_v;
    uint64_t src2_v;
    uint64_t tmp_v;
    uint64_t des_v;

    src1_v = (uint64_t)(*(int16_t *)src1);
    src2_v = (uint64_t)(*(uint64_t *)src2);
    tmp_v = src1_v * src2_v;

    *(uint32_t *)des = (uint32_t)tmp_v;
}

// get the lower 64-bit
void mul_int64(void *des, void *src1, void *src2)
{
    __uint128_t src1_v;
    __uint128_t src2_v;
    __uint128_t tmp_v;

    src1_v = (__uint128_t)(*(int16_t *)src1);
    src2_v = (__uint128_t)(*(uint64_t *)src2);
    tmp_v = src1_v * src2_v;

    *(uint64_t *)des = (uint64_t)tmp_v;
}

void expmod_int16(void *des, void *src, size_t e, void *mod)
{
    int16_t src_v = *(int16_t *)src;
    int16_t tmp_v;

    tmp_v = 1;
    for (; e; e >>= 1) {
        if (e & 1) {
            mulmod_int16(&tmp_v, &tmp_v, &src_v, mod);
        }
        mulmod_int16(&src_v, &src_v, &src_v, mod);
    }

    memcpy(des, &tmp_v, sizeof(int16_t));
}

void expmod_int32(void *des, void *src, size_t e, void *mod)
{
    int32_t src_v = *(int32_t *)src;
    int32_t tmp_v;

    tmp_v = 1;
    for (; e; e >>= 1) {
        if (e & 1) {
            mulmod_int32(&tmp_v, &tmp_v, &src_v, mod);
        }
        mulmod_int32(&src_v, &src_v, &src_v, mod);
    }

    memcpy(des, &tmp_v, sizeof(int32_t));
}

void GenTables_7layer(void)
{
    int32_t t, j;
    int16_t t0, t1;
    uint64_t table_zetaqinv[128];
    uint32_t invN;
    uint64_t qinv;
    int16_t q, r2modq;

    qinv = QINV;
    q = KYBER_Q;
    r2modq = R2modQ;
    invN = INVN;
    memset(table_zetaqinv, 0, 128 * sizeof(uint64_t));
    for (j = 0; j < 127; j++) {
        expmod_int16(&t0, &root, treeNTTMerged_7layer[j], &q);
        mulmod_int16(&t0, &t0, &r2modq, &q);
        mul_int64(&table_zetaqinv[j], &t0, &qinv);
    }
    for (j = 0; j < 127; j++)
        printf("%ld, ", table_zetaqinv[j]);
    printf("\n\n");

    memset(table_zetaqinv, 0, 128 * sizeof(uint64_t));
    for (j = 0; j < 127; j++) {
        expmod_int16(&t0, &root, treeMulTable_7layer[j], &q);
        mulmod_int16(&t0, &t0, &r2modq, &q);
        mul_int64(&table_zetaqinv[j], &t0, &qinv);
    }
    for (j = 0; j < 127; j += 2)
        printf("%ld, ", table_zetaqinv[j]);
    printf("\n\n");

    memset(table_zetaqinv, 0, 128 * sizeof(uint64_t));
    for (j = 0; j < 127; j++) {
        expmod_int16(&t0, &root, 256 - treeINTTMerged_7layer[j], &q);
        mulmod_int16(&t0, &t0, &r2modq, &q);
        if (j == 126) {
            // invN * R2modQ
            mulmod_int16(&t1, &invN, &r2modq, &q);
            mulmod_int16(&t0, &t0, &t1, &q);
        }
        mul_int64(&table_zetaqinv[j], &t0, &qinv);
    }

    mulmod_int16(&t1, &invN, &r2modq, &q);
    mulmod_int16(&t1, &t1, &r2modq, &q);
    mul_int64(&table_zetaqinv[127], &t1, &qinv);

    for (j = 0; j < 128; j++)
        printf("%ld, ", table_zetaqinv[j]);
    printf("\n\n");
}

int main(void)
{
    GenTables_7layer();
    return 0;
}