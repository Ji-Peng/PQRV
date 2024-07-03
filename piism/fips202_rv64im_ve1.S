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

.macro XOR5 out, S00, S01, S02, S03, S04
    xor \out, \S00, \S01
    xor \out, \out, \S02
    xor \out, \out, \S03
    xor \out, \out, \S04
.endm

.macro XOR5_x2 \
    out_0, S00_0, S01_0, S02_0, S03_0, S04_0, \
    out_1, S00_1, S01_1, S02_1, S03_1, S04_1
    xor \out_0, \S00_0, \S01_0
    xor \out_1, \S00_1, \S01_1
    xor \out_0, \out_0, \S02_0
    xor \out_1, \out_1, \S02_1
    xor \out_0, \out_0, \S03_0
    xor \out_1, \out_1, \S03_1
    xor \out_0, \out_0, \S04_0
    xor \out_1, \out_1, \S04_1
.endm

.macro ROLn out, in, tmp, n
    slli \tmp, \in, \n
    srli \out, \in, 64-\n
    xor  \in,  \in, \in
.endm

.macro ROL1 out, in, tmp
    ROLn \out, \in, \tmp, 1
.endm

.macro EachXOR S00, S01, S02, S03, S04, D
    xor \S00, \S00, \D
    xor \S01, \S01, \D
    xor \S02, \S02, \D
    xor \S03, \S03, \D
    xor \S04, \S04, \D
.endm

.macro XOR5_EachXOR out, S00, S01, S02, S03, S04, D
    xor \out, \S00, \S01
    xor \S00, \S00, \D
    xor \S01, \S01, \D
    xor \out, \out, \S02
    xor \S02, \S02, \D
    xor \out, \out, \S03
    xor \S03, \S03, \D
    xor \out, \out, \S04
    xor \S04, \S04, \D
.endm

.macro ChiOp out, S00, S01, S02, T
    not \T, \S01
    and \T, \T, \S02
    xor \out, \T, \S00
.endm

.macro xoror out, S00, S01, S02, T
    or  \T, \S01, \S02
    xor \out, \S00, \T
.endm

.macro xornotor out, S00, S01, S02, T
    not \T, \S01
    or  \T, \T, \S02
    xor \out, \S00, \T
.endm

.macro xorand out, S00, S01, S02, T
    and \T, \S01, \S02
    xor \out, \S00, \T
.endm

.macro xorornot out, S00, S01, S02, T
    not \T, \S02
    or  \T, \T, \S01
    xor \out, \S00, \T
.endm

.macro xornotand out, S00, S01, S02, T
    not \T, \S01
    and \T, \T, \S02
    xor \out, \S00, \T
.endm

.macro notxoror out, S00, S01, S02, T, T0
    not \T0, \S00
    or  \T, \S01, \S02
    xor \out, \T0, \T
.endm

.macro notxorand out, S00, S01, S02, T, T0
    not \T0, \S00
    and \T, \S01, \S02
    xor \out, \T0, \T
.endm

.macro ARoundInPlace \
        S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
        S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
        S20, S21, S22, S23, S24, T00, T01, T02, T03, T04
    # theta - start
    # C0 = S00 ^ S05 ^ S10 ^ S15 ^ S20
    # C2 = S02 ^ S07 ^ S12 ^ S17 ^ S22
    XOR5_x2 \
        \T01, \S02, \S07, \S12, \S17, \S22, \
        \T00, \S00, \S05, \S10, \S15, \S20
    # D1 = C0 ^ ROL(C2, 1)
    ROL1 \T02, \T01, \T03
    xor  \T00, \T02, \T00

    # C1 = S01 ^ S06 ^ S11 ^ S16 ^ S21
    # S06 ^= D1; S16 ^= D1; S01 ^= D1; S11 ^= D1; S21 ^= D1
    # C4 = S04 ^ S09 ^ S14 ^ S19 ^ S24
    xor \T03, \S01, \S06
    xor \T04, \S04, \S09
    xor \S01, \S01, \T02
    xor \S06, \S06, \T02
    xor \T03, \T03, \S11
    xor \T04, \T04, \S14
    xor \S11, \S11, \T02
    xor \T03, \T03, \S16
    xor \T04, \T04, \S19
    xor \S16, \S16, \T02
    xor \T04, \T04, \S24
    xor \T03, \T03, \S21
    xor \S21, \S21, \T02
    // T00=C0 T01=C2 T03=C1 T04=C4
    
    # D3 = C2 ^ ROL(C4, 1); T01=C2 can be overwritten
    slli \T02, \T04, 1
    xor  \T01, \T01, \S24
    srli \S19, \T04, 63
    xor  \S16, \S16, \T03 // T00=C0 T01=D3 T03=C1 T04=C4
    
    # C3 = S03 ^ S08 ^ S13 ^ S18 ^ S23
    # S18 ^= D3; S03 ^= D3; S13 ^= D3; S23 ^= D3; S08 ^= D3
    XOR5_EachXOR \T02, \S03, \S08, \S13, \S18, \S23, \T01 // T00=C0 T03=C1 T04=C4 T02=C3

    # D4 = C3 ^ ROL(C0, 1); C0 can be overwritten
    ROL1 \T00, \T00, \T01
    xor  \T02, \T02, \T02
    # S24 ^= D4; S09 ^= D4; S19 ^= D4; S04 ^= D4; S14 ^= D4
    EachXOR \S04, \S09, \S14, \S19, \S24, \T00 // T03=C1 T04=C4 T02=C3

    # D2 = C1 ^ ROL(C3, 1)
    ROL1 \T02, \T02, \T01
    xor  \T02, \T02, \T03 // T03=C1 T04=C4 T02=D2
    # S12 ^= D2; S22 ^= D2; S07 ^= D2; S17 ^= D2; S02 ^= D2
    EachXOR \S02, \S07, \S12, \S17, \S22, \T02 // T03=C1 T04=C4

    # D0 = C4 ^ ROL(C1, 1)
    ROL1 \T03, \T03, \T01
    xor  \S03, \S03, \S03 // T03=D0
    # S00 ^= D0; S05 ^= D0; S10 ^= D0; S15 ^= D0; S20 ^= D0
    # EachXOR \S00, \S05, \S10, \S15, \S20, \T03
    xor \S05, \S05, \T03
    xor \S10, \S10, \T03
    xor \S15, \S15, \T03
    xor \S20, \S20, \T03
    xor \T00, \S00, \T03
    # theta - end

    # Rho & Pi & Chi - start
    ROLn \T01, \S06, \T04, 44
    ROLn \S00, \S02, \T03, 62
    ROLn \S02, \S12, \T04, 43
    ROLn \S12, \S13, \T03, 25
    ROLn \S13, \S19, \T04, 8
    ROLn \S19, \S23, \T03, 56
    ROLn \S23, \S15, \T04, 41
    ROLn \S15, \S01, \T03, 1
    ROLn \S01, \S08, \T04, 55
    ROLn \S08, \S16, \T03, 45
    ROLn \S16, \S07, \T04, 6
    ROLn \S07, \S10, \T03, 3
    ROLn \S10, \S03, \T04, 28
    ROLn \S03, \S18, \T03, 21
    ROLn \S18, \S17, \T04, 15
    ROLn \S17, \S11, \T03, 10
    ROLn \S11, \S09, \T04, 20
    ROLn \S09, \S22, \T03, 61
    ROLn \S22, \S14, \T04, 39
    ROLn \S14, \S20, \T03, 18
    ROLn \S20, \S04, \T04, 27
    ROLn \S04, \S24, \T03, 14
    ROLn \S24, \S21, \T04, 2
    ROLn \S21, \S05, \T03, 36

    xoror    \S05, \S10, \S11, \S07, \T04
    xorand   \S06, \S11, \S07, \S08, \T03
    xorornot \S07, \S07, \S08, \S09, \T04
    xoror    \S08, \S08, \S09, \S10, \T03
    xorand   \S09, \S09, \S10, \S11, \T04

    xoror       \S10, \S15, \S16, \S12, \T03
    xorand      \S11, \S16, \S12, \S13, \T04
    xornotand   \S12, \S12, \S13, \S14, \T03
    notxoror    \S13, \S13, \S14, \S15, \T04, \T03
    xorand      \S14, \S14, \S15, \S16, \T03

    xorand      \S15, \S20, \S21, \S17, \T04
    xoror       \S16, \S21, \S17, \S18, \T03
    xornotor    \S17, \S17, \S18, \S19, \T04
    notxorand   \S18, \S18, \S19, \S20, \T03, \T04
    xoror       \S19, \S19, \S20, \S21, \T04

    xornotand   \S20, \S00, \S01, \S22, \T03
    notxoror    \S21, \S01, \S22, \S23, \T04, \T03
    xorand      \S22, \S22, \S23, \S24, \T03
    xoror       \S23, \S23, \S24, \S00, \T04
    xorand      \S24, \S24, \S00, \S01, \T03

    xoror       \S00, \T00, \T01, \S02, \T04
    xornotor    \S01, \T01, \S02, \S03, \T03
    xorand      \S02, \S02, \S03, \S04, \T04
    xoror       \S03, \S03, \S04, \T00, \T03
    xorand      \S04, \S04, \T00, \T01, \T04

    # Iota
    ld   \T02, 17*8(sp)
    ld   \T03, 0(\T02)
    xor  \S00, \S00, \T03
    addi \T02, \T02, 8
    sd   \T02, 17*8(sp)
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
