#include "fips202x.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#ifdef VECTOR128
IMPL_SHA3_RV32_APIS(2)
// #    define N 2
// #    ifndef BIT_INTERLEAVING
// extern void FUNC(KeccakF1600_StatePermute_RV32V_, N, x)(uint64_t *state);
// void FUNC(KeccakF1600x, N, _StatePermute)(uint64_t *state)
// {
//     FUNC(KeccakF1600_StatePermute_RV32V_, N, x)(state);
// }
// static void FUNC(keccakx, N, _absorb_once)(uint64_t *s, unsigned int r,
//                                            const uint8_t **in, size_t inlen,
//                                            uint8_t p)
// {
//     unsigned int i, j, k;
//     const uint8_t *in_t[N];
//     uint8_t buf[N][8];

//     memcpy(in_t, in, sizeof(uint8_t *) * N);
//     memset(s, 0, 25 * N * sizeof(uint64_t));
//     memset(buf, 0, N * 8 * sizeof(uint8_t));

//     while (inlen >= r) {
//         for (i = 0; i < r / 8; i++)
//             for (j = 0; j < N; j++)
//                 S(j, i) ^= *(uint64_t *)(in_t[j] + 8 * i);

//         for (j = 0; j < N; j++)
//             in_t[j] += r;
//         inlen -= r;
//         FUNC(KeccakF1600x, N, _StatePermute)(s);
//     }

//     for (i = 0; inlen >= 8; i += 1, inlen -= 8)
//         for (j = 0; j < N; j++) {
//             S(j, i) ^= *(uint64_t *)(in_t[j]);
//             in_t[j] += 8;
//         }
//     for (k = 0; k < inlen; k++)
//         for (j = 0; j < N; j++)
//             buf[j][k] = in_t[j][k];

//     for (j = 0; j < N; j++)
//         buf[j][k] = p;

//     for (j = 0; j < N; j++) {
//         S(j, i) ^= *(uint64_t *)(buf[j]);
//         S(j, ((r - 1) / 8)) ^= (1ULL << 63);
//     }
// }
// static unsigned int FUNC(keccakx, N, _squeeze)(uint8_t **out, size_t outlen,
//                                                uint64_t *s, unsigned int pos,
//                                                unsigned int r)
// {
//     unsigned int i, j;
//     uint8_t *out_t[N];

//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     while (outlen) {
//         if (pos == r) {
//             FUNC(KeccakF1600x, N, _StatePermute)(s);
//             pos = 0;
//         }
//         for (i = pos; i < r && i < pos + outlen; i++) {
//             for (j = 0; j < N; j++)
//                 *out_t[j]++ = S(j, (i / 8)) >> 8 * (i % 8);
//         }
//         outlen -= i - pos;
//         pos = i;
//     }

//     return pos;
// }
// static void FUNC(keccakx, N, _squeezeblocks)(uint8_t **out, size_t nblocks,
//                                              uint64_t *s, unsigned int r)
// {
//     unsigned int i, j;
//     uint8_t *out_t[N];

//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     while (nblocks) {
//         FUNC(KeccakF1600x, N, _StatePermute)(s);
//         for (i = 0; i < r / 8; i++)
//             for (j = 0; j < N; j++)
//                 *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));
//         for (j = 0; j < N; j++)
//             out_t[j] += r;
//         nblocks -= 1;
//     }
// }
// void FUNC(shake128x, N, _squeeze)(uint8_t **out, size_t outlen,
//                                   KECCAK(keccakx, N, _state) * state)
// {
//     state->pos = FUNC(keccakx, N, _squeeze)(out, outlen, (uint64_t
//     *)&state->s,
//                                             state->pos, SHAKE128_RATE);
// }
// void FUNC(shake128x, N, _absorb_once)(KECCAK(keccakx, N, _state) * state,
//                                       const uint8_t **in, size_t inlen)
// {
//     FUNC(keccakx, N, _absorb_once)
//     ((uint64_t *)&state->s, SHAKE128_RATE, in, inlen, 0x1F);
//     state->pos = SHAKE128_RATE;
// }
// void FUNC(shake128x, N, _squeezeblocks)(uint8_t **out, size_t nblocks,
//                                         KECCAK(keccakx, N, _state) * state)
// {
//     FUNC(keccakx, N, _squeezeblocks)
//     (out, nblocks, (uint64_t *)&state->s, SHAKE128_RATE);
// }
// void FUNC(shake256x, N, _squeeze)(uint8_t **out, size_t outlen,
//                                   KECCAK(keccakx, N, _state) * state)
// {
//     state->pos = FUNC(keccakx, N, _squeeze)(out, outlen, (uint64_t
//     *)&state->s,
//                                             state->pos, SHAKE256_RATE);
// }
// void FUNC(shake256x, N, _absorb_once)(KECCAK(keccakx, N, _state) * state,
//                                       const uint8_t **in, size_t inlen)
// {
//     FUNC(keccakx, N, _absorb_once)
//     ((uint64_t *)&state->s, SHAKE256_RATE, in, inlen, 0x1F);
//     state->pos = SHAKE256_RATE;
// }
// void FUNC(shake256x, N, _squeezeblocks)(uint8_t **out, size_t nblocks,
//                                         KECCAK(keccakx, N, _state) * state)
// {
//     FUNC(keccakx, N, _squeezeblocks)
//     (out, nblocks, (uint64_t *)&state->s, SHAKE256_RATE);
// }
// void FUNC(shake128x, N, )(uint8_t **out, size_t outlen, const uint8_t **in,
//                           size_t inlen)
// {
//     unsigned int j;
//     size_t nblocks;
//     KECCAK(keccakx, N, _state) * state;
//     if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {
//         printf("%s: malloc failed\n", STR(FUNC(shake128x, N, )));
//     }
//     uint8_t *out_t[N];

//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     FUNC(shake128x, N, _absorb_once)(state, in, inlen);
//     nblocks = outlen / SHAKE128_RATE;
//     FUNC(shake128x, N, _squeezeblocks)(out_t, nblocks, state);
//     outlen -= nblocks * SHAKE128_RATE;
//     for (j = 0; j < N; j++)
//         out_t[j] += nblocks * SHAKE128_RATE;
//     FUNC(shake128x, N, _squeeze)(out_t, outlen, state);
//     free(state);
// }
// void FUNC(shake256x, N, )(uint8_t **out, size_t outlen, const uint8_t **in,
//                           size_t inlen)
// {
//     unsigned int j;
//     size_t nblocks;
//     KECCAK(keccakx, N, _state) * state;
//     if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {
//         printf("%s: malloc failed\n", STR(FUNC(shake256x, N, )));
//     }
//     uint8_t *out_t[N];

//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     FUNC(shake256x, N, _absorb_once)(state, in, inlen);
//     nblocks = outlen / SHAKE256_RATE;
//     FUNC(shake256x, N, _squeezeblocks)(out_t, nblocks, state);
//     outlen -= nblocks * SHAKE256_RATE;
//     for (j = 0; j < N; j++)
//         out_t[j] += nblocks * SHAKE256_RATE;
//     FUNC(shake256x, N, _squeeze)(out_t, outlen, state);
//     free(state);
// }
// void FUNC(sha3_256x, N, )(uint8_t **out, const uint8_t **in, size_t inlen)
// {
//     unsigned int i, j;
//     KECCAK(keccakx, N, _state) * state;
//     uint64_t *s;
//     uint8_t *out_t[N];

//     if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {
//         printf("%s: malloc failed\n", STR(FUNC(sha3_256x, N, )));
//     }
//     s = (uint64_t *)&(state->s);
//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     FUNC(keccakx, N, _absorb_once)(s, SHA3_256_RATE, in, inlen, 0x06);
//     FUNC(KeccakF1600x, N, _StatePermute)(s);
//     for (i = 0; i < 4; i++)
//         for (j = 0; j < N; j++)
//             *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));
//     free(state);
// }
// void FUNC(sha3_512x, N, )(uint8_t **out, const uint8_t **in, size_t inlen)
// {
//     unsigned int i, j;
//     KECCAK(keccakx, N, _state) * state;
//     uint64_t *s;
//     uint8_t *out_t[N];

//     if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {
//         printf("%s: malloc failed\n", STR(FUNC(sha3_512x, N, )));
//     }
//     s = (uint64_t *)&(state->s);
//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     FUNC(keccakx, N, _absorb_once)(s, SHA3_512_RATE, in, inlen, 0x06);
//     FUNC(KeccakF1600x, N, _StatePermute)(s);
//     for (i = 0; i < 8; i++)
//         for (j = 0; j < N; j++)
//             *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));
//     free(state);
// }
// #    else
// extern void FUNC(KeccakF1600_StatePermute_RV32V_, N, x)(uint64_t *state);
// void FUNC(KeccakF1600x, N, _StatePermute)(uint64_t *state)
// {
//     FUNC(KeccakF1600_StatePermute_RV32V_, N, x)(state);
// }
// static void FUNC(keccakx, N, _absorb_once)(uint64_t *s, unsigned int r,
//                                            const uint8_t **in, size_t inlen,
//                                            uint8_t p)
// {
//     unsigned int i, j, k;
//     const uint8_t *in_t[N];
//     uint8_t buf[N][8];
//     uint32_t t, t0, t1;

//     memcpy(in_t, in, sizeof(uint8_t *) * N);
//     memset(s, 0, 25 * N * sizeof(uint64_t));
//     memset(buf, 0, N * 8 * sizeof(uint8_t));

//     while (inlen >= r) {
//         for (i = 0; i < r / 8; i++)
//             for (j = 0; j < N; j++)
//                 if (j < 2) {
//                     S(j, i) ^= *(uint64_t *)(in_t[j] + 8 * i);
//                 } else {
//                     toBitInterleavingAndXOR64b(*(uint64_t *)(in_t[j] + 8 *
//                     i),
//                                                S(j, i), t, t0, t1);
//                 }
//         for (j = 0; j < N; j++)
//             in_t[j] += r;
//         inlen -= r;
//         FUNC(KeccakF1600x, N, _StatePermute)(s);
//     }

//     for (i = 0; inlen >= 8; i += 1, inlen -= 8)
//         for (j = 0; j < N; j++) {
//             if (j < 2) {
//                 S(j, i) ^= *(uint64_t *)(in_t[j]);
//             } else {
//                 toBitInterleavingAndXOR64b(*(uint64_t *)(in_t[j]), S(j, i),
//                 t,
//                                            t0, t1);
//             }
//             in_t[j] += 8;
//         }
//     for (k = 0; k < inlen; k++)
//         for (j = 0; j < N; j++)
//             buf[j][k] = in_t[j][k];

//     for (j = 0; j < N; j++)
//         buf[j][k] = p;

//     for (j = 0; j < N; j++)
//         if (j < 2) {
//             S(j, i) ^= *(uint64_t *)(buf[j]);
//             S(j, ((r - 1) / 8)) ^= (1ULL << 63);
//         } else {
//             toBitInterleavingAndXOR64b(*(uint64_t *)(buf[j]), S(j, i), t, t0,
//                                        t1);
//             toBitInterleavingAndXOR64b((1ULL << 63), S(j, ((r - 1) / 8)), t,
//             t0,
//                                        t1);
//         }
// }
// static unsigned int FUNC(keccakx, N, _squeeze)(uint8_t **out, size_t outlen,
//                                                uint64_t *s, unsigned int pos,
//                                                unsigned int r)
// {
//     unsigned int i, j;
//     uint8_t *out_t[N];
//     uint32_t t, t0, t1;
//     uint8_t buf[2][8];
//     unsigned int computed_index = -1;

//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     while (outlen) {
//         if (pos == r) {
//             FUNC(KeccakF1600x, N, _StatePermute)(s);
//             pos = 0;
//         }
//         for (i = pos; i < r && i < pos + outlen; i++) {
//             if (computed_index != i / 8) {
//                 for (j = 0; j < 2; j++) {
//                     fromBitInterleaving64b(S(j, (i / 8)), *(uint64_t
//                     *)buf[j],
//                                            t, t0, t1);
//                 }
//                 computed_index = i / 8;
//             }
//             for (j = 0; j < N; j++)
//                 if (j < 2)
//                     *out_t[j]++ = buf[j][i % 8];
//                 else
//                     *out_t[j]++ = S(j, (i / 8)) >> 8 * (i % 8);
//         }
//         outlen -= i - pos;
//         pos = i;
//     }

//     return pos;
// }
// static void FUNC(keccakx, N, _squeezeblocks)(uint8_t **out, size_t nblocks,
//                                              uint64_t *s, unsigned int r)
// {
//     unsigned int i, j;
//     uint8_t *out_t[N];
//     uint32_t t, t0, t1;

//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     while (nblocks) {
//         FUNC(KeccakF1600x, N, _StatePermute)(s);
//         for (i = 0; i < r / 8; i++)
//             for (j = 0; j < N; j++)
//                 if (j < 2) {
//                     fromBitInterleaving64b(
//                         S(j, (i)), *(uint64_t *)(out_t[j] + 8 * i), t, t0,
//                         t1);
//                 } else {
//                     *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));
//                 }
//         for (j = 0; j < N; j++)
//             out_t[j] += r;
//         nblocks -= 1;
//     }
// }
// void FUNC(shake128x, N, _squeeze)(uint8_t **out, size_t outlen,
//                                   KECCAK(keccakx, N, _state) * state)
// {
//     state->pos = FUNC(keccakx, N, _squeeze)(out, outlen, (uint64_t
//     *)&state->s,
//                                             state->pos, SHAKE128_RATE);
// }
// void FUNC(shake128x, N, _absorb_once)(KECCAK(keccakx, N, _state) * state,
//                                       const uint8_t **in, size_t inlen)
// {
//     FUNC(keccakx, N, _absorb_once)
//     ((uint64_t *)&state->s, SHAKE128_RATE, in, inlen, 0x1F);
//     state->pos = SHAKE128_RATE;
// }
// void FUNC(shake128x, N, _squeezeblocks)(uint8_t **out, size_t nblocks,
//                                         KECCAK(keccakx, N, _state) * state)
// {
//     FUNC(keccakx, N, _squeezeblocks)
//     (out, nblocks, (uint64_t *)&state->s, SHAKE128_RATE);
// }
// void FUNC(shake256x, N, _squeeze)(uint8_t **out, size_t outlen,
//                                   KECCAK(keccakx, N, _state) * state)
// {
//     state->pos = FUNC(keccakx, N, _squeeze)(out, outlen, (uint64_t
//     *)&state->s,
//                                             state->pos, SHAKE256_RATE);
// }
// void FUNC(shake256x, N, _absorb_once)(KECCAK(keccakx, N, _state) * state,
//                                       const uint8_t **in, size_t inlen)
// {
//     FUNC(keccakx, N, _absorb_once)
//     ((uint64_t *)&state->s, SHAKE256_RATE, in, inlen, 0x1F);
//     state->pos = SHAKE256_RATE;
// }
// void FUNC(shake256x, N, _squeezeblocks)(uint8_t **out, size_t nblocks,
//                                         KECCAK(keccakx, N, _state) * state)
// {
//     FUNC(keccakx, N, _squeezeblocks)
//     (out, nblocks, (uint64_t *)&state->s, SHAKE256_RATE);
// }
// void FUNC(shake128x, N, )(uint8_t **out, size_t outlen, const uint8_t **in,
//                           size_t inlen)
// {
//     unsigned int j;
//     size_t nblocks;
//     KECCAK(keccakx, N, _state) * state;
//     uint8_t *out_t[N];
//     if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {
//         printf("%s: malloc failed\n", STR(FUNC(shake128x, N, )));
//     }
//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     FUNC(shake128x, N, _absorb_once)(state, in, inlen);
//     nblocks = outlen / SHAKE128_RATE;
//     FUNC(shake128x, N, _squeezeblocks)(out_t, nblocks, state);
//     outlen -= nblocks * SHAKE128_RATE;
//     for (j = 0; j < N; j++)
//         out_t[j] += nblocks * SHAKE128_RATE;
//     FUNC(shake128x, N, _squeeze)(out_t, outlen, state);
//     free(state);
// }
// void FUNC(shake256x, N, )(uint8_t **out, size_t outlen, const uint8_t **in,
//                           size_t inlen)
// {
//     unsigned int j;
//     size_t nblocks;
//     KECCAK(keccakx, N, _state) * state;
//     uint8_t *out_t[N];
//     if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {
//         printf("%s: malloc failed\n", STR(FUNC(shake256x, N, )));
//     }
//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     FUNC(shake256x, N, _absorb_once)(state, in, inlen);
//     nblocks = outlen / SHAKE256_RATE;
//     FUNC(shake256x, N, _squeezeblocks)(out_t, nblocks, state);
//     outlen -= nblocks * SHAKE256_RATE;
//     for (j = 0; j < N; j++)
//         out_t[j] += nblocks * SHAKE256_RATE;
//     FUNC(shake256x, N, _squeeze)(out_t, outlen, state);
//     free(state);
// }
// void FUNC(sha3_256x, N, )(uint8_t **out, const uint8_t **in, size_t inlen)
// {
//     unsigned int i, j;
//     KECCAK(keccakx, N, _state) * state;
//     uint64_t *s;
//     uint8_t *out_t[N];
//     uint32_t t, t0, t1;

//     if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {
//         printf("%s: malloc failed\n", STR(FUNC(sha3_256x, N, )));
//     }
//     s = (uint64_t *)&(state->s);
//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     FUNC(keccakx, N, _absorb_once)(s, SHA3_256_RATE, in, inlen, 0x06);
//     FUNC(KeccakF1600x, N, _StatePermute)(s);
//     for (i = 0; i < 4; i++)
//         for (j = 0; j < N; j++)
//             if (j < 2) {
//                 fromBitInterleaving64b(
//                     S(j, (i)), *(uint64_t *)(out_t[j] + 8 * i), t, t0, t1);
//             } else {
//                 *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));
//             }
//     free(state);
// }
// void FUNC(sha3_512x, N, )(uint8_t **out, const uint8_t **in, size_t inlen)
// {
//     unsigned int i, j;
//     KECCAK(keccakx, N, _state) * state;
//     uint64_t *s;
//     uint8_t *out_t[N];
//     uint32_t t, t0, t1;

//     if ((state = malloc(sizeof(KECCAK(keccakx, N, _state)))) == NULL) {
//         printf("%s: malloc failed\n", STR(FUNC(sha3_512x, N, )));
//     }
//     s = (uint64_t *)&(state->s);
//     memcpy(out_t, out, sizeof(uint8_t *) * N);
//     FUNC(keccakx, N, _absorb_once)(s, SHA3_512_RATE, in, inlen, 0x06);
//     FUNC(KeccakF1600x, N, _StatePermute)(s);
//     for (i = 0; i < 8; i++)
//         for (j = 0; j < N; j++)
//             if (j < 2) {
//                 fromBitInterleaving64b(
//                     S(j, (i)), *(uint64_t *)(out_t[j] + 8 * i), t, t0, t1);
//             } else {
//                 *(uint64_t *)(out_t[j] + 8 * i) = S(j, (i));
//             }
//     free(state);
// }
// #endif

#endif

#if defined(VECTOR128) && defined(HYBRIDX3)
IMPL_SHA3_RV32_APIS(3)
#endif

#if defined(VECTOR128) && defined(HYBRIDX4)
IMPL_SHA3_RV32_APIS(4)
#endif
