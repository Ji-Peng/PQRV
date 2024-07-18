#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "cpucycles.h"
#include "params.h"
#include "poly.h"
#include "polyvec.h"
#include "sign.h"
#include "speed_print.h"

#define NTESTS 10000

uint64_t t[NTESTS * 10];

int main(void)
{
    unsigned int i;
    size_t siglen;
    uint8_t pk[CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[CRYPTO_SECRETKEYBYTES];
    uint8_t sig[CRYPTO_BYTES];
    uint8_t message[CRYPTO_BYTES];
    uint8_t seed[CRHBYTES];
    polyvecl mat[K];
    polyveck veck;
    polyvecl vecl;
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
        poly_intt(a);
    }
    print_results("poly_intt:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        poly_pointwise(c, a, b);
    }
    print_results("poly_pointwise:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        polyveck_pointwise_poly(&veck, a, &veck);
    }
    print_results("polyveck_pointwise_poly:", t, NTESTS);

    // for (i = 0; i < NTESTS; ++i) {
    //     t[i] = cpucycles();
    //     polyvecl_pointwise_poly(&mat[0], a, &mat[0]);
    // }
    // print_results("polyvecl_pointwise_poly:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        polyvec_matrix_pointwise(&veck, mat, &vecl);
    }
    print_results("polyvec_matrix_pointwise:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        polyveck_reduce(&veck);
    }
    print_results("polyveck_reduce:", t, NTESTS);

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

    for (i = 0; i < NTESTS * 10; ++i) {
        t[i] = cpucycles();
        crypto_sign_signature(sig, &siglen, sig, CRHBYTES, sk);
    }
    print_results_average("Sign with rand:", t, NTESTS * 10);

    memset(message, 0xff, CRHBYTES);
    // Find a key pair such that the 'goto rej' statement within the Sign
    // function does not execute
    do {
        crypto_sign_keypair(pk, sk);
        i = crypto_sign_signature(sig, &siglen, message, CRHBYTES, sk);
    } while (i != 0);
    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        crypto_sign_signature(sig, &siglen, message, CRHBYTES, sk);
    }
    print_results("Sign without rej:", t, NTESTS);

    // Find a key pair such that the 'goto rej' statement within the Sign
    // function executes exactly once
    do {
        crypto_sign_keypair(pk, sk);
        i = crypto_sign_signature(sig, &siglen, message, CRHBYTES, sk);
    } while (i != 1);
    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        crypto_sign_signature(sig, &siglen, message, CRHBYTES, sk);
    }
    print_results("Sign with 1 rej:", t, NTESTS);

    // Find a key pair such that the 'goto rej' statement within the Sign
    // function executes exactly twice
    do {
        crypto_sign_keypair(pk, sk);
        i = crypto_sign_signature(sig, &siglen, message, CRHBYTES, sk);
    } while (i != 2);
    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        crypto_sign_signature(sig, &siglen, message, CRHBYTES, sk);
    }
    print_results("Sign with 2 rej:", t, NTESTS);

    do {
        crypto_sign_keypair(pk, sk);
        i = crypto_sign_signature(sig, &siglen, message, CRHBYTES, sk);
    } while (i != 3);
    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        crypto_sign_signature(sig, &siglen, message, CRHBYTES, sk);
    }
    print_results("Sign with 3 rej:", t, NTESTS);

    do {
        crypto_sign_keypair(pk, sk);
        i = crypto_sign_signature(sig, &siglen, message, CRHBYTES, sk);
    } while (i != 4);
    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        crypto_sign_signature(sig, &siglen, message, CRHBYTES, sk);
    }
    print_results("Sign with 4 rej:", t, NTESTS);

    for (i = 0; i < NTESTS; ++i) {
        t[i] = cpucycles();
        crypto_sign_verify(sig, CRYPTO_BYTES, sig, CRHBYTES, pk);
    }
    print_results("Verify:", t, NTESTS);

    printf("\n");

    return 0;
}
