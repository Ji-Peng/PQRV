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

int32_t tree_332merging_ntt[] = {
    128, 64,  192, 32,  160, 96,  224, 16,  8,   136, 4,   132, 68,  196,
    144, 72,  200, 36,  164, 100, 228, 80,  40,  168, 20,  148, 84,  212,
    208, 104, 232, 52,  180, 116, 244, 48,  24,  152, 12,  140, 76,  204,
    176, 88,  216, 44,  172, 108, 236, 112, 56,  184, 28,  156, 92,  220,
    240, 120, 248, 60,  188, 124, 252, 2,   1,   129, 130, 65,  193, 66,
    33,  161, 194, 97,  225, 34,  17,  145, 162, 81,  209, 98,  49,  177,
    226, 113, 241, 18,  9,   137, 146, 73,  201, 82,  41,  169, 210, 105,
    233, 50,  25,  153, 178, 89,  217, 114, 57,  185, 242, 121, 249, 10,
    5,   133, 138, 69,  197, 74,  37,  165, 202, 101, 229, 42,  21,  149,
    170, 85,  213, 106, 53,  181, 234, 117, 245, 26,  13,  141, 154, 77,
    205, 90,  45,  173, 218, 109, 237, 58,  29,  157, 186, 93,  221, 122,
    61,  189, 250, 125, 253, 6,   3,   131, 134, 67,  195, 70,  35,  163,
    198, 99,  227, 38,  19,  147, 166, 83,  211, 102, 51,  179, 230, 115,
    243, 22,  11,  139, 150, 75,  203, 86,  43,  171, 214, 107, 235, 54,
    27,  155, 182, 91,  219, 118, 59,  187, 246, 123, 251, 14,  7,   135,
    142, 71,  199, 78,  39,  167, 206, 103, 231, 46,  23,  151, 174, 87,
    215, 110, 55,  183, 238, 119, 247, 30,  15,  143, 158, 79,  207, 94,
    47,  175, 222, 111, 239, 62,  31,  159, 190, 95,  223, 126, 63,  191,
    254, 127, 255};

int32_t tree_233merging_intt[] = {
    1,   129, 2,   65,  193, 130, 33,  161, 66,  97,  225, 194, 17,  145,
    34,  81,  209, 162, 49,  177, 98,  113, 241, 226, 9,   137, 18,  73,
    201, 146, 41,  169, 82,  105, 233, 210, 25,  153, 50,  89,  217, 178,
    57,  185, 114, 121, 249, 242, 5,   133, 10,  69,  197, 138, 37,  165,
    74,  101, 229, 202, 21,  149, 42,  85,  213, 170, 53,  181, 106, 117,
    245, 234, 13,  141, 26,  77,  205, 154, 45,  173, 90,  109, 237, 218,
    29,  157, 58,  93,  221, 186, 61,  189, 122, 125, 253, 250, 3,   131,
    6,   67,  195, 134, 35,  163, 70,  99,  227, 198, 19,  147, 38,  83,
    211, 166, 51,  179, 102, 115, 243, 230, 11,  139, 22,  75,  203, 150,
    43,  171, 86,  107, 235, 214, 27,  155, 54,  91,  219, 182, 59,  187,
    118, 123, 251, 246, 7,   135, 14,  71,  199, 142, 39,  167, 78,  103,
    231, 206, 23,  151, 46,  87,  215, 174, 55,  183, 110, 119, 247, 238,
    15,  143, 30,  79,  207, 158, 47,  175, 94,  111, 239, 222, 31,  159,
    62,  95,  223, 190, 63,  191, 126, 127, 255, 254, 4,   132, 68,  196,
    8,   136, 16,  36,  164, 100, 228, 72,  200, 144, 20,  148, 84,  212,
    40,  168, 80,  52,  180, 116, 244, 104, 232, 208, 12,  140, 76,  204,
    24,  152, 48,  44,  172, 108, 236, 88,  216, 176, 28,  156, 92,  220,
    56,  184, 112, 60,  188, 124, 252, 120, 248, 240, 32,  160, 96,  224,
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

void gen_table_332merging(void)
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
        expmod_int32(&t0, &root, tree_332merging_ntt[j], &q);
        mulmod_int32(&zetas[j], &t0, &mont, &q);
        t0 = zetas[j];
        mul_int32(&zetasqinv[j], &t0, &qinv);
    }
    printf("332merging ntt:\n");
    for (j = 0; j < 256 - 1; j++) {
        printf("%d, ", zetas[j]);
        printf("%d, ", zetasqinv[j]);
    }
    printf("\n\n");

    memset(zetas, 0, 256 * sizeof(int32_t));
    memset(zetasqinv, 0, 256 * sizeof(int32_t));
    for (j = 0; j < 256 - 1; j++) {
        expmod_int32(&t0, &root, 512 - tree_233merging_intt[j], &q);
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
    printf("233merging intt:\n");
    for (j = 0; j < 256 - 1; j++) {
        printf("%d, ", zetas[j]);
        printf("%d, ", zetasqinv[j]);
    }
    printf("\n\n");
}

int main()
{
    // GenTable_c_ref();
    // gen_table_c_6layer();
    // gen_table_3_3_merging();
    gen_table_332merging();
    return 0;
}