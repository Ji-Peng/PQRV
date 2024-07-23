#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "cpucycles.h"
#include "implvariant.h"
#include "indcpa.h"
#include "kem.h"
#include "params.h"
#include "poly.h"
#include "polyvec.h"
#include "speed_print.h"

#define NTESTS 10000

uint64_t t[NTESTS];
uint8_t seed[KYBER_SYMBYTES] = {0};

int main()
{
    unsigned int i;
    uint8_t pk[CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[CRYPTO_SECRETKEYBYTES];
    uint8_t ct[CRYPTO_CIPHERTEXTBYTES];
    uint8_t key[CRYPTO_BYTES];
    poly a, b;

#if (KYBER_K == 2)
    printf("Test speed of Kyber512\n");
#elif (KYBER_K == 3)
    printf("Test speed of Kyber768\n");
#elif (KYBER_K == 4)
    printf("Test speed of Kyber1024\n");
#else
#    error "KYBER_K must be in {2,3,4}"
#endif

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_ntt(&a);
    }
    print_results("NTT: ", t, NTESTS);

#ifdef optstack
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul(&b, &a, &a);
    }
    print_results("basemul: ", t, NTESTS);
#elif defined(optspeed)
    int32_t r_tmp[KYBER_N];
    poly_half a_prime;
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_opt_16_32(r_tmp, &a, &b, &a_prime);
    }
    print_results("poly_basemul_opt_16_32: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_acc_opt_32_32(r_tmp, &a, &b, &a_prime);
    }
    print_results("poly_basemul_acc_opt_32_32: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_acc_opt_32_16(&a, &a, &b, &a_prime, r_tmp);
    }
    print_results("poly_basemul_acc_opt_32_16: ", t, NTESTS);
#endif

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_invntt(&a);
    }
    print_results("poly_invntt: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        crypto_kem_keypair(pk, sk);
    }
    print_results("kyber_keypair: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        crypto_kem_enc(ct, key, pk);
    }
    print_results("kyber_encaps: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        crypto_kem_dec(key, ct, sk);
    }
    print_results("kyber_decaps: ", t, NTESTS);

    return 0;
}
