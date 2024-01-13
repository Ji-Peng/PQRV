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

.macro InitLoad \
        S02h, S02l, S04h, S04l, S05h, S05l, S08h, S08l, S10h, S10l, \
        S14h, S14l, S16h, S16l, S17h, S17l, S21h, S21l, S23h, S23l, \
        T00h, T00l, T01h, T01l, T02h, T02l, T03h, T03l, T04
    lw \S02l, 2*8(a0)
    lw \S02h, 2*8+4(a0)
    lw \S04l, 4*8(a0)
    lw \S04h, 4*8+4(a0)
    lw \S05l, 5*8(a0)
    lw \S05h, 5*8+4(a0)
    lw \S08l, 8*8(a0)
    lw \S08h, 8*8+4(a0)
    lw \S10l, 10*8(a0)
    lw \S10h, 10*8+4(a0)
    lw \S14l, 14*8(a0)
    lw \S14h, 14*8+4(a0)
    lw \S16l, 16*8(a0)
    lw \S16h, 16*8+4(a0)
    lw \S17l, 17*8(a0)
    lw \S17h, 17*8+4(a0)
    lw \S21l, 21*8(a0)
    lw \S21h, 21*8+4(a0)
    # lane complement: 1,2,8,12,17,20
    lw \T00l, 1*8(a0)
    lw \T00h, 1*8+4(a0)
    lw \S23l, 23*8(a0)
    lw \S23h, 23*8+4(a0)
    not \T00l, \T00l
    not \T00h, \T00h
    lw \T01l, 12*8(a0)
    lw \T01h, 12*8+4(a0)
    sw \T00l, 1*8(a0)
    sw \T00h, 1*8+4(a0)
    not \T01l, \T01l
    not \T01h, \T01h
    lw \T00l, 20*8(a0)
    lw \T00h, 20*8+4(a0)
    sw \T01l, 12*8(a0)
    sw \T01h, 12*8+4(a0)
    not \T00l, \T00l
    not \T00h, \T00h
    not \S02l, \S02l
    not \S02h, \S02h
    sw \T00l, 20*8(a0)
    sw \T00h, 20*8+4(a0)
    not \S08l, \S08l
    not \S08h, \S08h
    not \S17l, \S17l
    not \S17h, \S17h
.endm

.macro FinalStore \
        S02h, S02l, S04h, S04l, S05h, S05l, S08h, S08l, S10h, S10l, \
        S14h, S14l, S16h, S16l, S17h, S17l, S21h, S21l, S23h, S23l, \
        T00h, T00l, T01h, T01l, T02h, T02l, T03h, T03l, T04
    # lane complement: 1,2,8,12,17,20
    lw \T00l, 1*8(a0)
    lw \T00h, 1*8+4(a0)
    not \S02l, \S02l
    not \S02h, \S02h
    not \T00l, \T00l
    not \T00h, \T00h
    sw \T00l, 1*8(a0)
    sw \T00h, 1*8+4(a0)
    lw \T01l, 12*8(a0)
    lw \T01h, 12*8+4(a0)
    not \S08l, \S08l
    not \S08h, \S08h
    not \T01l, \T01l
    not \T01h, \T01h
    sw \T01l, 12*8(a0)
    sw \T01h, 12*8+4(a0)
    lw \T00l, 20*8(a0)
    lw \T00h, 20*8+4(a0)
    not \S17l, \S17l
    not \S17h, \S17h
    not \T00l, \T00l
    not \T00h, \T00h
    sw \T00l, 20*8(a0)
    sw \T00h, 20*8+4(a0)
    
    sw \S02l, 2*8(a0)
    sw \S02h, 2*8+4(a0)
    sw \S04l, 4*8(a0)
    sw \S04h, 4*8+4(a0)
    sw \S05l, 5*8(a0)
    sw \S05h, 5*8+4(a0)
    sw \S08l, 8*8(a0)
    sw \S08h, 8*8+4(a0)
    sw \S10l, 10*8(a0)
    sw \S10h, 10*8+4(a0)
    sw \S14l, 14*8(a0)
    sw \S14h, 14*8+4(a0)
    sw \S16l, 16*8(a0)
    sw \S16h, 16*8+4(a0)
    sw \S17l, 17*8(a0)
    sw \S17h, 17*8+4(a0)
    sw \S21l, 21*8(a0)
    sw \S21h, 21*8+4(a0)
    sw \S23l, 23*8(a0)
    sw \S23h, 23*8+4(a0)
.endm

.macro ARound \
        S02h, S02l, S04h, S04l, S05h, S05l, S08h, S08l, S10h, S10l, \
        S14h, S14l, S16h, S16l, S17h, S17l, S21h, S21l, S23h, S23l, \
        T00h, T00l, T01h, T01l, T02h, T02l, T03h, T03l, T04
    lw \T03l, 0*8(a0)
    lw \T03h, 0*8+4(a0)
    xor \T00h, \S05h, \S10h
    xor \T00l, \S05l, \S10l
    lw \T02l, 15*8(a0)
    lw \T02h, 15*8+4(a0)
    xor \T00h, \T00h, \T03h
    xor \T00l, \T00l, \T03l
    lw \T03l, 20*8(a0)
    lw \T03h, 20*8+4(a0)
    xor \T00h, \T00h, \T02h
    xor \T00l, \T00l, \T02l
    xor \T00h, \T00h, \T03h
    xor \T00l, \T00l, \T03l
    sw \T00l, 18*4(sp)
    sw \T00h, 19*4(sp)
    lw \T03l, 3*8(a0)
    lw \T03h, 3*8+4(a0)
    xor \T01h, \S08h, \S23h
    xor \T01l, \S08l, \S23l
    lw \T02l, 13*8(a0)
    lw \T02h, 13*8+4(a0)
    xor \T01h, \T01h, \T03h
    xor \T01l, \T01l, \T03l
    lw \T03l, 18*8(a0)
    lw \T03h, 18*8+4(a0)
    xor \T01h, \T01h, \T02h
    xor \T01l, \T01l, \T02l
    xor \T01h, \T01h, \T03h
    xor \T01l, \T01l, \T03l
    sw \T01l, 24*4(sp)
    sw \T01h, 25*4(sp)
    srli \T03h, \T00l, 31
    slli \T00l, \T00l, 1
    srli \T03l, \T00h, 31
    slli \T00h, \T00h, 1
    xor \T00l, \T00l, \T03l
    xor \T00h, \T00h, \T03h
    xor \T00h, \T00h, \T01h
    xor \T00l, \T00l, \T01l
    lw \T03l, 9*8(a0)
    lw \T03h, 9*8+4(a0)
    xor \T01h, \S04h, \S14h
    xor \T01l, \S04l, \S14l
    xor \S04h, \S04h, \T00h
    xor \S04l, \S04l, \T00l
    xor \S14h, \S14h, \T00h
    xor \S14l, \S14l, \T00l
    lw \T02l, 19*8(a0)
    lw \T02h, 19*8+4(a0)
    xor \T01h, \T01h, \T03h
    xor \T01l, \T01l, \T03l
    xor \T03h, \T03h, \T00h
    xor \T03l, \T03l, \T00l
    sw \T03l, 9*8(a0)
    sw \T03h, 9*8+4(a0)
    lw \T03l, 24*8(a0)
    lw \T03h, 24*8+4(a0)
    xor \T01h, \T01h, \T02h
    xor \T01l, \T01l, \T02l
    xor \T02h, \T02h, \T00h
    xor \T02l, \T02l, \T00l
    sw \T02l, 19*8(a0)
    sw \T02h, 19*8+4(a0)
    xor \T01h, \T01h, \T03h
    xor \T01l, \T01l, \T03l
    xor \T03h, \T03h, \T00h
    xor \T03l, \T03l, \T00l
    sw \T03l, 24*8(a0)
    sw \T03h, 24*8+4(a0)
    sw \T01l, 26*4(sp)
    sw \T01h, 27*4(sp)
    lw \T03l, 1*8(a0)
    lw \T03h, 1*8+4(a0)
    xor \T00h, \S16h, \S21h
    xor \T00l, \S16l, \S21l
    lw \T02l, 6*8(a0)
    lw \T02h, 6*8+4(a0)
    xor \T00h, \T00h, \T03h
    xor \T00l, \T00l, \T03l
    lw \T03l, 11*8(a0)
    lw \T03h, 11*8+4(a0)
    xor \T00h, \T00h, \T02h
    xor \T00l, \T00l, \T02l
    xor \T00h, \T00h, \T03h
    xor \T00l, \T00l, \T03l
    sw \T00l, 20*4(sp)
    sw \T00h, 21*4(sp)
    srli \T03h, \T00l, 32-1
    slli \T00l, \T00l, 1
    srli \T03l, \T00h, 32-1
    slli \T00h, \T00h, 1
    xor \T00l, \T00l, \T03l
    xor \T00h, \T00h, \T03h
    xor \T00h, \T00h, \T01h
    xor \T00l, \T00l, \T01l
    lw \T02l, 0*8(a0)
    lw \T02h, 0*8+4(a0)
    xor \S05h, \S05h, \T00h
    xor \S05l, \S05l, \T00l
    xor \T02h, \T02h, \T00h
    xor \T02l, \T02l, \T00l
    sw \T02l, 0*8(a0)
    sw \T02h, 0*8+4(a0)
    lw \T02l, 15*8(a0)
    lw \T02h, 15*8+4(a0)
    xor \S10h, \S10h, \T00h
    xor \S10l, \S10l, \T00l
    xor \T02h, \T02h, \T00h
    xor \T02l, \T02l, \T00l
    sw \T02l, 15*8(a0)
    sw \T02h, 15*8+4(a0)
    lw \T03l, 20*8(a0)
    lw \T03h, 20*8+4(a0)
    xor \T03h, \T03h, \T00h
    xor \T03l, \T03l, \T00l
    sw \T02l, 15*8(a0)
    sw \T02h, 15*8+4(a0)
    sw \T03l, 20*8(a0)
    sw \T03h, 20*8+4(a0)
    lw \T02l, 24*4(sp)
    lw \T02h, 25*4(sp)
    lw \T00l, 20*4(sp)
    lw \T00h, 21*4(sp)
    srli \T03h, \T02l, 32-1
    slli \T02l, \T02l, 1
    srli \T03l, \T02h, 32-1
    slli \T02h, \T02h, 1
    xor \T02l, \T02l, \T03l
    xor \T02h, \T02h, \T03h
    xor \T02h, \T02h, \T00h
    xor \T02l, \T02l, \T00l
    lw \T03l, 7*8(a0)
    lw \T03h, 7*8+4(a0)
    xor \T00h, \S02h, \S17h
    xor \T00l, \S02l, \S17l
    xor \T00h, \T00h, \T03h
    xor \T00l, \T00l, \T03l
    xor \T03h, \T03h, \T02h
    xor \T03l, \T03l, \T02l
    sw \T03l, 7*8(a0)
    sw \T03h, 7*8+4(a0)
    lw \T03l, 12*8(a0)
    lw \T03h, 12*8+4(a0)
    xor \S02h, \S02h, \T02h
    xor \S02l, \S02l, \T02l
    xor \T00h, \T00h, \T03h
    xor \T00l, \T00l, \T03l
    xor \T03h, \T03h, \T02h
    xor \T03l, \T03l, \T02l
    sw \T03l, 12*8(a0)
    sw \T03h, 12*8+4(a0)
    lw \T03l, 22*8(a0)
    lw \T03h, 22*8+4(a0)
    xor \S17h, \S17h, \T02h
    xor \S17l, \S17l, \T02l
    xor \T00h, \T00h, \T03h
    xor \T00l, \T00l, \T03l
    xor \T03h, \T03h, \T02h
    xor \T03l, \T03l, \T02l
    sw \T03l, 22*8(a0)
    sw \T03h, 22*8+4(a0)
    sw \T00l, 22*4(sp)
    sw \T00h, 23*4(sp)
    srli \T03h, \T01l, 32-1
    slli \T01l, \T01l, 1
    srli \T03l, \T01h, 32-1
    slli \T01h, \T01h, 1
    xor \T01l, \T01l, \T03l
    xor \T01h, \T01h, \T03h
    xor \T01h, \T01h, \T00h
    xor \T01l, \T01l, \T00l
    lw \T03l, 3*8(a0)
    lw \T03h, 3*8+4(a0)
    xor \S08h, \S08h, \T01h
    xor \S08l, \S08l, \T01l
    xor \T03h, \T03h, \T01h
    xor \T03l, \T03l, \T01l
    sw \T03l, 3*8(a0)
    sw \T03h, 3*8+4(a0)
    lw \T02l, 13*8(a0)
    lw \T02h, 13*8+4(a0)
    xor \S23h, \S23h, \T01h
    xor \S23l, \S23l, \T01l
    xor \T02h, \T02h, \T01h
    xor \T02l, \T02l, \T01l
    sw \T02l, 13*8(a0)
    sw \T02h, 13*8+4(a0)
    lw \T03l, 18*8(a0)
    lw \T03h, 18*8+4(a0)
    xor \T03h, \T03h, \T01h
    xor \T03l, \T03l, \T01l
    sw \T02l, 13*8(a0)
    sw \T02h, 13*8+4(a0)
    sw \T03l, 18*8(a0)
    sw \T03h, 18*8+4(a0)
    lw \T01l, 18*4(sp)
    lw \T01h, 19*4(sp)
    srli \T03h, \T00l, 32-1
    slli \T00l, \T00l, 1
    srli \T03l, \T00h, 32-1
    slli \T00h, \T00h, 1
    xor \T00l, \T00l, \T03l
    xor \T00h, \T00h, \T03h
    xor \T00h, \T00h, \T01h
    xor \T00l, \T00l, \T01l
    lw \T02l, 1*8(a0)
    lw \T02h, 1*8+4(a0)
    xor \S16h, \S16h, \T00h
    xor \S16l, \S16l, \T00l
    xor \T02h, \T02h, \T00h
    xor \T02l, \T02l, \T00l
    sw \T02l, 1*8(a0)
    sw \T02h, 1*8+4(a0)
    lw \T03l, 6*8(a0)
    lw \T03h, 6*8+4(a0)
    xor \S21h, \S21h, \T00h
    xor \S21l, \S21l, \T00l
    xor \T03h, \T03h, \T00h
    xor \T03l, \T03l, \T00l
    lw \T02l, 11*8(a0)
    lw \T02h, 11*8+4(a0)
    sw \T03l, 6*8(a0)
    sw \T03h, 6*8+4(a0)
    xor \T02h, \T02h, \T00h
    xor \T02l, \T02l, \T00l
    sw \T02l, 11*8(a0)
    sw \T02h, 11*8+4(a0)
    lw \T00l, 0*8(a0)
    lw \T00h, 0*8+4(a0)
    lw \T01l, 6*8(a0)
    lw \T01h, 6*8+4(a0)
    slli \T03l, \S21l, 2
    srli \S21l, \S21l, 32-2
    srli \T03h, \S21h, 32-2
    xor  \T03l, \T03l, \T03h
    slli \T03h, \S21h, 2
    xor  \T03h, \T03h, \S21l
    slli \T02h,  \T01l, 44-32
    srli \T01l, \T01l, 64-44
    slli \T02l,  \T01h, 44-32
    xor  \T01l, \T01l, \T02l
    srli \T01h, \T01h, 64-44
    xor  \T01h, \T01h, \T02h
    sw \T03l, 0*8(a0)
    sw \T03h, 0*8+4(a0)
    slli \S21h, \S08l, 55-32
    srli \S08l, \S08l, 64-55
    srli \S21l, \S08h, 64-55
    xor  \S21h, \S21h, \S21l
    slli \S21l, \S08h, 55-32
    xor  \S21l, \S21l, \S08l
    slli \S08h, \S16l, 45-32
    srli \S16l, \S16l, 64-45
    srli \S08l, \S16h, 64-45
    xor  \S08h, \S08h, \S08l
    slli \S08l, \S16h, 45-32
    xor  \S08l, \S08l, \S16l
    lw \T02l, 3*8(a0)
    lw \T02h, 3*8+4(a0)
    slli \S16h, \S05l, 36-32
    srli \S05l, \S05l, 64-36
    srli \S16l, \S05h, 64-36
    xor  \S16h, \S16h, \S16l
    slli \S16l, \S05h, 36-32
    xor  \S16l, \S16l, \S05l
    lw \T03l, 18*8(a0)
    lw \T03h, 18*8+4(a0)
    slli \S05l, \T02l, 28
    srli \T02l, \T02l, 32-28
    srli \S05h, \T02h, 32-28
    xor  \S05l, \S05l, \S05h
    slli \S05h, \T02h, 28
    xor  \S05h, \S05h, \T02l
    slli \T02l, \T03l, 21
    srli \T03l, \T03l, 32-21
    srli \T02h, \T03h, 32-21
    xor  \T02l, \T02l, \T02h
    slli \T02h, \T03h, 21
    xor  \T02h, \T02h, \T03l
    lw \T03l, 13*8(a0)
    lw \T03h, 13*8+4(a0)
    sw \T02l, 3*8(a0)
    sw \T02h, 3*8+4(a0)
    srli \T04,   \T03l, 32-25
    slli \T03l, \T03l, 25
    srli \T02l,   \T03h, 32-25
    slli \T03h, \T03h, 25
    xor  \T03l, \T03l, \T02l
    xor  \T03h, \T03h, \T04
    sw \T03l, 18*8(a0)
    sw \T03h, 18*8+4(a0)
    slli \T02l, \S10l, 3
    srli \S10l, \S10l, 32-3
    srli \T02h, \S10h, 32-3
    xor  \T02l, \T02l, \T02h
    slli \T02h, \S10h, 3
    xor  \T02h, \T02h, \S10l
    lw \T03l, 1*8(a0)
    lw \T03h, 1*8+4(a0)
    sw \T02l, 13*8(a0)
    sw \T02h, 13*8+4(a0)
    slli \S10l, \T03l, 1
    srli \T03l, \T03l, 32-1
    srli \S10h, \T03h, 32-1
    xor  \S10l, \S10l, \S10h
    slli \S10h, \T03h, 1
    xor  \S10h, \S10h, \T03l
    slli \T02l, \S02h, 62-32
    srli \S02h, \S02h, 64-62
    srli \T02h, \S02l, 64-62
    xor  \T02l, \T02l, \T02h
    slli \T02h, \S02l, 62-32
    xor  \T02h, \T02h, \S02h
    lw \T03l, 12*8(a0)
    lw \T03h, 12*8+4(a0)
    sw \T02l, 1*8(a0)
    sw \T02h, 1*8+4(a0)
    lw \T02l, 9*8(a0)
    lw \T02h, 9*8+4(a0)
    slli \S02l, \T03h, 43-32
    srli \T03h, \T03h, 64-43
    srli \S02h, \T03l, 64-43
    xor  \S02l, \S02l, \S02h
    slli \S02h, \T03l, 43-32
    xor  \S02h, \S02h, \T03h
    slli \T03l, \T02l, 20
    srli \T02l, \T02l, 32-20
    srli \T03h, \T02h, 32-20
    xor  \T03l, \T03l, \T03h
    slli \T03h, \T02h, 20
    xor  \T03h, \T03h, \T02l
    lw \T02l, 22*8(a0)
    lw \T02h, 22*8+4(a0)
    sw \T03l, 12*8(a0)
    sw \T03h, 12*8+4(a0)
    slli \T04,  \T02l, 61-32
    srli \T02l, \T02l, 64-61
    slli \T03l, \T02h, 61-32
    xor  \T02l, \T02l, \T03l
    srli \T02h, \T02h, 64-61
    xor  \T02h, \T02h, \T04
    sw \T02l, 9*8(a0)
    sw \T02h, 9*8+4(a0)
    slli \T03l, \S14h, 39-32
    srli \S14h, \S14h, 64-39
    srli \T03h, \S14l, 64-39
    xor  \T03l, \T03l, \T03h
    slli \T03h, \S14l, 39-32
    xor  \T03h, \T03h, \S14h
    lw \T02l, 20*8(a0)
    lw \T02h, 20*8+4(a0)
    sw \T03l, 22*8(a0)
    sw \T03h, 22*8+4(a0)
    slli \S14l, \T02l, 18
    srli \T02l, \T02l, 32-18
    srli \S14h, \T02h, 32-18
    xor  \S14l, \S14l, \S14h
    slli \S14h, \T02h, 18
    xor  \S14h, \S14h, \T02l
    slli \T02l, \S23h, 56-32
    srli \S23h, \S23h, 64-56
    srli \T02h, \S23l, 64-56
    xor  \T02l, \T02l, \T02h
    slli \T02h, \S23l, 56-32
    xor  \T02h, \T02h, \S23h
    lw \T03l, 15*8(a0)
    lw \T03h, 15*8+4(a0)
    sw \T02l, 20*8(a0)
    sw \T02h, 20*8+4(a0)
    slli \S23l, \T03h, 41-32
    srli \T03h, \T03h, 64-41
    srli \S23h, \T03l, 64-41
    xor  \S23l, \S23l, \S23h
    slli \S23h, \T03l, 41-32
    xor  \S23h, \S23h, \T03h  
    slli \T02l, \S04l, 27
    srli \S04l, \S04l, 32-27
    srli \T02h, \S04h, 32-27
    xor  \T02l, \T02l, \T02h
    slli \T02h, \S04h, 27
    xor  \T02h, \T02h, \S04l    
    lw \T03l, 24*8(a0)
    lw \T03h, 24*8+4(a0)
    sw \T02l, 15*8(a0)
    sw \T02h, 15*8+4(a0)
    slli \S04l, \T03l, 14
    srli \T03l, \T03l, 32-14
    srli \S04h, \T03h, 32-14
    xor  \S04l, \S04l, \S04h
    slli \S04h, \T03h, 14
    xor  \S04h, \S04h, \T03l
    slli \T02l, \S17l, 15
    srli \S17l, \S17l, 32-15
    srli \T02h, \S17h, 32-15
    xor  \T02l, \T02l, \T02h
    slli \T02h, \S17h, 15
    xor  \T02h, \T02h, \S17l
    lw \T03l, 11*8(a0)
    lw \T03h, 11*8+4(a0)
    sw \T02l, 24*8(a0)
    sw \T02h, 24*8+4(a0)
    lw \T04, 7*8(a0)
    lw \T02l, 7*8+4(a0)
    slli \S17l, \T03l, 10
    srli \T03l, \T03l, 32-10
    srli \S17h, \T03h, 32-10
    xor  \S17l, \S17l, \S17h
    slli \S17h, \T03h, 10
    xor  \S17h, \S17h, \T03l
    srli \T03h,   \T04, 32-6
    slli \T04, \T04, 6
    srli \T03l,   \T02l, 32-6
    slli \T02l, \T02l, 6
    xor  \T04, \T04, \T03l
    xor  \T02l, \T02l, \T03h    
    lw \T03l, 19*8(a0)
    lw \T03h, 19*8+4(a0)
    sw \T04, 11*8(a0)
    sw \T02l, 11*8+4(a0)
    srli \T02h,   \T03l, 32-8
    slli \T03l, \T03l, 8
    srli \T04,   \T03h, 32-8
    slli \T03h, \T03h, 8
    xor  \T03l, \T03l, \T04
    xor  \T03h, \T03h, \T02h    
    sw \T00l, 18*4(sp)
    sw \T00h, 19*4(sp)
    sw \T01l, 20*4(sp)
    sw \T01h, 21*4(sp)
    sw \T03l, 19*8(a0)
    sw \T03h, 19*8+4(a0)
    lw \T01l, 13*8(a0)
    lw \T01h, 13*8+4(a0)
    lw \T00l, 12*8(a0)
    lw \T00h, 12*8+4(a0)
    and \T03h, \T01h, \S08h
    and \T03l, \T01l, \S08l
    xor \T03h, \T00h, \T03h
    xor \T03l, \T00l, \T03l
    lw \T02l, 9*8(a0)
    lw \T02h, 9*8+4(a0)
    sw \T03l, 6*8(a0)
    sw \T03h, 6*8+4(a0)
    not \T03h, \T02h
    not \T03l, \T02l
    or \T03h, \T03h, \S08h
    or \T03l, \T03l, \S08l
    xor \T03h, \T01h, \T03h
    xor \T03l, \T01l, \T03l
    sw \T03l, 7*8(a0)
    sw \T03h, 7*8+4(a0)
    or \T03h, \T02h, \S05h
    or \T03l, \T02l, \S05l
    xor \S08h, \S08h, \T03h
    xor \S08l, \S08l, \T03l
    and \T03h, \S05h, \T00h
    and \T03l, \S05l, \T00l
    xor \T02h, \T02h, \T03h
    xor \T02l, \T02l, \T03l
    sw \T02l, 9*8(a0)
    or  \T03l, \T00l, \T01l
    sw \T02h, 9*8+4(a0)
    or  \T03h, \T00h, \T01h
    lw \T01l, 19*8(a0)
    xor \S05h, \S05h, \T03h
    lw \T01h, 19*8+4(a0)
    xor \S05l, \S05l, \T03l
    lw \T02l, 11*8(a0)
    lw \T02h, 11*8+4(a0)
    lw \T00l, 18*8(a0)
    lw \T00h, 18*8+4(a0)
    not \T03h, \T01h
    not \T03l, \T01l
    and \T03h, \T03h, \S14h
    and \T03l, \T03l, \S14l
    xor \T03h, \T00h, \T03h
    xor \T03l, \T00l, \T03l
    sw \T03l, 12*8(a0)
    sw \T03h, 12*8+4(a0)
    not \T04, \T01h
    or  \T03h, \S14h, \S10h
    xor \T03h, \T03h, \T04
    not \T04, \T01l
    or  \T03l, \S14l, \S10l
    xor \T03l, \T03l, \T04
    sw \T03l, 13*8(a0)
    sw \T03h, 13*8+4(a0)
    and \T03h, \S10h, \T02h
    and \T03l, \S10l, \T02l
    xor \S14h, \S14h, \T03h
    xor \S14l, \S14l, \T03l
    or \T03h, \T02h, \T00h
    or \T03l, \T02l, \T00l
    xor \S10h, \S10h, \T03h
    xor \S10l, \S10l, \T03l
    and \T03h, \T00h, \T01h
    and \T03l, \T00l, \T01l
    xor \T02h, \T02h, \T03h
    xor \T02l, \T02l, \T03l
    lw \T01l, 20*8(a0)
    lw \T01h, 20*8+4(a0)
    sw \T02l, 11*8(a0)
    sw \T02h, 11*8+4(a0)
    lw \T00l, 24*8(a0)
    lw \T00h, 24*8+4(a0)
    lw \T02l, 15*8(a0)
    lw \T02h, 15*8+4(a0)
    not \T04, \T00h
    and \T03h, \T01h, \T02h
    xor \T03h, \T03h, \T04
    not \T04, \T00l
    and \T03l, \T01l, \T02l
    xor \T03l, \T03l, \T04
    sw \T03l, 18*8(a0)
    sw \T03h, 18*8+4(a0)
    or \T03h, \T02h, \S16h
    or \T03l, \T02l, \S16l
    xor \T03h, \T01h, \T03h
    xor \T03l, \T01l, \T03l
    sw \T03l, 19*8(a0)
    sw \T03h, 19*8+4(a0)
    and \T03h, \S16h, \S17h
    and \T03l, \S16l, \S17l
    xor \T02h, \T02h, \T03h
    xor \T02l, \T02l, \T03l
    sw \T02l, 15*8(a0)
    sw \T02h, 15*8+4(a0)
    or  \T03h, \S17h, \T00h
    or  \T03l, \S17l, \T00l
    xor \S16h, \S16h, \T03h
    xor \S16l, \S16l, \T03l
    lw \T02l, 22*8(a0)
    not \T03h, \T00h
    lw \T02h, 22*8+4(a0)
    not \T03l, \T00l
    lw \T00l, 0*8(a0)
    or  \T03h, \T03h, \T01h
    lw \T00h, 0*8+4(a0)
    or  \T03l, \T03l, \T01l
    lw \T01l, 1*8(a0)
    xor \S17h, \S17h, \T03h
    lw \T01h, 1*8+4(a0)
    xor \S17l, \S17l, \T03l
    and \T03h, \T01h, \S21h
    and \T03l, \T01l, \S21l
    xor \T03h, \T00h, \T03h
    xor \T03l, \T00l, \T03l
    sw \T03l, 24*8(a0)
    sw \T03h, 24*8+4(a0)
    not \T03h, \S21h
    not \T03l, \S21l
    and \T03h, \T03h, \T02h
    and \T03l, \T03l, \T02l
    xor \T03h, \T01h, \T03h
    xor \T03l, \T01l, \T03l
    sw \T03l, 20*8(a0)
    sw \T03h, 20*8+4(a0)
    not \T04, \S21h
    or  \T03h, \T02h, \S23h
    xor \S21h, \T03h, \T04
    not \T04, \S21l
    or  \T03l, \T02l, \S23l
    xor \S21l, \T03l, \T04
    and \T03h, \S23h, \T00h
    and \T03l, \S23l, \T00l
    xor \T02h, \T02h, \T03h
    xor \T02l, \T02l, \T03l
    sw \T02l, 22*8(a0)
    or  \T03l, \T00l, \T01l
    sw \T02h, 22*8+4(a0)
    or  \T03h, \T00h, \T01h
    lw \T00l, 18*4(sp)
    xor \S23h, \S23h, \T03h
    lw \T00h, 19*4(sp)
    xor \S23l, \S23l, \T03l
    lw \T01l, 20*4(sp)
    lw \T01h, 21*4(sp)
    or  \T03h, \T01h, \S02h
    or  \T03l, \T01l, \S02l
    xor \T03h, \T00h, \T03h
    xor \T03l, \T00l, \T03l
    lw \T04, 17*4(sp)
    lw \T02l, 0(\T04)
    lw \T02h, 4(\T04)
    addi \T04, \T04, 8
    sw  \T04, 17*4(sp)
    xor \T03h, \T03h, \T02h
    xor \T03l, \T03l, \T02l
    lw \T02l, 3*8(a0)
    lw \T02h, 3*8+4(a0)
    sw \T03l, 0*8(a0)
    sw \T03h, 0*8+4(a0)
    not \T03h, \S02h
    not \T03l, \S02l
    or \T03h, \T03h, \T02h
    or \T03l, \T03l, \T02l
    xor \T03h, \T01h, \T03h
    xor \T03l, \T01l, \T03l
    sw \T03l, 1*8(a0)
    sw \T03h, 1*8+4(a0)
    and \T03h, \T02h, \S04h
    and \T03l, \T02l, \S04l
    xor \S02h, \S02h, \T03h
    xor \S02l, \S02l, \T03l
    or  \T03h, \S04h, \T00h
    or  \T03l, \S04l, \T00l
    xor \T03h, \T02h, \T03h
    xor \T03l, \T02l, \T03l
    sw \T03l, 3*8(a0)
    sw \T03h, 3*8+4(a0)
    and \T03h, \T00h, \T01h
    and \T03l, \T00l, \T01l
    xor \S04h, \S04h, \T03h
    xor \S04l, \S04l, \T03l
.endm

# stack: 
# 0*4-14*4 for saving registers
# 15*4 for saving a0
# 16*4 for loop control
# 17*4 for table index
# 18*4,19*4 for C0
# 20*4,21*4 for C1
# 22*4,23*4 for C2
# 24*4,25*4 for C3
# 26*4,27*4 for C4
.globl KeccakF1600_StatePermute_RV32ASM
.align 2
KeccakF1600_StatePermute_RV32ASM:
    addi sp, sp, -4*28
    SaveRegs
    la tp, constants_keccak
    sw tp, 17*4(sp)

    InitLoad \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10,s11,ra, gp, tp

    li tp, 24

loop_start:
    sw tp, 16*4(sp)
    ARound \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10,s11,ra, gp, tp
    
    lw tp, 16*4(sp)
    addi tp, tp, -1
    bnez tp, loop_start

    FinalStore \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10,s11,ra, gp, tp

    RestoreRegs
    addi sp, sp, 4*28
    ret