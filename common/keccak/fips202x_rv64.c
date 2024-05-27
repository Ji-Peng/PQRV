#include "fips202x.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#ifdef VECTOR128
IMPL_SHA3_RV64_APIS(2)
#endif

#if defined(VECTOR128) && defined(HYBRIDX3)
IMPL_SHA3_RV64_APIS(3)
#endif

#if defined(VECTOR128) && defined(HYBRIDX4)
IMPL_SHA3_RV64_APIS(4)
#endif

#if defined(VECTOR128) && defined(HYBRIDX5)
IMPL_SHA3_RV64_APIS(5)
#endif

#if defined(VECTOR128) && defined(HYBRIDX6)
IMPL_SHA3_RV64_APIS(6)
#endif

#if defined(VECTOR128) && defined(HYBRIDX8)
IMPL_SHA3_RV64_APIS(8)
#endif

#if defined(VECTOR128) && defined(HYBRIDX10)
IMPL_SHA3_RV64_APIS(10)
#endif

#if defined(VECTOR128) && defined(HYBRIDX14)
IMPL_SHA3_RV64_APIS(14)
#endif
