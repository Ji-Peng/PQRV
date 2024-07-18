#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "cpucycles.h"
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
    polyvec matrix[KYBER_K], pkpv, skpv;
    poly ap;
    polyvec *a = matrix;

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
        gen_matrix(matrix, seed, 0);
    }
    print_results("gen_a: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_getnoise_eta1(&ap, seed, 0);
    }
    print_results("poly_getnoise_eta1: ", t, NTESTS);

    // for (i = 0; i < NTESTS; i++) {
    //     t[i] = cpucycles();
    //     poly_getnoise_eta2(&ap, seed, 0);
    // }
    // print_results("poly_getnoise_eta2: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_ntt(&ap);
    }
    print_results("NTT: ", t, NTESTS);

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_intt(&ap);
    }
    print_results("INVNTT: ", t, NTESTS);

#if defined(VECTOR128)
    poly_half b_cache;
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_acc(&ap, &matrix[0].vec[0], &matrix[1].vec[0]);
    }
    print_results("poly_basemul_acc: ", t, NTESTS);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_acc_cache_init(&ap, &matrix[0].vec[0],
                                    &matrix[1].vec[0], &b_cache);
    }
    print_results("poly_basemul_acc_cache_init: ", t, NTESTS);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_cached(&ap, &matrix[0].vec[0], &matrix[1].vec[0],
                            &b_cache);
    }
    print_results("poly_basemul_cached: ", t, NTESTS);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_acc_cached(&ap, &matrix[0].vec[0], &matrix[1].vec[0],
                                &b_cache);
    }
    print_results("poly_basemul_acc_cached: ", t, NTESTS);
#elif !defined(REF_IMPL) && (defined(RV32) || defined(RV64))
    poly_double r_double;
    poly_half b_cache;
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_acc_cache_init(&r_double, &matrix[0].vec[0],
                                    &matrix[1].vec[0], &b_cache);
    }
    print_results("poly_basemul_acc_cache_init: ", t, NTESTS);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_acc_cached(&r_double, &matrix[0].vec[0],
                                &matrix[1].vec[0], &b_cache);
    }
    print_results("poly_basemul_acc_cached: ", t, NTESTS);
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul_acc_cache_end(&ap, &matrix[0].vec[0],
                                   &matrix[1].vec[0], &b_cache, &r_double);
    }
    print_results("poly_basemul_acc_cache_end: ", t, NTESTS);
#else
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        poly_basemul(&ap, &matrix[0].vec[0], &matrix[1].vec[0]);
    }
    print_results("poly_basemul: ", t, NTESTS);
#endif

    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        polyvec_basemul_acc(&ap, &matrix[0], &matrix[1]);
    }
    print_results("polyvec_basemul_acc: ", t, NTESTS);

#if defined(VECTOR128) || defined(RV32)
    polyvec_half skpv_cache;
#endif
    // matrix-vector mul
    for (int j = 0; j < NTESTS; j++) {
        t[j] = cpucycles();
#if defined(VECTOR128) || defined(RV32)
        polyvec_basemul_acc_cache_init(&pkpv.vec[0], &a[0], &skpv,
                                       &skpv_cache);
        for (i = 1; i < KYBER_K; i++) {
            polyvec_basemul_acc_cached(&pkpv.vec[i], &a[i], &skpv,
                                       &skpv_cache);
        }
#else
        for (i = 0; i < KYBER_K; i++) {
            polyvec_basemul_acc(&pkpv.vec[i], &a[i], &skpv);
        }
#endif
    }
    print_results("matrix-vector mul: ", t, NTESTS);

#if defined(VECTOR128) || defined(RV32)
    for (i = 0; i < NTESTS; i++) {
        t[i] = cpucycles();
        polyvec_basemul_acc_cached(&ap, &pkpv, &skpv, &skpv_cache);
    }
    print_results("polyvec_basemul_acc_cached: ", t, NTESTS);
#endif

    // for(i=0;i<NTESTS;i++) {
    //   t[i] = cpucycles();
    //   poly_tomsg(ct,&ap);
    // }
    // print_results("poly_tomsg: ", t, NTESTS);

    // for(i=0;i<NTESTS;i++) {
    //   t[i] = cpucycles();
    //   poly_frommsg(&ap,ct);
    // }
    // print_results("poly_frommsg: ", t, NTESTS);

    // for(i=0;i<NTESTS;i++) {
    //   t[i] = cpucycles();
    //   poly_compress(ct,&ap);
    // }
    // print_results("poly_compress: ", t, NTESTS);

    // for(i=0;i<NTESTS;i++) {
    //   t[i] = cpucycles();
    //   poly_decompress(&ap,ct);
    // }
    // print_results("poly_decompress: ", t, NTESTS);

    // for(i=0;i<NTESTS;i++) {
    //   t[i] = cpucycles();
    //   polyvec_compress(ct,&matrix[0]);
    // }
    // print_results("polyvec_compress: ", t, NTESTS);

    // for(i=0;i<NTESTS;i++) {
    //   t[i] = cpucycles();
    //   polyvec_decompress(&matrix[0],ct);
    // }
    // print_results("polyvec_decompress: ", t, NTESTS);

    // for (i = 0; i < NTESTS; i++) {
    //     t[i] = cpucycles();
    //     indcpa_keypair(pk, sk);
    // }
    // print_results("indcpa_keypair: ", t, NTESTS);

    // for (i = 0; i < NTESTS; i++) {
    //     t[i] = cpucycles();
    //     indcpa_enc(ct, key, pk, seed);
    // }
    // print_results("indcpa_enc: ", t, NTESTS);

    // for (i = 0; i < NTESTS; i++) {
    //     t[i] = cpucycles();
    //     indcpa_dec(key, ct, sk);
    // }
    // print_results("indcpa_dec: ", t, NTESTS);

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

    printf("\n");

    return 0;
}
