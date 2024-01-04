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
    # lane complement: 1,2,8,12,17,20
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
.endm

.macro StoreStates S00, S01, S02, S03, S04, \
                   S05, S06, S07, S08, S09, \
                   S10, S11, S12, S13, S14, \
                   S15, S16, S17, S18, S19, \
                   S20, S21, S22, S23, S24
    # lane complement: 1,2,8,12,17,20
    not \S01, \S01
    not \S02, \S02
    not \S08, \S08
    not \S12, \S12
    not \S17, \S17
    not \S20, \S20
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

.macro ARoundInPlace \
        S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
        S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
        S20, S21, S22, S23, S24, T00, T01, T02, T03, T04
    # theta - start
    # C0 = S00 ^ S05 ^ S10 ^ S15 ^ S20
    xor \T00, \S00, \S05
    xor \T00, \T00, \S10
    xor \T00, \T00, \S15
    xor \T00, \T00, \S20
    # C2 = S02 ^ S07 ^ S12 ^ S17 ^ S22
    xor \T01, \S02, \S07
    xor \T01, \T01, \S12
    xor \T01, \T01, \S17
    xor \T01, \T01, \S22
    # D1 = C0 ^ ROL(C2, 1)
    slli \T03, \T01, 1
    srli \T02, \T01, 64-1
    xor  \T02, \T02, \T03
    xor  \T02, \T02, \T00 // T00=C0 T01=C2 T02=D1

    # C1 = S01 ^ S06 ^ S11 ^ S16 ^ S21
    xor \T03, \S01, \S06
    xor \T03, \T03, \S11
    xor \T03, \T03, \S16
    xor \T03, \T03, \S21
    # S06 ^= D1; S16 ^= D1; S01 ^= D1; S11 ^= D1; S21 ^= D1
    xor \S01, \S01, \T02
    xor \S06, \S06, \T02
    xor \S11, \S11, \T02
    xor \S16, \S16, \T02
    xor \S21, \S21, \T02

    # C4 = S04 ^ S09 ^ S14 ^ S19 ^ S24
    xor \T02, \S04, \S09
    xor \T02, \T02, \S14
    xor \T02, \T02, \S19
    xor \T02, \T02, \S24
    # D3 = C2 ^ ROL(C4, 1); C2 can be overwritten
    slli \T04, \T02, 1
    xor  \T01, \T01, \T04
    srli \T04, \T02, 63
    xor  \T01, \T01, \T04 // T00=C0 T01=D3 T03=C1 T02=C4

    # C3 = S03 ^ S08 ^ S13 ^ S18 ^ S23
    xor \T04, \S03, \S08
    xor \T04, \T04, \S13
    xor \T04, \T04, \S18
    xor \T04, \T04, \S23
    # S18 ^= D3; S03 ^= D3; S13 ^= D3; S23 ^= D3; S08 ^= D3
    xor \S03, \S03, \T01
    xor \S08, \S08, \T01
    xor \S13, \S13, \T01
    xor \S18, \S18, \T01
    xor \S23, \S23, \T01

    # D4 = C3 ^ ROL(C0, 1); C0 can be overwritten
    slli \T01, \T00, 1
    srli \T00, \T00, 64-1
    xor  \T00, \T00, \T01
    xor  \T00, \T00, \T04 // T00=D4 T03=C1 T02=C4 T04=C3
    # S24 ^= D4; S09 ^= D4; S19 ^= D4; S04 ^= D4; S14 ^= D4
    xor \S04, \S04, \T00
    xor \S09, \S09, \T00
    xor \S14, \S14, \T00
    xor \S19, \S19, \T00
    xor \S24, \S24, \T00

    # D2 = C1 ^ ROL(C3, 1)
    slli \T01, \T04, 1
    srli \T04, \T04, 64-1
    xor  \T04, \T04, \T01
    xor  \T04, \T04, \T03 // T03=C1 T02=C4 T04=D2
    # S12 ^= D2; S22 ^= D2; S07 ^= D2; S17 ^= D2; S02 ^= D2
    xor \S02, \S02, \T04
    xor \S07, \S07, \T04
    xor \S12, \S12, \T04
    xor \S17, \S17, \T04
    xor \S22, \S22, \T04

    # D0 = C4 ^ ROL(C1, 1)
    slli \T01, \T03, 1
    srli \T03, \T03, 64-1
    xor  \T03, \T03, \T01
    xor  \T03, \T03, \T02 // T03=D0
    # S00 ^= D0; S05 ^= D0; S10 ^= D0; S15 ^= D0; S20 ^= D0
    xor \S05, \S05, \T03
    xor \S10, \S10, \T03
    xor \S15, \S15, \T03
    xor \S20, \S20, \T03
    xor \T00, \S00, \T03
    # theta - end

    # Rho & Pi & Chi - start
    slli \T02, \S06, 44
    srli \T01, \S06, 64-44
    xor  \T01, \T01, \T02

    slli \T03, \S02, 62
    srli \S00, \S02, 64-62
    xor  \S00, \S00, \T03

    slli \T02, \S12, 43
    srli \S02, \S12, 64-43
    xor  \S02, \S02, \T02

    slli \T03, \S13, 25
    srli \S12, \S13, 64-25
    xor  \S12, \S12, \T03

    slli \T02, \S19, 8
    srli \S13, \S19, 64-8
    xor  \S13, \S13, \T02

    slli \T03, \S23, 56
    srli \S19, \S23, 64-56
    xor  \S19, \S19, \T03

    slli \T02, \S15, 41
    srli \S23, \S15, 64-41
    xor  \S23, \S23, \T02

    slli \T03, \S01, 1
    srli \S15, \S01, 64-1
    xor  \S15, \S15, \T03

    slli \T02, \S08, 55
    srli \S01, \S08, 64-55
    xor  \S01, \S01, \T02

    slli \T03, \S16, 45
    srli \S08, \S16, 64-45
    xor  \S08, \S08, \T03

    slli \T02, \S07, 6
    srli \S16, \S07, 64-6
    xor  \S16, \S16, \T02

    slli \T03, \S10, 3
    srli \S07, \S10, 64-3
    xor  \S07, \S07, \T03

    slli \T02, \S03, 28
    srli \S10, \S03, 64-28
    xor  \S10, \S10, \T02

    slli \T03, \S18, 21
    srli \S03, \S18, 64-21
    xor  \S03, \S03, \T03

    slli \T02, \S17, 15
    srli \S18, \S17, 64-15
    xor  \S18, \S18, \T02

    slli \T03, \S11, 10
    srli \S17, \S11, 64-10
    xor  \S17, \S17, \T03

    slli \T02, \S09, 20
    srli \S11, \S09, 64-20
    xor  \S11, \S11, \T02

    slli \T03, \S22, 61
    srli \S09, \S22, 64-61
    xor  \S09, \S09, \T03

    slli \T02, \S14, 39
    srli \S22, \S14, 64-39
    xor  \S22, \S22, \T02

    slli \T03, \S20, 18
    srli \S14, \S20, 64-18
    xor  \S14, \S14, \T03

    slli \T02, \S04, 27
    srli \S20, \S04, 64-27
    xor  \S20, \S20, \T02

    slli \T03, \S24, 14
    srli \S04, \S24, 64-14
    xor  \S04, \S04, \T03

    slli \T02, \S21, 2
    srli \S24, \S21, 64-2
    xor  \S24, \S24, \T02

    slli \T03, \S05, 36
    srli \S21, \S05, 64-36
    xor  \S21, \S21, \T03

    or  \T02, \S11, \S07
    xor \S05, \S10, \T02
    and \T03, \S07, \S08
    xor \S06, \S11, \T03
    not \T02, \S09
    or  \T02, \T02, \S08
    xor \S07, \S07, \T02
    or  \T03, \S09, \S10
    xor \S08, \S08, \T03
    and \T02, \S10, \S11
    xor \S09, \S09, \T02

    or  \T03, \S16, \S12
    xor \S10, \S15, \T03
    and \T02, \S12, \S13
    xor \S11, \S16, \T02
    not \T03, \S13
    and \T03, \T03, \S14
    xor \S12, \S12, \T03
    not \T03, \S13
    or  \T02, \S14, \S15
    xor \S13, \T03, \T02
    and \T03, \S15, \S16
    xor \S14, \S14, \T03

    and \T02, \S21, \S17
    xor \S15, \S20, \T02
    or  \T03, \S17, \S18
    xor \S16, \S21, \T03
    not \T02, \S18
    or  \T02, \T02, \S19
    xor \S17, \S17, \T02
    not \T02, \S18
    and \T03, \S19, \S20
    xor \S18, \T02, \T03
    or  \T02, \S20, \S21
    xor \S19, \S19, \T02

    not \T03, \S01
    and \T03, \T03, \S22
    xor \S20, \S00, \T03
    not \T03, \S01
    or  \T02, \S22, \S23
    xor \S21, \T03, \T02
    and \T03, \S23, \S24
    xor \S22, \S22, \T03
    or  \T02, \S24, \S00
    xor \S23, \S23, \T02
    and \T03, \S00, \S01
    xor \S24, \S24, \T03

    or  \T02, \T01, \S02
    xor \S00, \T00, \T02
    not \T03, \S02
    or  \T03, \T03, \S03
    xor \S01, \T01, \T03
    and \T02, \S03, \S04
    xor \S02, \S02, \T02
    or  \T03, \S04, \T00
    xor \S03, \S03, \T03
    and \T02, \T00, \T01
    xor \S04, \S04, \T02


    # Iota
    ld   \T04, 17*8(sp)
    ld   \T03, 0(\T04)
    xor  \S00, \S00, \T03
    addi \T04, \T04, 8
    sd   \T04, 17*8(sp)
    # Rho & Pi & Chi - end
.endm

# 15*8(sp): a0
# 16*8(sp): loop control variable i
# 17*8(sp): table index
.globl KeccakF1600_StatePermute_RV64ASM
.align 2
KeccakF1600_StatePermute_RV64ASM:
    addi sp, sp, -8*18
    SaveRegs
    sd a0, 15*8(sp)

    la a1, constants_keccak
    sd a1, 17*8(sp)

    LoadStates \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10

    li a0, 24
    
loop:
    sd a0, 16*8(sp)
    ARoundInPlace \
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
    addi sp, sp, 8*18
    ret
