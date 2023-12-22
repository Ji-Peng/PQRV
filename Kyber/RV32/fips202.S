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

.macro XOR5 outh, outl, \
            S00h, S00l, S05h, S05l,\
            S10h, S10l, S15h, S15l,\
            S20h, S20l
    xor \outh, \S00h, \S05h
    xor \outl, \S00l, \S05l
    xor \outh, \outh, \S10h
    xor \outl, \outl, \S10l
    xor \outh, \outh, \S15h
    xor \outl, \outl, \S15l
    xor \outh, \outh, \S20h
    xor \outl, \outl, \S20l
.endm

.macro XOR1Init outh, outl, in0h, in0l, in1h, in1l
    xor \outh, \in0h, \in1h
    xor \outl, \in0l, \in1l
.endm

.macro XOR1 outh, outl, inh, inl
    xor \outh, \outh, \inh
    xor \outl, \outl, \inl
.endm

.macro XOREach                 \
        S00h, S00l, S01h, S01l,\
        S02h, S02l, S03h, S03l,\
        S04h, S04l, Dh,   Dl
    XOR1 \S00h, \S00l, \Dh, \Dl
    XOR1 \S01h, \S01l, \Dh, \Dl
    XOR1 \S02h, \S02l, \Dh, \Dl
    XOR1 \S03h, \S03l, \Dh, \Dl
    XOR1 \S04h, \S04l, \Dh, \Dl
.endm

.macro ROLn outh, outl, S00h, S00l, T, n
.if \n < 32
    slli \outl, \S00l, \n
    srli \outh, \S00h, 32-\n
    xor  \outl, \outl, \outh
    srli \T,    \S00l, 32-\n
    slli \outh, \S00h, \n
    xor  \outh, \outh, \T
.else
    slli \outl, \S00h, \n-32
    srli \outh, \S00l, 64-\n
    xor  \outl, \outl, \outh
    srli \T,    \S00h, 64-\n
    slli \outh, \S00l, \n-32
    xor  \outh, \outh, \T
.endif
.endm

.macro ROLnInplace S00h, S00l, T0, T1, n
    srli \T0,   \S00l, 32-\n
    slli \S00l, \S00l, \n
    srli \T1,   \S00h, 32-\n
    slli \S00h, \S00h, \n
    xor  \S00l, \S00l, \T1
    xor  \S00h, \S00h, \T0
.endm

.macro ChiOp \
        outh, outl, \
        S00h, S00l, S01h, S01l, S02h, S02l, \
        Th, Tl
    not \Th, \S01h
    not \Tl, \S01l
    and \Th, \Th, \S02h
    and \Tl, \Tl, \S02l
    xor \outh, \Th, \S00h
    xor \outl, \Tl, \S00l
.endm

.macro ARound1 \
        S00h, S00l, S01h, S01l, S02h, S02l, S04h, S04l, S07h, S07l, \
        S08h, S08l, S15h, S15l, S16h, S16l, S18h, S18l, S19h, S19l, \
        T00h, T00l, T01h, T01l, T02h, T02l, T03h, T03l, T04
    # C0=S00+S05+S10+S15+S20
    lw \T03l, 5*8(a0)
    lw \T03h, 5*8+4(a0)
    XOR1Init \T00h, \T00l, \S00h, \S00l, \S15h, \S15l
    lw \T02l, 10*8(a0)
    lw \T02h, 10*8+4(a0)
    XOR1 \T00h, \T00l, \T03h, \T03l
    lw \T03l, 20*8(a0)
    lw \T03h, 20*8+4(a0)
    XOR1 \T00h, \T00l, \T02h, \T02l
    XOR1 \T00h, \T00l, \T03h, \T03l
    sw \T00l, 18*4(sp)
    sw \T00h, 19*4(sp)

    # T00=C0
    # C3=S03+S08+S13+S18+S23
    lw \T03l, 3*8(a0)
    lw \T03h, 3*8+4(a0)
    XOR1Init \T01h, \T01l, \S08h, \S08l, \S18h, \S18l
    lw \T02l, 13*8(a0)
    lw \T02h, 13*8+4(a0)
    XOR1 \T01h, \T01l, \T03h, \T03l
    lw \T03l, 23*8(a0)
    lw \T03h, 23*8+4(a0)
    XOR1 \T01h, \T01l, \T02h, \T02l
    XOR1 \T01h, \T01l, \T03h, \T03l
    sw \T01l, 24*4(sp)
    sw \T01h, 25*4(sp)

    # T00=C0, T01=C3
    # D4=C3^ROL(C0,1);
    ROLnInplace \T00h, \T00l, \T03h, \T03l, 1
    XOR1 \T00h, \T00l, \T01h, \T01l
    # T00=D4

    # C4=S04+S09+S14+S19+S24
    # S04,S09,S14,S19,S24 += D4
    lw \T03l, 9*8(a0)
    lw \T03h, 9*8+4(a0)
    XOR1Init \T01h, \T01l, \S04h, \S04l, \S19h, \S19l
    XOR1 \S04h, \S04l, \T00h, \T00l
    XOR1 \S19h, \S19l, \T00h, \T00l
    lw \T02l, 14*8(a0)
    lw \T02h, 14*8+4(a0)
    XOR1 \T01h, \T01l, \T03h, \T03l
    XOR1 \T03h, \T03l, \T00h, \T00l
    sw \T03l, 9*8(a0)
    sw \T03h, 9*8+4(a0)
    lw \T03l, 24*8(a0)
    lw \T03h, 24*8+4(a0)
    XOR1 \T01h, \T01l, \T02h, \T02l
    XOR1 \T02h, \T02l, \T00h, \T00l
    sw \T02l, 14*8(a0)
    sw \T02h, 14*8+4(a0)
    XOR1 \T01h, \T01l, \T03h, \T03l
    XOR1 \T03h, \T03l, \T00h, \T00l
    sw \T03l, 24*8(a0)
    sw \T03h, 24*8+4(a0)
    sw \T01l, 26*4(sp)
    sw \T01h, 27*4(sp)
    # T01=C4

    # C1=S01+S06+S11+S16+S21
    lw \T03l, 06*8(a0)
    lw \T03h, 06*8+4(a0)
    XOR1Init \T00h, \T00l, \S01h, \S01l, \S16h, \S16l
    lw \T02l, 11*8(a0)
    lw \T02h, 11*8+4(a0)
    XOR1 \T00h, \T00l, \T03h, \T03l
    lw \T03l, 21*8(a0)
    lw \T03h, 21*8+4(a0)
    XOR1 \T00h, \T00l, \T02h, \T02l
    XOR1 \T00h, \T00l, \T03h, \T03l
    sw \T00l, 20*4(sp)
    sw \T00h, 21*4(sp)
    # T01=C4,T00=C1

    # D0=C4^ROL(C1,1)
    ROLnInplace \T00h, \T00l, \T03h, \T03l, 1
    XOR1 \T00h, \T00l, \T01h, \T01l
    # T01=C4,T00=D0

    # S00,S05,S10,S15,S20 += D0
    lw \T02l, 5*8(a0)
    lw \T02h, 5*8+4(a0)
    XOR1 \S00h, \S00l, \T00h, \T00l
    XOR1 \T02h, \T02l, \T00h, \T00l
    sw \T02l, 5*8(a0)
    sw \T02h, 5*8+4(a0)
    lw \T02l, 10*8(a0)
    lw \T02h, 10*8+4(a0)
    XOR1 \S15h, \S15l, \T00h, \T00l
    XOR1 \T02h, \T02l, \T00h, \T00l
    sw \T02l, 10*8(a0)
    sw \T02h, 10*8+4(a0)
    lw \T02l, 20*8(a0)
    lw \T02h, 20*8+4(a0)
    XOR1 \T02h, \T02l, \T00h, \T00l
    sw \T02l, 20*8(a0)
    sw \T02h, 20*8+4(a0)

    # T01=C4
    # D2=C1^ROL(C3,1)
    lw \T02l, 24*4(sp)
    lw \T02h, 25*4(sp)
    ROLnInplace \T02h, \T02l, \T03h, \T03l, 1
    lw \T03l, 20*4(sp)
    lw \T03h, 21*4(sp)
    XOR1 \T02h, \T02l, \T03h, \T03l

    # T01=C4,T02=D2
    # C2=S02+S07+S12+S17+S22
    # S02,S07,S12,S17,S22 += D2
    lw \T03l, 12*8(a0)
    lw \T03h, 12*8+4(a0)
    XOR1Init \T00h, \T00l, \S02h, \S02l, \S07h, \S07l
    XOR1 \T00h, \T00l, \T03h, \T03l
    XOR1 \T03h, \T03l, \T02h, \T02l
    sw \T03l, 12*8(a0)
    sw \T03h, 12*8+4(a0)
    lw \T03l, 17*8(a0)
    lw \T03h, 17*8+4(a0)
    XOR1 \T00h, \T00l, \T03h, \T03l
    XOR1 \T03h, \T03l, \T02h, \T02l
    sw \T03l, 17*8(a0)
    sw \T03h, 17*8+4(a0)
    lw \T03l, 22*8(a0)
    lw \T03h, 22*8+4(a0)
    XOR1 \T00h, \T00l, \T03h, \T03l
    XOR1 \T03h, \T03l, \T02h, \T02l
    sw \T03l, 22*8(a0)
    sw \T03h, 22*8+4(a0)
    sw \T00l, 22*4(sp)
    sw \T00h, 23*4(sp)
    XOR1 \S02h, \S02l, \T02h, \T02l
    XOR1 \S07h, \S07l, \T02h, \T02l
    # T01=C4,T00=C2

    # D3=C2^ROL(C4,1)
    ROLnInplace \T01h, \T01l, \T03h, \T03l, 1
    XOR1 \T01h, \T01l, \T00h, \T00l
    # T01=D3

    # S03,S08,S13,S18,S23 += D3
    lw \T03l, 3*8(a0)
    lw \T03h, 3*8+4(a0)
    XOR1 \S08h, \S08l, \T01h, \T01l
    XOR1 \T03h, \T03l, \T01h, \T01l
    sw \T03l, 3*8(a0)
    sw \T03h, 3*8+4(a0)
    lw \T03l, 13*8(a0)
    lw \T03h, 13*8+4(a0)
    XOR1 \S18h, \S18l, \T01h, \T01l
    XOR1 \T03h, \T03l, \T01h, \T01l
    sw \T03l, 13*8(a0)
    sw \T03h, 13*8+4(a0)
    lw \T03l, 23*8(a0)
    lw \T03h, 23*8+4(a0)
    XOR1 \T03h, \T03l, \T01h, \T01l
    sw \T03l, 23*8(a0)
    sw \T03h, 23*8+4(a0)

    # T00=C2
    # D1=C0^ROL(C2,1)
    lw \T01l, 18*4(sp)
    lw \T01h, 19*4(sp)
    ROLnInplace \T00h, \T00l, \T03h, \T03l, 1
    XOR1 \T00h, \T00l, \T01h, \T01l
    # T00=D1

    # S01,S06,S11,S16,S21 += D1
    lw \T02l, 06*8(a0)
    lw \T02h, 06*8+4(a0)
    XOR1 \S01h, \S01l, \T00h, \T00l
    XOR1 \T02h, \T02l, \T00h, \T00l
    sw \T02l, 06*8(a0)
    sw \T02h, 06*8+4(a0)
    lw \T02l, 11*8(a0)
    lw \T02h, 11*8+4(a0)
    XOR1 \S16h, \S16l, \T00h, \T00l
    XOR1 \T02h, \T02l, \T00h, \T00l
    sw \T02l, 11*8(a0)
    sw \T02h, 11*8+4(a0)
    lw \T02l, 21*8(a0)
    lw \T02h, 21*8+4(a0)
    XOR1 \T02h, \T02l, \T00h, \T00l
    sw \T02l, 21*8(a0)
    sw \T02h, 21*8+4(a0)

    # TODO: A00可优化
    # TODO: 流水线有优化空间的，可减少指令间的依赖
    mv \T00h, \S00h
    mv \T00l, \S00l
    # ROLn \T01h, \T01l, \S06h, \S06l, 44
    lw \T02l, 6*8(a0)
    lw \T02h, 6*8+4(a0)
    ROLn \T01h, \T01l, \T02h, \T02l, \T04, 44
    # ROLn \S00h, \S00l, \S02h, \S02l, 62
    ROLn \S00h, \S00l, \S02h, \S02l, \T04, 62
    # ROLn \S02h, \S02l, \S12h, \S12l, 43
    lw \T02l, 12*8(a0)
    lw \T02h, 12*8+4(a0)
    ROLn \S02h, \S02l, \T02h, \T02l, \T04, 43
    # ROLn \S12h, \S12l, \S13h, \S13l, 25
    lw \T03l, 13*8(a0)
    lw \T03h, 13*8+4(a0)
    ROLn \T02h, \T02l, \T03h, \T03l, \T04, 25
    sw \T02l, 12*8(a0)
    sw \T02h, 12*8+4(a0)
    # ROLn \S13h, \S13l, \S19h, \S19l, 8
    ROLn \T02h, \T02l, \S19h, \S19l, \T04, 8
    sw \T02l, 13*8(a0)
    sw \T02h, 13*8+4(a0)
    # ROLn \S19h, \S19l, \S23h, \S23l, 56
    lw \T02l, 23*8(a0)
    lw \T02h, 23*8+4(a0)
    ROLn \S19h, \S19l, \T02h, \T02l, \T04, 56
    # ROLn \S23h, \S23l, \S15h, \S15l, 41
    ROLn \T02h, \T02l, \S15h, \S15l, \T04, 41
    sw \T02l, 23*8(a0)
    sw \T02h, 23*8+4(a0)
    # ROLn \S15h, \S15l, \S01h, \S01l, 1
    ROLn \S15h, \S15l, \S01h, \S01l, \T04, 1
    # ROLn \S01h, \S01l, \S08h, \S08l, 55
    ROLn \S01h, \S01l, \S08h, \S08l, \T04, 55
    # ROLn \S08h, \S08l, \S16h, \S16l, 45
    ROLn \S08h, \S08l, \S16h, \S16l, \T04, 45
    # ROLn \S16h, \S16l, \S07h, \S07l, 6
    ROLn \S16h, \S16l, \S07h, \S07l, \T04, 6
    # ROLn \S07h, \S07l, \S10h, \S10l, 3
    lw \T02l, 10*8(a0)
    lw \T02h, 10*8+4(a0)
    ROLn \S07h, \S07l, \T02h, \T02l, \T04, 3
    # ROLn \S10h, \S10l, \S03h, \S03l, 28
    lw \T03l, 3*8(a0)
    lw \T03h, 3*8+4(a0)
    ROLn \T02h, \T02l, \T03h, \T03l, \T04, 28
    sw \T02l, 10*8(a0)
    sw \T02h, 10*8+4(a0)
    # ROLn \S03h, \S03l, \S18h, \S18l, 21
    ROLn \T02h, \T02l, \S18h, \S18l, \T04, 21
    sw \T02l, 3*8(a0)
    sw \T02h, 3*8+4(a0)
    # ROLn \S18h, \S18l, \S17h, \S17l, 15
    lw \T02l, 17*8(a0)
    lw \T02h, 17*8+4(a0)
    ROLn \S18h, \S18l, \T02h, \T02l, \T04, 15
    # ROLn \S17h, \S17l, \S11h, \S11l, 10
    lw \T03l, 11*8(a0)
    lw \T03h, 11*8+4(a0)
    ROLn \T02h, \T02l, \T03h, \T03l, \T04, 10
    sw \T02l, 17*8(a0)
    sw \T02h, 17*8+4(a0)
    # ROLn \S11h, \S11l, \S09h, \S09l, 20
    lw \T03l, 9*8(a0)
    lw \T03h, 9*8+4(a0)
    ROLn \T02h, \T02l, \T03h, \T03l, \T04, 20
    sw \T02l, 11*8(a0)
    sw \T02h, 11*8+4(a0)
    # ROLn \S09h, \S09l, \S22h, \S22l, 61
    lw \T03l, 22*8(a0)
    lw \T03h, 22*8+4(a0)
    ROLn \T02h, \T02l, \T03h, \T03l, \T04, 61
    sw \T02l, 9*8(a0)
    sw \T02h, 9*8+4(a0)
    # ROLn \S22h, \S22l, \S14h, \S14l, 39
    lw \T03l, 14*8(a0)
    lw \T03h, 14*8+4(a0)
    ROLn \T02h, \T02l, \T03h, \T03l, \T04, 39
    sw \T02l, 22*8(a0)
    sw \T02h, 22*8+4(a0)
    # ROLn \S14h, \S14l, \S20h, \S20l, 18
    lw \T03l, 20*8(a0)
    lw \T03h, 20*8+4(a0)
    ROLn \T02h, \T02l, \T03h, \T03l, \T04, 18
    sw \T02l, 14*8(a0)
    sw \T02h, 14*8+4(a0)
    # ROLn \S20h, \S20l, \S04h, \S04l, 27
    ROLn \T02h, \T02l, \S04h, \S04l, \T04, 27
    sw \T02l, 20*8(a0)
    sw \T02h, 20*8+4(a0)
    # ROLn \S04h, \S04l, \S24h, \S24l, 14
    lw \T02l, 24*8(a0)
    lw \T02h, 24*8+4(a0)
    ROLn \S04h, \S04l, \T02h, \T02l, \T04, 14
    # ROLn \S24h, \S24l, \S21h, \S21l, 2
    lw \T03l, 21*8(a0)
    lw \T03h, 21*8+4(a0)
    ROLn \T02h, \T02l, \T03h, \T03l, \T04, 2
    sw \T02l, 24*8(a0)
    sw \T02h, 24*8+4(a0)
    # ROLn \S21h, \S21l, \S05h, \S05l, 36
    lw \T03l, 5*8(a0)
    lw \T03h, 5*8+4(a0)
    ROLn \T02h, \T02l, \T03h, \T03l, \T04, 36
    sw \T02l, 21*8(a0)
    sw \T02h, 21*8+4(a0)

    # store T00,T01
    sw \T00l, 18*4(sp)
    sw \T00h, 19*4(sp)
    sw \T01l, 20*4(sp)
    sw \T01h, 21*4(sp)

    # TODO: 这里也能调优流水
    # chi - start
    # T00,T01,S07,S08,T02=S'05-S'09
    lw \T00l, 10*8(a0)
    lw \T00h, 10*8+4(a0)
    lw \T01l, 11*8(a0)
    lw \T01h, 11*8+4(a0)
    lw \T02l, 9*8(a0)
    lw \T02h, 9*8+4(a0)
    ChiOp \T03h, \T03l, \T00h, \T00l, \T01h, \T01l, \S07h, \S07l, \T03h, \T03l
    sw \T03l, 5*8(a0)
    sw \T03h, 5*8+4(a0)
    ChiOp \T03h, \T03l, \T01h, \T01l, \S07h, \S07l, \S08h, \S08l, \T03h, \T03l
    sw \T03l, 6*8(a0)
    sw \T03h, 6*8+4(a0)
    ChiOp \S07h, \S07l, \S07h, \S07l, \S08h, \S08l, \T02h, \T02l, \T03h, \T03l
    ChiOp \S08h, \S08l, \S08h, \S08l, \T02h, \T02l, \T00h, \T00l, \T03h, \T03l
    ChiOp \T02h, \T02l, \T02h, \T02l, \T00h, \T00l, \T01h, \T01l, \T03h, \T03l
    sw \T02l, 9*8(a0)
    sw \T02h, 9*8+4(a0)

    # S15,S16,T00,T01,T02=S'10-S'14
    lw \T00l, 12*8(a0)
    lw \T00h, 12*8+4(a0)
    lw \T01l, 13*8(a0)
    lw \T01h, 13*8+4(a0)
    lw \T02l, 14*8(a0)
    lw \T02h, 14*8+4(a0)
    ChiOp \T03h, \T03l, \T00h, \T00l, \T01h, \T01l, \T02h, \T02l, \T03h, \T03l
    sw \T03l, 12*8(a0)
    sw \T03h, 12*8+4(a0)
    ChiOp \T03h, \T03l, \T01h, \T01l, \T02h, \T02l, \S15h, \S15l, \T03h, \T03l
    sw \T03l, 13*8(a0)
    sw \T03h, 13*8+4(a0)
    ChiOp \T03h, \T03l, \T02h, \T02l, \S15h, \S15l, \S16h, \S16l, \T03h, \T03l
    sw \T03l, 14*8(a0)
    sw \T03h, 14*8+4(a0)
    ChiOp \S15h, \S15l, \S15h, \S15l, \S16h, \S16l, \T00h, \T00l, \T03h, \T03l
    ChiOp \S16h, \S16l, \S16h, \S16l, \T00h, \T00l, \T01h, \T01l, \T03h, \T03l

    sw \S15l, 10*8(a0)
    sw \S15h, 10*8+4(a0)
    sw \S16l, 11*8(a0)
    sw \S16h, 11*8+4(a0)

    # T00,T01,T02,S18,S19=S'15-S'19
    lw \T00l, 20*8(a0)
    lw \T00h, 20*8+4(a0)
    lw \T01l, 21*8(a0)
    lw \T01h, 21*8+4(a0)
    lw \T02l, 17*8(a0)
    lw \T02h, 17*8+4(a0)
    ChiOp \T03h, \T03l, \T00h, \T00l, \T01h, \T01l, \T02h, \T02l, \T03h, \T03l
    mv \S15l, \T03l
    mv \S15h, \T03h
    ChiOp \T03h, \T03l, \T01h, \T01l, \T02h, \T02l, \S18h, \S18l, \T03h, \T03l
    mv \S16l, \T03l
    mv \S16h, \T03h
    ChiOp \T03h, \T03l, \T02h, \T02l, \S18h, \S18l, \S19h, \S19l, \T03h, \T03l
    sw \T03l, 17*8(a0)
    sw \T03h, 17*8+4(a0)
    ChiOp \S18h, \S18l, \S18h, \S18l, \S19h, \S19l, \T00h, \T00l, \T03h, \T03l
    ChiOp \S19h, \S19l, \S19h, \S19l, \T00h, \T00l, \T01h, \T01l, \T03h, \T03l

    # S00,S01,T00,T01,T02=S'20-S'24
    lw \T00l, 22*8(a0)
    lw \T00h, 22*8+4(a0)
    lw \T01l, 23*8(a0)
    lw \T01h, 23*8+4(a0)
    lw \T02l, 24*8(a0)
    lw \T02h, 24*8+4(a0)
    ChiOp \T03h, \T03l, \T00h, \T00l, \T01h, \T01l, \T02h, \T02l, \T03h, \T03l
    sw \T03l, 22*8(a0)
    sw \T03h, 22*8+4(a0)
    ChiOp \T03h, \T03l, \T01h, \T01l, \T02h, \T02l, \S00h, \S00l, \T03h, \T03l
    sw \T03l, 23*8(a0)
    sw \T03h, 23*8+4(a0)
    ChiOp \T03h, \T03l, \T02h, \T02l, \S00h, \S00l, \S01h, \S01l, \T03h, \T03l
    sw \T03l, 24*8(a0)
    sw \T03h, 24*8+4(a0)
    ChiOp \S00h, \S00l, \S00h, \S00l, \S01h, \S01l, \T00h, \T00l, \T03h, \T03l
    ChiOp \S01h, \S01l, \S01h, \S01l, \T00h, \T00l, \T01h, \T01l, \T03h, \T03l

    sw \S00l, 20*8(a0)
    sw \S00h, 20*8+4(a0)
    sw \S01l, 21*8(a0)
    sw \S01h, 21*8+4(a0)

    # T00,T01,S02,T02,S04=S'00-S'04
    # restore T00,T01 from stack
    lw \T00l, 18*4(sp)
    lw \T00h, 19*4(sp)
    lw \T01l, 20*4(sp)
    lw \T01h, 21*4(sp)
    lw \T02l, 3*8(a0)
    lw \T02h, 3*8+4(a0)
    ChiOp \T03h, \T03l, \T00h, \T00l, \T01h, \T01l, \S02h, \S02l, \T03h, \T03l
    mv \S00h, \T03h
    mv \S00l, \T03l
    ChiOp \T03h, \T03l, \T01h, \T01l, \S02h, \S02l, \T02h, \T02l, \T03h, \T03l
    mv \S01h, \T03h
    mv \S01l, \T03l
    ChiOp \S02h, \S02l, \S02h, \S02l, \T02h, \T02l, \S04h, \S04l, \T03h, \T03l
    ChiOp \T03h, \T03l, \T02h, \T02l, \S04h, \S04l, \T00h, \T00l, \T03h, \T03l
    sw \T03l, 3*8(a0)
    sw \T03h, 3*8+4(a0)
    ChiOp \S04h, \S04l, \S04h, \S04l, \T00h, \T00l, \T01h, \T01l, \T03h, \T03l

    lw \T01l, 17*4(sp)
    lw \T02l, 0(\T01l)
    lw \T02h, 4(\T01l)
    XOR1 \S00h, \S00l, \T02h, \T02l
    addi \T01l, \T01l, 8
    sw  \T01l, 17*4(sp)

    # for debug
    # sw \S00l, 0*8(a0)
    # sw \S00h, 0*8+4(a0)
    # sw \S01l, 1*8(a0)
    # sw \S01h, 1*8+4(a0)
    # sw \S02l, 2*8(a0)
    # sw \S02h, 2*8+4(a0)
    # sw \S04l, 4*8(a0)
    # sw \S04h, 4*8+4(a0)
    # sw \S07l, 7*8(a0)
    # sw \S07h, 7*8+4(a0)
    # sw \S08l, 8*8(a0)
    # sw \S08h, 8*8+4(a0)
    # sw \S15l, 15*8(a0)
    # sw \S15h, 15*8+4(a0)
    # sw \S16l, 16*8(a0)
    # sw \S16h, 16*8+4(a0)
    # sw \S18l, 18*8(a0)
    # sw \S18h, 18*8+4(a0)
    # sw \S19l, 19*8(a0)
    # sw \S19h, 19*8+4(a0)
    # chi - end
.endm

.macro InitLoad1 \
        S00h, S00l, S01h, S01l, S02h, S02l, S04h, S04l, S07h, S07l, \
        S08h, S08l, S15h, S15l, S16h, S16l, S18h, S18l, S19h, S19l
    lw \S00l, 0*8(a0)
    lw \S00h, 0*8+4(a0)
    lw \S01l, 1*8(a0)
    lw \S01h, 1*8+4(a0)
    lw \S02l, 2*8(a0)
    lw \S02h, 2*8+4(a0)
    lw \S04l, 4*8(a0)
    lw \S04h, 4*8+4(a0)
    lw \S07l, 7*8(a0)
    lw \S07h, 7*8+4(a0)
    lw \S08l, 8*8(a0)
    lw \S08h, 8*8+4(a0)
    lw \S15l, 15*8(a0)
    lw \S15h, 15*8+4(a0)
    lw \S16l, 16*8(a0)
    lw \S16h, 16*8+4(a0)
    lw \S18l, 18*8(a0)
    lw \S18h, 18*8+4(a0)
    lw \S19l, 19*8(a0)
    lw \S19h, 19*8+4(a0)
.endm

.macro FinalStore1 \
        S00h, S00l, S01h, S01l, S02h, S02l, S04h, S04l, S07h, S07l, \
        S08h, S08l, S15h, S15l, S16h, S16l, S18h, S18l, S19h, S19l
    sw \S00l, 0*8(a0)
    sw \S00h, 0*8+4(a0)
    sw \S01l, 1*8(a0)
    sw \S01h, 1*8+4(a0)
    sw \S02l, 2*8(a0)
    sw \S02h, 2*8+4(a0)
    sw \S04l, 4*8(a0)
    sw \S04h, 4*8+4(a0)
    sw \S07l, 7*8(a0)
    sw \S07h, 7*8+4(a0)
    sw \S08l, 8*8(a0)
    sw \S08h, 8*8+4(a0)
    sw \S15l, 15*8(a0)
    sw \S15h, 15*8+4(a0)
    sw \S16l, 16*8(a0)
    sw \S16h, 16*8+4(a0)
    sw \S18l, 18*8(a0)
    sw \S18h, 18*8+4(a0)
    sw \S19l, 19*8(a0)
    sw \S19h, 19*8+4(a0)
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

    InitLoad1 \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5

    li tp, 24

loop_start:
    sw tp, 16*4(sp)
    ARound1 \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
        s6, s7, s8, s9, s10,s11,ra, gp, tp
    
    lw tp, 16*4(sp)
    addi tp, tp, -1
    bnez tp, loop_start

    FinalStore1 \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, s1, s2, s3, s4, s5
    # ARoundInit \
    #     a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
    #     t3, t4, t5, t6, s0, s1, s2, s3, s4, s5, \
    #     s6, s7, s8, s9, s10,s11,ra, gp, tp, a0

    RestoreRegs
    addi sp, sp, 4*28
    ret