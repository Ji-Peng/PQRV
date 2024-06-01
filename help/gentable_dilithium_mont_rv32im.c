#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define N 256
#define Q 8380417
#define ROOT_OF_UNITY 1753
#define MONT -4186625   // 2^32 % Q
#define R2modQ 2365951  // 2^64 % Q
#define QINV 58728449   // q^(-1) mod 2^32
#define INVN -32736     // N^-1 mod Q

int32_t root = ROOT_OF_UNITY;

int32_t tree_ntt_c[] = {
    128, 64,  192, 32,  160, 96,  224, 16,  144, 80,  208, 48,  176, 112,
    240, 8,   136, 72,  200, 40,  168, 104, 232, 24,  152, 88,  216, 56,
    184, 120, 248, 4,   132, 68,  196, 36,  164, 100, 228, 20,  148, 84,
    212, 52,  180, 116, 244, 12,  140, 76,  204, 44,  172, 108, 236, 28,
    156, 92,  220, 60,  188, 124, 252, 2,   130, 66,  194, 34,  162, 98,
    226, 18,  146, 82,  210, 50,  178, 114, 242, 10,  138, 74,  202, 42,
    170, 106, 234, 26,  154, 90,  218, 58,  186, 122, 250, 6,   134, 70,
    198, 38,  166, 102, 230, 22,  150, 86,  214, 54,  182, 118, 246, 14,
    142, 78,  206, 46,  174, 110, 238, 30,  158, 94,  222, 62,  190, 126,
    254, 1,   129, 65,  193, 33,  161, 97,  225, 17,  145, 81,  209, 49,
    177, 113, 241, 9,   137, 73,  201, 41,  169, 105, 233, 25,  153, 89,
    217, 57,  185, 121, 249, 5,   133, 69,  197, 37,  165, 101, 229, 21,
    149, 85,  213, 53,  181, 117, 245, 13,  141, 77,  205, 45,  173, 109,
    237, 29,  157, 93,  221, 61,  189, 125, 253, 3,   131, 67,  195, 35,
    163, 99,  227, 19,  147, 83,  211, 51,  179, 115, 243, 11,  139, 75,
    203, 43,  171, 107, 235, 27,  155, 91,  219, 59,  187, 123, 251, 7,
    135, 71,  199, 39,  167, 103, 231, 23,  151, 87,  215, 55,  183, 119,
    247, 15,  143, 79,  207, 47,  175, 111, 239, 31,  159, 95,  223, 63,
    191, 127, 255};

int32_t tree_6layer_ntt[] = {
    128, 64,  192, 32,  160, 96,  224, 16,  144, 80,  208, 48,  176,
    112, 240, 8,   136, 72,  200, 40,  168, 104, 232, 24,  152, 88,
    216, 56,  184, 120, 248, 4,   132, 68,  196, 36,  164, 100, 228,
    20,  148, 84,  212, 52,  180, 116, 244, 12,  140, 76,  204, 44,
    172, 108, 236, 28,  156, 92,  220, 60,  188, 124, 252};

int32_t tree_6layer_intt[] = {
    4,   132, 68,  196, 36,  164, 100, 228, 20,  148, 84,  212, 52,
    180, 116, 244, 12,  140, 76,  204, 44,  172, 108, 236, 28,  156,
    92,  220, 60,  188, 124, 252, 8,   136, 72,  200, 40,  168, 104,
    232, 24,  152, 88,  216, 56,  184, 120, 248, 16,  144, 80,  208,
    48,  176, 112, 240, 32,  160, 96,  224, 64,  192, 128};

int32_t tree_6layer_basemul[] = {4,  132, 68, 196, 36, 164, 100, 228,
                                 20, 148, 84, 212, 52, 180, 116, 244,
                                 12, 140, 76, 204, 44, 172, 108, 236,
                                 28, 156, 92, 220, 60, 188, 124, 252};

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

void GenTable_c_ref(void)
{
    int32_t t0, t1, j, zetas[256];
    int32_t qinv, invN, q, mont;

    q = Q;
    qinv = QINV;
    invN = INVN;
    mont = MONT;

    memset(zetas, 0, 256 * sizeof(int32_t));
    for (j = 0; j < 256 - 1; j++) {
        expmod_int32(&t0, &root, tree_ntt_c[j], &q);
        mulmod_int32(&zetas[j], &t0, &mont, &q);
    }
    for (j = 0; j < 256 - 1; j++)
        printf("%d, ", zetas[j]);
    printf("\n\n");
}

void gen_table_c_6layer(void)
{
    int32_t t0, t1, j, zetas[64];
    int32_t qinv, invN, q, mont;

    q = Q;
    qinv = QINV;
    invN = INVN;
    mont = MONT;

    memset(zetas, 0, 64 * sizeof(int32_t));
    for (j = 0; j < 64 - 1; j++) {
        expmod_int32(&t0, &root, tree_6layer_ntt[j], &q);
        mulmod_int32(&zetas[j], &t0, &mont, &q);
    }
    printf("6-layer ntt:\n");
    for (j = 0; j < 64 - 1; j++)
        printf("%d, ", zetas[j]);
    printf("\n\n");

    memset(zetas, 0, 64 * sizeof(int32_t));
    for (j = 0; j < 64 - 1; j++) {
        expmod_int32(&t0, &root, 512 - tree_6layer_intt[j], &q);
        mulmod_int32(&zetas[j], &t0, &mont, &q);
    }
    printf("6-layer intt:\n");
    for (j = 0; j < 64 - 1; j++)
        printf("%d, ", zetas[j]);
    printf("\n\n");

    memset(zetas, 0, 64 * sizeof(int32_t));
    for (j = 0; j < 32; j++) {
        expmod_int32(&t0, &root, tree_6layer_basemul[j], &q);
        mulmod_int32(&zetas[j], &t0, &mont, &q);
    }
    printf("6-layer basemul:\n");
    for (j = 0; j < 32; j++)
        printf("%d, ", zetas[j]);
    printf("\n\n");
}

int main()
{
    // GenTable_c_ref();
    gen_table_c_6layer();
    return 0;
}