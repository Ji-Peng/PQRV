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

.macro XOR1Init outh, outl, in0h, in0l, in1h, in1l
    xor \outl, \in0l, \in1l
    xor \outh, \in0h, \in1h
.endm

.macro XOR1 outh, outl, inh, inl
    xor \outl, \outl, \inl
    xor \outh, \outh, \inh
.endm

.macro XOREach                 \
        S00h_s, S00l_s, S01h_s, S01l_s,\
        S02h_s, S02l_s, S03h_s, S03l_s,\
        S04h_s, S04l_s, Dh,   Dl
    XOR1 \S00h_s, \S00l_s, \Dh, \Dl
    XOR1 \S01h_s, \S01l_s, \Dh, \Dl
    XOR1 \S02h_s, \S02l_s, \Dh, \Dl
    XOR1 \S03h_s, \S03l_s, \Dh, \Dl
    XOR1 \S04h_s, \S04l_s, \Dh, \Dl
.endm

.macro ROLn outh, outl, S00h_s, S00l_s, n
.if \n < 32
    slli \outl, \S00l_s, \n
    srli \S00l_s, \S00l_s, 32-\n
    srli \outh, \S00h_s, 32-\n
    slli \S00h_s, \S00h_s, \n
    xor  \outl, \outl, \outh
    xor  \outh, \S00h_s, \S00l_s
.else
    slli \outl, \S00h_s, \n-32
    srli \S00h_s, \S00h_s, 64-\n
    srli \outh, \S00l_s, 64-\n
    slli \S00l_s, \S00l_s, \n-32
    xor  \outl, \outl, \outh
    xor  \outh, \S00l_s, \S00h_s
.endif
.endm

.macro ROLnInplace S00h_s, S00l_s, T0, T1, n
.if \n < 32
    srli \T0,   \S00l_s, 32-\n
    slli \S00l_s, \S00l_s, \n
    srli \T1,   \S00h_s, 32-\n
    slli \S00h_s, \S00h_s, \n
    xor  \S00l_s, \S00l_s, \T1
    xor  \S00h_s, \S00h_s, \T0
.else
    slli \T0,  \S00l_s, \n-32
    srli \S00l_s,\S00l_s, 64-\n
    slli \T1,  \S00h_s, \n-32
    srli \S00h_s,\S00h_s, 64-\n
    xor  \S00l_s,\S00l_s, \T1
    xor  \S00h_s,\S00h_s, \T0
.endif
.endm

.macro xoror outh, outl, S00h_s, S00l_s, S01h_s, S01l_s, S02h_s, S02l_s, Th, Tl
    or \Tl, \S01l_s, \S02l_s
    or \Th, \S01h_s, \S02h_s
    xor \outl, \S00l_s, \Tl
    xor \outh, \S00h_s, \Th
.endm

.macro xornotor outh, outl, S00h_s, S00l_s, S01h_s, S01l_s, S02h_s, S02l_s, Th, Tl
    not \Tl, \S01l_s
    not \Th, \S01h_s
    or \Tl, \Tl, \S02l_s
    or \Th, \Th, \S02h_s
    xor \outl, \S00l_s, \Tl
    xor \outh, \S00h_s, \Th
.endm

.macro xorand outh, outl, S00h_s, S00l_s, S01h_s, S01l_s, S02h_s, S02l_s, Th, Tl
    and \Tl, \S01l_s, \S02l_s
    and \Th, \S01h_s, \S02h_s
    xor \outl, \S00l_s, \Tl
    xor \outh, \S00h_s, \Th
.endm

.macro xorornot outh, outl, S00h_s, S00l_s, S01h_s, S01l_s, S02h_s, S02l_s, Th, Tl
    not \Tl, \S02l_s
    not \Th, \S02h_s
    or \Tl, \Tl, \S01l_s
    or \Th, \Th, \S01h_s
    xor \outl, \S00l_s, \Tl
    xor \outh, \S00h_s, \Th
.endm

.macro xornotand outh, outl, S00h_s, S00l_s, S01h_s, S01l_s, S02h_s, S02l_s, Th, Tl
    not \Tl, \S01l_s
    not \Th, \S01h_s
    and \Tl, \Tl, \S02l_s
    and \Th, \Th, \S02h_s
    xor \outl, \S00l_s, \Tl
    xor \outh, \S00h_s, \Th
.endm

.macro notxoror outh, outl, S00h_s, S00l_s, S01h_s, S01l_s, S02h_s, S02l_s, Th, Tl, T0
    not \T0, \S00h_s
    or  \Th, \S01h_s, \S02h_s
    or  \Tl, \S01l_s, \S02l_s
    xor \outh, \Th, \T0
    not \T0, \S00l_s
    xor \outl, \Tl, \T0
.endm

.macro notxorand outh, outl, S00h_s, S00l_s, S01h_s, S01l_s, S02h_s, S02l_s, Th, Tl, T0
    not \T0, \S00h_s
    and \Th, \S01h_s, \S02h_s
    and \Tl, \S01l_s, \S02l_s
    xor \outh, \Th, \T0
    not \T0, \S00l_s
    xor \outl, \Tl, \T0
.endm

.macro InitLoad \
        S02h_s, S02l_s, S04h_s, S04l_s, S05h_s, S05l_s, S08h_s, S08l_s, S10h_s, S10l_s, \
        S14h_s, S14l_s, S16h_s, S16l_s, S17h_s, S17l_s, S21h_s, S21l_s, S23h_s, S23l_s, \
        T00h_s, T00l_s, T01h_s, T01l_s, T02h_s, T02l_s, T03h_s, T03l_s, T04_s
    # lane complement: 1,2,8,12,17,20
    lw \T00l_s, 1*8(a0)
    lw \T00h_s, 1*8+4(a0)
    lw \T01l_s, 12*8(a0)
    lw \T01h_s, 12*8+4(a0)
    lw \S02l_s, 2*8(a0)
    lw \S02h_s, 2*8+4(a0)
    lw \S04l_s, 4*8(a0)
    lw \S04h_s, 4*8+4(a0)
    lw \S05l_s, 5*8(a0)
    lw \S05h_s, 5*8+4(a0)
    not \T00l_s, \T00l_s
    not \T00h_s, \T00h_s
    not \T01l_s, \T01l_s
    not \T01h_s, \T01h_s
    sw \T00l_s, 1*8(a0)
    sw \T00h_s, 1*8+4(a0)
    lw \S08l_s, 8*8(a0)
    lw \S08h_s, 8*8+4(a0)
    sw \T01l_s, 12*8(a0)
    sw \T01h_s, 12*8+4(a0)
    lw \S10l_s, 10*8(a0)
    lw \S10h_s, 10*8+4(a0)
    lw \T00l_s, 20*8(a0)
    lw \T00h_s, 20*8+4(a0)
    not \S02l_s, \S02l_s
    not \S02h_s, \S02h_s
    not \S08l_s, \S08l_s
    not \S08h_s, \S08h_s
    lw \S14l_s, 14*8(a0)
    lw \S14h_s, 14*8+4(a0)
    lw \S16l_s, 16*8(a0)
    lw \S16h_s, 16*8+4(a0)
    lw \S17l_s, 17*8(a0)
    lw \S17h_s, 17*8+4(a0)
    not \T00l_s, \T00l_s
    not \T00h_s, \T00h_s
    lw \S21l_s, 21*8(a0)
    lw \S21h_s, 21*8+4(a0)
    sw \T00l_s, 20*8(a0)
    sw \T00h_s, 20*8+4(a0)
    not \S17l_s, \S17l_s
    not \S17h_s, \S17h_s
    lw \S23l_s, 23*8(a0)
    lw \S23h_s, 23*8+4(a0)
.endm

.macro FinalStore \
        S02h_s, S02l_s, S04h_s, S04l_s, S05h_s, S05l_s, S08h_s, S08l_s, S10h_s, S10l_s, \
        S14h_s, S14l_s, S16h_s, S16l_s, S17h_s, S17l_s, S21h_s, S21l_s, S23h_s, S23l_s, \
        T00h_s, T00l_s, T01h_s, T01l_s, T02h_s, T02l_s, T03h_s, T03l_s, T04_s
    # lane complement: 1,2,8,12,17,20
    lw \T00l_s, 1*8(a0)
    lw \T00h_s, 1*8+4(a0)
    lw \T01l_s, 12*8(a0)
    lw \T01h_s, 12*8+4(a0)
    not \S02l_s, \S02l_s
    not \S02h_s, \S02h_s
    not \S08l_s, \S08l_s
    not \S08h_s, \S08h_s
    sw \S02l_s, 2*8(a0)
    sw \S02h_s, 2*8+4(a0)
    sw \S04l_s, 4*8(a0)
    sw \S04h_s, 4*8+4(a0)
    not \T00l_s, \T00l_s
    not \T00h_s, \T00h_s
    not \T01l_s, \T01l_s
    not \T01h_s, \T01h_s
    sw \T00l_s, 1*8(a0)
    sw \T00h_s, 1*8+4(a0)
    sw \T01l_s, 12*8(a0)
    sw \T01h_s, 12*8+4(a0)
    lw \T00l_s, 20*8(a0)
    lw \T00h_s, 20*8+4(a0)
    not \S17l_s, \S17l_s
    not \S17h_s, \S17h_s
    sw \S05l_s, 5*8(a0)
    sw \S05h_s, 5*8+4(a0)
    sw \S08l_s, 8*8(a0)
    sw \S08h_s, 8*8+4(a0)
    sw \S10l_s, 10*8(a0)
    sw \S10h_s, 10*8+4(a0)
    not \T00l_s, \T00l_s
    not \T00h_s, \T00h_s
    sw \S14l_s, 14*8(a0)
    sw \S14h_s, 14*8+4(a0)
    sw \T00l_s, 20*8(a0)
    sw \T00h_s, 20*8+4(a0)
    sw \S16l_s, 16*8(a0)
    sw \S16h_s, 16*8+4(a0)
    sw \S17l_s, 17*8(a0)
    sw \S17h_s, 17*8+4(a0)
    sw \S21l_s, 21*8(a0)
    sw \S21h_s, 21*8+4(a0)
    sw \S23l_s, 23*8(a0)
    sw \S23h_s, 23*8+4(a0)
.endm

.macro ARound \
        S02h_s, S02l_s, S04h_s, S04l_s, S05h_s, S05l_s, S08h_s, S08l_s, S10h_s, S10l_s, \
        S14h_s, S14l_s, S16h_s, S16l_s, S17h_s, S17l_s, S21h_s, S21l_s, S23h_s, S23l_s, \
        T00h_s, T00l_s, T01h_s, T01l_s, T02h_s, T02l_s, T03h_s, T03l_s, T04_s
    lw \T03l_s, 0*8(a0)
    lw \T03h_s, 0*8+4(a0)
    xor \T00l_s, \S05l_s, \S10l_s
    xor \T00h_s, \S05h_s, \S10h_s
    lw \T02l_s, 15*8(a0)
    lw \T02h_s, 15*8+4(a0)
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    lw \T03l_s, 20*8(a0)
    lw \T03h_s, 20*8+4(a0)
    xor \T00l_s, \T00l_s, \T02l_s
    xor \T00h_s, \T00h_s, \T02h_s
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    lw \T03l_s, 3*8(a0)
    lw \T03h_s, 3*8+4(a0)
    sw \T00l_s, 18*4(sp)
    sw \T00h_s, 19*4(sp)
    xor \T01l_s, \S08l_s, \S23l_s
    xor \T01h_s, \S08h_s, \S23h_s
    lw \T02l_s, 13*8(a0)
    lw \T02h_s, 13*8+4(a0)
    xor \T01l_s, \T01l_s, \T03l_s
    xor \T01h_s, \T01h_s, \T03h_s
    lw \T03l_s, 18*8(a0)
    lw \T03h_s, 18*8+4(a0)
    xor \T01l_s, \T01l_s, \T02l_s
    xor \T01h_s, \T01h_s, \T02h_s
    xor \T01l_s, \T01l_s, \T03l_s
    xor \T01h_s, \T01h_s, \T03h_s
    srli \T03h_s,   \T00l_s, 31
    slli \T00l_s, \T00l_s, 1
    srli \T03l_s,   \T00h_s, 31
    slli \T00h_s, \T00h_s, 1
    xor  \T00l_s, \T00l_s, \T03l_s
    xor  \T00h_s, \T00h_s, \T03h_s
    sw \T01l_s, 24*4(sp)
    sw \T01h_s, 25*4(sp)
    xor \T00l_s, \T00l_s, \T01l_s
    xor \T00h_s, \T00h_s, \T01h_s
    lw \T03l_s, 9*8(a0)
    lw \T03h_s, 9*8+4(a0)
    xor \T01l_s, \S04l_s, \S14l_s
    xor \T01h_s, \S04h_s, \S14h_s
    xor \S04l_s, \S04l_s, \T00l_s
    xor \S04h_s, \S04h_s, \T00h_s
    xor \S14l_s, \S14l_s, \T00l_s
    xor \S14h_s, \S14h_s, \T00h_s
    lw \T02l_s, 19*8(a0)
    lw \T02h_s, 19*8+4(a0)
    xor \T01l_s, \T01l_s, \T03l_s
    xor \T01h_s, \T01h_s, \T03h_s
    xor \T03l_s, \T03l_s, \T00l_s
    xor \T03h_s, \T03h_s, \T00h_s
    sw \T03l_s, 9*8(a0)
    sw \T03h_s, 9*8+4(a0)
    lw \T03l_s, 24*8(a0)
    lw \T03h_s, 24*8+4(a0)
    xor \T01l_s, \T01l_s, \T02l_s
    xor \T01h_s, \T01h_s, \T02h_s
    xor \T02l_s, \T02l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T01l_s, \T01l_s, \T03l_s
    xor \T01h_s, \T01h_s, \T03h_s
    sw \T02l_s, 19*8(a0)
    sw \T02h_s, 19*8+4(a0)
    xor \T03l_s, \T03l_s, \T00l_s
    xor \T03h_s, \T03h_s, \T00h_s
    sw \T01l_s, 26*4(sp)
    sw \T01h_s, 27*4(sp)
    sw \T03l_s, 24*8(a0)
    sw \T03h_s, 24*8+4(a0)
    lw \T03l_s, 1*8(a0)
    lw \T03h_s, 1*8+4(a0)
    xor \T00l_s, \S16l_s, \S21l_s
    xor \T00h_s, \S16h_s, \S21h_s
    lw \T02l_s, 6*8(a0)
    lw \T02h_s, 6*8+4(a0)
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    lw \T03l_s, 11*8(a0)
    lw \T03h_s, 11*8+4(a0)
    xor \T00l_s, \T00l_s, \T02l_s
    xor \T00h_s, \T00h_s, \T02h_s
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    sw \T00l_s, 20*4(sp)
    sw \T00h_s, 21*4(sp)
    srli \T03h_s,   \T00l_s, 31
    slli \T00l_s, \T00l_s, 1
    srli \T03l_s,   \T00h_s, 31
    slli \T00h_s, \T00h_s, 1
    xor  \T00l_s, \T00l_s, \T03l_s
    xor  \T00h_s, \T00h_s, \T03h_s
    lw \T02l_s, 0*8(a0)
    lw \T02h_s, 0*8+4(a0)
    xor \T00l_s, \T00l_s, \T01l_s
    xor \T00h_s, \T00h_s, \T01h_s
    xor \S05l_s, \S05l_s, \T00l_s
    xor \S05h_s, \S05h_s, \T00h_s
    lw \T03l_s, 20*8(a0)
    lw \T03h_s, 20*8+4(a0)
    xor \T02l_s, \T02l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    sw \T02l_s, 0*8(a0)
    sw \T02h_s, 0*8+4(a0)
    lw \T02l_s, 15*8(a0)
    lw \T02h_s, 15*8+4(a0)
    xor \S10l_s, \S10l_s, \T00l_s
    xor \S10h_s, \S10h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    sw \T02l_s, 15*8(a0)
    sw \T02h_s, 15*8+4(a0)
    xor \T03l_s, \T03l_s, \T00l_s
    xor \T03h_s, \T03h_s, \T00h_s
    lw \T02l_s, 24*4(sp)
    lw \T02h_s, 25*4(sp)
    lw \T00l_s, 20*4(sp)
    lw \T00h_s, 21*4(sp)
    sw \T03l_s, 20*8(a0)
    sw \T03h_s, 20*8+4(a0)
    srli \T03h_s,   \T02l_s, 31
    slli \T02l_s, \T02l_s, 1
    srli \T03l_s,   \T02h_s, 31
    slli \T02h_s, \T02h_s, 1
    xor  \T02l_s, \T02l_s, \T03l_s
    xor  \T02h_s, \T02h_s, \T03h_s
    lw \T03l_s, 7*8(a0)
    lw \T03h_s, 7*8+4(a0)
    xor \T02l_s, \T02l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    xor \T00l_s, \S02l_s, \S17l_s
    xor \T00h_s, \S02h_s, \S17h_s
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T03h_s, \T02h_s
    xor \S02l_s, \S02l_s, \T02l_s
    xor \S02h_s, \S02h_s, \T02h_s
    sw \T03l_s, 7*8(a0)
    sw \T03h_s, 7*8+4(a0)
    lw \T03l_s, 12*8(a0)
    lw \T03h_s, 12*8+4(a0)
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T03h_s, \T02h_s
    xor \S17l_s, \S17l_s, \T02l_s
    xor \S17h_s, \S17h_s, \T02h_s
    sw \T03l_s, 12*8(a0)
    sw \T03h_s, 12*8+4(a0)
    lw \T03l_s, 22*8(a0)
    lw \T03h_s, 22*8+4(a0)
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T03h_s, \T02h_s
    sw \T00l_s, 22*4(sp)
    sw \T00h_s, 23*4(sp)
    sw \T03l_s, 22*8(a0)
    sw \T03h_s, 22*8+4(a0)
    srli \T03h_s,   \T01l_s, 31
    slli \T01l_s, \T01l_s, 1
    srli \T03l_s,   \T01h_s, 31
    slli \T01h_s, \T01h_s, 1
    xor  \T01l_s, \T01l_s, \T03l_s
    xor  \T01h_s, \T01h_s, \T03h_s
    lw \T03l_s, 3*8(a0)
    lw \T03h_s, 3*8+4(a0)
    xor \T01l_s, \T01l_s, \T00l_s
    xor \T01h_s, \T01h_s, \T00h_s
    xor \S08l_s, \S08l_s, \T01l_s
    xor \S08h_s, \S08h_s, \T01h_s
    xor \T03l_s, \T03l_s, \T01l_s
    xor \T03h_s, \T03h_s, \T01h_s
    lw \T02l_s, 13*8(a0)
    lw \T02h_s, 13*8+4(a0)
    sw \T03l_s, 3*8(a0)
    sw \T03h_s, 3*8+4(a0)
    lw \T03l_s, 18*8(a0)
    lw \T03h_s, 18*8+4(a0)
    xor \T02l_s, \T02l_s, \T01l_s
    xor \T02h_s, \T02h_s, \T01h_s
    xor \S23l_s, \S23l_s, \T01l_s
    xor \S23h_s, \S23h_s, \T01h_s
    sw \T02l_s, 13*8(a0)
    sw \T02h_s, 13*8+4(a0)
    xor \T03l_s, \T03l_s, \T01l_s
    xor \T03h_s, \T03h_s, \T01h_s
    lw \T01l_s, 18*4(sp)
    lw \T01h_s, 19*4(sp)
    sw \T03l_s, 18*8(a0)
    sw \T03h_s, 18*8+4(a0)
    srli \T03h_s,   \T00l_s, 31
    slli \T00l_s, \T00l_s, 1
    srli \T03l_s,   \T00h_s, 31
    slli \T00h_s, \T00h_s, 1
    xor  \T00l_s, \T00l_s, \T03l_s
    xor  \T00h_s, \T00h_s, \T03h_s
    lw \T02l_s, 1*8(a0)
    lw \T02h_s, 1*8+4(a0)
    xor \T00l_s, \T00l_s, \T01l_s
    xor \T00h_s, \T00h_s, \T01h_s
    lw \T03l_s, 6*8(a0)
    lw \T03h_s, 6*8+4(a0)
    xor \S16l_s, \S16l_s, \T00l_s
    xor \S16h_s, \S16h_s, \T00h_s
    xor \S21l_s, \S21l_s, \T00l_s
    xor \S21h_s, \S21h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    sw \T02l_s, 1*8(a0)
    sw \T02h_s, 1*8+4(a0)
    xor \T03l_s, \T03l_s, \T00l_s
    xor \T03h_s, \T03h_s, \T00h_s
    lw \T02l_s, 11*8(a0)
    lw \T02h_s, 11*8+4(a0)
    sw \T03l_s, 6*8(a0)
    sw \T03h_s, 6*8+4(a0)
    xor \T02l_s, \T02l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    mv \T01l_s, \T03l_s
    mv \T01h_s, \T03h_s
    sw \T02l_s, 11*8(a0)
    sw \T02h_s, 11*8+4(a0)
    slli \T03l_s, \S21l_s, 2
    srli \S21l_s, \S21l_s, 30
    srli \T03h_s, \S21h_s, 30
    slli \S21h_s, \S21h_s, 2
    xor  \T03l_s, \T03l_s, \T03h_s
    xor  \T03h_s, \S21h_s, \S21l_s
    slli \T02h_s,  \T01l_s, 12
    srli \T01l_s, \T01l_s, 20
    slli \T02l_s,  \T01h_s, 12
    srli \T01h_s, \T01h_s, 20
    xor  \T01l_s, \T01l_s, \T02l_s
    xor  \T01h_s, \T01h_s, \T02h_s
    lw \T00l_s, 0*8(a0)
    lw \T00h_s, 0*8+4(a0)
    slli \S21l_s, \S08h_s, 23
    srli \S08h_s, \S08h_s, 9
    srli \S21h_s, \S08l_s, 9
    slli \S08l_s, \S08l_s, 23
    xor  \S21l_s, \S21l_s, \S21h_s
    xor  \S21h_s, \S08l_s, \S08h_s
    sw \T03l_s, 0*8(a0)
    sw \T03h_s, 0*8+4(a0)
    slli \S08l_s, \S16h_s, 13
    srli \S16h_s, \S16h_s, 19
    srli \S08h_s, \S16l_s, 19
    slli \S16l_s, \S16l_s, 13
    xor  \S08l_s, \S08l_s, \S08h_s
    xor  \S08h_s, \S16l_s, \S16h_s
    lw \T02l_s, 3*8(a0)
    lw \T02h_s, 3*8+4(a0)
    slli \S16l_s, \S05h_s, 4
    srli \S05h_s, \S05h_s, 28
    srli \S16h_s, \S05l_s, 28
    slli \S05l_s, \S05l_s, 4
    xor  \S16l_s, \S16l_s, \S16h_s
    xor  \S16h_s, \S05l_s, \S05h_s
    lw \T03l_s, 18*8(a0)
    lw \T03h_s, 18*8+4(a0)
    slli \S05l_s, \T02l_s, 28
    srli \T02l_s, \T02l_s, 4
    srli \S05h_s, \T02h_s, 4
    slli \T02h_s, \T02h_s, 28
    xor  \S05l_s, \S05l_s, \S05h_s
    xor  \S05h_s, \T02h_s, \T02l_s
    slli \T02l_s, \T03l_s, 21
    srli \T03l_s, \T03l_s, 11
    srli \T02h_s, \T03h_s, 11
    slli \T03h_s, \T03h_s, 21
    xor  \T02l_s, \T02l_s, \T02h_s
    xor  \T02h_s, \T03h_s, \T03l_s
    lw \T03l_s, 13*8(a0)
    lw \T03h_s, 13*8+4(a0)
    sw \T02l_s, 3*8(a0)
    sw \T02h_s, 3*8+4(a0)
    srli \T02h_s,   \T03l_s, 7
    slli \T03l_s, \T03l_s, 25
    srli \T02l_s,   \T03h_s, 7
    slli \T03h_s, \T03h_s, 25
    xor  \T03l_s, \T03l_s, \T02l_s
    xor  \T03h_s, \T03h_s, \T02h_s
    sw \T03l_s, 18*8(a0)
    sw \T03h_s, 18*8+4(a0)
    slli \T02l_s, \S10l_s, 3
    srli \S10l_s, \S10l_s, 29
    srli \T02h_s, \S10h_s, 29
    slli \S10h_s, \S10h_s, 3
    xor  \T02l_s, \T02l_s, \T02h_s
    xor  \T02h_s, \S10h_s, \S10l_s
    lw \T03l_s, 1*8(a0)
    lw \T03h_s, 1*8+4(a0)
    sw \T02l_s, 13*8(a0)
    sw \T02h_s, 13*8+4(a0)
    slli \S10l_s, \T03l_s, 1
    srli \T03l_s, \T03l_s, 31
    srli \S10h_s, \T03h_s, 31
    slli \T03h_s, \T03h_s, 1
    xor  \S10l_s, \S10l_s, \S10h_s
    xor  \S10h_s, \T03h_s, \T03l_s
    lw \T03l_s, 12*8(a0)
    lw \T03h_s, 12*8+4(a0)
    slli \T02l_s, \S02h_s, 30
    srli \S02h_s, \S02h_s, 2
    srli \T02h_s, \S02l_s, 2
    slli \S02l_s, \S02l_s, 30
    xor  \T02l_s, \T02l_s, \T02h_s
    xor  \T02h_s, \S02l_s, \S02h_s
    sw \T02l_s, 1*8(a0)
    sw \T02h_s, 1*8+4(a0)
    lw \T02l_s, 9*8(a0)
    lw \T02h_s, 9*8+4(a0)
    slli \S02l_s, \T03h_s, 11
    srli \T03h_s, \T03h_s, 21
    srli \S02h_s, \T03l_s, 21
    slli \T03l_s, \T03l_s, 11
    xor  \S02l_s, \S02l_s, \S02h_s
    xor  \S02h_s, \T03l_s, \T03h_s
    slli \T03l_s, \T02l_s, 20
    srli \T02l_s, \T02l_s, 12
    srli \T03h_s, \T02h_s, 12
    slli \T02h_s, \T02h_s, 20
    xor  \T03l_s, \T03l_s, \T03h_s
    xor  \T03h_s, \T02h_s, \T02l_s
    lw \T02l_s, 22*8(a0)
    lw \T02h_s, 22*8+4(a0)
    sw \T03l_s, 12*8(a0)
    sw \T03h_s, 12*8+4(a0)
    slli \T03h_s,  \T02l_s, 29
    srli \T02l_s, \T02l_s, 3
    slli \T03l_s,  \T02h_s, 29
    srli \T02h_s, \T02h_s, 3
    xor  \T02l_s, \T02l_s, \T03l_s
    xor  \T02h_s, \T02h_s, \T03h_s
    sw \T02l_s, 9*8(a0)
    sw \T02h_s, 9*8+4(a0)
    slli \T03l_s, \S14h_s, 7
    srli \S14h_s, \S14h_s, 25
    srli \T03h_s, \S14l_s, 25
    slli \S14l_s, \S14l_s, 7
    xor  \T03l_s, \T03l_s, \T03h_s
    xor  \T03h_s, \S14l_s, \S14h_s
    lw \T02l_s, 20*8(a0)
    lw \T02h_s, 20*8+4(a0)
    sw \T03l_s, 22*8(a0)
    sw \T03h_s, 22*8+4(a0)
    slli \S14l_s, \T02l_s, 18
    srli \T02l_s, \T02l_s, 14
    srli \S14h_s, \T02h_s, 14
    slli \T02h_s, \T02h_s, 18
    xor  \S14l_s, \S14l_s, \S14h_s
    xor  \S14h_s, \T02h_s, \T02l_s
    lw \T03l_s, 15*8(a0)
    lw \T03h_s, 15*8+4(a0)
    slli \T02l_s, \S23h_s, 24
    srli \S23h_s, \S23h_s, 8
    srli \T02h_s, \S23l_s, 8
    slli \S23l_s, \S23l_s, 24
    xor  \T02l_s, \T02l_s, \T02h_s
    xor  \T02h_s, \S23l_s, \S23h_s
    slli \S23l_s, \T03h_s, 9
    srli \T03h_s, \T03h_s, 23
    srli \S23h_s, \T03l_s, 23
    slli \T03l_s, \T03l_s, 9
    xor  \S23l_s, \S23l_s, \S23h_s
    xor  \S23h_s, \T03l_s, \T03h_s
    sw \T02l_s, 20*8(a0)
    sw \T02h_s, 20*8+4(a0)
    slli \T02l_s, \S04l_s, 27
    srli \S04l_s, \S04l_s, 5
    srli \T02h_s, \S04h_s, 5
    slli \S04h_s, \S04h_s, 27
    xor  \T02l_s, \T02l_s, \T02h_s
    xor  \T02h_s, \S04h_s, \S04l_s
    lw \T03l_s, 24*8(a0)
    lw \T03h_s, 24*8+4(a0)
    sw \T02l_s, 15*8(a0)
    sw \T02h_s, 15*8+4(a0)
    slli \S04l_s, \T03l_s, 14
    srli \T03l_s, \T03l_s, 18
    srli \S04h_s, \T03h_s, 18
    slli \T03h_s, \T03h_s, 14
    xor  \S04l_s, \S04l_s, \S04h_s
    xor  \S04h_s, \T03h_s, \T03l_s
    slli \T02l_s, \S17l_s, 15
    srli \S17l_s, \S17l_s, 17
    srli \T02h_s, \S17h_s, 17
    slli \S17h_s, \S17h_s, 15
    xor  \T02l_s, \T02l_s, \T02h_s
    xor  \T02h_s, \S17h_s, \S17l_s
    lw \T03l_s, 11*8(a0)
    lw \T03h_s, 11*8+4(a0)
    sw \T02l_s, 24*8(a0)
    sw \T02h_s, 24*8+4(a0)
    lw \T02h_s, 7*8(a0)
    lw \T02l_s, 7*8+4(a0)
    slli \S17l_s, \T03l_s, 10
    srli \T03l_s, \T03l_s, 22
    srli \S17h_s, \T03h_s, 22
    slli \T03h_s, \T03h_s, 10
    xor  \S17l_s, \S17l_s, \S17h_s
    xor  \S17h_s, \T03h_s, \T03l_s
    srli \T03h_s,   \T02h_s, 26
    slli \T02h_s, \T02h_s, 6
    srli \T03l_s,   \T02l_s, 26
    slli \T02l_s, \T02l_s, 6
    xor  \T02h_s, \T02h_s, \T03l_s
    xor  \T02l_s, \T02l_s, \T03h_s
    lw \T03l_s, 19*8(a0)
    lw \T03h_s, 19*8+4(a0)
    sw \T02h_s, 11*8(a0)
    sw \T02l_s, 11*8+4(a0)
    sw \T00l_s, 18*4(sp)
    sw \T00h_s, 19*4(sp)
    srli \T02h_s,   \T03l_s, 24
    slli \T03l_s, \T03l_s, 8
    srli \T02l_s,   \T03h_s, 24
    slli \T03h_s, \T03h_s, 8
    xor  \T03l_s, \T03l_s, \T02l_s
    xor  \T03h_s, \T03h_s, \T02h_s
    lw \T00l_s, 12*8(a0)
    lw \T00h_s, 12*8+4(a0)
    sw \T01l_s, 20*4(sp)
    sw \T01h_s, 21*4(sp)
    lw \T01l_s, 13*8(a0)
    lw \T01h_s, 13*8+4(a0)
    sw \T03l_s, 19*8(a0)
    sw \T03h_s, 19*8+4(a0)
    and \T03l_s, \T01l_s, \S08l_s
    and \T03h_s, \T01h_s, \S08h_s
    xor \T03l_s, \T00l_s, \T03l_s
    xor \T03h_s, \T00h_s, \T03h_s
    lw \T02l_s, 9*8(a0)
    lw \T02h_s, 9*8+4(a0)
    sw \T03l_s, 6*8(a0)
    sw \T03h_s, 6*8+4(a0)
    not \T03l_s, \T02l_s
    not \T03h_s, \T02h_s
    or \T03l_s, \T03l_s, \S08l_s
    or \T03h_s, \T03h_s, \S08h_s
    xor \T03l_s, \T01l_s, \T03l_s
    xor \T03h_s, \T01h_s, \T03h_s
    sw \T03l_s, 7*8(a0)
    sw \T03h_s, 7*8+4(a0)
    or \T03l_s, \T02l_s, \S05l_s
    or \T03h_s, \T02h_s, \S05h_s
    xor \S08l_s, \S08l_s, \T03l_s
    xor \S08h_s, \S08h_s, \T03h_s
    and \T03l_s, \S05l_s, \T00l_s
    and \T03h_s, \S05h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T03l_s
    xor \T02h_s, \T02h_s, \T03h_s
    or  \T03l_s, \T00l_s, \T01l_s
    or  \T03h_s, \T00h_s, \T01h_s
    lw \T01l_s, 19*8(a0)
    lw \T01h_s, 19*8+4(a0)
    sw \T02l_s, 9*8(a0)
    sw \T02h_s, 9*8+4(a0)
    lw \T00l_s, 18*8(a0)
    lw \T00h_s, 18*8+4(a0)
    xor \S05h_s, \S05h_s, \T03h_s
    xor \S05l_s, \S05l_s, \T03l_s
    not \T03l_s, \T01l_s
    not \T03h_s, \T01h_s
    and \T03l_s, \T03l_s, \S14l_s
    and \T03h_s, \T03h_s, \S14h_s
    xor \T03l_s, \T00l_s, \T03l_s
    xor \T03h_s, \T00h_s, \T03h_s
    lw \T02l_s, 11*8(a0)
    lw \T02h_s, 11*8+4(a0)
    sw \T03l_s, 12*8(a0)
    sw \T03h_s, 12*8+4(a0)
    not \T04_s, \T01h_s
    or  \T03h_s, \S14h_s, \S10h_s
    or  \T03l_s, \S14l_s, \S10l_s
    xor \T03h_s, \T03h_s, \T04_s
    not \T04_s, \T01l_s
    xor \T03l_s, \T03l_s, \T04_s
    sw \T03l_s, 13*8(a0)
    sw \T03h_s, 13*8+4(a0)
    and \T03l_s, \S10l_s, \T02l_s
    and \T03h_s, \S10h_s, \T02h_s
    xor \S14l_s, \S14l_s, \T03l_s
    xor \S14h_s, \S14h_s, \T03h_s
    or \T03l_s, \T02l_s, \T00l_s
    or \T03h_s, \T02h_s, \T00h_s
    xor \S10l_s, \S10l_s, \T03l_s
    xor \S10h_s, \S10h_s, \T03h_s
    and \T03l_s, \T00l_s, \T01l_s
    and \T03h_s, \T00h_s, \T01h_s
    xor \T02l_s, \T02l_s, \T03l_s
    xor \T02h_s, \T02h_s, \T03h_s
    lw \T00h_s, 24*8+4(a0)
    lw \T01h_s, 20*8+4(a0)
    sw \T02h_s, 11*8+4(a0)
    sw \T02l_s, 11*8(a0)
    lw \T02h_s, 15*8+4(a0)
    lw \T01l_s, 20*8(a0)
    lw \T02l_s, 15*8(a0)
    lw \T00l_s, 24*8(a0)
    not \T04_s, \T00h_s
    and \T03h_s, \T01h_s, \T02h_s
    and \T03l_s, \T01l_s, \T02l_s
    xor \T03h_s, \T03h_s, \T04_s
    not \T04_s, \T00l_s
    xor \T03l_s, \T03l_s, \T04_s
    sw \T03l_s, 18*8(a0)
    sw \T03h_s, 18*8+4(a0)
    or \T03l_s, \T02l_s, \S16l_s
    or \T03h_s, \T02h_s, \S16h_s
    xor \T03l_s, \T01l_s, \T03l_s
    xor \T03h_s, \T01h_s, \T03h_s
    sw \T03l_s, 19*8(a0)
    sw \T03h_s, 19*8+4(a0)
    and \T03l_s, \S16l_s, \S17l_s
    and \T03h_s, \S16h_s, \S17h_s
    xor \T02l_s, \T02l_s, \T03l_s
    xor \T02h_s, \T02h_s, \T03h_s
    sw \T02l_s, 15*8(a0)
    sw \T02h_s, 15*8+4(a0)
    or \T03l_s, \S17l_s, \T00l_s
    or \T03h_s, \S17h_s, \T00h_s
    xor \S16l_s, \S16l_s, \T03l_s
    xor \S16h_s, \S16h_s, \T03h_s
    lw \T02l_s, 22*8(a0)
    lw \T02h_s, 22*8+4(a0)
    not \T03l_s, \T00l_s
    not \T03h_s, \T00h_s
    lw \T00l_s, 0*8(a0)
    lw \T00h_s, 0*8+4(a0)
    or  \T03l_s, \T03l_s, \T01l_s
    or  \T03h_s, \T03h_s, \T01h_s
    lw \T01l_s, 1*8(a0)
    lw \T01h_s, 1*8+4(a0)
    xor \S17l_s, \S17l_s, \T03l_s
    xor \S17h_s, \S17h_s, \T03h_s
    and \T03l_s, \T01l_s, \S21l_s
    and \T03h_s, \T01h_s, \S21h_s
    xor \T03l_s, \T00l_s, \T03l_s
    xor \T03h_s, \T00h_s, \T03h_s
    sw \T03l_s, 24*8(a0)
    sw \T03h_s, 24*8+4(a0)
    not \T03l_s, \S21l_s
    not \T03h_s, \S21h_s
    and \T03l_s, \T03l_s, \T02l_s
    and \T03h_s, \T03h_s, \T02h_s
    xor \T03l_s, \T01l_s, \T03l_s
    xor \T03h_s, \T01h_s, \T03h_s
    sw \T03l_s, 20*8(a0)
    sw \T03h_s, 20*8+4(a0)
    not \T04_s, \S21h_s
    or  \T03h_s, \T02h_s, \S23h_s
    or  \T03l_s, \T02l_s, \S23l_s
    xor \S21h_s, \T03h_s, \T04_s
    not \T04_s, \S21l_s
    xor \S21l_s, \T03l_s, \T04_s
    and \T03l_s, \S23l_s, \T00l_s
    and \T03h_s, \S23h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T03l_s
    xor \T02h_s, \T02h_s, \T03h_s
    lw \T04_s, 17*4(sp)
    or  \T03l_s, \T00l_s, \T01l_s
    or  \T03h_s, \T00h_s, \T01h_s
    lw \T00l_s, 18*4(sp)
    lw \T00h_s, 19*4(sp)
    sw \T02l_s, 22*8(a0)
    sw \T02h_s, 22*8+4(a0)
    lw \T01l_s, 20*4(sp)
    lw \T01h_s, 21*4(sp)
    xor \S23h_s, \S23h_s, \T03h_s
    xor \S23l_s, \S23l_s, \T03l_s
    lw \T02l_s, 0(\T04_s)
    lw \T02h_s, 4(\T04_s)
    addi \T04_s, \T04_s, 8
    or \T03l_s, \T01l_s, \S02l_s
    or \T03h_s, \T01h_s, \S02h_s
    xor \T03l_s, \T00l_s, \T03l_s
    xor \T03h_s, \T00h_s, \T03h_s
    sw  \T04_s, 17*4(sp)
    xor \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T03h_s, \T02h_s
    lw \T02l_s, 3*8(a0)
    lw \T02h_s, 3*8+4(a0)
    sw \T03l_s, 0*8(a0)
    sw \T03h_s, 0*8+4(a0)
    not \T03l_s, \S02l_s
    not \T03h_s, \S02h_s
    or \T03l_s, \T03l_s, \T02l_s
    or \T03h_s, \T03h_s, \T02h_s
    xor \T03l_s, \T01l_s, \T03l_s
    xor \T03h_s, \T01h_s, \T03h_s
    sw \T03l_s, 1*8(a0)
    sw \T03h_s, 1*8+4(a0)
    and \T03l_s, \T02l_s, \S04l_s
    and \T03h_s, \T02h_s, \S04h_s
    xor \S02l_s, \S02l_s, \T03l_s
    xor \S02h_s, \S02h_s, \T03h_s
    lw \T04_s, 16*4(sp)
    or \T03l_s, \S04l_s, \T00l_s
    or \T03h_s, \S04h_s, \T00h_s
    xor \T03l_s, \T02l_s, \T03l_s
    xor \T03h_s, \T02h_s, \T03h_s
    sw \T03l_s, 3*8(a0)
    sw \T03h_s, 3*8+4(a0)
    addi \T04_s, \T04_s, -1
    and \T03l_s, \T00l_s, \T01l_s
    and \T03h_s, \T00h_s, \T01h_s
    xor \S04l_s, \S04l_s, \T03l_s
    xor \S04h_s, \S04h_s, \T03h_s
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
    la t0, constants_keccak
    SaveRegs
    sw t0, 17*4(sp)

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
    
    # lw tp, 16*4(sp)
    # addi tp, tp, -1
    bnez tp, loop_start

    FinalStore \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10,s11,ra, gp, tp

    RestoreRegs
    addi sp, sp, 4*28
    ret