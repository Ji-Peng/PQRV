#include <stdint.h>
#include <stdio.h>
#include <string.h>

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

    src1_v = (uint64_t)(*(int32_t *)src1);
    src2_v = (uint64_t)(*(int32_t *)src2);
    tmp_v = src1_v * src2_v;

    *(uint32_t *)des = (uint32_t)tmp_v;
}

// get the lower 64-bit
void mul_int64(void *des, void *src1, void *src2)
{
    __uint128_t src1_v;
    __uint128_t src2_v;
    __uint128_t tmp_v;

    src1_v = (__uint128_t)(*(int32_t *)src1);
    src2_v = (__uint128_t)(*(int64_t *)src2);
    tmp_v = src1_v * src2_v;

    *(uint64_t *)des = (uint64_t)tmp_v;
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

void GenTables_Dilithium_44merging()
{
    int32_t treeNTT44merging[] = {
        128, 64,  192, 32,  160, 96,  224, 16,  144, 80,  208, 48,  176,
        112, 240, 8,   4,   132, 2,   130, 66,  194, 1,   129, 65,  193,
        33,  161, 97,  225, 136, 68,  196, 34,  162, 98,  226, 17,  145,
        81,  209, 49,  177, 113, 241, 72,  36,  164, 18,  146, 82,  210,
        9,   137, 73,  201, 41,  169, 105, 233, 200, 100, 228, 50,  178,
        114, 242, 25,  153, 89,  217, 57,  185, 121, 249, 40,  20,  148,
        10,  138, 74,  202, 5,   133, 69,  197, 37,  165, 101, 229, 168,
        84,  212, 42,  170, 106, 234, 21,  149, 85,  213, 53,  181, 117,
        245, 104, 52,  180, 26,  154, 90,  218, 13,  141, 77,  205, 45,
        173, 109, 237, 232, 116, 244, 58,  186, 122, 250, 29,  157, 93,
        221, 61,  189, 125, 253, 24,  12,  140, 6,   134, 70,  198, 3,
        131, 67,  195, 35,  163, 99,  227, 152, 76,  204, 38,  166, 102,
        230, 19,  147, 83,  211, 51,  179, 115, 243, 88,  44,  172, 22,
        150, 86,  214, 11,  139, 75,  203, 43,  171, 107, 235, 216, 108,
        236, 54,  182, 118, 246, 27,  155, 91,  219, 59,  187, 123, 251,
        56,  28,  156, 14,  142, 78,  206, 7,   135, 71,  199, 39,  167,
        103, 231, 184, 92,  220, 46,  174, 110, 238, 23,  151, 87,  215,
        55,  183, 119, 247, 120, 60,  188, 30,  158, 94,  222, 15,  143,
        79,  207, 47,  175, 111, 239, 248, 124, 252, 62,  190, 126, 254,
        31,  159, 95,  223, 63,  191, 127, 255};

    int32_t treeINTT44merging[] = {
        1,   129, 65,  193, 33,  161, 97,  225, 2,   130, 66,  194, 4,
        132, 8,   17,  145, 81,  209, 49,  177, 113, 241, 34,  162, 98,
        226, 68,  196, 136, 9,   137, 73,  201, 41,  169, 105, 233, 18,
        146, 82,  210, 36,  164, 72,  25,  153, 89,  217, 57,  185, 121,
        249, 50,  178, 114, 242, 100, 228, 200, 5,   133, 69,  197, 37,
        165, 101, 229, 10,  138, 74,  202, 20,  148, 40,  21,  149, 85,
        213, 53,  181, 117, 245, 42,  170, 106, 234, 84,  212, 168, 13,
        141, 77,  205, 45,  173, 109, 237, 26,  154, 90,  218, 52,  180,
        104, 29,  157, 93,  221, 61,  189, 125, 253, 58,  186, 122, 250,
        116, 244, 232, 3,   131, 67,  195, 35,  163, 99,  227, 6,   134,
        70,  198, 12,  140, 24,  19,  147, 83,  211, 51,  179, 115, 243,
        38,  166, 102, 230, 76,  204, 152, 11,  139, 75,  203, 43,  171,
        107, 235, 22,  150, 86,  214, 44,  172, 88,  27,  155, 91,  219,
        59,  187, 123, 251, 54,  182, 118, 246, 108, 236, 216, 7,   135,
        71,  199, 39,  167, 103, 231, 14,  142, 78,  206, 28,  156, 56,
        23,  151, 87,  215, 55,  183, 119, 247, 46,  174, 110, 238, 92,
        220, 184, 15,  143, 79,  207, 47,  175, 111, 239, 30,  158, 94,
        222, 60,  188, 120, 31,  159, 95,  223, 63,  191, 127, 255, 62,
        190, 126, 254, 124, 252, 248, 16,  144, 80,  208, 48,  176, 112,
        240, 32,  160, 96,  224, 64,  192, 128};

    int32_t t0, t1, j;
    int64_t table_zetaqinv[256];
    int32_t invN;
    int64_t qinv;
    int32_t q, r2modq;
    int32_t dilithium_root = 1753;

    qinv = 0x180a406003802001;
    q = 8380417;
    r2modq = 6014466;
    invN = 0x7f6021;

    memset(table_zetaqinv, 0, 256 * sizeof(uint64_t));
    for (j = 0; j < 256 - 1; j++) {
        expmod_int32(&t0, &dilithium_root, treeNTT44merging[j], &q);
        mulmod_int32(&t0, &t0, &r2modq, &q);
        mul_int64(&table_zetaqinv[j], &t0, &qinv);
    }
    for (j = 0; j < 256 - 1; j++)
        printf("%ld, ", table_zetaqinv[j]);
    printf("\n\n");

    memset(table_zetaqinv, 0, 256 * sizeof(uint64_t));
    for (j = 0; j < 256 - 1; j++) {
        expmod_int32(&t0, &dilithium_root, 512 - treeINTT44merging[j], &q);
        mulmod_int32(&t0, &t0, &r2modq, &q);
        if (j == 254) {
            // invN * R2modQ
            mulmod_int32(&t1, &invN, &r2modq, &q);
            mulmod_int32(&t0, &t0, &t1, &q);
        }
        mul_int64(&table_zetaqinv[j], &t0, &qinv);
    }
    mulmod_int32(&t1, &invN, &r2modq, &q);
    mulmod_int32(&t1, &t1, &r2modq, &q);
    mul_int64(&table_zetaqinv[255], &t1, &qinv);
    for (j = 0; j < 256; j++)
        printf("%ld, ", table_zetaqinv[j]);
    printf("\n\n");
}

int main(void)
{
    GenTables_Dilithium_44merging();
    return 0;
}