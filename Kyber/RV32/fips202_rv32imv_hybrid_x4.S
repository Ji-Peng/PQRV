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

.macro SaveRegs
    sw s0,  0*4(sp)
    sw s1,  1*4(sp)
    sw s2,  2*4(sp)
    sw s3,  3*4(sp)
    sw s4,  4*4(sp)
    sw s5,  5*4(sp)
    sw s6,  6*4(sp)
    sw s7,  7*4(sp)
    sw s8,  8*4(sp)
    sw s9,  9*4(sp)
    sw s10, 10*4(sp)
    sw s11, 11*4(sp)
    sw gp,  12*4(sp)
    sw tp,  13*4(sp)
    sw ra,  14*4(sp)
.endm

.macro RestoreRegs
    lw s0,  0*4(sp)
    lw s1,  1*4(sp)
    lw s2,  2*4(sp)
    lw s3,  3*4(sp)
    lw s4,  4*4(sp)
    lw s5,  5*4(sp)
    lw s6,  6*4(sp)
    lw s7,  7*4(sp)
    lw s8,  8*4(sp)
    lw s9,  9*4(sp)
    lw s10, 10*4(sp)
    lw s11, 11*4(sp)
    lw gp,  12*4(sp)
    lw tp,  13*4(sp)
    lw ra,  14*4(sp)
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

.macro LoadStates_s \
        S02h_s, S02l_s, S04h_s, S04l_s, S05h_s, S05l_s, S08h_s, S08l_s, S10h_s, S10l_s, \
        S14h_s, S14l_s, S16h_s, S16l_s, S17h_s, S17l_s, S21h_s, S21l_s, S23h_s, S23l_s, \
        T00h_s, T00l_s, T01h_s, T01l_s, T02h_s, T02l_s, T03h_s, T03l_s, T04_s
    lw \S02l_s, 2*8(a0)
    lw \S02h_s, 2*8+4(a0)
    lw \S04l_s, 4*8(a0)
    lw \S04h_s, 4*8+4(a0)
    lw \S05l_s, 5*8(a0)
    lw \S05h_s, 5*8+4(a0)
    lw \S08l_s, 8*8(a0)
    lw \S08h_s, 8*8+4(a0)
    lw \S10l_s, 10*8(a0)
    lw \S10h_s, 10*8+4(a0)
    lw \S14l_s, 14*8(a0)
    lw \S14h_s, 14*8+4(a0)
    lw \S16l_s, 16*8(a0)
    lw \S16h_s, 16*8+4(a0)
    lw \S17l_s, 17*8(a0)
    lw \S17h_s, 17*8+4(a0)
    lw \S21l_s, 21*8(a0)
    lw \S21h_s, 21*8+4(a0)
    # lane complement: 1,2,8,12,17,20
    lw \T00l_s, 1*8(a0)
    lw \T00h_s, 1*8+4(a0)
    lw \S23l_s, 23*8(a0)
    lw \S23h_s, 23*8+4(a0)
    not \T00l_s, \T00l_s
    not \T00h_s, \T00h_s
    lw \T01l_s, 12*8(a0)
    lw \T01h_s, 12*8+4(a0)
    sw \T00l_s, 1*8(a0)
    sw \T00h_s, 1*8+4(a0)
    not \T01l_s, \T01l_s
    not \T01h_s, \T01h_s
    lw \T00l_s, 20*8(a0)
    lw \T00h_s, 20*8+4(a0)
    sw \T01l_s, 12*8(a0)
    sw \T01h_s, 12*8+4(a0)
    not \T00l_s, \T00l_s
    not \T00h_s, \T00h_s
    not \S02l_s, \S02l_s
    not \S02h_s, \S02h_s
    sw \T00l_s, 20*8(a0)
    sw \T00h_s, 20*8+4(a0)
    not \S08l_s, \S08l_s
    not \S08h_s, \S08h_s
    not \S17l_s, \S17l_s
    not \S17h_s, \S17h_s
.endm

.macro StoreStates_s \
        S02h_s, S02l_s, S04h_s, S04l_s, S05h_s, S05l_s, S08h_s, S08l_s, S10h_s, S10l_s, \
        S14h_s, S14l_s, S16h_s, S16l_s, S17h_s, S17l_s, S21h_s, S21l_s, S23h_s, S23l_s, \
        T00h_s, T00l_s, T01h_s, T01l_s, T02h_s, T02l_s, T03h_s, T03l_s
    # lane complement: 1,2,8,12,17,20
    lw \T00l_s, 1*8(a0)
    lw \T00h_s, 1*8+4(a0)
    not \S02l_s, \S02l_s
    not \S02h_s, \S02h_s
    not \T00l_s, \T00l_s
    not \T00h_s, \T00h_s
    sw \T00l_s, 1*8(a0)
    sw \T00h_s, 1*8+4(a0)
    lw \T01l_s, 12*8(a0)
    lw \T01h_s, 12*8+4(a0)
    not \S08l_s, \S08l_s
    not \S08h_s, \S08h_s
    not \T01l_s, \T01l_s
    not \T01h_s, \T01h_s
    sw \T01l_s, 12*8(a0)
    sw \T01h_s, 12*8+4(a0)
    lw \T00l_s, 20*8(a0)
    lw \T00h_s, 20*8+4(a0)
    not \S17l_s, \S17l_s
    not \S17h_s, \S17h_s
    not \T00l_s, \T00l_s
    not \T00h_s, \T00h_s
    sw \T00l_s, 20*8(a0)
    sw \T00h_s, 20*8+4(a0)
    sw \S02l_s, 2*8(a0)
    sw \S02h_s, 2*8+4(a0)
    sw \S04l_s, 4*8(a0)
    sw \S04h_s, 4*8+4(a0)
    sw \S05l_s, 5*8(a0)
    sw \S05h_s, 5*8+4(a0)
    sw \S08l_s, 8*8(a0)
    sw \S08h_s, 8*8+4(a0)
    sw \S10l_s, 10*8(a0)
    sw \S10h_s, 10*8+4(a0)
    sw \S14l_s, 14*8(a0)
    sw \S14h_s, 14*8+4(a0)
    sw \S16l_s, 16*8(a0)
    sw \S16h_s, 16*8+4(a0)
    sw \S17l_s, 17*8(a0)
    sw \S17h_s, 17*8+4(a0)
    sw \S21l_s, 21*8(a0)
    sw \S21h_s, 21*8+4(a0)
    sw \S23l_s, 23*8(a0)
    sw \S23h_s, 23*8+4(a0)
.endm

.macro ARound  \
        S00_v, S01_v, S02_v, S03_v, S04_v, S05_v, S06_v, S07_v, S08_v, S09_v, \
        S10_v, S11_v, S12_v, S13_v, S14_v, S15_v, S16_v, S17_v, S18_v, S19_v, \
        S20_v, S21_v, S22_v, S23_v, S24_v, T00_v, T01_v, T02_v, T03_v, T04_v, \
        S02h_s, S02l_s, S04h_s, S04l_s, S05h_s, S05l_s, S08h_s, S08l_s, S10h_s, S10l_s, \
        S14h_s, S14l_s, S16h_s, S16l_s, S17h_s, S17l_s, S21h_s, S21l_s, S23h_s, S23l_s, \
        T00h_s, T00l_s, T01h_s, T01l_s, T02h_s, T02l_s, T03h_s, T03l_s, T04_s
    lw \T03l_s, 0*8(a0)
    lw \T03h_s, 0*8+4(a0)
    xor \T00h_s, \S05h_s, \S10h_s
    xor \T00l_s, \S05l_s, \S10l_s
    lw \T02l_s, 15*8(a0)
    lw \T02h_s, 15*8+4(a0);                 vxor.vv \T00_v, \S00_v, \S05_v
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s
    lw \T03l_s, 20*8(a0)
    lw \T03h_s, 20*8+4(a0)
    xor \T00h_s, \T00h_s, \T02h_s
    xor \T00l_s, \T00l_s, \T02l_s;          vxor.vv \T00_v, \T00_v, \S10_v
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s
    sw \T00l_s, 18*4(sp)
    sw \T00h_s, 19*4(sp)
    lw \T03l_s, 3*8(a0)
    lw \T03h_s, 3*8+4(a0);                  vxor.vv \T00_v, \T00_v, \S15_v
    xor \T01h_s, \S08h_s, \S23h_s
    xor \T01l_s, \S08l_s, \S23l_s
    lw \T02l_s, 13*8(a0)
    lw \T02h_s, 13*8+4(a0)
    xor \T01h_s, \T01h_s, \T03h_s
    xor \T01l_s, \T01l_s, \T03l_s;          vxor.vv \T00_v, \T00_v, \S20_v
    lw \T03l_s, 18*8(a0)
    lw \T03h_s, 18*8+4(a0)
    xor \T01h_s, \T01h_s, \T02h_s
    xor \T01l_s, \T01l_s, \T02l_s
    xor \T01h_s, \T01h_s, \T03h_s
    xor \T01l_s, \T01l_s, \T03l_s;          vxor.vv \T01_v, \S02_v, \S07_v
    sw \T01l_s, 24*4(sp)
    sw \T01h_s, 25*4(sp)
    srli \T03h_s, \T00l_s, 31
    slli \T00l_s, \T00l_s, 1
    srli \T03l_s, \T00h_s, 31
    slli \T00h_s, \T00h_s, 1;               vxor.vv \T01_v, \T01_v, \S12_v
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00h_s, \T00h_s, \T01h_s
    xor \T00l_s, \T00l_s, \T01l_s
    lw \T03l_s, 9*8(a0)
    lw \T03h_s, 9*8+4(a0);                  vxor.vv \T01_v, \T01_v, \S17_v
    xor \T01h_s, \S04h_s, \S14h_s
    xor \T01l_s, \S04l_s, \S14l_s
    xor \S04h_s, \S04h_s, \T00h_s
    xor \S04l_s, \S04l_s, \T00l_s
    xor \S14h_s, \S14h_s, \T00h_s
    xor \S14l_s, \S14l_s, \T00l_s;          vxor.vv \T01_v, \T01_v, \S22_v
    lw \T02l_s, 19*8(a0)
    lw \T02h_s, 19*8+4(a0)
    xor \T01h_s, \T01h_s, \T03h_s
    xor \T01l_s, \T01l_s, \T03l_s;          li \T04_s, 64-1
    xor \T03h_s, \T03h_s, \T00h_s;          vsll.vi \T03_v, \T01_v, 1
    xor \T03l_s, \T03l_s, \T00l_s
    sw \T03l_s, 9*8(a0)
    sw \T03h_s, 9*8+4(a0)
    lw \T03l_s, 24*8(a0)
    lw \T03h_s, 24*8+4(a0)
    xor \T01h_s, \T01h_s, \T02h_s
    xor \T01l_s, \T01l_s, \T02l_s;          vsrl.vx \T02_v, \T01_v, \T04_s
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    sw \T02l_s, 19*8(a0)
    sw \T02h_s, 19*8+4(a0)
    xor \T01h_s, \T01h_s, \T03h_s
    xor \T01l_s, \T01l_s, \T03l_s
    xor \T03h_s, \T03h_s, \T00h_s;          vxor.vv \T02_v, \T02_v, \T03_v
    xor \T03l_s, \T03l_s, \T00l_s
    sw \T03l_s, 24*8(a0)
    sw \T03h_s, 24*8+4(a0)
    sw \T01l_s, 26*4(sp)
    sw \T01h_s, 27*4(sp)
    lw \T03l_s, 1*8(a0)
    lw \T03h_s, 1*8+4(a0);                  vxor.vv  \T02_v, \T02_v, \T00_v
    xor \T00h_s, \S16h_s, \S21h_s
    xor \T00l_s, \S16l_s, \S21l_s
    lw \T02l_s, 6*8(a0)
    lw \T02h_s, 6*8+4(a0)
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s
    lw \T03l_s, 11*8(a0);                   vxor.vv \T03_v, \S01_v, \S06_v
    lw \T03h_s, 11*8+4(a0)
    xor \T00h_s, \T00h_s, \T02h_s
    xor \T00l_s, \T00l_s, \T02l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s
    sw \T00l_s, 20*4(sp);                   vxor.vv \T03_v, \T03_v, \S11_v
    sw \T00h_s, 21*4(sp)
    srli \T03h_s, \T00l_s, 32-1
    slli \T00l_s, \T00l_s, 1
    srli \T03l_s, \T00h_s, 32-1
    slli \T00h_s, \T00h_s, 1
    xor \T00l_s, \T00l_s, \T03l_s;          vxor.vv \T03_v, \T03_v, \S16_v
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00h_s, \T00h_s, \T01h_s
    xor \T00l_s, \T00l_s, \T01l_s
    lw \T02l_s, 0*8(a0)
    lw \T02h_s, 0*8+4(a0)
    xor \S05h_s, \S05h_s, \T00h_s;          vxor.vv \T03_v, \T03_v, \S21_v
    xor \S05l_s, \S05l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    sw \T02l_s, 0*8(a0)
    sw \T02h_s, 0*8+4(a0)
    lw \T02l_s, 15*8(a0);                   vxor.vv \S01_v, \S01_v, \T02_v
    lw \T02h_s, 15*8+4(a0)
    xor \S10h_s, \S10h_s, \T00h_s
    xor \S10l_s, \S10l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    sw \T02l_s, 15*8(a0);                   vxor.vv \S06_v, \S06_v, \T02_v
    sw \T02h_s, 15*8+4(a0)
    lw \T03l_s, 20*8(a0)
    lw \T03h_s, 20*8+4(a0)
    xor \T03h_s, \T03h_s, \T00h_s
    xor \T03l_s, \T03l_s, \T00l_s
    sw \T02l_s, 15*8(a0);                   vxor.vv \S11_v, \S11_v, \T02_v
    sw \T02h_s, 15*8+4(a0)
    sw \T03l_s, 20*8(a0)
    sw \T03h_s, 20*8+4(a0)
    lw \T02l_s, 24*4(sp)
    lw \T02h_s, 25*4(sp)
    lw \T00l_s, 20*4(sp);                   vxor.vv \S16_v, \S16_v, \T02_v
    lw \T00h_s, 21*4(sp)
    srli \T03h_s, \T02l_s, 32-1
    slli \T02l_s, \T02l_s, 1
    srli \T03l_s, \T02h_s, 32-1
    slli \T02h_s, \T02h_s, 1
    xor \T02l_s, \T02l_s, \T03l_s;          vxor.vv \S21_v, \S21_v, \T02_v
    xor \T02h_s, \T02h_s, \T03h_s
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    lw \T03l_s, 7*8(a0)
    lw \T03h_s, 7*8+4(a0)
    xor \T00h_s, \S02h_s, \S17h_s;          vxor.vv \T02_v, \S04_v, \S09_v
    xor \T00l_s, \S02l_s, \S17l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T03h_s, \T03h_s, \T02h_s
    xor \T03l_s, \T03l_s, \T02l_s
    sw \T03l_s, 7*8(a0)
    sw \T03h_s, 7*8+4(a0);                  vxor.vv \T02_v, \T02_v, \S14_v
    lw \T03l_s, 12*8(a0)
    lw \T03h_s, 12*8+4(a0)
    xor \S02h_s, \S02h_s, \T02h_s
    xor \S02l_s, \S02l_s, \T02l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T03h_s, \T03h_s, \T02h_s;          vxor.vv \T02_v, \T02_v, \S19_v
    xor \T03l_s, \T03l_s, \T02l_s
    sw \T03l_s, 12*8(a0)
    sw \T03h_s, 12*8+4(a0)
    lw \T03l_s, 22*8(a0)
    lw \T03h_s, 22*8+4(a0)
    xor \S17h_s, \S17h_s, \T02h_s
    xor \S17l_s, \S17l_s, \T02l_s;          vxor.vv \T02_v, \T02_v, \S24_v
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T03h_s, \T03h_s, \T02h_s
    xor \T03l_s, \T03l_s, \T02l_s
    sw \T03l_s, 22*8(a0)
    sw \T03h_s, 22*8+4(a0)
    sw \T00l_s, 22*4(sp);                   vsll.vi \T04_v, \T02_v, 1
    sw \T00h_s, 23*4(sp)
    srli \T03h_s, \T01l_s, 32-1
    slli \T01l_s, \T01l_s, 1
    srli \T03l_s, \T01h_s, 32-1
    slli \T01h_s, \T01h_s, 1
    xor \T01l_s, \T01l_s, \T03l_s;          vxor.vv \T01_v, \T01_v, \T04_v
    xor \T01h_s, \T01h_s, \T03h_s
    xor \T01h_s, \T01h_s, \T00h_s
    xor \T01l_s, \T01l_s, \T00l_s
    lw \T03l_s, 3*8(a0);                    li \T04_s, 63
    lw \T03h_s, 3*8+4(a0);                  vsrl.vx \T04_v, \T02_v, \T04_s
    xor \S08h_s, \S08h_s, \T01h_s
    xor \S08l_s, \S08l_s, \T01l_s
    xor \T03h_s, \T03h_s, \T01h_s
    xor \T03l_s, \T03l_s, \T01l_s
    sw \T03l_s, 3*8(a0)
    sw \T03h_s, 3*8+4(a0);                  vxor.vv \T01_v, \T01_v, \T04_v
    lw \T02l_s, 13*8(a0)
    lw \T02h_s, 13*8+4(a0)
    xor \S23h_s, \S23h_s, \T01h_s
    xor \S23l_s, \S23l_s, \T01l_s
    xor \T02h_s, \T02h_s, \T01h_s
    xor \T02l_s, \T02l_s, \T01l_s;          vxor.vv \T04_v, \S03_v, \S08_v
    sw \T02l_s, 13*8(a0)
    sw \T02h_s, 13*8+4(a0)
    lw \T03l_s, 18*8(a0)
    lw \T03h_s, 18*8+4(a0)
    xor \T03h_s, \T03h_s, \T01h_s
    xor \T03l_s, \T03l_s, \T01l_s;          vxor.vv \T04_v, \T04_v, \S13_v
    sw \T02l_s, 13*8(a0)
    sw \T02h_s, 13*8+4(a0)
    sw \T03l_s, 18*8(a0)
    sw \T03h_s, 18*8+4(a0)
    lw \T01l_s, 18*4(sp)
    lw \T01h_s, 19*4(sp);                   vxor.vv \T04_v, \T04_v, \S18_v
    srli \T03h_s, \T00l_s, 32-1
    slli \T00l_s, \T00l_s, 1
    srli \T03l_s, \T00h_s, 32-1
    slli \T00h_s, \T00h_s, 1
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s;          vxor.vv \T04_v, \T04_v, \S23_v
    xor \T00h_s, \T00h_s, \T01h_s
    xor \T00l_s, \T00l_s, \T01l_s
    lw \T02l_s, 1*8(a0)
    lw \T02h_s, 1*8+4(a0)
    xor \S16h_s, \S16h_s, \T00h_s
    xor \S16l_s, \S16l_s, \T00l_s;          vxor.vv \S03_v, \S03_v, \T01_v
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    sw \T02l_s, 1*8(a0)
    sw \T02h_s, 1*8+4(a0)
    lw \T03l_s, 6*8(a0)
    lw \T03h_s, 6*8+4(a0);                  vxor.vv \S08_v, \S08_v, \T01_v
    xor \S21h_s, \S21h_s, \T00h_s
    xor \S21l_s, \S21l_s, \T00l_s
    xor \T03h_s, \T03h_s, \T00h_s
    xor \T03l_s, \T03l_s, \T00l_s
    lw \T02l_s, 11*8(a0)
    lw \T02h_s, 11*8+4(a0)
    sw \T03l_s, 6*8(a0);                    vxor.vv \S13_v, \S13_v, \T01_v
    sw \T03h_s, 6*8+4(a0)
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    sw \T02l_s, 11*8(a0)
    sw \T02h_s, 11*8+4(a0)
    lw \T00l_s, 0*8(a0)
    lw \T00h_s, 0*8+4(a0);                  vxor.vv \S18_v, \S18_v, \T01_v
    lw \T01l_s, 6*8(a0)
    lw \T01h_s, 6*8+4(a0)
    slli \T03l_s, \S21l_s, 2
    srli \S21l_s, \S21l_s, 32-2
    srli \T03h_s, \S21h_s, 32-2
    xor  \T03l_s, \T03l_s, \T03h_s
    slli \T03h_s, \S21h_s, 2;               vxor.vv \S23_v, \S23_v, \T01_v
    xor  \T03h_s, \T03h_s, \S21l_s
    slli \T02h_s,  \T01l_s, 44-32
    srli \T01l_s, \T01l_s, 64-44
    slli \T02l_s,  \T01h_s, 44-32
    xor  \T01l_s, \T01l_s, \T02l_s;         li \T04_s, 64-1
    srli \T01h_s, \T01h_s, 64-44;           vsll.vi \T01_v, \T00_v, 1
    xor  \T01h_s, \T01h_s, \T02h_s
    sw \T03l_s, 0*8(a0)
    sw \T03h_s, 0*8+4(a0)
    slli \S21h_s, \S08l_s, 55-32
    srli \S08l_s, \S08l_s, 64-55
    srli \S21l_s, \S08h_s, 64-55;           vsrl.vx \T00_v, \T00_v, \T04_s
    xor  \S21h_s, \S21h_s, \S21l_s
    slli \S21l_s, \S08h_s, 55-32
    xor  \S21l_s, \S21l_s, \S08l_s
    slli \S08h_s, \S16l_s, 45-32
    srli \S16l_s, \S16l_s, 64-45
    srli \S08l_s, \S16h_s, 64-45;           vxor.vv \T00_v, \T00_v, \T01_v
    xor  \S08h_s, \S08h_s, \S08l_s
    slli \S08l_s, \S16h_s, 45-32
    xor  \S08l_s, \S08l_s, \S16l_s
    lw \T02l_s, 3*8(a0)
    lw \T02h_s, 3*8+4(a0)
    slli \S16h_s, \S05l_s, 36-32;           vxor.vv \T00_v, \T00_v, \T04_v
    srli \S05l_s, \S05l_s, 64-36
    srli \S16l_s, \S05h_s, 64-36
    xor  \S16h_s, \S16h_s, \S16l_s
    slli \S16l_s, \S05h_s, 36-32
    xor  \S16l_s, \S16l_s, \S05l_s
    lw \T03l_s, 18*8(a0);                   vxor.vv \S04_v, \S04_v, \T00_v
    lw \T03h_s, 18*8+4(a0)
    slli \S05l_s, \T02l_s, 28
    srli \T02l_s, \T02l_s, 32-28
    srli \S05h_s, \T02h_s, 32-28
    xor  \S05l_s, \S05l_s, \S05h_s
    slli \S05h_s, \T02h_s, 28;              vxor.vv \S09_v, \S09_v, \T00_v
    xor  \S05h_s, \S05h_s, \T02l_s
    slli \T02l_s, \T03l_s, 21
    srli \T03l_s, \T03l_s, 32-21
    srli \T02h_s, \T03h_s, 32-21
    xor  \T02l_s, \T02l_s, \T02h_s
    slli \T02h_s, \T03h_s, 21;              vxor.vv \S14_v, \S14_v, \T00_v
    xor  \T02h_s, \T02h_s, \T03l_s
    lw \T03l_s, 13*8(a0)
    lw \T03h_s, 13*8+4(a0)
    sw \T02l_s, 3*8(a0)
    sw \T02h_s, 3*8+4(a0)
    srli \T02h_s,  \T03l_s, 32-25;          vxor.vv \S19_v, \S19_v, \T00_v
    slli \T03l_s, \T03l_s, 25
    srli \T02l_s,   \T03h_s, 32-25
    slli \T03h_s, \T03h_s, 25
    xor  \T03l_s, \T03l_s, \T02l_s
    xor  \T03h_s, \T03h_s, \T02h_s
    sw \T03l_s, 18*8(a0);                   vxor.vv \S24_v, \S24_v, \T00_v
    sw \T03h_s, 18*8+4(a0)
    slli \T02l_s, \S10l_s, 3
    srli \S10l_s, \S10l_s, 32-3
    srli \T02h_s, \S10h_s, 32-3;            li \T04_s, 64-1
    xor  \T02l_s, \T02l_s, \T02h_s;         vsll.vi \T01_v, \T04_v, 1
    slli \T02h_s, \S10h_s, 3
    xor  \T02h_s, \T02h_s, \S10l_s
    lw \T03l_s, 1*8(a0)
    lw \T03h_s, 1*8+4(a0)
    sw \T02l_s, 13*8(a0)
    sw \T02h_s, 13*8+4(a0)
    slli \S10l_s, \T03l_s, 1;               vsrl.vx \T04_v, \T04_v, \T04_s
    srli \T03l_s, \T03l_s, 32-1
    srli \S10h_s, \T03h_s, 32-1
    xor  \S10l_s, \S10l_s, \S10h_s
    slli \S10h_s, \T03h_s, 1
    xor  \S10h_s, \S10h_s, \T03l_s
    slli \T02l_s, \S02h_s, 62-32
    srli \S02h_s, \S02h_s, 64-62;           vxor.vv \T04_v, \T04_v, \T01_v
    srli \T02h_s, \S02l_s, 64-62
    xor  \T02l_s, \T02l_s, \T02h_s
    slli \T02h_s, \S02l_s, 62-32
    xor  \T02h_s, \T02h_s, \S02h_s
    lw \T03l_s, 12*8(a0)
    lw \T03h_s, 12*8+4(a0)
    sw \T02l_s, 1*8(a0);                    vxor.vv  \T04_v, \T04_v, \T03_v
    sw \T02h_s, 1*8+4(a0)
    lw \T02l_s, 9*8(a0)
    lw \T02h_s, 9*8+4(a0)
    slli \S02l_s, \T03h_s, 43-32
    srli \T03h_s, \T03h_s, 64-43
    srli \S02h_s, \T03l_s, 64-43
    xor  \S02l_s, \S02l_s, \S02h_s;         vxor.vv \S02_v, \S02_v, \T04_v
    slli \S02h_s, \T03l_s, 43-32
    xor  \S02h_s, \S02h_s, \T03h_s
    slli \T03l_s, \T02l_s, 20
    srli \T02l_s, \T02l_s, 32-20
    srli \T03h_s, \T02h_s, 32-20
    xor  \T03l_s, \T03l_s, \T03h_s;         vxor.vv \S07_v, \S07_v, \T04_v
    slli \T03h_s, \T02h_s, 20
    xor  \T03h_s, \T03h_s, \T02l_s
    lw \T02l_s, 22*8(a0)
    lw \T02h_s, 22*8+4(a0)
    sw \T03l_s, 12*8(a0)
    sw \T03h_s, 12*8+4(a0);                 vxor.vv \S12_v, \S12_v, \T04_v
    slli \T03h_s,  \T02l_s, 61-32
    srli \T02l_s, \T02l_s, 64-61
    slli \T03l_s, \T02h_s, 61-32
    xor  \T02l_s, \T02l_s, \T03l_s
    srli \T02h_s, \T02h_s, 64-61
    xor  \T02h_s, \T02h_s, \T03h_s;         vxor.vv \S17_v, \S17_v, \T04_v
    sw \T02l_s, 9*8(a0)
    sw \T02h_s, 9*8+4(a0)
    slli \T03l_s, \S14h_s, 39-32
    srli \S14h_s, \S14h_s, 64-39
    srli \T03h_s, \S14l_s, 64-39
    xor  \T03l_s, \T03l_s, \T03h_s;         vxor.vv \S22_v, \S22_v, \T04_v
    slli \T03h_s, \S14l_s, 39-32
    xor  \T03h_s, \T03h_s, \S14h_s
    lw \T02l_s, 20*8(a0)
    lw \T02h_s, 20*8+4(a0);                 li \T04_s, 64-1
    sw \T03l_s, 22*8(a0);                   vsll.vi \T01_v, \T03_v, 1
    sw \T03h_s, 22*8+4(a0)
    slli \S14l_s, \T02l_s, 18
    srli \T02l_s, \T02l_s, 32-18
    srli \S14h_s, \T02h_s, 32-18
    xor  \S14l_s, \S14l_s, \S14h_s
    slli \S14h_s, \T02h_s, 18;              vsrl.vx \T03_v, \T03_v, \T04_s
    xor  \S14h_s, \S14h_s, \T02l_s
    slli \T02l_s, \S23h_s, 56-32
    srli \S23h_s, \S23h_s, 64-56
    srli \T02h_s, \S23l_s, 64-56
    xor  \T02l_s, \T02l_s, \T02h_s
    slli \T02h_s, \S23l_s, 56-32;           vxor.vv \T03_v, \T03_v, \T01_v
    xor  \T02h_s, \T02h_s, \S23h_s
    lw \T03l_s, 15*8(a0)
    lw \T03h_s, 15*8+4(a0)
    sw \T02l_s, 20*8(a0)
    sw \T02h_s, 20*8+4(a0)
    slli \S23l_s, \T03h_s, 41-32;           vxor.vv  \T03_v, \T03_v, \T02_v
    srli \T03h_s, \T03h_s, 64-41
    srli \S23h_s, \T03l_s, 64-41
    xor  \S23l_s, \S23l_s, \S23h_s
    slli \S23h_s, \T03l_s, 41-32
    xor  \S23h_s, \S23h_s, \T03h_s  
    slli \T02l_s, \S04l_s, 27;              vxor.vv \S05_v, \S05_v, \T03_v
    srli \S04l_s, \S04l_s, 32-27
    srli \T02h_s, \S04h_s, 32-27
    xor  \T02l_s, \T02l_s, \T02h_s
    slli \T02h_s, \S04h_s, 27
    xor  \T02h_s, \T02h_s, \S04l_s    
    lw \T03l_s, 24*8(a0)
    lw \T03h_s, 24*8+4(a0);                 vxor.vv \S10_v, \S10_v, \T03_v
    sw \T02l_s, 15*8(a0)
    sw \T02h_s, 15*8+4(a0)
    slli \S04l_s, \T03l_s, 14
    srli \T03l_s, \T03l_s, 32-14
    srli \S04h_s, \T03h_s, 32-14
    xor  \S04l_s, \S04l_s, \S04h_s
    slli \S04h_s, \T03h_s, 14;              vxor.vv \S15_v, \S15_v, \T03_v
    xor  \S04h_s, \S04h_s, \T03l_s
    slli \T02l_s, \S17l_s, 15
    srli \S17l_s, \S17l_s, 32-15
    srli \T02h_s, \S17h_s, 32-15
    xor  \T02l_s, \T02l_s, \T02h_s
    slli \T02h_s, \S17h_s, 15
    xor  \T02h_s, \T02h_s, \S17l_s;         vxor.vv \S20_v, \S20_v, \T03_v
    lw \T03l_s, 11*8(a0)
    lw \T03h_s, 11*8+4(a0)
    sw \T02l_s, 24*8(a0)
    sw \T02h_s, 24*8+4(a0)
    lw \T02h_s, 7*8(a0)
    lw \T02l_s, 7*8+4(a0)
    slli \S17l_s, \T03l_s, 10;              vxor.vv \T00_v, \S00_v, \T03_v
    srli \T03l_s, \T03l_s, 32-10
    srli \S17h_s, \T03h_s, 32-10
    xor  \S17l_s, \S17l_s, \S17h_s
    slli \S17h_s, \T03h_s, 10;              li \T04_s, 44
    xor  \S17h_s, \S17h_s, \T03l_s;         vsll.vx \T02_v, \S06_v, \T04_s
    srli \T03h_s,   \T02h_s, 32-6
    slli \T02h_s, \T02h_s, 6
    srli \T03l_s,   \T02l_s, 32-6
    slli \T02l_s, \T02l_s, 6
    xor  \T02h_s, \T02h_s, \T03l_s
    xor  \T02l_s, \T02l_s, \T03h_s;         vsrl.vi \T01_v, \S06_v, 64-44
    lw \T03l_s, 19*8(a0)
    lw \T03h_s, 19*8+4(a0)
    sw \T02h_s, 11*8(a0)
    sw \T02l_s, 11*8+4(a0)
    srli \T02h_s,   \T03l_s, 32-8
    slli \T03l_s, \T03l_s, 8;               vxor.vv \T01_v, \T01_v, \T02_v
    srli \T02l_s,   \T03h_s, 32-8
    slli \T03h_s, \T03h_s, 8
    xor  \T03l_s, \T03l_s, \T02l_s
    xor  \T03h_s, \T03h_s, \T02h_s;         li \T04_s, 62
    sw \T00l_s, 18*4(sp);                   vsll.vx \T03_v, \S02_v, \T04_s
    sw \T00h_s, 19*4(sp)
    sw \T01l_s, 20*4(sp)
    sw \T01h_s, 21*4(sp)
    sw \T03l_s, 19*8(a0)
    sw \T03h_s, 19*8+4(a0)
    lw \T01l_s, 13*8(a0);                   vsrl.vi \S00_v, \S02_v, 64-62
    lw \T01h_s, 13*8+4(a0)
    lw \T00l_s, 12*8(a0)
    lw \T00h_s, 12*8+4(a0)
    and \T03h_s, \T01h_s, \S08h_s
    and \T03l_s, \T01l_s, \S08l_s
    xor \T03h_s, \T00h_s, \T03h_s;          vxor.vv \S00_v, \S00_v, \T03_v
    xor \T03l_s, \T00l_s, \T03l_s
    lw \T02l_s, 9*8(a0)
    lw \T02h_s, 9*8+4(a0)
    sw \T03l_s, 6*8(a0);                    li \T04_s, 43
    sw \T03h_s, 6*8+4(a0);                  vsll.vx \T02_v, \S12_v, \T04_s
    not \T03h_s, \T02h_s
    not \T03l_s, \T02l_s
    or \T03h_s, \T03h_s, \S08h_s
    or \T03l_s, \T03l_s, \S08l_s
    xor \T03h_s, \T01h_s, \T03h_s
    xor \T03l_s, \T01l_s, \T03l_s;          vsrl.vi \S02_v, \S12_v, 64-43
    sw \T03l_s, 7*8(a0)
    sw \T03h_s, 7*8+4(a0)
    or \T03h_s, \T02h_s, \S05h_s
    or \T03l_s, \T02l_s, \S05l_s
    xor \S08h_s, \S08h_s, \T03h_s
    xor \S08l_s, \S08l_s, \T03l_s;          vxor.vv \S02_v, \S02_v, \T02_v
    and \T03h_s, \S05h_s, \T00h_s
    and \T03l_s, \S05l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T03h_s
    xor \T02l_s, \T02l_s, \T03l_s
    sw \T02l_s, 9*8(a0);                    li \T04_s, 64-25
    or  \T03l_s, \T00l_s, \T01l_s;          vsll.vi \T03_v, \S13_v, 25
    sw \T02h_s, 9*8+4(a0)
    or  \T03h_s, \T00h_s, \T01h_s
    lw \T01l_s, 19*8(a0)
    xor \S05h_s, \S05h_s, \T03h_s
    lw \T01h_s, 19*8+4(a0)
    xor \S05l_s, \S05l_s, \T03l_s
    lw \T02l_s, 11*8(a0);                   vsrl.vx \S12_v, \S13_v, \T04_s
    lw \T02h_s, 11*8+4(a0)
    lw \T00l_s, 18*8(a0)
    lw \T00h_s, 18*8+4(a0)
    not \T03h_s, \T01h_s
    not \T03l_s, \T01l_s
    and \T03h_s, \T03h_s, \S14h_s
    and \T03l_s, \T03l_s, \S14l_s;          vxor.vv \S12_v, \S12_v, \T03_v
    xor \T03h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T00l_s, \T03l_s;          sw \S08l_s, 28*4(sp)
    sw \T03l_s, 12*8(a0)
    sw \T03h_s, 12*8+4(a0)
    not \T04_s, \T01h_s;                    li \S08l_s, 64-8
    or  \T03h_s, \S14h_s, \S10h_s;          vsll.vi \T02_v, \S19_v, 8
    xor \T03h_s, \T03h_s, \T04_s
    not \T04_s, \T01l_s
    or  \T03l_s, \S14l_s, \S10l_s
    xor \T03l_s, \T03l_s, \T04_s
    sw \T03l_s, 13*8(a0)
    sw \T03h_s, 13*8+4(a0);                 vsrl.vx \S13_v, \S19_v, \S08l_s
    and \T03h_s, \S10h_s, \T02h_s
    and \T03l_s, \S10l_s, \T02l_s
    xor \S14h_s, \S14h_s, \T03h_s
    xor \S14l_s, \S14l_s, \T03l_s
    or \T03h_s, \T02h_s, \T00h_s
    or \T03l_s, \T02l_s, \T00l_s;           vxor.vv \S13_v, \S13_v, \T02_v
    xor \S10h_s, \S10h_s, \T03h_s
    xor \S10l_s, \S10l_s, \T03l_s
    and \T03h_s, \T00h_s, \T01h_s
    and \T03l_s, \T00l_s, \T01l_s;          li \S08l_s, 56
    xor \T02h_s, \T02h_s, \T03h_s;          vsll.vx \T03_v, \S23_v, \S08l_s
    xor \T02l_s, \T02l_s, \T03l_s
    lw \T01l_s, 20*8(a0)
    lw \T01h_s, 20*8+4(a0)
    sw \T02l_s, 11*8(a0)
    sw \T02h_s, 11*8+4(a0)
    lw \T00l_s, 24*8(a0);                   vsrl.vi \S19_v, \S23_v, 64-56
    lw \T00h_s, 24*8+4(a0)
    lw \T02l_s, 15*8(a0)
    lw \T02h_s, 15*8+4(a0)
    not \T04_s, \T00h_s
    and \T03h_s, \T01h_s, \T02h_s
    xor \T03h_s, \T03h_s, \T04_s;           vxor.vv \S19_v, \S19_v, \T03_v
    not \T04_s, \T00l_s
    and \T03l_s, \T01l_s, \T02l_s
    xor \T03l_s, \T03l_s, \T04_s
    sw \T03l_s, 18*8(a0);                   li \S08l_s, 41
    sw \T03h_s, 18*8+4(a0);                 vsll.vx \T02_v, \S15_v, \S08l_s
    or \T03h_s, \T02h_s, \S16h_s
    or \T03l_s, \T02l_s, \S16l_s
    xor \T03h_s, \T01h_s, \T03h_s
    xor \T03l_s, \T01l_s, \T03l_s
    sw \T03l_s, 19*8(a0)
    sw \T03h_s, 19*8+4(a0);                 vsrl.vi \S23_v, \S15_v, 64-41
    and \T03h_s, \S16h_s, \S17h_s
    and \T03l_s, \S16l_s, \S17l_s
    xor \T02h_s, \T02h_s, \T03h_s
    xor \T02l_s, \T02l_s, \T03l_s
    sw \T02l_s, 15*8(a0)
    sw \T02h_s, 15*8+4(a0);                 vxor.vv \S23_v, \S23_v, \T02_v
    or  \T03h_s, \S17h_s, \T00h_s
    or  \T03l_s, \S17l_s, \T00l_s
    xor \S16h_s, \S16h_s, \T03h_s
    xor \S16l_s, \S16l_s, \T03l_s;          li \S08l_s, 64-1
    lw \T02l_s, 22*8(a0);                   vsll.vi \T03_v, \S01_v, 1
    not \T03h_s, \T00h_s
    lw \T02h_s, 22*8+4(a0)
    not \T03l_s, \T00l_s
    lw \T00l_s, 0*8(a0)
    or  \T03h_s, \T03h_s, \T01h_s
    lw \T00h_s, 0*8+4(a0)
    or  \T03l_s, \T03l_s, \T01l_s;          vsrl.vx \S15_v, \S01_v, \S08l_s
    lw \T01l_s, 1*8(a0)
    xor \S17h_s, \S17h_s, \T03h_s
    lw \T01h_s, 1*8+4(a0)
    xor \S17l_s, \S17l_s, \T03l_s
    and \T03h_s, \T01h_s, \S21h_s
    and \T03l_s, \T01l_s, \S21l_s
    xor \T03h_s, \T00h_s, \T03h_s;          vxor.vv \S15_v, \S15_v, \T03_v
    xor \T03l_s, \T00l_s, \T03l_s
    sw \T03l_s, 24*8(a0)
    sw \T03h_s, 24*8+4(a0)
    not \T03h_s, \S21h_s
    not \T03l_s, \S21l_s;                   li \S08l_s, 55
    and \T03h_s, \T03h_s, \T02h_s;          vsll.vx \T02_v, \S08_v, \S08l_s
    and \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T01h_s, \T03h_s
    xor \T03l_s, \T01l_s, \T03l_s
    sw \T03l_s, 20*8(a0)
    sw \T03h_s, 20*8+4(a0)
    not \T04_s, \S21h_s
    or  \T03h_s, \T02h_s, \S23h_s;          vsrl.vi \S01_v, \S08_v, 64-55
    xor \S21h_s, \T03h_s, \T04_s
    not \T04_s, \S21l_s
    or  \T03l_s, \T02l_s, \S23l_s
    xor \S21l_s, \T03l_s, \T04_s
    and \T03h_s, \S23h_s, \T00h_s
    and \T03l_s, \S23l_s, \T00l_s;          vxor.vv \S01_v, \S01_v, \T02_v
    xor \T02h_s, \T02h_s, \T03h_s
    xor \T02l_s, \T02l_s, \T03l_s
    sw \T02l_s, 22*8(a0)
    or  \T03l_s, \T00l_s, \T01l_s;          li \S08l_s, 45
    sw \T02h_s, 22*8+4(a0);                 vsll.vx \T03_v, \S16_v, \S08l_s
    or  \T03h_s, \T00h_s, \T01h_s
    lw \T00l_s, 18*4(sp)
    xor \S23h_s, \S23h_s, \T03h_s
    lw \T00h_s, 19*4(sp)
    xor \S23l_s, \S23l_s, \T03l_s
    lw \T01l_s, 20*4(sp);                   vsrl.vi \S08_v, \S16_v, 64-45
    lw \T01h_s, 21*4(sp)
    or  \T03h_s, \T01h_s, \S02h_s
    or  \T03l_s, \T01l_s, \S02l_s
    xor \T03h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T00l_s, \T03l_s
    lw \T04_s, 17*4(sp);                    vxor.vv \S08_v, \S08_v, \T03_v
    lw \T02l_s, 0(\T04_s)
    lw \T02h_s, 4(\T04_s)
    addi \T04_s, \T04_s, 16
    sw  \T04_s, 17*4(sp);                   li \S08l_s, 64-6
    xor \T03h_s, \T03h_s, \T02h_s;          vsll.vi \T02_v, \S07_v, 6
    xor \T03l_s, \T03l_s, \T02l_s
    lw \T02l_s, 3*8(a0)
    lw \T02h_s, 3*8+4(a0)
    sw \T03l_s, 0*8(a0)
    sw \T03h_s, 0*8+4(a0)
    not \T03h_s, \S02h_s;                   vsrl.vx \S16_v, \S07_v, \S08l_s
    not \T03l_s, \S02l_s
    or \T03h_s, \T03h_s, \T02h_s;           lw \S08l_s, 28*4(sp)
    or \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T01h_s, \T03h_s
    xor \T03l_s, \T01l_s, \T03l_s
    sw \T03l_s, 1*8(a0);                    vxor.vv \S16_v, \S16_v, \T02_v
    sw \T03h_s, 1*8+4(a0)
    and \T03h_s, \T02h_s, \S04h_s
    and \T03l_s, \T02l_s, \S04l_s
    xor \S02h_s, \S02h_s, \T03h_s;          li \T04_s, 64-3
    xor \S02l_s, \S02l_s, \T03l_s;          vsll.vi \T03_v, \S10_v, 3
    or  \T03h_s, \S04h_s, \T00h_s
    or  \T03l_s, \S04l_s, \T00l_s
    xor \T03h_s, \T02h_s, \T03h_s
    xor \T03l_s, \T02l_s, \T03l_s
    sw \T03l_s, 3*8(a0)
    sw \T03h_s, 3*8+4(a0);                  vsrl.vx \S07_v, \S10_v, \T04_s
    and \T03h_s, \T00h_s, \T01h_s
    and \T03l_s, \T00l_s, \T01l_s
    xor \S04h_s, \S04h_s, \T03h_s
    xor \S04l_s, \S04l_s, \T03l_s
    lw \T03l_s, 0*8(a0)
    lw \T03h_s, 0*8+4(a0)
    xor \T00h_s, \S05h_s, \S10h_s;          vxor.vv \S07_v, \S07_v, \T03_v
    xor \T00l_s, \S05l_s, \S10l_s
    lw \T02l_s, 15*8(a0)
    lw \T02h_s, 15*8+4(a0)
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s;          li \T04_s, 64-28
    lw \T03l_s, 20*8(a0);                   vsll.vi \T02_v, \S03_v, 28
    lw \T03h_s, 20*8+4(a0)
    xor \T00h_s, \T00h_s, \T02h_s
    xor \T00l_s, \T00l_s, \T02l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s
    sw \T00l_s, 18*4(sp)
    sw \T00h_s, 19*4(sp);                   vsrl.vx \S10_v, \S03_v, \T04_s
    lw \T03l_s, 3*8(a0)
    lw \T03h_s, 3*8+4(a0)
    xor \T01h_s, \S08h_s, \S23h_s
    xor \T01l_s, \S08l_s, \S23l_s
    lw \T02l_s, 13*8(a0)
    lw \T02h_s, 13*8+4(a0)
    xor \T01h_s, \T01h_s, \T03h_s;          vxor.vv \S10_v, \S10_v, \T02_v
    xor \T01l_s, \T01l_s, \T03l_s
    lw \T03l_s, 18*8(a0)
    lw \T03h_s, 18*8+4(a0)
    xor \T01h_s, \T01h_s, \T02h_s;          li \T04_s, 64-21
    xor \T01l_s, \T01l_s, \T02l_s;          vsll.vi \T03_v, \S18_v, 21
    xor \T01h_s, \T01h_s, \T03h_s
    xor \T01l_s, \T01l_s, \T03l_s
    sw \T01l_s, 24*4(sp)
    sw \T01h_s, 25*4(sp)
    srli \T03h_s, \T00l_s, 31
    slli \T00l_s, \T00l_s, 1;               vsrl.vx \S03_v, \S18_v, \T04_s
    srli \T03l_s, \T00h_s, 31
    slli \T00h_s, \T00h_s, 1
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00h_s, \T00h_s, \T01h_s
    xor \T00l_s, \T00l_s, \T01l_s;          vxor.vv \S03_v, \S03_v, \T03_v
    lw \T03l_s, 9*8(a0)
    lw \T03h_s, 9*8+4(a0)
    xor \T01h_s, \S04h_s, \S14h_s
    xor \T01l_s, \S04l_s, \S14l_s;          li \T04_s, 64-15
    xor \S04h_s, \S04h_s, \T00h_s;          vsll.vi \T02_v, \S17_v, 15
    xor \S04l_s, \S04l_s, \T00l_s
    xor \S14h_s, \S14h_s, \T00h_s
    xor \S14l_s, \S14l_s, \T00l_s
    lw \T02l_s, 19*8(a0)
    lw \T02h_s, 19*8+4(a0)
    xor \T01h_s, \T01h_s, \T03h_s;          vsrl.vx \S18_v, \S17_v, \T04_s
    xor \T01l_s, \T01l_s, \T03l_s
    xor \T03h_s, \T03h_s, \T00h_s
    xor \T03l_s, \T03l_s, \T00l_s
    sw \T03l_s, 9*8(a0)
    sw \T03h_s, 9*8+4(a0)
    lw \T03l_s, 24*8(a0);                   vxor.vv \S18_v, \S18_v, \T02_v
    lw \T03h_s, 24*8+4(a0)
    xor \T01h_s, \T01h_s, \T02h_s
    xor \T01l_s, \T01l_s, \T02l_s
    xor \T02h_s, \T02h_s, \T00h_s;          li \T04_s, 64-10
    xor \T02l_s, \T02l_s, \T00l_s;          vsll.vi \T03_v, \S11_v, 10
    sw \T02l_s, 19*8(a0)
    sw \T02h_s, 19*8+4(a0)
    xor \T01h_s, \T01h_s, \T03h_s
    xor \T01l_s, \T01l_s, \T03l_s
    xor \T03h_s, \T03h_s, \T00h_s
    xor \T03l_s, \T03l_s, \T00l_s;          vsrl.vx \S17_v, \S11_v, \T04_s
    sw \T03l_s, 24*8(a0)
    sw \T03h_s, 24*8+4(a0)
    sw \T01l_s, 26*4(sp)
    sw \T01h_s, 27*4(sp)
    lw \T03l_s, 1*8(a0)
    lw \T03h_s, 1*8+4(a0);                  vxor.vv \S17_v, \S17_v, \T03_v
    xor \T00h_s, \S16h_s, \S21h_s
    xor \T00l_s, \S16l_s, \S21l_s
    lw \T02l_s, 6*8(a0)
    lw \T02h_s, 6*8+4(a0)
    xor \T00h_s, \T00h_s, \T03h_s;          li \T04_s, 64-20
    xor \T00l_s, \T00l_s, \T03l_s;          vsll.vi \T02_v, \S09_v, 20
    lw \T03l_s, 11*8(a0)
    lw \T03h_s, 11*8+4(a0)
    xor \T00h_s, \T00h_s, \T02h_s
    xor \T00l_s, \T00l_s, \T02l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s
    sw \T00l_s, 20*4(sp);                   vsrl.vx \S11_v, \S09_v, \T04_s
    sw \T00h_s, 21*4(sp)
    srli \T03h_s, \T00l_s, 32-1
    slli \T00l_s, \T00l_s, 1
    srli \T03l_s, \T00h_s, 32-1
    slli \T00h_s, \T00h_s, 1
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s;          vxor.vv \S11_v, \S11_v, \T02_v
    xor \T00h_s, \T00h_s, \T01h_s
    xor \T00l_s, \T00l_s, \T01l_s
    lw \T02l_s, 0*8(a0)
    lw \T02h_s, 0*8+4(a0)
    xor \S05h_s, \S05h_s, \T00h_s;          li \T04_s, 61
    xor \S05l_s, \S05l_s, \T00l_s;          vsll.vx \T03_v, \S22_v, \T04_s
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    sw \T02l_s, 0*8(a0)
    sw \T02h_s, 0*8+4(a0)
    lw \T02l_s, 15*8(a0)
    lw \T02h_s, 15*8+4(a0);                 vsrl.vi \S09_v, \S22_v, 64-61
    xor \S10h_s, \S10h_s, \T00h_s
    xor \S10l_s, \S10l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    sw \T02l_s, 15*8(a0)
    sw \T02h_s, 15*8+4(a0);                 vxor.vv \S09_v, \S09_v, \T03_v
    lw \T03l_s, 20*8(a0)
    lw \T03h_s, 20*8+4(a0)
    xor \T03h_s, \T03h_s, \T00h_s
    xor \T03l_s, \T03l_s, \T00l_s;          li \T04_s, 39
    sw \T02l_s, 15*8(a0);                   vsll.vx \T02_v, \S14_v, \T04_s
    sw \T02h_s, 15*8+4(a0)
    sw \T03l_s, 20*8(a0)
    sw \T03h_s, 20*8+4(a0)
    lw \T02l_s, 24*4(sp)
    lw \T02h_s, 25*4(sp)
    lw \T00l_s, 20*4(sp);                   vsrl.vi \S22_v, \S14_v, 64-39
    lw \T00h_s, 21*4(sp)
    srli \T03h_s, \T02l_s, 32-1
    slli \T02l_s, \T02l_s, 1
    srli \T03l_s, \T02h_s, 32-1
    slli \T02h_s, \T02h_s, 1
    xor \T02l_s, \T02l_s, \T03l_s;          vxor.vv \S22_v, \S22_v, \T02_v
    xor \T02h_s, \T02h_s, \T03h_s
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    lw \T03l_s, 7*8(a0);                    li \T04_s, 64-18
    lw \T03h_s, 7*8+4(a0);                  vsll.vi \T03_v, \S20_v, 18
    xor \T00h_s, \S02h_s, \S17h_s
    xor \T00l_s, \S02l_s, \S17l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T03h_s, \T03h_s, \T02h_s
    xor \T03l_s, \T03l_s, \T02l_s;          vsrl.vx \S14_v, \S20_v, \T04_s
    sw \T03l_s, 7*8(a0)
    sw \T03h_s, 7*8+4(a0)
    lw \T03l_s, 12*8(a0)
    lw \T03h_s, 12*8+4(a0)
    xor \S02h_s, \S02h_s, \T02h_s
    xor \S02l_s, \S02l_s, \T02l_s;          vxor.vv \S14_v, \S14_v, \T03_v
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T03h_s, \T03h_s, \T02h_s
    xor \T03l_s, \T03l_s, \T02l_s;          li \T04_s, 64-27
    sw \T03l_s, 12*8(a0);                   vsll.vi \T02_v, \S04_v, 27
    sw \T03h_s, 12*8+4(a0)
    lw \T03l_s, 22*8(a0)
    lw \T03h_s, 22*8+4(a0)
    xor \S17h_s, \S17h_s, \T02h_s
    xor \S17l_s, \S17l_s, \T02l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00l_s, \T00l_s, \T03l_s;          vsrl.vx \S20_v, \S04_v, \T04_s
    xor \T03h_s, \T03h_s, \T02h_s
    xor \T03l_s, \T03l_s, \T02l_s
    sw \T03l_s, 22*8(a0)
    sw \T03h_s, 22*8+4(a0)
    sw \T00l_s, 22*4(sp)
    sw \T00h_s, 23*4(sp)
    srli \T03h_s, \T01l_s, 32-1;            vxor.vv \S20_v, \S20_v, \T02_v
    slli \T01l_s, \T01l_s, 1
    srli \T03l_s, \T01h_s, 32-1
    slli \T01h_s, \T01h_s, 1
    xor \T01l_s, \T01l_s, \T03l_s
    xor \T01h_s, \T01h_s, \T03h_s;          li \T04_s, 64-14
    xor \T01h_s, \T01h_s, \T00h_s;          vsll.vi \T03_v, \S24_v, 14
    xor \T01l_s, \T01l_s, \T00l_s
    lw \T03l_s, 3*8(a0)
    lw \T03h_s, 3*8+4(a0)
    xor \S08h_s, \S08h_s, \T01h_s
    xor \S08l_s, \S08l_s, \T01l_s
    xor \T03h_s, \T03h_s, \T01h_s
    xor \T03l_s, \T03l_s, \T01l_s;          vsrl.vx \S04_v, \S24_v, \T04_s
    sw \T03l_s, 3*8(a0)
    sw \T03h_s, 3*8+4(a0)
    lw \T02l_s, 13*8(a0)
    lw \T02h_s, 13*8+4(a0)
    xor \S23h_s, \S23h_s, \T01h_s
    xor \S23l_s, \S23l_s, \T01l_s;          vxor.vv \S04_v, \S04_v, \T03_v
    xor \T02h_s, \T02h_s, \T01h_s
    xor \T02l_s, \T02l_s, \T01l_s
    sw \T02l_s, 13*8(a0)
    sw \T02h_s, 13*8+4(a0);                 li \T04_s, 64-2
    lw \T03l_s, 18*8(a0);                   vsll.vi \T02_v, \S21_v, 2
    lw \T03h_s, 18*8+4(a0)
    xor \T03h_s, \T03h_s, \T01h_s
    xor \T03l_s, \T03l_s, \T01l_s
    sw \T02l_s, 13*8(a0)
    sw \T02h_s, 13*8+4(a0)
    sw \T03l_s, 18*8(a0);                   vsrl.vx \S24_v, \S21_v, \T04_s
    sw \T03h_s, 18*8+4(a0)
    lw \T01l_s, 18*4(sp)
    lw \T01h_s, 19*4(sp)
    srli \T03h_s, \T00l_s, 32-1
    slli \T00l_s, \T00l_s, 1
    srli \T03l_s, \T00h_s, 32-1;            vxor.vv \S24_v, \S24_v, \T02_v
    slli \T00h_s, \T00h_s, 1
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T00h_s, \T00h_s, \T01h_s;          li \T04_s, 36
    xor \T00l_s, \T00l_s, \T01l_s;          vsll.vx \T03_v, \S05_v, \T04_s
    lw \T02l_s, 1*8(a0)
    lw \T02h_s, 1*8+4(a0)
    xor \S16h_s, \S16h_s, \T00h_s
    xor \S16l_s, \S16l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s;          vsrl.vi \S21_v, \S05_v, 64-36
    sw \T02l_s, 1*8(a0)
    sw \T02h_s, 1*8+4(a0)
    lw \T03l_s, 6*8(a0)
    lw \T03h_s, 6*8+4(a0)
    xor \S21h_s, \S21h_s, \T00h_s
    xor \S21l_s, \S21l_s, \T00l_s;          vxor.vv \S21_v, \S21_v, \T03_v
    xor \T03h_s, \T03h_s, \T00h_s
    xor \T03l_s, \T03l_s, \T00l_s
    lw \T02l_s, 11*8(a0)
    lw \T02h_s, 11*8+4(a0)
    sw \T03l_s, 6*8(a0)
    sw \T03h_s, 6*8+4(a0);                  vor.vv \T02_v, \S11_v, \S07_v
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    sw \T02l_s, 11*8(a0)
    sw \T02h_s, 11*8+4(a0)
    lw \T00l_s, 0*8(a0)
    lw \T00h_s, 0*8+4(a0);                  vxor.vv \S05_v, \S10_v, \T02_v
    lw \T01l_s, 6*8(a0)
    lw \T01h_s, 6*8+4(a0)
    slli \T03l_s, \S21l_s, 2
    srli \S21l_s, \S21l_s, 32-2
    srli \T03h_s, \S21h_s, 32-2
    xor  \T03l_s, \T03l_s, \T03h_s
    slli \T03h_s, \S21h_s, 2;               vand.vv \T03_v, \S07_v, \S08_v
    xor  \T03h_s, \T03h_s, \S21l_s
    slli \T02h_s,  \T01l_s, 44-32
    srli \T01l_s, \T01l_s, 64-44
    slli \T02l_s,  \T01h_s, 44-32
    xor  \T01l_s, \T01l_s, \T02l_s
    srli \T01h_s, \T01h_s, 64-44
    xor  \T01h_s, \T01h_s, \T02h_s;         vxor.vv \S06_v, \S11_v, \T03_v
    sw \T03l_s, 0*8(a0)
    sw \T03h_s, 0*8+4(a0)
    slli \S21h_s, \S08l_s, 55-32
    srli \S08l_s, \S08l_s, 64-55
    srli \S21l_s, \S08h_s, 64-55
    xor  \S21h_s, \S21h_s, \S21l_s
    slli \S21l_s, \S08h_s, 55-32;           vnot.v \T02_v, \S09_v
    xor  \S21l_s, \S21l_s, \S08l_s
    slli \S08h_s, \S16l_s, 45-32
    srli \S16l_s, \S16l_s, 64-45
    srli \S08l_s, \S16h_s, 64-45
    xor  \S08h_s, \S08h_s, \S08l_s
    slli \S08l_s, \S16h_s, 45-32
    xor  \S08l_s, \S08l_s, \S16l_s;         vor.vv  \T02_v, \T02_v, \S08_v
    lw \T02l_s, 3*8(a0)
    lw \T02h_s, 3*8+4(a0)
    slli \S16h_s, \S05l_s, 36-32
    srli \S05l_s, \S05l_s, 64-36
    srli \S16l_s, \S05h_s, 64-36
    xor  \S16h_s, \S16h_s, \S16l_s;         vxor.vv \S07_v, \S07_v, \T02_v
    slli \S16l_s, \S05h_s, 36-32
    xor  \S16l_s, \S16l_s, \S05l_s
    lw \T03l_s, 18*8(a0)
    lw \T03h_s, 18*8+4(a0)
    slli \S05l_s, \T02l_s, 28
    srli \T02l_s, \T02l_s, 32-28;           vor.vv \T03_v, \S09_v, \S10_v
    srli \S05h_s, \T02h_s, 32-28
    xor  \S05l_s, \S05l_s, \S05h_s
    slli \S05h_s, \T02h_s, 28
    xor  \S05h_s, \S05h_s, \T02l_s
    slli \T02l_s, \T03l_s, 21
    srli \T03l_s, \T03l_s, 32-21;           vxor.vv \S08_v, \S08_v, \T03_v
    srli \T02h_s, \T03h_s, 32-21
    xor  \T02l_s, \T02l_s, \T02h_s
    slli \T02h_s, \T03h_s, 21
    xor  \T02h_s, \T02h_s, \T03l_s
    lw \T03l_s, 13*8(a0)
    lw \T03h_s, 13*8+4(a0);                 vand.vv \T02_v, \S10_v, \S11_v
    sw \T02l_s, 3*8(a0)
    sw \T02h_s, 3*8+4(a0)
    srli \T02h_s,  \T03l_s, 32-25
    slli \T03l_s, \T03l_s, 25
    srli \T02l_s,   \T03h_s, 32-25
    slli \T03h_s, \T03h_s, 25;              vxor.vv \S09_v, \S09_v, \T02_v
    xor  \T03l_s, \T03l_s, \T02l_s
    xor  \T03h_s, \T03h_s, \T02h_s
    sw \T03l_s, 18*8(a0)
    sw \T03h_s, 18*8+4(a0)
    slli \T02l_s, \S10l_s, 3
    srli \S10l_s, \S10l_s, 32-3;            vor.vv \T03_v, \S16_v, \S12_v
    srli \T02h_s, \S10h_s, 32-3
    xor  \T02l_s, \T02l_s, \T02h_s
    slli \T02h_s, \S10h_s, 3
    xor  \T02h_s, \T02h_s, \S10l_s
    lw \T03l_s, 1*8(a0)
    lw \T03h_s, 1*8+4(a0);                  vxor.vv \S10_v, \S15_v, \T03_v
    sw \T02l_s, 13*8(a0)
    sw \T02h_s, 13*8+4(a0)
    slli \S10l_s, \T03l_s, 1
    srli \T03l_s, \T03l_s, 32-1
    srli \S10h_s, \T03h_s, 32-1
    xor  \S10l_s, \S10l_s, \S10h_s;         vand.vv \T02_v, \S12_v, \S13_v
    slli \S10h_s, \T03h_s, 1
    xor  \S10h_s, \S10h_s, \T03l_s
    slli \T02l_s, \S02h_s, 62-32
    srli \S02h_s, \S02h_s, 64-62
    srli \T02h_s, \S02l_s, 64-62
    xor  \T02l_s, \T02l_s, \T02h_s;         vxor.vv \S11_v, \S16_v, \T02_v
    slli \T02h_s, \S02l_s, 62-32
    xor  \T02h_s, \T02h_s, \S02h_s
    lw \T03l_s, 12*8(a0)
    lw \T03h_s, 12*8+4(a0)
    sw \T02l_s, 1*8(a0)
    sw \T02h_s, 1*8+4(a0)
    lw \T02l_s, 9*8(a0);                    vnot.v \T03_v, \S13_v
    lw \T02h_s, 9*8+4(a0)
    slli \S02l_s, \T03h_s, 43-32
    srli \T03h_s, \T03h_s, 64-43
    srli \S02h_s, \T03l_s, 64-43
    xor  \S02l_s, \S02l_s, \S02h_s
    slli \S02h_s, \T03l_s, 43-32
    xor  \S02h_s, \S02h_s, \T03h_s;         vand.vv \T03_v, \T03_v, \S14_v
    slli \T03l_s, \T02l_s, 20
    srli \T02l_s, \T02l_s, 32-20
    srli \T03h_s, \T02h_s, 32-20
    xor  \T03l_s, \T03l_s, \T03h_s
    slli \T03h_s, \T02h_s, 20
    xor  \T03h_s, \T03h_s, \T02l_s
    lw \T02l_s, 22*8(a0);                   vxor.vv \S12_v, \S12_v, \T03_v
    lw \T02h_s, 22*8+4(a0)
    sw \T03l_s, 12*8(a0)
    sw \T03h_s, 12*8+4(a0)
    slli \T03h_s,  \T02l_s, 61-32
    srli \T02l_s, \T02l_s, 64-61
    slli \T03l_s, \T02h_s, 61-32
    xor  \T02l_s, \T02l_s, \T03l_s;         vnot.v \T03_v, \S13_v
    srli \T02h_s, \T02h_s, 64-61
    xor  \T02h_s, \T02h_s, \T03h_s
    sw \T02l_s, 9*8(a0)
    sw \T02h_s, 9*8+4(a0)
    slli \T03l_s, \S14h_s, 39-32
    srli \S14h_s, \S14h_s, 64-39;           vor.vv  \T02_v, \S14_v, \S15_v
    srli \T03h_s, \S14l_s, 64-39
    xor  \T03l_s, \T03l_s, \T03h_s
    slli \T03h_s, \S14l_s, 39-32
    xor  \T03h_s, \T03h_s, \S14h_s
    lw \T02l_s, 20*8(a0)
    lw \T02h_s, 20*8+4(a0);                 vxor.vv \S13_v, \T03_v, \T02_v
    sw \T03l_s, 22*8(a0)
    sw \T03h_s, 22*8+4(a0)
    slli \S14l_s, \T02l_s, 18
    srli \T02l_s, \T02l_s, 32-18
    srli \S14h_s, \T02h_s, 32-18
    xor  \S14l_s, \S14l_s, \S14h_s;         vand.vv \T03_v, \S15_v, \S16_v
    slli \S14h_s, \T02h_s, 18
    xor  \S14h_s, \S14h_s, \T02l_s
    slli \T02l_s, \S23h_s, 56-32
    srli \S23h_s, \S23h_s, 64-56
    srli \T02h_s, \S23l_s, 64-56
    xor  \T02l_s, \T02l_s, \T02h_s;         vxor.vv \S14_v, \S14_v, \T03_v
    slli \T02h_s, \S23l_s, 56-32
    xor  \T02h_s, \T02h_s, \S23h_s
    lw \T03l_s, 15*8(a0)
    lw \T03h_s, 15*8+4(a0)
    sw \T02l_s, 20*8(a0)
    sw \T02h_s, 20*8+4(a0);                 vand.vv \T02_v, \S21_v, \S17_v
    slli \S23l_s, \T03h_s, 41-32
    srli \T03h_s, \T03h_s, 64-41
    srli \S23h_s, \T03l_s, 64-41
    xor  \S23l_s, \S23l_s, \S23h_s
    slli \S23h_s, \T03l_s, 41-32
    xor  \S23h_s, \S23h_s, \T03h_s;         vxor.vv \S15_v, \S20_v, \T02_v
    slli \T02l_s, \S04l_s, 27
    srli \S04l_s, \S04l_s, 32-27
    srli \T02h_s, \S04h_s, 32-27
    xor  \T02l_s, \T02l_s, \T02h_s
    slli \T02h_s, \S04h_s, 27
    xor  \T02h_s, \T02h_s, \S04l_s;         vor.vv \T03_v, \S17_v, \S18_v
    lw \T03l_s, 24*8(a0)
    lw \T03h_s, 24*8+4(a0)
    sw \T02l_s, 15*8(a0)
    sw \T02h_s, 15*8+4(a0)
    slli \S04l_s, \T03l_s, 14
    srli \T03l_s, \T03l_s, 32-14;           vxor.vv \S16_v, \S21_v, \T03_v
    srli \S04h_s, \T03h_s, 32-14
    xor  \S04l_s, \S04l_s, \S04h_s
    slli \S04h_s, \T03h_s, 14
    xor  \S04h_s, \S04h_s, \T03l_s
    slli \T02l_s, \S17l_s, 15
    srli \S17l_s, \S17l_s, 32-15;           vnot.v \T02_v, \S18_v
    srli \T02h_s, \S17h_s, 32-15
    xor  \T02l_s, \T02l_s, \T02h_s
    slli \T02h_s, \S17h_s, 15
    xor  \T02h_s, \T02h_s, \S17l_s
    lw \T03l_s, 11*8(a0)
    lw \T03h_s, 11*8+4(a0)
    sw \T02l_s, 24*8(a0);                   vor.vv  \T02_v, \T02_v, \S19_v
    sw \T02h_s, 24*8+4(a0)
    lw \T02h_s, 7*8(a0)
    lw \T02l_s, 7*8+4(a0)
    slli \S17l_s, \T03l_s, 10
    srli \T03l_s, \T03l_s, 32-10
    srli \S17h_s, \T03h_s, 32-10
    xor  \S17l_s, \S17l_s, \S17h_s;         vxor.vv \S17_v, \S17_v, \T02_v
    slli \S17h_s, \T03h_s, 10
    xor  \S17h_s, \S17h_s, \T03l_s
    srli \T03h_s,   \T02h_s, 32-6
    slli \T02h_s, \T02h_s, 6
    srli \T03l_s,   \T02l_s, 32-6
    slli \T02l_s, \T02l_s, 6
    xor  \T02h_s, \T02h_s, \T03l_s;         vnot.v \T02_v, \S18_v
    xor  \T02l_s, \T02l_s, \T03h_s    
    lw \T03l_s, 19*8(a0)
    lw \T03h_s, 19*8+4(a0)
    sw \T02h_s, 11*8(a0)
    sw \T02l_s, 11*8+4(a0)
    srli \T02h_s,   \T03l_s, 32-8
    slli \T03l_s, \T03l_s, 8;               vand.vv \T03_v, \S19_v, \S20_v
    srli \T02l_s,   \T03h_s, 32-8
    slli \T03h_s, \T03h_s, 8
    xor  \T03l_s, \T03l_s, \T02l_s
    xor  \T03h_s, \T03h_s, \T02h_s    
    sw \T00l_s, 18*4(sp)
    sw \T00h_s, 19*4(sp);                   vxor.vv \S18_v, \T02_v, \T03_v
    sw \T01l_s, 20*4(sp)
    sw \T01h_s, 21*4(sp)
    sw \T03l_s, 19*8(a0)
    sw \T03h_s, 19*8+4(a0)
    lw \T01l_s, 13*8(a0)
    lw \T01h_s, 13*8+4(a0);                 vor.vv \T02_v, \S20_v, \S21_v
    lw \T00l_s, 12*8(a0)
    lw \T00h_s, 12*8+4(a0)
    and \T03h_s, \T01h_s, \S08h_s
    and \T03l_s, \T01l_s, \S08l_s
    xor \T03h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T00l_s, \T03l_s;          vxor.vv \S19_v, \S19_v, \T02_v
    lw \T02l_s, 9*8(a0)
    lw \T02h_s, 9*8+4(a0)
    sw \T03l_s, 6*8(a0)
    sw \T03h_s, 6*8+4(a0)
    not \T03h_s, \T02h_s
    not \T03l_s, \T02l_s;                   vnot.v \T03_v, \S01_v
    or \T03h_s, \T03h_s, \S08h_s
    or \T03l_s, \T03l_s, \S08l_s
    xor \T03h_s, \T01h_s, \T03h_s
    xor \T03l_s, \T01l_s, \T03l_s
    sw \T03l_s, 7*8(a0)
    sw \T03h_s, 7*8+4(a0);                  vand.vv \T03_v, \T03_v, \S22_v
    or \T03h_s, \T02h_s, \S05h_s
    or \T03l_s, \T02l_s, \S05l_s
    xor \S08h_s, \S08h_s, \T03h_s
    xor \S08l_s, \S08l_s, \T03l_s
    and \T03h_s, \S05h_s, \T00h_s
    and \T03l_s, \S05l_s, \T00l_s;          vxor.vv \S20_v, \S00_v, \T03_v
    xor \T02h_s, \T02h_s, \T03h_s
    xor \T02l_s, \T02l_s, \T03l_s
    sw \T02l_s, 9*8(a0)
    or  \T03l_s, \T00l_s, \T01l_s
    sw \T02h_s, 9*8+4(a0)
    or  \T03h_s, \T00h_s, \T01h_s;          vnot.v \T03_v, \S01_v
    lw \T01l_s, 19*8(a0)
    xor \S05h_s, \S05h_s, \T03h_s
    lw \T01h_s, 19*8+4(a0)
    xor \S05l_s, \S05l_s, \T03l_s
    lw \T02l_s, 11*8(a0)
    lw \T02h_s, 11*8+4(a0);                 vor.vv  \T02_v, \S22_v, \S23_v
    lw \T00l_s, 18*8(a0)
    lw \T00h_s, 18*8+4(a0)
    not \T03h_s, \T01h_s
    not \T03l_s, \T01l_s
    and \T03h_s, \T03h_s, \S14h_s
    and \T03l_s, \T03l_s, \S14l_s;          vxor.vv \S21_v, \T03_v, \T02_v
    xor \T03h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T00l_s, \T03l_s
    sw \T03l_s, 12*8(a0)
    sw \T03h_s, 12*8+4(a0)
    not \T04_s, \T01h_s
    or  \T03h_s, \S14h_s, \S10h_s
    xor \T03h_s, \T03h_s, \T04_s;           vand.vv \T03_v, \S23_v, \S24_v
    not \T04_s, \T01l_s
    or  \T03l_s, \S14l_s, \S10l_s
    xor \T03l_s, \T03l_s, \T04_s
    sw \T03l_s, 13*8(a0)
    sw \T03h_s, 13*8+4(a0)
    and \T03h_s, \S10h_s, \T02h_s
    and \T03l_s, \S10l_s, \T02l_s;          vxor.vv \S22_v, \S22_v, \T03_v
    xor \S14h_s, \S14h_s, \T03h_s
    xor \S14l_s, \S14l_s, \T03l_s
    or \T03h_s, \T02h_s, \T00h_s
    or \T03l_s, \T02l_s, \T00l_s
    xor \S10h_s, \S10h_s, \T03h_s
    xor \S10l_s, \S10l_s, \T03l_s
    and \T03h_s, \T00h_s, \T01h_s;          vor.vv \T02_v, \S24_v, \S00_v
    and \T03l_s, \T00l_s, \T01l_s
    xor \T02h_s, \T02h_s, \T03h_s
    xor \T02l_s, \T02l_s, \T03l_s
    lw \T01l_s, 20*8(a0)
    lw \T01h_s, 20*8+4(a0)
    sw \T02l_s, 11*8(a0)
    sw \T02h_s, 11*8+4(a0);                 vxor.vv \S23_v, \S23_v, \T02_v
    lw \T00l_s, 24*8(a0)
    lw \T00h_s, 24*8+4(a0)
    lw \T02l_s, 15*8(a0)
    lw \T02h_s, 15*8+4(a0)
    not \T04_s, \T00h_s
    and \T03h_s, \T01h_s, \T02h_s;          vand.vv \T03_v, \S00_v, \S01_v
    xor \T03h_s, \T03h_s, \T04_s
    not \T04_s, \T00l_s
    and \T03l_s, \T01l_s, \T02l_s
    xor \T03l_s, \T03l_s, \T04_s
    sw \T03l_s, 18*8(a0)
    sw \T03h_s, 18*8+4(a0);                 vxor.vv \S24_v, \S24_v, \T03_v
    or \T03h_s, \T02h_s, \S16h_s
    or \T03l_s, \T02l_s, \S16l_s
    xor \T03h_s, \T01h_s, \T03h_s
    xor \T03l_s, \T01l_s, \T03l_s
    sw \T03l_s, 19*8(a0)
    sw \T03h_s, 19*8+4(a0);                 vor.vv \T02_v, \T01_v, \S02_v
    and \T03h_s, \S16h_s, \S17h_s
    and \T03l_s, \S16l_s, \S17l_s
    xor \T02h_s, \T02h_s, \T03h_s
    xor \T02l_s, \T02l_s, \T03l_s
    sw \T02l_s, 15*8(a0)
    sw \T02h_s, 15*8+4(a0);                 vxor.vv \S00_v, \T00_v, \T02_v
    or  \T03h_s, \S17h_s, \T00h_s
    or  \T03l_s, \S17l_s, \T00l_s
    xor \S16h_s, \S16h_s, \T03h_s
    xor \S16l_s, \S16l_s, \T03l_s
    lw \T02l_s, 22*8(a0)
    not \T03h_s, \T00h_s;                   vnot.v \T03_v, \S02_v
    lw \T02h_s, 22*8+4(a0)
    not \T03l_s, \T00l_s
    lw \T00l_s, 0*8(a0)
    or  \T03h_s, \T03h_s, \T01h_s
    lw \T00h_s, 0*8+4(a0)
    or  \T03l_s, \T03l_s, \T01l_s;          vor.vv \T03_v, \T03_v, \S03_v
    lw \T01l_s, 1*8(a0)
    xor \S17h_s, \S17h_s, \T03h_s
    lw \T01h_s, 1*8+4(a0)
    xor \S17l_s, \S17l_s, \T03l_s
    and \T03h_s, \T01h_s, \S21h_s
    and \T03l_s, \T01l_s, \S21l_s;          vxor.vv \S01_v, \T01_v, \T03_v
    xor \T03h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T00l_s, \T03l_s
    sw \T03l_s, 24*8(a0)
    sw \T03h_s, 24*8+4(a0)
    not \T03h_s, \S21h_s
    not \T03l_s, \S21l_s;                   vand.vv \T02_v, \S03_v, \S04_v
    and \T03h_s, \T03h_s, \T02h_s
    and \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T01h_s, \T03h_s
    xor \T03l_s, \T01l_s, \T03l_s
    sw \T03l_s, 20*8(a0)
    sw \T03h_s, 20*8+4(a0);                 vxor.vv \S02_v, \S02_v, \T02_v
    not \T04_s, \S21h_s
    or  \T03h_s, \T02h_s, \S23h_s
    xor \S21h_s, \T03h_s, \T04_s
    not \T04_s, \S21l_s
    or  \T03l_s, \T02l_s, \S23l_s
    xor \S21l_s, \T03l_s, \T04_s
    and \T03h_s, \S23h_s, \T00h_s;          vor.vv \T03_v, \S04_v, \T00_v
    and \T03l_s, \S23l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T03h_s
    xor \T02l_s, \T02l_s, \T03l_s
    sw \T02l_s, 22*8(a0)
    or  \T03l_s, \T00l_s, \T01l_s
    sw \T02h_s, 22*8+4(a0)
    or  \T03h_s, \T00h_s, \T01h_s;          vxor.vv \S03_v, \S03_v, \T03_v
    lw \T00l_s, 18*4(sp)
    xor \S23h_s, \S23h_s, \T03h_s
    lw \T00h_s, 19*4(sp)
    xor \S23l_s, \S23l_s, \T03l_s
    lw \T01l_s, 20*4(sp)
    lw \T01h_s, 21*4(sp)
    or  \T03h_s, \T01h_s, \S02h_s;          vand.vv \T02_v, \T00_v, \T01_v
    or  \T03l_s, \T01l_s, \S02l_s
    xor \T03h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T00l_s, \T03l_s
    lw \T04_s, 17*4(sp)
    lw \T02l_s, 0(\T04_s)
    lw \T02h_s, 4(\T04_s)
    addi \T04_s, \T04_s, 16;                 vxor.vv \S04_v, \S04_v, \T02_v
    sw  \T04_s, 17*4(sp)
    xor \T03h_s, \T03h_s, \T02h_s
    xor \T03l_s, \T03l_s, \T02l_s;          lw \T04_s, 29*4(sp)
    lw \T02l_s, 3*8(a0)
    lw \T02h_s, 3*8+4(a0)
    sw \T03l_s, 0*8(a0);                    vle64.v  \T00_v, 0(\T04_s)
    sw \T03h_s, 0*8+4(a0)
    not \T03h_s, \S02h_s
    not \T03l_s, \S02l_s
    or \T03h_s, \T03h_s, \T02h_s
    or \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T01h_s, \T03h_s;          vxor.vv  \S00_v, \S00_v, \T00_v
    xor \T03l_s, \T01l_s, \T03l_s
    sw \T03l_s, 1*8(a0)
    sw \T03h_s, 1*8+4(a0)
    and \T03h_s, \T02h_s, \S04h_s
    and \T03l_s, \T02l_s, \S04l_s
    xor \S02h_s, \S02h_s, \T03h_s;          addi \T04_s, \T04_s, 16
    xor \S02l_s, \S02l_s, \T03l_s;          sw \T04_s, 29*4(sp)
    or  \T03h_s, \S04h_s, \T00h_s
    or  \T03l_s, \S04l_s, \T00l_s
    xor \T03h_s, \T02h_s, \T03h_s
    xor \T03l_s, \T02l_s, \T03l_s
    sw \T03l_s, 3*8(a0)
    sw \T03h_s, 3*8+4(a0)
    and \T03h_s, \T00h_s, \T01h_s
    and \T03l_s, \T00l_s, \T01l_s
    xor \S04h_s, \S04h_s, \T03h_s
    xor \S04l_s, \S04l_s, \T03l_s
.endm

# stack: 
# 0*4-14*4 for saving registers
# 15*4 for saving a0
# 16*4 for loop control
# 17*4 for table index of scalar impl
# 18*4,19*4 for C0
# 20*4,21*4 for C1
# 22*4,23*4 for C2
# 24*4,25*4 for C3
# 26*4,27*4 for C4
# 28*4 for temporary usage
# 29*4 for table index of vector impl
# 30*4 for outer loop control variable j
.globl KeccakF1600_StatePermute_RV32V_4x
.align 2
KeccakF1600_StatePermute_RV32V_4x:
    addi sp, sp, -4*31
    SaveRegs
    # set VPU
    li a1, 128
    vsetvli a1, a1, e64, m1, tu, mu

    li s11, 0
outer_loop:
    sw s11, 30*4(sp)
    # prepare table index
    la tp, constants_keccak
    sw tp, 17*4(sp)
    bnez s11, init_1th_loop
init_0th_loop:
    sw tp, 29*4(sp)
    # load 1-th scalar impl inputs and vector impl inputs
    LoadStates_v
    j init_end
init_1th_loop:
    addi a0, a0, 25*8
init_end:
    LoadStates_s \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10,s11,ra, gp, tp

    li tp, 12
inner_loop:
    sw tp, 16*4(sp)
    ARound \
        v0,  v1,  v2,  v3,  v4,  v5,  v6,  v7,  v8,  v9,    \
        v10, v11, v12, v13, v14, v15, v16, v17, v18, v19,   \
        v20, v21, v22, v23, v24, v25, v26, v27, v28, v29,   \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10,s11,ra, gp, tp
    lw tp, 16*4(sp)
    addi tp, tp, -1
    bnez tp, inner_loop

    # outer loop cpntrol
    StoreStates_s \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10,ra, gp, tp
    lw s11, 30*4(sp)
    beqz s11, final_end
final_1th_loop:
    addi a0, a0, -25*(16+8)
    StoreStates_v
final_end:
    addi s11, s11, 1
    li   ra, 2
    blt  s11, ra, outer_loop

    RestoreRegs
    addi sp, sp, 4*31
    ret
