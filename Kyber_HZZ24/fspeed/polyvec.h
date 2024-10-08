#ifndef POLYVEC_H
#define POLYVEC_H

#include "params.h"
#include "poly.h"

typedef struct {
    poly vec[KYBER_K];
} polyvec;

typedef struct {
    poly_half vec[KYBER_K];
} polyvec_half;

void polyvec_compress(unsigned char *r, polyvec *a);
void polyvec_decompress(polyvec *r, const unsigned char *a);

void polyvec_tobytes(unsigned char *r, polyvec *a);
void polyvec_frombytes(polyvec *r, const unsigned char *a);

void polyvec_ntt(polyvec *r);
void polyvec_invntt(polyvec *r);

void polyvec_reduce(polyvec *r);

void polyvec_add(polyvec *r, const polyvec *a, const polyvec *b);

#endif
