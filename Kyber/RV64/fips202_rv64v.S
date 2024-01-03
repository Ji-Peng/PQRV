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

.macro LoadStates S00, S01, S02, S03, S04, \
                  S05, S06, S07, S08, S09, \
                  S10, S11, S12, S13, S14, \
                  S15, S16, S17, S18, S19, \
                  S20, S21, S22, S23, S24
    vle64.v \S00, (a0)
    addi a0, a0, 16
    vle64.v \S01, (a0)
    addi a0, a0, 16
    vle64.v \S02, (a0)
    addi a0, a0, 16
    vle64.v \S03, (a0)
    addi a0, a0, 16
    vle64.v \S04, (a0)
    addi a0, a0, 16
    vle64.v \S05, (a0)
    addi a0, a0, 16
    vle64.v \S06, (a0)
    addi a0, a0, 16
    vle64.v \S07, (a0)
    addi a0, a0, 16
    vle64.v \S08, (a0)
    addi a0, a0, 16
    vle64.v \S09, (a0)
    addi a0, a0, 16
    vle64.v \S10, (a0)
    addi a0, a0, 16
    vle64.v \S11, (a0)
    addi a0, a0, 16
    vle64.v \S12, (a0)
    addi a0, a0, 16
    vle64.v \S13, (a0)
    addi a0, a0, 16
    vle64.v \S14, (a0)
    addi a0, a0, 16
    vle64.v \S15, (a0)
    addi a0, a0, 16
    vle64.v \S16, (a0)
    addi a0, a0, 16
    vle64.v \S17, (a0)
    addi a0, a0, 16
    vle64.v \S18, (a0)
    addi a0, a0, 16
    vle64.v \S19, (a0)
    addi a0, a0, 16
    vle64.v \S20, (a0)
    addi a0, a0, 16
    vle64.v \S21, (a0)
    addi a0, a0, 16
    vle64.v \S22, (a0)
    addi a0, a0, 16
    vle64.v \S23, (a0)
    addi a0, a0, 16
    vle64.v \S24, (a0)

    addi a0, a0, -16*24
.endm

.macro StoreStates S00, S01, S02, S03, S04, \
                   S05, S06, S07, S08, S09, \
                   S10, S11, S12, S13, S14, \
                   S15, S16, S17, S18, S19, \
                   S20, S21, S22, S23, S24
    vse64.v \S00, (a0)
    addi a0, a0, 16
    vse64.v \S01, (a0)
    addi a0, a0, 16
    vse64.v \S02, (a0)
    addi a0, a0, 16
    vse64.v \S03, (a0)
    addi a0, a0, 16
    vse64.v \S04, (a0)
    addi a0, a0, 16
    vse64.v \S05, (a0)
    addi a0, a0, 16
    vse64.v \S06, (a0)
    addi a0, a0, 16
    vse64.v \S07, (a0)
    addi a0, a0, 16
    vse64.v \S08, (a0)
    addi a0, a0, 16
    vse64.v \S09, (a0)
    addi a0, a0, 16
    vse64.v \S10, (a0)
    addi a0, a0, 16
    vse64.v \S11, (a0)
    addi a0, a0, 16
    vse64.v \S12, (a0)
    addi a0, a0, 16
    vse64.v \S13, (a0)
    addi a0, a0, 16
    vse64.v \S14, (a0)
    addi a0, a0, 16
    vse64.v \S15, (a0)
    addi a0, a0, 16
    vse64.v \S16, (a0)
    addi a0, a0, 16
    vse64.v \S17, (a0)
    addi a0, a0, 16
    vse64.v \S18, (a0)
    addi a0, a0, 16
    vse64.v \S19, (a0)
    addi a0, a0, 16
    vse64.v \S20, (a0)
    addi a0, a0, 16
    vse64.v \S21, (a0)
    addi a0, a0, 16
    vse64.v \S22, (a0)
    addi a0, a0, 16
    vse64.v \S23, (a0)
    addi a0, a0, 16
    vse64.v \S24, (a0)
.endm

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

.macro ARoundInPlace    S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
                        S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
                        S20, S21, S22, S23, S24, T00, T01, T02, T03, T04
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
    li a4, 63
    vsrl.vx \T04, \T02, a4
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

    ChiOp \S05, \S10, \S11, \S07, \T02
    ChiOp \S06, \S11, \S07, \S08, \T03
    ChiOp \S07, \S07, \S08, \S09, \T02
    ChiOp \S08, \S08, \S09, \S10, \T03
    ChiOp \S09, \S09, \S10, \S11, \T02

    ChiOp \S10, \S15, \S16, \S12, \T03
    ChiOp \S11, \S16, \S12, \S13, \T02
    ChiOp \S12, \S12, \S13, \S14, \T03
    ChiOp \S13, \S13, \S14, \S15, \T02
    ChiOp \S14, \S14, \S15, \S16, \T03

    ChiOp \S15, \S20, \S21, \S17, \T02
    ChiOp \S16, \S21, \S17, \S18, \T03
    ChiOp \S17, \S17, \S18, \S19, \T02
    ChiOp \S18, \S18, \S19, \S20, \T03
    ChiOp \S19, \S19, \S20, \S21, \T02

    ChiOp \S20, \S00, \S01, \S22, \T03
    ChiOp \S21, \S01, \S22, \S23, \T02
    ChiOp \S22, \S22, \S23, \S24, \T03
    ChiOp \S23, \S23, \S24, \S00, \T02
    ChiOp \S24, \S24, \S00, \S01, \T03

    ChiOp \S00, \T00, \T01, \S02, \T02
    ChiOp \S01, \T01, \S02, \S03, \T03
    ChiOp \S02, \S02, \S03, \S04, \T02
    ChiOp \S03, \S03, \S04, \T00, \T03
    ChiOp \S04, \S04, \T00, \T01, \T02
    # Iota
    ld   a4, 0(a3)
    vxor.vx \S00, \S00, a4
    addi a3, a3, 8
    # Rho & Pi & Chi - end
.endm

.globl KeccakF1600_StatePermute_RV64V_2x
.align 2
KeccakF1600_StatePermute_RV64V_2x:

    li a1, 128
    vsetvli a1, a1, e64, m1, tu, mu

    LoadStates \
        v0,  v1,  v2,  v3,  v4,  v5,  v6,  v7,  v8,  v9,    \
        v10, v11, v12, v13, v14, v15, v16, v17, v18, v19,   \
        v20, v21, v22, v23, v24

    # a2: loop control variable i
    # a3: table index
    li a2, 24
    la a3, constants_keccak

loop:
    ARoundInPlace \
        v0,  v1,  v2,  v3,  v4,  v5,  v6,  v7,  v8,  v9,    \
        v10, v11, v12, v13, v14, v15, v16, v17, v18, v19,   \
        v20, v21, v22, v23, v24, v25, v26, v27, v28, v29
    addi a2, a2, -1
    bnez a2, loop

    StoreStates \
        v0,  v1,  v2,  v3,  v4,  v5,  v6,  v7,  v8,  v9,    \
        v10, v11, v12, v13, v14, v15, v16, v17, v18, v19,   \
        v20, v21, v22, v23, v24

    ret
