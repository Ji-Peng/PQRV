# PQRV

## Preliminaries

- **Development Board:** CanMV-K230 development board, which includes a C908 core.
- **Cross Compiler:** Xuantie-900 linux-5.10.4 glibc gcc Toolchain V2.8.0 B-20231018.
- **Host Machine:** A Linux-capable machine used for cross-compiling. Note that the Linux running on the C908 is a minimal version and is not suitable for direct development; therefore, cross-compilation is necessary.
- **Router:** A router is used to set up a local area network (LAN), allowing the host machine to transfer files to the development board via `scp` and connect to the development board via `ssh`.
- **Network Topology:** The host machine and the K230 development board are on the same local network. The host machine cross-compiles executable files for the C908 core and transfers them to the development board using the `scp` tool. Then, the host machine connects to the development board via `ssh` to run the executable files and obtain the experimental results.
- **Necessary Modifications:** All Makefiles in this project have hard-coded information such as the IP address of the development board within the local network (`192.168.123.99`), the username on the Linux running on the C908 (`root`), and the directory on the C908 where the executable files are stored (`/sharefs`). These details need to be modified according to your specific setup, especially the IP address of the development board within the local network.

## Development board

We use the CanMV-K230 development board based on the Kendryte K230 SoC. This SoC adopts a big.LITTLE heterogeneous design, and we only use the big core in this work. The big core is based on the [XuanTie C908 processor](https://www.xrvm.com/product/xuantie/C908) from [T-Head Semiconductor](https://www.t-head.cn/?lang=en), with the following information:
- Instruction set: RV{32,64}GCBV, vector extension version is 1.0
- Frequency: 1.6GHz
- Cache: 32KB L1 instruction/data cache, 256KB L2 cache
- Microarchitecture: Dual-core, 9-stage in-order pipeline
- Memory: 512MB
- Operating system: Linux version 5.10.4
- Compiler: riscv64-unknown-linux-gnu-gcc (Xuantie-900 linux-5.10.4 glibc gcc Toolchain V2.8.0 B-20231018) 10.4.0, whose download link is [here](https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1698113812618/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.8.0-20231018.tar.gz). You can find more related resources at [XuanTie community](https://www.xrvm.cn/community/download?id=4224193228112465920).

For the tutorial on how to use this development board, we refer readers to [K230 doc](https://github.com/kendryte/k230_docs/blob/main/README_en.md) and [K230 sdk](https://github.com/kendryte/k230_sdk). We only emphasize some key configurations here. The command we use to make the system image for the development board is `make CONF=k230_evb_only_linux_defconfig`, which generates Linux OS by BuildRoot for the big core, so that we can run RVV instructions on the big core.

## Basic Project Structure

We will use `cpi/Makefile` as an example to explain our basic project structure. In the dependency list of the `all` target, besides the executable files to be compiled, there is also the target `out/scp_speed`, which is implemented as follows:
```makefile
out/scp_speed:	\
	out/cpi_rv32imb out/cpi_rv64imb out/cpi_rvv	\
	out/cpi_rv_vgroup	\
	out/cpi_ntt_rv32imv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@
```
This means it will transfer all the generated executable files to the development board via `scp`. In summary, our `make all` command not only compiles the executable files but also uses `scp` to transfer all executables to the development board.

Additionally, our `cpi/Makefile` defines the target `run_all`, as shown below:
```makefile
run_all: run_rv32imb run_rv64imb run_rvv run_rv_vgroup run_ntt_rv32imv
```

Taking the `run_rv32imb` target as an example:
```makefile
run_rv32imb: out/scp_speed
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./cpi_rv32imb" > cpi_rv32imb.txt
```
This means that the host computer connects to the development board via `ssh`, runs the corresponding executable, and redirects the output to a `txt` file on the host computer.

Therefore, the basic steps to reproduce our experimental data are to navigate to the appropriate directory and then run the `make run_all` command. You can also use `make all -j; make run_all`, where `make all -j` leverages multithreading to speed up the compilation.

## Reproduction of Experimental Data

### Microbenchmarks for the C908 Core

Table 1 in our paper presents the latency and CPI (Cycles Per Instruction) for various instructions of the C908 core. Some of these results are directly obtained from the C908 user manual. Additionally, we performed a series of microbenchmarks, which can be found in the `cpi/` directory. The source code files are identified by the `.S` and `.c` extensions, and the test results are in files with the `.txt` extension.

The commands you need to run are as follows:
```bash
cd cpi
make all -j
make run_all
```
The experimental results are output to the `txt` files in the `cpi/` directory.

For a detailed explanation of the principles and results of the microbenchmarks, please refer to `cpi/README.md`.

### Keccak

Table 2 in our paper presents the experimental results for various Keccak-f1600 implementations. The data for the ARM Cortex-A55 and ARM Cortex-M4 platforms are directly taken from the corresponding papers, while the remaining data were obtained by running the following commands:

```bash
cd sha3
make all -j
make run_all
```
The experimental results are output to the `txt` files in the `sha3/` directory.

The data in `results_ko_rv32im.txt` are from testing Ko Stoffelen's implementation on our platform with the RV32IM ISA. The data in `results_riscvcrypto_rv64imb.txt` are from testing the [RISCV-Crypto](https://github.com/riscv/riscv-crypto/blob/main/benchmarks/sha3/zscrypto_rv64/Keccak.c) implementation on our platform with the RV64IMB ISA. Files with the `_ref.txt` suffix contain test results of reference implementations on the corresponding ISAs. The remaining `.txt` files contain the test results of the optimized implementations from our work.

### NTT

Table 3 in our paper reports the experimental results of various NTT implementations. The data for the ARM Cortex-A72 and ARM Cortex-M4 platforms are directly taken from the corresponding papers, while the remaining data were obtained by running the following commands:

```bash
cd ntt
make all -j
make run_all
```
The experimental results are output to the `ntt/speed_ntt.txt` file, which contains more comprehensive data than Table 3 in the paper.

The relationship between the entries in Table 3 and the experimental results in the `ntt/speed_ntt.txt` file is as follows:

| Table 3                        | speed_ntt.txt                             |
|--------------------------------|-------------------------------------------|
| Kyber [HZZ+24] on RV32IM       | speed_singleissue_kyber_plantard_ntt_rv32 |
| Kyber Our on RV32IM            | speed_dualissue_kyber_plantard_ntt_rv32   |
| Kyber Our on RV64IM            | speed_dualissue_kyber_plantard_ntt_rv64   |
| Kyber Our on RVV               | speed_dualissue_kyber_mont_ntt_rvv        |
| Dilithium Our on RV32IM        | speed_dualissue_dilithium_mont_ntt_rv32   |
| Dilithium Our on RV64IM        | speed_dualissue_dilithium_plant_ntt_rv64  |
| Dilithium Our on RVV           | speed_dualissue_dilithium_mont_ntt_rvv    |


### Kyber and Dilithium

Table 4 in our paper presents the performance comparison of various Kyber and Dilithium implementations. The data for the ARM Cortex-A72 and ARM Cortex-M4 platforms are directly taken from the corresponding papers.

To reproduce the experimental data for Kyber and Dilithium, navigate to the corresponding directory and run the following commands:
```bash
make all -j; make speed -j
make run_diff_vectors
make run_speed
```
The executable files generated by the `all` target are primarily used to verify the correctness of the Kyber or Dilithium implementations and to generate test vectors. The executable files generated by the `speed` target are used for performance testing.

The `make run_diff_vectors` command generates test vectors and compares them with those generated by the reference implementation to verify the correctness of our implementation. The `make run_speed` command performs performance testing on Kyber or Dilithium, with the results output to the corresponding `txt` files.

If you only want to perform performance testing, simply run the following commands:
```bash
make speed -j
make run_speed
```

#### Kyber

To reproduce the [HZZ+24] on RV32IM results, run the following commands:
```bash
cd Kyber_HZZ24/fspeed
make speed -j
make run_speed
```

For the performance of the Kyber reference implementation on various ISAs, run the following commands:
```bash
cd Kyber/ref
make speed -j
make run_speed
```
The experimental results will be output to the `txt` files in the `Kyber/ref` directory.

For the performance of our optimized implementation on RV32, run the following commands:
```bash
cd Kyber/RV32
make speed -j
make run_speed
```
The experimental results will be output to the `txt` files in the `Kyber/RV32` directory.

For the performance of our optimized implementation on RV64, run the following commands:
```bash
cd Kyber/RV64
make speed -j
make run_speed
```
The experimental results will be output to the `txt` files in the `Kyber/RV64` directory.

#### Dilithium

For the performance of the Dilithium reference implementation on various ISAs, run the following commands:
```bash
cd Dilithium/ref
make speed -j
make run_speed
```
The experimental results will be output to the `txt` files in the `Dilithium/ref` directory.

For the performance of our optimized implementation on RV32, run the following commands:
```bash
cd Dilithium/RV32
make speed -j
make run_speed
```
The experimental results will be output to the `txt` files in the `Dilithium/RV32` directory.

For the performance of our optimized implementation on RV64, run the following commands:
```bash
cd Dilithium/RV64
make speed -j
make run_speed
```
The experimental results will be output to the `txt` files in the `Dilithium/RV64` directory.

## Why using the `-static` option?

The current SDK provided by this development board runs Linux (generated by BuildRoot) on the big core, which is a simplified Linux system suitable for embedded scenarios. It does not support a complete set of dynamic libraries. Therefore, under the current configuration, only executable files obtained using the `-static` option can run on the development board. For the sake of fairness in comparison, all experiments involved in this work use the `-static` option.

