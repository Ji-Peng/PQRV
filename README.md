# PQRV64

## Regarding non-standard extended instruction set

The complete instruction set supported by C908 is `-march=rv64imafdcv_zihintpause_zfh_zba_zbb_zbc_zbs_xtheadc -mabi=lp64d`, which includes non-standard custom extensions. We aim to obtain experimental results under the standard RISC-V instruction set, so we only use `-march=rv64imav -mabi=lp64`.

## Why using the `-static` option?



