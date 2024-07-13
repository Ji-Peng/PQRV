.text

// This code was inspired by the eXtended Keccak Code Package and then modified
// https://github.com/XKCP/XKCP/tree/master/lib/low/KeccakP-1600/Optimized32biAsmARM/KeccakP-1600-inplace-32bi-armv7m-le-gcc.s

.macro xor5 dst,b,g,k,m,s,tmp
    lw    \dst, \b(a0)
    lw    \tmp, \g(a0)
    xor   \dst, \dst, \tmp
    lw    \tmp, \k(a0)
    xor   \dst, \dst, \tmp
    lw    \tmp, \m(a0)
    xor   \dst, \dst, \tmp
    lw    \tmp, \s(a0)
    xor   \dst, \dst, \tmp
.endm

.macro ror reg,dist,tmp
    srli  \tmp, \reg, \dist
    slli  \reg, \reg, 32-\dist
    xor   \reg, \reg, \tmp
.endm

.macro xorrol dst,aa,bb,tmp
    srli  \tmp, \bb, 31
    slli  \dst, \bb, 1
    xor   \dst, \dst, \tmp
    xor   \dst, \dst, \aa
.endm

.macro xorand_m dst,aa,bb,cc,tmp
    and   \tmp, \bb,  \cc
    xor   \tmp, \tmp, \aa
    sw    \tmp, \dst(a0)
.endm

.macro xornotand_m dst,aa,bb,cc,tmp
    not   \tmp, \bb
    and   \tmp, \tmp, \cc
    xor   \tmp, \tmp, \aa
    sw    \tmp, \dst(a0)
.endm

.macro notxorand_m dst,aa,bb,cc,tmp0,tmp1
    not   \tmp0, \aa
    and   \tmp1, \bb,   \cc
    xor   \tmp0, \tmp0, \tmp1
    sw    \tmp0, \dst(a0)
.endm

.macro xoror_m dst,aa,bb,cc,tmp
    or    \tmp, \bb,  \cc
    xor   \tmp, \tmp, \aa
    sw    \tmp, \dst(a0)
.endm

.macro xornotor_m dst,aa,bb,cc,tmp
    not   \tmp, \bb
    or    \tmp, \tmp, \cc
    xor   \tmp, \tmp, \aa
    sw    \tmp, \dst(a0)
.endm

.macro notxoror_m dst,aa,bb,cc,tmp0,tmp1
    not   \tmp0, \aa
    or    \tmp1, \bb,   \cc
    xor   \tmp0, \tmp0, \tmp1
    sw    \tmp0, \dst(a0)
.endm

.macro xorand_r dst,aa,bb,cc,tmp
    and   \dst, \bb,  \cc
    xor   \dst, \dst, \aa
.endm

.macro xornotand_r dst,aa,bb,cc,tmp
    not   \dst, \bb
    and   \dst, \dst, \cc
    xor   \dst, \dst, \aa
.endm

.macro notxorand_r dst,aa,bb,cc,tmp0,tmp1
    not   \tmp0, \aa
    and   \dst, \bb,   \cc
    xor   \dst, \tmp0, \dst
.endm

.macro xoror_r dst,aa,bb,cc,tmp
    or    \dst, \bb,  \cc
    xor   \dst, \dst, \aa
.endm

.macro xornotor_r dst,aa,bb,cc,tmp
    not   \dst, \bb
    or    \dst, \dst, \cc
    xor   \dst, \dst, \aa
.endm

.macro notxoror_r dst,aa,bb,cc,tmp0,tmp1
    not   \tmp0, \aa
    or    \dst, \bb,   \cc
    xor   \dst, \tmp0, \dst
.endm

.macro thetarhopifinal aA1,aDax,aA2,aDex,rot2,aA3,aDix,rot3,aA4,aDox,rot4,aA5,aDux,rot5
    lw      a2, \aA1(a0)
    lw      a3, \aA2(a0)
    lw      a4, \aA3(a0)
    lw      a5, \aA4(a0)
    lw      a6, \aA5(a0)
    xor     a2, a2, \aDax
    xor     a3, a3, \aDex
    xor     a4, a4, \aDix
    xor     a5, a5, \aDox
    xor     a6, a6, \aDux
    ror     a3, (32-\rot2), t6
    ror     a4, (32-\rot3), t6
    ror     a5, (32-\rot4), t6
    ror     a6, (32-\rot5), t6
.endm

.macro thetarhopi aB1,aA1,aDax,rot1,aB2,aA2,aDex,rot2,aB3,aA3,aDix,rot3,aB4,aA4,aDox,rot4,aB5,aA5,aDux,rot5
    lw    \aB1, \aA1(a0)
    lw    \aB2, \aA2(a0)
    lw    \aB3, \aA3(a0)
    lw    \aB4, \aA4(a0)
    lw    \aB5, \aA5(a0)
    xor   \aB1, \aB1, \aDax
    xor   \aB2, \aB2, \aDex
    xor   \aB3, \aB3, \aDix
    xor   \aB4, \aB4, \aDox
    xor   \aB5, \aB5, \aDux
    ror   \aB1, (32-\rot1), t6
    .if \rot2 > 0
    ror   \aB2, (32-\rot2), t6
    .endif
    ror   \aB3, (32-\rot3), t6
    ror   \aB4, (32-\rot4), t6
    ror   \aB5, (32-\rot5), t6
.endm

# .macro chipattern0 aA1,aA2,aA3,aA4,aA5
#     xoror     \aA1, a2, a3, a4, t6
#     xorand    \aA2, a3, a4, a5, t6
#     xornotor  \aA3, a4, a6, a5, t6
#     xoror     \aA4, a5, a6, a2, t6
#     xorand    \aA5, a6, a2, a3, t6
# .endm

# .macro chipattern1 aA1,aA2,aA3,aA4,aA5
#     xoror     \aA1, a2, a3, a4, t6
#     xorand    \aA2, a3, a4, a5, t6
#     xornotand \aA3, a4, a5, a6, t6
#     notxoror  \aA4, a5, a6, a2, t6, t1
#     xorand    \aA5, a6, a2, a3, t6
# .endm

# .macro chipattern2 aA1,aA2,aA3,aA4,aA5
#     xorand    \aA1, a2, a3, a4, t6
#     xoror     \aA2, a3, a4, a5, t6
#     xornotor  \aA3, a4, a5, a6, t6
#     notxorand \aA4, a5, a6, a2, t6, t1
#     xoror     \aA5, a6, a2, a3, t6
# .endm

# .macro chipattern3 aA1,aA2,aA3,aA4,aA5
#     xornotand \aA1, a2, a3, a4, t6
#     notxoror  \aA2, a3, a4, a5, t6, t1
#     xorand    \aA3, a4, a5, a6, t6
#     xoror     \aA4, a5, a6, a2, t6
#     xorand    \aA5, a6, a2, a3, t6
# .endm

.macro chiiota aA1,aA2,aA3,aA4,aA5,offset
    xornotor  \aA2, a3, a4, a5, t6
    xorand    \aA3, a4, a5, a6, t6
    xoror     \aA4, a5, a6, a2, t6
    xorand    \aA5, a6, a2, a3, t6
    or      a4, a4, a3
    lw      t6, \offset(a1)
    xor     a2, a2, a4
    xor     a2, a2, t6
    sw      a2, \aA1(a0)
.endm

.macro round0 T0, T1, T2, T3, T4, T5, T6, T7, T8, T9
    # C4l
    xor5        a2, 4*8+0*4, 9*8+0*4, 14*8+0*4, 19*8+0*4, 24*8+0*4, t6
    # C1h
    xor5        a6, 1*8+1*4, 6*8+1*4, 11*8+1*4, 16*8+1*4, 21*8+1*4, t6
    # D0l
    xorrol      s0, a2, a6, t6
    # C4h
    xor5        a5, 4*8+1*4, 9*8+1*4, 14*8+1*4, 19*8+1*4, 24*8+1*4, t6
    # C1l
    xor5        t5, 1*8+0*4, 6*8+0*4, 11*8+0*4, 16*8+0*4, 21*8+0*4, t6
    # D0h
    xor         t0, a5, t5

    # C2l
    xor5        a4, 2*8+0*4, 7*8+0*4, 12*8+0*4, 17*8+0*4, 22*8+0*4, t6
    # D3l
    xorrol      s4, a4, a5, t6
    # C2h
    xor5        a3, 2*8+1*4, 7*8+1*4, 12*8+1*4, 17*8+1*4, 22*8+1*4, t6
    # D3h
    xor         s1, a2, a3

    # C0l
    xor5        a2, 0*8+0*4, 5*8+0*4, 10*8+0*4, 15*8+0*4, 20*8+0*4, t6
    # D1l
    xorrol      t2, a2, a3, t6
    # C0h
    xor5        a5, 0*8+1*4, 5*8+1*4, 10*8+1*4, 15*8+1*4, 20*8+1*4, t6
    # D1h
    xor         t3, a5, a4

    # C3h
    xor5        a3, 3*8+1*4, 8*8+1*4, 13*8+1*4, 18*8+1*4, 23*8+1*4, t6
    # D2l
    xorrol      a7, t5, a3, t6
    # C3l
    xor5        a4, 3*8+0*4, 8*8+0*4, 13*8+0*4, 18*8+0*4, 23*8+0*4, t6
    # D2h
    xor         s2, a6, a4

    # D4l
    xorrol      t4, a4, a5, t6
    # D4h
    xor         t5, a3, a2

# D0,D1,D2,D3,D4={t0,s0},{t3,t2},{s2,a7},{s1,s4},{t5,t4}
//used for masks: r2,r8,r9,r10,r11,r12,lr,mDa0,mDo1,mDi0,mDa1,mDo0
//           = >  a7,t0,t1, t2, t3, t4,t5,  s0,  s1,  s2,  s3,  s4
    thetarhopi  a4, 10*8+1*4, t0,  2, a5, 16*8+1*4, t3, 23, a6, 22*8+1*4, s2, 31, a2, 3*8+0*4, s4, 14, a3, 9*8+0*4, t4, 10
    chipattern0     10*8+1*4,             16*8+1*4,             22*8+1*4,             3*8+0*4,             9*8+0*4
    thetarhopi  a6, 20*8+1*4, t0,  9, a2, 1*8+0*4, t2,  0, a3, 7*8+1*4, s2,  3, a4, 13*8+0*4, s4, 12, a5, 19*8+1*4, t5,  4
    chipattern1     20*8+1*4,             1*8+0*4,             7*8+1*4,             13*8+0*4,             19*8+1*4
    thetarhopi  a3, 5*8+0*4, s0, 18, a4, 11*8+0*4, t2,  5, a5, 17*8+1*4, s2,  8, a6, 23*8+0*4, s4, 28, a2, 4*8+1*4, t5, 14
    chipattern2     5*8+0*4,             11*8+0*4,             17*8+1*4,             23*8+0*4,             4*8+1*4
    thetarhopi  a5, 15*8+0*4, s0, 20, a6, 21*8+1*4, t3,  1, a2, 2*8+1*4, s2, 31, a3, 8*8+0*4, s4, 27, a4, 14*8+0*4, t4, 19
    chipattern3     15*8+0*4,             21*8+1*4,             2*8+1*4,             8*8+0*4,             14*8+0*4
    thetarhopifinal 0*8+0*4, s0,         6*8+0*4, t2, 22,     12*8+1*4, s2, 22,     18*8+1*4, s1, 11,     24*8+0*4, t4,  7
    chiiota         0*8+0*4,             6*8+0*4,             12*8+1*4,             18*8+1*4,             24*8+0*4, 0

    thetarhopi  a4, 10*8+0*4, s0,  1, a5, 16*8+0*4, t2, 22, a6, 22*8+0*4, a7, 30, a2, 3*8+1*4, s1, 14, a3, 9*8+1*4, t5, 10
    chipattern0     10*8+0*4,             16*8+0*4,             22*8+0*4,             3*8+1*4,             9*8+1*4
    thetarhopi  a6, 20*8+0*4, s0,  9, a2, 1*8+1*4, t3,  1, a3, 7*8+0*4, a7,  3, a4, 13*8+1*4, s1, 13, a5, 19*8+0*4, t4,  4
    chipattern1     20*8+0*4,             1*8+1*4,             7*8+0*4,             13*8+1*4,             19*8+0*4
    thetarhopi  a3, 5*8+1*4, t0, 18, a4, 11*8+1*4, t3,  5, a5, 17*8+0*4, a7,  7, a6, 23*8+1*4, s1, 28, a2, 4*8+0*4, t4, 13
    chipattern2     5*8+1*4,             11*8+1*4,             17*8+0*4,             23*8+1*4,             4*8+0*4
    thetarhopi  a5, 15*8+1*4, t0, 21, a6, 21*8+0*4, t2,  1, a2, 2*8+0*4, a7, 31, a3, 8*8+1*4, s1, 28, a4, 14*8+1*4, t5, 20
    chipattern3     15*8+1*4,             21*8+0*4,             2*8+0*4,             8*8+1*4,             14*8+1*4
    thetarhopifinal 0*8+1*4, t0,         6*8+1*4, t3, 22,     12*8+0*4, a7, 21,     18*8+0*4, s4, 10,     24*8+1*4, t5,  7
    chiiota         0*8+1*4,             6*8+1*4,             12*8+0*4,             18*8+0*4,             24*8+1*4, 4
.endm

.macro round1
    xor5        a2, 24*8+0*4, 9*8+0*4, 19*8+0*4, 4*8+1*4, 14*8+1*4, t6
    xor5        a6, 6*8+1*4, 16*8+0*4, 1*8+0*4, 11*8+1*4, 21*8+1*4, t6
    xorrol      s0, a2, a6, t6
    xor5        a5, 24*8+1*4, 9*8+1*4, 19*8+1*4, 4*8+0*4, 14*8+0*4, t6
    xor5        t5, 6*8+0*4, 16*8+1*4, 1*8+1*4, 11*8+0*4, 21*8+0*4, t6
    xor         t0, a5, t5

    xor5        a4, 12*8+1*4, 22*8+1*4, 7*8+0*4, 17*8+1*4, 2*8+0*4, t6
    xorrol      s4, a4, a5, t6
    xor5        a3, 12*8+0*4, 22*8+0*4, 7*8+1*4, 17*8+0*4, 2*8+1*4, t6
    xor         s1, a2, a3

    xor5        a2, 0*8+0*4, 10*8+1*4, 20*8+0*4, 5*8+0*4, 15*8+1*4, t6
    xorrol      t2, a2, a3, t6
    xor5        a5, 0*8+1*4, 10*8+0*4, 20*8+1*4, 5*8+1*4, 15*8+0*4, t6
    xor         t3, a5, a4

    xor5        a3, 18*8+0*4, 3*8+1*4, 13*8+0*4, 23*8+1*4, 8*8+0*4, t6
    xorrol      a7, t5, a3, t6
    xor5        a4, 18*8+1*4, 3*8+0*4, 13*8+1*4, 23*8+0*4, 8*8+1*4, t6
    xor         s2, a6, a4

    xorrol      t4, a4, a5, t6
    xor         t5, a3, a2

//used for masks: r2,r8,r9,r10,r11,r12,lr,mDa0,mDo1,mDi0,mDa1,mDo0
//           = >  a7,t0,t1, t2, t3, t4,t5,  s0,  s1,  s2,  s3,  s4
    thetarhopi  a4, 20*8+1*4, t0,  2, a5, 11*8+1*4, t3, 23, a6, 2*8+1*4, s2, 31, a2, 18*8+1*4, s4, 14, a3, 9*8+0*4, t4, 10
    chipattern0     20*8+1*4,             11*8+1*4,             2*8+1*4,             18*8+1*4,             9*8+0*4
    thetarhopi  a6, 15*8+0*4, t0,  9, a2, 6*8+0*4, t2,  0, a3, 22*8+0*4, s2,  3, a4, 13*8+1*4, s4, 12, a5, 4*8+0*4, t5,  4
    chipattern1     15*8+0*4,             6*8+0*4,             22*8+0*4,             13*8+1*4,             4*8+0*4
    thetarhopi  a3, 10*8+1*4, s0, 18, a4, 1*8+1*4, t2,  5, a5, 17*8+0*4, s2,  8, a6, 8*8+1*4, s4, 28, a2, 24*8+1*4, t5, 14
    chipattern2     10*8+1*4,             1*8+1*4,             17*8+0*4,             8*8+1*4,             24*8+1*4
    thetarhopi  a5, 5*8+0*4, s0, 20, a6, 21*8+1*4, t3,  1, a2, 12*8+0*4, s2, 31, a3, 3*8+0*4, s4, 27, a4, 19*8+0*4, t4, 19
    chipattern3     5*8+0*4,             21*8+1*4,             12*8+0*4,             3*8+0*4,             19*8+0*4
    thetarhopifinal 0*8+0*4, s0,         16*8+1*4, t2, 22,     7*8+1*4, s2, 22,     23*8+1*4, s1, 11,     14*8+1*4, t4,  7
    chiiota         0*8+0*4,             16*8+1*4,             7*8+1*4,             23*8+1*4,             14*8+1*4, 8

    thetarhopi  a4, 20*8+0*4, s0,  1, a5, 11*8+0*4, t2, 22, a6, 2*8+0*4, a7, 30, a2, 18*8+0*4, s1, 14, a3, 9*8+1*4, t5, 10
    chipattern0     20*8+0*4,             11*8+0*4,             2*8+0*4,             18*8+0*4,             9*8+1*4
    thetarhopi  a6, 15*8+1*4, s0,  9, a2, 6*8+1*4, t3,  1, a3, 22*8+1*4, a7,  3, a4, 13*8+0*4, s1, 13, a5, 4*8+1*4, t4,  4
    chipattern1     15*8+1*4,             6*8+1*4,             22*8+1*4,             13*8+0*4,             4*8+1*4
    thetarhopi  a3, 10*8+0*4, t0, 18, a4, 1*8+0*4, t3,  5, a5, 17*8+1*4, a7,  7, a6, 8*8+0*4, s1, 28, a2, 24*8+0*4, t4, 13
    chipattern2     10*8+0*4,             1*8+0*4,             17*8+1*4,             8*8+0*4,             24*8+0*4
    thetarhopi  a5, 5*8+1*4, t0, 21, a6, 21*8+0*4, t2,  1, a2, 12*8+1*4, a7, 31, a3, 3*8+1*4, s1, 28, a4, 19*8+1*4, t5, 20
    chipattern3     5*8+1*4,             21*8+0*4,             12*8+1*4,             3*8+1*4,             19*8+1*4
    thetarhopifinal 0*8+1*4, t0,         16*8+0*4, t3, 22,     7*8+0*4, a7, 21,     23*8+0*4, s4, 10,     14*8+0*4, t5,  7
    chiiota         0*8+1*4,             16*8+0*4,             7*8+0*4,             23*8+0*4,             14*8+0*4, 12
.endm

.macro round2
    xor5        a2, 14*8+1*4, 9*8+0*4, 4*8+1*4, 24*8+1*4, 19*8+1*4, t6
    xor5        a6, 16*8+0*4, 11*8+0*4, 6*8+0*4, 1*8+0*4, 21*8+1*4, t6
    xorrol      s0, a2, a6, t6
    xor5        a5, 14*8+0*4, 9*8+1*4, 4*8+0*4, 24*8+0*4, 19*8+0*4, t6
    xor5        t5, 16*8+1*4, 11*8+1*4, 6*8+1*4, 1*8+1*4, 21*8+0*4, t6
    xor         t0, a5, t5

    xor5        a4, 7*8+1*4, 2*8+1*4, 22*8+1*4, 17*8+0*4, 12*8+1*4, t6
    xorrol      s4, a4, a5, t6
    xor5        a3, 7*8+0*4, 2*8+0*4, 22*8+0*4, 17*8+1*4, 12*8+0*4, t6
    xor         s1, a2, a3

    xor5        a2, 0*8+0*4, 20*8+1*4, 15*8+1*4, 10*8+1*4, 5*8+1*4, t6
    xorrol      t2, a2, a3, t6
    xor5        a5, 0*8+1*4, 20*8+0*4, 15*8+0*4, 10*8+0*4, 5*8+0*4, t6
    xor         t3, a5, a4

    xor5        a3, 23*8+0*4, 18*8+0*4, 13*8+1*4, 8*8+0*4, 3*8+0*4, t6
    xorrol      a7, t5, a3, t6
    xor5        a4, 23*8+1*4, 18*8+1*4, 13*8+0*4, 8*8+1*4, 3*8+1*4, t6
    xor         s2, a6, a4

    xorrol      t4, a4, a5, t6
    xor         t5, a3, a2

//used for masks: r2,r8,r9,r10,r11,r12,lr,mDa0,mDo1,mDi0,mDa1,mDo0
//           = >  a7,t0,t1, t2, t3, t4,t5,  s0,  s1,  s2,  s3,  s4
    thetarhopi  a4, 15*8+0*4, t0,  2, a5, 1*8+0*4, t3, 23, a6, 12*8+0*4, s2, 31, a2, 23*8+1*4, s4, 14, a3, 9*8+0*4, t4, 10
    chipattern0     15*8+0*4,             1*8+0*4,             12*8+0*4,             23*8+1*4,             9*8+0*4
    thetarhopi  a6, 5*8+0*4, t0,  9, a2, 16*8+1*4, t2,  0, a3, 2*8+0*4, s2,  3, a4, 13*8+0*4, s4, 12, a5, 24*8+0*4, t5,  4
    chipattern1     5*8+0*4,             16*8+1*4,             2*8+0*4,             13*8+0*4,             24*8+0*4
    thetarhopi  a3, 20*8+1*4, s0, 18, a4, 6*8+1*4, t2,  5, a5, 17*8+1*4, s2,  8, a6, 3*8+1*4, s4, 28, a2, 14*8+0*4, t5, 14
    chipattern2     20*8+1*4,             6*8+1*4,             17*8+1*4,             3*8+1*4,             14*8+0*4
    thetarhopi  a5, 10*8+1*4, s0, 20, a6, 21*8+1*4, t3,  1, a2, 7*8+0*4, s2, 31, a3, 18*8+1*4, s4, 27, a4, 4*8+1*4, t4, 19
    chipattern3     10*8+1*4,             21*8+1*4,             7*8+0*4,             18*8+1*4,             4*8+1*4
    thetarhopifinal 0*8+0*4, s0,         11*8+1*4, t2, 22,     22*8+0*4, s2, 22,     8*8+0*4, s1, 11,     19*8+1*4, t4,  7
    chiiota         0*8+0*4,             11*8+1*4,             22*8+0*4,             8*8+0*4,             19*8+1*4, 16

    thetarhopi  a4, 15*8+1*4, s0,  1, a5, 1*8+1*4, t2, 22, a6, 12*8+1*4, a7, 30, a2, 23*8+0*4, s1, 14, a3, 9*8+1*4, t5, 10
    chipattern0     15*8+1*4,             1*8+1*4,             12*8+1*4,             23*8+0*4,             9*8+1*4
    thetarhopi  a6, 5*8+1*4, s0,  9, a2, 16*8+0*4, t3,  1, a3, 2*8+1*4, a7,  3, a4, 13*8+1*4, s1, 13, a5, 24*8+1*4, t4,  4
    chipattern1     5*8+1*4,             16*8+0*4,             2*8+1*4,             13*8+1*4,             24*8+1*4
    thetarhopi  a3, 20*8+0*4, t0, 18, a4, 6*8+0*4, t3,  5, a5, 17*8+0*4, a7,  7, a6, 3*8+0*4, s1, 28, a2, 14*8+1*4, t4, 13
    chipattern2     20*8+0*4,             6*8+0*4,             17*8+0*4,             3*8+0*4,             14*8+1*4
    thetarhopi  a5, 10*8+0*4, t0, 21, a6, 21*8+0*4, t2,  1, a2, 7*8+1*4, a7, 31, a3, 18*8+0*4, s1, 28, a4, 4*8+0*4, t5, 20
    chipattern3     10*8+0*4,             21*8+0*4,             7*8+1*4,             18*8+0*4,             4*8+0*4
    thetarhopifinal 0*8+1*4, t0,         11*8+0*4, t3, 22,     22*8+1*4, a7, 21,     8*8+1*4, s4, 10,     19*8+0*4, t5,  7
    chiiota         0*8+1*4,             11*8+0*4,             22*8+1*4,             8*8+1*4,             19*8+0*4, 20
.endm

.macro round3
    xor5        a2, 19*8+1*4, 9*8+0*4, 24*8+1*4, 14*8+0*4, 4*8+0*4, t6
    xor5        a6, 11*8+0*4, 1*8+1*4, 16*8+1*4, 6*8+0*4, 21*8+1*4, t6
    xorrol      s0, a2, a6, t6
    xor5        a5, 19*8+0*4, 9*8+1*4, 24*8+0*4, 14*8+1*4, 4*8+1*4, t6
    xor5        t5, 11*8+1*4, 1*8+0*4, 16*8+0*4, 6*8+1*4, 21*8+0*4 t6
    xor         t0, a5, t5

    xor5        a4, 22*8+0*4, 12*8+0*4, 2*8+1*4, 17*8+1*4, 7*8+1*4, t6
    xorrol      s4, a4, a5, t6
    xor5        a3, 22*8+1*4, 12*8+1*4, 2*8+0*4, 17*8+0*4, 7*8+0*4, t6
    xor         s1, a2, a3

    xor5        a2, 0*8+0*4, 15*8+0*4, 5*8+1*4, 20*8+1*4, 10*8+0*4, t6
    xorrol      t2, a2, a3, t6
    xor5        a5, 0*8+1*4, 15*8+1*4, 5*8+0*4, 20*8+0*4, 10*8+1*4, t6
    xor         t3, a5, a4

    xor5        a3, 8*8+1*4, 23*8+0*4, 13*8+0*4, 3*8+0*4, 18*8+1*4, t6
    xorrol      a7, t5, a3, t6
    xor5        a4, 8*8+0*4, 23*8+1*4, 13*8+1*4, 3*8+1*4, 18*8+0*4, t6
    xor         s2, a6, a4

    xorrol      t4, a4, a5, t6
    xor         t5, a3, a2

//used for masks: r2,r8,r9,r10,r11,r12,lr,mDa0,mDo1,mDi0,mDa1,mDo0
//           = >  a7,t0,t1, t2, t3, t4,t5,  s0,  s1,  s2,  s3,  s4
    thetarhopi  a4, 5*8+0*4, t0,  2, a5, 6*8+0*4, t3, 23, a6, 7*8+0*4, s2, 31, a2, 8*8+0*4, s4, 14, a3, 9*8+0*4, t4, 10
    chipattern0     5*8+0*4,             6*8+0*4,             7*8+0*4,             8*8+0*4,             9*8+0*4
    thetarhopi  a6, 10*8+1*4, t0,  9, a2, 11*8+1*4, t2,  0, a3, 12*8+1*4, s2,  3, a4, 13*8+1*4, s4, 12, a5, 14*8+1*4, t5,  4
    chipattern1     10*8+1*4,             11*8+1*4,             12*8+1*4,             13*8+1*4,             14*8+1*4
    thetarhopi  a3, 15*8+0*4, s0, 18, a4, 16*8+0*4, t2,  5, a5, 17*8+0*4, s2,  8, a6, 18*8+0*4, s4, 28, a2, 19*8+0*4, t5, 14
    chipattern2     15*8+0*4,             16*8+0*4,             17*8+0*4,             18*8+0*4,             19*8+0*4
    thetarhopi  a5, 20*8+1*4, s0, 20, a6, 21*8+1*4, t3,  1, a2, 22*8+1*4, s2, 31, a3, 23*8+1*4, s4, 27, a4, 24*8+1*4, t4, 19
    chipattern3     20*8+1*4,             21*8+1*4,             22*8+1*4,             23*8+1*4,             24*8+1*4
    thetarhopifinal 0*8+0*4, s0,         1*8+0*4, t2, 22,     2*8+0*4, s2, 22,     3*8+0*4, s1, 11,     4*8+0*4, t4,  7
    chiiota         0*8+0*4,             1*8+0*4,             2*8+0*4,             3*8+0*4,             4*8+0*4, 24

    thetarhopi  a4, 5*8+1*4, s0,  1, a5, 6*8+1*4, t2, 22, a6, 7*8+1*4, a7, 30, a2, 8*8+1*4, s1, 14, a3, 9*8+1*4, t5, 10
    chipattern0     5*8+1*4,             6*8+1*4,             7*8+1*4,             8*8+1*4,             9*8+1*4
    thetarhopi  a6, 10*8+0*4, s0,  9, a2, 11*8+0*4, t3,  1, a3, 12*8+0*4, a7,  3, a4, 13*8+0*4, s1, 13, a5, 14*8+0*4, t4,  4
    chipattern1     10*8+0*4,             11*8+0*4,             12*8+0*4,             13*8+0*4,             14*8+0*4
    thetarhopi  a3, 15*8+1*4, t0, 18, a4, 16*8+1*4, t3,  5, a5, 17*8+1*4, a7,  7, a6, 18*8+1*4, s1, 28, a2, 19*8+1*4, t4, 13
    chipattern2     15*8+1*4,             16*8+1*4,             17*8+1*4,             18*8+1*4,             19*8+1*4
    thetarhopi  a5, 20*8+0*4, t0, 21, a6, 21*8+0*4, t2,  1, a2, 22*8+0*4, a7, 31, a3, 23*8+0*4, s1, 28, a4, 24*8+0*4, t5, 20
    chipattern3     20*8+0*4,             21*8+0*4,             22*8+0*4,             23*8+0*4,             24*8+0*4
    thetarhopifinal 0*8+1*4, t0,         1*8+1*4, t3, 22,     2*8+1*4, a7, 21,     3*8+1*4, s4, 10,     4*8+1*4, t5,  7
    chiiota         0*8+1*4,             1*8+1*4,             2*8+1*4,             3*8+1*4,             4*8+1*4, 28
.endm

.macro invert dst
    lw      t6, \dst(a0)
    not     t6, t6
    sw      t6, \dst(a0)
.endm

.macro complementlanes
    invert 1*8+0*4
    invert 1*8+1*4
    invert 2*8+0*4
    invert 2*8+1*4
    invert 8*8+0*4
    invert 8*8+1*4
    invert 12*8+0*4
    invert 12*8+1*4
    invert 17*8+0*4
    invert 17*8+1*4
    invert 20*8+0*4
    invert 20*8+1*4
.endm

.data

.align 3
keccakf1600_rc24:
    .long 0x00000001, 0x00000000
    .long 0x00000000, 0x00000089
    .long 0x00000000, 0x8000008b
    .long 0x00000000, 0x80008080
    .long 0x00000001, 0x0000008b
    .long 0x00000001, 0x00008000
    .long 0x00000001, 0x80008088
    .long 0x00000001, 0x80000082
    .long 0x00000000, 0x0000000b
    .long 0x00000000, 0x0000000a
    .long 0x00000001, 0x00008082
    .long 0x00000000, 0x00008003
    .long 0x00000001, 0x0000808b
    .long 0x00000001, 0x8000000b
    .long 0x00000001, 0x8000008a
    .long 0x00000001, 0x80000081
    .long 0x00000000, 0x80000081
    .long 0x00000000, 0x80000008
    .long 0x00000000, 0x00000083
    .long 0x00000000, 0x80008003
    .long 0x00000001, 0x80008088
    .long 0x00000000, 0x80000088
    .long 0x00000001, 0x00008000
    .long 0x00000000, 0x80008082

.text

// void keccakf1600(uint32_t *lanes);
.globl keccakf1600
.type keccakf1600,%function
.align 3
keccakf1600:
    addi    sp, sp, -24
    sw      s0,  4(sp)
    sw      s1,  8(sp)
    sw      s2, 12(sp)
    sw      s3, 16(sp)
    sw      s4, 20(sp)

    la      a1, keccakf1600_rc24
    addi    s3, zero, 5

    complementlanes

// With this loop it still fits in 16 KiB instruction cache
.align 3
1:  round0
    round1
    round2
    round3
    addi    a1, a1, 32
    addi    s3, s3, -1
    bge     s3, zero, 1b

    complementlanes

    lw      s0,  4(sp)
    lw      s1,  8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    lw      s4, 20(sp)
    addi    sp, sp, 24

    ret
.size keccakf1600,.-keccakf1600