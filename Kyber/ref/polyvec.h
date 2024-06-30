#ifndef POLYVEC_H
#define POLYVEC_H

#include <stdint.h>
#include "params.h"
#include "poly.h"

typedef struct{
  poly vec[KYBER_K];
} polyvec;

void polyvec_compress(uint8_t r[KYBER_POLYVECCOMPRESSEDBYTES], const polyvec *a);
void polyvec_decompress(polyvec *r, const uint8_t a[KYBER_POLYVECCOMPRESSEDBYTES]);
void polyvec_tobytes(uint8_t r[KYBER_POLYVECBYTES], const polyvec *a);
void polyvec_frombytes(polyvec *r, const uint8_t a[KYBER_POLYVECBYTES]);
void polyvec_ntt(polyvec *r);
void polyvec_intt(polyvec *r);
void polyvec_basemul_acc(poly *r, const polyvec *a, const polyvec *b);
void polyvec_reduce(polyvec *r);
void polyvec_add(polyvec *r, const polyvec *a, const polyvec *b);

#endif
