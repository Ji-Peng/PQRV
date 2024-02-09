#ifndef API_H
#define API_H

#include <stdint.h>

#define kyber512_SECRETKEYBYTES 1632
#define kyber512_PUBLICKEYBYTES 800
#define kyber512_CIPHERTEXTBYTES 768
#define kyber512_BYTES 32

#define kyber512_SECRETKEYBYTES kyber512_SECRETKEYBYTES
#define kyber512_PUBLICKEYBYTES kyber512_PUBLICKEYBYTES
#define kyber512_CIPHERTEXTBYTES kyber512_CIPHERTEXTBYTES
#define kyber512_BYTES kyber512_BYTES

int kyber512_keypair(uint8_t *pk, uint8_t *sk);
int kyber512_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk);
int kyber512_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#define kyber768_SECRETKEYBYTES 2400
#define kyber768_PUBLICKEYBYTES 1184
#define kyber768_CIPHERTEXTBYTES 1088
#define kyber768_BYTES 32

#define kyber768_SECRETKEYBYTES kyber768_SECRETKEYBYTES
#define kyber768_PUBLICKEYBYTES kyber768_PUBLICKEYBYTES
#define kyber768_CIPHERTEXTBYTES kyber768_CIPHERTEXTBYTES
#define kyber768_BYTES kyber768_BYTES

int kyber768_keypair(uint8_t *pk, uint8_t *sk);
int kyber768_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk);
int kyber768_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#define kyber1024_SECRETKEYBYTES 3168
#define kyber1024_PUBLICKEYBYTES 1568
#define kyber1024_CIPHERTEXTBYTES 1568
#define kyber1024_BYTES 32

#define kyber1024_SECRETKEYBYTES kyber1024_SECRETKEYBYTES
#define kyber1024_PUBLICKEYBYTES kyber1024_PUBLICKEYBYTES
#define kyber1024_CIPHERTEXTBYTES kyber1024_CIPHERTEXTBYTES
#define kyber1024_BYTES kyber1024_BYTES

int kyber1024_keypair(uint8_t *pk, uint8_t *sk);
int kyber1024_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk);
int kyber1024_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
