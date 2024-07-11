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

.macro LoadStates_v
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
.endm

.macro LoadStates_s \
        S00, S01, S02, S03, S04, \
        S05, S06, S07, S08, S09, \
        S10, S11, S12, S13, S14, \
        S15, S16, S17, S18, S19, \
        S20, S21, S22, S23, S24
    # lane complement: 1,2,8,12,17,20
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
    ld \S18, 18*8(a0)
    ld \S19, 19*8(a0)
    ld \S20, 20*8(a0)
    ld \S21, 21*8(a0)
    ld \S22, 22*8(a0)
    ld \S23, 23*8(a0)
    ld \S24, 24*8(a0)
.endm

.macro StoreStates_v
    # store states for vector impl
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
    addi a0, a0, 1*16
.endm

.macro StoreStates_s \
        S00, S01, S02, S03, S04, \
        S05, S06, S07, S08, S09, \
        S10, S11, S12, S13, S14, \
        S15, S16, S17, S18, S19, \
        S20, S21, S22, S23, S24
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

.macro ARoundInPlace \
        S00_v, S01_v, S02_v, S03_v, S04_v, S05_v, S06_v, S07_v, S08_v, S09_v, \
        S10_v, S11_v, S12_v, S13_v, S14_v, S15_v, S16_v, S17_v, S18_v, S19_v, \
        S20_v, S21_v, S22_v, S23_v, S24_v, T00_v, T01_v, T02_v, T03_v, T04_v, \
        T05_v, T06_v, \
        S00_s, S01_s, S02_s, S03_s, S04_s, S05_s, S06_s, S07_s, S08_s, S09_s, \
        S10_s, S11_s, S12_s, S13_s, S14_s, S15_s, S16_s, S17_s, S18_s, S19_s, \
        S20_s, S21_s, S22_s, S23_s, S24_s, T00_s, T01_s, T02_s, T03_s, T04_s
xor \T01_s, \S02_s, \S07_s
xor \T00_s, \S00_s, \S05_s
xor \T01_s, \T01_s, \S12_s;                        vxor.vv \T00_v, \S01_v, \S06_v
xor \T00_s, \T00_s, \S10_s
xor \T01_s, \T01_s, \S17_s
xor \T00_s, \T00_s, \S15_s;                        vxor.vv \T01_v, \S04_v, \S09_v
xor \T01_s, \T01_s, \S22_s
xor \T00_s, \T00_s, \S20_s
rori \T02_s, \T01_s, 64-1;                         vxor.vv \T02_v, \S03_v, \S08_v
xor \T03_s, \S01_s, \S06_s
xor  \T02_s, \T02_s, \T00_s;                       vxor.vv \T00_v, \T00_v, \S11_v
xor \T03_s, \T03_s, \S11_s
xor \T04_s, \S04_s, \S09_s;                        vxor.vv \T01_v, \T01_v, \S14_v
xor \S01_s, \S01_s, \T02_s
xor \T04_s, \T04_s, \S14_s
xor \S06_s, \S06_s, \T02_s;                        vxor.vv \T02_v, \T02_v, \S13_v
sd  \S06_s, 18*8(sp)
xor \T03_s, \T03_s, \S16_s
xor \T04_s, \T04_s, \S19_s;                        vxor.vv \T00_v, \T00_v, \S16_v
xor \S11_s, \S11_s, \T02_s
xor \T04_s, \T04_s, \S24_s
xor \T03_s, \T03_s, \S21_s;                        vxor.vv \T01_v, \T01_v, \S19_v
rori \S06_s, \T04_s, 63
xor \S16_s, \S16_s, \T02_s;                        vxor.vv \T02_v, \T02_v, \S18_v
xor \S21_s, \S21_s, \T02_s
xor  \T01_s, \T01_s, \S06_s;                       vxor.vv \T00_v, \T00_v, \S21_v
xor \T02_s, \S03_s, \S08_s;     sd \S00_s, 19*8(sp)
xor \S03_s, \S03_s, \T01_s
xor \T02_s, \T02_s, \S13_s;                        vxor.vv \T01_v, \T01_v, \S24_v
xor \S08_s, \S08_s, \T01_s
xor \T02_s, \T02_s, \S18_s
xor \S13_s, \S13_s, \T01_s;                        vxor.vv \T02_v, \T02_v, \S23_v;     li \S00_s, 64-1
xor \T02_s, \T02_s, \S23_s
xor \S18_s, \S18_s, \T01_s
ld  \S06_s, 18*8(sp);                              vsll.vi \T05_v, \T00_v, 1
rori \T00_s, \T00_s, 64-1
xor \S23_s, \S23_s, \T01_s;                        vsll.vi \T06_v, \T02_v, 1
xor  \T00_s, \T00_s, \T02_s
rori \T02_s, \T02_s, 64-1;                         vsrl.vx \T03_v, \T00_v, \S00_s
xor \S04_s, \S04_s, \T00_s
xor  \T02_s, \T02_s, \T03_s
xor \S09_s, \S09_s, \T00_s;                        vsrl.vx \T04_v, \T02_v, \S00_s
rori \T03_s, \T03_s, 64-1
xor \S14_s, \S14_s, \T00_s;     ld \S00_s, 19*8(sp)
xor  \T03_s, \T03_s, \T04_s;                       vxor.vv \T03_v, \T03_v, \T05_v
xor \S19_s, \S19_s, \T00_s
xor \S24_s, \S24_s, \T00_s
xor \S02_s, \S02_s, \T02_s;                        vxor.vv \T04_v, \T04_v, \T06_v
xor \S07_s, \S07_s, \T02_s
xor \S12_s, \S12_s, \T02_s;                        vxor.vv \T03_v, \T03_v, \T01_v
xor \S17_s, \S17_s, \T02_s
xor \S22_s, \S22_s, \T02_s;                        vxor.vv \T04_v, \T04_v, \T00_v
xor \T00_s, \S00_s, \T03_s
xor \S05_s, \S05_s, \T03_s
xor \S10_s, \S10_s, \T03_s;                        vxor.vv \T05_v, \S00_v, \S05_v
xor \S15_s, \S15_s, \T03_s
xor \S20_s, \S20_s, \T03_s
rori \T01_s, \S06_s, 64-44;                        vxor.vv \T06_v, \S02_v, \S07_v
rori \S00_s, \S02_s, 64-62
rori \S02_s, \S12_s, 64-43
rori \S12_s, \S13_s, 64-25;                        vxor.vv \T05_v, \T05_v, \S10_v
rori \S13_s, \S19_s, 64-8
rori \S19_s, \S23_s, 64-56;                        vxor.vv \T06_v, \T06_v, \S12_v
rori \S23_s, \S15_s, 64-41
rori \S15_s, \S01_s, 64-1;                         vxor.vv \T05_v, \T05_v, \S15_v
rori \S01_s, \S08_s, 64-55
rori \S08_s, \S16_s, 64-45
rori \S16_s, \S07_s, 64-6;                         vxor.vv \T06_v, \T06_v, \S17_v
rori \S07_s, \S10_s, 64-3
rori \S10_s, \S03_s, 64-28
rori \S03_s, \S18_s, 64-21;                        vxor.vv \T05_v, \T05_v, \S20_v
rori \S18_s, \S17_s, 64-15
rori \S17_s, \S11_s, 64-10
rori \S11_s, \S09_s, 64-20;                        vxor.vv \T06_v, \T06_v, \S22_v
rori \S09_s, \S22_s, 64-61
rori \S22_s, \S14_s, 64-39;                        vxor.vv \S00_v, \S00_v, \T03_v
rori \S14_s, \S20_s, 64-18
rori \S20_s, \S04_s, 64-27;                        vxor.vv \S05_v, \S05_v, \T03_v
rori \S04_s, \S24_s, 64-14
rori \S24_s, \S21_s, 64-2
rori \S21_s, \S05_s, 64-36;                        vxor.vv \S10_v, \S10_v, \T03_v
andn \T02_s, \S07_s, \S11_s
andn \T03_s, \S08_s, \S07_s
xor \S05_s, \T02_s, \S10_s;                        vxor.vv \S15_v, \S15_v, \T03_v
xor \S06_s, \T03_s, \S11_s
andn \T02_s, \S09_s, \S08_s
andn \T03_s, \S10_s, \S09_s;                       vxor.vv \S20_v, \S20_v, \T03_v
xor \S07_s, \T02_s, \S07_s
xor \S08_s, \T03_s, \S08_s;                        vxor.vv \S02_v, \S02_v, \T04_v
andn \T02_s, \S11_s, \S10_s
andn \T03_s, \S12_s, \S16_s;                       vxor.vv \S07_v, \S07_v, \T04_v
xor \S09_s, \T02_s, \S09_s
xor \S10_s, \T03_s, \S15_s
andn \T02_s, \S13_s, \S12_s;                       vxor.vv \S12_v, \S12_v, \T04_v
andn \T03_s, \S14_s, \S13_s;    sd \S09_s, 19*8(sp)
xor \S11_s, \T02_s, \S16_s;     li \S09_s, 63
xor \S12_s, \T03_s, \S12_s;                        vsll.vi \T03_v, \T01_v, 1
andn \T02_s, \S15_s, \S14_s
andn \T03_s, \S16_s, \S15_s
xor \S13_s, \T02_s, \S13_s;                        vsrl.vx \T00_v, \T01_v, \S09_s
xor \S14_s, \T03_s, \S14_s
andn \T02_s, \S17_s, \S21_s;                       vxor.vv \S17_v, \S17_v, \T04_v
andn \T03_s, \S18_s, \S17_s
xor \S15_s, \T02_s, \S20_s;                        vxor.vv \S22_v, \S22_v, \T04_v
xor \S16_s, \T03_s, \S21_s
andn \T02_s, \S19_s, \S18_s
andn \T03_s, \S20_s, \S19_s;                       vxor.vv \T00_v, \T00_v, \T03_v
xor \S17_s, \T02_s, \S17_s
xor \S18_s, \T03_s, \S18_s
andn \T02_s, \S21_s, \S20_s;                       vxor.vv \T00_v, \T00_v, \T06_v
andn \T03_s, \S22_s, \S01_s
xor \S19_s, \T02_s, \S19_s
xor \S20_s, \T03_s, \S00_s;                        vxor.vv \S03_v, \S03_v, \T00_v
andn \T02_s, \S23_s, \S22_s
andn \T03_s, \S24_s, \S23_s;                       vxor.vv \S08_v, \S08_v, \T00_v
xor \S21_s, \T02_s, \S01_s
xor \S22_s, \T03_s, \S22_s;                        vxor.vv \S13_v, \S13_v, \T00_v
andn \T02_s, \S00_s, \S24_s
andn \T03_s, \S01_s, \S00_s
xor \S23_s, \T02_s, \S23_s;                        vxor.vv \S18_v, \S18_v, \T00_v
xor \S24_s, \T03_s, \S24_s
andn \T02_s, \S02_s, \T01_s
andn \T03_s, \S03_s, \S02_s;    ld   \T04_s, 17*8(sp);vxor.vv \S23_v, \S23_v, \T00_v
xor \S00_s, \T02_s, \T00_s
xor \S01_s, \T03_s, \T01_s
andn \T02_s, \S04_s, \S03_s;                       vsll.vi \T00_v, \T06_v, 1
andn \T03_s, \T00_s, \S04_s
xor \S02_s, \T02_s, \S02_s;                        vsll.vi \T03_v, \T05_v, 1
andn \T02_s, \T01_s, \T00_s;   ld   \T01_s, 0(\T04_s)
xor \S03_s, \T03_s, \S03_s;    addi \T04_s, \T04_s, 8;vsrl.vx \T01_v, \T06_v, \S09_s
xor \S04_s, \T02_s, \S04_s;    sd   \T04_s, 17*8(sp)
xor  \S00_s, \S00_s, \T01_s
xor \T01_s, \S02_s, \S07_s;                        vsrl.vx \T04_v, \T05_v, \S09_s
xor \T00_s, \S00_s, \S05_s
xor \T01_s, \T01_s, \S12_s
xor \T00_s, \T00_s, \S10_s;                        vxor.vv \T01_v, \T01_v, \T00_v
xor \T01_s, \T01_s, \S17_s
xor \T00_s, \T00_s, \S15_s
xor \T01_s, \T01_s, \S22_s;                        vxor.vv \T04_v, \T04_v, \T03_v
xor \T00_s, \T00_s, \S20_s;     ld \S09_s, 19*8(sp)
rori \T02_s, \T01_s, 64-1;                         vxor.vv \T01_v, \T01_v, \T05_v
xor \T03_s, \S01_s, \S06_s
xor  \T02_s, \T02_s, \T00_s;                       vxor.vv \T04_v, \T04_v, \T02_v
xor \T03_s, \T03_s, \S11_s
xor \T04_s, \S04_s, \S09_s
xor \S01_s, \S01_s, \T02_s;                        vxor.vv \S01_v, \S01_v, \T01_v
xor \T04_s, \T04_s, \S14_s
xor \S06_s, \S06_s, \T02_s
sd  \S06_s, 18*8(sp);                              vxor.vv \S06_v, \S06_v, \T01_v
xor \T03_s, \T03_s, \S16_s
xor \T04_s, \T04_s, \S19_s
xor \S11_s, \S11_s, \T02_s;                        vxor.vv \S11_v, \S11_v, \T01_v
xor \T04_s, \T04_s, \S24_s
xor \T03_s, \T03_s, \S21_s;                        vxor.vv \S16_v, \S16_v, \T01_v
rori \S06_s, \T04_s, 63
xor \S16_s, \S16_s, \T02_s;                        vxor.vv \S21_v, \S21_v, \T01_v
xor \S21_s, \S21_s, \T02_s
xor  \T01_s, \T01_s, \S06_s
xor \T02_s, \S03_s, \S08_s;                        vxor.vv \S04_v, \S04_v, \T04_v
xor \S03_s, \S03_s, \T01_s
xor \T02_s, \T02_s, \S13_s
xor \S08_s, \S08_s, \T01_s;                        vxor.vv \S09_v, \S09_v, \T04_v
xor \T02_s, \T02_s, \S18_s
xor \S13_s, \S13_s, \T01_s
xor \T02_s, \T02_s, \S23_s;                        vxor.vv \S14_v, \S14_v, \T04_v
xor \S18_s, \S18_s, \T01_s
ld  \S06_s, 18*8(sp);                              vxor.vv \S19_v, \S19_v, \T04_v
rori \T00_s, \T00_s, 64-1
xor \S23_s, \S23_s, \T01_s;                        vxor.vv \S24_v, \S24_v, \T04_v
xor  \T00_s, \T00_s, \T02_s;    sd \S18_s, 19*8(sp)
rori \T02_s, \T02_s, 64-1
xor \S04_s, \S04_s, \T00_s;                        vmv.v.v \T00_v, \S00_v;             li \S18_s, 44
xor  \T02_s, \T02_s, \T03_s
xor \S09_s, \S09_s, \T00_s
rori \T03_s, \T03_s, 64-1;                         vsrl.vi \T01_v, \S06_v, 20
xor \S14_s, \S14_s, \T00_s
xor  \T03_s, \T03_s, \T04_s
xor \S19_s, \S19_s, \T00_s;                        vsll.vx \T02_v, \S06_v, \S18_s;     li \S18_s, 62
xor \S24_s, \S24_s, \T00_s
xor \S02_s, \S02_s, \T02_s;                        vsrl.vi \S00_v, \S02_v, 2
xor \S07_s, \S07_s, \T02_s
xor \S12_s, \S12_s, \T02_s;                        vsll.vx \T03_v, \S02_v, \S18_s
xor \S17_s, \S17_s, \T02_s
xor \S22_s, \S22_s, \T02_s
xor \T00_s, \S00_s, \T03_s;                        vxor.vv \T01_v, \T01_v, \T02_v
xor \S05_s, \S05_s, \T03_s
xor \S10_s, \S10_s, \T03_s
xor \S15_s, \S15_s, \T03_s;                        vxor.vv \S00_v, \S00_v, \T03_v;     li \S18_s, 43
xor \S20_s, \S20_s, \T03_s
rori \T01_s, \S06_s, 64-44
rori \S00_s, \S02_s, 64-62;                        vsrl.vi \S02_v, \S12_v, 21
rori \S02_s, \S12_s, 64-43
rori \S12_s, \S13_s, 64-25;                        vsll.vx \T02_v, \S12_v, \S18_s;     li \S18_s, 39
rori \S13_s, \S19_s, 64-8
rori \S19_s, \S23_s, 64-56;                        vsll.vi \T03_v, \S13_v, 25
rori \S23_s, \S15_s, 64-41
rori \S15_s, \S01_s, 64-1
rori \S01_s, \S08_s, 64-55;                        vsrl.vx \S12_v, \S13_v, \S18_s
rori \S08_s, \S16_s, 64-45;     ld \S18_s, 19*8(sp)
rori \S16_s, \S07_s, 64-6
rori \S07_s, \S10_s, 64-3;                         vxor.vv \S02_v, \S02_v, \T02_v
rori \S10_s, \S03_s, 64-28;     sd \T00_s, 19*8(sp)
rori \S03_s, \S18_s, 64-21
rori \S18_s, \S17_s, 64-15;                        vxor.vv \S12_v, \S12_v, \T03_v;     li \T00_s, 56
rori \S17_s, \S11_s, 64-10
rori \S11_s, \S09_s, 64-20;                        vsll.vi \T02_v, \S19_v, 8
rori \S09_s, \S22_s, 64-61
rori \S22_s, \S14_s, 64-39;                        vsrl.vx \S13_v, \S19_v, \T00_s;     li \T00_s, 56
rori \S14_s, \S20_s, 64-18
rori \S20_s, \S04_s, 64-27
rori \S04_s, \S24_s, 64-14;                        vsrl.vi \S19_v, \S23_v, 8
rori \S24_s, \S21_s, 64-2
rori \S21_s, \S05_s, 64-36
andn \T02_s, \S07_s, \S11_s;                       vsll.vx \T03_v, \S23_v, \T00_s
andn \T03_s, \S08_s, \S07_s
xor \S05_s, \T02_s, \S10_s
xor \S06_s, \T03_s, \S11_s;                        vxor.vv \S13_v, \S13_v, \T02_v
andn \T02_s, \S09_s, \S08_s
andn \T03_s, \S10_s, \S09_s;                       vxor.vv \S19_v, \S19_v, \T03_v;     li \T00_s, 41
xor \S07_s, \T02_s, \S07_s
xor \S08_s, \T03_s, \S08_s;                        vsrl.vi \S23_v, \S15_v, 23
andn \T02_s, \S11_s, \S10_s
andn \T03_s, \S12_s, \S16_s
xor \S09_s, \T02_s, \S09_s;                        vsll.vx \T02_v, \S15_v, \T00_s;     li \T00_s, 63
xor \S10_s, \T03_s, \S15_s
andn \T02_s, \S13_s, \S12_s
andn \T03_s, \S14_s, \S13_s;                       vsll.vi \T03_v, \S01_v, 1
xor \S11_s, \T02_s, \S16_s
xor \S12_s, \T03_s, \S12_s
andn \T02_s, \S15_s, \S14_s;                       vsrl.vx \S15_v, \S01_v, \T00_s
andn \T03_s, \S16_s, \S15_s
xor \S13_s, \T02_s, \S13_s;                        vxor.vv \S23_v, \S23_v, \T02_v
xor \S14_s, \T03_s, \S14_s
andn \T02_s, \S17_s, \S21_s;                       vxor.vv \S15_v, \S15_v, \T03_v;     li \T00_s, 55
andn \T03_s, \S18_s, \S17_s
xor \S15_s, \T02_s, \S20_s
xor \S16_s, \T03_s, \S21_s;                        vsrl.vi \S01_v, \S08_v, 9
andn \T02_s, \S19_s, \S18_s
andn \T03_s, \S20_s, \S19_s
xor \S17_s, \T02_s, \S17_s;                        vsll.vx \T02_v, \S08_v, \T00_s;     li \T00_s, 45
xor \S18_s, \T03_s, \S18_s
andn \T02_s, \S21_s, \S20_s
andn \T03_s, \S22_s, \S01_s;                       vsrl.vi \S08_v, \S16_v, 19
xor \S19_s, \T02_s, \S19_s
xor \S20_s, \T03_s, \S00_s;                        vsll.vx \T03_v, \S16_v, \T00_s
andn \T02_s, \S23_s, \S22_s;    ld \T00_s, 19*8(sp)
andn \T03_s, \S24_s, \S23_s;                       vxor.vv \S01_v, \S01_v, \T02_v
xor \S21_s, \T02_s, \S01_s
xor \S22_s, \T03_s, \S22_s;     sd \S21_s, 19*8(sp)
andn \T02_s, \S00_s, \S24_s;                       vxor.vv \S08_v, \S08_v, \T03_v;     li \S21_s, 58
andn \T03_s, \S01_s, \S00_s
xor \S23_s, \T02_s, \S23_s
xor \S24_s, \T03_s, \S24_s;                        vsll.vi \T02_v, \S07_v, 6
andn \T02_s, \S02_s, \T01_s
andn \T03_s, \S03_s, \S02_s;    ld   \T04_s, 17*8(sp)
xor \S00_s, \T02_s, \T00_s;                        vsrl.vx \S16_v, \S07_v, \S21_s;     li \S21_s, 61
xor \S01_s, \T03_s, \T01_s
andn \T02_s, \S04_s, \S03_s;                       vsll.vi \T03_v, \S10_v, 3
andn \T03_s, \T00_s, \S04_s
xor \S02_s, \T02_s, \S02_s;                        vsrl.vx \S07_v, \S10_v, \S21_s
andn \T02_s, \T01_s, \T00_s;   ld   \T01_s, 0(\T04_s)
xor \S03_s, \T03_s, \S03_s;    addi \T04_s, \T04_s, 8
xor \S04_s, \T02_s, \S04_s;    sd   \T04_s, 17*8(sp);vxor.vv \S16_v, \S16_v, \T02_v
xor  \S00_s, \S00_s, \T01_s
xor \T01_s, \S02_s, \S07_s
xor \T00_s, \S00_s, \S05_s;                        vxor.vv \S07_v, \S07_v, \T03_v;     li \S21_s, 36
xor \T01_s, \T01_s, \S12_s
xor \T00_s, \T00_s, \S10_s
xor \T01_s, \T01_s, \S17_s;                        vsll.vi \T02_v, \S03_v, 28
xor \T00_s, \T00_s, \S15_s
xor \T01_s, \T01_s, \S22_s;                        vsrl.vx \S10_v, \S03_v, \S21_s;     li \S21_s, 43
xor \T00_s, \T00_s, \S20_s
rori \T02_s, \T01_s, 64-1;                         vsll.vi \T03_v, \S18_v, 21
xor \T03_s, \S01_s, \S06_s
xor  \T02_s, \T02_s, \T00_s
xor \T03_s, \T03_s, \S11_s;                        vsrl.vx \S03_v, \S18_v, \S21_s
xor \T04_s, \S04_s, \S09_s;     ld \S21_s, 19*8(sp)
xor \S01_s, \S01_s, \T02_s
xor \T04_s, \T04_s, \S14_s;                        vxor.vv \S10_v, \S10_v, \T02_v
xor \S06_s, \S06_s, \T02_s;     sd \S01_s, 19*8(sp)
sd  \S06_s, 18*8(sp)
xor \T03_s, \T03_s, \S16_s;                        vxor.vv \S03_v, \S03_v, \T03_v;     li \S01_s, 49
xor \T04_s, \T04_s, \S19_s
xor \S11_s, \S11_s, \T02_s;                        vsll.vi \T02_v, \S17_v, 15
xor \T04_s, \T04_s, \S24_s
xor \T03_s, \T03_s, \S21_s;                        vsrl.vx \S18_v, \S17_v, \S01_s;     li \S01_s, 54
rori \S06_s, \T04_s, 63
xor \S16_s, \S16_s, \T02_s
xor \S21_s, \S21_s, \T02_s;                        vsll.vi \T03_v, \S11_v, 10
xor  \T01_s, \T01_s, \S06_s
xor \T02_s, \S03_s, \S08_s
xor \S03_s, \S03_s, \T01_s;                        vsrl.vx \S17_v, \S11_v, \S01_s
xor \T02_s, \T02_s, \S13_s
xor \S08_s, \S08_s, \T01_s
xor \T02_s, \T02_s, \S18_s;                        vxor.vv \S18_v, \S18_v, \T02_v
xor \S13_s, \S13_s, \T01_s
xor \T02_s, \T02_s, \S23_s;                        vxor.vv \S17_v, \S17_v, \T03_v;     li \S01_s, 44
xor \S18_s, \S18_s, \T01_s
ld  \S06_s, 18*8(sp);                              vsll.vi \T02_v, \S09_v, 20
rori \T00_s, \T00_s, 64-1
xor \S23_s, \S23_s, \T01_s
xor  \T00_s, \T00_s, \T02_s;                       vsrl.vx \S11_v, \S09_v, \S01_s;     li \S01_s, 61
rori \T02_s, \T02_s, 64-1
xor \S04_s, \S04_s, \T00_s
xor  \T02_s, \T02_s, \T03_s;                       vsrl.vi \S09_v, \S22_v, 3
xor \S09_s, \S09_s, \T00_s
rori \T03_s, \T03_s, 64-1
xor \S14_s, \S14_s, \T00_s;                        vsll.vx \T03_v, \S22_v, \S01_s
xor  \T03_s, \T03_s, \T04_s
xor \S19_s, \S19_s, \T00_s;                        vxor.vv \S11_v, \S11_v, \T02_v
xor \S24_s, \S24_s, \T00_s
xor \S02_s, \S02_s, \T02_s;                        vxor.vv \S09_v, \S09_v, \T03_v;     li \S01_s, 39
xor \S07_s, \S07_s, \T02_s
xor \S12_s, \S12_s, \T02_s
xor \S17_s, \S17_s, \T02_s;                        vsrl.vi \S22_v, \S14_v, 25
xor \S22_s, \S22_s, \T02_s
xor \T00_s, \S00_s, \T03_s
xor \S05_s, \S05_s, \T03_s;                        vsll.vx \T02_v, \S14_v, \S01_s;     li \S01_s, 46
xor \S10_s, \S10_s, \T03_s
xor \S15_s, \S15_s, \T03_s
xor \S20_s, \S20_s, \T03_s;                        vsll.vi \T03_v, \S20_v, 18
rori \T01_s, \S06_s, 64-44
rori \S00_s, \S02_s, 64-62;                        vsrl.vx \S14_v, \S20_v, \S01_s
rori \S02_s, \S12_s, 64-43;     ld \S01_s, 19*8(sp)
rori \S12_s, \S13_s, 64-25;                        vxor.vv \S22_v, \S22_v, \T02_v
rori \S13_s, \S19_s, 64-8;      sd \T01_s, 19*8(sp)
rori \S19_s, \S23_s, 64-56
rori \S23_s, \S15_s, 64-41;                        vxor.vv \S14_v, \S14_v, \T03_v;     li \T01_s, 37
rori \S15_s, \S01_s, 64-1
rori \S01_s, \S08_s, 64-55
rori \S08_s, \S16_s, 64-45;                        vsll.vi \T02_v, \S04_v, 27
rori \S16_s, \S07_s, 64-6
rori \S07_s, \S10_s, 64-3
rori \S10_s, \S03_s, 64-28;                        vsrl.vx \S20_v, \S04_v, \T01_s;     li \T01_s, 50
rori \S03_s, \S18_s, 64-21
rori \S18_s, \S17_s, 64-15;                        vsll.vi \T03_v, \S24_v, 14
rori \S17_s, \S11_s, 64-10
rori \S11_s, \S09_s, 64-20;                        vsrl.vx \S04_v, \S24_v, \T01_s
rori \S09_s, \S22_s, 64-61
rori \S22_s, \S14_s, 64-39
rori \S14_s, \S20_s, 64-18;                        vxor.vv \S20_v, \S20_v, \T02_v
rori \S20_s, \S04_s, 64-27
rori \S04_s, \S24_s, 64-14
rori \S24_s, \S21_s, 64-2;                         vxor.vv \S04_v, \S04_v, \T03_v;     li \T01_s, 62
rori \S21_s, \S05_s, 64-36
andn \T02_s, \S07_s, \S11_s
andn \T03_s, \S08_s, \S07_s;                       vsll.vi \T02_v, \S21_v, 2
xor \S05_s, \T02_s, \S10_s
xor \S06_s, \T03_s, \S11_s;                        vsrl.vx \S24_v, \S21_v, \T01_s;     li \T01_s, 36
andn \T02_s, \S09_s, \S08_s
andn \T03_s, \S10_s, \S09_s;                       vsrl.vi \S21_v, \S05_v, 28
xor \S07_s, \T02_s, \S07_s
xor \S08_s, \T03_s, \S08_s
andn \T02_s, \S11_s, \S10_s;                       vsll.vx \T03_v, \S05_v, \T01_s
andn \T03_s, \S12_s, \S16_s;    ld \T01_s, 19*8(sp)
xor \S09_s, \T02_s, \S09_s
xor \S10_s, \T03_s, \S15_s;                        vxor.vv \S24_v, \S24_v, \T02_v
andn \T02_s, \S13_s, \S12_s
andn \T03_s, \S14_s, \S13_s
xor \S11_s, \T02_s, \S16_s;                        vxor.vv \S21_v, \S21_v, \T03_v
xor \S12_s, \T03_s, \S12_s
andn \T02_s, \S15_s, \S14_s;                       vor.vv \T02_v, \S11_v, \S07_v
andn \T03_s, \S16_s, \S15_s
xor \S13_s, \T02_s, \S13_s;                        vand.vv \T03_v, \S07_v, \S08_v
xor \S14_s, \T03_s, \S14_s
andn \T02_s, \S17_s, \S21_s
andn \T03_s, \S18_s, \S17_s;                       vnot.v \T04_v, \S09_v
xor \S15_s, \T02_s, \S20_s
xor \S16_s, \T03_s, \S21_s
andn \T02_s, \S19_s, \S18_s;                       vor.vv \T05_v, \S09_v, \S10_v
andn \T03_s, \S20_s, \S19_s
xor \S17_s, \T02_s, \S17_s
xor \S18_s, \T03_s, \S18_s;                        vxor.vv \S05_v, \S10_v, \T02_v
andn \T02_s, \S21_s, \S20_s
andn \T03_s, \S22_s, \S01_s;                       vor.vv \T04_v, \T04_v, \S08_v
xor \S19_s, \T02_s, \S19_s
xor \S20_s, \T03_s, \S00_s;                        vxor.vv \S06_v, \S11_v, \T03_v
andn \T02_s, \S23_s, \S22_s
andn \T03_s, \S24_s, \S23_s
xor \S21_s, \T02_s, \S01_s;                        vxor.vv \S07_v, \S07_v, \T04_v
xor \S22_s, \T03_s, \S22_s
andn \T02_s, \S00_s, \S24_s
andn \T03_s, \S01_s, \S00_s;                       vxor.vv \S08_v, \S08_v, \T05_v
xor \S23_s, \T02_s, \S23_s
xor \S24_s, \T03_s, \S24_s
andn \T02_s, \S02_s, \T01_s;                       vand.vv \T02_v, \S10_v, \S11_v
andn \T03_s, \S03_s, \S02_s;    ld   \T04_s, 17*8(sp)
xor \S00_s, \T02_s, \T00_s;                        vor.vv \T03_v, \S16_v, \S12_v
xor \S01_s, \T03_s, \T01_s
andn \T02_s, \S04_s, \S03_s;                       vnot.v \T05_v, \S13_v
andn \T03_s, \T00_s, \S04_s
xor \S02_s, \T02_s, \S02_s
andn \T02_s, \T01_s, \T00_s;   ld   \T01_s, 0(\T04_s);vand.vv \T04_v, \S12_v, \S13_v
xor \S03_s, \T03_s, \S03_s;    addi \T04_s, \T04_s, 8
xor \S04_s, \T02_s, \S04_s;    sd   \T04_s, 17*8(sp)
xor  \S00_s, \S00_s, \T01_s;                       vxor.vv \S09_v, \S09_v, \T02_v
xor \T01_s, \S02_s, \S07_s
xor \T00_s, \S00_s, \S05_s
xor \T01_s, \T01_s, \S12_s;                        vand.vv \T05_v, \T05_v, \S14_v
xor \T00_s, \T00_s, \S10_s
xor \T01_s, \T01_s, \S17_s;                        vxor.vv \S10_v, \S15_v, \T03_v
xor \T00_s, \T00_s, \S15_s
xor \T01_s, \T01_s, \S22_s;                        vxor.vv \S11_v, \S16_v, \T04_v
xor \T00_s, \T00_s, \S20_s
rori \T02_s, \T01_s, 64-1
xor \T03_s, \S01_s, \S06_s;                        vxor.vv \S12_v, \S12_v, \T05_v
xor  \T02_s, \T02_s, \T00_s
xor \T03_s, \T03_s, \S11_s
xor \T04_s, \S04_s, \S09_s;                        vnot.v \T03_v, \S13_v
xor \S01_s, \S01_s, \T02_s
xor \T04_s, \T04_s, \S14_s
xor \S06_s, \S06_s, \T02_s;                        vand.vv \T04_v, \S15_v, \S16_v
sd  \S06_s, 18*8(sp)
xor \T03_s, \T03_s, \S16_s;                        vand.vv \T05_v, \S21_v, \S17_v
xor \T04_s, \T04_s, \S19_s
xor \S11_s, \S11_s, \T02_s;                        vor.vv \T02_v, \S14_v, \S15_v
xor \T04_s, \T04_s, \S24_s
xor \T03_s, \T03_s, \S21_s
rori \S06_s, \T04_s, 63;                           vxor.vv \S14_v, \S14_v, \T04_v
xor \S16_s, \S16_s, \T02_s
xor \S21_s, \S21_s, \T02_s
xor  \T01_s, \T01_s, \S06_s;                       vxor.vv \S15_v, \S20_v, \T05_v
xor \T02_s, \S03_s, \S08_s
xor \S03_s, \S03_s, \T01_s
xor \T02_s, \T02_s, \S13_s;                        vxor.vv \S13_v, \T03_v, \T02_v
xor \S08_s, \S08_s, \T01_s
xor \T02_s, \T02_s, \S18_s;                        vnot.v \T03_v, \S18_v
xor \S13_s, \S13_s, \T01_s
xor \T02_s, \T02_s, \S23_s;                        vnot.v \T05_v, \S18_v
xor \S18_s, \S18_s, \T01_s
ld  \S06_s, 18*8(sp)
rori \T00_s, \T00_s, 64-1;                         vor.vv \T02_v, \S17_v, \S18_v
xor \S23_s, \S23_s, \T01_s
xor  \T00_s, \T00_s, \T02_s
rori \T02_s, \T02_s, 64-1;                         vor.vv \T03_v, \T03_v, \S19_v
xor \S04_s, \S04_s, \T00_s
xor  \T02_s, \T02_s, \T03_s
xor \S09_s, \S09_s, \T00_s;                        vand.vv \T04_v, \S19_v, \S20_v
rori \T03_s, \T03_s, 64-1
xor \S14_s, \S14_s, \T00_s;                        vxor.vv \S16_v, \S21_v, \T02_v
xor  \T03_s, \T03_s, \T04_s
xor \S19_s, \S19_s, \T00_s;                        vxor.vv \S17_v, \S17_v, \T03_v
xor \S24_s, \S24_s, \T00_s
xor \S02_s, \S02_s, \T02_s
xor \S07_s, \S07_s, \T02_s;                        vxor.vv \S18_v, \T05_v, \T04_v
xor \S12_s, \S12_s, \T02_s
xor \S17_s, \S17_s, \T02_s
xor \S22_s, \S22_s, \T02_s;                        vnot.v \T03_v, \S01_v
xor \T00_s, \S00_s, \T03_s
xor \S05_s, \S05_s, \T03_s
xor \S10_s, \S10_s, \T03_s;                        vnot.v \T05_v, \S01_v
xor \S15_s, \S15_s, \T03_s
xor \S20_s, \S20_s, \T03_s;                        vor.vv \T02_v, \S20_v, \S21_v
rori \T01_s, \S06_s, 64-44
rori \S00_s, \S02_s, 64-62;                        vand.vv \T03_v, \T03_v, \S22_v
rori \S02_s, \S12_s, 64-43
rori \S12_s, \S13_s, 64-25
rori \S13_s, \S19_s, 64-8;                         vor.vv \T04_v, \S22_v, \S23_v
rori \S19_s, \S23_s, 64-56
rori \S23_s, \S15_s, 64-41
rori \S15_s, \S01_s, 64-1;                         vxor.vv \S19_v, \S19_v, \T02_v
rori \S01_s, \S08_s, 64-55
rori \S08_s, \S16_s, 64-45
rori \S16_s, \S07_s, 64-6;                         vxor.vv \S20_v, \S00_v, \T03_v
rori \S07_s, \S10_s, 64-3
rori \S10_s, \S03_s, 64-28;                        vxor.vv \S21_v, \T05_v, \T04_v
rori \S03_s, \S18_s, 64-21
rori \S18_s, \S17_s, 64-15;                        vand.vv \T02_v, \S23_v, \S24_v
rori \S17_s, \S11_s, 64-10
rori \S11_s, \S09_s, 64-20
rori \S09_s, \S22_s, 64-61;                        vor.vv \T03_v, \S24_v, \S00_v
rori \S22_s, \S14_s, 64-39
rori \S14_s, \S20_s, 64-18
rori \S20_s, \S04_s, 64-27;                        vand.vv \T04_v, \S00_v, \S01_v
rori \S04_s, \S24_s, 64-14
rori \S24_s, \S21_s, 64-2
rori \S21_s, \S05_s, 64-36;                        vor.vv \T05_v, \T01_v, \S02_v
andn \T02_s, \S07_s, \S11_s
andn \T03_s, \S08_s, \S07_s;                       vxor.vv \S22_v, \S22_v, \T02_v
xor \S05_s, \T02_s, \S10_s
xor \S06_s, \T03_s, \S11_s;                        vxor.vv \S23_v, \S23_v, \T03_v
andn \T02_s, \S09_s, \S08_s
andn \T03_s, \S10_s, \S09_s
xor \S07_s, \T02_s, \S07_s;                        vxor.vv \S24_v, \S24_v, \T04_v
xor \S08_s, \T03_s, \S08_s
andn \T02_s, \S11_s, \S10_s
andn \T03_s, \S12_s, \S16_s;                       vxor.vv \S00_v, \T00_v, \T05_v
xor \S09_s, \T02_s, \S09_s
xor \S10_s, \T03_s, \S15_s
andn \T02_s, \S13_s, \S12_s;                       vnot.v \T02_v, \S02_v
andn \T03_s, \S14_s, \S13_s
xor \S11_s, \T02_s, \S16_s;                        vor.vv \T04_v, \S04_v, \T00_v
xor \S12_s, \T03_s, \S12_s
andn \T02_s, \S15_s, \S14_s;                       vand.vv \T03_v, \S03_v, \S04_v
andn \T03_s, \S16_s, \S15_s
xor \S13_s, \T02_s, \S13_s
xor \S14_s, \T03_s, \S14_s;                        vand.vv \T05_v, \T00_v, \T01_v
andn \T02_s, \S17_s, \S21_s
andn \T03_s, \S18_s, \S17_s
xor \S15_s, \T02_s, \S20_s;                        vor.vv \T02_v, \T02_v, \S03_v
xor \S16_s, \T03_s, \S21_s
andn \T02_s, \S19_s, \S18_s
andn \T03_s, \S20_s, \S19_s;                       vxor.vv \S02_v, \S02_v, \T03_v
xor \S17_s, \T02_s, \S17_s
xor \S18_s, \T03_s, \S18_s;                        vxor.vv \S03_v, \S03_v, \T04_v
andn \T02_s, \S21_s, \S20_s
andn \T03_s, \S22_s, \S01_s;                       vxor.vv \S01_v, \T01_v, \T02_v
xor \S19_s, \T02_s, \S19_s
xor \S20_s, \T03_s, \S00_s
andn \T02_s, \S23_s, \S22_s;                       vxor.vv \S04_v, \S04_v, \T05_v
andn \T03_s, \S24_s, \S23_s
xor \S21_s, \T02_s, \S01_s
xor \S22_s, \T03_s, \S22_s
andn \T02_s, \S00_s, \S24_s
andn \T03_s, \S01_s, \S00_s
xor \S23_s, \T02_s, \S23_s
xor \S24_s, \T03_s, \S24_s
andn \T02_s, \S02_s, \T01_s
andn \T03_s, \S03_s, \S02_s;    ld   \T04_s, 17*8(sp)
xor \S00_s, \T02_s, \T00_s
xor \S01_s, \T03_s, \T01_s
andn \T02_s, \S04_s, \S03_s
andn \T03_s, \T00_s, \S04_s
xor \S02_s, \T02_s, \S02_s
andn \T02_s, \T01_s, \T00_s;   ld \T00_s, 20*8(sp);    ld \T01_s, 0(\T04_s)
xor \S03_s, \T03_s, \S03_s;    addi \T04_s, \T04_s, 8; ld \T03_s, 0(\T00_s); addi \T00_s,\T00_s,8
xor \S04_s, \T02_s, \S04_s;    sd   \T04_s, 17*8(sp);  sd \T00_s, 20*8(sp)
xor  \S00_s, \S00_s, \T01_s;                        vxor.vx \S00_v, \S00_v, \T03_s
.endm

# 15*8(sp): a0
# 16*8(sp): loop control variable i
# 17*8(sp): table index for scalar impl
# 18*8(sp), 19*8(sp): temp
# 20*8(sp): table index for vector impl
# 21*8(sp): outer loop control variable j
.globl KeccakF1600_StatePermute_RV64V_6x
.align 2
KeccakF1600_StatePermute_RV64V_6x:
    addi sp, sp, -8*22
    SaveRegs
    sd a0, 15*8(sp)
    li a1, 128
    vsetvli a2, a1, e64, m1, tu, mu

    li s11, 0
outer_loop:
    sd s11, 21*8(sp)
    # prepare table index
    la ra, constants_keccak
    sd ra, 17*8(sp)
    bnez s11, init_1th_loop
init_0th_loop:
    sd ra, 20*8(sp)
    LoadStates_v
    j init_end
init_1th_loop:
    addi a0, a0, 25*8
init_end:
    LoadStates_s \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10
    li a0, 6
inner_loop:
    sd a0, 16*8(sp)
    ARoundInPlace \
        v0,  v1,  v2,  v3,  v4,  v5,  v6,  v7,  v8,  v9,    \
        v10, v11, v12, v13, v14, v15, v16, v17, v18, v19,   \
        v20, v21, v22, v23, v24, v25, v26, v27, v28, v29,   \
        v30, v31, \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2,             \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5,             \
        s6, s7, s8, s9, s10,s11,ra, gp, tp, a0
    ld a0, 16*8(sp)
    addi a0, a0, -1
    bnez a0, inner_loop

    ld a0, 15*8(sp)
    ld s11, 21*8(sp)
    addi gp, s11, -3
    beqz gp, final_last_loop
final_no_last_loop:
    addi a0, a0, 25*16
    j final_end
final_last_loop:
    StoreStates_v
final_end:
    li ra, 25*8
    mul ra, ra, s11
    add a0, a0, ra
    StoreStates_s \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10
    addi s11, s11, 1
    li   ra, 4
    blt  s11, ra, outer_loop

    RestoreRegs
    addi sp, sp, 8*22
    ret
