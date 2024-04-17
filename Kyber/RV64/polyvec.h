#ifndef POLYVEC_H
#define POLYVEC_H

#include <stdint.h>

#include "params.h"
#include "poly.h"

typedef struct {
    poly vec[KYBER_K];
} polyvec;

void polyvec_gen_eta1_skpv_e(polyvec *skpv, polyvec *e,
                             const uint8_t *noiseseed);
void polyvec_gen_eta1_sp_eta2_ep_epp(polyvec *sp, polyvec *ep, poly *epp,
                                     const uint8_t coins[KYBER_SYMBYTES]);

void polyvec_compress(uint8_t r[KYBER_POLYVECCOMPRESSEDBYTES],
                      const polyvec *a);
void polyvec_decompress(polyvec *r,
                        const uint8_t a[KYBER_POLYVECCOMPRESSEDBYTES]);
void polyvec_tobytes(uint8_t r[KYBER_POLYVECBYTES], const polyvec *a);
void polyvec_frombytes(polyvec *r, const uint8_t a[KYBER_POLYVECBYTES]);
void polyvec_ntt(polyvec *r);
void polyvec_invntt_tomont(polyvec *r);
void polyvec_basemul_acc_montgomery(poly *r, const polyvec *a,
                                    const polyvec *b);
void polyvec_basemul_acc_montgomery_cache_init(poly *r, const polyvec *a,
                                               const polyvec *b,
                                               int16_t *b_buf);
void polyvec_basemul_acc_montgomery_cached(poly *r, const polyvec *a,
                                           const polyvec *b, int16_t *b_buf);
void polyvec_reduce(polyvec *r);
void polyvec_add(polyvec *r, const polyvec *a, const polyvec *b);

#endif
