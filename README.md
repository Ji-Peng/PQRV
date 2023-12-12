# PQRV64

## Development board

The development board we use is CanMV-K230, which is based on [Kendryte K230 SoC](https://www.canaan.io/product/k230). This SoC adopts a big.LITTLE heterogeneous design, and we only use the big core in this work. The big core supports the standard RISC-V instruction set of RV64IMAFDCV, where the version of V extension is 1.0. Besides the RISC-V standard instructions, this SoC also supports some custom extensions, but we only use RV64IMAV in this work. The big core has a maximum operating frequency of 1.6GHz, equipped with 32KB L1 instruction/data cache and 256KB L2 cache.

For the tutorial on how to use this development board, we refer readers to [K230 doc](https://github.com/kendryte/k230_docs) and [K230 sdk](https://github.com/kendryte/k230_sdk). We only emphasize some key configurations here. The command we use to make the system image for the development board is `make CONF=k230_evb_only_linux_defconfig`, which runs BuildRoot Linux on the big core, so that it can run executable files that use RVV instructions.

## Regarding non-standard extended instruction set

The complete instruction set supported by C908 is `-march=rv64imafdcv_zihintpause_zfh_zba_zbb_zbc_zbs_xtheadc -mabi=lp64d`, which includes non-standard custom extensions. We aim to obtain experimental results under the standard RISC-V instruction set, so we only use `-march=rv64imav -mabi=lp64`.

## Why using the `-static` option?

The current SDK provided by this development board runs BuildRoot Linux on the big core, which is a simplified Linux system suitable for embedded scenarios. It does not support a complete set of dynamic libraries. Therefore, under the current configuration, only executable files obtained using the `-static` option can run on the development board. In fact, the performance difference between executable files obtained by `dynamic` linking and `static` linking is not significant. For the sake of fairness in comparison, all experiments involved in this work use the `-static` option.

