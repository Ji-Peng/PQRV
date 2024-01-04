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

.macro ARoundInPlace    S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
                        S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
                        S20, S21, S22, S23, S24, T00, T01, T02, T03, T04
    # theta - start
    # C0 = S00 ^ S05 ^ S10 ^ S15 ^ S20
    vxor.vv \T00, \S00, \S05
    vxor.vv \T00, \T00, \S10
    vxor.vv \T00, \T00, \S15
    vxor.vv \T00, \T00, \S20
    # C2 = S02 ^ S07 ^ S12 ^ S17 ^ S22
    vxor.vv \T01, \S02, \S07
    vxor.vv \T01, \T01, \S12
    vxor.vv \T01, \T01, \S17
    vxor.vv \T01, \T01, \S22
    # T00=C0 T01=C2
    # D1 = C0 ^ ROL(C2, 1)
    li a4, 64-1
    vsll.vi \T03, \T01, 1
    vsrl.vx \T02, \T01, a4
    vxor.vv \T02, \T02, \T03
    vxor.vv  \T02, \T02, \T00
    # T00=C0 T01=C2 T02=D1

    # C1 = S01 ^ S06 ^ S11 ^ S16 ^ S21
    vxor.vv \T03, \S01, \S06
    vxor.vv \T03, \T03, \S11
    vxor.vv \T03, \T03, \S16
    vxor.vv \T03, \T03, \S21
    # T00=C0 T01=C2 T02=D1 T03=C1
    # S06 ^= D1; S16 ^= D1; S01 ^= D1; S11 ^= D1; S21 ^= D1
    vxor.vv \S01, \S01, \T02
    vxor.vv \S06, \S06, \T02
    vxor.vv \S11, \S11, \T02
    vxor.vv \S16, \S16, \T02
    vxor.vv \S21, \S21, \T02
    # T00=C0 T01=C2 T03=C1

    # C4 = S04 ^ S09 ^ S14 ^ S19 ^ S24
    vxor.vv \T02, \S04, \S09
    vxor.vv \T02, \T02, \S14
    vxor.vv \T02, \T02, \S19
    vxor.vv \T02, \T02, \S24
    # T00=C0 T01=C2 T03=C1 T02=C4
    # D3 = C2 ^ ROL(C4, 1); C2 can be overwritten
    vsll.vi \T04, \T02, 1
    vxor.vv \T01, \T01, \T04
    li a4, 63
    vsrl.vx \T04, \T02, a4
    vxor.vv \T01, \T01, \T04
    # T00=C0 T01=D3 T03=C1 T02=C4

    # C3 = S03 ^ S08 ^ S13 ^ S18 ^ S23
    vxor.vv \T04, \S03, \S08
    vxor.vv \T04, \T04, \S13
    vxor.vv \T04, \T04, \S18
    vxor.vv \T04, \T04, \S23
    # T00=C0 T01=D3 T03=C1 T02=C4 T04=C3
    # S18 ^= D3; S03 ^= D3; S13 ^= D3; S23 ^= D3; S08 ^= D3
    vxor.vv \S03, \S03, \T01
    vxor.vv \S08, \S08, \T01
    vxor.vv \S13, \S13, \T01
    vxor.vv \S18, \S18, \T01
    vxor.vv \S23, \S23, \T01
    # T00=C0 T03=C1 T02=C4 T04=C3

    # D4 = C3 ^ ROL(C0, 1); C0 can be overwritten
    li a4, 64-1
    vsll.vi \T01, \T00, 1
    vsrl.vx \T00, \T00, a4
    vxor.vv \T00, \T00, \T01
    vxor.vv \T00, \T00, \T04
    # T00=D4 T03=C1 T02=C4 T04=C3
    # S24 ^= D4; S09 ^= D4; S19 ^= D4; S04 ^= D4; S14 ^= D4
    vxor.vv \S04, \S04, \T00
    vxor.vv \S09, \S09, \T00
    vxor.vv \S14, \S14, \T00
    vxor.vv \S19, \S19, \T00
    vxor.vv \S24, \S24, \T00
    # T03=C1 T02=C4 T04=C3

    # D2 = C1 ^ ROL(C3, 1)
    li a4, 64-1
    vsll.vi \T01, \T04, 1
    vsrl.vx \T04, \T04, a4
    vxor.vv \T04, \T04, \T01
    vxor.vv  \T04, \T04, \T03
    # T03=C1 T02=C4 T04=D2
    # S12 ^= D2; S22 ^= D2; S07 ^= D2; S17 ^= D2; S02 ^= D2
    vxor.vv \S02, \S02, \T04
    vxor.vv \S07, \S07, \T04
    vxor.vv \S12, \S12, \T04
    vxor.vv \S17, \S17, \T04
    vxor.vv \S22, \S22, \T04
    # T03=C1 T02=C4

    # D0 = C4 ^ ROL(C1, 1)
    li a4, 64-1
    vsll.vi \T01, \T03, 1
    vsrl.vx \T03, \T03, a4
    vxor.vv \T03, \T03, \T01
    vxor.vv  \T03, \T03, \T02
    # T03=D0
    # S00 ^= D0; S05 ^= D0; S10 ^= D0; S15 ^= D0; S20 ^= D0
    # EachXOR \S00, \S05, \S10, \S15, \S20, \T03
    vxor.vv \S05, \S05, \T03
    vxor.vv \S10, \S10, \T03
    vxor.vv \S15, \S15, \T03
    vxor.vv \S20, \S20, \T03
    vxor.vv \T00, \S00, \T03
    # theta - end

    # Rho & Pi & Chi - start
    li a4, 44
    vsll.vx \T02, \S06, a4
    vsrl.vi \T01, \S06, 64-44
    vxor.vv \T01, \T01, \T02

    li a4, 62
    vsll.vx \T03, \S02, a4
    vsrl.vi \S00, \S02, 64-62
    vxor.vv \S00, \S00, \T03

    li a4, 43
    vsll.vx \T02, \S12, a4
    vsrl.vi \S02, \S12, 64-43
    vxor.vv \S02, \S02, \T02

    li a4, 64-25
    vsll.vi \T03, \S13, 25
    vsrl.vx \S12, \S13, a4
    vxor.vv \S12, \S12, \T03

    li a4, 64-8
    vsll.vi \T02, \S19, 8
    vsrl.vx \S13, \S19, a4
    vxor.vv \S13, \S13, \T02

    li a4, 56
    vsll.vx \T03, \S23, a4
    vsrl.vi \S19, \S23, 64-56
    vxor.vv \S19, \S19, \T03

    li a4, 41
    vsll.vx \T02, \S15, a4
    vsrl.vi \S23, \S15, 64-41
    vxor.vv \S23, \S23, \T02

    li a4, 64-1
    vsll.vi \T03, \S01, 1
    vsrl.vx \S15, \S01, a4
    vxor.vv \S15, \S15, \T03

    li a4, 55
    vsll.vx \T02, \S08, a4
    vsrl.vi \S01, \S08, 64-55
    vxor.vv \S01, \S01, \T02

    li a4, 45
    vsll.vx \T03, \S16, a4
    vsrl.vi \S08, \S16, 64-45
    vxor.vv \S08, \S08, \T03

    li a4, 64-6
    vsll.vi \T02, \S07, 6
    vsrl.vx \S16, \S07, a4
    vxor.vv \S16, \S16, \T02

    li a4, 64-3
    vsll.vi \T03, \S10, 3
    vsrl.vx \S07, \S10, a4
    vxor.vv \S07, \S07, \T03

    li a4, 64-28
    vsll.vi \T02, \S03, 28
    vsrl.vx \S10, \S03, a4
    vxor.vv \S10, \S10, \T02

    li a4, 64-21
    vsll.vi \T03, \S18, 21
    vsrl.vx \S03, \S18, a4
    vxor.vv \S03, \S03, \T03

    li a4, 64-15
    vsll.vi \T02, \S17, 15
    vsrl.vx \S18, \S17, a4
    vxor.vv \S18, \S18, \T02

    li a4, 64-10
    vsll.vi \T03, \S11, 10
    vsrl.vx \S17, \S11, a4
    vxor.vv \S17, \S17, \T03

    li a4, 64-20
    vsll.vi \T02, \S09, 20
    vsrl.vx \S11, \S09, a4
    vxor.vv \S11, \S11, \T02

    li a4, 61
    vsll.vx \T03, \S22, a4
    vsrl.vi \S09, \S22, 64-61
    vxor.vv \S09, \S09, \T03

    li a4, 39
    vsll.vx \T02, \S14, a4
    vsrl.vi \S22, \S14, 64-39
    vxor.vv \S22, \S22, \T02

    li a4, 64-18
    vsll.vi \T03, \S20, 18
    vsrl.vx \S14, \S20, a4
    vxor.vv \S14, \S14, \T03

    li a4, 64-27
    vsll.vi \T02, \S04, 27
    vsrl.vx \S20, \S04, a4
    vxor.vv \S20, \S20, \T02

    li a4, 64-14
    vsll.vi \T03, \S24, 14
    vsrl.vx \S04, \S24, a4
    vxor.vv \S04, \S04, \T03

    li a4, 64-2
    vsll.vi \T02, \S21, 2
    vsrl.vx \S24, \S21, a4
    vxor.vv \S24, \S24, \T02

    li a4, 36
    vsll.vx \T03, \S05, a4
    vsrl.vi \S21, \S05, 64-36
    vxor.vv \S21, \S21, \T03

    vor.vv \T02, \S11, \S07
    vxor.vv \S05, \S10, \T02
    vand.vv \T03, \S07, \S08
    vxor.vv \S06, \S11, \T03
    vnot.v \T02, \S09
    vor.vv  \T02, \T02, \S08
    vxor.vv \S07, \S07, \T02
    vor.vv \T03, \S09, \S10
    vxor.vv \S08, \S08, \T03
    vand.vv \T02, \S10, \S11
    vxor.vv \S09, \S09, \T02

    vor.vv \T03, \S16, \S12
    vxor.vv \S10, \S15, \T03
    vand.vv \T02, \S12, \S13
    vxor.vv \S11, \S16, \T02
    vnot.v \T03, \S13
    vand.vv \T03, \T03, \S14
    vxor.vv \S12, \S12, \T03
    vnot.v \T03, \S13
    vor.vv  \T02, \S14, \S15
    vxor.vv \S13, \T03, \T02
    vand.vv \T03, \S15, \S16
    vxor.vv \S14, \S14, \T03

    vand.vv \T02, \S21, \S17
    vxor.vv \S15, \S20, \T02
    vor.vv \T03, \S17, \S18
    vxor.vv \S16, \S21, \T03
    vnot.v \T02, \S18
    vor.vv  \T02, \T02, \S19
    vxor.vv \S17, \S17, \T02
    vnot.v \T02, \S18
    vand.vv \T03, \S19, \S20
    vxor.vv \S18, \T02, \T03
    vor.vv \T02, \S20, \S21
    vxor.vv \S19, \S19, \T02

    vnot.v \T03, \S01
    vand.vv \T03, \T03, \S22
    vxor.vv \S20, \S00, \T03
    vnot.v \T03, \S01
    vor.vv  \T02, \S22, \S23
    vxor.vv \S21, \T03, \T02
    vand.vv \T03, \S23, \S24
    vxor.vv \S22, \S22, \T03
    vor.vv \T02, \S24, \S00
    vxor.vv \S23, \S23, \T02
    vand.vv \T03, \S00, \S01
    vxor.vv \S24, \S24, \T03

    vor.vv \T02, \T01, \S02
    vxor.vv \S00, \T00, \T02
    vnot.v \T03, \S02
    vor.vv \T03, \T03, \S03
    vxor.vv \S01, \T01, \T03
    vand.vv \T02, \S03, \S04
    vxor.vv \S02, \S02, \T02
    vor.vv \T03, \S04, \T00
    vxor.vv \S03, \S03, \T03
    vand.vv \T02, \T00, \T01
    vxor.vv \S04, \S04, \T02

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

    # LoadStates
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

    # StoreStates
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

    ret
