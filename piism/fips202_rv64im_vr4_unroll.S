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
        S00_s, S01_s, S02_s, S03_s, S04_s, S05_s, S06_s, S07_s, S08_s, S09_s, \
        S10_s, S11_s, S12_s, S13_s, S14_s, S15_s, S16_s, S17_s, S18_s, S19_s, \
        S20_s, S21_s, S22_s, S23_s, S24_s, T00_s, T01_s, T02_s, T03_s, T04_s
    xor \T01_s, \S02_s, \S07_s
    xor \T00_s, \S00_s, \S05_s
    xor \T01_s, \T01_s, \S12_s
    xor \T00_s, \T00_s, \S10_s
    xor \T01_s, \T01_s, \S17_s
    xor \T00_s, \T00_s, \S15_s
    xor \T01_s, \T01_s, \S22_s
    xor \T00_s, \T00_s, \S20_s
    slli \T03_s, \T01_s, 1
    srli \T02_s, \T01_s, 64-1
    xor  \T04_s, \S04_s, \S09_s
    xor  \T02_s, \T02_s, \T03_s
    xor  \T03_s, \S01_s, \S06_s
    xor  \T02_s, \T02_s, \T00_s
    xor \T03_s, \T03_s, \S11_s
    xor \T04_s, \T04_s, \S14_s
    xor \S01_s, \S01_s, \T02_s
    xor \T03_s, \T03_s, \S16_s
    sd  \S01_s, 8*18(sp)
    xor \S06_s, \S06_s, \T02_s
    xor \T04_s, \T04_s, \S19_s
    xor \S11_s, \S11_s, \T02_s
    xor \S16_s, \S16_s, \T02_s
    xor \T04_s, \T04_s, \S24_s
    slli \S01_s, \T04_s, 1
    xor \T03_s, \T03_s, \S21_s
    xor  \T01_s, \T01_s, \S01_s
    srli \S01_s, \T04_s, 63
    xor \S21_s, \S21_s, \T02_s
    xor  \T01_s, \T01_s, \S01_s
    xor \T02_s, \S03_s, \S08_s
    xor \S03_s, \S03_s, \T01_s
    xor \S08_s, \S08_s, \T01_s
    xor \T02_s, \T02_s, \S13_s
    xor \S13_s, \S13_s, \T01_s
    xor \T02_s, \T02_s, \S18_s
    slli \S01_s, \T00_s, 1
    srli \T00_s, \T00_s, 63
    xor \S18_s, \S18_s, \T01_s
    xor \T02_s, \T02_s, \S23_s
    xor  \T00_s, \T00_s, \S01_s
    xor \S23_s, \S23_s, \T01_s
    xor  \T00_s, \T00_s, \T02_s
    slli \T01_s, \T02_s, 1
    srli \T02_s, \T02_s, 63
    xor \S04_s, \S04_s, \T00_s
    xor \S09_s, \S09_s, \T00_s
    ld  \S01_s, 8*18(sp)
    xor  \T02_s, \T02_s, \T01_s
    xor \S14_s, \S14_s, \T00_s
    xor \S19_s, \S19_s, \T00_s
    xor  \T02_s, \T02_s, \T03_s
    xor \S24_s, \S24_s, \T00_s
    slli \T01_s, \T03_s, 1
    srli \T03_s, \T03_s, 63
    xor \S02_s, \S02_s, \T02_s
    xor \S07_s, \S07_s, \T02_s
    xor  \T03_s, \T03_s, \T01_s
    xor \S12_s, \S12_s, \T02_s
    xor \S17_s, \S17_s, \T02_s
    xor  \T03_s, \T03_s, \T04_s
    xor \S22_s, \S22_s, \T02_s
    xor \S05_s, \S05_s, \T03_s
    xor \S10_s, \S10_s, \T03_s
    xor \S15_s, \S15_s, \T03_s
    xor \S20_s, \S20_s, \T03_s
    xor \T00_s, \S00_s, \T03_s
    slli \T04_s, \S06_s, 44
    srli \T01_s, \S06_s, 20
    slli \T03_s, \S02_s, 62
    xor  \T01_s, \T01_s, \T04_s
    srli \S00_s, \S02_s, 2
    slli \T02_s, \S12_s, 43
    xor  \S00_s, \S00_s, \T03_s
    srli \S02_s, \S12_s, 21
    slli \T04_s, \S13_s, 25
    xor  \S02_s, \S02_s, \T02_s
    srli \S12_s, \S13_s, 39
    slli \T03_s, \S19_s, 8
    xor  \S12_s, \S12_s, \T04_s
    srli \S13_s, \S19_s, 56
    slli \T02_s, \S23_s, 56
    xor  \S13_s, \S13_s, \T03_s
    srli \S19_s, \S23_s, 8
    slli \T04_s, \S15_s, 41
    xor  \S19_s, \S19_s, \T02_s
    srli \S23_s, \S15_s, 23
    slli \T03_s, \S01_s, 1
    xor  \S23_s, \S23_s, \T04_s
    srli \S15_s, \S01_s, 63
    slli \T02_s, \S08_s, 55
    xor  \S15_s, \S15_s, \T03_s
    srli \S01_s, \S08_s, 9
    slli \T04_s, \S16_s, 45
    xor  \S01_s, \S01_s, \T02_s
    srli \S08_s, \S16_s, 19
    slli \T03_s, \S07_s, 6
    xor  \S08_s, \S08_s, \T04_s
    srli \S16_s, \S07_s, 58
    slli \T02_s, \S10_s, 3
    xor  \S16_s, \S16_s, \T03_s
    srli \S07_s, \S10_s, 61
    slli \T04_s, \S03_s, 28
    xor  \S07_s, \S07_s, \T02_s
    srli \S10_s, \S03_s, 36
    slli \T03_s, \S18_s, 21
    xor  \S10_s, \S10_s, \T04_s
    srli \S03_s, \S18_s, 43
    slli \T02_s, \S17_s, 15
    xor  \S03_s, \S03_s, \T03_s
    srli \S18_s, \S17_s, 49
    slli \T04_s, \S11_s, 10
    xor  \S18_s, \S18_s, \T02_s
    srli \S17_s, \S11_s, 54
    slli \T03_s, \S09_s, 20
    xor  \S17_s, \S17_s, \T04_s
    srli \S11_s, \S09_s, 44
    slli \T02_s, \S22_s, 61
    xor  \S11_s, \S11_s, \T03_s
    srli \S09_s, \S22_s, 3
    slli \T04_s, \S14_s, 39
    xor  \S09_s, \S09_s, \T02_s
    srli \S22_s, \S14_s, 25
    slli \T03_s, \S20_s, 18
    xor  \S22_s, \S22_s, \T04_s
    srli \S14_s, \S20_s, 46
    slli \T02_s, \S04_s, 27
    xor  \S14_s, \S14_s, \T03_s
    srli \S20_s, \S04_s, 37
    slli \T04_s, \S24_s, 14
    xor  \S20_s, \S20_s, \T02_s
    srli \S04_s, \S24_s, 50
    slli \T03_s, \S21_s, 2
    xor  \S04_s, \S04_s, \T04_s
    srli \S24_s, \S21_s, 62
    slli \T02_s, \S05_s, 36
    xor  \S24_s, \S24_s, \T03_s
    srli \S21_s, \S05_s, 28
    or  \T04_s, \S11_s, \S07_s
    xor  \S21_s, \S21_s, \T02_s
    xor \S05_s, \S10_s, \T04_s
    and \T03_s, \S07_s, \S08_s
    not \T02_s, \S09_s
    xor \S06_s, \S11_s, \T03_s
    or  \T02_s, \T02_s, \S08_s
    or  \T04_s, \S09_s, \S10_s
    xor \S07_s, \S07_s, \T02_s
    xor \S08_s, \S08_s, \T04_s
    and \T03_s, \S10_s, \S11_s
    or  \T04_s, \S16_s, \S12_s
    xor \S09_s, \S09_s, \T03_s
    xor \S10_s, \S15_s, \T04_s
    and \T03_s, \S12_s, \S13_s
    not \T02_s, \S13_s
    xor \S11_s, \S16_s, \T03_s
    and \T02_s, \T02_s, \S14_s
    not \T03_s, \S13_s
    xor \S12_s, \S12_s, \T02_s
    or  \T04_s, \S14_s, \S15_s
    and \T02_s, \S15_s, \S16_s
    xor \S13_s, \T03_s, \T04_s
    xor \S14_s, \S14_s, \T02_s
    and \T04_s, \S21_s, \S17_s
    or  \T03_s, \S17_s, \S18_s
    not \T02_s, \S18_s
    xor \S15_s, \S20_s, \T04_s
    or  \T02_s, \T02_s, \S19_s
    xor \S16_s, \S21_s, \T03_s
    xor \S17_s, \S17_s, \T02_s
    not \T03_s, \S18_s
    and \T04_s, \S19_s, \S20_s
    or  \T02_s, \S20_s, \S21_s
    xor \S18_s, \T03_s, \T04_s
    xor \S19_s, \S19_s, \T02_s
    not \T04_s, \S01_s
    not \T02_s, \S01_s
    and \T04_s, \T04_s, \S22_s
    or  \T03_s, \S22_s, \S23_s
    xor \S20_s, \S00_s, \T04_s
    xor \S21_s, \T02_s, \T03_s
    and \T04_s, \S23_s, \S24_s
    or  \T03_s, \S24_s, \S00_s
    xor \S22_s, \S22_s, \T04_s
    xor \S23_s, \S23_s, \T03_s
    and \T02_s, \S00_s, \S01_s
    or  \T04_s, \T01_s, \S02_s
    not \T03_s, \S02_s
    xor \S24_s, \S24_s, \T02_s
    or  \T03_s, \T03_s, \S03_s
    xor \S00_s, \T00_s, \T04_s
    xor \S01_s, \T01_s, \T03_s
    and \T02_s, \S03_s, \S04_s
    or  \T04_s, \S04_s, \T00_s
    xor \S02_s, \S02_s, \T02_s
    ld   \T02_s, 17*8(sp)
    and \T03_s, \T00_s, \T01_s
    xor \S03_s, \S03_s, \T04_s
    ld   \T01_s, 0(\T02_s)
    ld   \T04_s, 16*8(sp)
    addi \T02_s, \T02_s, 8
    xor \S04_s, \S04_s, \T03_s
    sd   \T02_s, 17*8(sp)
    addi \T04_s, \T04_s, -1
    xor  \S00_s, \S00_s, \T01_s
.endm

# 15*8(sp): a0
# 16*8(sp): loop control variable i
# 17*8(sp): table index
.globl KeccakF1600_StatePermute_RV64ASM
.align 2
KeccakF1600_StatePermute_RV64ASM:
    addi sp, sp, -8*19
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
    # ld a0, 16*8(sp)
    # addi a0, a0, -1
    bnez a0, loop

    ld a0, 15*8(sp)
    StoreStates \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10
    RestoreRegs
    addi sp, sp, 8*19
    ret
