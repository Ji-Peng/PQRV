#include "fips202x.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#ifdef VECTOR128
IMPL_SHA3_RV32_APIS(2)
#endif

#if defined(VECTOR128) && defined(HYBRIDX3)
IMPL_SHA3_RV32_APIS(3)
#endif

#if defined(VECTOR128) && defined(HYBRIDX4)
IMPL_SHA3_RV32_APIS(4)
#endif

#if defined(VECTOR128) && defined(HYBRIDX5)
IMPL_SHA3_RV32_APIS(5)
#endif
