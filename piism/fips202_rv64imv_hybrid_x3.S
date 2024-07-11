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
    # store states for vector impl
    # lane complement: 1,2,8,12,17,20
    not \S01_s, \S01_s
    vnot.v v1, v1
    not \S02_s, \S02_s
    vnot.v v2, v2
    not \S08_s, \S08_s
    vnot.v v8, v8
    not \S12_s, \S12_s
    vnot.v v12, v12
    not \S17_s, \S17_s
    vnot.v v17, v17
    not \S20_s, \S20_s
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
        S00_v, S01_v, S02_v, S03_v, S04_v, S05_v, S06_v, S07_v, S08_v, S09_v, \
        S10_v, S11_v, S12_v, S13_v, S14_v, S15_v, S16_v, S17_v, S18_v, S19_v, \
        S20_v, S21_v, S22_v, S23_v, S24_v, T00_v, T01_v, T02_v, T03_v, T04_v, \
        T05_v, T06_v, \
        S00_s, S01_s, S02_s, S03_s, S04_s, S05_s, S06_s, S07_s, S08_s, S09_s, \
        S10_s, S11_s, S12_s, S13_s, S14_s, S15_s, S16_s, S17_s, S18_s, S19_s, \
        S20_s, S21_s, S22_s, S23_s, S24_s, T00_s, T01_s, T02_s, T03_s, T04_s
xor \T01_s, \S02_s, \S07_s;                            vxor.vv \T00_v, \S01_v, \S06_v
xor \T00_s, \S00_s, \S05_s;                            vxor.vv \T01_v, \S04_v, \S09_v
xor \T01_s, \T01_s, \S12_s;                            vxor.vv \T02_v, \S03_v, \S08_v
xor \T00_s, \T00_s, \S10_s; sd \S05_s, 8*19(sp);       vxor.vv \T00_v, \T00_v, \S11_v
xor \T01_s, \T01_s, \S17_s;                            vxor.vv \T01_v, \T01_v, \S14_v
xor \T00_s, \T00_s, \S15_s;                            vxor.vv \T02_v, \T02_v, \S13_v
xor \T01_s, \T01_s, \S22_s;                            vxor.vv \T00_v, \T00_v, \S16_v
xor \T00_s, \T00_s, \S20_s;                            vxor.vv \T01_v, \T01_v, \S19_v
slli \T03_s, \T01_s, 1;                                vxor.vv \T02_v, \T02_v, \S18_v
srli \T02_s, \T01_s, 64-1;                             vxor.vv \T00_v, \T00_v, \S21_v
xor  \T04_s, \S04_s, \S09_s; sd  \S00_s, 8*18(sp);     vxor.vv \T01_v, \T01_v, \S24_v
xor  \T02_s, \T02_s, \T03_s;                           vxor.vv \T02_v, \T02_v, \S23_v;     li \S05_s, 64-1
xor  \T03_s, \S01_s, \S06_s;                           vsll.vi \T05_v, \T00_v, 1
xor  \T02_s, \T02_s, \T00_s;                           vsll.vi \T06_v, \T02_v, 1
xor \T03_s, \T03_s, \S11_s;                            vsrl.vx \T03_v, \T00_v, \S05_s
xor \T04_s, \T04_s, \S14_s;                            vsrl.vx \T04_v, \T02_v, \S05_s
xor \S01_s, \S01_s, \T02_s;                            vxor.vv \T03_v, \T03_v, \T05_v
xor \T03_s, \T03_s, \S16_s;                            vxor.vv \T04_v, \T04_v, \T06_v
xor \S06_s, \S06_s, \T02_s;                            vxor.vv \T03_v, \T03_v, \T01_v
xor \T04_s, \T04_s, \S19_s;                            vxor.vv \T04_v, \T04_v, \T00_v
xor \S11_s, \S11_s, \T02_s;                            vxor.vv \T05_v, \S00_v, \S05_v
xor \S16_s, \S16_s, \T02_s;                            vxor.vv \T06_v, \S02_v, \S07_v
xor \T04_s, \T04_s, \S24_s;                            vxor.vv \T05_v, \T05_v, \S10_v
slli \S00_s, \T04_s, 1;                                vxor.vv \T06_v, \T06_v, \S12_v
xor \T03_s, \T03_s, \S21_s;                            vxor.vv \T05_v, \T05_v, \S15_v
xor  \T01_s, \T01_s, \S00_s;                           vxor.vv \T06_v, \T06_v, \S17_v
srli \S00_s, \T04_s, 63;                               vxor.vv \T05_v, \T05_v, \S20_v
xor \S21_s, \S21_s, \T02_s;                            vxor.vv \T06_v, \T06_v, \S22_v
xor  \T01_s, \T01_s, \S00_s;                           vxor.vv \S00_v, \S00_v, \T03_v
xor \T02_s, \S03_s, \S08_s;                            vxor.vv \S05_v, \S05_v, \T03_v
xor \S03_s, \S03_s, \T01_s;                            vxor.vv \S10_v, \S10_v, \T03_v
xor \S08_s, \S08_s, \T01_s;                            vxor.vv \S15_v, \S15_v, \T03_v
xor \T02_s, \T02_s, \S13_s;                            vxor.vv \S20_v, \S20_v, \T03_v
xor \S13_s, \S13_s, \T01_s;                            vxor.vv \S02_v, \S02_v, \T04_v
xor \T02_s, \T02_s, \S18_s;                            vxor.vv \S07_v, \S07_v, \T04_v
slli \S00_s, \T00_s, 1;                                vxor.vv \S12_v, \S12_v, \T04_v
srli \T00_s, \T00_s, 63;                               vsll.vi \T03_v, \T01_v, 1
xor \S18_s, \S18_s, \T01_s;                            vsrl.vx \T00_v, \T01_v, \S05_s
xor \T02_s, \T02_s, \S23_s;                            vxor.vv \S17_v, \S17_v, \T04_v
xor  \T00_s, \T00_s, \S00_s;                           vxor.vv \S22_v, \S22_v, \T04_v
xor \S23_s, \S23_s, \T01_s;                            vxor.vv \T00_v, \T00_v, \T03_v
xor  \T00_s, \T00_s, \T02_s;                           vxor.vv \T00_v, \T00_v, \T06_v
slli \T01_s, \T02_s, 1;                                vxor.vv \S03_v, \S03_v, \T00_v
srli \T02_s, \T02_s, 63;                               vxor.vv \S08_v, \S08_v, \T00_v
xor \S04_s, \S04_s, \T00_s;                            vxor.vv \S13_v, \S13_v, \T00_v
xor \S09_s, \S09_s, \T00_s;                            vxor.vv \S18_v, \S18_v, \T00_v
xor  \T02_s, \T02_s, \T01_s;                           vxor.vv \S23_v, \S23_v, \T00_v;     li \S05_s, 64-1
xor \S14_s, \S14_s, \T00_s;                            vsll.vi \T00_v, \T06_v, 1
xor \S19_s, \S19_s, \T00_s;                            vsll.vi \T03_v, \T05_v, 1
xor  \T02_s, \T02_s, \T03_s;                           vsrl.vx \T01_v, \T06_v, \S05_s
xor \S24_s, \S24_s, \T00_s;                            vsrl.vx \T04_v, \T05_v, \S05_s
slli \T01_s, \T03_s, 1;                                vxor.vv \T01_v, \T01_v, \T00_v
srli \T03_s, \T03_s, 63;                               vxor.vv \T04_v, \T04_v, \T03_v
xor \S02_s, \S02_s, \T02_s;                            vxor.vv \T01_v, \T01_v, \T05_v
xor \S07_s, \S07_s, \T02_s; ld \S05_s, 8*19(sp);       vxor.vv \T04_v, \T04_v, \T02_v
xor  \T03_s, \T03_s, \T01_s;                           vxor.vv \S01_v, \S01_v, \T01_v
xor \S12_s, \S12_s, \T02_s;                            vxor.vv \S06_v, \S06_v, \T01_v
xor \S17_s, \S17_s, \T02_s; ld  \S00_s, 8*18(sp);      vxor.vv \S11_v, \S11_v, \T01_v
xor  \T03_s, \T03_s, \T04_s;                           vxor.vv \S16_v, \S16_v, \T01_v
xor \S22_s, \S22_s, \T02_s;                            vxor.vv \S21_v, \S21_v, \T01_v
xor \S05_s, \S05_s, \T03_s;                            vxor.vv \S04_v, \S04_v, \T04_v
xor \S10_s, \S10_s, \T03_s;                            vxor.vv \S09_v, \S09_v, \T04_v
xor \S15_s, \S15_s, \T03_s;                            vxor.vv \S14_v, \S14_v, \T04_v
xor \S20_s, \S20_s, \T03_s;                            vxor.vv \S19_v, \S19_v, \T04_v
xor \T00_s, \S00_s, \T03_s;                            vxor.vv \S24_v, \S24_v, \T04_v
slli \T04_s, \S06_s, 44; sd \T00_s, 8*18(sp);          vmv.v.v \T00_v, \S00_v;             li \T00_s, 44
srli \T01_s, \S06_s, 20;                               vsrl.vi \T01_v, \S06_v, 20
slli \T03_s, \S02_s, 62;                               vsll.vx \T02_v, \S06_v, \T00_s;     li \T00_s, 62
xor  \T01_s, \T01_s, \T04_s;                           vsrl.vi \S00_v, \S02_v, 2
srli \S00_s, \S02_s, 2;                                vsll.vx \T03_v, \S02_v, \T00_s
slli \T02_s, \S12_s, 43;                               vxor.vv \T01_v, \T01_v, \T02_v
xor  \S00_s, \S00_s, \T03_s;                           vxor.vv \S00_v, \S00_v, \T03_v;     li \T00_s, 43
srli \S02_s, \S12_s, 21;                               vsrl.vi \S02_v, \S12_v, 21
slli \T04_s, \S13_s, 25;                               vsll.vx \T02_v, \S12_v, \T00_s;     li \T00_s, 39
xor  \S02_s, \S02_s, \T02_s;                           vsll.vi \T03_v, \S13_v, 25
srli \S12_s, \S13_s, 39;                               vsrl.vx \S12_v, \S13_v, \T00_s
slli \T03_s, \S19_s, 8;                                vxor.vv \S02_v, \S02_v, \T02_v
xor  \S12_s, \S12_s, \T04_s;                           vxor.vv \S12_v, \S12_v, \T03_v;     li \T00_s, 56
srli \S13_s, \S19_s, 56;                               vsll.vi \T02_v, \S19_v, 8
slli \T02_s, \S23_s, 56;                               vsrl.vx \S13_v, \S19_v, \T00_s;     li \T00_s, 56
xor  \S13_s, \S13_s, \T03_s;                           vsrl.vi \S19_v, \S23_v, 8
srli \S19_s, \S23_s, 8;                                vsll.vx \T03_v, \S23_v, \T00_s
slli \T04_s, \S15_s, 41;                               vxor.vv \S13_v, \S13_v, \T02_v
xor  \S19_s, \S19_s, \T02_s;                           vxor.vv \S19_v, \S19_v, \T03_v;     li \T00_s, 41
srli \S23_s, \S15_s, 23;                               vsrl.vi \S23_v, \S15_v, 23
slli \T03_s, \S01_s, 1;                                vsll.vx \T02_v, \S15_v, \T00_s;     li \T00_s, 63
xor  \S23_s, \S23_s, \T04_s;                           vsll.vi \T03_v, \S01_v, 1
srli \S15_s, \S01_s, 63;                               vsrl.vx \S15_v, \S01_v, \T00_s
slli \T02_s, \S08_s, 55;                               vxor.vv \S23_v, \S23_v, \T02_v
xor  \S15_s, \S15_s, \T03_s;                           vxor.vv \S15_v, \S15_v, \T03_v;     li \T00_s, 55
srli \S01_s, \S08_s, 9;                                vsrl.vi \S01_v, \S08_v, 9
slli \T04_s, \S16_s, 45;                               vsll.vx \T02_v, \S08_v, \T00_s;     li \T00_s, 45
xor  \S01_s, \S01_s, \T02_s;                           vsrl.vi \S08_v, \S16_v, 19
srli \S08_s, \S16_s, 19;                               vsll.vx \T03_v, \S16_v, \T00_s
slli \T03_s, \S07_s, 6;                                vxor.vv \S01_v, \S01_v, \T02_v
xor  \S08_s, \S08_s, \T04_s;                           vxor.vv \S08_v, \S08_v, \T03_v;     li \T00_s, 58
srli \S16_s, \S07_s, 58;                               vsll.vi \T02_v, \S07_v, 6
slli \T02_s, \S10_s, 3;                                vsrl.vx \S16_v, \S07_v, \T00_s;     li \T00_s, 61
xor  \S16_s, \S16_s, \T03_s;                           vsll.vi \T03_v, \S10_v, 3
srli \S07_s, \S10_s, 61;                               vsrl.vx \S07_v, \S10_v, \T00_s
slli \T04_s, \S03_s, 28;                               vxor.vv \S16_v, \S16_v, \T02_v
xor  \S07_s, \S07_s, \T02_s;                           vxor.vv \S07_v, \S07_v, \T03_v;     li \T00_s, 36
srli \S10_s, \S03_s, 36;                               vsll.vi \T02_v, \S03_v, 28
slli \T03_s, \S18_s, 21;                               vsrl.vx \S10_v, \S03_v, \T00_s;     li \T00_s, 43
xor  \S10_s, \S10_s, \T04_s;                           vsll.vi \T03_v, \S18_v, 21
srli \S03_s, \S18_s, 43;                               vsrl.vx \S03_v, \S18_v, \T00_s
slli \T02_s, \S17_s, 15;                               vxor.vv \S10_v, \S10_v, \T02_v
xor  \S03_s, \S03_s, \T03_s;                           vxor.vv \S03_v, \S03_v, \T03_v;     li \T00_s, 49
srli \S18_s, \S17_s, 49;                               vsll.vi \T02_v, \S17_v, 15
slli \T04_s, \S11_s, 10;                               vsrl.vx \S18_v, \S17_v, \T00_s;     li \T00_s, 54
xor  \S18_s, \S18_s, \T02_s;                           vsll.vi \T03_v, \S11_v, 10
srli \S17_s, \S11_s, 54;                               vsrl.vx \S17_v, \S11_v, \T00_s
slli \T03_s, \S09_s, 20;                               vxor.vv \S18_v, \S18_v, \T02_v
xor  \S17_s, \S17_s, \T04_s;                           vxor.vv \S17_v, \S17_v, \T03_v;     li \T00_s, 44
srli \S11_s, \S09_s, 44;                               vsll.vi \T02_v, \S09_v, 20
slli \T02_s, \S22_s, 61;                               vsrl.vx \S11_v, \S09_v, \T00_s;     li \T00_s, 61
xor  \S11_s, \S11_s, \T03_s;                           vsrl.vi \S09_v, \S22_v, 3
srli \S09_s, \S22_s, 3;                                vsll.vx \T03_v, \S22_v, \T00_s
slli \T04_s, \S14_s, 39;                               vxor.vv \S11_v, \S11_v, \T02_v
xor  \S09_s, \S09_s, \T02_s;                           vxor.vv \S09_v, \S09_v, \T03_v;     li \T00_s, 39
srli \S22_s, \S14_s, 25;                               vsrl.vi \S22_v, \S14_v, 25
slli \T03_s, \S20_s, 18;                               vsll.vx \T02_v, \S14_v, \T00_s;     li \T00_s, 46
xor  \S22_s, \S22_s, \T04_s;                           vsll.vi \T03_v, \S20_v, 18
srli \S14_s, \S20_s, 46;                               vsrl.vx \S14_v, \S20_v, \T00_s
slli \T02_s, \S04_s, 27;                               vxor.vv \S22_v, \S22_v, \T02_v
xor  \S14_s, \S14_s, \T03_s;                           vxor.vv \S14_v, \S14_v, \T03_v;     li \T00_s, 37
srli \S20_s, \S04_s, 37;                               vsll.vi \T02_v, \S04_v, 27
slli \T04_s, \S24_s, 14;                               vsrl.vx \S20_v, \S04_v, \T00_s;     li \T00_s, 50
xor  \S20_s, \S20_s, \T02_s;                           vsll.vi \T03_v, \S24_v, 14
srli \S04_s, \S24_s, 50;                               vsrl.vx \S04_v, \S24_v, \T00_s
slli \T03_s, \S21_s, 2;                                vxor.vv \S20_v, \S20_v, \T02_v
xor  \S04_s, \S04_s, \T04_s;                           vxor.vv \S04_v, \S04_v, \T03_v;     li \T00_s, 62
srli \S24_s, \S21_s, 62;                               vsll.vi \T02_v, \S21_v, 2
slli \T02_s, \S05_s, 36;                               vsrl.vx \S24_v, \S21_v, \T00_s;     li \T00_s, 36
xor  \S24_s, \S24_s, \T03_s;                           vsrl.vi \S21_v, \S05_v, 28
srli \S21_s, \S05_s, 28;                               vsll.vx \T03_v, \S05_v, \T00_s
or  \T04_s, \S11_s, \S07_s;                            vxor.vv \S24_v, \S24_v, \T02_v
xor  \S21_s, \S21_s, \T02_s;                           vxor.vv \S21_v, \S21_v, \T03_v
xor \S05_s, \S10_s, \T04_s;                            vor.vv \T02_v, \S11_v, \S07_v
and \T03_s, \S07_s, \S08_s;                            vand.vv \T03_v, \S07_v, \S08_v
not \T02_s, \S09_s;                                    vnot.v \T04_v, \S09_v
xor \S06_s, \S11_s, \T03_s;                            vor.vv \T05_v, \S09_v, \S10_v
or  \T02_s, \T02_s, \S08_s;                            vxor.vv \S05_v, \S10_v, \T02_v
or  \T04_s, \S09_s, \S10_s;                            vor.vv \T04_v, \T04_v, \S08_v
xor \S07_s, \S07_s, \T02_s;                            vxor.vv \S06_v, \S11_v, \T03_v
xor \S08_s, \S08_s, \T04_s;                            vxor.vv \S07_v, \S07_v, \T04_v
and \T03_s, \S10_s, \S11_s;                            vxor.vv \S08_v, \S08_v, \T05_v
or  \T04_s, \S16_s, \S12_s;                            vand.vv \T02_v, \S10_v, \S11_v
xor \S09_s, \S09_s, \T03_s;                            vor.vv \T03_v, \S16_v, \S12_v
xor \S10_s, \S15_s, \T04_s;                            vnot.v \T05_v, \S13_v
and \T03_s, \S12_s, \S13_s;                            vand.vv \T04_v, \S12_v, \S13_v
not \T02_s, \S13_s;                                    vxor.vv \S09_v, \S09_v, \T02_v
xor \S11_s, \S16_s, \T03_s;                            vand.vv \T05_v, \T05_v, \S14_v
and \T02_s, \T02_s, \S14_s;                            vxor.vv \S10_v, \S15_v, \T03_v
not \T03_s, \S13_s;                                    vxor.vv \S11_v, \S16_v, \T04_v
xor \S12_s, \S12_s, \T02_s;                            vxor.vv \S12_v, \S12_v, \T05_v
or  \T04_s, \S14_s, \S15_s;                            vnot.v \T03_v, \S13_v
and \T02_s, \S15_s, \S16_s;                            vand.vv \T04_v, \S15_v, \S16_v
xor \S13_s, \T03_s, \T04_s;                            vand.vv \T05_v, \S21_v, \S17_v
xor \S14_s, \S14_s, \T02_s;                            vor.vv \T02_v, \S14_v, \S15_v
and \T04_s, \S21_s, \S17_s;                            vxor.vv \S14_v, \S14_v, \T04_v
or  \T03_s, \S17_s, \S18_s;                            vxor.vv \S15_v, \S20_v, \T05_v
not \T02_s, \S18_s;                                    vxor.vv \S13_v, \T03_v, \T02_v
xor \S15_s, \S20_s, \T04_s;                            vnot.v \T03_v, \S18_v
or  \T02_s, \T02_s, \S19_s;                            vnot.v \T05_v, \S18_v
xor \S16_s, \S21_s, \T03_s;                            vor.vv \T02_v, \S17_v, \S18_v
xor \S17_s, \S17_s, \T02_s;                            vor.vv \T03_v, \T03_v, \S19_v
not \T03_s, \S18_s;                                    vand.vv \T04_v, \S19_v, \S20_v
and \T04_s, \S19_s, \S20_s;                            vxor.vv \S16_v, \S21_v, \T02_v
or  \T02_s, \S20_s, \S21_s;                            vxor.vv \S17_v, \S17_v, \T03_v
xor \S18_s, \T03_s, \T04_s;                            vxor.vv \S18_v, \T05_v, \T04_v
xor \S19_s, \S19_s, \T02_s;                            vnot.v \T03_v, \S01_v
not \T04_s, \S01_s;                                    vnot.v \T05_v, \S01_v
not \T02_s, \S01_s;                                    vor.vv \T02_v, \S20_v, \S21_v
and \T04_s, \T04_s, \S22_s;                            vand.vv \T03_v, \T03_v, \S22_v
or  \T03_s, \S22_s, \S23_s;                            vor.vv \T04_v, \S22_v, \S23_v
xor \S20_s, \S00_s, \T04_s;                            vxor.vv \S19_v, \S19_v, \T02_v
xor \S21_s, \T02_s, \T03_s;                            vxor.vv \S20_v, \S00_v, \T03_v
and \T04_s, \S23_s, \S24_s;                            vxor.vv \S21_v, \T05_v, \T04_v
or  \T03_s, \S24_s, \S00_s;                            vand.vv \T02_v, \S23_v, \S24_v
xor \S22_s, \S22_s, \T04_s; ld \T00_s, 8*18(sp);       vor.vv \T03_v, \S24_v, \S00_v
xor \S23_s, \S23_s, \T03_s;                            vand.vv \T04_v, \S00_v, \S01_v
and \T02_s, \S00_s, \S01_s;                            vor.vv \T05_v, \T01_v, \S02_v
or  \T04_s, \T01_s, \S02_s;                            vxor.vv \S22_v, \S22_v, \T02_v
not \T03_s, \S02_s;                                    vxor.vv \S23_v, \S23_v, \T03_v
xor \S24_s, \S24_s, \T02_s;                            vxor.vv \S24_v, \S24_v, \T04_v
or  \T03_s, \T03_s, \S03_s;                            vxor.vv \S00_v, \T00_v, \T05_v
xor \S00_s, \T00_s, \T04_s;                            vnot.v \T02_v, \S02_v
xor \S01_s, \T01_s, \T03_s;                            vor.vv \T04_v, \S04_v, \T00_v
and \T02_s, \S03_s, \S04_s;                            vand.vv \T03_v, \S03_v, \S04_v
or  \T04_s, \S04_s, \T00_s;                            vand.vv \T05_v, \T00_v, \T01_v
xor \S02_s, \S02_s, \T02_s; ld   \T02_s, 17*8(sp);     vor.vv \T02_v, \T02_v, \S03_v
and \T03_s, \T00_s, \T01_s;                            vxor.vv \S02_v, \S02_v, \T03_v
xor \S03_s, \S03_s, \T04_s; ld   \T01_s, 0(\T02_s);    vxor.vv \S03_v, \S03_v, \T04_v
addi \T02_s, \T02_s, 8;                                vxor.vv \S01_v, \T01_v, \T02_v
ld   \T04_s, 16*8(sp)
xor \S04_s, \S04_s, \T03_s; sd   \T02_s, 17*8(sp);     vxor.vv \S04_v, \S04_v, \T05_v
addi \T04_s, \T04_s, -1
xor  \S00_s, \S00_s, \T01_s;                           vxor.vx \S00_v, \S00_v, \T01_s
.endm

# 15*8(sp): a0
# 16*8(sp): loop control variable i
# 17*8(sp): table index
# 18*8(sp), 19*8(sp): temp
.globl KeccakF1600_StatePermute_RV64V_3x
.align 2
KeccakF1600_StatePermute_RV64V_3x:
    addi sp, sp, -8*20
    la a1, constants_keccak
    SaveRegs
    sd a0, 15*8(sp)
    sd a1, 17*8(sp)
    li a1, 128
    vsetvli a2, a1, e64, m1, tu, mu
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
        v30, v31, \
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
    addi sp, sp, 8*20
    ret
