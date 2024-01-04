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

.macro SaveRegs
    sd s0,   0*8(sp)
    sd s1,   1*8(sp)
    sd s2,   2*8(sp)
    sd s3,   3*8(sp)
    sd s4,   4*8(sp)
    sd s5,   5*8(sp)
    sd s6,   6*8(sp)
    sd s7,   7*8(sp)
    sd s8,   8*8(sp)
    sd s9,   9*8(sp)
    sd s10, 10*8(sp)
    sd s11, 11*8(sp)
    sd gp,  12*8(sp)
    sd tp,  13*8(sp)
    sd ra,  14*8(sp)
.endm

.macro RestoreRegs
    ld s0,   0*8(sp)
    ld s1,   1*8(sp)
    ld s2,   2*8(sp)
    ld s3,   3*8(sp)
    ld s4,   4*8(sp)
    ld s5,   5*8(sp)
    ld s6,   6*8(sp)
    ld s7,   7*8(sp)
    ld s8,   8*8(sp)
    ld s9,   9*8(sp)
    ld s10, 10*8(sp)
    ld s11, 11*8(sp)
    ld gp,  12*8(sp)
    ld tp,  13*8(sp)
    ld ra,  14*8(sp)
.endm

.macro LoadStates S00, S01, S02, S03, S04, \
                  S05, S06, S07, S08, S09, \
                  S10, S11, S12, S13, S14, \
                  S15, S16, S17, S18, S19, \
                  S20, S21, S22, S23, S24
    # load states for vector impl
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
    addi a0, a0, 1*16
    # load states for scalar impl
    ld \S00, 0*8(a0)
    ld \S01, 1*8(a0)
    ld \S02, 2*8(a0)
    ld \S03, 3*8(a0)
    ld \S04, 4*8(a0)
    ld \S05, 5*8(a0)
    ld \S06, 6*8(a0)
    ld \S07, 7*8(a0)
    ld \S08, 8*8(a0)
    ld \S09, 9*8(a0)
    ld \S10, 10*8(a0)
    ld \S11, 11*8(a0)
    ld \S12, 12*8(a0)
    ld \S13, 13*8(a0)
    ld \S14, 14*8(a0)
    ld \S15, 15*8(a0)
    ld \S16, 16*8(a0)
    ld \S17, 17*8(a0)
    not \S01, \S01
    not \S02, \S02
    not \S08, \S08
    not \S12, \S12
    not \S17, \S17
    ld \S18, 18*8(a0)
    ld \S19, 19*8(a0)
    ld \S20, 20*8(a0)
    ld \S21, 21*8(a0)
    ld \S22, 22*8(a0)
    ld \S23, 23*8(a0)
    not \S20, \S20
    ld \S24, 24*8(a0)

    addi a0, a0, -24*16
.endm

.macro StoreStates S00, S01, S02, S03, S04, \
                   S05, S06, S07, S08, S09, \
                   S10, S11, S12, S13, S14, \
                   S15, S16, S17, S18, S19, \
                   S20, S21, S22, S23, S24
    # store states for vector impl
    # lane complement: 1,2,8,12,17,20
    not \S01, \S01
    vnot.v v1, v1
    not \S02, \S02
    vnot.v v2, v2
    not \S08, \S08
    vnot.v v8, v8
    not \S12, \S12
    vnot.v v12, v12
    not \S17, \S17
    vnot.v v17, v17
    not \S20, \S20
    vnot.v v20, v20

    vs8r.v v0, (a0)
    addi a0, a0, 8*16
    vs8r.v v8, (a0)
    addi a0, a0, 8*16
    vs8r.v v16, (a0)
    addi a0, a0, 8*16
    vse64.v v24, (a0)
    addi a0, a0, 1*16
    # store states for scalar impl
    sd \S00, 0*8(a0)
    sd \S01, 1*8(a0)
    sd \S02, 2*8(a0)
    sd \S03, 3*8(a0)
    sd \S04, 4*8(a0)
    sd \S05, 5*8(a0)
    sd \S06, 6*8(a0)
    sd \S07, 7*8(a0)
    sd \S08, 8*8(a0)
    sd \S09, 9*8(a0)
    sd \S10, 10*8(a0)
    sd \S11, 11*8(a0)
    sd \S12, 12*8(a0)
    sd \S13, 13*8(a0)
    sd \S14, 14*8(a0)
    sd \S15, 15*8(a0)
    sd \S16, 16*8(a0)
    sd \S17, 17*8(a0)
    sd \S18, 18*8(a0)
    sd \S19, 19*8(a0)
    sd \S20, 20*8(a0)
    sd \S21, 21*8(a0)
    sd \S22, 22*8(a0)
    sd \S23, 23*8(a0)
    sd \S24, 24*8(a0)
.endm

.macro XOR5 \
        out_v, S00_v, S01_v, S02_v, S03_v, S04_v, \
        out, S00, S01, S02, S03, S04
    xor     \out, \S00, \S01;           vxor.vv \out_v, \S00_v, \S01_v
    xor     \out, \out, \S02;           vxor.vv \out_v, \out_v, \S02_v
    xor     \out, \out, \S03;           vxor.vv \out_v, \out_v, \S03_v
    xor     \out, \out, \S04;           vxor.vv \out_v, \out_v, \S04_v
.endm

.macro ROLn \
        out_v, in_v, tmp_v, \
        out, in, tmp, tmp1, n
.if \n < 32
    li      \tmp1, 64-\n
    slli    \tmp, \in, \n;              vsll.vi \tmp_v, \in_v, \n
    srli    \out, \in, 64-\n;           vsrl.vx \out_v, \in_v, \tmp1
    xor     \out, \out, \tmp;           vxor.vv \out_v, \out_v, \tmp_v
.else
    li      \tmp1, \n
    slli    \tmp, \in, \n;              vsll.vx \tmp_v, \in_v, \tmp1
    srli    \out, \in, 64-\n;           vsrl.vi \out_v, \in_v, 64-\n
    xor     \out, \out, \tmp;           vxor.vv \out_v, \out_v, \tmp_v
.endif

.endm

.macro ROL1 \
        out_v, in_v, tmp_v, \
        out, in, tmp, tmp1
    ROLn \out_v, \in_v, \tmp_v, \out, \in, \tmp, \tmp1, 1
.endm

.macro EachXOR \
        S00_v, S01_v, S02_v, S03_v, S04_v, D_v, \
        S00, S01, S02, S03, S04, D
    xor     \S00, \S00, \D;             vxor.vv \S00_v, \S00_v, \D_v
    xor     \S01, \S01, \D;             vxor.vv \S01_v, \S01_v, \D_v
    xor     \S02, \S02, \D;             vxor.vv \S02_v, \S02_v, \D_v
    xor     \S03, \S03, \D;             vxor.vv \S03_v, \S03_v, \D_v
    xor     \S04, \S04, \D;             vxor.vv \S04_v, \S04_v, \D_v
.endm

.macro ChiOp \
        out_v, S00_v, S01_v, S02_v, T_v, \
        out, S00, S01, S02, T
    not     \T, \S01;                   vnot.v  \T_v, \S01_v
    and     \T, \T, \S02;               vand.vv \T_v, \T_v, \S02_v
    xor     \out, \T, \S00;             vxor.vv \out_v, \T_v, \S00_v
.endm

.macro xoror \
        out_v, S00_v, S01_v, S02_v, T_v, \
        out, S00, S01, S02, T
    or      \T, \S01, \S02;             vor.vv  \T_v, \S01_v, \S02_v
    xor     \out, \S00, \T;             vxor.vv \out_v, \S00_v, \T_v
.endm

.macro xornotor \
        out_v, S00_v, S01_v, S02_v, T_v, \
        out, S00, S01, S02, T
    not     \T, \S01;                   vnot.v  \T_v, \S01_v
    or      \T, \T, \S02;               vor.vv  \T_v, \T_v, \S02_v
    xor     \out, \S00, \T;             vxor.vv \out_v, \S00_v, \T_v
.endm

.macro xorand \
        out_v, S00_v, S01_v, S02_v, T_v, \
        out, S00, S01, S02, T
    and     \T, \S01, \S02;             vand.vv \T_v, \S01_v, \S02_v
    xor     \out, \S00, \T;             vxor.vv \out_v, \S00_v, \T_v
.endm

.macro xorornot \
        out_v, S00_v, S01_v, S02_v, T_v, \
        out, S00, S01, S02, T
    not     \T, \S02;                   vnot.v  \T_v, \S02_v
    or      \T, \T, \S01;               vor.vv  \T_v, \T_v, \S01_v
    xor     \out, \S00, \T;             vxor.vv \out_v, \S00_v, \T_v
.endm

.macro xornotand \
        out_v, S00_v, S01_v, S02_v, T_v, \
        out, S00, S01, S02, T
    not     \T, \S01;                   vnot.v  \T_v, \S01_v
    and     \T, \T, \S02;               vand.vv \T_v, \T_v, \S02_v
    xor     \out, \S00, \T;             vxor.vv \out_v, \S00_v, \T_v
.endm

.macro notxoror \
        out_v, S00_v, S01_v, S02_v, T_v, T_v0, \
        out, S00, S01, S02, T, T0
    not     \T0, \S00;                  vnot.v  \T_v0, \S00_v
    or      \T, \S01, \S02;             vor.vv  \T_v, \S01_v, \S02_v
    xor     \out, \T0, \T;              vxor.vv \out_v, \T_v0, \T_v
.endm

.macro notxorand \
        out_v, S00_v, S01_v, S02_v, T_v, T_v0, \
        out, S00, S01, S02, T, T0
    not     \T0, \S00;                  vnot.v  \T_v0, \S00_v
    and     \T, \S01, \S02;             vand.vv \T_v, \S01_v, \S02_v
    xor     \out, \T0, \T;              vxor.vv \out_v, \T_v0, \T_v
.endm

.macro ARoundInPlace  \
        S00_v, S01_v, S02_v, S03_v, S04_v, S05_v, S06_v, S07_v, S08_v, S09_v, \
        S10_v, S11_v, S12_v, S13_v, S14_v, S15_v, S16_v, S17_v, S18_v, S19_v, \
        S20_v, S21_v, S22_v, S23_v, S24_v, T00_v, T01_v, T02_v, T03_v, T04_v, \
        S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
        S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
        S20, S21, S22, S23, S24, T00, T01, T02, T03, T04
    # theta - start
    # C0 = S00_v ^ S05_v ^ S10_v ^ S15_v ^ S20_v
    XOR5 \T00_v, \S00_v, \S05_v, \S10_v, \S15_v, \S20_v, \
         \T00, \S00, \S05, \S10, \S15, \S20
    # C2 = S02_v ^ S07_v ^ S12_v ^ S17_v ^ S22_v
    XOR5 \T01_v, \S02_v, \S07_v, \S12_v, \S17_v, \S22_v, \
         \T01, \S02, \S07, \S12, \S17, \S22
    # D1 = C0 ^ ROL(C2, 1)
    ROL1 \T02_v, \T01_v, \T03_v, \
         \T02, \T01, \T03, \T04
    xor  \T02, \T02, \T00;              vxor.vv  \T02_v, \T02_v, \T00_v
    # T00=C0 T01=C2 T02=D1

    # C1 = S01_v ^ S06_v ^ S11_v ^ S16_v ^ S21_v
    XOR5 \T03_v, \S01_v, \S06_v, \S11_v, \S16_v, \S21_v, \
         \T03, \S01, \S06, \S11, \S16, \S21
    # S06_v ^= D1; S16_v ^= D1; S01_v ^= D1; S11_v ^= D1; S21_v ^= D1
    EachXOR \S01_v, \S06_v, \S11_v, \S16_v, \S21_v, \T02_v, \
            \S01, \S06, \S11, \S16, \S21, \T02

    # store S01 into stack for temporary usage
    sd \S01, 18*8(sp)

    # C4 = S04_v ^ S09_v ^ S14_v ^ S19_v ^ S24_v
    XOR5 \T02_v, \S04_v, \S09_v, \S14_v, \S19_v, \S24_v, \
         \T02, \S04, \S09, \S14, \S19, \S24
    # D3 = C2 ^ ROL(C4, 1); C2 can be overwritten
    # T00=C0 T01=D3 T03=C1 T02=C4
    slli \T04, \T02, 1;                 vsll.vi \T04_v, \T02_v, 1
    xor  \T01, \T01, \T04;              vxor.vv \T01_v, \T01_v, \T04_v
    li \S01, 63
    srli \T04, \T02, 63;                vsrl.vx \T04_v, \T02_v, \S01
    xor  \T01, \T01, \T04;              vxor.vv \T01_v, \T01_v, \T04_v

    # C3 = S03_v ^ S08_v ^ S13_v ^ S18_v ^ S23_v
    XOR5 \T04_v, \S03_v, \S08_v, \S13_v, \S18_v, \S23_v, \
         \T04, \S03, \S08, \S13, \S18, \S23
    # S18_v ^= D3; S03_v ^= D3; S13_v ^= D3; S23_v ^= D3; S08_v ^= D3
    EachXOR \S03_v, \S08_v, \S13_v, \S18_v, \S23_v, \T01_v, \
            \S03, \S08, \S13, \S18, \S23, \T01
    # T00=C0 T03=C1 T02=C4 T04=C3

    # D4 = C3 ^ ROL(C0, 1); C0 can be overwritten
    ROL1 \T00_v, \T00_v, \T01_v, \
         \T00, \T00, \T01, \S01
    xor  \T00, \T00, \T04;              vxor.vv \T00_v, \T00_v, \T04_v
    # S24_v ^= D4; S09_v ^= D4; S19_v ^= D4; S04_v ^= D4; S14_v ^= D4
    EachXOR \S04_v, \S09_v, \S14_v, \S19_v, \S24_v, \T00_v, \
            \S04, \S09, \S14, \S19, \S24, \T00

    # D2 = C1 ^ ROL(C3, 1)
    ROL1 \T04_v, \T04_v, \T01_v, \
         \T04, \T04, \T01, \S01
    xor  \T04, \T04, \T03;              vxor.vv  \T04_v, \T04_v, \T03_v
    # S12_v ^= D2; S22_v ^= D2; S07_v ^= D2; S17_v ^= D2; S02_v ^= D2
    EachXOR \S02_v, \S07_v, \S12_v, \S17_v, \S22_v, \T04_v, \
            \S02, \S07, \S12, \S17, \S22, \T04

    # D0 = C4 ^ ROL(C1, 1)
    ROL1 \T03_v, \T03_v, \T01_v, \
         \T03, \T03, \T01, \S01
    xor  \T03, \T03, \T02;              vxor.vv  \T03_v, \T03_v, \T02_v
    # S00_v ^= D0; S05_v ^= D0; S10_v ^= D0; S15_v ^= D0; S20_v ^= D0
    # EachXOR \S00_v, \S05_v, \S10_v, \S15_v, \S20_v, \T03_v
    xor \S05, \S05, \T03;               vxor.vv \S05_v, \S05_v, \T03_v
    xor \S10, \S10, \T03;               vxor.vv \S10_v, \S10_v, \T03_v
    xor \S15, \S15, \T03;               vxor.vv \S15_v, \S15_v, \T03_v
    xor \S20, \S20, \T03;               vxor.vv \S20_v, \S20_v, \T03_v
    xor \T00, \S00, \T03;               vxor.vv \T00_v, \S00_v, \T03_v
    # theta - end

    # restore S01 from stack
    ld \S01, 18*8(sp)

    # Rho & Pi & Chi - start
    ROLn \T01_v, \S06_v, \T02_v, \T01, \S06, \T02, \T03, 44
    ROLn \S00_v, \S02_v, \T03_v, \S00, \S02, \T02, \T03, 62
    ROLn \S02_v, \S12_v, \T02_v, \S02, \S12, \T02, \T03, 43
    ROLn \S12_v, \S13_v, \T03_v, \S12, \S13, \T02, \T03, 25
    ROLn \S13_v, \S19_v, \T02_v, \S13, \S19, \T02, \T03, 8
    ROLn \S19_v, \S23_v, \T03_v, \S19, \S23, \T02, \T03, 56
    ROLn \S23_v, \S15_v, \T02_v, \S23, \S15, \T02, \T03, 41
    ROLn \S15_v, \S01_v, \T03_v, \S15, \S01, \T02, \T03, 1
    ROLn \S01_v, \S08_v, \T02_v, \S01, \S08, \T02, \T03, 55
    ROLn \S08_v, \S16_v, \T03_v, \S08, \S16, \T02, \T03, 45
    ROLn \S16_v, \S07_v, \T02_v, \S16, \S07, \T02, \T03, 6
    ROLn \S07_v, \S10_v, \T03_v, \S07, \S10, \T02, \T03, 3
    ROLn \S10_v, \S03_v, \T02_v, \S10, \S03, \T02, \T03, 28
    ROLn \S03_v, \S18_v, \T03_v, \S03, \S18, \T02, \T03, 21
    ROLn \S18_v, \S17_v, \T02_v, \S18, \S17, \T02, \T03, 15
    ROLn \S17_v, \S11_v, \T03_v, \S17, \S11, \T02, \T03, 10
    ROLn \S11_v, \S09_v, \T02_v, \S11, \S09, \T02, \T03, 20
    ROLn \S09_v, \S22_v, \T03_v, \S09, \S22, \T02, \T03, 61
    ROLn \S22_v, \S14_v, \T02_v, \S22, \S14, \T02, \T03, 39
    ROLn \S14_v, \S20_v, \T03_v, \S14, \S20, \T02, \T03, 18
    ROLn \S20_v, \S04_v, \T02_v, \S20, \S04, \T02, \T03, 27
    ROLn \S04_v, \S24_v, \T03_v, \S04, \S24, \T02, \T03, 14
    ROLn \S24_v, \S21_v, \T02_v, \S24, \S21, \T02, \T03, 2
    ROLn \S21_v, \S05_v, \T03_v, \S21, \S05, \T02, \T03, 36

    xoror    \S05_v, \S10_v, \S11_v, \S07_v, \T02_v, \S05, \S10, \S11, \S07, \T02
    xorand   \S06_v, \S11_v, \S07_v, \S08_v, \T03_v, \S06, \S11, \S07, \S08, \T03
    xorornot \S07_v, \S07_v, \S08_v, \S09_v, \T02_v, \S07, \S07, \S08, \S09, \T02
    xoror    \S08_v, \S08_v, \S09_v, \S10_v, \T03_v, \S08, \S08, \S09, \S10, \T03
    xorand   \S09_v, \S09_v, \S10_v, \S11_v, \T02_v, \S09, \S09, \S10, \S11, \T02

    xoror       \S10_v, \S15_v, \S16_v, \S12_v, \T03_v, \S10, \S15, \S16, \S12, \T03
    xorand      \S11_v, \S16_v, \S12_v, \S13_v, \T02_v, \S11, \S16, \S12, \S13, \T02
    xornotand   \S12_v, \S12_v, \S13_v, \S14_v, \T03_v, \S12, \S12, \S13, \S14, \T03
    notxoror    \S13_v, \S13_v, \S14_v, \S15_v, \T02_v, \T03_v, \S13, \S13, \S14, \S15, \T02, \T03
    xorand      \S14_v, \S14_v, \S15_v, \S16_v, \T03_v, \S14, \S14, \S15, \S16, \T03

    xorand      \S15_v, \S20_v, \S21_v, \S17_v, \T02_v, \S15, \S20, \S21, \S17, \T02
    xoror       \S16_v, \S21_v, \S17_v, \S18_v, \T03_v, \S16, \S21, \S17, \S18, \T03
    xornotor    \S17_v, \S17_v, \S18_v, \S19_v, \T02_v, \S17, \S17, \S18, \S19, \T02
    notxorand   \S18_v, \S18_v, \S19_v, \S20_v, \T03_v, \T02_v, \S18, \S18, \S19, \S20, \T03, \T02
    xoror       \S19_v, \S19_v, \S20_v, \S21_v, \T02_v, \S19, \S19, \S20, \S21, \T02

    xornotand   \S20_v, \S00_v, \S01_v, \S22_v, \T03_v, \S20, \S00, \S01, \S22, \T03
    notxoror    \S21_v, \S01_v, \S22_v, \S23_v, \T02_v, \T03_v, \S21, \S01, \S22, \S23, \T02, \T03
    xorand      \S22_v, \S22_v, \S23_v, \S24_v, \T03_v, \S22, \S22, \S23, \S24, \T03
    xoror       \S23_v, \S23_v, \S24_v, \S00_v, \T02_v, \S23, \S23, \S24, \S00, \T02
    xorand      \S24_v, \S24_v, \S00_v, \S01_v, \T03_v, \S24, \S24, \S00, \S01, \T03

    xoror       \S00_v, \T00_v, \T01_v, \S02_v, \T02_v, \S00, \T00, \T01, \S02, \T02
    xornotor    \S01_v, \T01_v, \S02_v, \S03_v, \T03_v, \S01, \T01, \S02, \S03, \T03
    xorand      \S02_v, \S02_v, \S03_v, \S04_v, \T02_v, \S02, \S02, \S03, \S04, \T02
    xoror       \S03_v, \S03_v, \S04_v, \T00_v, \T03_v, \S03, \S03, \S04, \T00, \T03
    xorand      \S04_v, \S04_v, \T00_v, \T01_v, \T02_v, \S04, \S04, \T00, \T01, \T02

    # Iota
    ld   \T04, 17*8(sp)
    ld   \T03, 0(\T04)
    xor  \S00, \S00, \T03;              vxor.vx \S00_v, \S00_v, \T03
    addi \T04, \T04, 8
    sd   \T04, 17*8(sp)
    # Rho & Pi & Chi - end
.endm

# 15*8(sp): a0
# 16*8(sp): loop control variable i
# 17*8(sp): table index
# 18*8(sp): temp
.globl KeccakF1600_StatePermute_RV64V_3x
.align 2
KeccakF1600_StatePermute_RV64V_3x:
    addi sp, sp, -8*19
    SaveRegs
    sd a0, 15*8(sp)

    la a1, constants_keccak
    sd a1, 17*8(sp)

    li a1, 128
    vsetvli a1, a1, e64, m1, tu, mu

    LoadStates \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10
    
    li a0, 24

loop:
    sd a0, 16*8(sp)
    ARoundInPlace \
        v0,  v1,  v2,  v3,  v4,  v5,  v6,  v7,  v8,  v9,    \
        v10, v11, v12, v13, v14, v15, v16, v17, v18, v19,   \
        v20, v21, v22, v23, v24, v25, v26, v27, v28, v29,   \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10,s11,ra, gp, tp, a0
    ld a0, 16*8(sp)
    addi a0, a0, -1
    bnez a0, loop

    ld a0, 15*8(sp)
    StoreStates \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10

    RestoreRegs
    addi sp, sp, 8*19
    ret
