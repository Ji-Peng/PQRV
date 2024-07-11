.data
.align 2
constants_keccak:
.quad 0x0000000000000001
.quad 0x0000000000008082
.quad 0x800000000000808a
.quad 0x8000000080008000
.quad 0x000000000000808b
.quad 0x0000000080000001
.quad 0x8000000080008081
.quad 0x8000000000008009
.quad 0x000000000000008a
.quad 0x0000000000000088
.quad 0x0000000080008009
.quad 0x000000008000000a
.quad 0x000000008000808b
.quad 0x800000000000008b
.quad 0x8000000000008089
.quad 0x8000000000008003
.quad 0x8000000000008002
.quad 0x8000000000000080
.quad 0x000000000000800a
.quad 0x800000008000000a
.quad 0x8000000080008081
.quad 0x8000000000008080
.quad 0x0000000080000001
.quad 0x8000000080008008

.text

.macro LoadStates
    # lane complement: 1,2,8,12,17,20
    vl8re64.v v0, (a0)
    addi a0, a0, 8*16
    vl8re64.v v8, (a0)
    addi a0, a0, 8*16
    vnot.v v1, v1
    vnot.v v2, v2
    vnot.v v8, v8
    vnot.v v12, v12
    vl8re64.v v16, (a0)
    addi a0, a0, 8*16
    vnot.v v17, v17
    vnot.v v20, v20
    vle64.v v24, (a0)
    addi a0, a0, -24*16
.endm

.macro StoreStates
    # lane complement: 1,2,8,12,17,20
    vnot.v v1, v1
    vnot.v v2, v2
    vnot.v v8, v8
    vnot.v v12, v12
    vnot.v v17, v17
    vnot.v v20, v20
    vs8r.v v0, (a0)
    addi a0, a0, 8*16
    vs8r.v v8, (a0)
    addi a0, a0, 8*16
    vs8r.v v16, (a0)
    addi a0, a0, 8*16
    vse64.v v24, (a0)
.endm

.macro XOR5 out_0_v, S0_00_v, S0_01_v, S0_02_v, S0_03_v, S0_04_v
    vxor.vv \out_0_v, \S0_00_v, \S0_01_v
    vxor.vv \out_0_v, \out_0_v, \S0_02_v
    vxor.vv \out_0_v, \out_0_v, \S0_03_v
    vxor.vv \out_0_v, \out_0_v, \S0_04_v
.endm

.macro XOR5_x2 \
    out_0_v, S0_00_v, S0_01_v, S0_02_v, S0_03_v, S0_04_v, \
    out_1_v, S1_00_v, S1_01_v, S1_02_v, S1_03_v, S1_04_v
    vxor.vv \out_0_v, \S0_00_v, \S0_01_v
    vxor.vv \out_1_v, \S1_00_v, \S1_01_v
    vxor.vv \out_0_v, \out_0_v, \S0_02_v
    vxor.vv \out_1_v, \out_1_v, \S1_02_v
    vxor.vv \out_0_v, \out_0_v, \S0_03_v
    vxor.vv \out_1_v, \out_1_v, \S1_03_v
    vxor.vv \out_0_v, \out_0_v, \S0_04_v
    vxor.vv \out_1_v, \out_1_v, \S1_04_v
.endm

.macro XOR5_x3 \
    out_0_v, S0_00_v, S0_01_v, S0_02_v, S0_03_v, S0_04_v, \
    out_1_v, S1_00_v, S1_01_v, S1_02_v, S1_03_v, S1_04_v, \
    out_2_v, S2_00_v, S2_01_v, S2_02_v, S2_03_v, S2_04_v
    vxor.vv \out_0_v, \S0_00_v, \S0_01_v
    vxor.vv \out_1_v, \S1_00_v, \S1_01_v
    vxor.vv \out_2_v, \S2_00_v, \S2_01_v
    vxor.vv \out_0_v, \out_0_v, \S0_02_v
    vxor.vv \out_1_v, \out_1_v, \S1_02_v
    vxor.vv \out_2_v, \out_2_v, \S2_02_v
    vxor.vv \out_0_v, \out_0_v, \S0_03_v
    vxor.vv \out_1_v, \out_1_v, \S1_03_v
    vxor.vv \out_2_v, \out_2_v, \S2_03_v
    vxor.vv \out_0_v, \out_0_v, \S0_04_v
    vxor.vv \out_1_v, \out_1_v, \S1_04_v
    vxor.vv \out_2_v, \out_2_v, \S2_04_v
.endm

.macro ROLn_li out_0_v, in_0_v, tmp_0_v, n, tmp_0_s
.if \n < 32
    li \tmp_0_s, 64-\n
    vsll.vi \tmp_0_v, \in_0_v, \n
    vsrl.vx \out_0_v, \in_0_v, \tmp_0_s
    vxor.vv \out_0_v, \out_0_v, \tmp_0_v
.else
    li \tmp_0_s, \n
    vsll.vx \tmp_0_v, \in_0_v, \tmp_0_s
    vsrl.vi \out_0_v, \in_0_v, 64-\n
    vxor.vv \out_0_v, \out_0_v, \tmp_0_v
.endif
.endm

# tmp_0_s is ready for using; if n<32: tmp_0_s=64-n; else: tmp_0_s=n
.macro ROLn out_0_v, in_0_v, tmp_0_v, n, tmp_0_s
.if \n < 32
    vsll.vi \tmp_0_v, \in_0_v, \n
    vsrl.vx \out_0_v, \in_0_v, \tmp_0_s
    vxor.vv \out_0_v, \out_0_v, \tmp_0_v
.else
    vsll.vx \tmp_0_v, \in_0_v, \tmp_0_s
    vsrl.vi \out_0_v, \in_0_v, 64-\n
    vxor.vv \out_0_v, \out_0_v, \tmp_0_v
.endif
.endm

# out = in0 ^ ROL(in1, 1); tmp_0_s=64-1 is ready for using
.macro ROL1_XOR out_0_v, in_0_0_v, in_0_1_v, tmp_0_v, tmp_0_s
    vsll.vi \tmp_0_v, \in_0_1_v, 1
    vsrl.vx \out_0_v, \in_0_1_v, \tmp_0_s
    vxor.vv \out_0_v, \out_0_v, \tmp_0_v
    vxor.vv \out_0_v, \out_0_v, \in_0_0_v
.endm

.macro ROL1_XOR_x2 \
    out_0_v, in_0_0_v, in_0_1_v, tmp_0_v, \
    out_1_v, in_1_0_v, in_1_1_v, tmp_1_v, \
    tmp_0_s
    vsll.vi \tmp_0_v, \in_0_1_v, 1
    vsll.vi \tmp_1_v, \in_1_1_v, 1
    vsrl.vx \out_0_v, \in_0_1_v, \tmp_0_s
    vsrl.vx \out_1_v, \in_1_1_v, \tmp_0_s
    vxor.vv \out_0_v, \out_0_v, \tmp_0_v
    vxor.vv \out_1_v, \out_1_v, \tmp_1_v
    vxor.vv \out_0_v, \out_0_v, \in_0_0_v
    vxor.vv \out_1_v, \out_1_v, \in_1_0_v
.endm

.macro EachXOR S0_00_v, S0_01_v, S0_02_v, S0_03_v, S0_04_v, D_v
    vxor.vv \S0_00_v, \S0_00_v, \D_v
    vxor.vv \S0_01_v, \S0_01_v, \D_v
    vxor.vv \S0_02_v, \S0_02_v, \D_v
    vxor.vv \S0_03_v, \S0_03_v, \D_v
    vxor.vv \S0_04_v, \S0_04_v, \D_v
.endm

.macro ChiOp out_v, S00_v, S01_v, S02_v, T_v
    vnot.v  \T_v, \S01_v
    vand.vv \T_v, \T_v, \S02_v
    vxor.vv \out_v, \T_v, \S00_v
.endm

.macro xoror out_v, S00_v, S01_v, S02_v, T_v
    vor.vv  \T_v, \S01_v, \S02_v
    vxor.vv \out_v, \S00_v, \T_v
.endm

.macro xornotor out_v, S00_v, S01_v, S02_v, T_v
    vnot.v \T_v, \S01_v
    vor.vv  \T_v, \T_v, \S02_v
    vxor.vv \out_v, \S00_v, \T_v
.endm

.macro xorand out_v, S00_v, S01_v, S02_v, T_v
    vand.vv \T_v, \S01_v, \S02_v
    vxor.vv \out_v, \S00_v, \T_v
.endm

.macro xorornot out_v, S00_v, S01_v, S02_v, T_v
    vnot.v \T_v, \S02_v
    vor.vv  \T_v, \T_v, \S01_v
    vxor.vv \out_v, \S00_v, \T_v
.endm

.macro xornotand out_v, S00_v, S01_v, S02_v, T_v
    vnot.v \T_v, \S01_v
    vand.vv \T_v, \T_v, \S02_v
    vxor.vv \out_v, \S00_v, \T_v
.endm

.macro notxoror out_v, S00_v, S01_v, S02_v, T_v, T0_v
    vnot.v \T0_v, \S00_v
    vor.vv  \T_v, \S01_v, \S02_v
    vxor.vv \out_v, \T0_v, \T_v
.endm

.macro notxorand out_v, S00_v, S01_v, S02_v, T_v, T0_v
    vnot.v \T0_v, \S00_v
    vand.vv \T_v, \S01_v, \S02_v
    vxor.vv \out_v, \T0_v, \T_v
.endm

.macro ARoundInPlace \
    S00_v, S01_v, S02_v, S03_v, S04_v, S05_v, S06_v, S07_v, S08_v, S09_v, \
    S10_v, S11_v, S12_v, S13_v, S14_v, S15_v, S16_v, S17_v, S18_v, S19_v, \
    S20_v, S21_v, S22_v, S23_v, S24_v, T00_v, T01_v, T02_v, T03_v, T04_v, \
    T05_v, T06_v, T07_s
    # theta - start
    # T00,T01,T02=C1,C4,C3
    XOR5_x3 \
        \T00_v, \S01_v, \S06_v, \S11_v, \S16_v, \S21_v, \
        \T01_v, \S04_v, \S09_v, \S14_v, \S19_v, \S24_v, \
        \T02_v, \S03_v, \S08_v, \S13_v, \S18_v, \S23_v
    # T03,T04=D0,D2
    li \T07_s, 64-1
    ROL1_XOR_x2 \
        \T03_v, \T01_v, \T00_v, \T05_v, \
        \T04_v, \T00_v, \T02_v, \T06_v, \T07_s
    # T01,T02,T05,T06=C4,C3,C0,C2; T03,T04=D0,D2; T00: empty
    XOR5_x2 \
        \T05_v, \S00_v, \S05_v, \S10_v, \S15_v, \S20_v, \
        \T06_v, \S02_v, \S07_v, \S12_v, \S17_v, \S22_v
    EachXOR \S00_v, \S05_v, \S10_v, \S15_v, \S20_v, \T03_v
    vxor.vv \S02_v, \S02_v, \T04_v
    vxor.vv \S07_v, \S07_v, \T04_v
    vxor.vv \S12_v, \S12_v, \T04_v
    vsll.vi \T03_v, \T01_v, 1
    vsrl.vx \T00_v, \T01_v, \T07_s
    vxor.vv \S17_v, \S17_v, \T04_v
    vxor.vv \S22_v, \S22_v, \T04_v
    vxor.vv \T00_v, \T00_v, \T03_v
    vxor.vv \T00_v, \T00_v, \T06_v
    # T02,T05,T06=C3,C0,C2; T00:D3; T01,T03,T04: empty
    EachXOR \S03_v, \S08_v, \S13_v, \S18_v, \S23_v, \T00_v
    # T01,T04=D1,D4
    ROL1_XOR_x2 \
        \T01_v, \T05_v, \T06_v, \T00_v \
        \T04_v, \T02_v, \T05_v, \T03_v, \T07_s
    EachXOR \S01_v, \S06_v, \S11_v, \S16_v, \S21_v, \T01_v
    EachXOR \S04_v, \S09_v, \S14_v, \S19_v, \S24_v, \T04_v
    vmv.v.v \T00_v, \S00_v
    # theta - end
    # Rho & Pi & Chi - start
    ROLn_li \T01_v, \S06_v, \T02_v, 44, \T07_s
    ROLn_li \S00_v, \S02_v, \T03_v, 62, \T07_s
    ROLn_li \S02_v, \S12_v, \T02_v, 43, \T07_s
    ROLn_li \S12_v, \S13_v, \T03_v, 25, \T07_s
    ROLn_li \S13_v, \S19_v, \T02_v, 8,  \T07_s
    ROLn_li \S19_v, \S23_v, \T03_v, 56, \T07_s
    ROLn_li \S23_v, \S15_v, \T02_v, 41, \T07_s
    ROLn_li \S15_v, \S01_v, \T03_v, 1,  \T07_s
    ROLn_li \S01_v, \S08_v, \T02_v, 55, \T07_s
    ROLn_li \S08_v, \S16_v, \T03_v, 45, \T07_s
    ROLn_li \S16_v, \S07_v, \T02_v, 6,  \T07_s
    ROLn_li \S07_v, \S10_v, \T03_v, 3,  \T07_s
    ROLn_li \S10_v, \S03_v, \T02_v, 28, \T07_s
    ROLn_li \S03_v, \S18_v, \T03_v, 21, \T07_s
    ROLn_li \S18_v, \S17_v, \T02_v, 15, \T07_s
    ROLn_li \S17_v, \S11_v, \T03_v, 10, \T07_s
    ROLn_li \S11_v, \S09_v, \T02_v, 20, \T07_s
    ROLn_li \S09_v, \S22_v, \T03_v, 61, \T07_s
    ROLn_li \S22_v, \S14_v, \T02_v, 39, \T07_s
    ROLn_li \S14_v, \S20_v, \T03_v, 18, \T07_s
    ROLn_li \S20_v, \S04_v, \T02_v, 27, \T07_s
    ROLn_li \S04_v, \S24_v, \T03_v, 14, \T07_s
    ROLn_li \S24_v, \S21_v, \T02_v, 2,  \T07_s
    ROLn_li \S21_v, \S05_v, \T03_v, 36, \T07_s
    xoror    \S05_v, \S10_v, \S11_v, \S07_v, \T02_v
    xorand   \S06_v, \S11_v, \S07_v, \S08_v, \T03_v
    xorornot \S07_v, \S07_v, \S08_v, \S09_v, \T02_v
    xoror    \S08_v, \S08_v, \S09_v, \S10_v, \T03_v
    xorand   \S09_v, \S09_v, \S10_v, \S11_v, \T02_v
    xoror       \S10_v, \S15_v, \S16_v, \S12_v, \T03_v
    xorand      \S11_v, \S16_v, \S12_v, \S13_v, \T02_v
    xornotand   \S12_v, \S12_v, \S13_v, \S14_v, \T03_v
    notxoror    \S13_v, \S13_v, \S14_v, \S15_v, \T02_v, \T03_v
    xorand      \S14_v, \S14_v, \S15_v, \S16_v, \T03_v
    xorand      \S15_v, \S20_v, \S21_v, \S17_v, \T02_v
    xoror       \S16_v, \S21_v, \S17_v, \S18_v, \T03_v
    xornotor    \S17_v, \S17_v, \S18_v, \S19_v, \T02_v
    notxorand   \S18_v, \S18_v, \S19_v, \S20_v, \T03_v, \T02_v
    xoror       \S19_v, \S19_v, \S20_v, \S21_v, \T02_v
    xornotand   \S20_v, \S00_v, \S01_v, \S22_v, \T03_v
    notxoror    \S21_v, \S01_v, \S22_v, \S23_v, \T02_v, \T03_v
    xorand      \S22_v, \S22_v, \S23_v, \S24_v, \T03_v
    xoror       \S23_v, \S23_v, \S24_v, \S00_v, \T02_v
    xorand      \S24_v, \S24_v, \S00_v, \S01_v, \T03_v
    xoror       \S00_v, \T00_v, \T01_v, \S02_v, \T02_v
    xornotor    \S01_v, \T01_v, \S02_v, \S03_v, \T03_v
    xorand      \S02_v, \S02_v, \S03_v, \S04_v, \T02_v
    xoror       \S03_v, \S03_v, \S04_v, \T00_v, \T03_v
    xorand      \S04_v, \S04_v, \T00_v, \T01_v, \T02_v
    # Iota
    ld   a4, 0(a3)
    vxor.vx \S00_v, \S00_v, a4
    addi a3, a3, 8
    # Rho & Pi & Chi - end
.endm

.globl KeccakF1600_StatePermute_RV64V_2x
.align 2
KeccakF1600_StatePermute_RV64V_2x:

    li a1, 128
    vsetvli a2, a1, e64, m1, tu, mu

    LoadStates

    # a2: loop control variable i
    # a3: table index
    li a2, 24
    la a3, constants_keccak

loop:
    ARoundInPlace \
        v0,  v1,  v2,  v3,  v4,  v5,  v6,  v7,  v8,  v9,    \
        v10, v11, v12, v13, v14, v15, v16, v17, v18, v19,   \
        v20, v21, v22, v23, v24, v25, v26, v27, v28, v29,   \
        v30, v31, a4
    addi a2, a2, -1
    bnez a2, loop

    StoreStates

    ret
