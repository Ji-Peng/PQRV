.text

.macro save_regs
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

.macro restore_regs
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

# q * qinv = 1 mod 2^32, used for Montgomery arithmetic
.equ q, 3329
.equ qinv, 1806234369
# inv128 = 2^64 * (1/128) mod q is used for reverting standard domain
.equ inv256, 2208
# inv256qinv <- low(inv256*qinv)
.equ inv256qinv, 2435836064

# void ntt_rv32im(int16_t in[256], const int32_t zetas[128*2]);
# register usage:
# a0-a1: in/out, zetas; a6: q; a1/a2/a3/a4/a5/a7/gp/ra: tmp
# 4*15(sp), 4*16(sp) for outer/inner loop control
# 4*17(sp) for saving a1
# t0-t6,tp: 8 coeffs; s0-s9: 5 zetas & zetas*qinv
# s10, s11: for scalar-vector hybrid programming
# strategy: 1+3+3 layers merging
.globl ntt_rv32im
.align 2
ntt_rv32im:
    addi sp, sp, -4*18
    save_regs
    li a6, q
    # load 1 zeta & zeta*qinv
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    sw a1, 4*17(sp)
ntt_rv32im_looper_1:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # reset a0 & update a1
    lw   a1, 4*17(sp)
    addi a0, a0, -32*2
    addi a1, a1, 4*2
    sw   a1, 4*17(sp)
ntt_rv32im_outer_234:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # ntt_rv32im_inner_234:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 128*2-16*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # ntt_rv32im_inner_234:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 128*2-16*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    # reset a0
    addi a0, a0, -2*128*2
ntt_rv32im_outer_567:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    #ntt_rv32im_inner_567:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    mul  a1, t4, s1;    mul  a3, t5, s1
    mul  a5, t6, s1;    mul  gp, tp, s1
    mulh a2, t4, s0;    mulh a4, t5, s0
    mulh a7, t6, s0;    mulh ra, tp, s0
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t4, t0, a1;    sub  t5, t1, a3
    sub  t6, t2, a5;    sub  tp, t3, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t2, t2, a5;    add  t3, t3, gp
    mul  a1, t2, s3;    mul  a3, t3, s3
    mul  a5, t6, s5;    mul  gp, tp, s5
    mulh a2, t2, s2;    mulh a4, t3, s2
    mulh a7, t6, s4;    mulh ra, tp, s4
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t2, t0, a1;    sub  t3, t1, a3
    sub  t6, t4, a5;    sub  tp, t5, gp
    add  t0, t0, a1;    add  t1, t1, a3
    add  t4, t4, a5;    add  t5, t5, gp
    lw   ra, 4*17(sp);    lw   a5, 11*4(ra)
    lw   gp, 13*4(ra);    lw   a7, 10*4(ra)
    lw   ra, 12*4(ra)
    mul  a1, t1, s7;    mul  a3, t3, s9
    mul  a5, t5, a5;    mul  gp, tp, gp
    mulh a2, t1, s6;    mulh a4, t3, s8
    mulh a7, t5, a7;    mulh ra, tp, ra
    mulh a1, a1, a6;    mulh a3, a3, a6
    mulh a5, a5, a6;    mulh gp, gp, a6
    sub  a1, a2, a1;    sub  a3, a4, a3
    sub  a5, a7, a5;    sub  gp, ra, gp
    sub  t1, t0, a1;    sub  t3, t2, a3
    sub  t5, t4, a5;    sub  tp, t6, gp
    add  t0, t0, a1;    add  t2, t2, a3
    add  t4, t4, a5;    add  t6, t6, gp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    restore_regs
    addi sp, sp, 4*18
    ret

# void intt_rv32im(int16_t in[256], const int32_t zetas[128*2]);
# register usage: 
# a0-a1: in/out, zetas; a6: q; a1/a2/a3/a4/a5/a7/gp/ra: tmp
# 4*15(sp), 4*16(sp) for outer/inner loop control
# 4*17(sp) for saving a1
# t0-t6,tp: 8 coeffs; s0-s9: 5 zetas & zetas*qinv
# s10,s11: for scalar-vector hybrid programming
# strategy: 3+3+1 layers merging
# todo: note that this is not the newest version of ntt_dualissue_mont_rv32im.S
.globl intt_rv32im
.align 2
intt_rv32im:
    addi sp, sp, -4*18
    save_regs
    li a6, q
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_123:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_123:
    lh t0, 2*2*0(a0);    lh t1, 2*2*1(a0)
    lh t2, 2*2*2(a0);    lh t3, 2*2*3(a0)
    lh t4, 2*2*4(a0);    lh t5, 2*2*5(a0)
    lh t6, 2*2*6(a0);    lh tp, 2*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 2*2*0(a0);    sh t1, 2*2*1(a0)
    sh t2, 2*2*2(a0);    sh t3, 2*2*3(a0)
    sh t4, 2*2*4(a0);    sh t5, 2*2*5(a0)
    sh t6, 2*2*6(a0);    sh tp, 2*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    # reset a0
    addi a0, a0, -16*16*2
# intt_rv32im_outer_456:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 128*2-16*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
# intt_rv32im_outer_456:
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_inner_456:
    lh t0, 16*2*0(a0);    lh t1, 16*2*1(a0)
    lh t2, 16*2*2(a0);    lh t3, 16*2*3(a0)
    lh t4, 16*2*4(a0);    lh t5, 16*2*5(a0)
    lh t6, 16*2*6(a0);    lh tp, 16*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s3
    mul  t5, a5, s5;    mul  tp, gp, s7
    mulh a2, a1, s0;    mulh a4, a3, s2
    mulh a7, a5, s4;    mulh ra, gp, s6
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    lw   ra, 4*17(sp)
    sub  a1, t0, t2;    sub  a3, t1, t3
    sub  a5, t4, t6;    sub  gp, t5, tp
    lw   a7, 11*4(ra);    lw   ra, 10*4(ra)
    add  t0, t0, t2;    add  t1, t1, t3
    add  t4, t4, t6;    add  t5, t5, tp
    mul  t2, a1, s9;    mul  t3, a3, s9
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, s8;    mulh a4, a3, s8
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t2, t2, a6;    mulh t3, t3, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t2, a2, t2;    sub  t3, a4, t3
    sub  t6, a7, t6;    sub  tp, ra, tp
    lw   a7, 4*17(sp)
    sub  a1, t0, t4;    sub  a3, t1, t5
    sub  a5, t2, t6;    sub  gp, t3, tp
    lw   ra, 12*4(a7);    lw   a7, 13*4(a7)
    add  t0, t0, t4;    add  t1, t1, t5
    add  t2, t2, t6;    add  t3, t3, tp
    mul  t4, a1, a7;    mul  t5, a3, a7
    mul  t6, a5, a7;    mul  tp, gp, a7
    mulh a2, a1, ra;    mulh a4, a3, ra
    mulh a7, a5, ra;    mulh ra, gp, ra
    mulh t4, t4, a6;    mulh t5, t5, a6
    mulh t6, t6, a6;    mulh tp, tp, a6
    sub  t4, a2, t4;    sub  t5, a4, t5
    sub  t6, a7, t6;    sub  tp, ra, tp
    sh t0, 16*2*0(a0);    sh t1, 16*2*1(a0)
    sh t2, 16*2*2(a0);    sh t3, 16*2*3(a0)
    sh t4, 16*2*4(a0);    sh t5, 16*2*5(a0)
    sh t6, 16*2*6(a0);    sh tp, 16*2*7(a0)
    addi a0, a0, 2
    addi a0, a0, 128*2-16*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    # reset a0
    addi a0, a0, -2*128*2
    # load 1 zeta & zeta*qinv
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    addi a0, a0, 2
    # intt_rv32im_looper_7:
    lh t0, 32*2*0(a0);    lh t1, 32*2*1(a0)
    lh t2, 32*2*2(a0);    lh t3, 32*2*3(a0)
    lh t4, 32*2*4(a0);    lh t5, 32*2*5(a0)
    lh t6, 32*2*6(a0);    lh tp, 32*2*7(a0)
    sub  a1, t0, t1;    sub  a3, t2, t3
    sub  a5, t4, t5;    sub  gp, t6, tp
    add  t0, t0, t1;    add  t2, t2, t3
    add  t4, t4, t5;    add  t6, t6, tp
    mul  t1, a1, s1;    mul  t3, a3, s1
    mul  t5, a5, s1;    mul  tp, gp, s1
    mulh a2, a1, s0;    mulh a4, a3, s0
    mulh a7, a5, s0;    mulh ra, gp, s0
    mulh t1, t1, a6;    mulh t3, t3, a6
    mulh t5, t5, a6;    mulh tp, tp, a6
    sub  t1, a2, t1;    sub  t3, a4, t3
    sub  t5, a7, t5;    sub  tp, ra, tp
    sh t0, 32*2*0(a0);    sh t1, 32*2*1(a0)
    sh t2, 32*2*2(a0);    sh t3, 32*2*3(a0)
    sh t4, 32*2*4(a0);    sh t5, 32*2*5(a0)
    sh t6, 32*2*6(a0);    sh tp, 32*2*7(a0)
    restore_regs
    addi sp, sp, 4*18
    ret