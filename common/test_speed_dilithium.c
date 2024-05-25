#include <stdint.h>
#include <stdio.h>

#include "cpucycles.h"
#include "params.h"
#include "poly.h"
#include "polyvec.h"
#include "sign.h"
#include "speed_print.h"

#define NTESTS 1000

uint64_t t[NTESTS];

int main(void)
{
    unsigned int i;
    size_t siglen;
    uint8_t pk[CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[CRYPTO_SECRETKEYBYTES];
    uint8_t sig[CRYPTO_BYTES];
    uint8_t seed[CRHBYTES];
    polyvecl mat[K];
    polyveck veck;
    poly *a = &mat[0].vec[0];
    poly *b = &mat[0].vec[1];
    poly *c = &mat[0].vec[2];

    printf("Test speed of " CRYPTO_ALGNAME "\n");

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        polyvec_matrix_expand(mat, seed);
    }
    print_results("polyvec_matrix_expand:", t, NTESTS);

#if defined(VECTOR128)
    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        polyveclk_uniform_eta(&mat[0], &veck, seed, 0, L);
    }
    print_results("polyveclk_uniform_eta:", t, NTESTS);
#else
    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        polyvecl_uniform_eta(&mat[0], seed, 0);
    }
    print_results("polyvecl_uniform_eta:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        polyveck_uniform_eta(&veck, seed, 0);
    }
    print_results("polyveck_uniform_eta:", t, NTESTS);
#endif

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_ntt(a);
    }
    print_results("poly_ntt:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_invntt(a);
    }
    print_results("poly_invntt:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_pointwise_montgomery(c, a, b);
    }
    print_results("poly_pointwise_montgomery:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_challenge(c, seed);
    }
    print_results("poly_challenge:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        crypto_sign_keypair(pk, sk);
    }
    print_results("Keypair:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        crypto_sign_signature(sig, &siglen, sig, CRHBYTES, sk);
    }
    print_results("Sign:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        crypto_sign_verify(sig, CRYPTO_BYTES, sig, CRHBYTES, pk);
    }
    print_results("Verify:", t, NTESTS);

    printf("\n");

    return 0;
}
