.data
.align 2
constants_keccak:
.quad 0x0000000000000001
.quad 0x0000000000000001
.quad 0x0000000000008082
.quad 0x0000000000008082
.quad 0x800000000000808a
.quad 0x800000000000808a
.quad 0x8000000080008000
.quad 0x8000000080008000
.quad 0x000000000000808b
.quad 0x000000000000808b
.quad 0x0000000080000001
.quad 0x0000000080000001
.quad 0x8000000080008081
.quad 0x8000000080008081
.quad 0x8000000000008009
.quad 0x8000000000008009
.quad 0x000000000000008a
.quad 0x000000000000008a
.quad 0x0000000000000088
.quad 0x0000000000000088
.quad 0x0000000080008009
.quad 0x0000000080008009
.quad 0x000000008000000a
.quad 0x000000008000000a
.quad 0x000000008000808b
.quad 0x000000008000808b
.quad 0x800000000000008b
.quad 0x800000000000008b
.quad 0x8000000000008089
.quad 0x8000000000008089
.quad 0x8000000000008003
.quad 0x8000000000008003
.quad 0x8000000000008002
.quad 0x8000000000008002
.quad 0x8000000000000080
.quad 0x8000000000000080
.quad 0x000000000000800a
.quad 0x000000000000800a
.quad 0x800000008000000a
.quad 0x800000008000000a
.quad 0x8000000080008081
.quad 0x8000000080008081
.quad 0x8000000000008080
.quad 0x8000000000008080
.quad 0x0000000080000001
.quad 0x0000000080000001
.quad 0x8000000080008008
.quad 0x8000000080008008

.text

#ifdef V0p7
.macro LoadStates
    # lane complement: 1,2,8,12,17,20
    vle.v v0, (a0)
    addi a0, a0, 16
    vle.v v1, (a0)
    addi a0, a0, 16
    vle.v v2, (a0)
    addi a0, a0, 16
    vle.v v3, (a0)
    addi a0, a0, 16
    vle.v v4, (a0)
    addi a0, a0, 16
    vle.v v5, (a0)
    addi a0, a0, 16
    vle.v v6, (a0)
    addi a0, a0, 16
    vle.v v7, (a0)
    addi a0, a0, 16                        
    vle.v v8, (a0)
    addi a0, a0, 16
    vle.v v9, (a0)
    addi a0, a0, 16
    vle.v v10, (a0)
    addi a0, a0, 16
    vle.v v11, (a0)
    addi a0, a0, 16
    vle.v v12, (a0)
    addi a0, a0, 16
    vle.v v13, (a0)
    addi a0, a0, 16
    vle.v v14, (a0)
    addi a0, a0, 16
    vle.v v15, (a0)
    addi a0, a0, 16  
    vnot.v v1, v1
    vnot.v v2, v2
    vnot.v v8, v8
    vnot.v v12, v12
    vle.v v16, (a0)
    addi a0, a0, 16
    vle.v v17, (a0)
    addi a0, a0, 16
    vle.v v18, (a0)
    addi a0, a0, 16
    vle.v v19, (a0)
    addi a0, a0, 16
    vle.v v20, (a0)
    addi a0, a0, 16
    vle.v v21, (a0)
    addi a0, a0, 16
    vle.v v22, (a0)
    addi a0, a0, 16
    vle.v v23, (a0)
    addi a0, a0, 16  
    vnot.v v17, v17
    vnot.v v20, v20
    vle.v v24, (a0)
    addi a0, a0, -24*16
.endm
#else
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
#endif

#ifdef V0p7
.macro StoreStates
    # lane complement: 1,2,8,12,17,20
    vnot.v v1, v1
    vnot.v v2, v2
    vnot.v v8, v8
    vnot.v v12, v12
    vnot.v v17, v17
    vnot.v v20, v20
    vse.v v0, (a0)
    addi a0, a0, 16
    vse.v v1, (a0)
    addi a0, a0, 16
    vse.v v2, (a0)
    addi a0, a0, 16
    vse.v v3, (a0)
    addi a0, a0, 16
    vse.v v4, (a0)
    addi a0, a0, 16
    vse.v v5, (a0)
    addi a0, a0, 16
    vse.v v6, (a0)
    addi a0, a0, 16
    vse.v v7, (a0)
    addi a0, a0, 16
    vse.v v8, (a0)
    addi a0, a0, 16
    vse.v v9, (a0)
    addi a0, a0, 16
    vse.v v10, (a0)
    addi a0, a0, 16
    vse.v v11, (a0)
    addi a0, a0, 16
    vse.v v12, (a0)
    addi a0, a0, 16
    vse.v v13, (a0)
    addi a0, a0, 16
    vse.v v14, (a0)
    addi a0, a0, 16
    vse.v v15, (a0)
    addi a0, a0, 16
    vse.v v16, (a0)
    addi a0, a0, 16
    vse.v v17, (a0)
    addi a0, a0, 16
    vse.v v18, (a0)
    addi a0, a0, 16
    vse.v v19, (a0)
    addi a0, a0, 16
    vse.v v20, (a0)
    addi a0, a0, 16
    vse.v v21, (a0)
    addi a0, a0, 16
    vse.v v22, (a0)
    addi a0, a0, 16
    vse.v v23, (a0)
    addi a0, a0, 16
    vse.v v24, (a0)
.endm
#else
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
#endif

.macro XOR5 out, S00, S01, S02, S03, S04
    vxor.vv \out, \S00, \S01
    vxor.vv \out, \out, \S02
    vxor.vv \out, \out, \S03
    vxor.vv \out, \out, \S04
.endm

.macro ROLn out, in, tmp, n
.if \n < 32
    li a4, 64-\n
    vsll.vi \tmp, \in, \n
    vsrl.vx \out, \in, a4
    vxor.vv \out, \out, \tmp
.else
    li a4, \n
    vsll.vx \tmp, \in, a4
    vsrl.vi \out, \in, 64-\n
    vxor.vv \out, \out, \tmp
.endif
.endm

.macro ROL1 out, in, tmp
    ROLn \out, \in, \tmp, 1
.endm

.macro EachXOR S00, S01, S02, S03, S04, D
    vxor.vv \S00, \S00, \D
    vxor.vv \S01, \S01, \D
    vxor.vv \S02, \S02, \D
    vxor.vv \S03, \S03, \D
    vxor.vv \S04, \S04, \D
.endm

.macro ChiOp out, S00, S01, S02, T
    vnot.v  \T, \S01
    vand.vv \T, \T, \S02
    vxor.vv \out, \T, \S00
.endm

.macro xoror out, S00, S01, S02, T
    vor.vv  \T, \S01, \S02
    vxor.vv \out, \S00, \T
.endm

.macro xornotor out, S00, S01, S02, T
    vnot.v \T, \S01
    vor.vv  \T, \T, \S02
    vxor.vv \out, \S00, \T
.endm

.macro xorand out, S00, S01, S02, T
    vand.vv \T, \S01, \S02
    vxor.vv \out, \S00, \T
.endm

.macro xorornot out, S00, S01, S02, T
    vnot.v \T, \S02
    vor.vv  \T, \T, \S01
    vxor.vv \out, \S00, \T
.endm

.macro xornotand out, S00, S01, S02, T
    vnot.v \T, \S01
    vand.vv \T, \T, \S02
    vxor.vv \out, \S00, \T
.endm

.macro notxoror out, S00, S01, S02, T, T0
    vnot.v \T0, \S00
    vor.vv  \T, \S01, \S02
    vxor.vv \out, \T0, \T
.endm

.macro notxorand out, S00, S01, S02, T, T0
    vnot.v \T0, \S00
    vand.vv \T, \S01, \S02
    vxor.vv \out, \T0, \T
.endm

.macro ARoundInPlace    S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
                        S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
                        S20, S21, S22, S23, S24, T00, T01, T02, T03, T04, \
                        Ts0, Ts1
    # theta - start
    # C0 = S00 ^ S05 ^ S10 ^ S15 ^ S20
    XOR5 \T00, \S00, \S05, \S10, \S15, \S20
    # C2 = S02 ^ S07 ^ S12 ^ S17 ^ S22
    XOR5 \T01, \S02, \S07, \S12, \S17, \S22 // T00=C0 T01=C2
    # D1 = C0 ^ ROL(C2, 1)
    ROL1 \T02, \T01, \T03
    vxor.vv  \T02, \T02, \T00 // T00=C0 T01=C2 T02=D1

    # C1 = S01 ^ S06 ^ S11 ^ S16 ^ S21
    XOR5 \T03, \S01, \S06, \S11, \S16, \S21 // T00=C0 T01=C2 T02=D1 T03=C1
    # S06 ^= D1; S16 ^= D1; S01 ^= D1; S11 ^= D1; S21 ^= D1
    EachXOR \S01, \S06, \S11, \S16, \S21, \T02 // T00=C0 T01=C2 T03=C1

    # C4 = S04 ^ S09 ^ S14 ^ S19 ^ S24
    XOR5 \T02, \S04, \S09, \S14, \S19, \S24 // T00=C0 T01=C2 T03=C1 T02=C4
    # D3 = C2 ^ ROL(C4, 1); C2 can be overwritten
    vsll.vi \T04, \T02, 1
    vxor.vv \T01, \T01, \T04
    li \Ts0, 63
    vsrl.vx \T04, \T02, \Ts0
    vxor.vv \T01, \T01, \T04 // T00=C0 T01=D3 T03=C1 T02=C4

    # C3 = S03 ^ S08 ^ S13 ^ S18 ^ S23
    XOR5 \T04, \S03, \S08, \S13, \S18, \S23 // T00=C0 T01=D3 T03=C1 T02=C4 T04=C3
    # S18 ^= D3; S03 ^= D3; S13 ^= D3; S23 ^= D3; S08 ^= D3
    EachXOR \S03, \S08, \S13, \S18, \S23, \T01 // T00=C0 T03=C1 T02=C4 T04=C3

    # D4 = C3 ^ ROL(C0, 1); C0 can be overwritten
    ROL1 \T00, \T00, \T01
    vxor.vv \T00, \T00, \T04 // T00=D4 T03=C1 T02=C4 T04=C3
    # S24 ^= D4; S09 ^= D4; S19 ^= D4; S04 ^= D4; S14 ^= D4
    EachXOR \S04, \S09, \S14, \S19, \S24, \T00 // T03=C1 T02=C4 T04=C3

    # D2 = C1 ^ ROL(C3, 1)
    ROL1 \T04, \T04, \T01
    vxor.vv  \T04, \T04, \T03 // T03=C1 T02=C4 T04=D2
    # S12 ^= D2; S22 ^= D2; S07 ^= D2; S17 ^= D2; S02 ^= D2
    EachXOR \S02, \S07, \S12, \S17, \S22, \T04 // T03=C1 T02=C4

    # D0 = C4 ^ ROL(C1, 1)
    ROL1 \T03, \T03, \T01
    vxor.vv  \T03, \T03, \T02 // T03=D0
    # S00 ^= D0; S05 ^= D0; S10 ^= D0; S15 ^= D0; S20 ^= D0
    # EachXOR \S00, \S05, \S10, \S15, \S20, \T03
    vxor.vv \S05, \S05, \T03
    vxor.vv \S10, \S10, \T03
    vxor.vv \S15, \S15, \T03
    vxor.vv \S20, \S20, \T03
    vxor.vv \T00, \S00, \T03
    # theta - end

    # Rho & Pi & Chi - start
    ROLn \T01, \S06, \T02, 44
    ROLn \S00, \S02, \T03, 62
    ROLn \S02, \S12, \T02, 43
    ROLn \S12, \S13, \T03, 25
    ROLn \S13, \S19, \T02, 8
    ROLn \S19, \S23, \T03, 56
    ROLn \S23, \S15, \T02, 41
    ROLn \S15, \S01, \T03, 1
    ROLn \S01, \S08, \T02, 55
    ROLn \S08, \S16, \T03, 45
    ROLn \S16, \S07, \T02, 6
    ROLn \S07, \S10, \T03, 3
    ROLn \S10, \S03, \T02, 28
    ROLn \S03, \S18, \T03, 21
    ROLn \S18, \S17, \T02, 15
    ROLn \S17, \S11, \T03, 10
    ROLn \S11, \S09, \T02, 20
    ROLn \S09, \S22, \T03, 61
    ROLn \S22, \S14, \T02, 39
    ROLn \S14, \S20, \T03, 18
    ROLn \S20, \S04, \T02, 27
    ROLn \S04, \S24, \T03, 14
    ROLn \S24, \S21, \T02, 2
    ROLn \S21, \S05, \T03, 36

    xoror    \S05, \S10, \S11, \S07, \T02
    xorand   \S06, \S11, \S07, \S08, \T03
    xorornot \S07, \S07, \S08, \S09, \T02
    xoror    \S08, \S08, \S09, \S10, \T03
    xorand   \S09, \S09, \S10, \S11, \T02

    xoror       \S10, \S15, \S16, \S12, \T03
    xorand      \S11, \S16, \S12, \S13, \T02
    xornotand   \S12, \S12, \S13, \S14, \T03
    notxoror    \S13, \S13, \S14, \S15, \T02, \T03
    xorand      \S14, \S14, \S15, \S16, \T03

    xorand      \S15, \S20, \S21, \S17, \T02
    xoror       \S16, \S21, \S17, \S18, \T03
    xornotor    \S17, \S17, \S18, \S19, \T02
    notxorand   \S18, \S18, \S19, \S20, \T03, \T02
    xoror       \S19, \S19, \S20, \S21, \T02

    xornotand   \S20, \S00, \S01, \S22, \T03
    notxoror    \S21, \S01, \S22, \S23, \T02, \T03
    xorand      \S22, \S22, \S23, \S24, \T03
    xoror       \S23, \S23, \S24, \S00, \T02
    xorand      \S24, \S24, \S00, \S01, \T03

    xoror       \S00, \T00, \T01, \S02, \T02
    xornotor    \S01, \T01, \S02, \S03, \T03
    xorand      \S02, \S02, \S03, \S04, \T02
    xoror       \S03, \S03, \S04, \T00, \T03
    xorand      \S04, \S04, \T00, \T01, \T02

    # Iota
#ifdef V0p7
    vle.v  \T00, 0(\Ts1)
#else
    vle64.v  \T00, 0(\Ts1)
#endif
    vxor.vv  \S00, \S00, \T00
    addi \Ts1, \Ts1, 16
    # Rho & Pi & Chi - end
.endm

.globl KeccakF1600_StatePermute_RV32V_2x
.align 2
KeccakF1600_StatePermute_RV32V_2x:

    li a1, 128
#ifdef V0p7
    vsetvli a2, a1, e64
#else
    vsetvli a2, a1, e64, m1, tu, mu
#endif

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
        a4, a3
    addi a2, a2, -1
    bnez a2, loop

    StoreStates

    ret
