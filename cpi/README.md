# CPI

The `.S` and `.c` files are the necessary source files, while the `.txt` files contain the results of the microbenchmarks. We mainly focus on the results in the following files:
- `cpi_rv32imb.txt, cpi_rv64imb.txt`: Microbenchmark results for specific instructions in the RV32IMB/RV64IMB ISA
- `cpi_rvv.txt`: Microbenchmark results for specific instructions in the V extension
- The other files contain some microbenchmarks of code snippets, aimed at helping us understand how to write more efficient code. For example, `cpi_ntt_rv32imv.txt` includes microbenchmarks for NTT code snippets, while `cpi_rv_vgroup.txt` explores the grouping characteristics of the V extension.

## Basic Methodology

We primarily focus on the latency and CPI of instructions. For example, to test the latency of the `addi` instruction, we use the following code snippet:
```assembly
.globl cpi_addi_x1
.align 2
cpi_addi_x1:
.rep 1000
    addi a0, a0, 1
.endr
ret
```
In this code, each instruction depends on the result of the previous one, so the dual-issue capability cannot be fully utilized. The next instruction must wait for the result of the previous one, allowing us to measure the instruction's latency. The test results show that the CPI of this instruction sequence is 1, indicating a latency of 1 for the `addi` instruction.

To test the CPI of `addi`, we use the following code snippet:
```assembly
.globl cpi_addi
.align 2
cpi_addi:
.rep 100
    addi a0, a0, 1
    addi a1, a1, 1
    addi a2, a2, 1
    addi a3, a3, 1
    addi a4, a4, 1
    addi a5, a5, 1
    ...
.endr
ret
```
Here, there are no data dependencies between the instructions, allowing the dual-issue capability to be fully utilized. The test results show that the CPI of this instruction sequence is 0.5, indicating a CPI of 0.5 for the `addi` instruction.

## RV32I and RV64I

### Arithmetic/Logic Instructions

The testing methodology for these instructions is similar to that of the `addi` instruction mentioned above. The results show that the latency and CPI are 1 and 0.5, respectively.

### Load Instructions (lh/lw/ld)

Testing the latency of `lh/lw/ld` instructions requires careful design. Consider the following code snippet:
```assembly
.globl cpi_lw_addi
.align 2
cpi_lw_addi:
.rep 200
    lw a1, 8*0(a0)
    lw a2, 8*1(a0)
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
.endr
ret
```
The test results are: `cycles/insts/CPI=1207/2005/0.60`. This means that these 10 instructions take 6 cycles, and the 8 `addi` instructions take 4 cycles. Under dual-issue conditions, the `lw` instruction seems to take 2 cycles. However, considering the forwarding feature, the latency is reduced by 1 cycle, so the actual latency of the `lw` instruction is 3.

For the `lh` instruction, the `cpi_lh_addi` test results are `cycles/insts/CPI=1407/2005/0.70`, indicating a latency of 3 with no benefit from the forwarding feature.

These test results corroborate our paper's claim: "The load-use latency from the data of an `lh/{lw,ld}` instruction to the ALU of a dependent datapath instruction is three/two cycles. This means that in a back-to-back `lh/{lw,ld}-add` sequence the add instruction would stall for two/one cycle. We attribute the additional latency of the `lh` instruction to zero or sign extension."

### Store Instructions (sh/sw/sd)

The latency of these instructions is directly obtained from the C908 user manual and is 1 cycle. The CPI for these instructions is tested by the `cpi_sh`, `cpi_sw`, and `cpi_sd` functions, showing that their CPI is 1.

### Multiply Instructions (mul/mulw/mulh)

To test the latency of `mulw` on RV64M, we use the following code snippet:
```assembly
.globl cpi_mulw_x1
.align 2
cpi_mulw_x1:
.rep 1600
    mulw a0, a0, a0
.endr
ret
```
Each instruction depends on the previous one, so the test result reflects the instruction's latency. The result is `cycles/insts/CPI=4802/1603/3.00`, indicating a latency of 3 for this instruction. Similarly, the latency of `mul` and `mulh` on RV32M is also 3 cycles, while the latency on RV64M is 4 cycles.

The CPI for these instructions is measured by the `cpi_mulw`, `cpi_mul`, and `cpi_mulh` functions. The CPI for `mulw` on RV64, and `mul` and `mulh` on RV32, is 1, while the CPI for `mul` and `mulh` on RV64 is 2.

### rori/andn

For the `rori` instruction, `cpi_rori_x1` is used to measure latency, and `cpi_rori` is used to measure CPI. The latency is 1, and the CPI is 0.5.

### RVV Instructions

For the `vadd` and `vsub` instructions, `cpi_vaddvx_x1` and `cpi_vaddvx` are used to measure latency and CPI, respectively, which are 4 and 1.

For the `vmul` and `vmulh` instructions, `cpi_vmulvx_x1` and `cpi_vmulvx` are used to measure latency and CPI. When SEW is less than or equal to 16, they are 4 and 1, respectively; otherwise, they are 5 and 1. The different latencies for multiplication instructions with different SEW configurations are inspired by the C910 user manual.

For logical instructions, we tested `vand.vv`, `vnot.v`, `vxor.vv`, `vsll.vi`, and `vsrlvx` instructions. The latency and CPI are 4 and 2, respectively. The `vmerge` instruction is similar to logical instructions, with latency and CPI of 4 and 2, respectively.

For the `vrgather` instruction, `cpi_vrgathervv_x1` and `cpi_vrgathervv` are used to measure latency and CPI, which are 5 and 4, respectively.

The CPI for `vle` instructions is measured by `cpi_vle16`, with CPI of 2.

The instruction sequence used to test the latency of `vle` is as follows:
```assembly
.globl cpi_vle16_add
.align 2
cpi_vle16_add:
.rep 200
    vle16.v v0, (a0)
    vadd.vv v10, v0, v0
    vadd.vv v11, v0, v0
    vadd.vv v12, v0, v0
    vadd.vv v13, v0, v0
.endr
ret
```
The test result is `cycles/insts/CPI=1208/1005/1.20`, indicating that the five instructions take 6 cycles, with the four `vadd.vv` instructions taking 4 cycles. Therefore, the latency of `vle16.v` is 2 cycles.

When using `cpi_vse16` to test the CPI of the `vse` instruction, the result is `cycles/insts/CPI=1875/808/2.32`. We hypothesize that the higher CPI is due to the characteristics of the write combination.
