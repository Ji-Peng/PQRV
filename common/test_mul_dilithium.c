#include <stdint.h>
#include <stdio.h>

#include "params.h"
#include "poly.h"
#include "randombytes.h"

#define NTESTS 1000

static void poly_naivemul(poly *c, const poly *a, const poly *b)
{
    unsigned int i, j;
    int32_t r[2 * N] = {0};

    for (i = 0; i < N; i++)
        for (j = 0; j < N; j++)
            r[i + j] = (r[i + j] + (int64_t)a->coeffs[i] * b->coeffs[j]) % Q;

    for (i = N; i < 2 * N; i++)
        r[i - N] = (r[i - N] - r[i]) % Q;

    for (i = 0; i < N; i++)
        c->coeffs[i] = r[i];
}

int main(void)
{
    unsigned int i, j;
    uint8_t seed[SEEDBYTES];
    uint16_t nonce = 0;
    poly a, b, c, d;

    randombytes(seed, sizeof(seed));
    for (i = 0; i < NTESTS; ++i) {
        poly_uniform(&a, seed, nonce++);
        poly_uniform(&b, seed, nonce++);

        poly_naivemul(&c, &a, &b);
        poly_ntt(&a);
        poly_ntt(&b);
        poly_pointwise(&d, &a, &b);
        poly_intt(&d);

        for (j = 0; j < N; ++j) {
            if ((d.coeffs[j] - c.coeffs[j]) % Q)
                fprintf(stderr, "ERROR in multiplication: d[%d] = %d != %d\n",
                        j, d.coeffs[j], c.coeffs[j]);
        }
    }

    return 0;
}
