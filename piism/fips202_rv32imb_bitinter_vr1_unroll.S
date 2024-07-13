.data
.align 2
constants_keccak:
.word 0x00000001
.word 0x00000000
.word 0x00000000
.word 0x00000089
.word 0x00000000
.word 0x8000008b
.word 0x00000000
.word 0x80008080
.word 0x00000001
.word 0x0000008b
.word 0x00000001
.word 0x00008000
.word 0x00000001
.word 0x80008088
.word 0x00000001
.word 0x80000082
.word 0x00000000
.word 0x0000000b
.word 0x00000000
.word 0x0000000a
.word 0x00000001
.word 0x00008082
.word 0x00000000
.word 0x00008003
.word 0x00000001
.word 0x0000808b
.word 0x00000001
.word 0x8000000b
.word 0x00000001
.word 0x8000008a
.word 0x00000001
.word 0x80000081
.word 0x00000000
.word 0x80000081
.word 0x00000000
.word 0x80000008
.word 0x00000000
.word 0x00000083
.word 0x00000000
.word 0x80008003
.word 0x00000001
.word 0x80008088
.word 0x00000000
.word 0x80000088
.word 0x00000001
.word 0x00008000
.word 0x00000000
.word 0x80008082

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
        S14h, S14l, S16h, S16l, S17h, S17l, S21h, S21l, S23h, S23l
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
    lw \S23l, 23*8(a0)
    lw \S23h, 23*8+4(a0)
.endm

.macro FinalStore \
        S02h, S02l, S04h, S04l, S05h, S05l, S08h, S08l, S10h, S10l, \
        S14h, S14l, S16h, S16l, S17h, S17l, S21h, S21l, S23h, S23l
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
    sw \T01l_s, 24*4(sp)
    sw \T01h_s, 25*4(sp)
    rori \T03h_s, \T00h_s, 32-1
    xor  \T00h_s, \T00l_s, \T01h_s
    xor  \T00l_s, \T03h_s, \T01l_s
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
    rori \T03h_s, \T00h_s, 32-1
    xor  \T00h_s, \T00l_s, \T01h_s
    xor  \T00l_s, \T03h_s, \T01l_s
    lw \T02l_s, 0*8(a0)
    lw \T02h_s, 0*8+4(a0)
    xor \S05l_s, \S05l_s, \T00l_s
    xor \S05h_s, \S05h_s, \T00h_s
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
    lw \T03l_s, 20*8(a0)
    lw \T03h_s, 20*8+4(a0)
    sw \T02l_s, 15*8(a0)
    sw \T02h_s, 15*8+4(a0)
    lw \T02h_s, 25*4(sp)
    lw \T02l_s, 24*4(sp)
    xor \T03l_s, \T03l_s, \T00l_s
    xor \T03h_s, \T03h_s, \T00h_s
    sw \T03l_s, 20*8(a0)
    sw \T03h_s, 20*8+4(a0)
    lw \T00h_s, 21*4(sp)
    lw \T00l_s, 20*4(sp)
    rori \T03h_s, \T02h_s, 32-1
    xor  \T02h_s, \T02l_s, \T00h_s
    xor  \T02l_s, \T03h_s, \T00l_s
    lw \T03l_s, 7*8(a0)
    lw \T03h_s, 7*8+4(a0)
    xor \T00l_s, \S02l_s, \S17l_s
    xor \T00h_s, \S02h_s, \S17h_s
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T03h_s, \T02h_s
    sw \T03l_s, 7*8(a0)
    sw \T03h_s, 7*8+4(a0)
    lw \T03l_s, 12*8(a0)
    lw \T03h_s, 12*8+4(a0)
    xor \S02l_s, \S02l_s, \T02l_s
    xor \S02h_s, \S02h_s, \T02h_s
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T03h_s, \T02h_s
    sw \T03l_s, 12*8(a0)
    sw \T03h_s, 12*8+4(a0)
    lw \T03l_s, 22*8(a0)
    lw \T03h_s, 22*8+4(a0)
    xor \S17l_s, \S17l_s, \T02l_s
    xor \S17h_s, \S17h_s, \T02h_s
    xor \T00l_s, \T00l_s, \T03l_s
    xor \T00h_s, \T00h_s, \T03h_s
    xor \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T03h_s, \T02h_s
    sw \T00l_s, 22*4(sp)
    sw \T00h_s, 23*4(sp)
    sw \T03l_s, 22*8(a0)
    sw \T03h_s, 22*8+4(a0)
    rori \T03h_s, \T01h_s, 32-1
    xor  \T01h_s, \T01l_s, \T00h_s
    xor  \T01l_s, \T03h_s, \T00l_s
    lw \T03l_s, 3*8(a0)
    lw \T03h_s, 3*8+4(a0)
    xor \S08l_s, \S08l_s, \T01l_s
    xor \S08h_s, \S08h_s, \T01h_s
    xor \T03l_s, \T03l_s, \T01l_s
    xor \T03h_s, \T03h_s, \T01h_s
    lw \T02l_s, 13*8(a0)
    lw \T02h_s, 13*8+4(a0)
    sw \T03l_s, 3*8(a0)
    sw \T03h_s, 3*8+4(a0)
    xor \T02l_s, \T02l_s, \T01l_s
    xor \T02h_s, \T02h_s, \T01h_s
    lw \T03l_s, 18*8(a0)
    lw \T03h_s, 18*8+4(a0)
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
    rori \T03h_s, \T00h_s, 32-1
    xor  \T00h_s, \T00l_s, \T01h_s
    xor  \T00l_s, \T03h_s, \T01l_s
    lw \T02l_s, 1*8(a0)
    lw \T02h_s, 1*8+4(a0)
    xor \S16l_s, \S16l_s, \T00l_s
    xor \S16h_s, \S16h_s, \T00h_s
    xor \T02l_s, \T02l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    lw \T03l_s, 6*8(a0)
    lw \T03h_s, 6*8+4(a0)
    sw \T02l_s, 1*8(a0)
    sw \T02h_s, 1*8+4(a0)
    xor \T03l_s, \T03l_s, \T00l_s
    xor \T03h_s, \T03h_s, \T00h_s
    lw \T02l_s, 11*8(a0)
    lw \T02h_s, 11*8+4(a0)
    xor \S21l_s, \S21l_s, \T00l_s
    xor \S21h_s, \S21h_s, \T00h_s
    sw \T03l_s, 6*8(a0)
    sw \T03h_s, 6*8+4(a0)
    xor \T02l_s, \T02l_s, \T00l_s
    xor \T02h_s, \T02h_s, \T00h_s
    sw \T02l_s, 11*8(a0)
    sw \T02h_s, 11*8+4(a0)
    mv \T02l_s, \T03l_s
    mv \T02h_s, \T03h_s
    rori \T03l_s, \S21l_s, 31
    rori \T03h_s, \S21h_s, 31
    lw \T00l_s, 0*8(a0)
    lw \T00h_s, 0*8+4(a0)
    rori \T01l_s, \T02l_s, 10
    rori \T01h_s, \T02h_s, 10
    sw \T03l_s, 0*8(a0)
    sw \T03h_s, 0*8+4(a0)
    rori \S21h_s, \S08l_s, 5
    rori \S21l_s, \S08h_s, 4
    lw \T02l_s, 3*8(a0)    
    lw \T02h_s, 3*8+4(a0)
    rori \S08h_s, \S16l_s, 10
    rori \S08l_s, \S16h_s, 9
    lw \T03l_s, 18*8(a0)
    lw \T03h_s, 18*8+4(a0)
    rori \S16l_s, \S05l_s, 14
    rori \S16h_s, \S05h_s, 14
    sw \T00l_s, 18*4(sp)
    sw \T00h_s, 19*4(sp)
    rori \S05l_s, \T02l_s, 18
    rori \S05h_s, \T02h_s, 18
    rori \T02h_s, \T03l_s, 22
    rori \T02l_s, \T03h_s, 21
    sw \T02l_s, 3*8(a0)
    sw \T02h_s, 3*8+4(a0)
    lw \T02l_s, 13*8+4(a0)
    lw \T02h_s, 13*8(a0)
    rori \T03h_s, \T02h_s, 20
    rori \T03l_s, \T02l_s, 19
    sw \T03l_s, 18*8(a0)
    sw \T03h_s, 18*8+4(a0)
    rori \T02h_s, \S10l_s, 31
    rori \T02l_s, \S10h_s, 30
    lw \T03l_s, 1*8(a0)
    lw \T03h_s, 1*8+4(a0)
    sw \T02l_s, 13*8(a0)
    sw \T02h_s, 13*8+4(a0)
    mv \S10h_s, \T03l_s
    rori \S10l_s, \T03h_s, 31
    sw \T01l_s, 20*4(sp)
    sw \T01h_s, 21*4(sp)
    rori \T02l_s, \S02l_s, 1
    rori \T02h_s, \S02h_s, 1
    lw \T03l_s, 12*8(a0)
    lw \T03h_s, 12*8+4(a0)
    sw \T02l_s, 1*8(a0)
    sw \T02h_s, 1*8+4(a0)
    lw \T02l_s, 9*8(a0)
    lw \T02h_s, 9*8+4(a0)
    rori \S02h_s, \T03l_s, 11
    rori \S02l_s, \T03h_s, 10
    rori \T03l_s, \T02l_s, 22
    rori \T03h_s, \T02h_s, 22
    sw \T03l_s, 12*8(a0)
    sw \T03h_s, 12*8+4(a0)
    lw \T03l_s,  22*8(a0)
    lw \T03h_s, 22*8+4(a0)
    rori \T02h_s, \T03l_s, 2
    rori \T02l_s, \T03h_s, 1
    sw \T02l_s, 9*8(a0)
    sw \T02h_s, 9*8+4(a0)
    rori \T03h_s, \S14l_s, 13
    rori \T03l_s, \S14h_s, 12
    lw \T02l_s, 20*8(a0)
    lw \T02h_s, 20*8+4(a0)
    sw \T03l_s, 22*8(a0)
    sw \T03h_s, 22*8+4(a0)
    rori \S14l_s, \T02l_s, 23
    rori \S14h_s, \T02h_s, 23
    rori \T02l_s, \S23l_s, 4
    rori \T02h_s, \S23h_s, 4
    lw \T03l_s, 15*8(a0)
    lw \T03h_s, 15*8+4(a0)
    sw \T02l_s, 20*8(a0)
    sw \T02h_s, 20*8+4(a0)
    rori \S23h_s, \T03l_s, 12
    rori \S23l_s, \T03h_s, 11
    rori \T02h_s, \S04l_s, 19
    rori \T02l_s, \S04h_s, 18
    lw \T03l_s, 24*8(a0)
    lw \T03h_s, 24*8+4(a0)
    sw \T02l_s, 15*8(a0)
    sw \T02h_s, 15*8+4(a0)
    rori \S04l_s, \T03l_s, 25
    rori \S04h_s, \T03h_s, 25
    rori \T02h_s, \S17l_s, 25
    rori \T02l_s, \S17h_s, 24
    lw \T03l_s, 11*8(a0)
    lw \T03h_s, 11*8+4(a0)
    sw \T02l_s, 24*8(a0)
    sw \T02h_s, 24*8+4(a0)
    lw \T02l_s, 7*8+4(a0)
    lw \T02h_s, 7*8(a0)
    rori \S17l_s, \T03l_s, 27
    rori \S17h_s, \T03h_s, 27
    rori \T03l_s, \T02h_s, 29
    rori \T03h_s, \T02l_s, 29
    lw \T02l_s, 19*8(a0)
    lw \T02h_s, 19*8+4(a0)
    sw \T03l_s, 11*8(a0)
    sw \T03h_s, 11*8+4(a0)
    rori \T03l_s, \T02l_s, 28
    rori \T03h_s, \T02h_s, 28
    lw \T01l_s, 13*8(a0)
    lw \T01h_s, 13*8+4(a0)
    sw \T03l_s, 19*8(a0)
    sw \T03h_s, 19*8+4(a0)
    lw \T00l_s, 12*8(a0)
    lw \T00h_s, 12*8+4(a0)
    andn \T03l_s, \S08l_s, \T01l_s
    andn \T03h_s, \S08h_s, \T01h_s
    xor \T03l_s, \T03l_s, \T00l_s
    xor \T03h_s, \T03h_s, \T00h_s
    lw \T02l_s, 9*8(a0)
    lw \T02h_s, 9*8+4(a0)
    sw \T03l_s, 6*8(a0)
    sw \T03h_s, 6*8+4(a0)
    andn \T03l_s, \T02l_s, \S08l_s
    andn \T03h_s, \T02h_s, \S08h_s
    xor \T03l_s, \T03l_s, \T01l_s
    xor \T03h_s, \T03h_s, \T01h_s
    sw \T03l_s, 7*8(a0)
    sw \T03h_s, 7*8+4(a0)
    andn \T03l_s, \S05l_s, \T02l_s
    andn \T03h_s, \S05h_s, \T02h_s
    xor \S08l_s, \T03l_s, \S08l_s
    xor \S08h_s, \T03h_s, \S08h_s
    andn \T03l_s, \T00l_s, \S05l_s
    andn \T03h_s, \T00h_s, \S05h_s
    xor \T02l_s, \T03l_s, \T02l_s
    xor \T02h_s, \T03h_s, \T02h_s
    sw \T02l_s, 9*8(a0)
    sw \T02h_s, 9*8+4(a0)
    andn \T03l_s, \T01l_s, \T00l_s
    andn \T03h_s, \T01h_s, \T00h_s
    lw \T01l_s, 19*8(a0)
    lw \T01h_s, 19*8+4(a0)
    xor \S05h_s, \T03h_s, \S05h_s
    xor \S05l_s, \T03l_s, \S05l_s
    lw \T00l_s, 18*8(a0)
    lw \T00h_s, 18*8+4(a0)
    andn \T03l_s, \S14l_s, \T01l_s
    andn \T03h_s, \S14h_s, \T01h_s
    lw \T02l_s, 11*8(a0)
    lw \T02h_s, 11*8+4(a0)
    xor  \T03l_s, \T03l_s, \T00l_s
    xor  \T03h_s, \T03h_s, \T00h_s
    sw \T03l_s, 12*8(a0)
    sw \T03h_s, 12*8+4(a0)
    andn \T03l_s, \S10l_s, \S14l_s
    andn \T03h_s, \S10h_s, \S14h_s
    xor \T03l_s, \T03l_s, \T01l_s
    xor \T03h_s, \T03h_s, \T01h_s
    sw \T03l_s, 13*8(a0)
    sw \T03h_s, 13*8+4(a0)
    andn \T03l_s, \T02l_s, \S10l_s
    andn \T03h_s, \T02h_s, \S10h_s
    xor \S14l_s, \T03l_s, \S14l_s
    xor \S14h_s, \T03h_s, \S14h_s
    andn \T03l_s, \T00l_s, \T02l_s
    andn \T03h_s, \T00h_s, \T02h_s
    xor \S10l_s, \T03l_s, \S10l_s
    xor \S10h_s, \T03h_s, \S10h_s
    andn \T03l_s, \T01l_s, \T00l_s
    andn \T03h_s, \T01h_s, \T00h_s
    xor \T02l_s, \T03l_s, \T02l_s
    xor \T02h_s, \T03h_s, \T02h_s
    lw \T01l_s, 20*8(a0)
    lw \T01h_s, 20*8+4(a0)
    sw \T02l_s, 11*8(a0)
    sw \T02h_s, 11*8+4(a0)
    lw \T02l_s, 15*8(a0)
    lw \T02h_s, 15*8+4(a0)
    lw \T00l_s, 24*8(a0)
    lw \T00h_s, 24*8+4(a0)
    andn \T03l_s, \T02l_s, \T01l_s
    andn \T03h_s, \T02h_s, \T01h_s
    xor \T03l_s, \T03l_s, \T00l_s
    xor \T03h_s, \T03h_s, \T00h_s
    sw \T03l_s, 18*8(a0)
    sw \T03h_s, 18*8+4(a0)
    andn \T03l_s, \S16l_s, \T02l_s
    andn \T03h_s, \S16h_s, \T02h_s
    xor \T03l_s, \T03l_s, \T01l_s
    xor \T03h_s, \T03h_s, \T01h_s
    sw \T03l_s, 19*8(a0)
    sw \T03h_s, 19*8+4(a0)
    andn \T03l_s, \S17l_s, \S16l_s
    andn \T03h_s, \S17h_s, \S16h_s
    xor \T02l_s, \T03l_s, \T02l_s
    xor \T02h_s, \T03h_s, \T02h_s
    sw \T02l_s, 15*8(a0)
    sw \T02h_s, 15*8+4(a0)
    andn \T03l_s, \T00l_s, \S17l_s
    andn \T03h_s, \T00h_s, \S17h_s
    xor \S16l_s, \T03l_s, \S16l_s
    xor \S16h_s, \T03h_s, \S16h_s
    andn \T03l_s, \T01l_s, \T00l_s
    andn \T03h_s, \T01h_s, \T00h_s
    lw \T00l_s, 0*8(a0)
    lw \T00h_s, 0*8+4(a0)
    xor \S17h_s, \S17h_s, \T03h_s
    xor \S17l_s, \S17l_s, \T03l_s
    lw \T01l_s, 1*8(a0)
    lw \T01h_s, 1*8+4(a0)
    lw \T02l_s, 22*8(a0)
    lw \T02h_s, 22*8+4(a0)
    andn \T03l_s, \S21l_s, \T01l_s
    andn \T03h_s, \S21h_s, \T01h_s
    xor \T03l_s, \T03l_s, \T00l_s
    xor \T03h_s, \T03h_s, \T00h_s
    sw \T03l_s, 24*8(a0)
    sw \T03h_s, 24*8+4(a0)
    andn \T03l_s, \T02l_s, \S21l_s
    andn \T03h_s, \T02h_s, \S21h_s
    xor \T03l_s, \T03l_s, \T01l_s
    xor \T03h_s, \T03h_s, \T01h_s
    sw \T03l_s, 20*8(a0)
    sw \T03h_s, 20*8+4(a0)
    andn \T03l_s, \S23l_s, \T02l_s
    andn \T03h_s, \S23h_s, \T02h_s
    xor \S21l_s, \T03l_s, \S21l_s
    xor \S21h_s, \T03h_s, \S21h_s
    lw \T04_s, 17*4(sp)
    andn \T03l_s, \T00l_s, \S23l_s
    andn \T03h_s, \T00h_s, \S23h_s
    xor \T02l_s, \T03l_s, \T02l_s
    xor \T02h_s, \T03h_s, \T02h_s
    sw \T02l_s, 22*8(a0)
    sw \T02h_s, 22*8+4(a0)
    andn \T03l_s, \T01l_s, \T00l_s
    andn \T03h_s, \T01h_s, \T00h_s
    lw \T00l_s, 18*4(sp)
    lw \T00h_s, 19*4(sp)
    xor \S23h_s, \S23h_s, \T03h_s
    xor \S23l_s, \S23l_s, \T03l_s
    lw \T01l_s, 20*4(sp)
    lw \T01h_s, 21*4(sp)
    lw \T02l_s, 0(\T04_s)
    lw \T02h_s, 4(\T04_s)
    addi \T04_s, \T04_s, 8
    andn \T03l_s, \S02l_s, \T01l_s
    andn \T03h_s, \S02h_s, \T01h_s
    xor \T03l_s, \T03l_s, \T00l_s
    xor \T03h_s, \T03h_s, \T00h_s
    sw   \T04_s, 17*4(sp)
    xor \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T03h_s, \T02h_s
    lw \T02l_s, 3*8(a0)
    lw \T02h_s, 3*8+4(a0)
    sw \T03l_s, 0*8(a0)
    sw \T03h_s, 0*8+4(a0)
    andn \T03l_s, \T02l_s, \S02l_s
    andn \T03h_s, \T02h_s, \S02h_s
    xor \T03l_s, \T03l_s, \T01l_s
    xor \T03h_s, \T03h_s, \T01h_s
    sw \T03l_s, 1*8(a0)
    sw \T03h_s, 1*8+4(a0)
    andn \T03l_s, \T00l_s, \S04l_s
    andn \T03h_s, \T00h_s, \S04h_s
    xor \T03l_s, \T03l_s, \T02l_s
    xor \T03h_s, \T03h_s, \T02h_s
    sw \T03l_s, 3*8(a0)
    sw \T03h_s, 3*8+4(a0)
    andn \T03l_s, \S04l_s, \T02l_s
    andn \T03h_s, \S04h_s, \T02h_s
    xor \S02l_s, \T03l_s, \S02l_s
    xor \S02h_s, \T03h_s, \S02h_s
    lw  \T04_s, 16*4(sp)
    andn \T03l_s, \T01l_s, \T00l_s
    andn \T03h_s, \T01h_s, \T00h_s
    xor \S04l_s, \T03l_s, \S04l_s
    xor \S04h_s, \T03h_s, \S04h_s
    addi \T04_s, \T04_s, -1
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
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5

    li tp, 24

loop_start:
    sw tp, 16*4(sp)
    ARound \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10,s11,ra, gp, tp
    bnez tp, loop_start

    FinalStore \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5

    RestoreRegs
    addi sp, sp, 4*28
    ret