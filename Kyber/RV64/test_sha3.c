#include <stdio.h>

#include "cpucycles.h"
#include "fips202.h"
#include "speed_print.h"

#if (0)
// for debug
void print_hash(uint8_t out[32]);
void print_stat(uint64_t s[25]);
void test_sha3_256();
void test_keccakf1600();
void print_hash(uint8_t out[32])
{
    for (int i = 0; i < 32; i++) {
        printf("%d ", out[i]);
    }
    printf("\n");
}

void print_stat(uint64_t s[25])
{
    for (int i = 0; i < 25; i++) {
        printf("%lu ", s[i]);
    }
    printf("\n");
}

/**
 * The correct result should be:
 *
 * sha3_256 once: 190 47 181 116 251 237 130 151 42 99 10 169 144 68 179 193 166
 * 122 99 80 249 221 224 191 131 54 106 12 15 130 199 28
 *
 * sha3_256 twice: 144 122 237 223 209 118 6 246 47 97 126 39 59 24 191 232 217
 * 50 214 118 56 95 54 150 36 116 79 85 156 160 53 103
 */
void test_sha3_256()
{
    const uint8_t in[] = "Hello world, I am testing sha3!";
    uint8_t out[32];

    sha3_256(out, in, sizeof(in));
    printf("sha3_256 once: ");
    print_hash(out);

    sha3_256(out, out, 32);
    printf("sha3_256 twice: ");
    print_hash(out);
}

void test_keccakf1600()
{
    uint64_t s[25];
    for (int i = 0; i < 25; i++) {
        s[i] = 1;
    }
    KeccakF1600_StatePermute(s);
    print_stat(s);
}
#endif

#define NTESTS 10000

uint64_t t[NTESTS];

int main(void)
{
    int i;
    keccak_state s;
    const uint8_t buff[16] = {0};
    uint8_t buff_out[4 * SHAKE128_RATE];

    // test_sha3_256();
    // test_keccakf1600();
    // return 0;

    printf("Test speed of SHA-3 related subroutines\n");

    perf_profile(KeccakF1600_StatePermute(s.s), KeccakF1600_StatePermute);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        KeccakF1600_StatePermute(s.s);
    }
    print_results("KeccakF1600_StatePermute: ", t, NTESTS);

    perf_profile(shake128_absorb_once(&s, buff, 16), shake128_absorb_once);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        shake128_absorb_once(&s, buff, 16);
    }
    print_results("shake128_absorb_once: ", t, NTESTS);

    perf_profile(shake128_squeezeblocks(buff_out, 1, &s),
                 shake128_squeezeblocks_1);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        shake128_squeezeblocks(buff_out, 1, &s);
    }
    print_results("shake128_squeezeblocks_1: ", t, NTESTS);

    perf_profile(shake128_squeezeblocks(buff_out, 2, &s),
                 shake128_squeezeblocks_2);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        shake128_squeezeblocks(buff_out, 2, &s);
    }
    print_results("shake128_squeezeblocks_2: ", t, NTESTS);

    perf_profile(shake128_squeezeblocks(buff_out, 3, &s),
                 shake128_squeezeblocks_3);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        shake128_squeezeblocks(buff_out, 3, &s);
    }
    print_results("shake128_squeezeblocks_3: ", t, NTESTS);

    perf_profile(shake128_squeezeblocks(buff_out, 4, &s),
                 shake128_squeezeblocks_4);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        shake128_squeezeblocks(buff_out, 4, &s);
    }
    print_results("shake128_squeezeblocks_4: ", t, NTESTS);

    perf_profile(shake256_absorb_once(&s, buff, 16), shake256_absorb_once);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        shake256_absorb_once(&s, buff, 16);
    }
    print_results("shake256_absorb_once: ", t, NTESTS);

    perf_profile(shake256_squeezeblocks(buff_out, 1, &s),
                 shake256_squeezeblocks_1);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        shake256_squeezeblocks(buff_out, 1, &s);
    }
    print_results("shake256_squeezeblocks_1: ", t, NTESTS);

    perf_profile(shake256_squeezeblocks(buff_out, 2, &s),
                 shake256_squeezeblocks_2);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        shake256_squeezeblocks(buff_out, 2, &s);
    }
    print_results("shake256_squeezeblocks_2: ", t, NTESTS);

    perf_profile(shake256_squeezeblocks(buff_out, 3, &s),
                 shake256_squeezeblocks_3);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        shake256_squeezeblocks(buff_out, 3, &s);
    }
    print_results("shake256_squeezeblocks_3: ", t, NTESTS);

    perf_profile(shake256_squeezeblocks(buff_out, 4, &s),
                 shake256_squeezeblocks_4);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        shake256_squeezeblocks(buff_out, 4, &s);
    }
    print_results("shake256_squeezeblocks_4: ", t, NTESTS);

    perf_profile(sha3_256(buff_out, buff, 16), sha3_256);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        sha3_256(buff_out, buff, 16);
    }
    print_results("sha3_256: ", t, NTESTS);

    perf_profile(sha3_512(buff_out, buff, 16), sha3_512);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        sha3_512(buff_out, buff, 16);
    }
    print_results("sha3_512: ", t, NTESTS);

    return 0;
}