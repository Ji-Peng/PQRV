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

.macro ROLn outh, outl, S00h, S00l, n
.if \n < 32
    slli \outl, \S00l, \n
    srli \S00l, \S00l, 32-\n
    srli \outh, \S00h, 32-\n
    slli \S00h, \S00h, \n
    xor  \outl, \outl, \outh
    xor  \outh, \S00h, \S00l
.else
    slli \outl, \S00h, \n-32
    srli \S00h, \S00h, 64-\n
    srli \outh, \S00l, 64-\n
    slli \S00l, \S00l, \n-32
    xor  \outl, \outl, \outh
    xor  \outh, \S00l, \S00h
.endif
.endm

.macro ROLn_t outh, outl, S00h, S00l, tmph, tmpl, n
.if \n < 32
    slli \outl, \S00l, \n
    srli \tmpl, \S00l, 32-\n
    srli \outh, \S00h, 32-\n
    slli \tmph, \S00h, \n
    xor  \outl, \outl, \outh
    xor  \outh, \tmph, \tmpl
.else
    slli \outl, \S00h, \n-32
    srli \tmph, \S00h, 64-\n
    srli \outh, \S00l, 64-\n
    slli \tmpl, \S00l, \n-32
    xor  \outl, \outl, \outh
    xor  \outh, \tmpl, \tmph
.endif
.endm

.macro ROLnInplace S00h, S00l, T0, T1, n
.if \n < 32
    srli \T0,   \S00l, 32-\n
    slli \S00l, \S00l, \n
    srli \T1,   \S00h, 32-\n
    slli \S00h, \S00h, \n
    xor  \S00l, \S00l, \T1
    xor  \S00h, \S00h, \T0
.else
    slli \T0,  \S00l, \n-32
    srli \S00l,\S00l, 64-\n
    slli \T1,  \S00h, \n-32
    srli \S00h,\S00h, 64-\n
    xor  \S00l,\S00l, \T1
    xor  \S00h,\S00h, \T0
.endif
.endm

.macro xoror outh, outl, S00h, S00l, S01h, S01l, S02h, S02l, Th, Tl
    or \Tl, \S01l, \S02l
    or \Th, \S01h, \S02h
    xor \outl, \S00l, \Tl
    xor \outh, \S00h, \Th
.endm

.macro xornotor outh, outl, S00h, S00l, S01h, S01l, S02h, S02l, Th, Tl
    not \Tl, \S01l
    not \Th, \S01h
    or \Tl, \Tl, \S02l
    or \Th, \Th, \S02h
    xor \outl, \S00l, \Tl
    xor \outh, \S00h, \Th
.endm

.macro xorand outh, outl, S00h, S00l, S01h, S01l, S02h, S02l, Th, Tl
    and \Tl, \S01l, \S02l
    and \Th, \S01h, \S02h
    xor \outl, \S00l, \Tl
    xor \outh, \S00h, \Th
.endm

.macro xorornot outh, outl, S00h, S00l, S01h, S01l, S02h, S02l, Th, Tl
    not \Tl, \S02l
    not \Th, \S02h
    or \Tl, \Tl, \S01l
    or \Th, \Th, \S01h
    xor \outl, \S00l, \Tl
    xor \outh, \S00h, \Th
.endm

.macro xornotand outh, outl, S00h, S00l, S01h, S01l, S02h, S02l, Th, Tl
    not \Tl, \S01l
    not \Th, \S01h
    and \Tl, \Tl, \S02l
    and \Th, \Th, \S02h
    xor \outl, \S00l, \Tl
    xor \outh, \S00h, \Th
.endm

.macro notxoror outh, outl, S00h, S00l, S01h, S01l, S02h, S02l, Th, Tl, T0
    not \T0, \S00h
    or  \Th, \S01h, \S02h
    or  \Tl, \S01l, \S02l
    xor \outh, \Th, \T0
    not \T0, \S00l
    xor \outl, \Tl, \T0
.endm

.macro notxorand outh, outl, S00h, S00l, S01h, S01l, S02h, S02l, Th, Tl, T0
    not \T0, \S00h
    and \Th, \S01h, \S02h
    and \Tl, \S01l, \S02l
    xor \outh, \Th, \T0
    not \T0, \S00l
    xor \outl, \Tl, \T0
.endm

.macro InitLoad \
        S00l, S01l, S02l, S03l, S04l, S05l, S06l, S07l, S08l, \
        S09l, S10l, S11l, S12l, S13l, S14l \
        T0, T1, T2, T3, T4, T5, T6, T7
    # lane complement: 1,2,8,12,17,20
    lw \T0,  1*8+4(a0)
    lw \T1,  2*8+4(a0)
    lw \T2,  8*8+4(a0)
    lw \T3,  12*8+4(a0)
    lw \T4,  17*8+0(a0)
    lw \T5,  17*8+4(a0)
    lw \T6,  20*8+0(a0)
    lw \T7,  20*8+4(a0)
    not \T0, \T0
    not \T1, \T1
    not \T2, \T2
    not \T3, \T3
    not \T4, \T4
    not \T5, \T5
    not \T6, \T6
    not \T7, \T7
    sw \T0,  1*8+4(a0)
    sw \T1,  2*8+4(a0)
    sw \T2,  8*8+4(a0)
    sw \T3,  12*8+4(a0)
    sw \T4,  17*8+0(a0)
    sw \T5,  17*8+4(a0)
    sw \T6,  20*8+0(a0)
    sw \T7,  20*8+4(a0)
    lw \S00l,  0*8(a0)
    lw \S01l,  1*8(a0)
    lw \S02l,  2*8(a0)
    lw \S03l,  3*8(a0)
    lw \S04l,  4*8(a0)
    lw \S05l,  5*8(a0)
    lw \S06l,  6*8(a0)
    lw \S07l,  7*8(a0)
    lw \S08l,  8*8(a0)
    lw \S09l,  9*8(a0)
    lw \S10l, 10*8(a0)
    lw \S11l, 11*8(a0)
    lw \S12l, 12*8(a0)
    lw \S13l, 13*8(a0)
    lw \S14l, 14*8(a0)
    not \S01l, \S01l
    not \S02l, \S02l
    not \S08l, \S08l
    not \S12l, \S12l
.endm

.macro FinalStore \
        S00l, S01l, S02l, S03l, S04l, S05l, S06l, S07l, S08l, \
        S09l, S10l, S11l, S12l, S13l, S14l, \
        T0, T1, T2, T3, T4, T5, T6, T7
    # lane complement: 1,2,8,12,17,20
    lw \T0,  1*8+4(a0)
    lw \T1,  2*8+4(a0)
    lw \T2,  8*8+4(a0)
    lw \T3,  12*8+4(a0)
    lw \T4,  17*8+0(a0)
    lw \T5,  17*8+4(a0)
    lw \T6,  20*8+0(a0)
    lw \T7,  20*8+4(a0)
    not \T0, \T0
    not \T1, \T1
    not \T2, \T2
    not \T3, \T3
    not \T4, \T4
    not \T5, \T5
    not \T6, \T6
    not \T7, \T7
    sw \T0,  1*8+4(a0)
    sw \T1,  2*8+4(a0)
    sw \T2,  8*8+4(a0)
    sw \T3,  12*8+4(a0)
    sw \T4,  17*8+0(a0)
    sw \T5,  17*8+4(a0)
    sw \T6,  20*8+0(a0)
    sw \T7,  20*8+4(a0)
    not \S01l, \S01l
    not \S02l, \S02l
    not \S08l, \S08l
    not \S12l, \S12l
    sw \S00l,  0*8(a0)
    sw \S01l,  1*8(a0)
    sw \S02l,  2*8(a0)
    sw \S03l,  3*8(a0)
    sw \S04l,  4*8(a0)
    sw \S05l,  5*8(a0)
    sw \S06l,  6*8(a0)
    sw \S07l,  7*8(a0)
    sw \S08l,  8*8(a0)
    sw \S09l,  9*8(a0)
    sw \S10l, 10*8(a0)
    sw \S11l, 11*8(a0)
    sw \S12l, 12*8(a0)
    sw \S13l, 13*8(a0)
    sw \S14l, 14*8(a0)
.endm

.macro ARound \
        S00l, S01l, S02l, S03l, S04l, S05l, S06l, S07l, S08l, \
        S09l, S10l, S11l, S12l, S13l, S14l, \
        T0, T1, T2, T3, \
        C0l, C0h, C1l, C1h, C2l, C2h, C3l, C3h, C4l, C4h
    # C0=S00+S05+S10+S15+S20
    lw  \T2,   0*8+4(a0)
    lw  \C3l,  5*8+4(a0)
    lw  \C3h,  10*8+4(a0)
    xor \C0l, \S00l, \S05l
    xor \C0h, \T2,   \C3l
    lw  \T0,  15*8+0(a0)
    lw  \C4l, 15*8+4(a0)
    xor \C0l, \C0l,  \S10l
    xor \C0h, \C0h,  \C3h
    lw  \T1,  20*8+0(a0)
    lw  \C4h, 20*8+4(a0)
    xor \C0l, \C0l,  \T0
    xor \C0h, \C0h,  \C4l
    lw  \T2,  2*8+4(a0)
    lw  \C3l, 7*8+4(a0)
    xor \C0l, \C0l,  \T1
    xor \C0h, \C0h,  \C4h
    # C2=S02+S07+S12+S17+S22
    lw  \C3h, 12*8+4(a0)
    lw  \T0,  17*8+0(a0)
    xor \C2l, \S02l, \S07l
    xor \C2h, \T2,   \C3l
    lw  \C4l, 17*8+4(a0)
    lw  \T1,  22*8+0(a0)
    xor \C2l, \C2l,  \S12l
    xor \C2h, \C2h,  \C3h
    lw  \C4h, 22*8+4(a0)
    xor \C2l, \C2l,  \T0
    xor \C2h, \C2h,  \C4l
    lw  \T2,   1*8+4(a0)
    lw  \C3l,  6*8+4(a0)
    xor \C2l, \C2l,  \T1
    xor \C2h, \C2h,  \C4h
    # D1=C0^ROL(C2,1)=C4h,C4l
    ROLn_t \C4h, \C4l, \C2h, \C2l, \T1, \T0, 1
    xor  \C4l, \C4l, \C0l
    xor  \C4h, \C4h, \C0h
    # C1=S01+S06+S11+S16+S21
    # S01,S06,S11,S16,S21 += D1
    lw  \C3h, 11*8+4(a0)
    lw  \T0,  16*8+0(a0)
    xor \C1l, \S01l, \S06l
    xor \C1h, \T2,   \C3l
    xor \T2,   \T2,  \C4h
    xor \C3l,  \C3l, \C4h
    xor \S01l, \S01l, \C4l
    xor \S06l, \S06l, \C4l
    sw  \T2,  1*8+4(a0)
    sw  \C3l, 6*8+4(a0)
    xor \C1l, \C1l,  \S11l
    xor \C1h, \C1h,  \C3h
    lw  \T1,  21*8+0(a0)
    lw  \C3l, 16*8+4(a0)
    xor \C3h,  \C3h,  \C4h
    xor \S11l, \S11l, \C4l
    sw  \C3h, 11*8+4(a0)
    xor \C1l, \C1l,  \T0
    xor \C1h, \C1h,  \C3l
    lw  \C3h, 21*8+4(a0)
    xor \T0,  \T0,  \C4l
    xor \C3l, \C3l, \C4h
    sw  \T0,  16*8+0(a0)
    sw  \C3l, 16*8+4(a0)
    xor \C1l, \C1l,  \T1
    xor \C1h, \C1h,  \C3h
    xor \T1,  \T1,  \C4l
    xor \C3h, \C3h, \C4h
    sw  \T1,  21*8+0(a0)
    sw  \C3h, 21*8+4(a0)
    # C4=S04+S09+S14+S19+S24
    lw  \T0,  4*8+4(a0)
    lw  \T1,  9*8+4(a0)
    lw  \T2, 14*8+4(a0)
    xor \C4l, \S04l, \S09l
    xor \C4h, \T0,   \T1
    lw  \T0,  19*8+0(a0)
    lw  \T1,  19*8+4(a0)
    xor \C4l, \C4l,  \S14l
    xor \C4h, \C4h,  \T2
    lw  \T2,  24*8+0(a0)
    xor \C4l, \C4l,  \T0
    lw  \T0,  24*8+4(a0)
    xor \C4h, \C4h,  \T1
    xor \C4l, \C4l,  \T2
    xor \C4h, \C4h,  \T0
    # D3=C2^ROL(C4,1)=C2h,C2l
    # C3=S03+S08+S13+S18+S23
    # S03,S08,S13,S18,S23 += D3
    ROLn_t \C3h, \C3l, \C4h, \C4l, \T1, \T0, 1
    lw  \T0,  3*8+4(a0)
    lw  \T1,  8*8+4(a0)
    xor  \C2l, \C2l, \C3l
    xor  \C2h, \C2h, \C3h
    xor \C3l,  \S03l, \S08l
    xor \C3h,  \T0,   \T1
    lw  \T2, 13*8+4(a0)
    xor \S03l, \S03l, \C2l
    xor \S08l, \S08l, \C2l
    xor \T0,   \T0,   \C2h
    xor \T1,   \T1,   \C2h
    sw  \T0, 3*8+4(a0)
    sw  \T1, 8*8+4(a0)
    xor \C3l, \C3l,  \S13l
    xor \C3h, \C3h,  \T2
    lw  \T0, 18*8+0(a0)
    lw  \T1, 18*8+4(a0)
    xor \S13l, \S13l, \C2l
    xor \T2,   \T2,   \C2h
    sw  \T2, 13*8+4(a0)
    xor \C3l, \C3l,  \T0
    xor \C3h, \C3h,  \T1
    lw  \T2, 23*8+0(a0)
    xor \T0,  \T0,   \C2l
    xor \T1,  \T1,   \C2h
    sw  \T0, 18*8+0(a0)
    sw  \T1, 18*8+4(a0)
    lw  \T0, 23*8+4(a0)
    xor \C3l, \C3l,  \T2
    xor \C3h, \C3h,  \T0
    xor \T2,  \T2,  \C2l
    xor \T0,  \T0,  \C2h
    sw  \T2,  23*8+0(a0)
    sw  \T0,  23*8+4(a0)
    # D4=C3^ROL(C0,1)=T1,T0
    ROLnInplace \C0h, \C0l, \T1, \T0, 1
    xor  \T0, \C0l, \C3l
    xor  \T1, \C0h, \C3h
    # D2=C1^ROL(C3,1)=C3h,C3l
    ROLnInplace \C3h, \C3l, \C0h, \C0l, 1
    xor  \C3l, \C3l, \C1l
    xor  \C3h, \C3h, \C1h
    # D0=C4^ROL(C1,1)=C1h,C1l
    ROLnInplace \C1h, \C1l, \C0h, \C0l, 1
    xor  \C1l, \C1l, \C4l
    xor  \C1h, \C1h, \C4h
    # D0,D2,D4={C1h,C1l},{C3h,C3l},{T1,T0}
    # S00,S05,S10,S15,S20 += D0
    lw  \C0l, 15*8+0(a0)
    lw  \C0h, 20*8+0(a0)
    xor \S00l, \S00l, \C1l
    xor \S05l, \S05l, \C1l
    xor \S10l, \S10l, \C1l
    xor \C0l,  \C0l,  \C1l
    xor \C0h,  \C0h,  \C1l
    lw  \C2l,  0*8+4(a0)
    lw  \C2h,  5*8+4(a0)
    sw  \C0l, 15*8+0(a0)
    sw  \C0h, 20*8+0(a0)
    xor \C2l,  \C2l,  \C1h
    xor \C2h,  \C2h,  \C1h
    lw  \C0l, 10*8+4(a0)
    lw  \C0h, 15*8+4(a0)
    # sw  \C2l,  0*8+4(a0)
    # store S00 to stack
    sw  \C2l,  19*4(sp)
    sw  \S00l, 18*4(sp)
    lw  \C2l, 20*8+4(a0)
    sw  \C2h,  5*8+4(a0)
    xor \C0l,  \C0l,  \C1h
    xor \C0h,  \C0h,  \C1h
    xor \C2l,  \C2l,  \C1h
    sw  \C0l, 10*8+4(a0)
    sw  \C0h, 15*8+4(a0)
    sw  \C2l, 20*8+4(a0)
    # empty: C0h,C0l,C1h,C1l,C2h,C2l
    # S02,S07,S12,S17,S22 += D2
    lw  \C0l,   17*8+0(a0)
    lw  \C0h,   22*8+0(a0)
    xor \S02l, \S02l, \C3l
    xor \S07l, \S07l, \C3l
    lw  \C1l,    2*8+4(a0)
    lw  \C1h,    7*8+4(a0)
    xor \S12l, \S12l, \C3l
    xor \C0l,  \C0l,  \C3l
    xor \C0h,  \C0h,  \C3l
    lw  \C2l,   12*8+4(a0)
    lw  \C2h,   17*8+4(a0)
    sw  \C0l,   17*8+0(a0)
    sw  \C0h,   22*8+0(a0)
    xor \C1l,  \C1l,  \C3h
    xor \C1h,  \C1h,  \C3h
    lw  \C0l,    22*8+4(a0)
    sw  \C1l,    2*8+4(a0)
    sw  \C1h,    7*8+4(a0)
    xor \C2l,  \C2l,  \C3h
    xor \C2h,  \C2h,  \C3h
    xor \C0l,  \C0l,   \C3h
    sw  \C2l,   12*8+4(a0)
    sw  \C2h,   17*8+4(a0)
    sw  \C0l,   22*8+4(a0)
    # S04,S09,S14,S19,S24 += D4
    lw  \C0l,   19*8+0(a0)
    lw  \C0h,   24*8+0(a0)
    xor \S04l, \S04l, \T0
    xor \S09l, \S09l, \T0
    lw  \C1l,    4*8+4(a0)
    lw  \C1h,    9*8+4(a0)
    xor \S14l, \S14l, \T0
    xor \C0l,  \C0l,  \T0
    lw  \C2l,   14*8+4(a0)
    lw  \C2h,   19*8+4(a0)
    sw  \C0l,   19*8+0(a0)
    xor \C0h,  \C0h,  \T0
    xor \C1l,  \C1l,  \T1
    sw  \C0h,   24*8+0(a0)
    sw  \C1l,    4*8+4(a0)
    lw  \C3l,   24*8+4(a0)
    xor \C1h,  \C1h,  \T1
    xor \C2l,  \C2l,  \T1
    sw  \C1h,    9*8+4(a0)
    sw  \C2l,   14*8+4(a0)
    xor \C2h,  \C2h,  \T1
    xor \C3l,  \C3l,  \T1
    sw  \C2h,   19*8+4(a0)
    sw  \C3l,   24*8+4(a0)
    # rho and pi
    # empty: T0,T1,T2,C0,C1,C2,C3,C4

    lw  \C0l, 6*8+4(a0)
    lw  \C0h, 2*8+4(a0)
    lw  \C1l, 12*8+4(a0)
    lw  \C1h, 13*8+4(a0)
    lw  \C2l, 19*8+0(a0)
    lw  \C2h, 19*8+4(a0)
    lw  \C3l, 23*8+0(a0)
    lw  \C3h, 23*8+4(a0)
    ROLn \T1, \T0, \C0l, \S06l,44
    ROLn \C4h,\S00l,\C0h,\S02l,62
    sw   \C4h,0*8+4(a0)
    sw   \T0, 20*4(sp)
    sw   \T1, 21*4(sp)
    ROLn \C0h,\S02l,\C1l,\S12l,43
    sw   \C0h,2*8+4(a0)
    ROLn \C1l,\S12l,\C1h,\S13l,25
    sw   \C1l,12*8+4(a0)
    ROLn \C1h,\S13l,\C2h,\C2l,8
    sw   \C1h,13*8+4(a0)
    ROLn \C2h,\C2l,\C3h,\C3l,56
    sw   \C2l, 19*8+0(a0)
    sw   \C2h, 19*8+4(a0)
    lw   \C0l, 15*8+0(a0)
    lw   \C0h, 15*8+4(a0)
    lw   \C1l, 1*8+4(a0)
    lw   \C1h, 8*8+4(a0)
    lw   \C2l, 16*8+0(a0)
    lw   \C2h, 16*8+4(a0)
    ROLn \C3h,\C3l,\C0h,\C0l,41
    sw   \C3l, 23*8+0(a0)
    sw   \C3h, 23*8+4(a0)
    ROLn \C0h,\C0l,\C1l,\S01l,1
    sw   \C0l, 15*8+0(a0)
    sw   \C0h, 15*8+4(a0)
    ROLn \C1l,\S01l,\C1h,\S08l,55
    sw   \C1l, 1*8+4(a0)
    ROLn \C1h,\S08l,\C2h,\C2l,45
    sw   \C1h, 8*8+4(a0)
    lw   \C3l, 7*8+4(a0)
    lw   \C3h, 10*8+4(a0)
    lw   \C0l, 3*8+4(a0)
    lw   \C1l, 18*8+0(a0)
    lw   \C1h, 18*8+4(a0)
    ROLn \C2h,\C2l,\C3l,\S07l,6
    sw   \C2l, 16*8+0(a0)
    sw   \C2h, 16*8+4(a0)
    ROLn \C3l,\S07l,\C3h,\S10l,3
    sw   \C3l, 7*8+4(a0)
    ROLn \C3h,\S10l,\C0l,\S03l,28
    sw   \C3h, 10*8+4(a0)
    ROLn \C0l,\S03l,\C1h,\C1l,21
    sw   \C0l, 3*8+4(a0)
    lw   \C2l, 17*8+0(a0)
    lw   \C2h, 17*8+4(a0)
    lw   \C3l, 11*8+4(a0)
    lw   \C3h, 9*8+4(a0)
    lw   \C0l, 22*8+0(a0)
    lw   \C0h, 22*8+4(a0)
    ROLn \C1h,\C1l,\C2h,\C2l,15
    sw   \C1l, 18*8+0(a0)
    sw   \C1h, 18*8+4(a0)
    ROLn \C2h,\C2l,\C3l,\S11l,10
    sw   \C2l, 17*8+0(a0)
    sw   \C2h, 17*8+4(a0)
    ROLn \C3l,\S11l,\C3h,\S09l,20
    sw   \C3l, 11*8+4(a0)
    ROLn \C3h,\S09l,\C0h,\C0l,61
    sw   \C3h, 9*8+4(a0)
    lw   \C1l, 14*8+4(a0)
    lw   \C1h, 20*8+0(a0)
    lw   \C2l, 20*8+4(a0)
    lw   \C2h, 4*8+4(a0)
    lw   \C3l, 24*8+0(a0)
    lw   \C3h, 24*8+4(a0)
    ROLn \C0h,\C0l,\C1l,\S14l,39
    sw   \C0l, 22*8+0(a0)
    sw   \C0h, 22*8+4(a0)
    ROLn \C1l,\S14l,\C2l,\C1h,18
    sw   \C1l, 14*8+4(a0)
    ROLn \C2l,\C1h,\C2h,\S04l,27
    sw   \C1h, 20*8+0(a0)
    sw   \C2l, 20*8+4(a0)
    ROLn \C2h,\S04l,\C3h,\C3l,14
    sw   \C2h, 4*8+4(a0)
    lw   \C0l, 21*8+0(a0)
    lw   \C0h, 21*8+4(a0)
    lw   \C1l, 5*8+4(a0)
    ROLn \C3h,\C3l,\C0h,\C0l,2
    sw   \C3l, 24*8+0(a0)
    sw   \C3h, 24*8+4(a0)
    ROLn \C0h,\C0l,\C1l,\S05l,36
    sw   \C0l, 21*8+0(a0)
    sw   \C0h, 21*8+4(a0)

    lw   \T0,  10*8+4(a0)
    lw   \T1,  11*8+4(a0)
    lw   \T2,  7*8+4(a0)
    lw   \C2l, 8*8+4(a0)
    lw   \C2h, 9*8+4(a0)
    xoror  \C0l,\S05l,\T0,\S10l,\T1,\S11l,\T2,\S07l,\C4h,\C4l
    sw \C0l, 5*8+4(a0)
    xorand \C0h,\S06l,\T1,\S11l,\T2,\S07l,\C2l,\S08l,\C1h,\C1l
    sw \C0h, 6*8+4(a0)
    xorornot \T2,\S07l,\T2,\S07l,\C2l,\S08l,\C2h,\S09l,\C3h,\C3l
    sw  \T2,  7*8+4(a0)
    xoror \C2l,\S08l,\C2l,\S08l,\C2h,\S09l,\T0,\S10l,\C4h,\C4l
    sw   \C2l, 8*8+4(a0)
    xorand \C2h,\S09l,\C2h,\S09l,\T0,\S10l,\T1,\S11l,\C1h,\C1l
    sw   \C2h, 9*8+4(a0)

    lw  \C0l, 15*8+0(a0)
    lw  \C0h, 15*8+4(a0)
    lw  \C3l, 16*8+0(a0)
    lw  \C3h, 16*8+4(a0)
    lw  \C4l, 12*8+4(a0)
    lw  \C4h, 13*8+4(a0)
    lw  \T2,  14*8+4(a0)
    xoror \C1l,\S10l,\C0h,\C0l,\C3h,\C3l,\C4l,\S12l,\T1,\T0
    sw \C1l, 10*8+4(a0)
    xorand \C1h,\S11l,\C3h,\C3l,\C4l,\S12l,\C4h,\S13l,\C2h,\C2l
    sw \C1h, 11*8+4(a0)
    xornotand \C4l,\S12l,\C4l,\S12l,\C4h,\S13l,\T2,\S14l,\T1,\T0
    sw  \C4l, 12*8+4(a0)
    notxoror \C4h,\S13l,\C4h,\S13l,\T2,\S14l,\C0h,\C0l,\C2h,\C2l,\C1l
    sw  \C4h, 13*8+4(a0)
    xorand \T2,\S14l,\T2,\S14l,\C0h,\C0l,\C3h,\C3l,\T1,\T0
    sw  \T2,  14*8+4(a0)

    lw  \C1l, 20*8+0(a0)
    lw  \C1h, 20*8+4(a0)
    lw  \C2l, 21*8+0(a0)
    lw  \C2h, 21*8+4(a0)
    lw  \C4l, 17*8+0(a0)
    lw  \C4h, 17*8+4(a0)
    xorand \T1,\T0,\C1h,\C1l,\C2h,\C2l,\C4h,\C4l,\C0h,\C0l
    sw  \T0,  15*8+0(a0)
    sw  \T1,  15*8+4(a0)
    lw  \C3l, 18*8+0(a0)
    lw  \C3h, 18*8+4(a0)
    xoror \C0h,\C0l,\C2h,\C2l,\C4h,\C4l,\C3h,\C3l,\T1,\T0
    sw  \C0l, 16*8+0(a0) 
    sw  \C0h, 16*8+4(a0)
    lw  \T0,  19*8+0(a0)
    lw  \T1,  19*8+4(a0)
    xornotor \C4h,\C4l,\C4h,\C4l,\C3h,\C3l,\T1,\T0,\C0h,\C0l
    sw  \C4l, 17*8+0(a0)
    sw  \C4h, 17*8+4(a0)
    notxorand \C3h,\C3l,\C3h,\C3l,\T1,\T0,\C1h,\C1l,\C0h,\C0l,\T2
    sw  \C3l, 18*8+0(a0)
    sw  \C3h, 18*8+4(a0)
    xoror \T1,\T0,\T1,\T0,\C1h,\C1l,\C2h,\C2l,\C0h,\C0l
    sw  \T0,  19*8+0(a0)
    sw  \T1,  19*8+4(a0)

    lw  \C1l, 0*8+4(a0)
    lw  \C1h, 1*8+4(a0)
    lw  \C2l, 22*8+0(a0)
    lw  \C2h, 22*8+4(a0)
    lw  \C4l, 23*8+0(a0)
    lw  \C4h, 23*8+4(a0)
    xornotand \T1,\T0,\C1l,\S00l,\C1h,\S01l,\C2h,\C2l,\C0h,\C0l
    sw  \T0,  20*8+0(a0)
    sw  \T1,  20*8+4(a0)
    lw  \C3l, 24*8+0(a0)
    lw  \C3h, 24*8+4(a0)
    notxoror \C0h,\C0l,\C1h,\S01l,\C2h,\C2l,\C4h,\C4l,\T1,\T0,\T2
    sw  \C0l, 21*8+0(a0) 
    sw  \C0h, 21*8+4(a0)
    xorand \C2h,\C2l,\C2h,\C2l,\C4h,\C4l,\C3h,\C3l,\T1,\T0
    sw  \C2l, 22*8+0(a0)
    sw  \C2h, 22*8+4(a0)
    xoror \C4h,\C4l,\C4h,\C4l,\C3h,\C3l,\C1l,\S00l,\T1,\T0
    sw  \C4l, 23*8+0(a0)
    sw  \C4h, 23*8+4(a0)
    xorand \C3h,\C3l,\C3h,\C3l,\C1l,\S00l,\C1h,\S01l,\T1,\T0
    sw  \C3l, 24*8+0(a0)
    sw  \C3h, 24*8+4(a0)

    lw  \C3h, 17*4(sp)  # itoa table address
    lw  \C0l, 18*4(sp)
    lw  \C0h, 19*4(sp)
    lw  \C1l, 20*4(sp)
    lw  \C1h, 21*4(sp)
    lw  \C2l, 2*8+4(a0)
    lw  \C2h, 3*8+4(a0)
    lw  \C3l, 4*8+4(a0)
    lw  \T1, 0(\C3h); lw \T2, 4(\C3h); addi \C3h, \C3h, 8    # itoa
    xoror \T0,\S00l,\C0h,\C0l,\C1h,\C1l,\C2l,\S02l,\C4h,\C4l
    xor \S00l, \S00l, \T1; xor \T0, \T0, \T2
    sw  \C3h, 17*4(sp)
    sw  \T0, 0*8+4(a0)
    xornotor \T1,\S01l,\C1h,\C1l,\C2l,\S02l,\C2h,\S03l,\C4h,\C4l
    sw  \T1, 1*8+4(a0)
    xorand \C2l,\S02l,\C2l,\S02l,\C2h,\S03l,\C3l,\S04l,\C4h,\C4l
    sw  \C2l, 2*8+4(a0)
    xoror \C2h,\S03l,\C2h,\S03l,\C3l,\S04l,\C0h,\C0l,\C4h,\C4l
    sw  \C2h, 3*8+4(a0)
    xorand \C3l,\S04l,\C3l,\S04l,\C0h,\C0l,\C1h,\C1l,\C4h,\C4l
    sw  \C3l, 4*8+4(a0)
.endm

# stack: 
# 16*4 for loop control
# 17*4 for table index
# 18*4, 19*4, 20*4, 21*4 for tmp
.globl KeccakF1600_StatePermute_RV32ASM
.align 2
KeccakF1600_StatePermute_RV32ASM:
    addi sp, sp, -4*28
    la t0, constants_keccak
    SaveRegs
    sw t0, 17*4(sp)

    InitLoad \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, \
        s1, s2, s3, s4, s5, s6, s7, s8

    li tp, 24

loop_start:
    sw tp, 16*4(sp)
    ARound \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, \
        s1, s2, s3, s4, \
        s5, s6, s7, s8, s9, s10,s11,ra, gp, tp
    
    lw tp, 16*4(sp)
    addi tp, tp, -1
    bnez tp, loop_start

    FinalStore \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5, t6, s0, \
        s1, s2, s3, s4, s5, s6, s7, s8

    RestoreRegs
    addi sp, sp, 4*28
    ret
