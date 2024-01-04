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

.macro LoadStates S00_s, S01_s, S02_s, S03_s, S04_s, \
                  S05_s, S06_s, S07_s, S08_s, S09_s, \
                  S10_s, S11_s, S12_s, S13_s, S14_s, \
                  S15_s, S16_s, S17_s, S18_s, S19_s, \
                  S20_s, S21_s, S22_s, S23_s, S24_s
    # lane complement: 1,2,8,12,17,20
    ld \S00_s, 0*8(a0)
    ld \S01_s, 1*8(a0)
    ld \S02_s, 2*8(a0)
    ld \S03_s, 3*8(a0)
    ld \S04_s, 4*8(a0)
    ld \S05_s, 5*8(a0)
    ld \S06_s, 6*8(a0)
    ld \S07_s, 7*8(a0)
    ld \S08_s, 8*8(a0)
    ld \S09_s, 9*8(a0)
    ld \S10_s, 10*8(a0)
    ld \S11_s, 11*8(a0)
    ld \S12_s, 12*8(a0)
    ld \S13_s, 13*8(a0)
    ld \S14_s, 14*8(a0)
    ld \S15_s, 15*8(a0)
    ld \S16_s, 16*8(a0)
    ld \S17_s, 17*8(a0)
    not \S01_s, \S01_s
    not \S02_s, \S02_s
    not \S08_s, \S08_s
    not \S12_s, \S12_s
    not \S17_s, \S17_s
    ld \S18_s, 18*8(a0)
    ld \S19_s, 19*8(a0)
    ld \S20_s, 20*8(a0)
    ld \S21_s, 21*8(a0)
    ld \S22_s, 22*8(a0)
    ld \S23_s, 23*8(a0)
    not \S20_s, \S20_s
    ld \S24_s, 24*8(a0)
.endm

.macro StoreStates S00_s, S01_s, S02_s, S03_s, S04_s, \
                   S05_s, S06_s, S07_s, S08_s, S09_s, \
                   S10_s, S11_s, S12_s, S13_s, S14_s, \
                   S15_s, S16_s, S17_s, S18_s, S19_s, \
                   S20_s, S21_s, S22_s, S23_s, S24_s
    # lane complement: 1,2,8,12,17,20
    not \S01_s, \S01_s
    not \S02_s, \S02_s
    not \S08_s, \S08_s
    not \S12_s, \S12_s
    not \S17_s, \S17_s
    not \S20_s, \S20_s
    sd \S00_s, 0*8(a0)
    sd \S01_s, 1*8(a0)
    sd \S02_s, 2*8(a0)
    sd \S03_s, 3*8(a0)
    sd \S04_s, 4*8(a0)
    sd \S05_s, 5*8(a0)
    sd \S06_s, 6*8(a0)
    sd \S07_s, 7*8(a0)
    sd \S08_s, 8*8(a0)
    sd \S09_s, 9*8(a0)
    sd \S10_s, 10*8(a0)
    sd \S11_s, 11*8(a0)
    sd \S12_s, 12*8(a0)
    sd \S13_s, 13*8(a0)
    sd \S14_s, 14*8(a0)
    sd \S15_s, 15*8(a0)
    sd \S16_s, 16*8(a0)
    sd \S17_s, 17*8(a0)
    sd \S18_s, 18*8(a0)
    sd \S19_s, 19*8(a0)
    sd \S20_s, 20*8(a0)
    sd \S21_s, 21*8(a0)
    sd \S22_s, 22*8(a0)
    sd \S23_s, 23*8(a0)
    sd \S24_s, 24*8(a0)
.endm

.macro ARoundInPlace \
        S00_s, S01_s, S02_s, S03_s, S04_s, S05_s, S06_s, S07_s, S08_s, S09_s, \
        S10_s, S11_s, S12_s, S13_s, S14_s, S15_s, S16_s, S17_s, S18_s, S19_s, \
        S20_s, S21_s, S22_s, S23_s, S24_s, T00_s, T01_s, T02_s, T03_s, T04_s
    # theta - start
    # C0 = S00_s ^ S05_s ^ S10_s ^ S15_s ^ S20_s
    xor \T00_s, \S00_s, \S05_s
    xor \T00_s, \T00_s, \S10_s
    xor \T00_s, \T00_s, \S15_s
    xor \T00_s, \T00_s, \S20_s
    # C2 = S02_s ^ S07_s ^ S12_s ^ S17_s ^ S22_s
    xor \T01_s, \S02_s, \S07_s
    xor \T01_s, \T01_s, \S12_s
    xor \T01_s, \T01_s, \S17_s
    xor \T01_s, \T01_s, \S22_s
    # D1 = C0 ^ ROL(C2, 1)
    slli \T03_s, \T01_s, 1
    srli \T02_s, \T01_s, 64-1
    xor  \T02_s, \T02_s, \T03_s
    xor  \T02_s, \T02_s, \T00_s
    # C1 = S01_s ^ S06_s ^ S11_s ^ S16_s ^ S21_s
    xor \T03_s, \S01_s, \S06_s
    xor \T03_s, \T03_s, \S11_s
    xor \T03_s, \T03_s, \S16_s
    xor \T03_s, \T03_s, \S21_s
    # S06_s ^= D1; S16_s ^= D1; S01_s ^= D1; S11_s ^= D1; S21_s ^= D1
    xor \S01_s, \S01_s, \T02_s
    xor \S06_s, \S06_s, \T02_s
    xor \S11_s, \S11_s, \T02_s
    xor \S16_s, \S16_s, \T02_s
    xor \S21_s, \S21_s, \T02_s
    # C4 = S04_s ^ S09_s ^ S14_s ^ S19_s ^ S24_s
    xor \T02_s, \S04_s, \S09_s
    xor \T02_s, \T02_s, \S14_s
    xor \T02_s, \T02_s, \S19_s
    xor \T02_s, \T02_s, \S24_s
    # D3 = C2 ^ ROL(C4, 1); C2 can be overwritten
    slli \T04_s, \T02_s, 1
    xor  \T01_s, \T01_s, \T04_s
    srli \T04_s, \T02_s, 63
    xor  \T01_s, \T01_s, \T04_s
    # C3 = S03_s ^ S08_s ^ S13_s ^ S18_s ^ S23_s
    xor \T04_s, \S03_s, \S08_s
    xor \T04_s, \T04_s, \S13_s
    xor \T04_s, \T04_s, \S18_s
    xor \T04_s, \T04_s, \S23_s
    # S18_s ^= D3; S03_s ^= D3; S13_s ^= D3; S23_s ^= D3; S08_s ^= D3
    xor \S03_s, \S03_s, \T01_s
    xor \S08_s, \S08_s, \T01_s
    xor \S13_s, \S13_s, \T01_s
    xor \S18_s, \S18_s, \T01_s
    xor \S23_s, \S23_s, \T01_s
    # D4 = C3 ^ ROL(C0, 1); C0 can be overwritten
    slli \T01_s, \T00_s, 1
    srli \T00_s, \T00_s, 64-1
    xor  \T00_s, \T00_s, \T01_s
    xor  \T00_s, \T00_s, \T04_s
    # S24_s ^= D4; S09_s ^= D4; S19_s ^= D4; S04_s ^= D4; S14_s ^= D4
    xor \S04_s, \S04_s, \T00_s
    xor \S09_s, \S09_s, \T00_s
    xor \S14_s, \S14_s, \T00_s
    xor \S19_s, \S19_s, \T00_s
    xor \S24_s, \S24_s, \T00_s
    # D2 = C1 ^ ROL(C3, 1)
    slli \T01_s, \T04_s, 1
    srli \T04_s, \T04_s, 64-1
    xor  \T04_s, \T04_s, \T01_s
    xor  \T04_s, \T04_s, \T03_s
    # S12_s ^= D2; S22_s ^= D2; S07_s ^= D2; S17_s ^= D2; S02_s ^= D2
    xor \S02_s, \S02_s, \T04_s
    xor \S07_s, \S07_s, \T04_s
    xor \S12_s, \S12_s, \T04_s
    xor \S17_s, \S17_s, \T04_s
    xor \S22_s, \S22_s, \T04_s
    # D0 = C4 ^ ROL(C1, 1)
    slli \T01_s, \T03_s, 1
    srli \T03_s, \T03_s, 64-1
    xor  \T03_s, \T03_s, \T01_s
    xor  \T03_s, \T03_s, \T02_s
    # S00_s ^= D0; S05_s ^= D0; S10_s ^= D0; S15_s ^= D0; S20_s ^= D0
    xor \S05_s, \S05_s, \T03_s
    xor \S10_s, \S10_s, \T03_s
    xor \S15_s, \S15_s, \T03_s
    xor \S20_s, \S20_s, \T03_s
    xor \T00_s, \S00_s, \T03_s
    # theta - end
    # Rho & Pi & Chi - start
    slli \T02_s, \S06_s, 44
    srli \T01_s, \S06_s, 64-44
    xor  \T01_s, \T01_s, \T02_s
    slli \T03_s, \S02_s, 62
    srli \S00_s, \S02_s, 64-62
    xor  \S00_s, \S00_s, \T03_s
    slli \T02_s, \S12_s, 43
    srli \S02_s, \S12_s, 64-43
    xor  \S02_s, \S02_s, \T02_s
    slli \T03_s, \S13_s, 25
    srli \S12_s, \S13_s, 64-25
    xor  \S12_s, \S12_s, \T03_s
    slli \T02_s, \S19_s, 8
    srli \S13_s, \S19_s, 64-8
    xor  \S13_s, \S13_s, \T02_s
    slli \T03_s, \S23_s, 56
    srli \S19_s, \S23_s, 64-56
    xor  \S19_s, \S19_s, \T03_s
    slli \T02_s, \S15_s, 41
    srli \S23_s, \S15_s, 64-41
    xor  \S23_s, \S23_s, \T02_s
    slli \T03_s, \S01_s, 1
    srli \S15_s, \S01_s, 64-1
    xor  \S15_s, \S15_s, \T03_s
    slli \T02_s, \S08_s, 55
    srli \S01_s, \S08_s, 64-55
    xor  \S01_s, \S01_s, \T02_s
    slli \T03_s, \S16_s, 45
    srli \S08_s, \S16_s, 64-45
    xor  \S08_s, \S08_s, \T03_s
    slli \T02_s, \S07_s, 6
    srli \S16_s, \S07_s, 64-6
    xor  \S16_s, \S16_s, \T02_s
    slli \T03_s, \S10_s, 3
    srli \S07_s, \S10_s, 64-3
    xor  \S07_s, \S07_s, \T03_s
    slli \T02_s, \S03_s, 28
    srli \S10_s, \S03_s, 64-28
    xor  \S10_s, \S10_s, \T02_s
    slli \T03_s, \S18_s, 21
    srli \S03_s, \S18_s, 64-21
    xor  \S03_s, \S03_s, \T03_s
    slli \T02_s, \S17_s, 15
    srli \S18_s, \S17_s, 64-15
    xor  \S18_s, \S18_s, \T02_s
    slli \T03_s, \S11_s, 10
    srli \S17_s, \S11_s, 64-10
    xor  \S17_s, \S17_s, \T03_s
    slli \T02_s, \S09_s, 20
    srli \S11_s, \S09_s, 64-20
    xor  \S11_s, \S11_s, \T02_s
    slli \T03_s, \S22_s, 61
    srli \S09_s, \S22_s, 64-61
    xor  \S09_s, \S09_s, \T03_s
    slli \T02_s, \S14_s, 39
    srli \S22_s, \S14_s, 64-39
    xor  \S22_s, \S22_s, \T02_s
    slli \T03_s, \S20_s, 18
    srli \S14_s, \S20_s, 64-18
    xor  \S14_s, \S14_s, \T03_s
    slli \T02_s, \S04_s, 27
    srli \S20_s, \S04_s, 64-27
    xor  \S20_s, \S20_s, \T02_s
    slli \T03_s, \S24_s, 14
    srli \S04_s, \S24_s, 64-14
    xor  \S04_s, \S04_s, \T03_s
    slli \T02_s, \S21_s, 2
    srli \S24_s, \S21_s, 64-2
    xor  \S24_s, \S24_s, \T02_s
    slli \T03_s, \S05_s, 36
    srli \S21_s, \S05_s, 64-36
    xor  \S21_s, \S21_s, \T03_s
    # Chi
    or  \T02_s, \S11_s, \S07_s
    xor \S05_s, \S10_s, \T02_s
    and \T03_s, \S07_s, \S08_s
    xor \S06_s, \S11_s, \T03_s
    not \T02_s, \S09_s
    or  \T02_s, \T02_s, \S08_s
    xor \S07_s, \S07_s, \T02_s
    or  \T03_s, \S09_s, \S10_s
    xor \S08_s, \S08_s, \T03_s
    and \T02_s, \S10_s, \S11_s
    xor \S09_s, \S09_s, \T02_s
    or  \T03_s, \S16_s, \S12_s
    xor \S10_s, \S15_s, \T03_s
    and \T02_s, \S12_s, \S13_s
    xor \S11_s, \S16_s, \T02_s
    not \T03_s, \S13_s
    and \T03_s, \T03_s, \S14_s
    xor \S12_s, \S12_s, \T03_s
    not \T03_s, \S13_s
    or  \T02_s, \S14_s, \S15_s
    xor \S13_s, \T03_s, \T02_s
    and \T03_s, \S15_s, \S16_s
    xor \S14_s, \S14_s, \T03_s
    and \T02_s, \S21_s, \S17_s
    xor \S15_s, \S20_s, \T02_s
    or  \T03_s, \S17_s, \S18_s
    xor \S16_s, \S21_s, \T03_s
    not \T02_s, \S18_s
    or  \T02_s, \T02_s, \S19_s
    xor \S17_s, \S17_s, \T02_s
    not \T02_s, \S18_s
    and \T03_s, \S19_s, \S20_s
    xor \S18_s, \T02_s, \T03_s
    or  \T02_s, \S20_s, \S21_s
    xor \S19_s, \S19_s, \T02_s
    not \T03_s, \S01_s
    and \T03_s, \T03_s, \S22_s
    xor \S20_s, \S00_s, \T03_s
    not \T03_s, \S01_s
    or  \T02_s, \S22_s, \S23_s
    xor \S21_s, \T03_s, \T02_s
    and \T03_s, \S23_s, \S24_s
    xor \S22_s, \S22_s, \T03_s
    or  \T02_s, \S24_s, \S00_s
    xor \S23_s, \S23_s, \T02_s
    and \T03_s, \S00_s, \S01_s
    xor \S24_s, \S24_s, \T03_s
    or  \T02_s, \T01_s, \S02_s
    xor \S00_s, \T00_s, \T02_s
    not \T03_s, \S02_s
    or  \T03_s, \T03_s, \S03_s
    xor \S01_s, \T01_s, \T03_s
    and \T02_s, \S03_s, \S04_s
    xor \S02_s, \S02_s, \T02_s
    or  \T03_s, \S04_s, \T00_s
    xor \S03_s, \S03_s, \T03_s
    and \T02_s, \T00_s, \T01_s
    xor \S04_s, \S04_s, \T02_s
    # Iota
    ld   \T04_s, 17*8(sp)
    ld   \T03_s, 0(\T04_s)
    xor  \S00_s, \S00_s, \T03_s
    addi \T04_s, \T04_s, 8
    sd   \T04_s, 17*8(sp)
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
