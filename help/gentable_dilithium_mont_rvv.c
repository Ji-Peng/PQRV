#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define N 256
#define Q 8380417
#define ROOT_OF_UNITY 1753
#define MONT -4186625   // 2^32 % Q
#define R2modQ 2365951  // 2^64 % Q
#define QINV 58728449   // q^(-1) mod 2^32
#define INVN 8347681    // N^-1 mod Q
#define INV64 8249473   // 64^-1 mod Q

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

int32_t tree_33merging_ntt[] = {
    128, 64,  192, 32,  160, 96,  224, 16,  8,   136, 4,   132, 68,
    196, 144, 72,  200, 36,  164, 100, 228, 80,  40,  168, 20,  148,
    84,  212, 208, 104, 232, 52,  180, 116, 244, 48,  24,  152, 12,
    140, 76,  204, 176, 88,  216, 44,  172, 108, 236, 112, 56,  184,
    28,  156, 92,  220, 240, 120, 248, 60,  188, 124, 252};

int32_t tree_33merging_intt[] = {
    4,   132, 68,  196, 8,   136, 16,  36,  164, 100, 228, 72,  200,
    144, 20,  148, 84,  212, 40,  168, 80,  52,  180, 116, 244, 104,
    232, 208, 12,  140, 76,  204, 24,  152, 48,  44,  172, 108, 236,
    88,  216, 176, 28,  156, 92,  220, 56,  184, 112, 60,  188, 124,
    252, 120, 248, 240, 32,  160, 96,  224, 64,  192, 128};

int32_t tree_6layer_basemul[] = {4,  132, 68, 196, 36, 164, 100, 228,
                                 20, 148, 84, 212, 52, 180, 116, 244,
                                 12, 140, 76, 204, 44, 172, 108, 236,
                                 28, 156, 92, 220, 60, 188, 124, 252};

int32_t treeNTT44merging[] = {
    128, 64,  192, 32,  160, 96,  224, 16,  144, 80,  208, 48,  176, 112,
    240, 8,   136, 72,  200, 4,   132, 68,  196, 36,  164, 100, 228, 2,
    130, 66,  194, 34,  162, 98,  226, 18,  146, 82,  210, 50,  178, 114,
    242, 1,   129, 65,  193, 33,  161, 97,  225, 17,  145, 81,  209, 49,
    177, 113, 241, 9,   137, 73,  201, 41,  169, 105, 233, 25,  153, 89,
    217, 57,  185, 121, 249, 40,  168, 104, 232, 20,  148, 84,  212, 52,
    180, 116, 244, 10,  138, 74,  202, 42,  170, 106, 234, 26,  154, 90,
    218, 58,  186, 122, 250, 5,   133, 69,  197, 37,  165, 101, 229, 21,
    149, 85,  213, 53,  181, 117, 245, 13,  141, 77,  205, 45,  173, 109,
    237, 29,  157, 93,  221, 61,  189, 125, 253, 24,  152, 88,  216, 12,
    140, 76,  204, 44,  172, 108, 236, 6,   134, 70,  198, 38,  166, 102,
    230, 22,  150, 86,  214, 54,  182, 118, 246, 3,   131, 67,  195, 35,
    163, 99,  227, 19,  147, 83,  211, 51,  179, 115, 243, 11,  139, 75,
    203, 43,  171, 107, 235, 27,  155, 91,  219, 59,  187, 123, 251, 56,
    184, 120, 248, 28,  156, 92,  220, 60,  188, 124, 252, 14,  142, 78,
    206, 46,  174, 110, 238, 30,  158, 94,  222, 62,  190, 126, 254, 7,
    135, 71,  199, 39,  167, 103, 231, 23,  151, 87,  215, 55,  183, 119,
    247, 15,  143, 79,  207, 47,  175, 111, 239, 31,  159, 95,  223, 63,
    191, 127, 255};

int32_t treeINTT44merging[] = {
    1,   129, 65,  193, 33,  161, 97,  225, 17,  145, 81,  209, 49,  177,
    113, 241, 9,   137, 73,  201, 41,  169, 105, 233, 25,  153, 89,  217,
    57,  185, 121, 249, 2,   130, 66,  194, 34,  162, 98,  226, 18,  146,
    82,  210, 50,  178, 114, 242, 4,   132, 68,  196, 36,  164, 100, 228,
    8,   136, 72,  200, 5,   133, 69,  197, 37,  165, 101, 229, 21,  149,
    85,  213, 53,  181, 117, 245, 13,  141, 77,  205, 45,  173, 109, 237,
    29,  157, 93,  221, 61,  189, 125, 253, 10,  138, 74,  202, 42,  170,
    106, 234, 26,  154, 90,  218, 58,  186, 122, 250, 20,  148, 84,  212,
    52,  180, 116, 244, 40,  168, 104, 232, 3,   131, 67,  195, 35,  163,
    99,  227, 19,  147, 83,  211, 51,  179, 115, 243, 11,  139, 75,  203,
    43,  171, 107, 235, 27,  155, 91,  219, 59,  187, 123, 251, 6,   134,
    70,  198, 38,  166, 102, 230, 22,  150, 86,  214, 54,  182, 118, 246,
    12,  140, 76,  204, 44,  172, 108, 236, 24,  152, 88,  216, 7,   135,
    71,  199, 39,  167, 103, 231, 23,  151, 87,  215, 55,  183, 119, 247,
    15,  143, 79,  207, 47,  175, 111, 239, 31,  159, 95,  223, 63,  191,
    127, 255, 14,  142, 78,  206, 46,  174, 110, 238, 30,  158, 94,  222,
    62,  190, 126, 254, 28,  156, 92,  220, 60,  188, 124, 252, 56,  184,
    120, 248, 16,  144, 80,  208, 48,  176, 112, 240, 32,  160, 96,  224,
    64,  192, 128};

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

    src1_v = (uint64_t)(*(int32_t *)src1);
    src2_v = (uint64_t)(*(int32_t *)src2);
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

void gen_table_3_3_merging(void)
{
    int32_t t0, t1, j, zetas[64], zetasqinv[64];
    int32_t qinv, invN, q, mont;

    q = Q;
    qinv = QINV;
    invN = INV64;
    mont = MONT;

    memset(zetas, 0, 64 * sizeof(int32_t));
    memset(zetasqinv, 0, 64 * sizeof(int32_t));
    for (j = 0; j < 64 - 1; j++) {
        expmod_int32(&t0, &root, tree_33merging_ntt[j], &q);
        mulmod_int32(&zetas[j], &t0, &mont, &q);
        t0 = zetas[j];
        mul_int32(&zetasqinv[j], &t0, &qinv);
    }
    printf("33merging ntt:\n");
    for (j = 0; j < 64 - 1; j++) {
        printf("%d, ", zetas[j]);
        printf("%d, ", zetasqinv[j]);
    }
    printf("\n\n");

    memset(zetas, 0, 64 * sizeof(int32_t));
    memset(zetasqinv, 0, 64 * sizeof(int32_t));
    for (j = 0; j < 64 - 1; j++) {
        expmod_int32(&t0, &root, 512 - tree_33merging_intt[j], &q);
        if (j == 62) {
            mulmod_int32(&t0, &t0, &mont, &q);
            mulmod_int32(&t0, &t0, &mont, &q);
            mulmod_int32(&zetas[j], &t0, &invN, &q);
            t0 = zetas[j];
            mul_int32(&zetasqinv[j], &t0, &qinv);
        } else {
            mulmod_int32(&zetas[j], &t0, &mont, &q);
            t0 = zetas[j];
            mul_int32(&zetasqinv[j], &t0, &qinv);
        }
    }
    printf("33merging intt:\n");
    for (j = 0; j < 64 - 1; j++) {
        printf("%d, ", zetas[j]);
        printf("%d, ", zetasqinv[j]);
    }
    printf("\n\n");

    memset(zetas, 0, 64 * sizeof(int32_t));
    memset(zetasqinv, 0, 64 * sizeof(int32_t));
    for (j = 0; j < 32; j++) {
        expmod_int32(&t0, &root, tree_6layer_basemul[j], &q);
        mulmod_int32(&zetas[j], &t0, &mont, &q);
        t0 = zetas[j];
        mul_int32(&zetasqinv[j], &t0, &qinv);
    }
    printf("6-layer basemul:\n");
    for (j = 0; j < 32; j++) {
        printf("%d, ", zetas[j]);
        printf("%d, ", zetasqinv[j]);
    }
    printf("\n\n");

    t0 = 167912;
    mul_int32(&t0, &t0, &qinv);
    printf("invN*qinv: %d\n", t0);
}

void gen_table_44merging(void)
{
    int32_t t0, t1, j, zetas[256], zetasqinv[256];
    int32_t qinv, invN, q, mont;

    q = Q;
    qinv = QINV;
    invN = INVN;
    mont = MONT;

    memset(zetas, 0, 256 * sizeof(int32_t));
    memset(zetasqinv, 0, 256 * sizeof(int32_t));
    for (j = 0; j < 256 - 1; j++) {
        expmod_int32(&t0, &root, treeNTT44merging[j], &q);
        mulmod_int32(&zetas[j], &t0, &mont, &q);
        t0 = zetas[j];
        mul_int32(&zetasqinv[j], &t0, &qinv);
    }
    // printf("44merging ntt:\n");
    // for (j = 0; j < 256 - 1; j++) {
    //     printf("%d, ", zetas[j]);
    //     printf("%d, ", zetasqinv[j]);
    // }
    // printf("\n\n");

    printf("44merging ntt for rvv:\n");
    printf("%d, ", zetasqinv[0]);
    printf("%d, \n\n", zetas[0]);
    for (j = 1; j < 256 - 1; j++) {
        if (j == 3 || j == 7 || j == 15 || (j - 19) % 60 == 0 ||
            (j - 27) % 60 == 0 || (j - 43) % 60 == 0 ||
            (j - 75) % 60 == 0) {
            printf("\n\n");
        }
        if (j >= 27 && j <= 42 || j >= 87 && j <= 102 ||
            j >= 147 && j <= 162 || j >= 207 && j <= 222) {
            printf("%d, ", zetasqinv[j]);
            printf("%d, ", zetasqinv[j]);
            printf("%d, ", zetasqinv[j + 1]);
            printf("%d, ", zetasqinv[j + 1]);
            printf("%d, ", zetas[j]);
            printf("%d, ", zetas[j]);
            printf("%d, ", zetas[j + 1]);
            printf("%d, ", zetas[j + 1]);
            j += 2 - 1;
        } else if (j >= 42 + 1 && j <= 42 + 32 ||
                   j >= 102 + 1 && j <= 102 + 32 ||
                   j >= 162 + 1 && j <= 162 + 32 ||
                   j >= 222 + 1 && j <= 222 + 32) {
            printf("%d, ", zetasqinv[j + 0]);
            printf("%d, ", zetasqinv[j + 1]);
            printf("%d, ", zetasqinv[j + 2]);
            printf("%d, ", zetasqinv[j + 3]);
            printf("%d, ", zetas[j + 0]);
            printf("%d, ", zetas[j + 1]);
            printf("%d, ", zetas[j + 2]);
            printf("%d, ", zetas[j + 3]);
            j += 4 - 1;
        } else {
            printf("%d, ", zetasqinv[j]);
            printf("%d, ", zetas[j]);
        }
    }

    memset(zetas, 0, 256 * sizeof(int32_t));
    memset(zetasqinv, 0, 256 * sizeof(int32_t));
    for (j = 0; j < 256 - 1; j++) {
        expmod_int32(&t0, &root, 512 - treeINTT44merging[j], &q);
        if (j == 254) {
            mulmod_int32(&t0, &t0, &mont, &q);
            mulmod_int32(&t0, &t0, &mont, &q);
            mulmod_int32(&zetas[j], &t0, &invN, &q);
            t0 = zetas[j];
            mul_int32(&zetasqinv[j], &t0, &qinv);
        } else {
            mulmod_int32(&zetas[j], &t0, &mont, &q);
            t0 = zetas[j];
            mul_int32(&zetasqinv[j], &t0, &qinv);
        }
    }
    printf("\n\n44merging intt for rvv:\n");
    for (j = 0; j < 256 - 1; j++) {
        if ((j - 32) % 60 == 0 || (j - 48) % 60 == 0 ||
            (j - 56) % 60 == 0 || (j - 60) % 60 == 0 || j == 248 ||
            j == 252 || j == 254) {
            printf("\n\n");
        }
        if (j >= 32 && j <= 47 || j >= 92 && j <= 107 ||
            j >= 152 && j <= 167 || j >= 212 && j <= 227) {
            printf("%d, ", zetasqinv[j]);
            printf("%d, ", zetasqinv[j]);
            printf("%d, ", zetasqinv[j + 1]);
            printf("%d, ", zetasqinv[j + 1]);
            printf("%d, ", zetas[j]);
            printf("%d, ", zetas[j]);
            printf("%d, ", zetas[j + 1]);
            printf("%d, ", zetas[j + 1]);
            j += 2 - 1;
        } else if (j >= 32 - 32 && j <= 32 - 1 ||
                   j >= 92 - 32 && j <= 92 - 1 ||
                   j >= 152 - 32 && j <= 152 - 1 ||
                   j >= 212 - 32 && j <= 212 - 1) {
            printf("%d, ", zetasqinv[j + 0]);
            printf("%d, ", zetasqinv[j + 1]);
            printf("%d, ", zetasqinv[j + 2]);
            printf("%d, ", zetasqinv[j + 3]);
            printf("%d, ", zetas[j + 0]);
            printf("%d, ", zetas[j + 1]);
            printf("%d, ", zetas[j + 2]);
            printf("%d, ", zetas[j + 3]);
            j += 4 - 1;
        } else {
            printf("%d, ", zetasqinv[j]);
            printf("%d, ", zetas[j]);
        }
    }
    printf("\n\n");
}

int main()
{
    // GenTable_c_ref();
    // gen_table_c_6layer();
    // gen_table_3_3_merging();
    gen_table_44merging();
    return 0;
}