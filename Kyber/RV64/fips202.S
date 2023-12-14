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

.equ R0Constant,  0x0000000000000001
.equ R1Constant,  0x0000000000008082
.equ R2Constant,  0x800000000000808a
.equ R3Constant,  0x8000000080008000
.equ R4Constant,  0x000000000000808b
.equ R5Constant,  0x0000000080000001
.equ R6Constant,  0x8000000080008081
.equ R7Constant,  0x8000000000008009
.equ R8Constant,  0x000000000000008a
.equ R9Constant,  0x0000000000000088
.equ R10Constant, 0x0000000080008009 
.equ R11Constant, 0x000000008000000a 
.equ R12Constant, 0x000000008000808b
.equ R13Constant, 0x800000000000008b
.equ R14Constant, 0x8000000000008089
.equ R15Constant, 0x8000000000008003
.equ R16Constant, 0x8000000000008002
.equ R17Constant, 0x8000000000000080
.equ R18Constant, 0x000000000000800a
.equ R19Constant, 0x800000008000000a
.equ R20Constant, 0x8000000080008081
.equ R21Constant, 0x8000000000008080
.equ R22Constant, 0x0000000080000001
.equ R23Constant, 0x8000000080008008

.macro SaveRegs
    sd s0,  0*8(sp)
    sd s1,  1*8(sp)
    sd s2,  2*8(sp)
    sd s3,  3*8(sp)
    sd s4,  4*8(sp)
    sd s5,  5*8(sp)
    sd s6,  6*8(sp)
    sd s7,  7*8(sp)
    sd s8,  8*8(sp)
    sd s9,  9*8(sp)
    sd s10, 10*8(sp)
    sd s11, 11*8(sp)
    sd gp,  12*8(sp)
    sd tp,  13*8(sp)
    sd ra,  14*8(sp)
.endm

.macro RestoreRegs
    ld s0,  0*8(sp)
    ld s1,  1*8(sp)
    ld s2,  2*8(sp)
    ld s3,  3*8(sp)
    ld s4,  4*8(sp)
    ld s5,  5*8(sp)
    ld s6,  6*8(sp)
    ld s7,  7*8(sp)
    ld s8,  8*8(sp)
    ld s9,  9*8(sp)
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
    ld \S18, 18*8(a0)
    ld \S19, 19*8(a0)
    ld \S20, 20*8(a0)
    ld \S21, 21*8(a0)
    ld \S22, 22*8(a0)
    ld \S23, 23*8(a0)
    ld \S24, 24*8(a0)
.endm

.macro StoreStates S00, S01, S02, S03, S04, \
                   S05, S06, S07, S08, S09, \
                   S10, S11, S12, S13, S14, \
                   S15, S16, S17, S18, S19, \
                   S20, S21, S22, S23, S24
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

.macro ROLn out, in, tmp, n
    slli \tmp, \in, \n
    srli \out, \in, 64-\n
    xor  \out, \out, \tmp
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

.macro ChiOp out, S00, S01, S02
    not \out, \S01
    and \out, \out, \S02
    xor \out, \out, \S00
.endm

.macro PiChiOp S00, S01, S02, S03, S04, T00, T01, T02, T03
    mv \T00, \S00
    ChiOp \S00, \T00, \S01, \S02
    mv \T01, \S03
    ChiOp \S03, \T01, \S04, \T00
    mv \T02, \S04
    ChiOp \S04, \T02, \T00, \S01
    mv \T00, \S01
    ChiOp \S01, \T00, \S02, \T01
    mv \T03, \S02
    ChiOp \S02, \T03, \T01, \T02
.endm

.macro ARound  S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
               S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
               S20, S21, S22, S23, S24, T00, T01, T02, T03, T04, Constant
    # theta - start
    # C0 = S00 ^ S05 ^ S10 ^ S15 ^ S20
    XOR5 \T00, \S00, \S05, \S10, \S15, \S20
    # C2 = S02 ^ S07 ^ S12 ^ S17 ^ S22
    XOR5 \T01, \S02, \S07, \S12, \S17, \S22 // T00=C0 T01=C2
    # D1 = C0 ^ ROL(C2, 1)
    ROL1 \T02, \T01, \T03
    xor  \T02, \T02, \T00 // T00=C0 T01=C2 T02=D1

    # C1 = S01 ^ S06 ^ S11 ^ S16 ^ S21
    XOR5 \T03, \S01, \S06, \S11, \S16, \S21 // T00=C0 T01=C2 T02=D1 T03=C1
    # S06 ^= D1; S16 ^= D1; S01 ^= D1; S11 ^= D1; S21 ^= D1
    EachXOR \S01, \S06, \S11, \S16, \S21, \T02 // T00=C0 T01=C2 T03=C1

    # C4 = S04 ^ S09 ^ S14 ^ S19 ^ S24
    XOR5 \T02, \S04, \S09, \S14, \S19, \S24 // T00=C0 T01=C2 T03=C1 T02=C4
    # D3 = C2 ^ ROL(C4, 1); C2 can be overwritten
    slli \T04, \T02, 1
    xor  \T01, \T01, \T04
    srli \T04, \T02, 63
    xor  \T01, \T01, \T04 // T00=C0 T01=D3 T03=C1 T02=C4

    # C3 = S03 ^ S08 ^ S13 ^ S18 ^ S23
    XOR5 \T04, \S03, \S08, \S13, \S18, \S23 // T00=C0 T01=D3 T03=C1 T02=C4 T04=C3
    # S18 ^= D3; S03 ^= D3; S13 ^= D3; S23 ^= D3; S08 ^= D3
    EachXOR \S03, \S08, \S13, \S18, \S23, \T01 // T00=C0 T03=C1 T02=C4 T04=C3

    # D4 = C3 ^ ROL(C0, 1); C0 can be overwritten
    ROL1 \T00, \T00, \T01
    xor  \T00, \T00, \T04 // T00=D4 T03=C1 T02=C4 T04=C3
    # S24 ^= D4; S09 ^= D4; S19 ^= D4; S04 ^= D4; S14 ^= D4
    EachXOR \S04, \S09, \S14, \S19, \S24, \T00 // T03=C1 T02=C4 T04=C3

    # D2 = C1 ^ ROL(C3, 1)
    ROL1 \T04, \T04, \T01
    xor  \T04, \T04, \T03 // T03=C1 T02=C4 T04=D2
    # S12 ^= D2; S22 ^= D2; S07 ^= D2; S17 ^= D2; S02 ^= D2
    EachXOR \S02, \S07, \S12, \S17, \S22, \T04 // T03=C1 T02=C4

    # D0 = C4 ^ ROL(C1, 1)
    ROL1 \T03, \T03, \T01
    xor  \T03, \T03, \T02 // T03=D0
    # S00 ^= D0; S05 ^= D0; S10 ^= D0; S15 ^= D0; S20 ^= D0
    EachXOR \S00, \S05, \S10, \S15, \S20, \T03
    # theta - end

    # Rho - start
    ROLn \S01, \S01, \T00, 1
    ROLn \S02, \S02, \T01, 62
    ROLn \S03, \S03, \T02, 28
    ROLn \S04, \S04, \T03, 27
    ROLn \S05, \S05, \T00, 36
    ROLn \S06, \S06, \T01, 44
    ROLn \S07, \S07, \T02, 6
    ROLn \S08, \S08, \T03, 55
    ROLn \S09, \S09, \T00, 20
    ROLn \S10, \S10, \T01, 3
    ROLn \S11, \S11, \T02, 10
    ROLn \S12, \S12, \T03, 43
    ROLn \S13, \S13, \T00, 25
    ROLn \S14, \S14, \T01, 39
    ROLn \S15, \S15, \T02, 41
    ROLn \S16, \S16, \T03, 45
    ROLn \S17, \S17, \T00, 15
    ROLn \S18, \S18, \T01, 21
    ROLn \S19, \S19, \T02, 8
    ROLn \S20, \S20, \T03, 18
    ROLn \S21, \S21, \T00, 2
    ROLn \S22, \S22, \T01, 61
    ROLn \S23, \S23, \T02, 56
    ROLn \S24, \S24, \T03, 14
    # Rho - end

    # Pi & Chi - start
    PiChiOp \S00, \S06, \S12, \S18, \S24, \T00, \T01, \T02, \T03
    PiChiOp \S03, \S09, \S10, \S16, \S22, \T00, \T01, \T02, \T03
    PiChiOp \S01, \S07, \S13, \S19, \S20, \T00, \T01, \T02, \T03
    PiChiOp \S04, \S05, \S11, \S17, \S23, \T00, \T01, \T02, \T03
    PiChiOp \S02, \S08, \S14, \S15, \S21, \T00, \T01, \T02, \T03
    # Pi & Chi - end

    # Iota
    li  \T00, \Constant
    xor \S00, \S00, \T00
.endm

.macro ARoundNoIota  S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
                     S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
                     S20, S21, S22, S23, S24, T00, T01, T02, T03, T04
    # theta - start
    # C0 = S00 ^ S05 ^ S10 ^ S15 ^ S20
    XOR5 \T00, \S00, \S05, \S10, \S15, \S20
    # C2 = S02 ^ S07 ^ S12 ^ S17 ^ S22
    XOR5 \T01, \S02, \S07, \S12, \S17, \S22 // T00=C0 T01=C2
    # D1 = C0 ^ ROL(C2, 1)
    ROL1 \T02, \T01, \T03
    xor  \T02, \T02, \T00 // T00=C0 T01=C2 T02=D1

    # C1 = S01 ^ S06 ^ S11 ^ S16 ^ S21
    XOR5 \T03, \S01, \S06, \S11, \S16, \S21 // T00=C0 T01=C2 T02=D1 T03=C1
    # S06 ^= D1; S16 ^= D1; S01 ^= D1; S11 ^= D1; S21 ^= D1
    EachXOR \S01, \S06, \S11, \S16, \S21, \T02 // T00=C0 T01=C2 T03=C1

    # C4 = S04 ^ S09 ^ S14 ^ S19 ^ S24
    XOR5 \T02, \S04, \S09, \S14, \S19, \S24 // T00=C0 T01=C2 T03=C1 T02=C4
    # D3 = C2 ^ ROL(C4, 1); C2 can be overwritten
    slli \T04, \T02, 1
    xor  \T01, \T01, \T04
    srli \T04, \T02, 63
    xor  \T01, \T01, \T04 // T00=C0 T01=D3 T03=C1 T02=C4

    # C3 = S03 ^ S08 ^ S13 ^ S18 ^ S23
    XOR5 \T04, \S03, \S08, \S13, \S18, \S23 // T00=C0 T01=D3 T03=C1 T02=C4 T04=C3
    # S18 ^= D3; S03 ^= D3; S13 ^= D3; S23 ^= D3; S08 ^= D3
    EachXOR \S03, \S08, \S13, \S18, \S23, \T01 // T00=C0 T03=C1 T02=C4 T04=C3

    # D4 = C3 ^ ROL(C0, 1); C0 can be overwritten
    ROL1 \T00, \T00, \T01
    xor  \T00, \T00, \T04 // T00=D4 T03=C1 T02=C4 T04=C3
    # S24 ^= D4; S09 ^= D4; S19 ^= D4; S04 ^= D4; S14 ^= D4
    EachXOR \S04, \S09, \S14, \S19, \S24, \T00 // T03=C1 T02=C4 T04=C3

    # D2 = C1 ^ ROL(C3, 1)
    ROL1 \T04, \T04, \T01
    xor  \T04, \T04, \T03 // T03=C1 T02=C4 T04=D2
    # S12 ^= D2; S22 ^= D2; S07 ^= D2; S17 ^= D2; S02 ^= D2
    EachXOR \S02, \S07, \S12, \S17, \S22, \T04 // T03=C1 T02=C4

    # D0 = C4 ^ ROL(C1, 1)
    ROL1 \T03, \T03, \T01
    xor  \T03, \T03, \T02 // T03=D0
    # S00 ^= D0; S05 ^= D0; S10 ^= D0; S15 ^= D0; S20 ^= D0
    EachXOR \S00, \S05, \S10, \S15, \S20, \T03
    # theta - end

    # Rho - start
    ROLn \S01, \S01, \T00, 1
    ROLn \S02, \S02, \T01, 62
    ROLn \S03, \S03, \T02, 28
    ROLn \S04, \S04, \T03, 27
    ROLn \S05, \S05, \T00, 36
    ROLn \S06, \S06, \T01, 44
    ROLn \S07, \S07, \T02, 6
    ROLn \S08, \S08, \T03, 55
    ROLn \S09, \S09, \T00, 20
    ROLn \S10, \S10, \T01, 3
    ROLn \S11, \S11, \T02, 10
    ROLn \S12, \S12, \T03, 43
    ROLn \S13, \S13, \T00, 25
    ROLn \S14, \S14, \T01, 39
    ROLn \S15, \S15, \T02, 41
    ROLn \S16, \S16, \T03, 45
    ROLn \S17, \S17, \T00, 15
    ROLn \S18, \S18, \T01, 21
    ROLn \S19, \S19, \T02, 8
    ROLn \S20, \S20, \T03, 18
    ROLn \S21, \S21, \T00, 2
    ROLn \S22, \S22, \T01, 61
    ROLn \S23, \S23, \T02, 56
    ROLn \S24, \S24, \T03, 14
    # Rho - end

    # Pi & Chi - start
    PiChiOp \S00, \S06, \S12, \S18, \S24, \T00, \T01, \T02, \T03
    PiChiOp \S03, \S09, \S10, \S16, \S22, \T00, \T01, \T02, \T03
    PiChiOp \S01, \S07, \S13, \S19, \S20, \T00, \T01, \T02, \T03
    PiChiOp \S04, \S05, \S11, \S17, \S23, \T00, \T01, \T02, \T03
    PiChiOp \S02, \S08, \S14, \S15, \S21, \T00, \T01, \T02, \T03
    # Pi & Chi - end
.endm

.macro Rounds24 S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
                S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
                S20, S21, S22, S23, S24, T00, T01, T02, T03, T04
    ARound  \S00, \S01, \S02, \S03, \S04, \S05, \S06, \S07, \S08, \S09, \
            \S10, \S11, \S12, \S13, \S14, \S15, \S16, \S17, \S18, \S19, \
            \S20, \S21, \S22, \S23, \S24, \T00, \T01, \T02, \T03, \T04, R0Constant
    ARound  \S00, \S06, \S12, \S18, \S24, \S03, \S09, \S10, \S16, \S22, \
            \S01, \S07, \S13, \S19, \S20, \S04, \S05, \S11, \S17, \S23, \
            \S02, \S08, \S14, \S15, \S21, \T00, \T01, \T02, \T03, \T04, R1Constant
    ARound  \S00, \S09, \S13, \S17, \S21, \S18, \S22, \S01, \S05, \S14, \
            \S06, \S10, \S19, \S23, \S02, \S24, \S03, \S07, \S11, \S15, \
            \S12, \S16, \S20, \S04, \S08, \T00, \T01, \T02, \T03, \T04, R2Constant
    ARound  \S00, \S22, \S19, \S11, \S08, \S17, \S14, \S06, \S03, \S20, \
            \S09, \S01, \S23, \S15, \S12, \S21, \S18, \S10, \S07, \S04, \
            \S13, \S05, \S02, \S24, \S16, \T00, \T01, \T02, \T03, \T04, R3Constant
    ARound  \S00, \S14, \S23, \S07, \S16, \S11, \S20, \S09, \S18, \S02, \
            \S22, \S06, \S15, \S04, \S13, \S08, \S17, \S01, \S10, \S24, \
            \S19, \S03, \S12, \S21, \S05, \T00, \T01, \T02, \T03, \T04, R4Constant
    ARound  \S00, \S20, \S15, \S10, \S05, \S07, \S02, \S22, \S17, \S12, \
            \S14, \S09, \S04, \S24, \S19, \S16, \S11, \S06, \S01, \S21, \
            \S23, \S18, \S13, \S08, \S03, \T00, \T01, \T02, \T03, \T04, R5Constant
    ARound  \S00, \S02, \S04, \S01, \S03, \S10, \S12, \S14, \S11, \S13, \
            \S20, \S22, \S24, \S21, \S23, \S05, \S07, \S09, \S06, \S08, \
            \S15, \S17, \S19, \S16, \S18, \T00, \T01, \T02, \T03, \T04, R6Constant
    ARound  \S00, \S12, \S24, \S06, \S18, \S01, \S13, \S20, \S07, \S19, \
            \S02, \S14, \S21, \S08, \S15, \S03, \S10, \S22, \S09, \S16, \
            \S04, \S11, \S23, \S05, \S17, \T00, \T01, \T02, \T03, \T04, R7Constant
    ARound  \S00, \S13, \S21, \S09, \S17, \S06, \S19, \S02, \S10, \S23, \
            \S12, \S20, \S08, \S16, \S04, \S18, \S01, \S14, \S22, \S05, \
            \S24, \S07, \S15, \S03, \S11, \T00, \T01, \T02, \T03, \T04, R8Constant
    ARound  \S00, \S19, \S08, \S22, \S11, \S09, \S23, \S12, \S01, \S15, \
            \S13, \S02, \S16, \S05, \S24, \S17, \S06, \S20, \S14, \S03, \
            \S21, \S10, \S04, \S18, \S07, \T00, \T01, \T02, \T03, \T04, R9Constant
    ARound  \S00, \S23, \S16, \S14, \S07, \S22, \S15, \S13, \S06, \S04, \
            \S19, \S12, \S05, \S03, \S21, \S11, \S09, \S02, \S20, \S18, \
            \S08, \S01, \S24, \S17, \S10, \T00, \T01, \T02, \T03, \T04, R10Constant
    ARound  \S00, \S15, \S05, \S20, \S10, \S14, \S04, \S19, \S09, \S24, \
            \S23, \S13, \S03, \S18, \S08, \S07, \S22, \S12, \S02, \S17, \
            \S16, \S06, \S21, \S11, \S01, \T00, \T01, \T02, \T03, \T04, R11Constant
    ARound  \S00, \S04, \S03, \S02, \S01, \S20, \S24, \S23, \S22, \S21, \
            \S15, \S19, \S18, \S17, \S16, \S10, \S14, \S13, \S12, \S11, \
            \S05, \S09, \S08, \S07, \S06, \T00, \T01, \T02, \T03, \T04, R12Constant
    ARound  \S00, \S24, \S18, \S12, \S06, \S02, \S21, \S15, \S14, \S08, \
            \S04, \S23, \S17, \S11, \S05, \S01, \S20, \S19, \S13, \S07, \
            \S03, \S22, \S16, \S10, \S09, \T00, \T01, \T02, \T03, \T04, R13Constant
    ARound  \S00, \S21, \S17, \S13, \S09, \S12, \S08, \S04, \S20, \S16, \
            \S24, \S15, \S11, \S07, \S03, \S06, \S02, \S23, \S19, \S10, \
            \S18, \S14, \S05, \S01, \S22, \T00, \T01, \T02, \T03, \T04, R14Constant
    ARound  \S00, \S08, \S11, \S19, \S22, \S13, \S16, \S24, \S02, \S05, \
            \S21, \S04, \S07, \S10, \S18, \S09, \S12, \S15, \S23, \S01, \
            \S17, \S20, \S03, \S06, \S14, \T00, \T01, \T02, \T03, \T04, R15Constant
    ARound  \S00, \S16, \S07, \S23, \S14, \S19, \S05, \S21, \S12, \S03, \
            \S08, \S24, \S10, \S01, \S17, \S22, \S13, \S04, \S15, \S06, \
            \S11, \S02, \S18, \S09, \S20, \T00, \T01, \T02, \T03, \T04, R16Constant
    ARound  \S00, \S05, \S10, \S15, \S20, \S23, \S03, \S08, \S13, \S18, \
            \S16, \S21, \S01, \S06, \S11, \S14, \S19, \S24, \S04, \S09, \
            \S07, \S12, \S17, \S22, \S02, \T00, \T01, \T02, \T03, \T04, R17Constant
    ARound  \S00, \S03, \S01, \S04, \S02, \S15, \S18, \S16, \S19, \S17, \
            \S05, \S08, \S06, \S09, \S07, \S20, \S23, \S21, \S24, \S22, \
            \S10, \S13, \S11, \S14, \S12, \T00, \T01, \T02, \T03, \T04, R18Constant
    ARound  \S00, \S18, \S06, \S24, \S12, \S04, \S17, \S05, \S23, \S11, \
            \S03, \S16, \S09, \S22, \S10, \S02, \S15, \S08, \S21, \S14, \
            \S01, \S19, \S07, \S20, \S13, \T00, \T01, \T02, \T03, \T04, R19Constant
    ARound  \S00, \S17, \S09, \S21, \S13, \S24, \S11, \S03, \S15, \S07, \
            \S18, \S05, \S22, \S14, \S01, \S12, \S04, \S16, \S08, \S20, \
            \S06, \S23, \S10, \S02, \S19, \T00, \T01, \T02, \T03, \T04, R20Constant
    ARound  \S00, \S11, \S22, \S08, \S19, \S21, \S07, \S18, \S04, \S10, \
            \S17, \S03, \S14, \S20, \S06, \S13, \S24, \S05, \S16, \S02, \
            \S09, \S15, \S01, \S12, \S23, \T00, \T01, \T02, \T03, \T04, R21Constant
    ARound  \S00, \S07, \S14, \S16, \S23, \S08, \S10, \S17, \S24, \S01, \
            \S11, \S18, \S20, \S02, \S09, \S19, \S21, \S03, \S05, \S12, \
            \S22, \S04, \S06, \S13, \S15, \T00, \T01, \T02, \T03, \T04, R22Constant
    ARound  \S00, \S10, \S20, \S05, \S15, \S16, \S01, \S11, \S21, \S06, \
            \S07, \S17, \S02, \S12, \S22, \S23, \S08, \S18, \S03, \S13, \
            \S14, \S24, \S09, \S19, \S04, \T00, \T01, \T02, \T03, \T04, R23Constant
.endm

.macro IotaForRounds12 S00, T00, T01
    ld   \T00, 17*8(sp)
    ld   \T01, 0(\T00)
    xor  \S00, \S00, \T01
    addi \T00, \T00, 8
    sd   \T00, 17*8(sp)
.endm

.macro Rounds12 S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
                S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
                S20, S21, S22, S23, S24, T00, T01, T02, T03, T04
    ARoundNoIota  \S00, \S01, \S02, \S03, \S04, \S05, \S06, \S07, \S08, \S09, \
            \S10, \S11, \S12, \S13, \S14, \S15, \S16, \S17, \S18, \S19, \
            \S20, \S21, \S22, \S23, \S24, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01

    ARoundNoIota  \S00, \S06, \S12, \S18, \S24, \S03, \S09, \S10, \S16, \S22, \
            \S01, \S07, \S13, \S19, \S20, \S04, \S05, \S11, \S17, \S23, \
            \S02, \S08, \S14, \S15, \S21, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01

    ARoundNoIota  \S00, \S09, \S13, \S17, \S21, \S18, \S22, \S01, \S05, \S14, \
            \S06, \S10, \S19, \S23, \S02, \S24, \S03, \S07, \S11, \S15, \
            \S12, \S16, \S20, \S04, \S08, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S22, \S19, \S11, \S08, \S17, \S14, \S06, \S03, \S20, \
            \S09, \S01, \S23, \S15, \S12, \S21, \S18, \S10, \S07, \S04, \
            \S13, \S05, \S02, \S24, \S16, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S14, \S23, \S07, \S16, \S11, \S20, \S09, \S18, \S02, \
            \S22, \S06, \S15, \S04, \S13, \S08, \S17, \S01, \S10, \S24, \
            \S19, \S03, \S12, \S21, \S05, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S20, \S15, \S10, \S05, \S07, \S02, \S22, \S17, \S12, \
            \S14, \S09, \S04, \S24, \S19, \S16, \S11, \S06, \S01, \S21, \
            \S23, \S18, \S13, \S08, \S03, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S02, \S04, \S01, \S03, \S10, \S12, \S14, \S11, \S13, \
            \S20, \S22, \S24, \S21, \S23, \S05, \S07, \S09, \S06, \S08, \
            \S15, \S17, \S19, \S16, \S18, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S12, \S24, \S06, \S18, \S01, \S13, \S20, \S07, \S19, \
            \S02, \S14, \S21, \S08, \S15, \S03, \S10, \S22, \S09, \S16, \
            \S04, \S11, \S23, \S05, \S17, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S13, \S21, \S09, \S17, \S06, \S19, \S02, \S10, \S23, \
            \S12, \S20, \S08, \S16, \S04, \S18, \S01, \S14, \S22, \S05, \
            \S24, \S07, \S15, \S03, \S11, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S19, \S08, \S22, \S11, \S09, \S23, \S12, \S01, \S15, \
            \S13, \S02, \S16, \S05, \S24, \S17, \S06, \S20, \S14, \S03, \
            \S21, \S10, \S04, \S18, \S07, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S23, \S16, \S14, \S07, \S22, \S15, \S13, \S06, \S04, \
            \S19, \S12, \S05, \S03, \S21, \S11, \S09, \S02, \S20, \S18, \
            \S08, \S01, \S24, \S17, \S10, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S15, \S05, \S20, \S10, \S14, \S04, \S19, \S09, \S24, \
            \S23, \S13, \S03, \S18, \S08, \S07, \S22, \S12, \S02, \S17, \
            \S16, \S06, \S21, \S11, \S01, \T00, \T01, \T02, \T03, \T04
    IotaForRounds12 \S00, \T00, \T01
.endm

.macro IotaForRounds6 S00, T00, T01
    ld   \T00, 17*8(sp)
    ld   \T01, 0(\T00)
    xor  \S00, \S00, \T01
    addi \T00, \T00, 8
    sd   \T00, 17*8(sp)
.endm

.macro Rounds6  S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
                S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
                S20, S21, S22, S23, S24, T00, T01, T02, T03, T04
    ARoundNoIota  \S00, \S01, \S02, \S03, \S04, \S05, \S06, \S07, \S08, \S09, \
            \S10, \S11, \S12, \S13, \S14, \S15, \S16, \S17, \S18, \S19, \
            \S20, \S21, \S22, \S23, \S24, \T00, \T01, \T02, \T03, \T04
    IotaForRounds6 \S00, \T00, \T01

    ARoundNoIota  \S00, \S06, \S12, \S18, \S24, \S03, \S09, \S10, \S16, \S22, \
            \S01, \S07, \S13, \S19, \S20, \S04, \S05, \S11, \S17, \S23, \
            \S02, \S08, \S14, \S15, \S21, \T00, \T01, \T02, \T03, \T04
    IotaForRounds6 \S00, \T00, \T01

    ARoundNoIota  \S00, \S09, \S13, \S17, \S21, \S18, \S22, \S01, \S05, \S14, \
            \S06, \S10, \S19, \S23, \S02, \S24, \S03, \S07, \S11, \S15, \
            \S12, \S16, \S20, \S04, \S08, \T00, \T01, \T02, \T03, \T04
    IotaForRounds6 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S22, \S19, \S11, \S08, \S17, \S14, \S06, \S03, \S20, \
            \S09, \S01, \S23, \S15, \S12, \S21, \S18, \S10, \S07, \S04, \
            \S13, \S05, \S02, \S24, \S16, \T00, \T01, \T02, \T03, \T04
    IotaForRounds6 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S14, \S23, \S07, \S16, \S11, \S20, \S09, \S18, \S02, \
            \S22, \S06, \S15, \S04, \S13, \S08, \S17, \S01, \S10, \S24, \
            \S19, \S03, \S12, \S21, \S05, \T00, \T01, \T02, \T03, \T04
    IotaForRounds6 \S00, \T00, \T01
    
    ARoundNoIota  \S00, \S20, \S15, \S10, \S05, \S07, \S02, \S22, \S17, \S12, \
            \S14, \S09, \S04, \S24, \S19, \S16, \S11, \S06, \S01, \S21, \
            \S23, \S18, \S13, \S08, \S03, \T00, \T01, \T02, \T03, \T04
    IotaForRounds6 \S00, \T00, \T01
.endm

.macro IotaForRounds3 S00, T00, T01
    ld   \T00, 17*8(sp)
    ld   \T01, 0(\T00)
    xor  \S00, \S00, \T01
    addi \T00, \T00, 8
    sd   \T00, 17*8(sp)
.endm

.macro Rounds3  S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
                S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, \
                S20, S21, S22, S23, S24, T00, T01, T02, T03, T04
    ARoundNoIota  \S00, \S01, \S02, \S03, \S04, \S05, \S06, \S07, \S08, \S09, \
            \S10, \S11, \S12, \S13, \S14, \S15, \S16, \S17, \S18, \S19, \
            \S20, \S21, \S22, \S23, \S24, \T00, \T01, \T02, \T03, \T04
    IotaForRounds3 \S00, \T00, \T01

    ARoundNoIota  \S00, \S06, \S12, \S18, \S24, \S03, \S09, \S10, \S16, \S22, \
            \S01, \S07, \S13, \S19, \S20, \S04, \S05, \S11, \S17, \S23, \
            \S02, \S08, \S14, \S15, \S21, \T00, \T01, \T02, \T03, \T04
    IotaForRounds3 \S00, \T00, \T01

    ARoundNoIota  \S00, \S09, \S13, \S17, \S21, \S18, \S22, \S01, \S05, \S14, \
            \S06, \S10, \S19, \S23, \S02, \S24, \S03, \S07, \S11, \S15, \
            \S12, \S16, \S20, \S04, \S08, \T00, \T01, \T02, \T03, \T04
    IotaForRounds3 \S00, \T00, \T01
.endm

.globl KeccakF1600_StatePermute_RV64_24r
.align 2
KeccakF1600_StatePermute_RV64_24r:
    addi sp, sp, -8*16
    SaveRegs
    LoadStates  a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
                t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
                s6, s7, s8, s9, s10
    sd a0, 15*8(sp)

    Rounds24    a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
                t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
                s6, s7, s8, s9, s10,s11,ra, gp, tp, a0

    ld a0, 15*8(sp)
    StoreStates a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
                t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
                s6, s7, s8, s9, s10
    RestoreRegs
    addi sp, sp, 8*16
    ret

.globl KeccakF1600_StatePermute_RV64_12r
.align 2
KeccakF1600_StatePermute_RV64_12r:
    addi sp, sp, -8*18
    SaveRegs
    sd a0, 15*8(sp)

    # 16*8(sp): loop control variable i
    # 17*8(sp): table index
    la a0, constants_keccak
    sd a0, 17*8(sp)
    li a0, 2
rounds12_loop_start:
    beqz a0, rounds12_loop_end
    addi a0, a0, -1
    sd a0, 16*8(sp)
    ld a0, 15*8(sp)

    LoadStates  a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
                t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
                s6, s7, s8, s9, s10
    Rounds12    a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
                t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
                s6, s7, s8, s9, s10,s11,ra, gp, tp, a0
    ld a0, 15*8(sp)
    StoreStates a1, a5, a4, a3, a2, s6, s10, s9, s8, s7, \
                s1, s5, s4, s3, s2, t3, s0, t6, t5, t4, \
                a6, t2, t1, t0, a7
    ld a0, 16*8(sp)
    j rounds12_loop_start

rounds12_loop_end:

    RestoreRegs
    addi sp, sp, 8*18
    ret

.globl KeccakF1600_StatePermute_RV64_6r
.align 2
KeccakF1600_StatePermute_RV64_6r:
    addi sp, sp, -8*18
    SaveRegs
    sd a0, 15*8(sp)

    # 16*8(sp): loop control variable i
    # 17*8(sp): table index
    la a0, constants_keccak
    sd a0, 17*8(sp)
    li a0, 4
rounds6_loop_start:
    beqz a0, rounds6_loop_end
    addi a0, a0, -1
    sd a0, 16*8(sp)
    ld a0, 15*8(sp)

    LoadStates  a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
                t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
                s6, s7, s8, s9, s10
    Rounds6     a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
                t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
                s6, s7, s8, s9, s10,s11,ra, gp, tp, a0
    ld a0, 15*8(sp)
    StoreStates a1, a3, a5, a2, a4, t3, t5, s0, t4, t6, \
                s6, s8, s10, s7, s9, a6, t0, t2, a7, t1, \
                s1, s3, s5, s2, s4
    ld a0, 16*8(sp)
    j rounds6_loop_start

rounds6_loop_end:

    RestoreRegs
    addi sp, sp, 8*18
    ret

.globl KeccakF1600_StatePermute_RV64_3r
.align 2
KeccakF1600_StatePermute_RV64_3r:
    addi sp, sp, -8*18
    SaveRegs
    sd a0, 15*8(sp)

    # 16*8(sp): loop control variable i
    # 17*8(sp): table index
    la a0, constants_keccak
    sd a0, 17*8(sp)
    li a0, 8
rounds3_loop_start:
    beqz a0, rounds3_loop_end
    addi a0, a0, -1
    sd a0, 16*8(sp)
    ld a0, 15*8(sp)

    LoadStates  a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
                t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
                s6, s7, s8, s9, s10
    Rounds3     a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
                t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
                s6, s7, s8, s9, s10,s11,ra, gp, tp, a0
    ld a0, 15*8(sp)
    StoreStates a1, s8, s5, t4, t1, s3, s0, a7, a4, s6, \
                t2, a2, s9, s1, t5, s7, s4, t3, t0, a5, \
                t6, a6, a3, s10, s2
    ld a0, 16*8(sp)
    j rounds3_loop_start

rounds3_loop_end:

    RestoreRegs
    addi sp, sp, 8*18
    ret
