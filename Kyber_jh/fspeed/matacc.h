#ifndef MATACC_H
#define MATACC_H
#include "poly.h"
#include "polyvec.h"
#include "symmetric.h"

void matacc_opt32(poly *r, int32_t *r_tmp, polyvec *b, polyvec_half *b_prime,
                  unsigned char i, const unsigned char *seed, int transposed);
void matacc_cache32(poly *r, int32_t *r_tmp, polyvec *b, polyvec_half *b_prime,
                    unsigned char i, const unsigned char *seed, int transposed);
#endif  // MATACC_H