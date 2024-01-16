#include "fips202x.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#define NROUNDS 24
#define ROL(a, offset) ((a << offset) ^ (a >> (64 - offset)))

#ifdef VECTOR128
IMPL_SHA3_APIS(2)
#endif

#if defined(VECTOR128) && defined(HYBRIDX3)
IMPL_SHA3_APIS(3)
#endif

#if defined(VECTOR128) && defined(HYBRIDX4)
IMPL_SHA3_APIS(4)
#endif

#if defined(VECTOR128) && defined(HYBRIDX5)
IMPL_SHA3_APIS(5)
#endif

#if defined(VECTOR128) && defined(HYBRIDX6)
IMPL_SHA3_APIS(6)
#endif

#if defined(VECTOR128) && defined(HYBRIDX8)
IMPL_SHA3_APIS(8)
#endif
