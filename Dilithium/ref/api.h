#ifndef API_H
#define API_H

#include <stddef.h>
#include <stdint.h>

#define dilithium2_PUBLICKEYBYTES 1312
#define dilithium2_SECRETKEYBYTES 2528
#define dilithium2_BYTES 2420

#define dilithium2_PUBLICKEYBYTES dilithium2_PUBLICKEYBYTES
#define dilithium2_SECRETKEYBYTES dilithium2_SECRETKEYBYTES
#define dilithium2_BYTES dilithium2_BYTES

int dilithium2_keypair(uint8_t *pk, uint8_t *sk);

int dilithium2_signature(uint8_t *sig, size_t *siglen, const uint8_t *m,
                             size_t mlen, const uint8_t *sk);

int dilithium2_ref(uint8_t *sm, size_t *smlen, const uint8_t *m, size_t mlen,
                   const uint8_t *sk);

int dilithium2_verify(const uint8_t *sig, size_t siglen, const uint8_t *m,
                          size_t mlen, const uint8_t *pk);

int dilithium2_open(uint8_t *m, size_t *mlen, const uint8_t *sm,
                        size_t smlen, const uint8_t *pk);

#define dilithium3_PUBLICKEYBYTES 1952
#define dilithium3_SECRETKEYBYTES 4000
#define dilithium3_BYTES 3293

#define dilithium3_PUBLICKEYBYTES dilithium3_PUBLICKEYBYTES
#define dilithium3_SECRETKEYBYTES dilithium3_SECRETKEYBYTES
#define dilithium3_BYTES dilithium3_BYTES

int dilithium3_keypair(uint8_t *pk, uint8_t *sk);

int dilithium3_signature(uint8_t *sig, size_t *siglen, const uint8_t *m,
                             size_t mlen, const uint8_t *sk);

int dilithium3_ref(uint8_t *sm, size_t *smlen, const uint8_t *m, size_t mlen,
                   const uint8_t *sk);

int dilithium3_verify(const uint8_t *sig, size_t siglen, const uint8_t *m,
                          size_t mlen, const uint8_t *pk);

int dilithium3_open(uint8_t *m, size_t *mlen, const uint8_t *sm,
                        size_t smlen, const uint8_t *pk);

#define dilithium5_PUBLICKEYBYTES 2592
#define dilithium5_SECRETKEYBYTES 4864
#define dilithium5_BYTES 4595

#define dilithium5_PUBLICKEYBYTES dilithium5_PUBLICKEYBYTES
#define dilithium5_SECRETKEYBYTES dilithium5_SECRETKEYBYTES
#define dilithium5_BYTES dilithium5_BYTES

int dilithium5_keypair(uint8_t *pk, uint8_t *sk);

int dilithium5_signature(uint8_t *sig, size_t *siglen, const uint8_t *m,
                             size_t mlen, const uint8_t *sk);

int dilithium5_ref(uint8_t *sm, size_t *smlen, const uint8_t *m, size_t mlen,
                   const uint8_t *sk);

int dilithium5_verify(const uint8_t *sig, size_t siglen, const uint8_t *m,
                          size_t mlen, const uint8_t *pk);

int dilithium5_open(uint8_t *m, size_t *mlen, const uint8_t *sm,
                        size_t smlen, const uint8_t *pk);

#endif
