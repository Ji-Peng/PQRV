#include "consts.h"

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

.equ q, 3329
.equ q16, 0x0d010000            // q<<16
.equ qinv, 0x6ba8f301           // q^-1 mod+- 2^32
.equ plantconst, 0x13afb8       // (-2^{32} mod q)*qinv mod 2^32
.equ plantconst2, 0x97f44fac    // (2^{64} mod q)*qinv mod 2^32

.globl ntt_hybridx2_rv32imv
.align 2
ntt_hybridx2_rv32imv:
    addi sp, sp, -4*17
    save_regs
    # vector init
    li t4, 128
    vsetvli t5, t4, e16, m1, tu, mu
    li t4, 3329
    # stack init: 4*15(sp) for vector-*a; 4*16(sp) for *vector_zetas
    addi t4, a0, 256*2
    sw   t4, 4*15(sp)
    sw   a2, 4*16(sp)
    li a6, q16        // q<<16
addi a0, a0, 32
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    lw   t5, 4*15(sp)
lw t2, 2*4(a1)
lw t3, 3*4(a1)
addi a0, a0, -2;                                   addi t5, t5, (64*0+128)*2   
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vle16.v v8,  (t5);  addi t5, t5, 16
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vle16.v v9,  (t5);  addi t5, t5, 16
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vle16.v v10, (t5);  addi t5, t5, 16
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v11, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v12, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v v13, (t5);  addi t5, t5, 16
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v v14, (t5);  addi t5, t5, 16
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v15, (t5);  addi t5, t5, -((64*0+128)*2+16*7)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v16, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vle16.v v17, (t5);  addi t5, t5, 16
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vle16.v v18, (t5);  addi t5, t5, 16
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v19, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v20, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v v21, (t5);  addi t5, t5, 16
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v v22, (t5);  addi t5, t5, 16
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v23, (t5);  addi t5, t5, -16*7
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 sw t5, 4*15(sp)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                lw t6, 4*16(sp)
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  lh t5, (_ZETAS_EXP+0)*2(t6)
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                lh t6, (_ZETAS_EXP+1)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v0, v8, t5
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmul.vx v1, v9, t5
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmul.vx v2, v10, t5
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmul.vx v3, v11, t5
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v4, v12, t5
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v5, v13, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vmul.vx v6, v14, t5
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmul.vx v7, v15, t5
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmulh.vx v8,  v8, t6
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v9,  v9, t6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v10, v10, t6
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmulh.vx v11, v11, t6
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmulh.vx v12, v12, t6
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v13, v13, t6
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v14, v14, t6
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v15, v15, t6
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v0, v0, t4
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v1, v1, t4
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vx v2, v2, t4
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmulh.vx v3, v3, t4
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vx v4, v4, t4
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmulh.vx v5, v5, t4
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v6, v6, t4
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v7, v7, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v8,  v8,  v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v9,  v9,  v1
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v10, v10, v2
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11, v11, v3
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v12, v12, v4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v13, v13, v5
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v14, v14, v6
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v15, v15, v7
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v0, v16, v8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v1, v17, v9
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v2, v18, v10
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v3, v19, v11
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v4, v20, v12
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v5, v21, v13
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vadd.vv  v6, v22, v14
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v7, v23, v15
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v8, v16, v8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v9, v17, v9
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vsub.vv  v10, v18, v10
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v11, v19, v11
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v12, v20, v12
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v13, v21, v13
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v14, v22, v14
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vsub.vv  v15, v23, v15
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                lw t5, 4*15(sp)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v0,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v1,  (t5);  addi t5, t5, 16
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vse16.v  v2,  (t5);  addi t5, t5, 16
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vse16.v  v3,  (t5);  addi t5, t5, 16
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v4,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v5,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vse16.v  v6,  (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vse16.v  v7,  (t5);  addi t5, t5, (64*0+128)*2-16*7
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vse16.v  v8,  (t5);  addi t5, t5, 16
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vse16.v  v9,  (t5);  addi t5, t5, 16
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vse16.v  v10, (t5);  addi t5, t5, 16
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vse16.v  v11, (t5);  addi t5, t5, 16
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vse16.v  v12, (t5);  addi t5, t5, 16
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vse16.v  v13, (t5);  addi t5, t5, 16
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v14, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v15, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v  v24, (t5);  addi t5, t5, 16
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v  v25, (t5);  addi t5, t5, 16
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v  v26, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v  v27, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vle16.v  v28, (t5);  addi t5, t5, 16
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vle16.v  v29, (t5);  addi t5, t5, 16
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v  v30, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v  v31, (t5);  addi t5, t5, -(128*2)-16*7
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v  v16, (t5);  addi t5, t5, 16
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v  v17, (t5);  addi t5, t5, 16
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v  v18, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v  v19, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v  v20, (t5);  addi t5, t5, 16
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vle16.v  v21, (t5);  addi t5, t5, 16
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v  v22, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v  v23, (t5);  addi t5, t5, -16*7
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                sw t5, 4*15(sp)
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  lw t6, 4*16(sp)
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               lh t5, (_ZETAS_EXP+0)*2(t6)
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                lh t6, (_ZETAS_EXP+1)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v0, v24, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vmul.vx v1, v25, t5
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmul.vx v2, v26, t5
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmul.vx v3, v27, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v4, v28, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v5, v29, t5
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmul.vx v6, v30, t5
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmul.vx v7, v31, t5
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v24, v24, t6
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v25, v25, t6
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v26, v26, t6
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v27, v27, t6
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v28, v28, t6
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vx v29, v29, t6
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmulh.vx v30, v30, t6
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vx v31, v31, t6
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmulh.vx v0, v0, t4
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v1, v1, t4
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v2, v2, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v3, v3, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v4, v4, t4
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v5, v5, t4
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v6, v6, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v7, v7, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v24, v24, v0
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v25, v25, v1
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v26, v26, v2
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v27, v27, v3
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v28, v28, v4
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v29, v29, v5
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v30, v30, v6
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v31, v31, v7
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v0, v16, v24
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vadd.vv  v1, v17, v25
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v2, v18, v26
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v3, v19, v27
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vadd.vv  v4, v20, v28
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vadd.vv  v5, v21, v29
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vadd.vv  v6, v22, v30
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v7, v23, v31
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v24, v16, v24
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v25, v17, v25
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vsub.vv  v26, v18, v26
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vsub.vv  v27, v19, v27
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v28, v20, v28
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v29, v21, v29
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v30, v22, v30
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v31, v23, v31
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                lw t5, 4*15(sp)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v0,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vse16.v  v1,  (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vse16.v  v2,  (t5);  addi t5, t5, 16
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vse16.v  v3,  (t5);  addi t5, t5, 16
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vse16.v  v4,  (t5);  addi t5, t5, 16
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vse16.v  v5,  (t5);  addi t5, t5, 16
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vse16.v  v6,  (t5);  addi t5, t5, 16
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vse16.v  v7,  (t5);  addi t5, t5, -16*7+128*2
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vse16.v  v24, (t5);  addi t5, t5, 16
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v25, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v26, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v27, (t5);  addi t5, t5, 16
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vse16.v  v28, (t5);  addi t5, t5, 16
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v29, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v30, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vse16.v  v31, (t5);  addi t5, t5, -16*7-192*2
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                sw t5, 4*15(sp)
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lw t6, 4*16(sp)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 addi t5, t6, _MASK_45674567*2;      vle16.v v31, (t5)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                addi t5, t6, _MASK_01230123*2;      vle16.v v30, (t5)
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                addi t5, t6, _MASK_00010045*2;      vle16.v v29, (t5)
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 addi t5, t6, _MASK_23006700*2;      vle16.v v28, (t5)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lw   t5, 4*15(sp);  addi t5, t5, (64+0*128)*2
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v v9,  (t5);  addi t5, t5, 16
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vle16.v v10, (t5);  addi t5, t5, 16
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v11, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v12, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vle16.v v13, (t5);  addi t5, t5, 16
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vle16.v v14, (t5);  addi t5, t5, 16
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vle16.v v15, (t5);  addi t5, t5, 16
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v v16, (t5);  addi t5, t5, -16*7-(64+0*128)*2+(0*128)*2
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v1,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vle16.v v2,  (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vle16.v v3,  (t5);  addi t5, t5, 16
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vle16.v v4,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v5,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v6,  (t5);  addi t5, t5, 16
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vle16.v v7,  (t5);  addi t5, t5, 16
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vle16.v v8,  (t5)
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                lw t6, 4*16(sp)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              lh t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmul.vx v17, v9,  t5
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmul.vx v18, v10, t5
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmul.vx v19, v11, t5
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmul.vx v20, v12, t5
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmul.vx v21, v13, t5
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmul.vx v22, v14, t5
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmul.vx v23, v15, t5
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v24, v16, t5
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v9,  v9,  t6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v10, v10, t6
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v11, v11, t6
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v12, v12, t6
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v13, v13, t6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v14, v14, t6
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v15, v15, t6
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v16, v16, t6
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v21, v21, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v22, v22, t4
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v23, v23, t4
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v24, v24, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v13, v13, v21
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v14, v14, v22
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vsub.vv  v15, v15, v23
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v16, v16, v24
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v17, v17, t4
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v21, v5, v13
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmulh.vx v18, v18, t4
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v22, v6, v14
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v19, v19, t4
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v23, v7, v15
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v20, v20, t4
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vsub.vv  v24, v8, v16
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vsub.vv  v9,  v9,  v17
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v10, v10, v18
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v11, v11, v19
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v12, v12, v20
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v17, v1, v9
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v18, v2, v10
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v19, v3, v11
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vsub.vv  v20, v4, v12
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vadd.vv  v13, v5, v13
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vadd.vv  v14, v6, v14
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vadd.vv  v15, v7, v15
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vadd.vv  v16, v8, v16
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vadd.vv  v9, v1, v9
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vadd.vv  v10, v2, v10
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vadd.vv  v11, v3, v11
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v12, v4, v12
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lw t6, 4*16(sp)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vx v1, v13, t5
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v2, v14, t5
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v3, v15, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmul.vx v4, v16, t5
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v5, v21, t5
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v6, v22, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vx v7, v23, t5
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vx v8, v24, t5
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v13, v13, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v14, v14, t5
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmulh.vx v15, v15, t5
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v16, v16, t5
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vx v21, v21, t5
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmulh.vx v22, v22, t5
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vx v23, v23, t5
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v24, v24, t5
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v1, v1, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v2, v2, t4
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmulh.vx v3, v3, t4
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmulh.vx v4, v4, t4
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v13, v13, v1
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v14, v14, v2
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v15, v15, v3
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v16, v16, v4
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v5, v5, t4
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v1, v9,  v13
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v6, v6, t4
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vadd.vv  v2, v10, v14
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v7, v7, t4
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vadd.vv  v3, v11, v15
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmulh.vx v8, v8, t4
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vadd.vv  v4, v12, v16
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vsub.vv  v21, v21, v5
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v22, v22, v6
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v23, v23, v7
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v24, v24, v8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v5, v17, v21
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v6, v18, v22
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v7, v19, v23
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v8, v20, v24
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v9, v9,  v13
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v10, v10,v14
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11,v11, v15
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v12,v12, v16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v13,v17, v21
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v14,v18, v22
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v15,v19, v23
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v16,v20, v24
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmul.vx v17, v3,  t5
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v18, v4,  t5
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmul.vx v19, v11, t5
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmul.vx v20, v12, t5
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v21, v7,  t5
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v22, v8,  t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmul.vx v23, v15, t5
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmul.vx v24, v16, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v3,  v3,  t5
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmulh.vx v4,  v4,  t5
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v11, v11, t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v12, v12, t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v7,  v7,  t5
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v8,  v8,  t5
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmulh.vx v15, v15, t5
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vx v16, v16, t5
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmulh.vx v17, v17, t4
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v18, v18, t4
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v19, v19, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v20, v20, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v3,  v3,  v17
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v4,  v4,  v18
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11, v11, v19
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v12, v12, v20
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v21, v21, t4
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vadd.vv  v17, v1,  v3
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v22, v22, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v18, v2,  v4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v23, v23, t4
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v19, v9,  v11
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v24, v24, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v20, v10, v12
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v7,  v7,  v21
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vsub.vv  v8,  v8,  v22
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v15, v15, v23
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v16, v16, v24
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vadd.vv  v21, v5,  v7
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vadd.vv  v22, v6,  v8
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vadd.vv  v23, v13, v15
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v24, v14, v16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v1,  v1,  v3
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v2,  v2,  v4
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vsub.vv  v3,  v9,  v11
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vsub.vv  v4,  v10, v12
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v5,  v5,  v7
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v8
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v7,  v13, v15
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v8,  v14, v16
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v9,  v18,  t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v18, v18, t5
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmul.vx v10, v2,   t5
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vx v2,  v2,  t5
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmul.vx v11, v20,  t5
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v20, v20, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vx v12, v4,   t5
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v4,  v4,  t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmul.vx v13, v22,  t5
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v22, v22, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vx v14, v6,   t5
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v6,  v6,  t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmul.vx v15, v24,  t5
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v24, v24, t5
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmul.vx v16, v8,   t5
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v8,  v8,  t5
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v9,  v9,  t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v10, v10, t4
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmulh.vx v11, v11, t4
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmulh.vx v12, v12, t4
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v18, v18, v9
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v2,  v2,  v10
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v20, v20, v11
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v4,  v4,  v12
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v13, v13, t4
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v9,  v17, v18
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v14, v14, t4
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vadd.vv  v10, v1,  v2
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v15, v15, t4
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vadd.vv  v11, v19, v20
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmulh.vx v16, v16, t4
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vadd.vv  v12, v3, v4
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v22, v22, v13
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v6,  v6,  v14
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v24, v24, v15
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v8,  v8,  v16
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v17, v17, v18
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v18, v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v19, v19, v20
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v20, v3,  v4
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vadd.vv  v13, v21,  v22
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v14, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v15, v23, v24
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v2, v9, v31
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v1, v17, v30
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm v2, v17, v2, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v1, v1, v9, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v16, v7, v8
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vrgather.vv v4, v10, v31
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v3, v18, v30
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v4, v18, v4, v0
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmerge.vvm v3, v3, v10, v0
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vsub.vv  v21, v21, v22
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v22, v5,  v6
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v23, v23, v24
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v24, v7,  v8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L5 + 0*_ZETAS_EXP_1TO6_P1_L5)*2
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vle16.v v27, (t6)
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v9,  v2,  v27
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v2,  v2,  v26
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vrgather.vv v6, v11, v31
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vrgather.vv v5, v19, v30
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm v6, v19, v6, v0
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm v5, v5, v11, v0
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vrgather.vv v8, v12, v31
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vrgather.vv v7, v20, v30
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmerge.vvm v8, v20, v8, v0
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmerge.vvm v7, v7, v12, v0
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   addi t6, t6, 8*2;     vle16.v v27, (t6)
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         addi t6, t6, 8*2;     vle16.v v26, (t6)
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmul.vv  v17, v4,  v27
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vv v4,  v4,  v26
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v9,  v9,  t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v17, v17, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v10, v6,  v27
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v6,  v6,  v26
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v2,  v2,  v9
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v10, v10, t4
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vv  v18, v8,  v27
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vv v8,  v8,  v26
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v18, v18, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v4,  v4,  v17
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v6,  v6,  v10
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vsub.vv  v8,  v8,  v18
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v9,  v1,  v2
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v11, v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vadd.vv  v17, v3,  v4
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vsub.vv  v19, v3,  v4
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vadd.vv  v10, v5,  v6
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v12, v5,  v6
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v2, v13, v31
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vrgather.vv v1, v21, v30
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmerge.vvm v2, v21, v2, v0
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmerge.vvm v1, v1, v13, v0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v4, v14, v31
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v3, v22, v30
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmerge.vvm v4, v22, v4, v0
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmerge.vvm v3, v3, v14, v0
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v18, v7,  v8
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v20, v7,  v8
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vrgather.vv v6, v15, v31
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vrgather.vv v5, v23, v30
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmerge.vvm v6, v23, v6, v0
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmerge.vvm v5, v5, v15, v0
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vrgather.vv v8, v16, v31
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vrgather.vv v7, v24, v30
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmerge.vvm v8, v24, v8, v0
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmerge.vvm v7, v7, v16, v0
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vv  v13, v2,  v27
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vv v2,  v2,  v26
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v13, v13, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmul.vv  v21, v4,  v27
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v4,  v4,  v26
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v21, v21, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v14, v6,  v27
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v6,  v6,  v26
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v14, v14, t4
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v22, v8,  v27
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vv v8,  v8,  v26
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vsub.vv  v2,  v2, v13
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v4,  v4, v21
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v22, v22, t4
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v6,  v6, v14
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v8,  v8, v22
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               lw t6, 4*16(sp)
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v13, v1,  v2
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v15, v1,  v2
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vadd.vv  v21, v3,  v4
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v23, v3,  v4
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v14, v5,  v6
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v16, v5,  v6
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vrgather.vv v1, v11, v29
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmerge.vvm  v1, v1, v9, v0
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vrgather.vv v2, v9, v28
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmerge.vvm  v2, v11, v2, v0
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vadd.vv  v22, v7,  v8
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vsub.vv  v24, v7,  v8
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vrgather.vv v3, v19, v29
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmerge.vvm  v3, v3, v17, v0
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v4, v17, v28
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v4, v19, v4, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L6+ 0*_ZETAS_EXP_1TO6_P1_L6)*2
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v v27, (t6)
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v9,  v2,  v27
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vv v2,  v2,  v26
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vrgather.vv v5, v12, v29
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v5, v5, v10, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v6, v10, v28
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v6, v12, v6, v0
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v11, v4,  v27
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vv v4,  v4,  v26
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vrgather.vv v7, v20, v29
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v7, v7, v18, v0
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v8, v18, v28
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmerge.vvm  v8, v20, v8, v0
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v17, v6,  v27
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v6,  v6,  v26
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               addi t6, t6, 8*2;     vle16.v v26, (t6)
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmul.vv  v19, v8,  v27
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v8,  v8,  v26
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v9,  v9,  t4
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmulh.vx v11, v11, t4
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmulh.vx v17, v17, t4
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v19, v19, t4
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v2,  v2,  v9
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vsub.vv  v4,  v4,  v11
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vsub.vv  v6,  v6,  v17
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vsub.vv  v8,  v8,  v19
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vadd.vv  v9,  v1,  v2
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vsub.vv  v11, v1,  v2
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vadd.vv  v17, v3,  v4
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vsub.vv  v19, v3,  v4
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vrgather.vv v1, v15, v29
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v1, v1, v13, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v2, v13, v28
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v2, v15, v2, v0
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v10, v5,  v6
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v12, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v18, v7,  v8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v20, v7,  v8
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vrgather.vv v3, v23, v29
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v3, v3, v21, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v4, v21, v28
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v4, v23, v4, v0
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v13, v2,  v27
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vv v2,  v2,  v26
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vrgather.vv v5, v16, v29
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v5, v5, v14, v0
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v6, v14, v28
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmerge.vvm  v6, v16, v6, v0
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v15, v4,  v27
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v4,  v4,  v26
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vrgather.vv v7, v24, v29
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmerge.vvm  v7, v7, v22, v0
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vrgather.vv v8, v22, v28
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v8, v24, v8, v0
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmul.vv  v21, v6,  v27
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vv v6,  v6,  v26
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmul.vv  v23, v8,  v27
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vv v8,  v8,  v26
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vx v13, v13, t4
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmulh.vx v15, v15, t4
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vx v21, v21, t4
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmulh.vx v23, v23, t4
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v2,  v2,  v13
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v4,  v4,  v15
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v6,  v6,  v21
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v8,  v8,  v23
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v13, v1,  v2
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v15, v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lw t6, 4*16(sp)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v21, v3,  v4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v23, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v1, v11, v27
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v2, v9, v27
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v1, v1, v9, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v2, v11, v2, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v14, v5,  v6
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vsub.vv  v16, v5,  v6
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v3, v19, v27
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v4, v17, v27
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmerge.vvm  v3, v3, v17, v0
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmerge.vvm  v4, v19, v4, v0
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vadd.vv  v22, v7,  v8
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v24, v7,  v8
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v5, v12, v27
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vrgather.vv v6, v10, v27
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmerge.vvm  v5, v5, v10, v0
lw   tp, 9*4(a1);  lw   ra, 10*4(a1)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmerge.vvm  v6, v12, v6, v0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v7, v20, v27
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v8, v18, v27
sub  s1, s0, a7;   sub  s3, s2, gp
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmerge.vvm  v7, v7, v18, v0
mul  a7, s9, a7;   mul  gp, s11, gp
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmerge.vvm  v8, v20, v8, v0
add  s6, s6, ra;   lw   ra, 14*4(a1)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v9, v15, v27
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v11, v13, v27
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vmerge.vvm  v9, v9, v13, v0
add  s8, s8, a7;   add  s10, s10, gp
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmerge.vvm  v11, v15, v11, v0
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vrgather.vv v17, v23, v27
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vrgather.vv v19, v21, v27
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a1, a1, 15*4;                                 vmerge.vvm  v17, v17, v21, v0
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vmerge.vvm  v19, v23, v19, v0
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vrgather.vv v10, v16, v27
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    vrgather.vv v12, v14, v27
lw t1, 1*4(a1)
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    vmerge.vvm  v10, v10, v14, v0
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v12, v16, v12, v0
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v18, v24, v27
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                vrgather.vv v20, v22, v27
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               vmerge.vvm  v18, v18, v22, v0
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v20, v24, v20, v0
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                lw   t5, 4*15(sp);   addi t5, t5, (0*128)*2
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                vse16.v  v1,  (t5);  addi t5, t5, 16
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                vse16.v  v2,  (t5);  addi t5, t5, 16
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v3,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v4,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                vse16.v  v5,  (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                vse16.v  v6,  (t5);  addi t5, t5, 16
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v7,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v8,  (t5);  addi t5, t5, -16*7-(0*128)*2+(64+0*128)*2
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                vse16.v  v9,  (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              vse16.v  v11, (t5);  addi t5, t5, 16
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                vse16.v  v17, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v19, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v10, (t5);  addi t5, t5, 16
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v12, (t5);  addi t5, t5, 16
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  vse16.v  v18, (t5);  addi t5, t5, 16
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v20, (t5)
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 lw   t5, 4*15(sp);  addi t5, t5, (64+1*128)*2
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               vle16.v v9,  (t5);  addi t5, t5, 16
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                vle16.v v10, (t5);  addi t5, t5, 16
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vle16.v v11, (t5);  addi t5, t5, 16
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vle16.v v12, (t5);  addi t5, t5, 16
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32;                                   vle16.v v13, (t5);  addi t5, t5, 16
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vle16.v v14, (t5);  addi t5, t5, 16
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vle16.v v15, (t5);  addi t5, t5, 16
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vle16.v v16, (t5);  addi t5, t5, -16*7-(64+1*128)*2+(1*128)*2
lw t0, 0*4(a1)
lw t1, 1*4(a1)
lw t2, 2*4(a1);                                    vle16.v v1,  (t5);  addi t5, t5, 16
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0;               vle16.v v2,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v3,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v4,  (t5);  addi t5, t5, 16
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0;                vle16.v v5,  (t5);  addi t5, t5, 16
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0;                vle16.v v6,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v7,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v8,  (t5)
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra;                lw t6, 4*16(sp)
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v17, v9,  t5
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2;                vmul.vx v18, v10, t5
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2;                vmul.vx v19, v11, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v20, v12, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v21, v13, t5
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra;               vmul.vx v22, v14, t5
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3;                vmul.vx v23, v15, t5
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v24, v16, t5
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v9,  v9,  t6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vx v10, v10, t6
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v11, v11, t6
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v12, v12, t6
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v13, v13, t6
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v14, v14, t6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v15, v15, t6
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmulh.vx v16, v16, t6
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vmulh.vx v21, v21, t4
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmulh.vx v22, v22, t4
addi a0, a0, 32
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vmulh.vx v23, v23, t4
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vmulh.vx v24, v24, t4
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vsub.vv  v13, v13, v21
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    vsub.vv  v14, v14, v22
lw t2, 2*4(a1)
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v15, v15, v23
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v16, v16, v24
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v17, v17, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v21, v5, v13
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v18, v18, t4
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v22, v6, v14
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v19, v19, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v23, v7, v15
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v20, v20, t4
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v24, v8, v16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v9,  v9,  v17
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v10, v10, v18
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v11, v11, v19
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v12, v12, v20
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v17, v1, v9
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v18, v2, v10
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vsub.vv  v19, v3, v11
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v20, v4, v12
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v13, v5, v13
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vadd.vv  v14, v6, v14
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vadd.vv  v15, v7, v15
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vadd.vv  v16, v8, v16
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v9, v1, v9
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v10, v2, v10
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vadd.vv  v11, v3, v11
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vadd.vv  v12, v4, v12
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           lw t6, 4*16(sp)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32
addi a1, a1, 7*4;                                  vmul.vx v1, v13, t5
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vmul.vx v2, v14, t5
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmul.vx v3, v15, t5
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    vmul.vx v4, v16, t5
lw t1, 1*4(a1)
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v5, v21, t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v6, v22, t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vx v7, v23, t5
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               vmul.vx v8, v24, t5
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v13, v13, t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v14, v14, t5
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v15, v15, t5
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v16, v16, t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                vmulh.vx v21, v21, t5
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                vmulh.vx v22, v22, t5
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v23, v23, t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v24, v24, t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                vmulh.vx v1, v1, t4
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              vmulh.vx v2, v2, t4
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                vmulh.vx v3, v3, t4
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v4, v4, t4
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v13, v13, v1
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v14, v14, v2
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  vsub.vv  v15, v15, v3
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v16, v16, v4
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v5, v5, t4
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               vadd.vv  v1, v9,  v13
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                vmulh.vx v6, v6, t4
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vadd.vv  v2, v10, v14
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmulh.vx v7, v7, t4
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32;                                   vadd.vv  v3, v11, v15
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmulh.vx v8, v8, t4
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vadd.vv  v4, v12, v16
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vsub.vv  v21, v21, v5
lw t0, 0*4(a1)
lw t1, 1*4(a1)
lw t2, 2*4(a1);                                    vsub.vv  v22, v22, v6
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v23, v23, v7
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v24, v24, v8
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v5, v17, v21
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0;                vadd.vv  v6, v18, v22
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0;                vadd.vv  v7, v19, v23
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v8, v20, v24
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v9, v9,  v13
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v10, v10,v14
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1;                vsub.vv  v11,v11, v15
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v12,v12, v16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v13,v17, v21
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v14,v18, v22
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v15,v19, v23
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v16,v20, v24
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra;               vmul.vx v17, v3,  t5
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3;                vmul.vx v18, v4,  t5
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v19, v11, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra;                vmul.vx v20, v12, t5
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra;                vmul.vx v21, v7,  t5
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v22, v8,  t5
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp;                vmul.vx v23, v15, t5
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmul.vx v24, v16, t5
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmulh.vx v3,  v3,  t5
addi a0, a0, 32
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vmulh.vx v4,  v4,  t5
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmulh.vx v11, v11, t5
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    vmulh.vx v12, v12, t5
lw t2, 2*4(a1)
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v7,  v7,  t5
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v8,  v8,  t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v15, v15, t5
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v16, v16, t5
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v17, v17, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v18, v18, t4
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v19, v19, t4
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v20, v20, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v3,  v3,  v17
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v4,  v4,  v18
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v11, v11, v19
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v12, v12, v20
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v21, v21, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v17, v1,  v3
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmulh.vx v22, v22, t4
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v18, v2,  v4
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v23, v23, t4
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vadd.vv  v19, v9,  v11
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmulh.vx v24, v24, t4
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vadd.vv  v20, v10, v12
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v7,  v7,  v21
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v8,  v8,  v22
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v15, v15, v23
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vsub.vv  v16, v16, v24
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vadd.vv  v21, v5,  v7
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vadd.vv  v22, v6,  v8
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32
addi a1, a1, 7*4;                                  vadd.vv  v23, v13, v15
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vadd.vv  v24, v14, v16
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vsub.vv  v1,  v1,  v3
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    vsub.vv  v2,  v2,  v4
lw t1, 1*4(a1)
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    vsub.vv  v3,  v9,  v11
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v4,  v10, v12
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v5,  v5,  v7
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                vsub.vv  v6,  v6,  v8
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               vsub.vv  v7,  v13, v15
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v8,  v14, v16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                vmul.vx v9,  v18,  t5
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v18, v18, t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                vmul.vx v10, v2,   t5
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v2,  v2,  t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                vmul.vx v11, v20,  t5
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                vmulh.vx v20, v20, t5
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v12, v4,   t5
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  vmulh.vx v4,  v4,  t5
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v13, v22,  t5
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                vmulh.vx v22, v22, t5
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmul.vx v14, v6,   t5
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32;                                   lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmulh.vx v6,  v6,  t5
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vmul.vx v15, v24,  t5
lw t0, 0*4(a1)
lw t1, 1*4(a1)
lw t2, 2*4(a1);                                    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0;               vmulh.vx v24, v24, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v16, v8,   t5
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vx v8,  v8,  t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v9,  v9,  t4
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v10, v10, t4
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v11, v11, t4
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v12, v12, t4
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v18, v18, v9
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v2,  v2,  v10
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v20, v20, v11
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v4,  v4,  v12
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v13, v13, t4
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v9,  v17, v18
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vx v14, v14, t4
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3;                vadd.vv  v10, v1,  v2
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v15, v15, t4
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v11, v19, v20
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vx v16, v16, t4
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp;                vadd.vv  v12, v3, v4
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra;                addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v22, v22, v13
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v14
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v24, v24, v15
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vsub.vv  v8,  v8,  v16
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vsub.vv  v17, v17, v18
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vsub.vv  v18, v1,  v2
addi a0, a0, 32
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vsub.vv  v19, v19, v20
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vsub.vv  v20, v3,  v4
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vadd.vv  v13, v21,  v22
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    vadd.vv  v14, v5,  v6
lw t2, 2*4(a1)
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0;                vadd.vv  v15, v23, v24
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v2, v9, v31
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v1, v17, v30
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm v2, v17, v2, v0
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm v1, v1, v9, v0
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v16, v7, v8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v4, v10, v31
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vrgather.vv v3, v18, v30
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmerge.vvm v4, v18, v4, v0
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm v3, v3, v10, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v21, v21, v22
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v22, v5,  v6
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v23, v23, v24
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v24, v7,  v8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L5 + 1*_ZETAS_EXP_1TO6_P1_L5)*2
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v v27, (t6)
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v9,  v2,  v27
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v2,  v2,  v26
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vrgather.vv v6, v11, v31
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vrgather.vv v5, v19, v30
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmerge.vvm v6, v19, v6, v0
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm v5, v5, v11, v0
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v8, v12, v31
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vrgather.vv v7, v20, v30
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vmerge.vvm v8, v20, v8, v0
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vmerge.vvm v7, v7, v12, v0
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          addi t6, t6, 8*2;     vle16.v v27, (t6)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32
addi a1, a1, 7*4;                                  addi t6, t6, 8*2;     vle16.v v26, (t6)
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vmul.vv  v17, v4,  v27
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmulh.vv v4,  v4,  v26
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    vmulh.vx v9,  v9,  t4
lw t1, 1*4(a1)
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    vmulh.vx v17, v17, t4
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vv  v10, v6,  v27
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vv v6,  v6,  v26
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v2,  v2,  v9
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v10, v10, t4
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v18, v8,  v27
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vv v8,  v8,  v26
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                vmulh.vx v18, v18, t4
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                vsub.vv  v4,  v4,  v17
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v6,  v6,  v10
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v8,  v8,  v18
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                vadd.vv  v9,  v1,  v2
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              vsub.vv  v11, v1,  v2
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                vadd.vv  v17, v3,  v4
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v19, v3,  v4
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v10, v5,  v6
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v12, v5,  v6
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  vrgather.vv v2, v13, v31
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v1, v21, v30
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v2, v21, v2, v0
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               vmerge.vvm v1, v1, v13, v0
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                vrgather.vv v4, v14, v31
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vrgather.vv v3, v22, v30
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmerge.vvm v4, v22, v4, v0
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32;                                   vmerge.vvm v3, v3, v14, v0
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vadd.vv  v18, v7,  v8
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vsub.vv  v20, v7,  v8
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vrgather.vv v6, v15, v31
lw t0, 0*4(a1)
lw t1, 1*4(a1)
lw t2, 2*4(a1);                                    vrgather.vv v5, v23, v30
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0;               vmerge.vvm v6, v23, v6, v0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm v5, v5, v15, v0
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v8, v16, v31
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0;                vrgather.vv v7, v24, v30
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0;                vmerge.vvm v8, v24, v8, v0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm v7, v7, v16, v0
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1;                vmul.vv  v13, v2,  v27
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v2,  v2,  v26
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v13, v13, t4
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v21, v4,  v27
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v4,  v4,  v26
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vx v21, v21, t4
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v14, v6,  v27
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vv v6,  v6,  v26
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v14, v14, t4
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v22, v8,  v27
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vv v8,  v8,  v26
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vsub.vv  v2,  v2, v13
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vsub.vv  v4,  v4, v21
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmulh.vx v22, v22, t4
addi a0, a0, 32
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vsub.vv  v6,  v6, v14
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vsub.vv  v8,  v8, v22
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          lw t6, 4*16(sp)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
lw t2, 2*4(a1)
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0;                vadd.vv  v13, v1,  v2
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v15, v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v21, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v23, v3,  v4
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v14, v5,  v6
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v16, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v1, v11, v29
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmerge.vvm  v1, v1, v9, v0
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vrgather.vv v2, v9, v28
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v2, v11, v2, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v22, v7,  v8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v24, v7,  v8
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v3, v19, v29
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v3, v3, v17, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v4, v17, v28
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmerge.vvm  v4, v19, v4, v0
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L6+ 1*_ZETAS_EXP_1TO6_P1_L6)*2
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmul.vv  v9,  v2,  v27
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmulh.vv v2,  v2,  v26
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vrgather.vv v5, v12, v29
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v5, v5, v10, v0
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v6, v10, v28
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vmerge.vvm  v6, v12, v6, v0
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           addi t6, t6, 8*2;     vle16.v v27, (t6)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           addi t6, t6, 8*2;     vle16.v v26, (t6)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vmul.vv  v11, v4,  v27
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32
addi a1, a1, 7*4;                                  vmulh.vv v4,  v4,  v26
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vrgather.vv v7, v20, v29
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmerge.vvm  v7, v7, v18, v0
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    vrgather.vv v8, v18, v28
lw t1, 1*4(a1)
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    vmerge.vvm  v8, v20, v8, v0
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vv  v17, v6,  v27
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vv v6,  v6,  v26
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                vmul.vv  v19, v8,  v27
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vv v8,  v8,  v26
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v9,  v9,  t4
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v11, v11, t4
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                vmulh.vx v17, v17, t4
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                vmulh.vx v19, v19, t4
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v2,  v2,  v9
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v4,  v4,  v11
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                vsub.vv  v6,  v6,  v17
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              vsub.vv  v8,  v8,  v19
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                vadd.vv  v9,  v1,  v2
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11, v1,  v2
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v17, v3,  v4
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v19, v3,  v4
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  vrgather.vv v1, v15, v29
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v1, v1, v13, v0
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v2, v13, v28
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               vmerge.vvm  v2, v15, v2, v0
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                vadd.vv  v10, v5,  v6
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vsub.vv  v12, v5,  v6
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vadd.vv  v18, v7,  v8
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32;                                   vsub.vv  v20, v7,  v8
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vrgather.vv v3, v23, v29
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vmerge.vvm  v3, v3, v21, v0
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vrgather.vv v4, v21, v28
lw t0, 0*4(a1)
lw t1, 1*4(a1)
lw t2, 2*4(a1);                                    vmerge.vvm  v4, v23, v4, v0
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0;               addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v13, v2,  v27
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vv v2,  v2,  v26
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0;                vrgather.vv v5, v16, v29
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v5, v5, v14, v0
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v6, v14, v28
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra;                vmerge.vvm  v6, v16, v6, v0
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v15, v4,  v27
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2;                vmulh.vv v4,  v4,  v26
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2;                vrgather.vv v7, v24, v29
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v7, v7, v22, v0
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v8, v22, v28
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra;               vmerge.vvm  v8, v24, v8, v0
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v21, v6,  v27
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vv v6,  v6,  v26
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v23, v8,  v27
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v8,  v8,  v26
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v13, v13, t4
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmulh.vx v15, v15, t4
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vmulh.vx v21, v21, t4
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmulh.vx v23, v23, t4
addi a0, a0, 32
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vsub.vv  v2,  v2,  v13
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vsub.vv  v4,  v4,  v15
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vsub.vv  v6,  v6,  v21
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    vsub.vv  v8,  v8,  v23
lw t2, 2*4(a1)
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0;                vadd.vv  v13, v1,  v2
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v15, v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lw t6, 4*16(sp)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v21, v3,  v4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v23, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vrgather.vv v1, v11, v27
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vrgather.vv v2, v9, v27
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v1, v1, v9, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v2, v11, v2, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v14, v5,  v6
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v16, v5,  v6
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v3, v19, v27
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v4, v17, v27
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmerge.vvm  v3, v3, v17, v0
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmerge.vvm  v4, v19, v4, v0
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v22, v7,  v8
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v24, v7,  v8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vrgather.vv v5, v12, v27
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vrgather.vv v6, v10, v27
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmerge.vvm  v5, v5, v10, v0
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v6, v12, v6, v0
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v7, v20, v27
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vrgather.vv v8, v18, v27
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vmerge.vvm  v7, v7, v18, v0
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vmerge.vvm  v8, v20, v8, v0
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vrgather.vv v9, v15, v27
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32
addi a1, a1, 7*4;                                  vrgather.vv v11, v13, v27
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vmerge.vvm  v9, v9, v13, v0
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmerge.vvm  v11, v15, v11, v0
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    vrgather.vv v17, v23, v27
lw t1, 1*4(a1)
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    vrgather.vv v19, v21, v27
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v17, v17, v21, v0
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v19, v23, v19, v0
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                vrgather.vv v10, v16, v27
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               vrgather.vv v12, v14, v27
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v10, v10, v14, v0
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v12, v16, v12, v0
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                vrgather.vv v18, v24, v27
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                vrgather.vv v20, v22, v27
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v18, v18, v22, v0
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v20, v24, v20, v0
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                lw   t5, 4*15(sp);   addi t5, t5, (1*128)*2
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                vse16.v  v1,  (t5);  addi t5, t5, 16
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v2,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v3,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                vse16.v  v4,  (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              vse16.v  v5,  (t5);  addi t5, t5, 16
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                vse16.v  v6,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v7,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v8,  (t5);  addi t5, t5, -16*7-(1*128)*2+(64+1*128)*2
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v9,  (t5);  addi t5, t5, 16
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  vse16.v  v11, (t5);  addi t5, t5, 16
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v17, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v19, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               vse16.v  v10, (t5);  addi t5, t5, 16
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                vse16.v  v12, (t5);  addi t5, t5, 16
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vse16.v  v18, (t5);  addi t5, t5, 16
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vse16.v  v20, (t5)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
    restore_regs
    addi sp, sp, 4*17
    ret

.globl ntt_hybridx3_rv32imv
.align 2
ntt_hybridx3_rv32imv:
    addi sp, sp, -4*17
    save_regs
    # vector init
    li t4, 128
    vsetvli t5, t4, e16, m1, tu, mu
    li t4, 3329
    # stack init: 4*15(sp) for vector-*a; 4*16(sp) for *vector_zetas
    addi t4, a0, 256*2
    sw   t4, 4*15(sp)
    sw   a2, 4*16(sp)
    li a6, q16        // q<<16
addi a0, a0, 32;                                   lw   t5, 4*15(sp)
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    addi t5, t5, (64*0+128)*2   
lw t2, 2*4(a1);                                    vle16.v v8,  (t5);  addi t5, t5, 16
lw t3, 3*4(a1)
addi a0, a0, -2;                                   vle16.v v9,  (t5);  addi t5, t5, 16
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vle16.v v10, (t5);  addi t5, t5, 16
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vle16.v v11, (t5);  addi t5, t5, 16
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vle16.v v12, (t5);  addi t5, t5, 16
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vle16.v v13, (t5);  addi t5, t5, 16
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vle16.v v14, (t5);  addi t5, t5, 16
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vle16.v v15, (t5);  addi t5, t5, -((64*0+128)*2+16*7)
mul  tp, s10, t0;  mul  ra, s11, t0;               vle16.v v16, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v17, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v18, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v19, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v20, (t5);  addi t5, t5, 16
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v v21, (t5);  addi t5, t5, 16
mul  a7, a2, t0;   mul  gp, a3, t0;                vle16.v v22, (t5);  addi t5, t5, 16
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v v23, (t5);  addi t5, t5, -16*7
mul  tp, a4, t0;   mul  ra, a5, t0;                sw t5, 4*15(sp)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lw t6, 4*16(sp)
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, (_ZETAS_EXP+0)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lh t6, (_ZETAS_EXP+1)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v0, v8, t5
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmul.vx v1, v9, t5
sub  a4, s6, tp;   sub  a5, s7, ra;                vmul.vx v2, v10, t5
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmul.vx v3, v11, t5
mul  tp, s6, t1;   mul  ra, s7, t1;                vmul.vx v4, v12, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v5, v13, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v6, v14, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v7, v15, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v8,  v8, t6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v9,  v9, t6
mul  a7, a2, t2;   mul  gp, a3, t2;                vmulh.vx v10, v10, t6
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v11, v11, t6
mul  tp, a4, t2;   mul  ra, a5, t2;                vmulh.vx v12, v12, t6
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v13, v13, t6
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v14, v14, t6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v15, v15, t6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v0, v0, t4
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v1, v1, t4
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vx v2, v2, t4
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmulh.vx v3, v3, t4
mul  a7, s2, t3;   mul  gp, s3, t3;                vmulh.vx v4, v4, t4
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v5, v5, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v6, v6, t4
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v7, v7, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v8,  v8,  v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v9,  v9,  v1
sub  s6, s4, tp;   sub  s7, s5, ra;                vsub.vv  v10, v10, v2
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vsub.vv  v11, v11, v3
add  s5, s5, ra;   add  s4, s4, tp;                vsub.vv  v12, v12, v4
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v13, v13, v5
mul  tp, a4, ra;   mul  ra, a5, ra;                vsub.vv  v14, v14, v6
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v15, v15, v7
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v0, v16, v8
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v1, v17, v9
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v2, v18, v10
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vadd.vv  v3, v19, v11
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v4, v20, v12
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vadd.vv  v5, v21, v13
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vadd.vv  v6, v22, v14
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vadd.vv  v7, v23, v15
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v8, v16, v8
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v9, v17, v9
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v10, v18, v10
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v11, v19, v11
sub  s1, s0, a7;   sub  s3, s2, gp;                vsub.vv  v12, v20, v12
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v13, v21, v13
mul  a7, s9, a7;   mul  gp, s11, gp;               vsub.vv  v14, v22, v14
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v15, v23, v15
add  s6, s6, ra;   lw   ra, 14*4(a1);              lw t5, 4*15(sp)
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v0,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v1,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v2,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v3,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vse16.v  v4,  (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s10, s10, gp;              vse16.v  v5,  (t5);  addi t5, t5, 16
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vse16.v  v6,  (t5);  addi t5, t5, 16
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vse16.v  v7,  (t5);  addi t5, t5, (64*0+128)*2-16*7
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vse16.v  v8,  (t5);  addi t5, t5, 16
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vse16.v  v9,  (t5);  addi t5, t5, 16
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vse16.v  v10, (t5);  addi t5, t5, 16
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vse16.v  v11, (t5);  addi t5, t5, 16
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vse16.v  v12, (t5);  addi t5, t5, 16
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vse16.v  v13, (t5);  addi t5, t5, 16
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vse16.v  v14, (t5);  addi t5, t5, 16
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vse16.v  v15, (t5);  addi t5, t5, 16
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vle16.v  v24, (t5);  addi t5, t5, 16
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vle16.v  v25, (t5);  addi t5, t5, 16
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vle16.v  v26, (t5);  addi t5, t5, 16
mul  tp, s10, t0;  mul  ra, s11, t0;               vle16.v  v27, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v  v28, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v  v29, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v  v30, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v  v31, (t5);  addi t5, t5, -(128*2)-16*7
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v  v16, (t5);  addi t5, t5, 16
mul  a7, a2, t0;   mul  gp, a3, t0;                vle16.v  v17, (t5);  addi t5, t5, 16
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v  v18, (t5);  addi t5, t5, 16
mul  tp, a4, t0;   mul  ra, a5, t0;                vle16.v  v19, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v  v20, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v  v21, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v  v22, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v  v23, (t5);  addi t5, t5, -16*7
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                sw t5, 4*15(sp)
sub  a4, s6, tp;   sub  a5, s7, ra;                lw t6, 4*16(sp)
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                lh t5, (_ZETAS_EXP+0)*2(t6)
mul  tp, s6, t1;   mul  ra, s7, t1;                lh t6, (_ZETAS_EXP+1)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v0, v24, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v1, v25, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v2, v26, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v3, v27, t5
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vx v4, v28, t5
mul  a7, a2, t2;   mul  gp, a3, t2;                vmul.vx v5, v29, t5
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vx v6, v30, t5
mul  tp, a4, t2;   mul  ra, a5, t2;                vmul.vx v7, v31, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v24, v24, t6
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v25, v25, t6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v26, v26, t6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v27, v27, t6
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v28, v28, t6
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vx v29, v29, t6
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmulh.vx v30, v30, t6
mul  a7, s2, t3;   mul  gp, s3, t3;                vmulh.vx v31, v31, t6
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v0, v0, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v1, v1, t4
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v2, v2, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v3, v3, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vx v4, v4, t4
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vx v5, v5, t4
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmulh.vx v6, v6, t4
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v7, v7, t4
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v24, v24, v0
mul  tp, a4, ra;   mul  ra, a5, ra;                vsub.vv  v25, v25, v1
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v26, v26, v2
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v27, v27, v3
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v28, v28, v4
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v29, v29, v5
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v30, v30, v6
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v31, v31, v7
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vadd.vv  v0, v16, v24
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vadd.vv  v1, v17, v25
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vadd.vv  v2, v18, v26
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v3, v19, v27
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v4, v20, v28
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v5, v21, v29
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v6, v22, v30
sub  s1, s0, a7;   sub  s3, s2, gp;                vadd.vv  v7, v23, v31
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v24, v16, v24
mul  a7, s9, a7;   mul  gp, s11, gp;               vsub.vv  v25, v17, v25
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v26, v18, v26
add  s6, s6, ra;   lw   ra, 14*4(a1);              vsub.vv  v27, v19, v27
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v28, v20, v28
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v29, v21, v29
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v30, v22, v30
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v31, v23, v31
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              lw t5, 4*15(sp)
add  s8, s8, a7;   add  s10, s10, gp;              vse16.v  v0,  (t5);  addi t5, t5, 16
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vse16.v  v1,  (t5);  addi t5, t5, 16
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vse16.v  v2,  (t5);  addi t5, t5, 16
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vse16.v  v3,  (t5);  addi t5, t5, 16
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vse16.v  v4,  (t5);  addi t5, t5, 16
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vse16.v  v5,  (t5);  addi t5, t5, 16
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vse16.v  v6,  (t5);  addi t5, t5, 16
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vse16.v  v7,  (t5);  addi t5, t5, -16*7+128*2
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vse16.v  v24, (t5);  addi t5, t5, 16
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vse16.v  v25, (t5);  addi t5, t5, 16
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vse16.v  v26, (t5);  addi t5, t5, 16
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vse16.v  v27, (t5);  addi t5, t5, 16
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vse16.v  v28, (t5);  addi t5, t5, 16
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vse16.v  v29, (t5);  addi t5, t5, 16
mul  tp, s10, t0;  mul  ra, s11, t0;               vse16.v  v30, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v31, (t5);  addi t5, t5, -16*7-192*2
mulh a7, a7, a6;   mulh gp, gp, a6;                sw t5, 4*15(sp)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lw t6, 4*16(sp)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t5, t6, _MASK_45674567*2;      vle16.v v31, (t5)
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                addi t5, t6, _MASK_01230123*2;      vle16.v v30, (t5)
mul  a7, a2, t0;   mul  gp, a3, t0;                addi t5, t6, _MASK_00010045*2;      vle16.v v29, (t5)
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                addi t5, t6, _MASK_23006700*2;      vle16.v v28, (t5)
mul  tp, a4, t0;   mul  ra, a5, t0;                lw   t5, 4*15(sp);  addi t5, t5, (64+0*128)*2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v9,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v10, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v11, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v12, (t5);  addi t5, t5, 16
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vle16.v v13, (t5);  addi t5, t5, 16
sub  a4, s6, tp;   sub  a5, s7, ra;                vle16.v v14, (t5);  addi t5, t5, 16
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vle16.v v15, (t5);  addi t5, t5, 16
mul  tp, s6, t1;   mul  ra, s7, t1;                vle16.v v16, (t5);  addi t5, t5, -16*7-(64+0*128)*2+(0*128)*2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v1,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v2,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v3,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v4,  (t5);  addi t5, t5, 16
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v v5,  (t5);  addi t5, t5, 16
mul  a7, a2, t2;   mul  gp, a3, t2;                vle16.v v6,  (t5);  addi t5, t5, 16
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v v7,  (t5);  addi t5, t5, 16
mul  tp, a4, t2;   mul  ra, a5, t2;                vle16.v v8,  (t5)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lw t6, 4*16(sp)
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lh t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v17, v9,  t5
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmul.vx v18, v10, t5
sub  a4, s10, tp;  sub  a5, s11, ra;               vmul.vx v19, v11, t5
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmul.vx v20, v12, t5
mul  a7, s2, t3;   mul  gp, s3, t3;                vmul.vx v21, v13, t5
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v22, v14, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v23, v15, t5
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v24, v16, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v9,  v9,  t6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vx v10, v10, t6
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vx v11, v11, t6
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmulh.vx v12, v12, t6
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v13, v13, t6
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vx v14, v14, t6
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v15, v15, t6
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v16, v16, t6
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v21, v21, t4
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v22, v22, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v23, v23, t4
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v24, v24, t4
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v13, v13, v21
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vsub.vv  v14, v14, v22
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vsub.vv  v15, v15, v23
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vsub.vv  v16, v16, v24
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v17, v17, t4
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v21, v5, v13
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v18, v18, t4
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v22, v6, v14
sub  s1, s0, a7;   sub  s3, s2, gp;                vmulh.vx v19, v19, t4
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v23, v7, v15
mul  a7, s9, a7;   mul  gp, s11, gp;               vmulh.vx v20, v20, t4
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v24, v8, v16
add  s6, s6, ra;   lw   ra, 14*4(a1);              vsub.vv  v9,  v9,  v17
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v10, v10, v18
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11, v11, v19
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v12, v12, v20
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v17, v1, v9
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vsub.vv  v18, v2, v10
add  s8, s8, a7;   add  s10, s10, gp;              vsub.vv  v19, v3, v11
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vsub.vv  v20, v4, v12
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vadd.vv  v13, v5, v13
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vadd.vv  v14, v6, v14
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vadd.vv  v15, v7, v15
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vadd.vv  v16, v8, v16
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vadd.vv  v9, v1, v9
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vadd.vv  v10, v2, v10
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vadd.vv  v11, v3, v11
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vadd.vv  v12, v4, v12
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         lw t6, 4*16(sp)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vmul.vx v1, v13, t5
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmul.vx v2, v14, t5
mul  tp, s10, t0;  mul  ra, s11, t0;               vmul.vx v3, v15, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v4, v16, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v5, v21, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v6, v22, t5
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vx v7, v23, t5
mul  a7, a2, t0;   mul  gp, a3, t0;                vmul.vx v8, v24, t5
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vx v13, v13, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v14, v14, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v15, v15, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v16, v16, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v21, v21, t5
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v22, v22, t5
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v23, v23, t5
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v24, v24, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v1, v1, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v2, v2, t4
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v3, v3, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v4, v4, t4
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v13, v13, v1
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v14, v14, v2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v15, v15, v3
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v16, v16, v4
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v5, v5, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v1, v9,  v13
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v6, v6, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v2, v10, v14
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v7, v7, t4
sub  a4, s10, tp;  sub  a5, s11, ra;               vadd.vv  v3, v11, v15
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmulh.vx v8, v8, t4
mul  a7, s2, t3;   mul  gp, s3, t3;                vadd.vv  v4, v12, v16
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v21, v21, v5
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v22, v22, v6
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v23, v23, v7
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v24, v24, v8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vadd.vv  v5, v17, v21
sub  s6, s4, tp;   sub  s7, s5, ra;                vadd.vv  v6, v18, v22
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vadd.vv  v7, v19, v23
add  s5, s5, ra;   add  s4, s4, tp;                vadd.vv  v8, v20, v24
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v9, v9,  v13
mul  tp, a4, ra;   mul  ra, a5, ra;                vsub.vv  v10, v10,v14
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v11,v11, v15
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v12,v12, v16
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v13,v17, v21
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v14,v18, v22
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v15,v19, v23
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v16,v20, v24
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmul.vx v17, v3,  t5
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmul.vx v18, v4,  t5
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v19, v11, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v20, v12, t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
sub  s1, s0, a7;   sub  s3, s2, gp;                vmul.vx v21, v7,  t5
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmul.vx v22, v8,  t5
mul  a7, s9, a7;   mul  gp, s11, gp;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmul.vx v23, v15, t5
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmul.vx v24, v16, t5
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v3,  v3,  t5
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v4,  v4,  t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v11, v11, t5
add  s8, s8, a7;   add  s10, s10, gp;              vmulh.vx v12, v12, t5
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmulh.vx v7,  v7,  t5
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v8,  v8,  t5
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vx v15, v15, t5
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmulh.vx v16, v16, t5
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmulh.vx v17, v17, t4
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vmulh.vx v18, v18, t4
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vx v19, v19, t4
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vmulh.vx v20, v20, t4
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vsub.vv  v3,  v3,  v17
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vsub.vv  v4,  v4,  v18
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v11, v11, v19
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v12, v12, v20
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v21, v21, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v17, v1,  v3
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v22, v22, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v18, v2,  v4
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v23, v23, t4
mul  a7, a2, t0;   mul  gp, a3, t0;                vadd.vv  v19, v9,  v11
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v24, v24, t4
mul  tp, a4, t0;   mul  ra, a5, t0;                vadd.vv  v20, v10, v12
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v7,  v7,  v21
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v8,  v8,  v22
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v15, v15, v23
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v16, v16, v24
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vadd.vv  v21, v5,  v7
sub  a4, s6, tp;   sub  a5, s7, ra;                vadd.vv  v22, v6,  v8
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vadd.vv  v23, v13, v15
mul  tp, s6, t1;   mul  ra, s7, t1;                vadd.vv  v24, v14, v16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v1,  v1,  v3
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v2,  v2,  v4
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v3,  v9,  v11
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v4,  v10, v12
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v5,  v5,  v7
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v6,  v6,  v8
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v7,  v13, v15
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v8,  v14, v16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v9,  v18,  t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v18, v18, t5
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
sub  a4, s10, tp;  sub  a5, s11, ra;               vmul.vx v10, v2,   t5
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
mul  a7, s2, t3;   mul  gp, s3, t3;                vmulh.vx v2,  v2,  t5
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v11, v20,  t5
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v20, v20, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
sub  s6, s4, tp;   sub  s7, s5, ra;                vmul.vx v12, v4,   t5
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v4,  v4,  t5
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
mul  tp, a4, ra;   mul  ra, a5, ra;                vmul.vx v13, v22,  t5
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v22, v22, t5
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v14, v6,   t5
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v6,  v6,  t5
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmul.vx v15, v24,  t5
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v24, v24, t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v16, v8,   t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
sub  s1, s0, a7;   sub  s3, s2, gp;                vmulh.vx v8,  v8,  t5
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmulh.vx v9,  v9,  t4
mul  a7, s9, a7;   mul  gp, s11, gp;               vmulh.vx v10, v10, t4
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmulh.vx v11, v11, t4
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmulh.vx v12, v12, t4
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v18, v18, v9
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v2,  v2,  v10
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v20, v20, v11
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v4,  v4,  v12
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v13, v13, t4
add  s8, s8, a7;   add  s10, s10, gp;              vadd.vv  v9,  v17, v18
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v14, v14, t4
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vadd.vv  v10, v1,  v2
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v15, v15, t4
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vadd.vv  v11, v19, v20
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vx v16, v16, t4
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vadd.vv  v12, v3, v4
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vsub.vv  v22, v22, v13
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vsub.vv  v6,  v6,  v14
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vsub.vv  v24, v24, v15
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vsub.vv  v8,  v8,  v16
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vsub.vv  v17, v17, v18
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v18, v1,  v2
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v19, v19, v20
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v20, v3,  v4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v13, v21,  v22
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v14, v5,  v6
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v15, v23, v24
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v2, v9, v31
mul  a7, a2, t0;   mul  gp, a3, t0;                vrgather.vv v1, v17, v30
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm v2, v17, v2, v0
mul  tp, a4, t0;   mul  ra, a5, t0;                vmerge.vvm v1, v1, v9, v0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v16, v7, v8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v4, v10, v31
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v3, v18, v30
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm v4, v18, v4, v0
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmerge.vvm v3, v3, v10, v0
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v21, v21, v22
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v22, v5,  v6
mul  tp, s6, t1;   mul  ra, s7, t1;                vsub.vv  v23, v23, v24
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v24, v7,  v8
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L5 + 0*_ZETAS_EXP_1TO6_P1_L5)*2
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vv  v9,  v2,  v27
mul  a7, a2, t2;   mul  gp, a3, t2;                vmulh.vv v2,  v2,  v26
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v6, v11, v31
mul  tp, a4, t2;   mul  ra, a5, t2;                vrgather.vv v5, v19, v30
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm v6, v19, v6, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm v5, v5, v11, v0
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v8, v12, v31
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v7, v20, v30
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmerge.vvm v8, v20, v8, v0
sub  a4, s10, tp;  sub  a5, s11, ra;               vmerge.vvm v7, v7, v12, v0
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  a7, s2, t3;   mul  gp, s3, t3;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v17, v4,  v27
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vv v4,  v4,  v26
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v9,  v9,  t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v17, v17, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s6, s4, tp;   sub  s7, s5, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmul.vv  v10, v6,  v27
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vv v6,  v6,  v26
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v2,  v2,  v9
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v10, v10, t4
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v18, v8,  v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v8,  v8,  v26
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v18, v18, t4
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v4,  v4,  v17
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vsub.vv  v6,  v6,  v10
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vsub.vv  v8,  v8,  v18
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vadd.vv  v9,  v1,  v2
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v11, v1,  v2
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v17, v3,  v4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v19, v3,  v4
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v10, v5,  v6
sub  s1, s0, a7;   sub  s3, s2, gp;                vsub.vv  v12, v5,  v6
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vrgather.vv v2, v13, v31
mul  a7, s9, a7;   mul  gp, s11, gp;               vrgather.vv v1, v21, v30
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmerge.vvm v2, v21, v2, v0
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmerge.vvm v1, v1, v13, v0
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v4, v14, v31
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v3, v22, v30
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm v4, v22, v4, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v3, v3, v14, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vadd.vv  v18, v7,  v8
add  s8, s8, a7;   add  s10, s10, gp;              vsub.vv  v20, v7,  v8
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vrgather.vv v6, v15, v31
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vrgather.vv v5, v23, v30
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmerge.vvm v6, v23, v6, v0
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmerge.vvm v5, v5, v15, v0
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vrgather.vv v8, v16, v31
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vrgather.vv v7, v24, v30
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmerge.vvm v8, v24, v8, v0
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vmerge.vvm v7, v7, v16, v0
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         addi t6, t6, 8*2;     vle16.v v27, (t6)
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         addi t6, t6, 8*2;     vle16.v v26, (t6)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmul.vv  v13, v2,  v27
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vmulh.vv v2,  v2,  v26
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v13, v13, t4
mul  tp, s10, t0;  mul  ra, s11, t0;               addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v21, v4,  v27
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v4,  v4,  v26
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v21, v21, t4
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  a7, a2, t0;   mul  gp, a3, t0;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vv  v14, v6,  v27
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vv v6,  v6,  v26
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v14, v14, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v22, v8,  v27
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vv v8,  v8,  v26
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v2,  v2, v13
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v4,  v4, v21
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v22, v22, t4
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v6,  v6, v14
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v8,  v8, v22
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lw t6, 4*16(sp)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v13, v1,  v2
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v15, v1,  v2
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v21, v3,  v4
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v23, v3,  v4
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v14, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v16, v5,  v6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v1, v11, v29
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v1, v1, v9, v0
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vrgather.vv v2, v9, v28
sub  a4, s10, tp;  sub  a5, s11, ra;               vmerge.vvm  v2, v11, v2, v0
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vadd.vv  v22, v7,  v8
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v24, v7,  v8
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v3, v19, v29
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v3, v3, v17, v0
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v4, v17, v28
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v4, v19, v4, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L6+ 0*_ZETAS_EXP_1TO6_P1_L6)*2
sub  s6, s4, tp;   sub  s7, s5, ra;                vle16.v v27, (t6)
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s5, s5, ra;   add  s4, s4, tp;                vmul.vv  v9,  v2,  v27
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vv v2,  v2,  v26
mul  tp, a4, ra;   mul  ra, a5, ra;                vrgather.vv v5, v12, v29
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v5, v5, v10, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v6, v10, v28
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v6, v12, v6, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s8, s8, a7;   add  s9, s9, gp;                vmul.vv  v11, v4,  v27
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmulh.vv v4,  v4,  v26
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vrgather.vv v7, v20, v29
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmerge.vvm  v7, v7, v18, v0
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v8, v18, v28
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v8, v20, v8, v0
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s1, s0, a7;   sub  s3, s2, gp;                vmul.vv  v17, v6,  v27
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmulh.vv v6,  v6,  v26
mul  a7, s9, a7;   mul  gp, s11, gp;               addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmul.vv  v19, v8,  v27
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vv v8,  v8,  v26
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v9,  v9,  t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v11, v11, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v17, v17, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v19, v19, t4
add  s8, s8, a7;   add  s10, s10, gp;              vsub.vv  v2,  v2,  v9
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vsub.vv  v4,  v4,  v11
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vsub.vv  v6,  v6,  v17
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vsub.vv  v8,  v8,  v19
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vadd.vv  v9,  v1,  v2
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vsub.vv  v11, v1,  v2
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vadd.vv  v17, v3,  v4
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vsub.vv  v19, v3,  v4
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vrgather.vv v1, v15, v29
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmerge.vvm  v1, v1, v13, v0
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vrgather.vv v2, v13, v28
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmerge.vvm  v2, v15, v2, v0
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vadd.vv  v10, v5,  v6
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v12, v5,  v6
mul  tp, s10, t0;  mul  ra, s11, t0;               vadd.vv  v18, v7,  v8
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v20, v7,  v8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v3, v23, v29
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v3, v3, v21, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v4, v21, v28
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v4, v23, v4, v0
mul  a7, a2, t0;   mul  gp, a3, t0;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, a4, t0;   mul  ra, a5, t0;                vmul.vv  v13, v2,  v27
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v2,  v2,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v5, v16, v29
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v5, v5, v14, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v6, v14, v28
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmerge.vvm  v6, v16, v6, v0
sub  a4, s6, tp;   sub  a5, s7, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, s6, t1;   mul  ra, s7, t1;                vmul.vv  v15, v4,  v27
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v4,  v4,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v7, v24, v29
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v7, v7, v22, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v8, v22, v28
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v8, v24, v8, v0
mul  a7, a2, t2;   mul  gp, a3, t2;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, a4, t2;   mul  ra, a5, t2;                vmul.vv  v21, v6,  v27
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v6,  v6,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v23, v8,  v27
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vv v8,  v8,  v26
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vx v13, v13, t4
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmulh.vx v15, v15, t4
mul  a7, s2, t3;   mul  gp, s3, t3;                vmulh.vx v21, v21, t4
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v23, v23, t4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v2,  v2,  v13
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v4,  v4,  v15
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v6,  v6,  v21
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v8,  v8,  v23
sub  s6, s4, tp;   sub  s7, s5, ra;                vadd.vv  v13, v1,  v2
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vsub.vv  v15, v1,  v2
add  s5, s5, ra;   add  s4, s4, tp;                lw t6, 4*16(sp)
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
mul  tp, a4, ra;   mul  ra, a5, ra;                addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v21, v3,  v4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v23, v3,  v4
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v1, v11, v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v2, v9, v27
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vmerge.vvm  v1, v1, v9, v0
add  s8, s8, a7;   add  s9, s9, gp;                vmerge.vvm  v2, v11, v2, v0
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vadd.vv  v14, v5,  v6
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vsub.vv  v16, v5,  v6
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vrgather.vv v3, v19, v27
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v4, v17, v27
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v3, v3, v17, v0
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v4, v19, v4, v0
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v22, v7,  v8
sub  s1, s0, a7;   sub  s3, s2, gp;                vsub.vv  v24, v7,  v8
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vrgather.vv v5, v12, v27
mul  a7, s9, a7;   mul  gp, s11, gp;               vrgather.vv v6, v10, v27
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmerge.vvm  v5, v5, v10, v0
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmerge.vvm  v6, v12, v6, v0
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v7, v20, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v8, v18, v27
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v7, v7, v18, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v8, v20, v8, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vrgather.vv v9, v15, v27
add  s8, s8, a7;   add  s10, s10, gp;              vrgather.vv v11, v13, v27
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmerge.vvm  v9, v9, v13, v0
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmerge.vvm  v11, v15, v11, v0
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vrgather.vv v17, v23, v27
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vrgather.vv v19, v21, v27
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmerge.vvm  v17, v17, v21, v0
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmerge.vvm  v19, v23, v19, v0
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vrgather.vv v10, v16, v27
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vrgather.vv v12, v14, v27
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmerge.vvm  v10, v10, v14, v0
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vmerge.vvm  v12, v16, v12, v0
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vrgather.vv v18, v24, v27
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vrgather.vv v20, v22, v27
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmerge.vvm  v18, v18, v22, v0
mul  tp, s10, t0;  mul  ra, s11, t0;               vmerge.vvm  v20, v24, v20, v0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lw   t5, 4*15(sp);   addi t5, t5, (0*128)*2
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v1,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v2,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v3,  (t5);  addi t5, t5, 16
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v4,  (t5);  addi t5, t5, 16
mul  a7, a2, t0;   mul  gp, a3, t0;                vse16.v  v5,  (t5);  addi t5, t5, 16
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vse16.v  v6,  (t5);  addi t5, t5, 16
mul  tp, a4, t0;   mul  ra, a5, t0;                vse16.v  v7,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v8,  (t5);  addi t5, t5, -16*7-(0*128)*2+(64+0*128)*2
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v9,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v11, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v17, (t5);  addi t5, t5, 16
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vse16.v  v19, (t5);  addi t5, t5, 16
sub  a4, s6, tp;   sub  a5, s7, ra;                vse16.v  v10, (t5);  addi t5, t5, 16
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vse16.v  v12, (t5);  addi t5, t5, 16
mul  tp, s6, t1;   mul  ra, s7, t1;                vse16.v  v18, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v20, (t5)
mulh a7, a7, a6;   mulh gp, gp, a6;                lw   t5, 4*15(sp);  addi t5, t5, (64+1*128)*2
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v9,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v10, (t5);  addi t5, t5, 16
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v v11, (t5);  addi t5, t5, 16
mul  a7, a2, t2;   mul  gp, a3, t2;                vle16.v v12, (t5);  addi t5, t5, 16
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v v13, (t5);  addi t5, t5, 16
mul  tp, a4, t2;   mul  ra, a5, t2;                vle16.v v14, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v15, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v16, (t5);  addi t5, t5, -16*7-(64+1*128)*2+(1*128)*2
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v1,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v2,  (t5);  addi t5, t5, 16
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v v3,  (t5);  addi t5, t5, 16
sub  a4, s10, tp;  sub  a5, s11, ra;               vle16.v v4,  (t5);  addi t5, t5, 16
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vle16.v v5,  (t5);  addi t5, t5, 16
mul  a7, s2, t3;   mul  gp, s3, t3;                vle16.v v6,  (t5);  addi t5, t5, 16
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v7,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v v8,  (t5)
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 lw t6, 4*16(sp)
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                lh t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
sub  s6, s4, tp;   sub  s7, s5, ra;                vmul.vx v17, v9,  t5
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmul.vx v18, v10, t5
add  s5, s5, ra;   add  s4, s4, tp;                vmul.vx v19, v11, t5
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmul.vx v20, v12, t5
mul  tp, a4, ra;   mul  ra, a5, ra;                vmul.vx v21, v13, t5
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v22, v14, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v23, v15, t5
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v24, v16, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v9,  v9,  t6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v10, v10, t6
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v11, v11, t6
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmulh.vx v12, v12, t6
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmulh.vx v13, v13, t6
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmulh.vx v14, v14, t6
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v15, v15, t6
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v16, v16, t6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v21, v21, t4
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v22, v22, t4
sub  s1, s0, a7;   sub  s3, s2, gp;                vmulh.vx v23, v23, t4
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmulh.vx v24, v24, t4
mul  a7, s9, a7;   mul  gp, s11, gp;               vsub.vv  v13, v13, v21
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v14, v14, v22
add  s6, s6, ra;   lw   ra, 14*4(a1);              vsub.vv  v15, v15, v23
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v16, v16, v24
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v17, v17, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v21, v5, v13
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v18, v18, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vsub.vv  v22, v6, v14
add  s8, s8, a7;   add  s10, s10, gp;              vmulh.vx v19, v19, t4
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vsub.vv  v23, v7, v15
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmulh.vx v20, v20, t4
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vsub.vv  v24, v8, v16
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vsub.vv  v9,  v9,  v17
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vsub.vv  v10, v10, v18
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vsub.vv  v11, v11, v19
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vsub.vv  v12, v12, v20
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vsub.vv  v17, v1, v9
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vsub.vv  v18, v2, v10
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vsub.vv  v19, v3, v11
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vsub.vv  v20, v4, v12
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vadd.vv  v13, v5, v13
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vadd.vv  v14, v6, v14
mul  tp, s10, t0;  mul  ra, s11, t0;               vadd.vv  v15, v7, v15
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v16, v8, v16
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v9, v1, v9
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v10, v2, v10
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v11, v3, v11
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v12, v4, v12
mul  a7, a2, t0;   mul  gp, a3, t0;                lw t6, 4*16(sp)
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
mul  tp, a4, t0;   mul  ra, a5, t0;                vmul.vx v1, v13, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v2, v14, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v3, v15, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v4, v16, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmul.vx v5, v21, t5
sub  a4, s6, tp;   sub  a5, s7, ra;                vmul.vx v6, v22, t5
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmul.vx v7, v23, t5
mul  tp, s6, t1;   mul  ra, s7, t1;                vmul.vx v8, v24, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v13, v13, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v14, v14, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v15, v15, t5
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v16, v16, t5
mul  a7, a2, t2;   mul  gp, a3, t2;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v21, v21, t5
mul  tp, a4, t2;   mul  ra, a5, t2;                vmulh.vx v22, v22, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v23, v23, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v24, v24, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v1, v1, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v2, v2, t4
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v3, v3, t4
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vx v4, v4, t4
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vsub.vv  v13, v13, v1
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v14, v14, v2
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v15, v15, v3
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v16, v16, v4
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v5, v5, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v1, v9,  v13
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vx v6, v6, t4
sub  s6, s4, tp;   sub  s7, s5, ra;                vadd.vv  v2, v10, v14
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmulh.vx v7, v7, t4
add  s5, s5, ra;   add  s4, s4, tp;                vadd.vv  v3, v11, v15
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vx v8, v8, t4
mul  tp, a4, ra;   mul  ra, a5, ra;                vadd.vv  v4, v12, v16
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v21, v21, v5
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v22, v22, v6
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v23, v23, v7
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v24, v24, v8
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vadd.vv  v5, v17, v21
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v6, v18, v22
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vadd.vv  v7, v19, v23
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vadd.vv  v8, v20, v24
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vsub.vv  v9, v9,  v13
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v10, v10,v14
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v11,v11, v15
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v12,v12, v16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v13,v17, v21
sub  s1, s0, a7;   sub  s3, s2, gp;                vsub.vv  v14,v18, v22
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v15,v19, v23
mul  a7, s9, a7;   mul  gp, s11, gp;               vsub.vv  v16,v20, v24
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmul.vx v17, v3,  t5
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v18, v4,  t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v19, v11, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v20, v12, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
add  s8, s8, a7;   add  s10, s10, gp;              vmul.vx v21, v7,  t5
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmul.vx v22, v8,  t5
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmul.vx v23, v15, t5
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmul.vx v24, v16, t5
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmulh.vx v3,  v3,  t5
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmulh.vx v4,  v4,  t5
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vx v11, v11, t5
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vmulh.vx v12, v12, t5
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vmulh.vx v7,  v7,  t5
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v8,  v8,  t5
mul  tp, s10, t0;  mul  ra, s11, t0;               lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v15, v15, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v16, v16, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v17, v17, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v18, v18, t4
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v19, v19, t4
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v20, v20, t4
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v3,  v3,  v17
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v4,  v4,  v18
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11, v11, v19
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v12, v12, v20
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v21, v21, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v17, v1,  v3
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v22, v22, t4
sub  a4, s6, tp;   sub  a5, s7, ra;                vadd.vv  v18, v2,  v4
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v23, v23, t4
mul  tp, s6, t1;   mul  ra, s7, t1;                vadd.vv  v19, v9,  v11
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v24, v24, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v20, v10, v12
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v7,  v7,  v21
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v8,  v8,  v22
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v15, v15, v23
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v16, v16, v24
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v21, v5,  v7
mul  tp, a4, t2;   mul  ra, a5, t2;                vadd.vv  v22, v6,  v8
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v23, v13, v15
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v24, v14, v16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v1,  v1,  v3
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v2,  v2,  v4
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v3,  v9,  v11
sub  a4, s10, tp;  sub  a5, s11, ra;               vsub.vv  v4,  v10, v12
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vsub.vv  v5,  v5,  v7
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v6,  v6,  v8
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v7,  v13, v15
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v8,  v14, v16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v9,  v18,  t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vx v18, v18, t5
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
add  s5, s5, ra;   add  s4, s4, tp;                vmul.vx v10, v2,   t5
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v2,  v2,  t5
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v11, v20,  t5
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v20, v20, t5
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
add  s8, s8, a7;   add  s9, s9, gp;                vmul.vx v12, v4,   t5
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmulh.vx v4,  v4,  t5
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v13, v22,  t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v22, v22, t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
sub  s1, s0, a7;   sub  s3, s2, gp;                vmul.vx v14, v6,   t5
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
mul  a7, s9, a7;   mul  gp, s11, gp;               vmulh.vx v6,  v6,  t5
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmul.vx v15, v24,  t5
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v24, v24, t5
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v16, v8,   t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
add  s8, s8, a7;   add  s10, s10, gp;              vmulh.vx v8,  v8,  t5
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v9,  v9,  t4
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmulh.vx v10, v10, t4
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v11, v11, t4
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmulh.vx v12, v12, t4
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vsub.vv  v18, v18, v9
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vsub.vv  v2,  v2,  v10
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vsub.vv  v20, v20, v11
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vsub.vv  v4,  v4,  v12
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vx v13, v13, t4
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vadd.vv  v9,  v17, v18
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmulh.vx v14, v14, t4
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vadd.vv  v10, v1,  v2
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v15, v15, t4
mul  tp, s10, t0;  mul  ra, s11, t0;               vadd.vv  v11, v19, v20
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v16, v16, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v12, v3, v4
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v22, v22, v13
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v6,  v6,  v14
mul  a7, a2, t0;   mul  gp, a3, t0;                vsub.vv  v24, v24, v15
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v8,  v8,  v16
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v17, v17, v18
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v18, v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v19, v19, v20
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v20, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v13, v21,  v22
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vadd.vv  v14, v5,  v6
sub  a4, s6, tp;   sub  a5, s7, ra;                vadd.vv  v15, v23, v24
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vrgather.vv v2, v9, v31
mul  tp, s6, t1;   mul  ra, s7, t1;                vrgather.vv v1, v17, v30
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm v2, v17, v2, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm v1, v1, v9, v0
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v16, v7, v8
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v4, v10, v31
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v3, v18, v30
mul  a7, a2, t2;   mul  gp, a3, t2;                vmerge.vvm v4, v18, v4, v0
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm v3, v3, v10, v0
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v21, v21, v22
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v22, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v23, v23, v24
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v24, v7,  v8
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L5 + 1*_ZETAS_EXP_1TO6_P1_L5)*2
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v v27, (t6)
sub  a4, s10, tp;  sub  a5, s11, ra;               addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmul.vv  v9,  v2,  v27
mul  a7, s2, t3;   mul  gp, s3, t3;                vmulh.vv v2,  v2,  v26
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v6, v11, v31
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v5, v19, v30
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v6, v19, v6, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm v5, v5, v11, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vrgather.vv v8, v12, v31
sub  s6, s4, tp;   sub  s7, s5, ra;                vrgather.vv v7, v20, v30
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmerge.vvm v8, v20, v8, v0
add  s5, s5, ra;   add  s4, s4, tp;                vmerge.vvm v7, v7, v12, v0
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, a4, ra;   mul  ra, a5, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v17, v4,  v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v4,  v4,  v26
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v9,  v9,  t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v17, v17, t4
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s8, s8, a7;   add  s9, s9, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmul.vv  v10, v6,  v27
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmulh.vv v6,  v6,  v26
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vsub.vv  v2,  v2,  v9
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v10, v10, t4
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v18, v8,  v27
sub  s1, s0, a7;   sub  s3, s2, gp;                vmulh.vv v8,  v8,  v26
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmulh.vx v18, v18, t4
mul  a7, s9, a7;   mul  gp, s11, gp;               vsub.vv  v4,  v4,  v17
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v6,  v6,  v10
add  s6, s6, ra;   lw   ra, 14*4(a1);              vsub.vv  v8,  v8,  v18
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v9,  v1,  v2
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11, v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v17, v3,  v4
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v19, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vadd.vv  v10, v5,  v6
add  s8, s8, a7;   add  s10, s10, gp;              vsub.vv  v12, v5,  v6
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vrgather.vv v2, v13, v31
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vrgather.vv v1, v21, v30
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmerge.vvm v2, v21, v2, v0
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmerge.vvm v1, v1, v13, v0
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vrgather.vv v4, v14, v31
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vrgather.vv v3, v22, v30
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmerge.vvm v4, v22, v4, v0
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vmerge.vvm v3, v3, v14, v0
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vadd.vv  v18, v7,  v8
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vsub.vv  v20, v7,  v8
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vrgather.vv v6, v15, v31
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vrgather.vv v5, v23, v30
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmerge.vvm v6, v23, v6, v0
mul  tp, s10, t0;  mul  ra, s11, t0;               vmerge.vvm v5, v5, v15, v0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v8, v16, v31
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v7, v24, v30
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v8, v24, v8, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm v7, v7, v16, v0
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  a7, a2, t0;   mul  gp, a3, t0;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vv  v13, v2,  v27
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vv v2,  v2,  v26
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v13, v13, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v21, v4,  v27
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vv v4,  v4,  v26
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v21, v21, t4
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s6, t1;   mul  ra, s7, t1;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v14, v6,  v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v6,  v6,  v26
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v14, v14, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  a7, a2, t2;   mul  gp, a3, t2;                vmul.vv  v22, v8,  v27
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vv v8,  v8,  v26
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v2,  v2, v13
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v4,  v4, v21
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v22, v22, t4
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v6,  v6, v14
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v8,  v8, v22
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                lw t6, 4*16(sp)
sub  a4, s10, tp;  sub  a5, s11, ra;               addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vadd.vv  v13, v1,  v2
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v15, v1,  v2
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v21, v3,  v4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v23, v3,  v4
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v14, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v16, v5,  v6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vrgather.vv v1, v11, v29
sub  s6, s4, tp;   sub  s7, s5, ra;                vmerge.vvm  v1, v1, v9, v0
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vrgather.vv v2, v9, v28
add  s5, s5, ra;   add  s4, s4, tp;                vmerge.vvm  v2, v11, v2, v0
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vadd.vv  v22, v7,  v8
mul  tp, a4, ra;   mul  ra, a5, ra;                vsub.vv  v24, v7,  v8
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v3, v19, v29
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v3, v3, v17, v0
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v4, v17, v28
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v4, v19, v4, v0
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L6+ 1*_ZETAS_EXP_1TO6_P1_L6)*2
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v v27, (t6)
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               addi t6, t6, 8*2;     vle16.v v26, (t6)
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmul.vv  v9,  v2,  v27
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmulh.vv v2,  v2,  v26
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v5, v12, v29
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v5, v5, v10, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v6, v10, v28
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v6, v12, v6, v0
sub  s1, s0, a7;   sub  s3, s2, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  a7, s9, a7;   mul  gp, s11, gp;               vmul.vv  v11, v4,  v27
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmulh.vv v4,  v4,  v26
add  s6, s6, ra;   lw   ra, 14*4(a1);              vrgather.vv v7, v20, v29
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v7, v7, v18, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v8, v18, v28
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v8, v20, v8, v0
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s8, s8, a7;   add  s10, s10, gp;              vmul.vv  v17, v6,  v27
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vv v6,  v6,  v26
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         addi t6, t6, 8*2;     vle16.v v27, (t6)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         addi t6, t6, 8*2;     vle16.v v26, (t6)
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmul.vv  v19, v8,  v27
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vv v8,  v8,  v26
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmulh.vx v9,  v9,  t4
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmulh.vx v11, v11, t4
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vmulh.vx v17, v17, t4
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vx v19, v19, t4
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vsub.vv  v2,  v2,  v9
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vsub.vv  v4,  v4,  v11
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vsub.vv  v6,  v6,  v17
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v8,  v8,  v19
mul  tp, s10, t0;  mul  ra, s11, t0;               vadd.vv  v9,  v1,  v2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11, v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v17, v3,  v4
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v19, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v1, v15, v29
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v1, v1, v13, v0
mul  a7, a2, t0;   mul  gp, a3, t0;                vrgather.vv v2, v13, v28
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm  v2, v15, v2, v0
mul  tp, a4, t0;   mul  ra, a5, t0;                vadd.vv  v10, v5,  v6
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v12, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v18, v7,  v8
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v20, v7,  v8
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v3, v23, v29
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmerge.vvm  v3, v3, v21, v0
sub  a4, s6, tp;   sub  a5, s7, ra;                vrgather.vv v4, v21, v28
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmerge.vvm  v4, v23, v4, v0
mul  tp, s6, t1;   mul  ra, s7, t1;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v13, v2,  v27
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v2,  v2,  v26
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v5, v16, v29
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v5, v5, v14, v0
mul  a7, a2, t2;   mul  gp, a3, t2;                vrgather.vv v6, v14, v28
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm  v6, v16, v6, v0
mul  tp, a4, t2;   mul  ra, a5, t2;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v15, v4,  v27
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v4,  v4,  v26
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v7, v24, v29
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmerge.vvm  v7, v7, v22, v0
sub  a4, s10, tp;  sub  a5, s11, ra;               vrgather.vv v8, v22, v28
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmerge.vvm  v8, v24, v8, v0
mul  a7, s2, t3;   mul  gp, s3, t3;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v21, v6,  v27
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v6,  v6,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s6, s4, tp;   sub  s7, s5, ra;                vmul.vv  v23, v8,  v27
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmulh.vv v8,  v8,  v26
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v13, v13, t4
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vx v15, v15, t4
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v21, v21, t4
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v23, v23, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v2,  v2,  v13
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v4,  v4,  v15
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v21
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v8,  v8,  v23
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v13, v1,  v2
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vsub.vv  v15, v1,  v2
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              lw t6, 4*16(sp)
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
srai a7, a7, 16;   srai gp, gp, 16;                addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v21, v3,  v4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v23, v3,  v4
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v1, v11, v27
sub  s1, s0, a7;   sub  s3, s2, gp;                vrgather.vv v2, v9, v27
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmerge.vvm  v1, v1, v9, v0
mul  a7, s9, a7;   mul  gp, s11, gp;               vmerge.vvm  v2, v11, v2, v0
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vadd.vv  v14, v5,  v6
add  s6, s6, ra;   lw   ra, 14*4(a1);              vsub.vv  v16, v5,  v6
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v3, v19, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v4, v17, v27
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v3, v3, v17, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v4, v19, v4, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vadd.vv  v22, v7,  v8
add  s8, s8, a7;   add  s10, s10, gp;              vsub.vv  v24, v7,  v8
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vrgather.vv v5, v12, v27
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vrgather.vv v6, v10, v27
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmerge.vvm  v5, v5, v10, v0
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmerge.vvm  v6, v12, v6, v0
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vrgather.vv v7, v20, v27
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vrgather.vv v8, v18, v27
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmerge.vvm  v7, v7, v18, v0
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vmerge.vvm  v8, v20, v8, v0
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vrgather.vv v9, v15, v27
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vrgather.vv v11, v13, v27
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmerge.vvm  v9, v9, v13, v0
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vmerge.vvm  v11, v15, v11, v0
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vrgather.vv v17, v23, v27
mul  tp, s10, t0;  mul  ra, s11, t0;               vrgather.vv v19, v21, v27
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v17, v17, v21, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v19, v23, v19, v0
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v10, v16, v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v12, v14, v27
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v10, v10, v14, v0
mul  a7, a2, t0;   mul  gp, a3, t0;                vmerge.vvm  v12, v16, v12, v0
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v18, v24, v27
mul  tp, a4, t0;   mul  ra, a5, t0;                vrgather.vv v20, v22, v27
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v18, v18, v22, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v20, v24, v20, v0
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lw   t5, 4*15(sp);   addi t5, t5, (1*128)*2
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v1,  (t5);  addi t5, t5, 16
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vse16.v  v2,  (t5);  addi t5, t5, 16
sub  a4, s6, tp;   sub  a5, s7, ra;                vse16.v  v3,  (t5);  addi t5, t5, 16
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vse16.v  v4,  (t5);  addi t5, t5, 16
mul  tp, s6, t1;   mul  ra, s7, t1;                vse16.v  v5,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v6,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v7,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v8,  (t5);  addi t5, t5, -16*7-(1*128)*2+(64+1*128)*2
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v9,  (t5);  addi t5, t5, 16
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v11, (t5);  addi t5, t5, 16
mul  a7, a2, t2;   mul  gp, a3, t2;                vse16.v  v17, (t5);  addi t5, t5, 16
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vse16.v  v19, (t5);  addi t5, t5, 16
mul  tp, a4, t2;   mul  ra, a5, t2;                vse16.v  v10, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v12, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v18, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v20, (t5)
mulh tp, tp, a6;   mulh ra, ra, a6;                lw   t5, 4*15(sp)
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                addi t5, t5, (64*0+128)*2   
sub  a4, s10, tp;  sub  a5, s11, ra;               vle16.v v8,  (t5);  addi t5, t5, 16
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vle16.v v9,  (t5);  addi t5, t5, 16
mul  a7, s2, t3;   mul  gp, s3, t3;                vle16.v v10, (t5);  addi t5, t5, 16
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v11, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v v12, (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v13, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v14, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vle16.v v15, (t5);  addi t5, t5, -((64*0+128)*2+16*7)
sub  s6, s4, tp;   sub  s7, s5, ra;                vle16.v v16, (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vle16.v v17, (t5);  addi t5, t5, 16
add  s5, s5, ra;   add  s4, s4, tp;                vle16.v v18, (t5);  addi t5, t5, 16
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vle16.v v19, (t5);  addi t5, t5, 16
mul  tp, a4, ra;   mul  ra, a5, ra;                vle16.v v20, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v v21, (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v22, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v23, (t5);  addi t5, t5, -16*7
mulh tp, tp, a6;   mulh ra, ra, a6;                sw t5, 4*15(sp)
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                lw t6, 4*16(sp)
add  s8, s8, a7;   add  s9, s9, gp;                lh t5, (_ZETAS_EXP+0)*2(t6)
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               lh t6, (_ZETAS_EXP+1)*2(t6)
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmul.vx v0, v8, t5
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                vmul.vx v1, v9, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v2, v10, t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v3, v11, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v4, v12, t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v5, v13, t5
sub  s1, s0, a7;   sub  s3, s2, gp;                vmul.vx v6, v14, t5
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmul.vx v7, v15, t5
mul  a7, s9, a7;   mul  gp, s11, gp;               vmulh.vx v8,  v8, t6
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmulh.vx v9,  v9, t6
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmulh.vx v10, v10, t6
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v11, v11, t6
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v12, v12, t6
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v13, v13, t6
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v14, v14, t6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v15, v15, t6
add  s8, s8, a7;   add  s10, s10, gp;              vmulh.vx v0, v0, t4
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v1, v1, t4
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmulh.vx v2, v2, t4
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v3, v3, t4
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmulh.vx v4, v4, t4
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vx v5, v5, t4
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmulh.vx v6, v6, t4
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a0, a0, -2;                                   vmulh.vx v7, v7, t4
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vsub.vv  v8,  v8,  v0
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vsub.vv  v9,  v9,  v1
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vsub.vv  v10, v10, v2
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vsub.vv  v11, v11, v3
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vsub.vv  v12, v12, v4
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0)
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v13, v13, v5
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v14, v14, v6
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v15, v15, v7
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v0, v16, v8
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v1, v17, v9
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v2, v18, v10
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v3, v19, v11
mul  a7, a2, t0;   mul  gp, a3, t0;                vadd.vv  v4, v20, v12
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v5, v21, v13
mul  tp, a4, t0;   mul  ra, a5, t0;                vadd.vv  v6, v22, v14
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v7, v23, v15
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v8, v16, v8
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v9, v17, v9
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v10, v18, v10
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v11, v19, v11
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v12, v20, v12
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v13, v21, v13
mul  tp, s6, t1;   mul  ra, s7, t1;                vsub.vv  v14, v22, v14
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v15, v23, v15
mulh a7, a7, a6;   mulh gp, gp, a6;                lw t5, 4*15(sp)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v0,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v1,  (t5);  addi t5, t5, 16
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v2,  (t5);  addi t5, t5, 16
mul  a7, a2, t2;   mul  gp, a3, t2;                vse16.v  v3,  (t5);  addi t5, t5, 16
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vse16.v  v4,  (t5);  addi t5, t5, 16
mul  tp, a4, t2;   mul  ra, a5, t2;                vse16.v  v5,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v6,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v7,  (t5);  addi t5, t5, (64*0+128)*2-16*7
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v8,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v9,  (t5);  addi t5, t5, 16
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vse16.v  v10, (t5);  addi t5, t5, 16
sub  a4, s10, tp;  sub  a5, s11, ra;               vse16.v  v11, (t5);  addi t5, t5, 16
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vse16.v  v12, (t5);  addi t5, t5, 16
mul  a7, s2, t3;   mul  gp, s3, t3;                vse16.v  v13, (t5);  addi t5, t5, 16
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v14, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v15, (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v  v24, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v  v25, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vle16.v  v26, (t5);  addi t5, t5, 16
sub  s6, s4, tp;   sub  s7, s5, ra;                vle16.v  v27, (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vle16.v  v28, (t5);  addi t5, t5, 16
add  s5, s5, ra;   add  s4, s4, tp;                vle16.v  v29, (t5);  addi t5, t5, 16
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vle16.v  v30, (t5);  addi t5, t5, 16
mul  tp, a4, ra;   mul  ra, a5, ra;                vle16.v  v31, (t5);  addi t5, t5, -(128*2)-16*7
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v  v16, (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v  v17, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v  v18, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v  v19, (t5);  addi t5, t5, 16
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vle16.v  v20, (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v  v21, (t5);  addi t5, t5, 16
add  a2, a2, tp;   add  a3, a3, ra
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vle16.v  v22, (t5);  addi t5, t5, 16
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vle16.v  v23, (t5);  addi t5, t5, -16*7
mul  a7, s1, a7;   mul  gp, s3, gp
mul  tp, s5, tp;   mul  ra, s7, ra;                sw t5, 4*15(sp)
srai a7, a7, 16;   srai gp, gp, 16;                lw t6, 4*16(sp)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, (_ZETAS_EXP+0)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                lh t6, (_ZETAS_EXP+1)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v0, v24, t5
sub  s1, s0, a7;   sub  s3, s2, gp;                vmul.vx v1, v25, t5
add  s0, s0, a7;   lw   a7, 11*4(a1)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmul.vx v2, v26, t5
mul  a7, s9, a7;   mul  gp, s11, gp;               vmul.vx v3, v27, t5
sub  s5, s4, tp;   sub  s7, s6, ra
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmul.vx v4, v28, t5
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmul.vx v5, v29, t5
mul  tp, a3, tp;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v6, v30, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v7, v31, t5
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v24, v24, t6
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v25, v25, t6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v26, v26, t6
add  s8, s8, a7;   add  s10, s10, gp;              vmulh.vx v27, v27, t6
sub  a3, a2, tp;   sub  a5, a4, ra
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v28, v28, t6
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmulh.vx v29, v29, t6
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0)
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v30, v30, t6
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmulh.vx v31, v31, t6
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vx v0, v0, t4
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmulh.vx v1, v1, t4
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0)
addi a1, a1, 15*4;                                 vmulh.vx v2, v2, t4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vmulh.vx v3, v3, t4
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vmulh.vx v4, v4, t4
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vmulh.vx v5, v5, t4
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmulh.vx v6, v6, t4
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmulh.vx v7, v7, t4
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    vsub.vv  v24, v24, v0
lw t1, 1*4(a1);                                    vsub.vv  v25, v25, v1
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    vsub.vv  v26, v26, v2
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v27, v27, v3
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v28, v28, v4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v29, v29, v5
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v30, v30, v6
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v31, v31, v7
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                vadd.vv  v0, v16, v24
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v1, v17, v25
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               vadd.vv  v2, v18, v26
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v3, v19, v27
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v4, v20, v28
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v5, v21, v29
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v6, v22, v30
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v7, v23, v31
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v24, v16, v24
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v25, v17, v25
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                vsub.vv  v26, v18, v26
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v27, v19, v27
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v28, v20, v28
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v29, v21, v29
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v30, v22, v30
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v31, v23, v31
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                lw t5, 4*15(sp)
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v0,  (t5);  addi t5, t5, 16
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                vse16.v  v1,  (t5);  addi t5, t5, 16
add  s2, s2, tp;   add  s3, s3, ra;                vse16.v  v2,  (t5);  addi t5, t5, 16
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v3,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v4,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v5,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v6,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                vse16.v  v7,  (t5);  addi t5, t5, -16*7+128*2
add  s8, s8, a7;   add  s9, s9, gp;                vse16.v  v24, (t5);  addi t5, t5, 16
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              vse16.v  v25, (t5);  addi t5, t5, 16
lw   ra, 4*4(a1);                                  vse16.v  v26, (t5);  addi t5, t5, 16
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                vse16.v  v27, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v28, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v29, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v30, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v31, (t5);  addi t5, t5, -16*7-192*2
sub  s2, s0, a7;   sub  s3, s1, gp;                sw t5, 4*15(sp)
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                lw t6, 4*16(sp)
lw   gp, 5*4(a1);                                  addi t5, t6, _MASK_45674567*2;      vle16.v v31, (t5)
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  addi t5, t6, _MASK_01230123*2;      vle16.v v30, (t5)
mul  a7, s10, gp;  mul  gp, s11, gp;               addi t5, t6, _MASK_00010045*2;      vle16.v v29, (t5)
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                addi t5, t6, _MASK_23006700*2;      vle16.v v28, (t5)
srai tp, tp, 16;   srai ra, ra, 16;                lw   t5, 4*15(sp);  addi t5, t5, (64+0*128)*2
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v9,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v10, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               vle16.v v11, (t5);  addi t5, t5, 16
sub  a4, a2, tp;   sub  a5, a3, ra;                vle16.v v12, (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                vle16.v v13, (t5);  addi t5, t5, 16
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vle16.v v14, (t5);  addi t5, t5, 16
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vle16.v v15, (t5);  addi t5, t5, 16
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vle16.v v16, (t5);  addi t5, t5, -16*7-(64+0*128)*2+(0*128)*2
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vle16.v v1,  (t5);  addi t5, t5, 16
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vle16.v v2,  (t5);  addi t5, t5, 16
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32;                                   vle16.v v3,  (t5);  addi t5, t5, 16
addi a1, a1, 7*4;                                  vle16.v v4,  (t5);  addi t5, t5, 16
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vle16.v v5,  (t5);  addi t5, t5, 16
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vle16.v v6,  (t5);  addi t5, t5, 16
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vle16.v v7,  (t5);  addi t5, t5, 16
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vle16.v v8,  (t5)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          lw t6, 4*16(sp)
lw t0, 0*4(a1);                                    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
lw t1, 1*4(a1)
lw t2, 2*4(a1);                                    lh t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
lw t3, 3*4(a1);                                    vmul.vx v17, v9,  t5
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0;               vmul.vx v18, v10, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v19, v11, t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v20, v12, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v21, v13, t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v22, v14, t5
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vx v23, v15, t5
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0;                vmul.vx v24, v16, t5
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vx v9,  v9,  t6
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vx v10, v10, t6
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v11, v11, t6
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v12, v12, t6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v13, v13, t6
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v14, v14, t6
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v15, v15, t6
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v16, v16, t6
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v21, v21, t4
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v22, v22, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v23, v23, t4
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v24, v24, t4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v13, v13, v21
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v14, v14, v22
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v15, v15, v23
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v16, v16, v24
sub  s6, s2, tp;   sub  s7, s3, ra;                vmulh.vx v17, v17, t4
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v21, v5, v13
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v18, v18, t4
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v22, v6, v14
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v19, v19, t4
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v23, v7, v15
sub  a2, s8, a7;   sub  a3, s9, gp;                vmulh.vx v20, v20, t4
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra;               vsub.vv  v24, v8, v16
add  s10, s10, tp; add  s11, s11, ra;              vsub.vv  v9,  v9,  v17
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v10, v10, v18
mul  tp, s6, ra;   mul  ra, s7, ra;                vsub.vv  v11, v11, v19
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v12, v12, v20
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v17, v1, v9
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v18, v2, v10
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v19, v3, v11
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra;                vsub.vv  v20, v4, v12
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v13, v5, v13
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp;                vadd.vv  v14, v6, v14
lw   ra, 6*4(a1);                                  vadd.vv  v15, v7, v15
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra;                vadd.vv  v16, v8, v16
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v9, v1, v9
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v10, v2, v10
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v11, v3, v11
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v12, v4, v12
sub  s10, s8, a7;  sub  s11, s9, gp;               lw t6, 4*16(sp)
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
add  a2, a2, tp;   add  a3, a3, ra;                vmul.vx v1, v13, t5
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmul.vx v2, v14, t5
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vmul.vx v3, v15, t5
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vmul.vx v4, v16, t5
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmul.vx v5, v21, t5
addi a0, a0, 32;                                   vmul.vx v6, v22, t5
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vmul.vx v7, v23, t5
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmul.vx v8, v24, t5
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vmulh.vx v13, v13, t5
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmulh.vx v14, v14, t5
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vmulh.vx v15, v15, t5
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    vmulh.vx v16, v16, t5
lw t2, 2*4(a1);                                    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v21, v21, t5
mul  tp, s10, t0;  mul  ra, s11, t0;               vmulh.vx v22, v22, t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v23, v23, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v24, v24, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v1, v1, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v2, v2, t4
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v3, v3, t4
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v4, v4, t4
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v13, v13, v1
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v14, v14, v2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v15, v15, v3
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v16, v16, v4
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v5, v5, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v1, v9,  v13
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v6, v6, t4
sub  a4, s6, tp;   sub  a5, s7, ra;                vadd.vv  v2, v10, v14
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v7, v7, t4
mul  tp, s6, t1;   mul  ra, s7, t1;                vadd.vv  v3, v11, v15
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v8, v8, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v4, v12, v16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v21, v21, v5
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v22, v22, v6
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v23, v23, v7
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v24, v24, v8
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v5, v17, v21
mul  tp, a4, t2;   mul  ra, a5, t2;                vadd.vv  v6, v18, v22
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v7, v19, v23
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v8, v20, v24
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v9, v9,  v13
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v10, v10,v14
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v11,v11, v15
sub  a4, s10, tp;  sub  a5, s11, ra;               vsub.vv  v12,v12, v16
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vsub.vv  v13,v17, v21
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v14,v18, v22
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v15,v19, v23
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v16,v20, v24
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v17, v3,  t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmul.vx v18, v4,  t5
sub  s6, s4, tp;   sub  s7, s5, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmul.vx v19, v11, t5
add  s5, s5, ra;   add  s4, s4, tp;                vmul.vx v20, v12, t5
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
mul  tp, a4, ra;   mul  ra, a5, ra;                vmul.vx v21, v7,  t5
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v22, v8,  t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v23, v15, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v24, v16, t5
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v3,  v3,  t5
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vmulh.vx v4,  v4,  t5
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vmulh.vx v11, v11, t5
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vmulh.vx v12, v12, t5
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmulh.vx v7,  v7,  t5
addi a0, a0, 32
addi a1, a1, 7*4;                                  vmulh.vx v8,  v8,  t5
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vmulh.vx v15, v15, t5
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vmulh.vx v16, v16, t5
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmulh.vx v17, v17, t4
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmulh.vx v18, v18, t4
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    vmulh.vx v19, v19, t4
lw t1, 1*4(a1);                                    vmulh.vx v20, v20, t4
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    vsub.vv  v3,  v3,  v17
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v4,  v4,  v18
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v11, v11, v19
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v12, v12, v20
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v21, v21, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v17, v1,  v3
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                vmulh.vx v22, v22, t4
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v18, v2,  v4
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vx v23, v23, t4
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v19, v9,  v11
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v24, v24, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v20, v10, v12
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v7,  v7,  v21
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v8,  v8,  v22
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v15, v15, v23
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v16, v16, v24
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                vadd.vv  v21, v5,  v7
mul  a7, s4, t1;   mul  gp, s5, t1;                vadd.vv  v22, v6,  v8
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v23, v13, v15
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v24, v14, v16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v1,  v1,  v3
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v2,  v2,  v4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v3,  v9,  v11
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v4,  v10, v12
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                vsub.vv  v5,  v5,  v7
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v6,  v6,  v8
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v7,  v13, v15
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v8,  v14, v16
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v9,  v18,  t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v18, v18, t5
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
lw   ra, 4*4(a1);                                  vmul.vx v10, v2,   t5
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v2,  v2,  t5
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v11, v20,  t5
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vx v20, v20, t5
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
lw   gp, 5*4(a1);                                  vmul.vx v12, v4,   t5
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vx v4,  v4,  t5
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v13, v22,  t5
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v22, v22, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
sub  a4, a2, tp;   sub  a5, a3, ra;                vmul.vx v14, v6,   t5
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vmulh.vx v6,  v6,  t5
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vmul.vx v15, v24,  t5
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vmulh.vx v24, v24, t5
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32;                                   lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
addi a1, a1, 7*4;                                  vmul.vx v16, v8,   t5
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vmulh.vx v8,  v8,  t5
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vmulh.vx v9,  v9,  t4
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmulh.vx v10, v10, t4
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vmulh.vx v11, v11, t4
lw t0, 0*4(a1);                                    vmulh.vx v12, v12, t4
lw t1, 1*4(a1)
lw t2, 2*4(a1);                                    vsub.vv  v18, v18, v9
lw t3, 3*4(a1);                                    vsub.vv  v2,  v2,  v10
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v20, v20, v11
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v4,  v4,  v12
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v13, v13, t4
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v9,  v17, v18
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v14, v14, t4
sub  s8, s0, a7;   sub  s9, s1, gp;                vadd.vv  v10, v1,  v2
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v15, v15, t4
sub  s10, s2, tp;  sub  s11, s3, ra;               vadd.vv  v11, v19, v20
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vx v16, v16, t4
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v12, v3, v4
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v22, v22, v13
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v14
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v24, v24, v15
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v8,  v8,  v16
add  s6, s6, tp;   add  s7, s7, ra;                vsub.vv  v17, v17, v18
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1;                vsub.vv  v18, v1,  v2
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v19, v19, v20
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v20, v3,  v4
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v13, v21,  v22
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v14, v5,  v6
sub  s4, s0, a7;   sub  s5, s1, gp;                vadd.vv  v15, v23, v24
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2;                vrgather.vv v2, v9, v31
sub  s6, s2, tp;   sub  s7, s3, ra;                vrgather.vv v1, v17, v30
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2;                vmerge.vvm v2, v17, v2, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm v1, v1, v9, v0
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v16, v7, v8
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v4, v10, v31
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v3, v18, v30
sub  a2, s8, a7;   sub  a3, s9, gp;                vmerge.vvm v4, v18, v4, v0
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra;               vmerge.vvm v3, v3, v10, v0
add  s10, s10, tp; add  s11, s11, ra;              vsub.vv  v21, v21, v22
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v22, v5,  v6
mul  tp, s6, ra;   mul  ra, s7, ra;                vsub.vv  v23, v23, v24
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v24, v7,  v8
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L5 + 0*_ZETAS_EXP_1TO6_P1_L5)*2
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra;                vmul.vv  v9,  v2,  v27
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vv v2,  v2,  v26
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp;                vrgather.vv v6, v11, v31
lw   ra, 6*4(a1);                                  vrgather.vv v5, v19, v30
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra;                vmerge.vvm v6, v19, v6, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm v5, v5, v11, v0
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v8, v12, v31
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v7, v20, v30
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm v8, v20, v8, v0
sub  s10, s8, a7;  sub  s11, s9, gp;               vmerge.vvm v7, v7, v12, v0
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  a2, a2, tp;   add  a3, a3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmul.vv  v17, v4,  v27
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vmulh.vv v4,  v4,  v26
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vmulh.vx v9,  v9,  t4
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmulh.vx v17, v17, t4
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a0, a0, 32;                                   addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vmul.vv  v10, v6,  v27
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmulh.vv v6,  v6,  v26
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vsub.vv  v2,  v2,  v9
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vmulh.vx v10, v10, t4
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          addi t6, t6, 8*2;     vle16.v v27, (t6)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          addi t6, t6, 8*2;     vle16.v v26, (t6)
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    vmul.vv  v18, v8,  v27
lw t2, 2*4(a1);                                    vmulh.vv v8,  v8,  v26
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v18, v18, t4
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v4,  v4,  v17
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v6,  v6,  v10
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v8,  v8,  v18
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v9,  v1,  v2
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v11, v1,  v2
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v17, v3,  v4
mul  a7, a2, t0;   mul  gp, a3, t0;                vsub.vv  v19, v3,  v4
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v10, v5,  v6
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v12, v5,  v6
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v2, v13, v31
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v1, v21, v30
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v2, v21, v2, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm v1, v1, v13, v0
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vrgather.vv v4, v14, v31
sub  a4, s6, tp;   sub  a5, s7, ra;                vrgather.vv v3, v22, v30
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmerge.vvm v4, v22, v4, v0
mul  tp, s6, t1;   mul  ra, s7, t1;                vmerge.vvm v3, v3, v14, v0
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v18, v7,  v8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v20, v7,  v8
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v6, v15, v31
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v5, v23, v30
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm v6, v23, v6, v0
mul  a7, a2, t2;   mul  gp, a3, t2;                vmerge.vvm v5, v5, v15, v0
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v8, v16, v31
mul  tp, a4, t2;   mul  ra, a5, t2;                vrgather.vv v7, v24, v30
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm v8, v24, v8, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm v7, v7, v16, v0
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmul.vv  v13, v2,  v27
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vv v2,  v2,  v26
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmulh.vx v13, v13, t4
mul  a7, s2, t3;   mul  gp, s3, t3;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v21, v4,  v27
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v4,  v4,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v21, v21, t4
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s6, s4, tp;   sub  s7, s5, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmul.vv  v14, v6,  v27
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vv v6,  v6,  v26
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vx v14, v14, t4
mul  tp, a4, ra;   mul  ra, a5, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v22, v8,  v27
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v8,  v8,  v26
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v2,  v2, v13
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v4,  v4, v21
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v22, v22, t4
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vsub.vv  v6,  v6, v14
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vsub.vv  v8,  v8, v22
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           lw t6, 4*16(sp)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vadd.vv  v13, v1,  v2
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vsub.vv  v15, v1,  v2
addi a0, a0, 32
addi a1, a1, 7*4;                                  vadd.vv  v21, v3,  v4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vsub.vv  v23, v3,  v4
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vadd.vv  v14, v5,  v6
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vsub.vv  v16, v5,  v6
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vrgather.vv v1, v11, v29
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmerge.vvm  v1, v1, v9, v0
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    vrgather.vv v2, v9, v28
lw t1, 1*4(a1);                                    vmerge.vvm  v2, v11, v2, v0
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    vadd.vv  v22, v7,  v8
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v24, v7,  v8
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v3, v19, v29
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v3, v3, v17, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v4, v17, v28
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v4, v19, v4, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L6+ 0*_ZETAS_EXP_1TO6_P1_L6)*2
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v v27, (t6)
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vv  v9,  v2,  v27
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vv v2,  v2,  v26
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v5, v12, v29
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v5, v5, v10, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v6, v10, v28
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                vmerge.vvm  v6, v12, v6, v0
add  s4, s4, a7;   add  s5, s5, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  a7, s4, t1;   mul  gp, s5, t1;                vmul.vv  v11, v4,  v27
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vv v4,  v4,  v26
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v7, v20, v29
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v7, v7, v18, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v8, v18, v28
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                vmerge.vvm  v8, v20, v8, v0
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vv  v17, v6,  v27
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vv v6,  v6,  v26
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v19, v8,  v27
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                vmulh.vv v8,  v8,  v26
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v9,  v9,  t4
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              vmulh.vx v11, v11, t4
lw   ra, 4*4(a1);                                  vmulh.vx v17, v17, t4
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                vmulh.vx v19, v19, t4
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v2,  v2,  v9
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v4,  v4,  v11
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v6,  v6,  v17
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v8,  v8,  v19
sub  s2, s0, a7;   sub  s3, s1, gp;                vadd.vv  v9,  v1,  v2
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v11, v1,  v2
lw   gp, 5*4(a1);                                  vadd.vv  v17, v3,  v4
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  vsub.vv  v19, v3,  v4
mul  a7, s10, gp;  mul  gp, s11, gp;               vrgather.vv v1, v15, v29
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v1, v1, v13, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v2, v13, v28
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v2, v15, v2, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v10, v5,  v6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               vsub.vv  v12, v5,  v6
sub  a4, a2, tp;   sub  a5, a3, ra;                vadd.vv  v18, v7,  v8
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                vsub.vv  v20, v7,  v8
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vrgather.vv v3, v23, v29
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vmerge.vvm  v3, v3, v21, v0
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vrgather.vv v4, v21, v28
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmerge.vvm  v4, v23, v4, v0
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          addi t6, t6, 8*2;     vle16.v v27, (t6)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32;                                   addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a1, a1, 7*4;                                  vmul.vv  v13, v2,  v27
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmulh.vv v2,  v2,  v26
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vrgather.vv v5, v16, v29
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vmerge.vvm  v5, v5, v14, v0
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vrgather.vv v6, v14, v28
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vmerge.vvm  v6, v16, v6, v0
lw t0, 0*4(a1);                                    addi t6, t6, 8*2;     vle16.v v27, (t6)
lw t1, 1*4(a1)
lw t2, 2*4(a1);                                    addi t6, t6, 8*2;     vle16.v v26, (t6)
lw t3, 3*4(a1);                                    vmul.vv  v15, v4,  v27
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0;               vmulh.vv v4,  v4,  v26
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v7, v24, v29
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v7, v7, v22, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v8, v22, v28
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v8, v24, v8, v0
sub  s8, s0, a7;   sub  s9, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s10, s2, tp;  sub  s11, s3, ra;               vmul.vv  v21, v6,  v27
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vv v6,  v6,  v26
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v23, v8,  v27
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v8,  v8,  v26
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v13, v13, t4
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v15, v15, t4
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v21, v21, t4
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v23, v23, t4
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v2,  v2,  v13
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v4,  v4,  v15
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v6,  v6,  v21
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v8,  v8,  v23
sub  s4, s0, a7;   sub  s5, s1, gp;                vadd.vv  v13, v1,  v2
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v15, v1,  v2
sub  s6, s2, tp;   sub  s7, s3, ra;                lw t6, 4*16(sp)
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2;                addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
srai a7, a7, 16;   srai gp, gp, 16;                addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v21, v3,  v4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v23, v3,  v4
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v1, v11, v27
sub  a2, s8, a7;   sub  a3, s9, gp;                vrgather.vv v2, v9, v27
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra;               vmerge.vvm  v1, v1, v9, v0
add  s10, s10, tp; add  s11, s11, ra;              vmerge.vvm  v2, v11, v2, v0
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3;                vadd.vv  v14, v5,  v6
mul  tp, s6, ra;   mul  ra, s7, ra;                vsub.vv  v16, v5,  v6
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v3, v19, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v4, v17, v27
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v3, v3, v17, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v4, v19, v4, v0
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra;                vadd.vv  v22, v7,  v8
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v24, v7,  v8
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp;                vrgather.vv v5, v12, v27
lw   ra, 6*4(a1);                                  vrgather.vv v6, v10, v27
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra;                vmerge.vvm  v5, v5, v10, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v6, v12, v6, v0
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v7, v20, v27
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v8, v18, v27
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v7, v7, v18, v0
sub  s10, s8, a7;  sub  s11, s9, gp;               vmerge.vvm  v8, v20, v8, v0
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp;                vrgather.vv v9, v15, v27
add  a2, a2, tp;   add  a3, a3, ra;                vrgather.vv v11, v13, v27
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmerge.vvm  v9, v9, v13, v0
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vmerge.vvm  v11, v15, v11, v0
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vrgather.vv v17, v23, v27
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vrgather.vv v19, v21, v27
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmerge.vvm  v17, v17, v21, v0
addi a0, a0, 32;                                   vmerge.vvm  v19, v23, v19, v0
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vrgather.vv v10, v16, v27
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vrgather.vv v12, v14, v27
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vmerge.vvm  v10, v10, v14, v0
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vmerge.vvm  v12, v16, v12, v0
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vrgather.vv v18, v24, v27
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vrgather.vv v20, v22, v27
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    vmerge.vvm  v18, v18, v22, v0
lw t2, 2*4(a1);                                    vmerge.vvm  v20, v24, v20, v0
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0;                lw   t5, 4*15(sp);   addi t5, t5, (0*128)*2
mul  tp, s10, t0;  mul  ra, s11, t0;               vse16.v  v1,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v2,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v3,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v4,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v5,  (t5);  addi t5, t5, 16
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v6,  (t5);  addi t5, t5, 16
mul  a7, a2, t0;   mul  gp, a3, t0;                vse16.v  v7,  (t5);  addi t5, t5, 16
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vse16.v  v8,  (t5);  addi t5, t5, -16*7-(0*128)*2+(64+0*128)*2
mul  tp, a4, t0;   mul  ra, a5, t0;                vse16.v  v9,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v11, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v17, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v19, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v10, (t5);  addi t5, t5, 16
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vse16.v  v12, (t5);  addi t5, t5, 16
sub  a4, s6, tp;   sub  a5, s7, ra;                vse16.v  v18, (t5);  addi t5, t5, 16
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vse16.v  v20, (t5)
mul  tp, s6, t1;   mul  ra, s7, t1;                lw   t5, 4*15(sp);  addi t5, t5, (64+1*128)*2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v9,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v10, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v11, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v12, (t5);  addi t5, t5, 16
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v v13, (t5);  addi t5, t5, 16
mul  a7, a2, t2;   mul  gp, a3, t2;                vle16.v v14, (t5);  addi t5, t5, 16
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v v15, (t5);  addi t5, t5, 16
mul  tp, a4, t2;   mul  ra, a5, t2;                vle16.v v16, (t5);  addi t5, t5, -16*7-(64+1*128)*2+(1*128)*2
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v1,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v2,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v3,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v4,  (t5);  addi t5, t5, 16
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v v5,  (t5);  addi t5, t5, 16
sub  a4, s10, tp;  sub  a5, s11, ra;               vle16.v v6,  (t5);  addi t5, t5, 16
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vle16.v v7,  (t5);  addi t5, t5, 16
mul  a7, s2, t3;   mul  gp, s3, t3;                vle16.v v8,  (t5)
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                lw t6, 4*16(sp)
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 lh t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v17, v9,  t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmul.vx v18, v10, t5
sub  s6, s4, tp;   sub  s7, s5, ra;                vmul.vx v19, v11, t5
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmul.vx v20, v12, t5
add  s5, s5, ra;   add  s4, s4, tp;                vmul.vx v21, v13, t5
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmul.vx v22, v14, t5
mul  tp, a4, ra;   mul  ra, a5, ra;                vmul.vx v23, v15, t5
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v24, v16, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v9,  v9,  t6
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v10, v10, t6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v11, v11, t6
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v12, v12, t6
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v13, v13, t6
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vmulh.vx v14, v14, t6
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmulh.vx v15, v15, t6
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vmulh.vx v16, v16, t6
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vmulh.vx v21, v21, t4
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vmulh.vx v22, v22, t4
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmulh.vx v23, v23, t4
addi a0, a0, 32
addi a1, a1, 7*4;                                  vmulh.vx v24, v24, t4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vsub.vv  v13, v13, v21
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vsub.vv  v14, v14, v22
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vsub.vv  v15, v15, v23
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vsub.vv  v16, v16, v24
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmulh.vx v17, v17, t4
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    vsub.vv  v21, v5, v13
lw t1, 1*4(a1);                                    vmulh.vx v18, v18, t4
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    vsub.vv  v22, v6, v14
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v19, v19, t4
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v23, v7, v15
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v20, v20, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v24, v8, v16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v9,  v9,  v17
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                vsub.vv  v10, v10, v18
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v11, v11, v19
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               vsub.vv  v12, v12, v20
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v17, v1, v9
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v18, v2, v10
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v19, v3, v11
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v20, v4, v12
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v13, v5, v13
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                vadd.vv  v14, v6, v14
add  s4, s4, a7;   add  s5, s5, gp;                vadd.vv  v15, v7, v15
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                vadd.vv  v16, v8, v16
mul  a7, s4, t1;   mul  gp, s5, t1;                vadd.vv  v9, v1, v9
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v10, v2, v10
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v11, v3, v11
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v12, v4, v12
addi tp, tp, 8;    addi ra, ra, 8;                 lw t6, 4*16(sp)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vx v1, v13, t5
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                vmul.vx v2, v14, t5
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vx v3, v15, t5
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v4, v16, t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v5, v21, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v6, v22, t5
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                vmul.vx v7, v23, t5
add  s8, s8, a7;   add  s9, s9, gp;                vmul.vx v8, v24, t5
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
lw   ra, 4*4(a1);                                  vmulh.vx v13, v13, t5
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                vmulh.vx v14, v14, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v15, v15, t5
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v16, v16, t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v21, v21, t5
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vx v22, v22, t5
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v23, v23, t5
lw   gp, 5*4(a1);                                  vmulh.vx v24, v24, t5
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  vmulh.vx v1, v1, t4
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vx v2, v2, t4
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v3, v3, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v4, v4, t4
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v13, v13, v1
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v14, v14, v2
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               vsub.vv  v15, v15, v3
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v16, v16, v4
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                vmulh.vx v5, v5, t4
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vadd.vv  v1, v9,  v13
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vmulh.vx v6, v6, t4
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vadd.vv  v2, v10, v14
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmulh.vx v7, v7, t4
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vadd.vv  v3, v11, v15
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32;                                   vmulh.vx v8, v8, t4
addi a1, a1, 7*4;                                  vadd.vv  v4, v12, v16
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vsub.vv  v21, v21, v5
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vsub.vv  v22, v22, v6
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vsub.vv  v23, v23, v7
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vsub.vv  v24, v24, v8
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vadd.vv  v5, v17, v21
lw t0, 0*4(a1);                                    vadd.vv  v6, v18, v22
lw t1, 1*4(a1)
lw t2, 2*4(a1);                                    vadd.vv  v7, v19, v23
lw t3, 3*4(a1);                                    vadd.vv  v8, v20, v24
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v9, v9,  v13
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v10, v10,v14
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v11,v11, v15
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v12,v12, v16
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v13,v17, v21
sub  s8, s0, a7;   sub  s9, s1, gp;                vsub.vv  v14,v18, v22
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0;                vsub.vv  v15,v19, v23
sub  s10, s2, tp;  sub  s11, s3, ra;               vsub.vv  v16,v20, v24
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v17, v3,  t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v18, v4,  t5
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v19, v11, t5
sub  a2, s4, a7;   sub  a3, s5, gp;                vmul.vx v20, v12, t5
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
add  s6, s6, tp;   add  s7, s7, ra;                vmul.vx v21, v7,  t5
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1;                vmul.vx v22, v8,  t5
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v23, v15, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v24, v16, t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
sub  s4, s0, a7;   sub  s5, s1, gp;                vmulh.vx v3,  v3,  t5
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2;                vmulh.vx v4,  v4,  t5
sub  s6, s2, tp;   sub  s7, s3, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2;                vmulh.vx v11, v11, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v12, v12, t5
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v7,  v7,  t5
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v8,  v8,  t5
sub  a2, s8, a7;   sub  a3, s9, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vx v15, v15, t5
add  s10, s10, tp; add  s11, s11, ra;              vmulh.vx v16, v16, t5
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3;                vmulh.vx v17, v17, t4
mul  tp, s6, ra;   mul  ra, s7, ra;                vmulh.vx v18, v18, t4
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v19, v19, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v20, v20, t4
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v3,  v3,  v17
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v4,  v4,  v18
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra;                vsub.vv  v11, v11, v19
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v12, v12, v20
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v21, v21, t4
lw   ra, 6*4(a1);                                  vadd.vv  v17, v1,  v3
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v22, v22, t4
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v18, v2,  v4
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v23, v23, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v19, v9,  v11
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v24, v24, t4
sub  s10, s8, a7;  sub  s11, s9, gp;               vadd.vv  v20, v10, v12
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v7,  v7,  v21
add  a2, a2, tp;   add  a3, a3, ra;                vsub.vv  v8,  v8,  v22
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vsub.vv  v15, v15, v23
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vsub.vv  v16, v16, v24
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vadd.vv  v21, v5,  v7
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vadd.vv  v22, v6,  v8
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vadd.vv  v23, v13, v15
addi a0, a0, 32;                                   vadd.vv  v24, v14, v16
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vsub.vv  v1,  v1,  v3
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vsub.vv  v2,  v2,  v4
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vsub.vv  v3,  v9,  v11
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vsub.vv  v4,  v10, v12
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vsub.vv  v5,  v5,  v7
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vsub.vv  v6,  v6,  v8
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    vsub.vv  v7,  v13, v15
lw t2, 2*4(a1);                                    vsub.vv  v8,  v14, v16
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
mul  tp, s10, t0;  mul  ra, s11, t0;               vmul.vx v9,  v18,  t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v18, v18, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v10, v2,   t5
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v2,  v2,  t5
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
mul  tp, a4, t0;   mul  ra, a5, t0;                vmul.vx v11, v20,  t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v20, v20, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v12, v4,   t5
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v4,  v4,  t5
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
mul  tp, s6, t1;   mul  ra, s7, t1;                vmul.vx v13, v22,  t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v22, v22, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v14, v6,   t5
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
mul  a7, a2, t2;   mul  gp, a3, t2;                vmulh.vx v6,  v6,  t5
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
mul  tp, a4, t2;   mul  ra, a5, t2;                vmul.vx v15, v24,  t5
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v24, v24, t5
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v16, v8,   t5
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vx v8,  v8,  t5
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmulh.vx v9,  v9,  t4
mul  a7, s2, t3;   mul  gp, s3, t3;                vmulh.vx v10, v10, t4
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v11, v11, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v12, v12, t4
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v18, v18, v9
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v2,  v2,  v10
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v20, v20, v11
sub  s6, s4, tp;   sub  s7, s5, ra;                vsub.vv  v4,  v4,  v12
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmulh.vx v13, v13, t4
add  s5, s5, ra;   add  s4, s4, tp;                vadd.vv  v9,  v17, v18
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vx v14, v14, t4
mul  tp, a4, ra;   mul  ra, a5, ra;                vadd.vv  v10, v1,  v2
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v15, v15, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v11, v19, v20
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v16, v16, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v12, v3, v4
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v22, v22, v13
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vsub.vv  v6,  v6,  v14
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vsub.vv  v24, v24, v15
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vsub.vv  v8,  v8,  v16
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vsub.vv  v17, v17, v18
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vsub.vv  v18, v1,  v2
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vsub.vv  v19, v19, v20
addi a0, a0, 32
addi a1, a1, 7*4;                                  vsub.vv  v20, v3,  v4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vadd.vv  v13, v21,  v22
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vadd.vv  v14, v5,  v6
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vadd.vv  v15, v23, v24
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vrgather.vv v2, v9, v31
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vrgather.vv v1, v17, v30
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    vmerge.vvm v2, v17, v2, v0
lw t1, 1*4(a1);                                    vmerge.vvm v1, v1, v9, v0
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    vadd.vv  v16, v7, v8
mul  a7, s8, t0;   mul  gp, s9, t0;                vrgather.vv v4, v10, v31
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v3, v18, v30
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm v4, v18, v4, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm v3, v3, v10, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v21, v21, v22
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                vsub.vv  v22, v5,  v6
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v23, v23, v24
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               vsub.vv  v24, v7,  v8
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L5 + 1*_ZETAS_EXP_1TO6_P1_L5)*2
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v9,  v2,  v27
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v2,  v2,  v26
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                vrgather.vv v6, v11, v31
add  s4, s4, a7;   add  s5, s5, gp;                vrgather.vv v5, v19, v30
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                vmerge.vvm v6, v19, v6, v0
mul  a7, s4, t1;   mul  gp, s5, t1;                vmerge.vvm v5, v5, v11, v0
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v8, v12, v31
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v7, v20, v30
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm v8, v20, v8, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v7, v7, v12, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                vmul.vv  v17, v4,  v27
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vv v4,  v4,  v26
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v9,  v9,  t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v17, v17, t4
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                vmul.vv  v10, v6,  v27
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vv v6,  v6,  v26
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              vsub.vv  v2,  v2,  v9
lw   ra, 4*4(a1);                                  vmulh.vx v10, v10, t4
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v18, v8,  v27
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v8,  v8,  v26
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v18, v18, t4
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v4,  v4,  v17
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v6,  v6,  v10
lw   gp, 5*4(a1);                                  vsub.vv  v8,  v8,  v18
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  vadd.vv  v9,  v1,  v2
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v11, v1,  v2
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v17, v3,  v4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v19, v3,  v4
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v10, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v12, v5,  v6
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               vrgather.vv v2, v13, v31
sub  a4, a2, tp;   sub  a5, a3, ra;                vrgather.vv v1, v21, v30
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                vmerge.vvm v2, v21, v2, v0
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vmerge.vvm v1, v1, v13, v0
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vrgather.vv v4, v14, v31
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vrgather.vv v3, v22, v30
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmerge.vvm v4, v22, v4, v0
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vmerge.vvm v3, v3, v14, v0
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
addi a0, a0, 32;                                   vadd.vv  v18, v7,  v8
addi a1, a1, 7*4;                                  vsub.vv  v20, v7,  v8
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vrgather.vv v6, v15, v31
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vrgather.vv v5, v23, v30
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vmerge.vvm v6, v23, v6, v0
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmerge.vvm v5, v5, v15, v0
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vrgather.vv v8, v16, v31
lw t0, 0*4(a1);                                    vrgather.vv v7, v24, v30
lw t1, 1*4(a1)
lw t2, 2*4(a1);                                    vmerge.vvm v8, v24, v8, v0
lw t3, 3*4(a1);                                    vmerge.vvm v7, v7, v16, v0
mul  a7, s8, t0;   mul  gp, s9, t0
mul  tp, s10, t0;  mul  ra, s11, t0;               addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v13, v2,  v27
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vv v2,  v2,  v26
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v13, v13, t4
sub  s8, s0, a7;   sub  s9, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t0;   mul  gp, a3, t0;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s10, s2, tp;  sub  s11, s3, ra;               vmul.vv  v21, v4,  v27
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vv v4,  v4,  v26
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v21, v21, t4
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v14, v6,  v27
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vv v6,  v6,  v26
add  s4, s4, a7;   add  s5, s5, gp
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v14, v14, t4
add  s6, s6, tp;   add  s7, s7, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  a7, s4, t1;   mul  gp, s5, t1
mul  tp, s6, t1;   mul  ra, s7, t1;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v22, v8,  v27
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v8,  v8,  v26
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v2,  v2, v13
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v4,  v4, v21
sub  s4, s0, a7;   sub  s5, s1, gp;                vmulh.vx v22, v22, t4
add  s0, s0, a7;   add  s1, s1, gp
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v6,  v6, v14
sub  s6, s2, tp;   sub  s7, s3, ra;                vsub.vv  v8,  v8, v22
add  s2, s2, tp;   add  s3, s3, ra
mul  tp, a4, t2;   mul  ra, a5, t2;                lw t6, 4*16(sp)
srai a7, a7, 16;   srai gp, gp, 16;                addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
addi a7, a7, 8;    addi gp, gp, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v13, v1,  v2
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v15, v1,  v2
addi tp, tp, 8;    addi ra, ra, 8
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v21, v3,  v4
sub  a2, s8, a7;   sub  a3, s9, gp;                vsub.vv  v23, v3,  v4
add  s8, s8, a7;   add  s9, s9, gp
sub  a4, s10, tp;  sub  a5, s11, ra;               vadd.vv  v14, v5,  v6
add  s10, s10, tp; add  s11, s11, ra;              vsub.vv  v16, v5,  v6
lw   ra, 4*4(a1)
mul  a7, s2, t3;   mul  gp, s3, t3;                vrgather.vv v1, v11, v29
mul  tp, s6, ra;   mul  ra, s7, ra;                vmerge.vvm  v1, v1, v9, v0
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v2, v9, v28
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v2, v11, v2, v0
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v22, v7,  v8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v24, v7,  v8
sub  s2, s0, a7;   sub  s3, s1, gp
sub  s6, s4, tp;   sub  s7, s5, ra;                vrgather.vv v3, v19, v29
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v3, v3, v17, v0
lw   gp, 5*4(a1)
add  s5, s5, ra;   add  s4, s4, tp;                vrgather.vv v4, v17, v28
lw   ra, 6*4(a1);                                  vmerge.vvm  v4, v19, v4, v0
mul  a7, s10, gp;  mul  gp, s11, gp
mul  tp, a4, ra;   mul  ra, a5, ra;                addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L6+ 1*_ZETAS_EXP_1TO6_P1_L6)*2
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v9,  v2,  v27
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v2,  v2,  v26
sub  s10, s8, a7;  sub  s11, s9, gp;               vrgather.vv v5, v12, v29
sub  a4, a2, tp;   sub  a5, a3, ra
add  s8, s8, a7;   add  s9, s9, gp;                vmerge.vvm  v5, v5, v10, v0
add  a2, a2, tp;   add  a3, a3, ra;                vrgather.vv v6, v10, v28
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmerge.vvm  v6, v12, v6, v0
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           addi t6, t6, 8*2;     vle16.v v27, (t6)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           addi t6, t6, 8*2;     vle16.v v26, (t6)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmul.vv  v11, v4,  v27
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmulh.vv v4,  v4,  v26
addi a0, a0, 32;                                   vrgather.vv v7, v20, v29
addi a1, a1, 7*4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vmerge.vvm  v7, v7, v18, v0
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vrgather.vv v8, v18, v28
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vmerge.vvm  v8, v20, v8, v0
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           addi t6, t6, 8*2;     vle16.v v27, (t6)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          addi t6, t6, 8*2;     vle16.v v26, (t6)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vmul.vv  v17, v6,  v27
lw t0, 0*4(a1)
lw t1, 1*4(a1);                                    vmulh.vv v6,  v6,  v26
lw t2, 2*4(a1);                                    addi t6, t6, 8*2;     vle16.v v27, (t6)
lw t3, 3*4(a1)
mul  a7, s8, t0;   mul  gp, s9, t0;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, s10, t0;  mul  ra, s11, t0;               vmul.vv  v19, v8,  v27
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v8,  v8,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v9,  v9,  t4
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v11, v11, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v17, v17, t4
sub  s8, s0, a7;   sub  s9, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v19, v19, t4
mul  a7, a2, t0;   mul  gp, a3, t0;                vsub.vv  v2,  v2,  v9
sub  s10, s2, tp;  sub  s11, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v4,  v4,  v11
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v6,  v6,  v17
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v8,  v8,  v19
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v9,  v1,  v2
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v11, v1,  v2
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v17, v3,  v4
sub  a2, s4, a7;   sub  a3, s5, gp
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v19, v3,  v4
sub  a4, s6, tp;   sub  a5, s7, ra;                vrgather.vv v1, v15, v29
add  s6, s6, tp;   add  s7, s7, ra
mul  a7, s4, t1;   mul  gp, s5, t1;                vmerge.vvm  v1, v1, v13, v0
mul  tp, s6, t1;   mul  ra, s7, t1;                vrgather.vv v2, v13, v28
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v2, v15, v2, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v10, v5,  v6
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v12, v5,  v6
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v18, v7,  v8
sub  s4, s0, a7;   sub  s5, s1, gp
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v20, v7,  v8
mul  a7, a2, t2;   mul  gp, a3, t2;                vrgather.vv v3, v23, v29
sub  s6, s2, tp;   sub  s7, s3, ra
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm  v3, v3, v21, v0
mul  tp, a4, t2;   mul  ra, a5, t2;                vrgather.vv v4, v21, v28
srai a7, a7, 16;   srai gp, gp, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v4, v23, v4, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v13, v2,  v27
sub  a2, s8, a7;   sub  a3, s9, gp
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vv v2,  v2,  v26
sub  a4, s10, tp;  sub  a5, s11, ra;               vrgather.vv v5, v16, v29
add  s10, s10, tp; add  s11, s11, ra
lw   ra, 4*4(a1);                                  vmerge.vvm  v5, v5, v14, v0
mul  a7, s2, t3;   mul  gp, s3, t3;                vrgather.vv v6, v14, v28
mul  tp, s6, ra;   mul  ra, s7, ra
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v6, v16, v6, v0
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v15, v4,  v27
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vv v4,  v4,  v26
sub  s6, s4, tp;   sub  s7, s5, ra;                vrgather.vv v7, v24, v29
add  s0, s0, a7;   add  s1, s1, gp
lw   gp, 5*4(a1);                                  vmerge.vvm  v7, v7, v22, v0
add  s5, s5, ra;   add  s4, s4, tp;                vrgather.vv v8, v22, v28
lw   ra, 6*4(a1)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmerge.vvm  v8, v24, v8, v0
mul  tp, a4, ra;   mul  ra, a5, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v21, v6,  v27
addi tp, tp, 8;    addi ra, ra, 8
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v6,  v6,  v26
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s10, s8, a7;  sub  s11, s9, gp
sub  a4, a2, tp;   sub  a5, a3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s8, s8, a7;   add  s9, s9, gp;                vmul.vv  v23, v8,  v27
add  a2, a2, tp;   add  a3, a3, ra
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vmulh.vv v8,  v8,  v26
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmulh.vx v13, v13, t4
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vmulh.vx v15, v15, t4
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vmulh.vx v21, v21, t4
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vmulh.vx v23, v23, t4
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vsub.vv  v2,  v2,  v13
addi a0, a0, 32
addi a1, a1, 7*4;                                  vsub.vv  v4,  v4,  v15
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vsub.vv  v6,  v6,  v21
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vsub.vv  v8,  v8,  v23
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vadd.vv  v13, v1,  v2
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vsub.vv  v15, v1,  v2
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          lw t6, 4*16(sp)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0)
lw t0, 0*4(a1);                                    addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
lw t1, 1*4(a1);                                    addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
lw t2, 2*4(a1)
lw t3, 3*4(a1);                                    vadd.vv  v21, v3,  v4
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v23, v3,  v4
mul  tp, s10, t0;  mul  ra, s11, t0
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v1, v11, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v2, v9, v27
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v1, v1, v9, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v2, v11, v2, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s8, s0, a7;   sub  s9, s1, gp;                vadd.vv  v14, v5,  v6
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v16, v5,  v6
mul  a7, a2, t0;   mul  gp, a3, t0
sub  s10, s2, tp;  sub  s11, s3, ra;               vrgather.vv v3, v19, v27
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v4, v17, v27
mul  tp, a4, t0;   mul  ra, a5, t0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v3, v3, v17, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v4, v19, v4, v0
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v22, v7,  v8
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v24, v7,  v8
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s4, a7;   sub  a3, s5, gp;                vrgather.vv v5, v12, v27
add  s4, s4, a7;   add  s5, s5, gp;                vrgather.vv v6, v10, v27
sub  a4, s6, tp;   sub  a5, s7, ra
add  s6, s6, tp;   add  s7, s7, ra;                vmerge.vvm  v5, v5, v10, v0
mul  a7, s4, t1;   mul  gp, s5, t1;                vmerge.vvm  v6, v12, v6, v0
mul  tp, s6, t1;   mul  ra, s7, t1
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v7, v20, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v8, v18, v27
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v7, v7, v18, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v8, v20, v8, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s4, s0, a7;   sub  s5, s1, gp;                vrgather.vv v9, v15, v27
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v11, v13, v27
mul  a7, a2, t2;   mul  gp, a3, t2
sub  s6, s2, tp;   sub  s7, s3, ra;                vmerge.vvm  v9, v9, v13, v0
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm  v11, v15, v11, v0
mul  tp, a4, t2;   mul  ra, a5, t2
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v17, v23, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v19, v21, v27
mulh a7, a7, a6;   mulh gp, gp, a6
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v17, v17, v21, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v19, v23, v19, v0
mulh tp, tp, a6;   mulh ra, ra, a6
sub  a2, s8, a7;   sub  a3, s9, gp;                vrgather.vv v10, v16, v27
add  s8, s8, a7;   add  s9, s9, gp;                vrgather.vv v12, v14, v27
sub  a4, s10, tp;  sub  a5, s11, ra
add  s10, s10, tp; add  s11, s11, ra;              vmerge.vvm  v10, v10, v14, v0
lw   ra, 4*4(a1);                                  vmerge.vvm  v12, v16, v12, v0
mul  a7, s2, t3;   mul  gp, s3, t3
mul  tp, s6, ra;   mul  ra, s7, ra;                vrgather.vv v18, v24, v27
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v20, v22, v27
srai tp, tp, 16;   srai ra, ra, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v18, v18, v22, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v20, v24, v20, v0
mulh a7, a7, a6;   mulh gp, gp, a6
mulh tp, tp, a6;   mulh ra, ra, a6;                lw   t5, 4*15(sp);   addi t5, t5, (1*128)*2
sub  s2, s0, a7;   sub  s3, s1, gp;                vse16.v  v1,  (t5);  addi t5, t5, 16
sub  s6, s4, tp;   sub  s7, s5, ra
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v2,  (t5);  addi t5, t5, 16
lw   gp, 5*4(a1);                                  vse16.v  v3,  (t5);  addi t5, t5, 16
add  s5, s5, ra;   add  s4, s4, tp
lw   ra, 6*4(a1);                                  vse16.v  v4,  (t5);  addi t5, t5, 16
mul  a7, s10, gp;  mul  gp, s11, gp;               vse16.v  v5,  (t5);  addi t5, t5, 16
mul  tp, a4, ra;   mul  ra, a5, ra
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v6,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v7,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v8,  (t5);  addi t5, t5, -16*7-(1*128)*2+(64+1*128)*2
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v9,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6
sub  s10, s8, a7;  sub  s11, s9, gp;               vse16.v  v11, (t5);  addi t5, t5, 16
sub  a4, a2, tp;   sub  a5, a3, ra;                vse16.v  v17, (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp
add  a2, a2, tp;   add  a3, a3, ra;                vse16.v  v19, (t5);  addi t5, t5, 16
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vse16.v  v10, (t5);  addi t5, t5, 16
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vse16.v  v12, (t5);  addi t5, t5, 16
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vse16.v  v18, (t5);  addi t5, t5, 16
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vse16.v  v20, (t5)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
    restore_regs
    addi sp, sp, 4*17
    ret

.globl ntt_hybridx4_rv32imv
.align 2
ntt_hybridx4_rv32imv:
    addi sp, sp, -4*17
    save_regs
    # vector init
    li t4, 128
    vsetvli t5, t4, e16, m1, tu, mu
    li t4, 3329
    # stack init: 4*15(sp) for vector-*a; 4*16(sp) for *vector_zetas
    addi t4, a0, 256*2
    sw   t4, 4*15(sp)
    sw   a2, 4*16(sp)
    li a6, q16        // q<<16
addi a0, a0, 32;                                   lw   t5, 4*15(sp)
lw t0, 0*4(a1);                                    addi t5, t5, (64*0+128)*2   
lw t1, 1*4(a1);                                    vle16.v v8,  (t5);  addi t5, t5, 16
lw t2, 2*4(a1);                                    vle16.v v9,  (t5);  addi t5, t5, 16
lw t3, 3*4(a1);                                    vle16.v v10, (t5);  addi t5, t5, 16
addi a0, a0, -2;                                   vle16.v v11, (t5);  addi t5, t5, 16
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vle16.v v12, (t5);  addi t5, t5, 16
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         vle16.v v13, (t5);  addi t5, t5, 16
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vle16.v v14, (t5);  addi t5, t5, 16
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vle16.v v15, (t5);  addi t5, t5, -((64*0+128)*2+16*7)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vle16.v v16, (t5);  addi t5, t5, 16
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vle16.v v17, (t5);  addi t5, t5, 16
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vle16.v v18, (t5);  addi t5, t5, 16
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vle16.v v19, (t5);  addi t5, t5, 16
mul  a7, s8, t0;   mul  gp, s9, t0;                vle16.v v20, (t5);  addi t5, t5, 16
mul  tp, s10, t0;  mul  ra, s11, t0;               vle16.v v21, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v22, (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v23, (t5);  addi t5, t5, -16*7
mulh a7, a7, a6;   mulh gp, gp, a6;                sw t5, 4*15(sp)
srai tp, tp, 16;   srai ra, ra, 16;                lw t6, 4*16(sp)
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, (_ZETAS_EXP+0)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t6, (_ZETAS_EXP+1)*2(t6)
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vx v0, v8, t5
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vx v1, v9, t5
mul  a7, a2, t0;   mul  gp, a3, t0;                vmul.vx v2, v10, t5
sub  s10, s2, tp;  sub  s11, s3, ra;               vmul.vx v3, v11, t5
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vx v4, v12, t5
mul  tp, a4, t0;   mul  ra, a5, t0;                vmul.vx v5, v13, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v6, v14, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v7, v15, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v8,  v8, t6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v9,  v9, t6
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v10, v10, t6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v11, v11, t6
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v12, v12, t6
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v13, v13, t6
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v14, v14, t6
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v15, v15, t6
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v0, v0, t4
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v1, v1, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v2, v2, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v3, v3, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v4, v4, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v5, v5, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v6, v6, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v7, v7, t4
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v8,  v8,  v0
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v9,  v9,  v1
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v10, v10, v2
sub  s6, s2, tp;   sub  s7, s3, ra;                vsub.vv  v11, v11, v3
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v12, v12, v4
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v13, v13, v5
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v14, v14, v6
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v15, v15, v7
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v0, v16, v8
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v1, v17, v9
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v2, v18, v10
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v3, v19, v11
sub  a2, s8, a7;   sub  a3, s9, gp;                vadd.vv  v4, v20, v12
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v5, v21, v13
sub  a4, s10, tp;  sub  a5, s11, ra;               vadd.vv  v6, v22, v14
add  s10, s10, tp; add  s11, s11, ra;              vadd.vv  v7, v23, v15
lw   ra, 4*4(a1);                                  vsub.vv  v8, v16, v8
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v9, v17, v9
mul  tp, s6, ra;   mul  ra, s7, ra;                vsub.vv  v10, v18, v10
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v11, v19, v11
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v12, v20, v12
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v13, v21, v13
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v14, v22, v14
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v15, v23, v15
mulh tp, tp, a6;   mulh ra, ra, a6;                lw t5, 4*15(sp)
sub  s2, s0, a7;   sub  s3, s1, gp;                vse16.v  v0,  (t5);  addi t5, t5, 16
sub  s6, s4, tp;   sub  s7, s5, ra;                vse16.v  v1,  (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v2,  (t5);  addi t5, t5, 16
lw   gp, 5*4(a1);                                  vse16.v  v3,  (t5);  addi t5, t5, 16
add  s5, s5, ra;   add  s4, s4, tp;                vse16.v  v4,  (t5);  addi t5, t5, 16
lw   ra, 6*4(a1);                                  vse16.v  v5,  (t5);  addi t5, t5, 16
mul  a7, s10, gp;  mul  gp, s11, gp;               vse16.v  v6,  (t5);  addi t5, t5, 16
mul  tp, a4, ra;   mul  ra, a5, ra;                vse16.v  v7,  (t5);  addi t5, t5, (64*0+128)*2-16*7
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v8,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v9,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v10, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v11, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v12, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v13, (t5);  addi t5, t5, 16
sub  s10, s8, a7;  sub  s11, s9, gp;               vse16.v  v14, (t5);  addi t5, t5, 16
sub  a4, a2, tp;   sub  a5, a3, ra;                vse16.v  v15, (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v  v24, (t5);  addi t5, t5, 16
add  a2, a2, tp;   add  a3, a3, ra;                vle16.v  v25, (t5);  addi t5, t5, 16
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vle16.v  v26, (t5);  addi t5, t5, 16
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vle16.v  v27, (t5);  addi t5, t5, 16
mul  a7, s1, a7;   mul  gp, s3, gp;                vle16.v  v28, (t5);  addi t5, t5, 16
mul  tp, s5, tp;   mul  ra, s7, ra;                vle16.v  v29, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v  v30, (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v  v31, (t5);  addi t5, t5, -(128*2)-16*7
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v  v16, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v  v17, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v  v18, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v  v19, (t5);  addi t5, t5, 16
sub  s1, s0, a7;   sub  s3, s2, gp;                vle16.v  v20, (t5);  addi t5, t5, 16
add  s0, s0, a7;   lw   a7, 11*4(a1);              vle16.v  v21, (t5);  addi t5, t5, 16
add  s2, s2, gp;   lw   gp, 12*4(a1);              vle16.v  v22, (t5);  addi t5, t5, 16
mul  a7, s9, a7;   mul  gp, s11, gp;               vle16.v  v23, (t5);  addi t5, t5, -16*7
sub  s5, s4, tp;   sub  s7, s6, ra;                sw t5, 4*15(sp)
add  s4, s4, tp;   lw   tp, 13*4(a1);              lw t6, 4*16(sp)
add  s6, s6, ra;   lw   ra, 14*4(a1);              lh t5, (_ZETAS_EXP+0)*2(t6)
mul  tp, a3, tp;   mul  ra, a5, ra;                lh t6, (_ZETAS_EXP+1)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v0, v24, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v1, v25, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v2, v26, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v3, v27, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v4, v28, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v5, v29, t5
sub  s9, s8, a7;   sub  s11, s10, gp;              vmul.vx v6, v30, t5
add  s8, s8, a7;   add  s10, s10, gp;              vmul.vx v7, v31, t5
sub  a3, a2, tp;   sub  a5, a4, ra;                vmulh.vx v24, v24, t6
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v25, v25, t6
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmulh.vx v26, v26, t6
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vmulh.vx v27, v27, t6
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v28, v28, t6
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmulh.vx v29, v29, t6
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vmulh.vx v30, v30, t6
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vx v31, v31, t6
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmulh.vx v0, v0, t4
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vmulh.vx v1, v1, t4
addi a0, a0, -2;                                   vmulh.vx v2, v2, t4
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vmulh.vx v3, v3, t4
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         vmulh.vx v4, v4, t4
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vx v5, v5, t4
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vmulh.vx v6, v6, t4
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vmulh.vx v7, v7, t4
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vsub.vv  v24, v24, v0
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vsub.vv  v25, v25, v1
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vsub.vv  v26, v26, v2
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v27, v27, v3
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v28, v28, v4
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v29, v29, v5
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v30, v30, v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v31, v31, v7
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v0, v16, v24
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v1, v17, v25
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v2, v18, v26
sub  s8, s0, a7;   sub  s9, s1, gp;                vadd.vv  v3, v19, v27
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v4, v20, v28
mul  a7, a2, t0;   mul  gp, a3, t0;                vadd.vv  v5, v21, v29
sub  s10, s2, tp;  sub  s11, s3, ra;               vadd.vv  v6, v22, v30
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v7, v23, v31
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v24, v16, v24
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v25, v17, v25
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v26, v18, v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v27, v19, v27
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v28, v20, v28
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v29, v21, v29
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v30, v22, v30
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v31, v23, v31
add  s4, s4, a7;   add  s5, s5, gp;                lw t5, 4*15(sp)
sub  a4, s6, tp;   sub  a5, s7, ra;                vse16.v  v0,  (t5);  addi t5, t5, 16
add  s6, s6, tp;   add  s7, s7, ra;                vse16.v  v1,  (t5);  addi t5, t5, 16
mul  a7, s4, t1;   mul  gp, s5, t1;                vse16.v  v2,  (t5);  addi t5, t5, 16
mul  tp, s6, t1;   mul  ra, s7, t1;                vse16.v  v3,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v4,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v5,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v6,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v7,  (t5);  addi t5, t5, -16*7+128*2
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v24, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v25, (t5);  addi t5, t5, 16
sub  s4, s0, a7;   sub  s5, s1, gp;                vse16.v  v26, (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v27, (t5);  addi t5, t5, 16
mul  a7, a2, t2;   mul  gp, a3, t2;                vse16.v  v28, (t5);  addi t5, t5, 16
sub  s6, s2, tp;   sub  s7, s3, ra;                vse16.v  v29, (t5);  addi t5, t5, 16
add  s2, s2, tp;   add  s3, s3, ra;                vse16.v  v30, (t5);  addi t5, t5, 16
mul  tp, a4, t2;   mul  ra, a5, t2;                vse16.v  v31, (t5);  addi t5, t5, -16*7-192*2
srai a7, a7, 16;   srai gp, gp, 16;                sw t5, 4*15(sp)
addi a7, a7, 8;    addi gp, gp, 8;                 lw t6, 4*16(sp)
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t5, t6, _MASK_45674567*2;      vle16.v v31, (t5)
srai tp, tp, 16;   srai ra, ra, 16;                addi t5, t6, _MASK_01230123*2;      vle16.v v30, (t5)
addi tp, tp, 8;    addi ra, ra, 8;                 addi t5, t6, _MASK_00010045*2;      vle16.v v29, (t5)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t5, t6, _MASK_23006700*2;      vle16.v v28, (t5)
sub  a2, s8, a7;   sub  a3, s9, gp;                lw   t5, 4*15(sp);  addi t5, t5, (64+0*128)*2
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v v9,  (t5);  addi t5, t5, 16
sub  a4, s10, tp;  sub  a5, s11, ra;               vle16.v v10, (t5);  addi t5, t5, 16
add  s10, s10, tp; add  s11, s11, ra;              vle16.v v11, (t5);  addi t5, t5, 16
lw   ra, 4*4(a1);                                  vle16.v v12, (t5);  addi t5, t5, 16
mul  a7, s2, t3;   mul  gp, s3, t3;                vle16.v v13, (t5);  addi t5, t5, 16
mul  tp, s6, ra;   mul  ra, s7, ra;                vle16.v v14, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v15, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v v16, (t5);  addi t5, t5, -16*7-(64+0*128)*2+(0*128)*2
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v1,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v2,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v3,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v4,  (t5);  addi t5, t5, 16
sub  s2, s0, a7;   sub  s3, s1, gp;                vle16.v v5,  (t5);  addi t5, t5, 16
sub  s6, s4, tp;   sub  s7, s5, ra;                vle16.v v6,  (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v v7,  (t5);  addi t5, t5, 16
lw   gp, 5*4(a1);                                  vle16.v v8,  (t5)
add  s5, s5, ra;   add  s4, s4, tp;                lw t6, 4*16(sp)
lw   ra, 6*4(a1);                                  lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
mul  a7, s10, gp;  mul  gp, s11, gp;               lh t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
mul  tp, a4, ra;   mul  ra, a5, ra;                vmul.vx v17, v9,  t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v18, v10, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v19, v11, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v20, v12, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v21, v13, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v22, v14, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v23, v15, t5
sub  s10, s8, a7;  sub  s11, s9, gp;               vmul.vx v24, v16, t5
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v9,  v9,  t6
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v10, v10, t6
add  a2, a2, tp;   add  a3, a3, ra;                vmulh.vx v11, v11, t6
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmulh.vx v12, v12, t6
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmulh.vx v13, v13, t6
mul  a7, s1, a7;   mul  gp, s3, gp;                vmulh.vx v14, v14, t6
mul  tp, s5, tp;   mul  ra, s7, ra;                vmulh.vx v15, v15, t6
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v16, v16, t6
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v21, v21, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v22, v22, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v23, v23, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v24, v24, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v13, v13, v21
sub  s1, s0, a7;   sub  s3, s2, gp;                vsub.vv  v14, v14, v22
add  s0, s0, a7;   lw   a7, 11*4(a1);              vsub.vv  v15, v15, v23
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v16, v16, v24
mul  a7, s9, a7;   mul  gp, s11, gp;               vmulh.vx v17, v17, t4
sub  s5, s4, tp;   sub  s7, s6, ra;                vsub.vv  v21, v5, v13
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmulh.vx v18, v18, t4
add  s6, s6, ra;   lw   ra, 14*4(a1);              vsub.vv  v22, v6, v14
mul  tp, a3, tp;   mul  ra, a5, ra;                vmulh.vx v19, v19, t4
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v23, v7, v15
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v20, v20, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v24, v8, v16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v9,  v9,  v17
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v10, v10, v18
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v11, v11, v19
sub  s9, s8, a7;   sub  s11, s10, gp;              vsub.vv  v12, v12, v20
add  s8, s8, a7;   add  s10, s10, gp;              vsub.vv  v17, v1, v9
sub  a3, a2, tp;   sub  a5, a4, ra;                vsub.vv  v18, v2, v10
add  a2, a2, tp;   add  a4, a4, ra;                vsub.vv  v19, v3, v11
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vsub.vv  v20, v4, v12
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vadd.vv  v13, v5, v13
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vadd.vv  v14, v6, v14
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vadd.vv  v15, v7, v15
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vadd.vv  v16, v8, v16
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vadd.vv  v9, v1, v9
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vadd.vv  v10, v2, v10
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vadd.vv  v11, v3, v11
addi a0, a0, -2;                                   vadd.vv  v12, v4, v12
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         lw t6, 4*16(sp)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmul.vx v1, v13, t5
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vmul.vx v2, v14, t5
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vmul.vx v3, v15, t5
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmul.vx v4, v16, t5
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vmul.vx v5, v21, t5
mul  a7, s8, t0;   mul  gp, s9, t0;                vmul.vx v6, v22, t5
mul  tp, s10, t0;  mul  ra, s11, t0;               vmul.vx v7, v23, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v8, v24, t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v13, v13, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v14, v14, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v15, v15, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v16, v16, t5
sub  s8, s0, a7;   sub  s9, s1, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v21, v21, t5
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v22, v22, t5
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vx v23, v23, t5
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v24, v24, t5
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vx v1, v1, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v2, v2, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v3, v3, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v4, v4, t4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v13, v13, v1
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v14, v14, v2
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v15, v15, v3
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v16, v16, v4
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v5, v5, t4
sub  a4, s6, tp;   sub  a5, s7, ra;                vadd.vv  v1, v9,  v13
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v6, v6, t4
mul  a7, s4, t1;   mul  gp, s5, t1;                vadd.vv  v2, v10, v14
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v7, v7, t4
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v3, v11, v15
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v8, v8, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v4, v12, v16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v21, v21, v5
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v22, v22, v6
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v23, v23, v7
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v24, v24, v8
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v5, v17, v21
mul  a7, a2, t2;   mul  gp, a3, t2;                vadd.vv  v6, v18, v22
sub  s6, s2, tp;   sub  s7, s3, ra;                vadd.vv  v7, v19, v23
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v8, v20, v24
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v9, v9,  v13
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v10, v10,v14
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11,v11, v15
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v12,v12, v16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v13,v17, v21
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v14,v18, v22
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v15,v19, v23
sub  a2, s8, a7;   sub  a3, s9, gp;                vsub.vv  v16,v20, v24
add  s8, s8, a7;   add  s9, s9, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
sub  a4, s10, tp;  sub  a5, s11, ra;               vmul.vx v17, v3,  t5
add  s10, s10, tp; add  s11, s11, ra;              vmul.vx v18, v4,  t5
lw   ra, 4*4(a1);                                  lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
mul  a7, s2, t3;   mul  gp, s3, t3;                vmul.vx v19, v11, t5
mul  tp, s6, ra;   mul  ra, s7, ra;                vmul.vx v20, v12, t5
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v21, v7,  t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v22, v8,  t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v23, v15, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v24, v16, t5
sub  s2, s0, a7;   sub  s3, s1, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vx v3,  v3,  t5
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v4,  v4,  t5
lw   gp, 5*4(a1);                                  lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v11, v11, t5
lw   ra, 6*4(a1);                                  vmulh.vx v12, v12, t5
mul  a7, s10, gp;  mul  gp, s11, gp;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v7,  v7,  t5
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v8,  v8,  t5
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v15, v15, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v16, v16, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v17, v17, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v18, v18, t4
sub  s10, s8, a7;  sub  s11, s9, gp;               vmulh.vx v19, v19, t4
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v20, v20, t4
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v3,  v3,  v17
add  a2, a2, tp;   add  a3, a3, ra;                vsub.vv  v4,  v4,  v18
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vsub.vv  v11, v11, v19
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vsub.vv  v12, v12, v20
mul  a7, s1, a7;   mul  gp, s3, gp;                vmulh.vx v21, v21, t4
mul  tp, s5, tp;   mul  ra, s7, ra;                vadd.vv  v17, v1,  v3
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v22, v22, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v18, v2,  v4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v23, v23, t4
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v19, v9,  v11
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v24, v24, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v20, v10, v12
sub  s1, s0, a7;   sub  s3, s2, gp;                vsub.vv  v7,  v7,  v21
add  s0, s0, a7;   lw   a7, 11*4(a1);              vsub.vv  v8,  v8,  v22
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v15, v15, v23
mul  a7, s9, a7;   mul  gp, s11, gp;               vsub.vv  v16, v16, v24
sub  s5, s4, tp;   sub  s7, s6, ra;                vadd.vv  v21, v5,  v7
add  s4, s4, tp;   lw   tp, 13*4(a1);              vadd.vv  v22, v6,  v8
add  s6, s6, ra;   lw   ra, 14*4(a1);              vadd.vv  v23, v13, v15
mul  tp, a3, tp;   mul  ra, a5, ra;                vadd.vv  v24, v14, v16
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v1,  v1,  v3
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v2,  v2,  v4
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v3,  v9,  v11
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v4,  v10, v12
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v5,  v5,  v7
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v8
sub  s9, s8, a7;   sub  s11, s10, gp;              vsub.vv  v7,  v13, v15
add  s8, s8, a7;   add  s10, s10, gp;              vsub.vv  v8,  v14, v16
sub  a3, a2, tp;   sub  a5, a4, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
add  a2, a2, tp;   add  a4, a4, ra;                vmul.vx v9,  v18,  t5
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vmulh.vx v18, v18, t5
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmul.vx v10, v2,   t5
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vx v2,  v2,  t5
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vmul.vx v11, v20,  t5
addi a0, a0, -2;                                   lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vmulh.vx v20, v20, t5
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmul.vx v12, v4,   t5
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vmulh.vx v4,  v4,  t5
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vmul.vx v13, v22,  t5
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v22, v22, t5
mul  tp, s10, t0;  mul  ra, s11, t0;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v14, v6,   t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v6,  v6,  t5
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v15, v24,  t5
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
sub  s8, s0, a7;   sub  s9, s1, gp;                vmulh.vx v24, v24, t5
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
mul  a7, a2, t0;   mul  gp, a3, t0;                vmul.vx v16, v8,   t5
sub  s10, s2, tp;  sub  s11, s3, ra;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v8,  v8,  t5
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vx v9,  v9,  t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v10, v10, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v11, v11, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v12, v12, t4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v18, v18, v9
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v2,  v2,  v10
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v20, v20, v11
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v4,  v4,  v12
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v13, v13, t4
sub  a4, s6, tp;   sub  a5, s7, ra;                vadd.vv  v9,  v17, v18
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v14, v14, t4
mul  a7, s4, t1;   mul  gp, s5, t1;                vadd.vv  v10, v1,  v2
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v15, v15, t4
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v11, v19, v20
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v16, v16, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v12, v3, v4
srai tp, tp, 16;   srai ra, ra, 16;                addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v22, v22, v13
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v14
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v24, v24, v15
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v8,  v8,  v16
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v17, v17, v18
sub  s6, s2, tp;   sub  s7, s3, ra;                vsub.vv  v18, v1,  v2
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v19, v19, v20
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v20, v3,  v4
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v13, v21,  v22
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v14, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v15, v23, v24
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v2, v9, v31
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v1, v17, v30
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm v2, v17, v2, v0
sub  a2, s8, a7;   sub  a3, s9, gp;                vmerge.vvm v1, v1, v9, v0
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v16, v7, v8
sub  a4, s10, tp;  sub  a5, s11, ra;               vrgather.vv v4, v10, v31
add  s10, s10, tp; add  s11, s11, ra;              vrgather.vv v3, v18, v30
lw   ra, 4*4(a1);                                  vmerge.vvm v4, v18, v4, v0
mul  a7, s2, t3;   mul  gp, s3, t3;                vmerge.vvm v3, v3, v10, v0
mul  tp, s6, ra;   mul  ra, s7, ra;                vsub.vv  v21, v21, v22
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v22, v5,  v6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v23, v23, v24
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v24, v7,  v8
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L5 + 0*_ZETAS_EXP_1TO6_P1_L5)*2
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s2, s0, a7;   sub  s3, s1, gp;                vmul.vv  v9,  v2,  v27
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vv v2,  v2,  v26
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v6, v11, v31
lw   gp, 5*4(a1);                                  vrgather.vv v5, v19, v30
add  s5, s5, ra;   add  s4, s4, tp;                vmerge.vvm v6, v19, v6, v0
lw   ra, 6*4(a1);                                  vmerge.vvm v5, v5, v11, v0
mul  a7, s10, gp;  mul  gp, s11, gp;               vrgather.vv v8, v12, v31
mul  tp, a4, ra;   mul  ra, a5, ra;                vrgather.vv v7, v20, v30
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm v8, v20, v8, v0
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm v7, v7, v12, v0
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v17, v4,  v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v4,  v4,  v26
sub  s10, s8, a7;  sub  s11, s9, gp;               vmulh.vx v9,  v9,  t4
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v17, v17, t4
add  s8, s8, a7;   add  s9, s9, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  a2, a2, tp;   add  a3, a3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmul.vv  v10, v6,  v27
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmulh.vv v6,  v6,  v26
mul  a7, s1, a7;   mul  gp, s3, gp;                vsub.vv  v2,  v2,  v9
mul  tp, s5, tp;   mul  ra, s7, ra;                vmulh.vx v10, v10, t4
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v18, v8,  v27
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vv v8,  v8,  v26
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v18, v18, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v4,  v4,  v17
sub  s1, s0, a7;   sub  s3, s2, gp;                vsub.vv  v6,  v6,  v10
add  s0, s0, a7;   lw   a7, 11*4(a1);              vsub.vv  v8,  v8,  v18
add  s2, s2, gp;   lw   gp, 12*4(a1);              vadd.vv  v9,  v1,  v2
mul  a7, s9, a7;   mul  gp, s11, gp;               vsub.vv  v11, v1,  v2
sub  s5, s4, tp;   sub  s7, s6, ra;                vadd.vv  v17, v3,  v4
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v19, v3,  v4
add  s6, s6, ra;   lw   ra, 14*4(a1);              vadd.vv  v10, v5,  v6
mul  tp, a3, tp;   mul  ra, a5, ra;                vsub.vv  v12, v5,  v6
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v2, v13, v31
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v1, v21, v30
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm v2, v21, v2, v0
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm v1, v1, v13, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v4, v14, v31
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v3, v22, v30
sub  s9, s8, a7;   sub  s11, s10, gp;              vmerge.vvm v4, v22, v4, v0
add  s8, s8, a7;   add  s10, s10, gp;              vmerge.vvm v3, v3, v14, v0
sub  a3, a2, tp;   sub  a5, a4, ra;                vadd.vv  v18, v7,  v8
add  a2, a2, tp;   add  a4, a4, ra;                vsub.vv  v20, v7,  v8
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vrgather.vv v6, v15, v31
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vrgather.vv v5, v23, v30
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmerge.vvm v6, v23, v6, v0
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmerge.vvm v5, v5, v15, v0
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vrgather.vv v8, v16, v31
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vrgather.vv v7, v24, v30
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmerge.vvm v8, v24, v8, v0
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vmerge.vvm v7, v7, v16, v0
addi a0, a0, -2;                                   addi t6, t6, 8*2;     vle16.v v27, (t6)
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         addi t6, t6, 8*2;     vle16.v v26, (t6)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         vmul.vv  v13, v2,  v27
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vv v2,  v2,  v26
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vmulh.vx v13, v13, t4
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         addi t6, t6, 8*2;     vle16.v v27, (t6)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        addi t6, t6, 8*2;     vle16.v v26, (t6)
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vmul.vv  v21, v4,  v27
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vmulh.vv v4,  v4,  v26
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v21, v21, t4
mul  tp, s10, t0;  mul  ra, s11, t0;               addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v14, v6,  v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v6,  v6,  v26
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v14, v14, t4
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vv  v22, v8,  v27
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vv v8,  v8,  v26
mul  a7, a2, t0;   mul  gp, a3, t0;                vsub.vv  v2,  v2, v13
sub  s10, s2, tp;  sub  s11, s3, ra;               vsub.vv  v4,  v4, v21
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v22, v22, t4
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v6,  v6, v14
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v8,  v8, v22
addi a7, a7, 8;    addi gp, gp, 8;                 lw t6, 4*16(sp)
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v13, v1,  v2
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v15, v1,  v2
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v21, v3,  v4
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v23, v3,  v4
add  s4, s4, a7;   add  s5, s5, gp;                vadd.vv  v14, v5,  v6
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v16, v5,  v6
add  s6, s6, tp;   add  s7, s7, ra;                vrgather.vv v1, v11, v29
mul  a7, s4, t1;   mul  gp, s5, t1;                vmerge.vvm  v1, v1, v9, v0
mul  tp, s6, t1;   mul  ra, s7, t1;                vrgather.vv v2, v9, v28
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v2, v11, v2, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v22, v7,  v8
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v24, v7,  v8
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v3, v19, v29
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v3, v3, v17, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v4, v17, v28
sub  s4, s0, a7;   sub  s5, s1, gp;                vmerge.vvm  v4, v19, v4, v0
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L6+ 0*_ZETAS_EXP_1TO6_P1_L6)*2
mul  a7, a2, t2;   mul  gp, a3, t2;                vle16.v v27, (t6)
sub  s6, s2, tp;   sub  s7, s3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vv  v9,  v2,  v27
mul  tp, a4, t2;   mul  ra, a5, t2;                vmulh.vv v2,  v2,  v26
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v5, v12, v29
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v5, v5, v10, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v6, v10, v28
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v6, v12, v6, v0
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  a2, s8, a7;   sub  a3, s9, gp;                vmul.vv  v11, v4,  v27
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vv v4,  v4,  v26
sub  a4, s10, tp;  sub  a5, s11, ra;               vrgather.vv v7, v20, v29
add  s10, s10, tp; add  s11, s11, ra;              vmerge.vvm  v7, v7, v18, v0
lw   ra, 4*4(a1);                                  vrgather.vv v8, v18, v28
mul  a7, s2, t3;   mul  gp, s3, t3;                vmerge.vvm  v8, v20, v8, v0
mul  tp, s6, ra;   mul  ra, s7, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v17, v6,  v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v6,  v6,  v26
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v19, v8,  v27
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vv v8,  v8,  v26
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vx v9,  v9,  t4
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v11, v11, t4
lw   gp, 5*4(a1);                                  vmulh.vx v17, v17, t4
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v19, v19, t4
lw   ra, 6*4(a1);                                  vsub.vv  v2,  v2,  v9
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v4,  v4,  v11
mul  tp, a4, ra;   mul  ra, a5, ra;                vsub.vv  v6,  v6,  v17
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v8,  v8,  v19
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v9,  v1,  v2
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11, v1,  v2
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v17, v3,  v4
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v19, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v1, v15, v29
sub  s10, s8, a7;  sub  s11, s9, gp;               vmerge.vvm  v1, v1, v13, v0
sub  a4, a2, tp;   sub  a5, a3, ra;                vrgather.vv v2, v13, v28
add  s8, s8, a7;   add  s9, s9, gp;                vmerge.vvm  v2, v15, v2, v0
add  a2, a2, tp;   add  a3, a3, ra;                vadd.vv  v10, v5,  v6
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vsub.vv  v12, v5,  v6
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vadd.vv  v18, v7,  v8
mul  a7, s1, a7;   mul  gp, s3, gp;                vsub.vv  v20, v7,  v8
mul  tp, s5, tp;   mul  ra, s7, ra;                vrgather.vv v3, v23, v29
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v3, v3, v21, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v4, v21, v28
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v4, v23, v4, v0
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v13, v2,  v27
sub  s1, s0, a7;   sub  s3, s2, gp;                vmulh.vv v2,  v2,  v26
add  s0, s0, a7;   lw   a7, 11*4(a1);              vrgather.vv v5, v16, v29
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmerge.vvm  v5, v5, v14, v0
mul  a7, s9, a7;   mul  gp, s11, gp;               vrgather.vv v6, v14, v28
sub  s5, s4, tp;   sub  s7, s6, ra;                vmerge.vvm  v6, v16, v6, v0
add  s4, s4, tp;   lw   tp, 13*4(a1);              addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s6, s6, ra;   lw   ra, 14*4(a1);              addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, a3, tp;   mul  ra, a5, ra;                vmul.vv  v15, v4,  v27
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vv v4,  v4,  v26
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v7, v24, v29
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v7, v7, v22, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v8, v22, v28
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v8, v24, v8, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s9, s8, a7;   sub  s11, s10, gp;              addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s8, s8, a7;   add  s10, s10, gp;              vmul.vv  v21, v6,  v27
sub  a3, a2, tp;   sub  a5, a4, ra;                vmulh.vv v6,  v6,  v26
add  a2, a2, tp;   add  a4, a4, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         addi t6, t6, 8*2;     vle16.v v26, (t6)
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vmul.vv  v23, v8,  v27
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vv v8,  v8,  v26
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmulh.vx v13, v13, t4
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vmulh.vx v15, v15, t4
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vx v21, v21, t4
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmulh.vx v23, v23, t4
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vsub.vv  v2,  v2,  v13
addi a0, a0, -2;                                   vsub.vv  v4,  v4,  v15
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vsub.vv  v6,  v6,  v21
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         vsub.vv  v8,  v8,  v23
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vadd.vv  v13, v1,  v2
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vsub.vv  v15, v1,  v2
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         lw t6, 4*16(sp)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vadd.vv  v21, v3,  v4
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v23, v3,  v4
mul  tp, s10, t0;  mul  ra, s11, t0;               vrgather.vv v1, v11, v27
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v2, v9, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v1, v1, v9, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v2, v11, v2, v0
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v14, v5,  v6
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v16, v5,  v6
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v3, v19, v27
sub  s8, s0, a7;   sub  s9, s1, gp;                vrgather.vv v4, v17, v27
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v3, v3, v17, v0
mul  a7, a2, t0;   mul  gp, a3, t0;                vmerge.vvm  v4, v19, v4, v0
sub  s10, s2, tp;  sub  s11, s3, ra;               vadd.vv  v22, v7,  v8
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v24, v7,  v8
mul  tp, a4, t0;   mul  ra, a5, t0;                vrgather.vv v5, v12, v27
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v6, v10, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v5, v5, v10, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v6, v12, v6, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v7, v20, v27
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v8, v18, v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v7, v7, v18, v0
sub  a2, s4, a7;   sub  a3, s5, gp;                vmerge.vvm  v8, v20, v8, v0
add  s4, s4, a7;   add  s5, s5, gp;                vrgather.vv v9, v15, v27
sub  a4, s6, tp;   sub  a5, s7, ra;                vrgather.vv v11, v13, v27
add  s6, s6, tp;   add  s7, s7, ra;                vmerge.vvm  v9, v9, v13, v0
mul  a7, s4, t1;   mul  gp, s5, t1;                vmerge.vvm  v11, v15, v11, v0
mul  tp, s6, t1;   mul  ra, s7, t1;                vrgather.vv v17, v23, v27
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v19, v21, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v17, v17, v21, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v19, v23, v19, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v10, v16, v27
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v12, v14, v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v10, v10, v14, v0
sub  s4, s0, a7;   sub  s5, s1, gp;                vmerge.vvm  v12, v16, v12, v0
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v18, v24, v27
mul  a7, a2, t2;   mul  gp, a3, t2;                vrgather.vv v20, v22, v27
sub  s6, s2, tp;   sub  s7, s3, ra;                vmerge.vvm  v18, v18, v22, v0
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm  v20, v24, v20, v0
mul  tp, a4, t2;   mul  ra, a5, t2;                lw   t5, 4*15(sp);   addi t5, t5, (0*128)*2
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v1,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v2,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v3,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v4,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v5,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v6,  (t5);  addi t5, t5, 16
sub  a2, s8, a7;   sub  a3, s9, gp;                vse16.v  v7,  (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp;                vse16.v  v8,  (t5);  addi t5, t5, -16*7-(0*128)*2+(64+0*128)*2
sub  a4, s10, tp;  sub  a5, s11, ra;               vse16.v  v9,  (t5);  addi t5, t5, 16
add  s10, s10, tp; add  s11, s11, ra;              vse16.v  v11, (t5);  addi t5, t5, 16
lw   ra, 4*4(a1);                                  vse16.v  v17, (t5);  addi t5, t5, 16
mul  a7, s2, t3;   mul  gp, s3, t3;                vse16.v  v19, (t5);  addi t5, t5, 16
mul  tp, s6, ra;   mul  ra, s7, ra;                vse16.v  v10, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v12, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v18, (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v20, (t5)
addi tp, tp, 8;    addi ra, ra, 8;                 lw   t5, 4*15(sp);  addi t5, t5, (64+1*128)*2
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v9,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v10, (t5);  addi t5, t5, 16
sub  s2, s0, a7;   sub  s3, s1, gp;                vle16.v v11, (t5);  addi t5, t5, 16
sub  s6, s4, tp;   sub  s7, s5, ra;                vle16.v v12, (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v v13, (t5);  addi t5, t5, 16
lw   gp, 5*4(a1);                                  vle16.v v14, (t5);  addi t5, t5, 16
add  s5, s5, ra;   add  s4, s4, tp;                vle16.v v15, (t5);  addi t5, t5, 16
lw   ra, 6*4(a1);                                  vle16.v v16, (t5);  addi t5, t5, -16*7-(64+1*128)*2+(1*128)*2
mul  a7, s10, gp;  mul  gp, s11, gp;               vle16.v v1,  (t5);  addi t5, t5, 16
mul  tp, a4, ra;   mul  ra, a5, ra;                vle16.v v2,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v3,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v v4,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v5,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v6,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v7,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v8,  (t5)
sub  s10, s8, a7;  sub  s11, s9, gp;               lw t6, 4*16(sp)
sub  a4, a2, tp;   sub  a5, a3, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
add  s8, s8, a7;   add  s9, s9, gp;                lh t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
add  a2, a2, tp;   add  a3, a3, ra;                vmul.vx v17, v9,  t5
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmul.vx v18, v10, t5
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmul.vx v19, v11, t5
mul  a7, s1, a7;   mul  gp, s3, gp;                vmul.vx v20, v12, t5
mul  tp, s5, tp;   mul  ra, s7, ra;                vmul.vx v21, v13, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v22, v14, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v23, v15, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v24, v16, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v9,  v9,  t6
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v10, v10, t6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v11, v11, t6
sub  s1, s0, a7;   sub  s3, s2, gp;                vmulh.vx v12, v12, t6
add  s0, s0, a7;   lw   a7, 11*4(a1);              vmulh.vx v13, v13, t6
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmulh.vx v14, v14, t6
mul  a7, s9, a7;   mul  gp, s11, gp;               vmulh.vx v15, v15, t6
sub  s5, s4, tp;   sub  s7, s6, ra;                vmulh.vx v16, v16, t6
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmulh.vx v21, v21, t4
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmulh.vx v22, v22, t4
mul  tp, a3, tp;   mul  ra, a5, ra;                vmulh.vx v23, v23, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v24, v24, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v13, v13, v21
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v14, v14, v22
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v15, v15, v23
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v16, v16, v24
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v17, v17, t4
sub  s9, s8, a7;   sub  s11, s10, gp;              vsub.vv  v21, v5, v13
add  s8, s8, a7;   add  s10, s10, gp;              vmulh.vx v18, v18, t4
sub  a3, a2, tp;   sub  a5, a4, ra;                vsub.vv  v22, v6, v14
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v19, v19, t4
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vsub.vv  v23, v7, v15
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vmulh.vx v20, v20, t4
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vsub.vv  v24, v8, v16
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vsub.vv  v9,  v9,  v17
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vsub.vv  v10, v10, v18
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vsub.vv  v11, v11, v19
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vsub.vv  v12, v12, v20
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vsub.vv  v17, v1, v9
addi a0, a0, -2;                                   vsub.vv  v18, v2, v10
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vsub.vv  v19, v3, v11
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         vsub.vv  v20, v4, v12
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vadd.vv  v13, v5, v13
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vadd.vv  v14, v6, v14
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vadd.vv  v15, v7, v15
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vadd.vv  v16, v8, v16
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vadd.vv  v9, v1, v9
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vadd.vv  v10, v2, v10
mul  a7, s8, t0;   mul  gp, s9, t0;                vadd.vv  v11, v3, v11
mul  tp, s10, t0;  mul  ra, s11, t0;               vadd.vv  v12, v4, v12
srai a7, a7, 16;   srai gp, gp, 16;                lw t6, 4*16(sp)
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v1, v13, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v2, v14, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v3, v15, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v4, v16, t5
sub  s8, s0, a7;   sub  s9, s1, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vx v5, v21, t5
mul  a7, a2, t0;   mul  gp, a3, t0;                vmul.vx v6, v22, t5
sub  s10, s2, tp;  sub  s11, s3, ra;               vmul.vx v7, v23, t5
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vx v8, v24, t5
mul  tp, a4, t0;   mul  ra, a5, t0;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v13, v13, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v14, v14, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v15, v15, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v16, v16, t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v21, v21, t5
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v22, v22, t5
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v23, v23, t5
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v24, v24, t5
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v1, v1, t4
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v2, v2, t4
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v3, v3, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v4, v4, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v13, v13, v1
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v14, v14, v2
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v15, v15, v3
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v16, v16, v4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v5, v5, t4
sub  s4, s0, a7;   sub  s5, s1, gp;                vadd.vv  v1, v9,  v13
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v6, v6, t4
mul  a7, a2, t2;   mul  gp, a3, t2;                vadd.vv  v2, v10, v14
sub  s6, s2, tp;   sub  s7, s3, ra;                vmulh.vx v7, v7, t4
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v3, v11, v15
mul  tp, a4, t2;   mul  ra, a5, t2;                vmulh.vx v8, v8, t4
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v4, v12, v16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v21, v21, v5
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v22, v22, v6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v23, v23, v7
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v24, v24, v8
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v5, v17, v21
sub  a2, s8, a7;   sub  a3, s9, gp;                vadd.vv  v6, v18, v22
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v7, v19, v23
sub  a4, s10, tp;  sub  a5, s11, ra;               vadd.vv  v8, v20, v24
add  s10, s10, tp; add  s11, s11, ra;              vsub.vv  v9, v9,  v13
lw   ra, 4*4(a1);                                  vsub.vv  v10, v10,v14
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v11,v11, v15
mul  tp, s6, ra;   mul  ra, s7, ra;                vsub.vv  v12,v12, v16
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v13,v17, v21
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v14,v18, v22
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v15,v19, v23
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v16,v20, v24
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v17, v3,  t5
sub  s2, s0, a7;   sub  s3, s1, gp;                vmul.vx v18, v4,  t5
sub  s6, s4, tp;   sub  s7, s5, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vx v19, v11, t5
lw   gp, 5*4(a1);                                  vmul.vx v20, v12, t5
add  s5, s5, ra;   add  s4, s4, tp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
lw   ra, 6*4(a1);                                  vmul.vx v21, v7,  t5
mul  a7, s10, gp;  mul  gp, s11, gp;               vmul.vx v22, v8,  t5
mul  tp, a4, ra;   mul  ra, a5, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v23, v15, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v24, v16, t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v3,  v3,  t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v4,  v4,  t5
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
sub  s10, s8, a7;  sub  s11, s9, gp;               vmulh.vx v11, v11, t5
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v12, v12, t5
add  s8, s8, a7;   add  s9, s9, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
add  a2, a2, tp;   add  a3, a3, ra;                vmulh.vx v7,  v7,  t5
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmulh.vx v8,  v8,  t5
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
mul  a7, s1, a7;   mul  gp, s3, gp;                vmulh.vx v15, v15, t5
mul  tp, s5, tp;   mul  ra, s7, ra;                vmulh.vx v16, v16, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v17, v17, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v18, v18, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v19, v19, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v20, v20, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v3,  v3,  v17
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v4,  v4,  v18
sub  s1, s0, a7;   sub  s3, s2, gp;                vsub.vv  v11, v11, v19
add  s0, s0, a7;   lw   a7, 11*4(a1);              vsub.vv  v12, v12, v20
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmulh.vx v21, v21, t4
mul  a7, s9, a7;   mul  gp, s11, gp;               vadd.vv  v17, v1,  v3
sub  s5, s4, tp;   sub  s7, s6, ra;                vmulh.vx v22, v22, t4
add  s4, s4, tp;   lw   tp, 13*4(a1);              vadd.vv  v18, v2,  v4
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmulh.vx v23, v23, t4
mul  tp, a3, tp;   mul  ra, a5, ra;                vadd.vv  v19, v9,  v11
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v24, v24, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v20, v10, v12
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v7,  v7,  v21
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v8,  v8,  v22
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v15, v15, v23
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v16, v16, v24
sub  s9, s8, a7;   sub  s11, s10, gp;              vadd.vv  v21, v5,  v7
add  s8, s8, a7;   add  s10, s10, gp;              vadd.vv  v22, v6,  v8
sub  a3, a2, tp;   sub  a5, a4, ra;                vadd.vv  v23, v13, v15
add  a2, a2, tp;   add  a4, a4, ra;                vadd.vv  v24, v14, v16
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vsub.vv  v1,  v1,  v3
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vsub.vv  v2,  v2,  v4
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vsub.vv  v3,  v9,  v11
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vsub.vv  v4,  v10, v12
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vsub.vv  v5,  v5,  v7
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vsub.vv  v6,  v6,  v8
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vsub.vv  v7,  v13, v15
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vsub.vv  v8,  v14, v16
addi a0, a0, -2;                                   lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vmul.vx v9,  v18,  t5
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmulh.vx v18, v18, t5
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vmul.vx v10, v2,   t5
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vmulh.vx v2,  v2,  t5
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmul.vx v11, v20,  t5
mul  tp, s10, t0;  mul  ra, s11, t0;               lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v20, v20, t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v12, v4,   t5
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v4,  v4,  t5
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vx v13, v22,  t5
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v22, v22, t5
sub  s10, s2, tp;  sub  s11, s3, ra;               lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vx v14, v6,   t5
mul  tp, a4, t0;   mul  ra, a5, t0;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v6,  v6,  t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v15, v24,  t5
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v24, v24, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
sub  a2, s4, a7;   sub  a3, s5, gp;                vmul.vx v16, v8,   t5
add  s4, s4, a7;   add  s5, s5, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v8,  v8,  t5
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v9,  v9,  t4
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v10, v10, t4
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v11, v11, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v12, v12, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v18, v18, v9
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v2,  v2,  v10
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v20, v20, v11
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v4,  v4,  v12
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v13, v13, t4
sub  s4, s0, a7;   sub  s5, s1, gp;                vadd.vv  v9,  v17, v18
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v14, v14, t4
mul  a7, a2, t2;   mul  gp, a3, t2;                vadd.vv  v10, v1,  v2
sub  s6, s2, tp;   sub  s7, s3, ra;                vmulh.vx v15, v15, t4
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v11, v19, v20
mul  tp, a4, t2;   mul  ra, a5, t2;                vmulh.vx v16, v16, t4
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v12, v3, v4
addi a7, a7, 8;    addi gp, gp, 8;                 addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v22, v22, v13
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v6,  v6,  v14
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v24, v24, v15
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v8,  v8,  v16
sub  a2, s8, a7;   sub  a3, s9, gp;                vsub.vv  v17, v17, v18
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v18, v1,  v2
sub  a4, s10, tp;  sub  a5, s11, ra;               vsub.vv  v19, v19, v20
add  s10, s10, tp; add  s11, s11, ra;              vsub.vv  v20, v3,  v4
lw   ra, 4*4(a1);                                  vadd.vv  v13, v21,  v22
mul  a7, s2, t3;   mul  gp, s3, t3;                vadd.vv  v14, v5,  v6
mul  tp, s6, ra;   mul  ra, s7, ra;                vadd.vv  v15, v23, v24
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v2, v9, v31
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v1, v17, v30
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm v2, v17, v2, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v1, v1, v9, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v16, v7, v8
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v4, v10, v31
sub  s2, s0, a7;   sub  s3, s1, gp;                vrgather.vv v3, v18, v30
sub  s6, s4, tp;   sub  s7, s5, ra;                vmerge.vvm v4, v18, v4, v0
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm v3, v3, v10, v0
lw   gp, 5*4(a1);                                  vsub.vv  v21, v21, v22
add  s5, s5, ra;   add  s4, s4, tp;                vsub.vv  v22, v5,  v6
lw   ra, 6*4(a1);                                  vsub.vv  v23, v23, v24
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v24, v7,  v8
mul  tp, a4, ra;   mul  ra, a5, ra;                addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L5 + 1*_ZETAS_EXP_1TO6_P1_L5)*2
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v9,  v2,  v27
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v2,  v2,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v6, v11, v31
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v5, v19, v30
sub  s10, s8, a7;  sub  s11, s9, gp;               vmerge.vvm v6, v19, v6, v0
sub  a4, a2, tp;   sub  a5, a3, ra;                vmerge.vvm v5, v5, v11, v0
add  s8, s8, a7;   add  s9, s9, gp;                vrgather.vv v8, v12, v31
add  a2, a2, tp;   add  a3, a3, ra;                vrgather.vv v7, v20, v30
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmerge.vvm v8, v20, v8, v0
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmerge.vvm v7, v7, v12, v0
mul  a7, s1, a7;   mul  gp, s3, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s5, tp;   mul  ra, s7, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v17, v4,  v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v4,  v4,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v9,  v9,  t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v17, v17, t4
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s1, s0, a7;   sub  s3, s2, gp;                vmul.vv  v10, v6,  v27
add  s0, s0, a7;   lw   a7, 11*4(a1);              vmulh.vv v6,  v6,  v26
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v2,  v2,  v9
mul  a7, s9, a7;   mul  gp, s11, gp;               vmulh.vx v10, v10, t4
sub  s5, s4, tp;   sub  s7, s6, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s4, s4, tp;   lw   tp, 13*4(a1);              addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmul.vv  v18, v8,  v27
mul  tp, a3, tp;   mul  ra, a5, ra;                vmulh.vv v8,  v8,  v26
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v18, v18, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v4,  v4,  v17
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v6,  v6,  v10
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v8,  v8,  v18
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v9,  v1,  v2
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v11, v1,  v2
sub  s9, s8, a7;   sub  s11, s10, gp;              vadd.vv  v17, v3,  v4
add  s8, s8, a7;   add  s10, s10, gp;              vsub.vv  v19, v3,  v4
sub  a3, a2, tp;   sub  a5, a4, ra;                vadd.vv  v10, v5,  v6
add  a2, a2, tp;   add  a4, a4, ra;                vsub.vv  v12, v5,  v6
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vrgather.vv v2, v13, v31
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vrgather.vv v1, v21, v30
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmerge.vvm v2, v21, v2, v0
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmerge.vvm v1, v1, v13, v0
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vrgather.vv v4, v14, v31
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vrgather.vv v3, v22, v30
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmerge.vvm v4, v22, v4, v0
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vmerge.vvm v3, v3, v14, v0
addi a0, a0, -2;                                   vadd.vv  v18, v7,  v8
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vsub.vv  v20, v7,  v8
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         vrgather.vv v6, v15, v31
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vrgather.vv v5, v23, v30
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vmerge.vvm v6, v23, v6, v0
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vmerge.vvm v5, v5, v15, v0
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vrgather.vv v8, v16, v31
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vrgather.vv v7, v24, v30
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vmerge.vvm v8, v24, v8, v0
mul  a7, s8, t0;   mul  gp, s9, t0;                vmerge.vvm v7, v7, v16, v0
mul  tp, s10, t0;  mul  ra, s11, t0;               addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v13, v2,  v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v2,  v2,  v26
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v13, v13, t4
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vv  v21, v4,  v27
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vv v4,  v4,  v26
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v21, v21, t4
sub  s10, s2, tp;  sub  s11, s3, ra;               addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, a4, t0;   mul  ra, a5, t0;                vmul.vv  v14, v6,  v27
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vv v6,  v6,  v26
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v14, v14, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v22, v8,  v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v8,  v8,  v26
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v2,  v2, v13
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v4,  v4, v21
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v22, v22, t4
add  s6, s6, tp;   add  s7, s7, ra;                vsub.vv  v6,  v6, v14
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v8,  v8, v22
mul  tp, s6, t1;   mul  ra, s7, t1;                lw t6, 4*16(sp)
srai a7, a7, 16;   srai gp, gp, 16;                addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v13, v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v15, v1,  v2
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v21, v3,  v4
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v23, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v14, v5,  v6
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v16, v5,  v6
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v1, v11, v29
mul  a7, a2, t2;   mul  gp, a3, t2;                vmerge.vvm  v1, v1, v9, v0
sub  s6, s2, tp;   sub  s7, s3, ra;                vrgather.vv v2, v9, v28
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm  v2, v11, v2, v0
mul  tp, a4, t2;   mul  ra, a5, t2;                vadd.vv  v22, v7,  v8
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v24, v7,  v8
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v3, v19, v29
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v3, v3, v17, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v4, v17, v28
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v4, v19, v4, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L6+ 1*_ZETAS_EXP_1TO6_P1_L6)*2
sub  a2, s8, a7;   sub  a3, s9, gp;                vle16.v v27, (t6)
add  s8, s8, a7;   add  s9, s9, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  a4, s10, tp;  sub  a5, s11, ra;               vmul.vv  v9,  v2,  v27
add  s10, s10, tp; add  s11, s11, ra;              vmulh.vv v2,  v2,  v26
lw   ra, 4*4(a1);                                  vrgather.vv v5, v12, v29
mul  a7, s2, t3;   mul  gp, s3, t3;                vmerge.vvm  v5, v5, v10, v0
mul  tp, s6, ra;   mul  ra, s7, ra;                vrgather.vv v6, v10, v28
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v6, v12, v6, v0
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v11, v4,  v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v4,  v4,  v26
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v7, v20, v29
sub  s2, s0, a7;   sub  s3, s1, gp;                vmerge.vvm  v7, v7, v18, v0
sub  s6, s4, tp;   sub  s7, s5, ra;                vrgather.vv v8, v18, v28
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v8, v20, v8, v0
lw   gp, 5*4(a1);                                  addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s5, s5, ra;   add  s4, s4, tp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
lw   ra, 6*4(a1);                                  vmul.vv  v17, v6,  v27
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vv v6,  v6,  v26
mul  tp, a4, ra;   mul  ra, a5, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v19, v8,  v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v8,  v8,  v26
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v9,  v9,  t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v11, v11, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v17, v17, t4
sub  s10, s8, a7;  sub  s11, s9, gp;               vmulh.vx v19, v19, t4
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v2,  v2,  v9
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v4,  v4,  v11
add  a2, a2, tp;   add  a3, a3, ra;                vsub.vv  v6,  v6,  v17
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vsub.vv  v8,  v8,  v19
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vadd.vv  v9,  v1,  v2
mul  a7, s1, a7;   mul  gp, s3, gp;                vsub.vv  v11, v1,  v2
mul  tp, s5, tp;   mul  ra, s7, ra;                vadd.vv  v17, v3,  v4
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v19, v3,  v4
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v1, v15, v29
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v1, v1, v13, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v2, v13, v28
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v2, v15, v2, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v10, v5,  v6
sub  s1, s0, a7;   sub  s3, s2, gp;                vsub.vv  v12, v5,  v6
add  s0, s0, a7;   lw   a7, 11*4(a1);              vadd.vv  v18, v7,  v8
add  s2, s2, gp;   lw   gp, 12*4(a1);              vsub.vv  v20, v7,  v8
mul  a7, s9, a7;   mul  gp, s11, gp;               vrgather.vv v3, v23, v29
sub  s5, s4, tp;   sub  s7, s6, ra;                vmerge.vvm  v3, v3, v21, v0
add  s4, s4, tp;   lw   tp, 13*4(a1);              vrgather.vv v4, v21, v28
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmerge.vvm  v4, v23, v4, v0
mul  tp, a3, tp;   mul  ra, a5, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v13, v2,  v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v2,  v2,  v26
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v5, v16, v29
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v5, v5, v14, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v6, v14, v28
sub  s9, s8, a7;   sub  s11, s10, gp;              vmerge.vvm  v6, v16, v6, v0
add  s8, s8, a7;   add  s10, s10, gp;              addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  a3, a2, tp;   sub  a5, a4, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  a2, a2, tp;   add  a4, a4, ra;                vmul.vv  v15, v4,  v27
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmulh.vv v4,  v4,  v26
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vrgather.vv v7, v24, v29
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmerge.vvm  v7, v7, v22, v0
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vrgather.vv v8, v22, v28
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vmerge.vvm  v8, v24, v8, v0
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        addi t6, t6, 8*2;     vle16.v v27, (t6)
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        addi t6, t6, 8*2;     vle16.v v26, (t6)
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vmul.vv  v21, v6,  v27
addi a0, a0, -2;                                   vmulh.vv v6,  v6,  v26
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         addi t6, t6, 8*2;     vle16.v v27, (t6)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         addi t6, t6, 8*2;     vle16.v v26, (t6)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmul.vv  v23, v8,  v27
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vmulh.vv v8,  v8,  v26
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vmulh.vx v13, v13, t4
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmulh.vx v15, v15, t4
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vmulh.vx v21, v21, t4
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vmulh.vx v23, v23, t4
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v2,  v2,  v13
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v4,  v4,  v15
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v6,  v6,  v21
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v8,  v8,  v23
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v13, v1,  v2
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v15, v1,  v2
addi tp, tp, 8;    addi ra, ra, 8;                 lw t6, 4*16(sp)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
sub  s8, s0, a7;   sub  s9, s1, gp;                addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v21, v3,  v4
mul  a7, a2, t0;   mul  gp, a3, t0;                vsub.vv  v23, v3,  v4
sub  s10, s2, tp;  sub  s11, s3, ra;               vrgather.vv v1, v11, v27
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v2, v9, v27
mul  tp, a4, t0;   mul  ra, a5, t0;                vmerge.vvm  v1, v1, v9, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v2, v11, v2, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v14, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v16, v5,  v6
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v3, v19, v27
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v4, v17, v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v3, v3, v17, v0
sub  a2, s4, a7;   sub  a3, s5, gp;                vmerge.vvm  v4, v19, v4, v0
add  s4, s4, a7;   add  s5, s5, gp;                vadd.vv  v22, v7,  v8
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v24, v7,  v8
add  s6, s6, tp;   add  s7, s7, ra;                vrgather.vv v5, v12, v27
mul  a7, s4, t1;   mul  gp, s5, t1;                vrgather.vv v6, v10, v27
mul  tp, s6, t1;   mul  ra, s7, t1;                vmerge.vvm  v5, v5, v10, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v6, v12, v6, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v7, v20, v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v8, v18, v27
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v7, v7, v18, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v8, v20, v8, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v9, v15, v27
sub  s4, s0, a7;   sub  s5, s1, gp;                vrgather.vv v11, v13, v27
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v9, v9, v13, v0
mul  a7, a2, t2;   mul  gp, a3, t2;                vmerge.vvm  v11, v15, v11, v0
sub  s6, s2, tp;   sub  s7, s3, ra;                vrgather.vv v17, v23, v27
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v19, v21, v27
mul  tp, a4, t2;   mul  ra, a5, t2;                vmerge.vvm  v17, v17, v21, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v19, v23, v19, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v10, v16, v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v12, v14, v27
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v10, v10, v14, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v12, v16, v12, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v18, v24, v27
sub  a2, s8, a7;   sub  a3, s9, gp;                vrgather.vv v20, v22, v27
add  s8, s8, a7;   add  s9, s9, gp;                vmerge.vvm  v18, v18, v22, v0
sub  a4, s10, tp;  sub  a5, s11, ra;               vmerge.vvm  v20, v24, v20, v0
add  s10, s10, tp; add  s11, s11, ra;              lw   t5, 4*15(sp);   addi t5, t5, (1*128)*2
lw   ra, 4*4(a1);                                  vse16.v  v1,  (t5);  addi t5, t5, 16
mul  a7, s2, t3;   mul  gp, s3, t3;                vse16.v  v2,  (t5);  addi t5, t5, 16
mul  tp, s6, ra;   mul  ra, s7, ra;                vse16.v  v3,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v4,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v5,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v6,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v7,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v8,  (t5);  addi t5, t5, -16*7-(1*128)*2+(64+1*128)*2
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v9,  (t5);  addi t5, t5, 16
sub  s2, s0, a7;   sub  s3, s1, gp;                vse16.v  v11, (t5);  addi t5, t5, 16
sub  s6, s4, tp;   sub  s7, s5, ra;                vse16.v  v17, (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v19, (t5);  addi t5, t5, 16
lw   gp, 5*4(a1);                                  vse16.v  v10, (t5);  addi t5, t5, 16
add  s5, s5, ra;   add  s4, s4, tp;                vse16.v  v12, (t5);  addi t5, t5, 16
lw   ra, 6*4(a1);                                  vse16.v  v18, (t5);  addi t5, t5, 16
mul  a7, s10, gp;  mul  gp, s11, gp;               vse16.v  v20, (t5)
mul  tp, a4, ra;   mul  ra, a5, ra;                lw   t5, 4*15(sp)
srai a7, a7, 16;   srai gp, gp, 16;                addi t5, t5, (64*0+128)*2   
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v v8,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v9,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v10, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v11, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v12, (t5);  addi t5, t5, 16
sub  s10, s8, a7;  sub  s11, s9, gp;               vle16.v v13, (t5);  addi t5, t5, 16
sub  a4, a2, tp;   sub  a5, a3, ra;                vle16.v v14, (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v v15, (t5);  addi t5, t5, -((64*0+128)*2+16*7)
add  a2, a2, tp;   add  a3, a3, ra;                vle16.v v16, (t5);  addi t5, t5, 16
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vle16.v v17, (t5);  addi t5, t5, 16
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vle16.v v18, (t5);  addi t5, t5, 16
mul  a7, s1, a7;   mul  gp, s3, gp;                vle16.v v19, (t5);  addi t5, t5, 16
mul  tp, s5, tp;   mul  ra, s7, ra;                vle16.v v20, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v21, (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v22, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v23, (t5);  addi t5, t5, -16*7
srai tp, tp, 16;   srai ra, ra, 16;                sw t5, 4*15(sp)
addi tp, tp, 8;    addi ra, ra, 8;                 lw t6, 4*16(sp)
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, (_ZETAS_EXP+0)*2(t6)
sub  s1, s0, a7;   sub  s3, s2, gp;                lh t6, (_ZETAS_EXP+1)*2(t6)
add  s0, s0, a7;   lw   a7, 11*4(a1);              vmul.vx v0, v8, t5
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmul.vx v1, v9, t5
mul  a7, s9, a7;   mul  gp, s11, gp;               vmul.vx v2, v10, t5
sub  s5, s4, tp;   sub  s7, s6, ra;                vmul.vx v3, v11, t5
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmul.vx v4, v12, t5
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmul.vx v5, v13, t5
mul  tp, a3, tp;   mul  ra, a5, ra;                vmul.vx v6, v14, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v7, v15, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v8,  v8, t6
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v9,  v9, t6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v10, v10, t6
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v11, v11, t6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v12, v12, t6
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v13, v13, t6
add  s8, s8, a7;   add  s10, s10, gp;              vmulh.vx v14, v14, t6
sub  a3, a2, tp;   sub  a5, a4, ra;                vmulh.vx v15, v15, t6
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v0, v0, t4
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmulh.vx v1, v1, t4
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vmulh.vx v2, v2, t4
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v3, v3, t4
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmulh.vx v4, v4, t4
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vmulh.vx v5, v5, t4
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmulh.vx v6, v6, t4
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmulh.vx v7, v7, t4
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vsub.vv  v8,  v8,  v0
addi a0, a0, -2;                                   vsub.vv  v9,  v9,  v1
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vsub.vv  v10, v10, v2
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         vsub.vv  v11, v11, v3
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vsub.vv  v12, v12, v4
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vsub.vv  v13, v13, v5
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vsub.vv  v14, v14, v6
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vsub.vv  v15, v15, v7
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vadd.vv  v0, v16, v8
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vadd.vv  v1, v17, v9
mul  a7, s8, t0;   mul  gp, s9, t0;                vadd.vv  v2, v18, v10
mul  tp, s10, t0;  mul  ra, s11, t0;               vadd.vv  v3, v19, v11
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v4, v20, v12
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v5, v21, v13
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v6, v22, v14
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v7, v23, v15
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v8, v16, v8
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v9, v17, v9
sub  s8, s0, a7;   sub  s9, s1, gp;                vsub.vv  v10, v18, v10
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v11, v19, v11
mul  a7, a2, t0;   mul  gp, a3, t0;                vsub.vv  v12, v20, v12
sub  s10, s2, tp;  sub  s11, s3, ra;               vsub.vv  v13, v21, v13
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v14, v22, v14
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v15, v23, v15
srai a7, a7, 16;   srai gp, gp, 16;                lw t5, 4*15(sp)
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v0,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v1,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v2,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v3,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v4,  (t5);  addi t5, t5, 16
sub  a2, s4, a7;   sub  a3, s5, gp;                vse16.v  v5,  (t5);  addi t5, t5, 16
add  s4, s4, a7;   add  s5, s5, gp;                vse16.v  v6,  (t5);  addi t5, t5, 16
sub  a4, s6, tp;   sub  a5, s7, ra;                vse16.v  v7,  (t5);  addi t5, t5, (64*0+128)*2-16*7
add  s6, s6, tp;   add  s7, s7, ra;                vse16.v  v8,  (t5);  addi t5, t5, 16
mul  a7, s4, t1;   mul  gp, s5, t1;                vse16.v  v9,  (t5);  addi t5, t5, 16
mul  tp, s6, t1;   mul  ra, s7, t1;                vse16.v  v10, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v11, (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v12, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v13, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v14, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v15, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v  v24, (t5);  addi t5, t5, 16
sub  s4, s0, a7;   sub  s5, s1, gp;                vle16.v  v25, (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v  v26, (t5);  addi t5, t5, 16
mul  a7, a2, t2;   mul  gp, a3, t2;                vle16.v  v27, (t5);  addi t5, t5, 16
sub  s6, s2, tp;   sub  s7, s3, ra;                vle16.v  v28, (t5);  addi t5, t5, 16
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v  v29, (t5);  addi t5, t5, 16
mul  tp, a4, t2;   mul  ra, a5, t2;                vle16.v  v30, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v  v31, (t5);  addi t5, t5, -(128*2)-16*7
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v  v16, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v  v17, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v  v18, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v  v19, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v  v20, (t5);  addi t5, t5, 16
sub  a2, s8, a7;   sub  a3, s9, gp;                vle16.v  v21, (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v  v22, (t5);  addi t5, t5, 16
sub  a4, s10, tp;  sub  a5, s11, ra;               vle16.v  v23, (t5);  addi t5, t5, -16*7
add  s10, s10, tp; add  s11, s11, ra;              sw t5, 4*15(sp)
lw   ra, 4*4(a1);                                  lw t6, 4*16(sp)
mul  a7, s2, t3;   mul  gp, s3, t3;                lh t5, (_ZETAS_EXP+0)*2(t6)
mul  tp, s6, ra;   mul  ra, s7, ra;                lh t6, (_ZETAS_EXP+1)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v0, v24, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v1, v25, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v2, v26, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v3, v27, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v4, v28, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v5, v29, t5
sub  s2, s0, a7;   sub  s3, s1, gp;                vmul.vx v6, v30, t5
sub  s6, s4, tp;   sub  s7, s5, ra;                vmul.vx v7, v31, t5
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v24, v24, t6
lw   gp, 5*4(a1);                                  vmulh.vx v25, v25, t6
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v26, v26, t6
lw   ra, 6*4(a1);                                  vmulh.vx v27, v27, t6
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vx v28, v28, t6
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v29, v29, t6
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v30, v30, t6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v31, v31, t6
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v0, v0, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v1, v1, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v2, v2, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v3, v3, t4
sub  s10, s8, a7;  sub  s11, s9, gp;               vmulh.vx v4, v4, t4
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v5, v5, t4
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v6, v6, t4
add  a2, a2, tp;   add  a3, a3, ra;                vmulh.vx v7, v7, t4
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vsub.vv  v24, v24, v0
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vsub.vv  v25, v25, v1
mul  a7, s1, a7;   mul  gp, s3, gp;                vsub.vv  v26, v26, v2
mul  tp, s5, tp;   mul  ra, s7, ra;                vsub.vv  v27, v27, v3
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v28, v28, v4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v29, v29, v5
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v30, v30, v6
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v31, v31, v7
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v0, v16, v24
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v1, v17, v25
sub  s1, s0, a7;   sub  s3, s2, gp;                vadd.vv  v2, v18, v26
add  s0, s0, a7;   lw   a7, 11*4(a1);              vadd.vv  v3, v19, v27
add  s2, s2, gp;   lw   gp, 12*4(a1);              vadd.vv  v4, v20, v28
mul  a7, s9, a7;   mul  gp, s11, gp;               vadd.vv  v5, v21, v29
sub  s5, s4, tp;   sub  s7, s6, ra;                vadd.vv  v6, v22, v30
add  s4, s4, tp;   lw   tp, 13*4(a1);              vadd.vv  v7, v23, v31
add  s6, s6, ra;   lw   ra, 14*4(a1);              vsub.vv  v24, v16, v24
mul  tp, a3, tp;   mul  ra, a5, ra;                vsub.vv  v25, v17, v25
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v26, v18, v26
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v27, v19, v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v28, v20, v28
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v29, v21, v29
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v30, v22, v30
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v31, v23, v31
sub  s9, s8, a7;   sub  s11, s10, gp;              lw t5, 4*15(sp)
add  s8, s8, a7;   add  s10, s10, gp;              vse16.v  v0,  (t5);  addi t5, t5, 16
sub  a3, a2, tp;   sub  a5, a4, ra;                vse16.v  v1,  (t5);  addi t5, t5, 16
add  a2, a2, tp;   add  a4, a4, ra;                vse16.v  v2,  (t5);  addi t5, t5, 16
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vse16.v  v3,  (t5);  addi t5, t5, 16
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vse16.v  v4,  (t5);  addi t5, t5, 16
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vse16.v  v5,  (t5);  addi t5, t5, 16
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vse16.v  v6,  (t5);  addi t5, t5, 16
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vse16.v  v7,  (t5);  addi t5, t5, -16*7+128*2
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vse16.v  v24, (t5);  addi t5, t5, 16
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vse16.v  v25, (t5);  addi t5, t5, 16
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vse16.v  v26, (t5);  addi t5, t5, 16
addi a0, a0, -2;                                   vse16.v  v27, (t5);  addi t5, t5, 16
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vse16.v  v28, (t5);  addi t5, t5, 16
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         vse16.v  v29, (t5);  addi t5, t5, 16
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vse16.v  v30, (t5);  addi t5, t5, 16
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vse16.v  v31, (t5);  addi t5, t5, -16*7-192*2
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         sw t5, 4*15(sp)
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        lw t6, 4*16(sp)
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        addi t5, t6, _MASK_45674567*2;      vle16.v v31, (t5)
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        addi t5, t6, _MASK_01230123*2;      vle16.v v30, (t5)
mul  a7, s8, t0;   mul  gp, s9, t0;                addi t5, t6, _MASK_00010045*2;      vle16.v v29, (t5)
mul  tp, s10, t0;  mul  ra, s11, t0;               addi t5, t6, _MASK_23006700*2;      vle16.v v28, (t5)
srai a7, a7, 16;   srai gp, gp, 16;                lw   t5, 4*15(sp);  addi t5, t5, (64+0*128)*2
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v9,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v10, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v v11, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v12, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v13, (t5);  addi t5, t5, 16
sub  s8, s0, a7;   sub  s9, s1, gp;                vle16.v v14, (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v v15, (t5);  addi t5, t5, 16
mul  a7, a2, t0;   mul  gp, a3, t0;                vle16.v v16, (t5);  addi t5, t5, -16*7-(64+0*128)*2+(0*128)*2
sub  s10, s2, tp;  sub  s11, s3, ra;               vle16.v v1,  (t5);  addi t5, t5, 16
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v v2,  (t5);  addi t5, t5, 16
mul  tp, a4, t0;   mul  ra, a5, t0;                vle16.v v3,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v4,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v5,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v6,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v v7,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v8,  (t5)
mulh tp, tp, a6;   mulh ra, ra, a6;                lw t6, 4*16(sp)
sub  a2, s4, a7;   sub  a3, s5, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
add  s4, s4, a7;   add  s5, s5, gp;                lh t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
sub  a4, s6, tp;   sub  a5, s7, ra;                vmul.vx v17, v9,  t5
add  s6, s6, tp;   add  s7, s7, ra;                vmul.vx v18, v10, t5
mul  a7, s4, t1;   mul  gp, s5, t1;                vmul.vx v19, v11, t5
mul  tp, s6, t1;   mul  ra, s7, t1;                vmul.vx v20, v12, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v21, v13, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v22, v14, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v23, v15, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v24, v16, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v9,  v9,  t6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v10, v10, t6
sub  s4, s0, a7;   sub  s5, s1, gp;                vmulh.vx v11, v11, t6
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v12, v12, t6
mul  a7, a2, t2;   mul  gp, a3, t2;                vmulh.vx v13, v13, t6
sub  s6, s2, tp;   sub  s7, s3, ra;                vmulh.vx v14, v14, t6
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v15, v15, t6
mul  tp, a4, t2;   mul  ra, a5, t2;                vmulh.vx v16, v16, t6
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v21, v21, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v22, v22, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v23, v23, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v24, v24, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v13, v13, v21
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v14, v14, v22
sub  a2, s8, a7;   sub  a3, s9, gp;                vsub.vv  v15, v15, v23
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v16, v16, v24
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vx v17, v17, t4
add  s10, s10, tp; add  s11, s11, ra;              vsub.vv  v21, v5, v13
lw   ra, 4*4(a1);                                  vmulh.vx v18, v18, t4
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v22, v6, v14
mul  tp, s6, ra;   mul  ra, s7, ra;                vmulh.vx v19, v19, t4
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v23, v7, v15
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v20, v20, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v24, v8, v16
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v9,  v9,  v17
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v10, v10, v18
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v11, v11, v19
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v12, v12, v20
sub  s6, s4, tp;   sub  s7, s5, ra;                vsub.vv  v17, v1, v9
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v18, v2, v10
lw   gp, 5*4(a1);                                  vsub.vv  v19, v3, v11
add  s5, s5, ra;   add  s4, s4, tp;                vsub.vv  v20, v4, v12
lw   ra, 6*4(a1);                                  vadd.vv  v13, v5, v13
mul  a7, s10, gp;  mul  gp, s11, gp;               vadd.vv  v14, v6, v14
mul  tp, a4, ra;   mul  ra, a5, ra;                vadd.vv  v15, v7, v15
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v16, v8, v16
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v9, v1, v9
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v10, v2, v10
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v11, v3, v11
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v12, v4, v12
mulh tp, tp, a6;   mulh ra, ra, a6;                lw t6, 4*16(sp)
sub  s10, s8, a7;  sub  s11, s9, gp;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
sub  a4, a2, tp;   sub  a5, a3, ra;                vmul.vx v1, v13, t5
add  s8, s8, a7;   add  s9, s9, gp;                vmul.vx v2, v14, t5
add  a2, a2, tp;   add  a3, a3, ra;                vmul.vx v3, v15, t5
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vmul.vx v4, v16, t5
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
mul  a7, s1, a7;   mul  gp, s3, gp;                vmul.vx v5, v21, t5
mul  tp, s5, tp;   mul  ra, s7, ra;                vmul.vx v6, v22, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v7, v23, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v8, v24, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v13, v13, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v14, v14, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v15, v15, t5
sub  s1, s0, a7;   sub  s3, s2, gp;                vmulh.vx v16, v16, t5
add  s0, s0, a7;   lw   a7, 11*4(a1);              lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmulh.vx v21, v21, t5
mul  a7, s9, a7;   mul  gp, s11, gp;               vmulh.vx v22, v22, t5
sub  s5, s4, tp;   sub  s7, s6, ra;                vmulh.vx v23, v23, t5
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmulh.vx v24, v24, t5
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmulh.vx v1, v1, t4
mul  tp, a3, tp;   mul  ra, a5, ra;                vmulh.vx v2, v2, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v3, v3, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v4, v4, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v13, v13, v1
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v14, v14, v2
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v15, v15, v3
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v16, v16, v4
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v5, v5, t4
add  s8, s8, a7;   add  s10, s10, gp;              vadd.vv  v1, v9,  v13
sub  a3, a2, tp;   sub  a5, a4, ra;                vmulh.vx v6, v6, t4
add  a2, a2, tp;   add  a4, a4, ra;                vadd.vv  v2, v10, v14
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmulh.vx v7, v7, t4
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vadd.vv  v3, v11, v15
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v8, v8, t4
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vadd.vv  v4, v12, v16
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vsub.vv  v21, v21, v5
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vsub.vv  v22, v22, v6
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vsub.vv  v23, v23, v7
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vsub.vv  v24, v24, v8
addi a0, a0, -2;                                   vadd.vv  v5, v17, v21
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vadd.vv  v6, v18, v22
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         vadd.vv  v7, v19, v23
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vadd.vv  v8, v20, v24
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vsub.vv  v9, v9,  v13
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vsub.vv  v10, v10,v14
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vsub.vv  v11,v11, v15
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vsub.vv  v12,v12, v16
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vsub.vv  v13,v17, v21
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v14,v18, v22
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v15,v19, v23
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v16,v20, v24
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v17, v3,  t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v18, v4,  t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v19, v11, t5
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vx v20, v12, t5
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
mul  a7, a2, t0;   mul  gp, a3, t0;                vmul.vx v21, v7,  t5
sub  s10, s2, tp;  sub  s11, s3, ra;               vmul.vx v22, v8,  t5
add  s2, s2, tp;   add  s3, s3, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
mul  tp, a4, t0;   mul  ra, a5, t0;                vmul.vx v23, v15, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v24, v16, t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v3,  v3,  t5
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v4,  v4,  t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v11, v11, t5
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v12, v12, t5
add  s4, s4, a7;   add  s5, s5, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v7,  v7,  t5
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v8,  v8,  t5
mul  a7, s4, t1;   mul  gp, s5, t1;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v15, v15, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v16, v16, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v17, v17, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v18, v18, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v19, v19, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v20, v20, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v3,  v3,  v17
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v4,  v4,  v18
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v11, v11, v19
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v12, v12, v20
sub  s6, s2, tp;   sub  s7, s3, ra;                vmulh.vx v21, v21, t4
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v17, v1,  v3
mul  tp, a4, t2;   mul  ra, a5, t2;                vmulh.vx v22, v22, t4
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v18, v2,  v4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v23, v23, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v19, v9,  v11
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v24, v24, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v20, v10, v12
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v7,  v7,  v21
sub  a2, s8, a7;   sub  a3, s9, gp;                vsub.vv  v8,  v8,  v22
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v15, v15, v23
sub  a4, s10, tp;  sub  a5, s11, ra;               vsub.vv  v16, v16, v24
add  s10, s10, tp; add  s11, s11, ra;              vadd.vv  v21, v5,  v7
lw   ra, 4*4(a1);                                  vadd.vv  v22, v6,  v8
mul  a7, s2, t3;   mul  gp, s3, t3;                vadd.vv  v23, v13, v15
mul  tp, s6, ra;   mul  ra, s7, ra;                vadd.vv  v24, v14, v16
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v1,  v1,  v3
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v2,  v2,  v4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v3,  v9,  v11
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v4,  v10, v12
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v5,  v5,  v7
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v8
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v7,  v13, v15
sub  s6, s4, tp;   sub  s7, s5, ra;                vsub.vv  v8,  v14, v16
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
lw   gp, 5*4(a1);                                  vmul.vx v9,  v18,  t5
add  s5, s5, ra;   add  s4, s4, tp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
lw   ra, 6*4(a1);                                  vmulh.vx v18, v18, t5
mul  a7, s10, gp;  mul  gp, s11, gp;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
mul  tp, a4, ra;   mul  ra, a5, ra;                vmul.vx v10, v2,   t5
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v2,  v2,  t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v11, v20,  t5
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v20, v20, t5
sub  s10, s8, a7;  sub  s11, s9, gp;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
sub  a4, a2, tp;   sub  a5, a3, ra;                vmul.vx v12, v4,   t5
add  s8, s8, a7;   add  s9, s9, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
add  a2, a2, tp;   add  a3, a3, ra;                vmulh.vx v4,  v4,  t5
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmul.vx v13, v22,  t5
mul  a7, s1, a7;   mul  gp, s3, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
mul  tp, s5, tp;   mul  ra, s7, ra;                vmulh.vx v22, v22, t5
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v14, v6,   t5
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v6,  v6,  t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v15, v24,  t5
sub  s1, s0, a7;   sub  s3, s2, gp;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
add  s0, s0, a7;   lw   a7, 11*4(a1);              vmulh.vx v24, v24, t5
add  s2, s2, gp;   lw   gp, 12*4(a1);              lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
mul  a7, s9, a7;   mul  gp, s11, gp;               vmul.vx v16, v8,   t5
sub  s5, s4, tp;   sub  s7, s6, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmulh.vx v8,  v8,  t5
add  s6, s6, ra;   lw   ra, 14*4(a1);              vmulh.vx v9,  v9,  t4
mul  tp, a3, tp;   mul  ra, a5, ra;                vmulh.vx v10, v10, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v11, v11, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v12, v12, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v18, v18, v9
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v2,  v2,  v10
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v20, v20, v11
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v4,  v4,  v12
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v13, v13, t4
add  s8, s8, a7;   add  s10, s10, gp;              vadd.vv  v9,  v17, v18
sub  a3, a2, tp;   sub  a5, a4, ra;                vmulh.vx v14, v14, t4
add  a2, a2, tp;   add  a4, a4, ra;                vadd.vv  v10, v1,  v2
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmulh.vx v15, v15, t4
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vadd.vv  v11, v19, v20
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmulh.vx v16, v16, t4
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vadd.vv  v12, v3, v4
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vsub.vv  v22, v22, v13
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vsub.vv  v6,  v6,  v14
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vsub.vv  v24, v24, v15
addi a0, a0, -2;                                   vsub.vv  v8,  v8,  v16
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vsub.vv  v17, v17, v18
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         vsub.vv  v18, v1,  v2
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vsub.vv  v19, v19, v20
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vsub.vv  v20, v3,  v4
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vadd.vv  v13, v21,  v22
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vadd.vv  v14, v5,  v6
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vadd.vv  v15, v23, v24
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vrgather.vv v2, v9, v31
mul  a7, s8, t0;   mul  gp, s9, t0;                vrgather.vv v1, v17, v30
mul  tp, s10, t0;  mul  ra, s11, t0;               vmerge.vvm v2, v17, v2, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm v1, v1, v9, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v16, v7, v8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v4, v10, v31
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v3, v18, v30
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v4, v18, v4, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm v3, v3, v10, v0
sub  s8, s0, a7;   sub  s9, s1, gp;                vsub.vv  v21, v21, v22
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v22, v5,  v6
mul  a7, a2, t0;   mul  gp, a3, t0;                vsub.vv  v23, v23, v24
sub  s10, s2, tp;  sub  s11, s3, ra;               vsub.vv  v24, v7,  v8
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L5 + 0*_ZETAS_EXP_1TO6_P1_L5)*2
mul  tp, a4, t0;   mul  ra, a5, t0;                vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v9,  v2,  v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v2,  v2,  v26
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v6, v11, v31
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v5, v19, v30
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm v6, v19, v6, v0
sub  a2, s4, a7;   sub  a3, s5, gp;                vmerge.vvm v5, v5, v11, v0
add  s4, s4, a7;   add  s5, s5, gp;                vrgather.vv v8, v12, v31
sub  a4, s6, tp;   sub  a5, s7, ra;                vrgather.vv v7, v20, v30
add  s6, s6, tp;   add  s7, s7, ra;                vmerge.vvm v8, v20, v8, v0
mul  a7, s4, t1;   mul  gp, s5, t1;                vmerge.vvm v7, v7, v12, v0
mul  tp, s6, t1;   mul  ra, s7, t1;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v17, v4,  v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v4,  v4,  v26
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v9,  v9,  t4
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v17, v17, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s4, s0, a7;   sub  s5, s1, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vv  v10, v6,  v27
mul  a7, a2, t2;   mul  gp, a3, t2;                vmulh.vv v6,  v6,  v26
sub  s6, s2, tp;   sub  s7, s3, ra;                vsub.vv  v2,  v2,  v9
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v10, v10, t4
mul  tp, a4, t2;   mul  ra, a5, t2;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v18, v8,  v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v8,  v8,  v26
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v18, v18, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v4,  v4,  v17
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v10
sub  a2, s8, a7;   sub  a3, s9, gp;                vsub.vv  v8,  v8,  v18
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v9,  v1,  v2
sub  a4, s10, tp;  sub  a5, s11, ra;               vsub.vv  v11, v1,  v2
add  s10, s10, tp; add  s11, s11, ra;              vadd.vv  v17, v3,  v4
lw   ra, 4*4(a1);                                  vsub.vv  v19, v3,  v4
mul  a7, s2, t3;   mul  gp, s3, t3;                vadd.vv  v10, v5,  v6
mul  tp, s6, ra;   mul  ra, s7, ra;                vsub.vv  v12, v5,  v6
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v2, v13, v31
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v1, v21, v30
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm v2, v21, v2, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v1, v1, v13, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v4, v14, v31
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v3, v22, v30
sub  s2, s0, a7;   sub  s3, s1, gp;                vmerge.vvm v4, v22, v4, v0
sub  s6, s4, tp;   sub  s7, s5, ra;                vmerge.vvm v3, v3, v14, v0
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v18, v7,  v8
lw   gp, 5*4(a1);                                  vsub.vv  v20, v7,  v8
add  s5, s5, ra;   add  s4, s4, tp;                vrgather.vv v6, v15, v31
lw   ra, 6*4(a1);                                  vrgather.vv v5, v23, v30
mul  a7, s10, gp;  mul  gp, s11, gp;               vmerge.vvm v6, v23, v6, v0
mul  tp, a4, ra;   mul  ra, a5, ra;                vmerge.vvm v5, v5, v15, v0
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v8, v16, v31
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v7, v24, v30
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm v8, v24, v8, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v7, v7, v16, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s10, s8, a7;  sub  s11, s9, gp;               vmul.vv  v13, v2,  v27
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vv v2,  v2,  v26
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v13, v13, t4
add  a2, a2, tp;   add  a3, a3, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               addi t6, t6, 8*2;     vle16.v v26, (t6)
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vmul.vv  v21, v4,  v27
mul  a7, s1, a7;   mul  gp, s3, gp;                vmulh.vv v4,  v4,  v26
mul  tp, s5, tp;   mul  ra, s7, ra;                vmulh.vx v21, v21, t4
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v14, v6,  v27
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vv v6,  v6,  v26
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v14, v14, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s1, s0, a7;   sub  s3, s2, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s0, s0, a7;   lw   a7, 11*4(a1);              vmul.vv  v22, v8,  v27
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmulh.vv v8,  v8,  v26
mul  a7, s9, a7;   mul  gp, s11, gp;               vsub.vv  v2,  v2, v13
sub  s5, s4, tp;   sub  s7, s6, ra;                vsub.vv  v4,  v4, v21
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmulh.vx v22, v22, t4
add  s6, s6, ra;   lw   ra, 14*4(a1);              vsub.vv  v6,  v6, v14
mul  tp, a3, tp;   mul  ra, a5, ra;                vsub.vv  v8,  v8, v22
srai a7, a7, 16;   srai gp, gp, 16;                lw t6, 4*16(sp)
addi a7, a7, 8;    addi gp, gp, 8;                 addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v13, v1,  v2
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v15, v1,  v2
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v21, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v23, v3,  v4
sub  s9, s8, a7;   sub  s11, s10, gp;              vadd.vv  v14, v5,  v6
add  s8, s8, a7;   add  s10, s10, gp;              vsub.vv  v16, v5,  v6
sub  a3, a2, tp;   sub  a5, a4, ra;                vrgather.vv v1, v11, v29
add  a2, a2, tp;   add  a4, a4, ra;                vmerge.vvm  v1, v1, v9, v0
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vrgather.vv v2, v9, v28
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vmerge.vvm  v2, v11, v2, v0
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vadd.vv  v22, v7,  v8
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vsub.vv  v24, v7,  v8
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vrgather.vv v3, v19, v29
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vmerge.vvm  v3, v3, v17, v0
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vrgather.vv v4, v17, v28
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vmerge.vvm  v4, v19, v4, v0
addi a0, a0, -2;                                   addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L6+ 0*_ZETAS_EXP_1TO6_P1_L6)*2
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vle16.v v27, (t6)
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         addi t6, t6, 8*2;     vle16.v v26, (t6)
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmul.vv  v9,  v2,  v27
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         vmulh.vv v2,  v2,  v26
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vrgather.vv v5, v12, v29
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vmerge.vvm  v5, v5, v10, v0
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vrgather.vv v6, v10, v28
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vmerge.vvm  v6, v12, v6, v0
mul  a7, s8, t0;   mul  gp, s9, t0;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s10, t0;  mul  ra, s11, t0;               addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v11, v4,  v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v4,  v4,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v7, v20, v29
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v7, v7, v18, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v8, v18, v28
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v8, v20, v8, v0
sub  s8, s0, a7;   sub  s9, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  a7, a2, t0;   mul  gp, a3, t0;                vmul.vv  v17, v6,  v27
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vv v6,  v6,  v26
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, a4, t0;   mul  ra, a5, t0;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v19, v8,  v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v8,  v8,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v9,  v9,  t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v11, v11, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v17, v17, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v19, v19, t4
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v2,  v2,  v9
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v4,  v4,  v11
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v6,  v6,  v17
add  s6, s6, tp;   add  s7, s7, ra;                vsub.vv  v8,  v8,  v19
mul  a7, s4, t1;   mul  gp, s5, t1;                vadd.vv  v9,  v1,  v2
mul  tp, s6, t1;   mul  ra, s7, t1;                vsub.vv  v11, v1,  v2
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v17, v3,  v4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v19, v3,  v4
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v1, v15, v29
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v1, v1, v13, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v2, v13, v28
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v2, v15, v2, v0
sub  s4, s0, a7;   sub  s5, s1, gp;                vadd.vv  v10, v5,  v6
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v12, v5,  v6
mul  a7, a2, t2;   mul  gp, a3, t2;                vadd.vv  v18, v7,  v8
sub  s6, s2, tp;   sub  s7, s3, ra;                vsub.vv  v20, v7,  v8
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v3, v23, v29
mul  tp, a4, t2;   mul  ra, a5, t2;                vmerge.vvm  v3, v3, v21, v0
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v4, v21, v28
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v4, v23, v4, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v13, v2,  v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v2,  v2,  v26
sub  a2, s8, a7;   sub  a3, s9, gp;                vrgather.vv v5, v16, v29
add  s8, s8, a7;   add  s9, s9, gp;                vmerge.vvm  v5, v5, v14, v0
sub  a4, s10, tp;  sub  a5, s11, ra;               vrgather.vv v6, v14, v28
add  s10, s10, tp; add  s11, s11, ra;              vmerge.vvm  v6, v16, v6, v0
lw   ra, 4*4(a1);                                  addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  a7, s2, t3;   mul  gp, s3, t3;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, s6, ra;   mul  ra, s7, ra;                vmul.vv  v15, v4,  v27
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vv v4,  v4,  v26
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v7, v24, v29
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v7, v7, v22, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v8, v22, v28
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v8, v24, v8, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s2, s0, a7;   sub  s3, s1, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s6, s4, tp;   sub  s7, s5, ra;                vmul.vv  v21, v6,  v27
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vv v6,  v6,  v26
lw   gp, 5*4(a1);                                  addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s5, s5, ra;   add  s4, s4, tp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
lw   ra, 6*4(a1);                                  vmul.vv  v23, v8,  v27
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vv v8,  v8,  v26
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v13, v13, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v15, v15, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v21, v21, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v23, v23, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v2,  v2,  v13
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v4,  v4,  v15
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v21
sub  s10, s8, a7;  sub  s11, s9, gp;               vsub.vv  v8,  v8,  v23
sub  a4, a2, tp;   sub  a5, a3, ra;                vadd.vv  v13, v1,  v2
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v15, v1,  v2
add  a2, a2, tp;   add  a3, a3, ra;                lw t6, 4*16(sp)
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
mul  a7, s1, a7;   mul  gp, s3, gp;                vadd.vv  v21, v3,  v4
mul  tp, s5, tp;   mul  ra, s7, ra;                vsub.vv  v23, v3,  v4
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v1, v11, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v2, v9, v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v1, v1, v9, v0
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v2, v11, v2, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v14, v5,  v6
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v16, v5,  v6
sub  s1, s0, a7;   sub  s3, s2, gp;                vrgather.vv v3, v19, v27
add  s0, s0, a7;   lw   a7, 11*4(a1);              vrgather.vv v4, v17, v27
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmerge.vvm  v3, v3, v17, v0
mul  a7, s9, a7;   mul  gp, s11, gp;               vmerge.vvm  v4, v19, v4, v0
sub  s5, s4, tp;   sub  s7, s6, ra;                vadd.vv  v22, v7,  v8
add  s4, s4, tp;   lw   tp, 13*4(a1);              vsub.vv  v24, v7,  v8
add  s6, s6, ra;   lw   ra, 14*4(a1);              vrgather.vv v5, v12, v27
mul  tp, a3, tp;   mul  ra, a5, ra;                vrgather.vv v6, v10, v27
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v5, v5, v10, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v6, v12, v6, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v7, v20, v27
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v8, v18, v27
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v7, v7, v18, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v8, v20, v8, v0
sub  s9, s8, a7;   sub  s11, s10, gp;              vrgather.vv v9, v15, v27
add  s8, s8, a7;   add  s10, s10, gp;              vrgather.vv v11, v13, v27
sub  a3, a2, tp;   sub  a5, a4, ra;                vmerge.vvm  v9, v9, v13, v0
add  a2, a2, tp;   add  a4, a4, ra;                vmerge.vvm  v11, v15, v11, v0
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vrgather.vv v17, v23, v27
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vrgather.vv v19, v21, v27
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vmerge.vvm  v17, v17, v21, v0
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vmerge.vvm  v19, v23, v19, v0
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vrgather.vv v10, v16, v27
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vrgather.vv v12, v14, v27
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmerge.vvm  v10, v10, v14, v0
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vmerge.vvm  v12, v16, v12, v0
addi a0, a0, -2;                                   vrgather.vv v18, v24, v27
lh s0,  16*2*0(a0);    lh s1,  16*2*1(a0);         vrgather.vv v20, v22, v27
lh s2,  16*2*2(a0);    lh s3,  16*2*3(a0);         vmerge.vvm  v18, v18, v22, v0
lh s4,  16*2*4(a0);    lh s5,  16*2*5(a0);         vmerge.vvm  v20, v24, v20, v0
lh s6,  16*2*6(a0);    lh s7,  16*2*7(a0);         lw   t5, 4*15(sp);   addi t5, t5, (0*128)*2
lh s8,  16*2*8(a0);    lh s9,  16*2*9(a0);         vse16.v  v1,  (t5);  addi t5, t5, 16
lh s10, 16*2*10(a0);   lh s11, 16*2*11(a0);        vse16.v  v2,  (t5);  addi t5, t5, 16
lh a2,  16*2*12(a0);   lh a3,  16*2*13(a0);        vse16.v  v3,  (t5);  addi t5, t5, 16
lh a4,  16*2*14(a0);   lh a5,  16*2*15(a0);        vse16.v  v4,  (t5);  addi t5, t5, 16
mul  a7, s8, t0;   mul  gp, s9, t0;                vse16.v  v5,  (t5);  addi t5, t5, 16
mul  tp, s10, t0;  mul  ra, s11, t0;               vse16.v  v6,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v7,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v8,  (t5);  addi t5, t5, -16*7-(0*128)*2+(64+0*128)*2
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v9,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v11, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v17, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v19, (t5);  addi t5, t5, 16
sub  s8, s0, a7;   sub  s9, s1, gp;                vse16.v  v10, (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v12, (t5);  addi t5, t5, 16
mul  a7, a2, t0;   mul  gp, a3, t0;                vse16.v  v18, (t5);  addi t5, t5, 16
sub  s10, s2, tp;  sub  s11, s3, ra;               vse16.v  v20, (t5)
add  s2, s2, tp;   add  s3, s3, ra;                lw   t5, 4*15(sp);  addi t5, t5, (64+1*128)*2
mul  tp, a4, t0;   mul  ra, a5, t0;                vle16.v v9,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v10, (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v11, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v12, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v v13, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v14, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v15, (t5);  addi t5, t5, 16
sub  a2, s4, a7;   sub  a3, s5, gp;                vle16.v v16, (t5);  addi t5, t5, -16*7-(64+1*128)*2+(1*128)*2
add  s4, s4, a7;   add  s5, s5, gp;                vle16.v v1,  (t5);  addi t5, t5, 16
sub  a4, s6, tp;   sub  a5, s7, ra;                vle16.v v2,  (t5);  addi t5, t5, 16
add  s6, s6, tp;   add  s7, s7, ra;                vle16.v v3,  (t5);  addi t5, t5, 16
mul  a7, s4, t1;   mul  gp, s5, t1;                vle16.v v4,  (t5);  addi t5, t5, 16
mul  tp, s6, t1;   mul  ra, s7, t1;                vle16.v v5,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v6,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v7,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v8,  (t5)
srai tp, tp, 16;   srai ra, ra, 16;                lw t6, 4*16(sp)
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
sub  s4, s0, a7;   sub  s5, s1, gp;                vmul.vx v17, v9,  t5
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vx v18, v10, t5
mul  a7, a2, t2;   mul  gp, a3, t2;                vmul.vx v19, v11, t5
sub  s6, s2, tp;   sub  s7, s3, ra;                vmul.vx v20, v12, t5
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vx v21, v13, t5
mul  tp, a4, t2;   mul  ra, a5, t2;                vmul.vx v22, v14, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v23, v15, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v24, v16, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v9,  v9,  t6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v10, v10, t6
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v11, v11, t6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v12, v12, t6
sub  a2, s8, a7;   sub  a3, s9, gp;                vmulh.vx v13, v13, t6
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v14, v14, t6
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vx v15, v15, t6
add  s10, s10, tp; add  s11, s11, ra;              vmulh.vx v16, v16, t6
lw   ra, 4*4(a1);                                  vmulh.vx v21, v21, t4
mul  a7, s2, t3;   mul  gp, s3, t3;                vmulh.vx v22, v22, t4
mul  tp, s6, ra;   mul  ra, s7, ra;                vmulh.vx v23, v23, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v24, v24, t4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v13, v13, v21
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v14, v14, v22
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v15, v15, v23
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v16, v16, v24
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v17, v17, t4
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v21, v5, v13
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vx v18, v18, t4
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v22, v6, v14
lw   gp, 5*4(a1);                                  vmulh.vx v19, v19, t4
add  s5, s5, ra;   add  s4, s4, tp;                vsub.vv  v23, v7, v15
lw   ra, 6*4(a1);                                  vmulh.vx v20, v20, t4
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v24, v8, v16
mul  tp, a4, ra;   mul  ra, a5, ra;                vsub.vv  v9,  v9,  v17
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v10, v10, v18
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v11, v11, v19
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v12, v12, v20
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v17, v1, v9
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v18, v2, v10
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v19, v3, v11
sub  s10, s8, a7;  sub  s11, s9, gp;               vsub.vv  v20, v4, v12
sub  a4, a2, tp;   sub  a5, a3, ra;                vadd.vv  v13, v5, v13
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v14, v6, v14
add  a2, a2, tp;   add  a3, a3, ra;                vadd.vv  v15, v7, v15
lw   a7, 7*4(a1);  lw   gp, 8*4(a1);               vadd.vv  v16, v8, v16
lw   tp, 9*4(a1);  lw   ra, 10*4(a1);              vadd.vv  v9, v1, v9
mul  a7, s1, a7;   mul  gp, s3, gp;                vadd.vv  v10, v2, v10
mul  tp, s5, tp;   mul  ra, s7, ra;                vadd.vv  v11, v3, v11
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v12, v4, v12
addi a7, a7, 8;    addi gp, gp, 8;                 lw t6, 4*16(sp)
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v1, v13, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v2, v14, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v3, v15, t5
sub  s1, s0, a7;   sub  s3, s2, gp;                vmul.vx v4, v16, t5
add  s0, s0, a7;   lw   a7, 11*4(a1);              lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
add  s2, s2, gp;   lw   gp, 12*4(a1);              vmul.vx v5, v21, t5
mul  a7, s9, a7;   mul  gp, s11, gp;               vmul.vx v6, v22, t5
sub  s5, s4, tp;   sub  s7, s6, ra;                vmul.vx v7, v23, t5
add  s4, s4, tp;   lw   tp, 13*4(a1);              vmul.vx v8, v24, t5
add  s6, s6, ra;   lw   ra, 14*4(a1);              lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
mul  tp, a3, tp;   mul  ra, a5, ra;                vmulh.vx v13, v13, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v14, v14, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v15, v15, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v16, v16, t5
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v21, v21, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v22, v22, t5
sub  s9, s8, a7;   sub  s11, s10, gp;              vmulh.vx v23, v23, t5
add  s8, s8, a7;   add  s10, s10, gp;              vmulh.vx v24, v24, t5
sub  a3, a2, tp;   sub  a5, a4, ra;                vmulh.vx v1, v1, t4
add  a2, a2, tp;   add  a4, a4, ra;                vmulh.vx v2, v2, t4
sh s0,  16*2*0(a0);    sh s1,  16*2*1(a0);         vmulh.vx v3, v3, t4
sh s2,  16*2*2(a0);    sh s3,  16*2*3(a0);         vmulh.vx v4, v4, t4
sh s4,  16*2*4(a0);    sh s5,  16*2*5(a0);         vsub.vv  v13, v13, v1
sh s6,  16*2*6(a0);    sh s7,  16*2*7(a0);         vsub.vv  v14, v14, v2
sh s8,  16*2*8(a0);    sh s9,  16*2*9(a0);         vsub.vv  v15, v15, v3
sh s10, 16*2*10(a0);   sh s11, 16*2*11(a0);        vsub.vv  v16, v16, v4
sh a2,  16*2*12(a0);   sh a3,  16*2*13(a0);        vmulh.vx v5, v5, t4
sh a4,  16*2*14(a0);   sh a5,  16*2*15(a0);        vadd.vv  v1, v9,  v13
addi a1, a1, 15*4;                                 vmulh.vx v6, v6, t4
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vadd.vv  v2, v10, v14
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmulh.vx v7, v7, t4
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vadd.vv  v3, v11, v15
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vmulh.vx v8, v8, t4
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vadd.vv  v4, v12, v16
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vsub.vv  v21, v21, v5
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vsub.vv  v22, v22, v6
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vsub.vv  v23, v23, v7
lw t0, 0*4(a1);                                    vsub.vv  v24, v24, v8
lw t1, 1*4(a1);                                    vadd.vv  v5, v17, v21
lw t2, 2*4(a1);                                    vadd.vv  v6, v18, v22
lw t3, 3*4(a1);                                    vadd.vv  v7, v19, v23
mul  a7, s8, t0;   mul  gp, s9, t0;                vadd.vv  v8, v20, v24
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v9, v9,  v13
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v10, v10,v14
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11,v11, v15
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v12,v12, v16
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v13,v17, v21
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v14,v18, v22
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v15,v19, v23
sub  s8, s0, a7;   sub  s9, s1, gp;                vsub.vv  v16,v20, v24
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
mul  a7, a2, t0;   mul  gp, a3, t0;                vmul.vx v17, v3,  t5
sub  s10, s2, tp;  sub  s11, s3, ra;               vmul.vx v18, v4,  t5
add  s2, s2, tp;   add  s3, s3, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
mul  tp, a4, t0;   mul  ra, a5, t0;                vmul.vx v19, v11, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v20, v12, t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v21, v7,  t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v22, v8,  t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v23, v15, t5
sub  a2, s4, a7;   sub  a3, s5, gp;                vmul.vx v24, v16, t5
add  s4, s4, a7;   add  s5, s5, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v3,  v3,  t5
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v4,  v4,  t5
mul  a7, s4, t1;   mul  gp, s5, t1;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v11, v11, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v12, v12, t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v7,  v7,  t5
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v8,  v8,  t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v15, v15, t5
sub  s4, s0, a7;   sub  s5, s1, gp;                vmulh.vx v16, v16, t5
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v17, v17, t4
mul  a7, a2, t2;   mul  gp, a3, t2;                vmulh.vx v18, v18, t4
sub  s6, s2, tp;   sub  s7, s3, ra;                vmulh.vx v19, v19, t4
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v20, v20, t4
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v3,  v3,  v17
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v4,  v4,  v18
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11, v11, v19
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v12, v12, v20
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v21, v21, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v17, v1,  v3
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v22, v22, t4
sub  a2, s8, a7;   sub  a3, s9, gp;                vadd.vv  v18, v2,  v4
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v23, v23, t4
sub  a4, s10, tp;  sub  a5, s11, ra;               vadd.vv  v19, v9,  v11
add  s10, s10, tp; add  s11, s11, ra;              vmulh.vx v24, v24, t4
lw   ra, 4*4(a1);                                  vadd.vv  v20, v10, v12
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v7,  v7,  v21
mul  tp, s6, ra;   mul  ra, s7, ra;                vsub.vv  v8,  v8,  v22
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v15, v15, v23
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v16, v16, v24
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v21, v5,  v7
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v22, v6,  v8
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v23, v13, v15
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v24, v14, v16
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v1,  v1,  v3
sub  s6, s4, tp;   sub  s7, s5, ra;                vsub.vv  v2,  v2,  v4
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v3,  v9,  v11
lw   gp, 5*4(a1);                                  vsub.vv  v4,  v10, v12
add  s5, s5, ra;   add  s4, s4, tp;                vsub.vv  v5,  v5,  v7
lw   ra, 6*4(a1);                                  vsub.vv  v6,  v6,  v8
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v7,  v13, v15
mul  tp, a4, ra;   mul  ra, a5, ra;                vsub.vv  v8,  v14, v16
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v9,  v18,  t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v18, v18, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v10, v2,   t5
sub  s10, s8, a7;  sub  s11, s9, gp;               lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
sub  a4, a2, tp;   sub  a5, a3, ra;                vmulh.vx v2,  v2,  t5
add  s8, s8, a7;   add  s9, s9, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
add  a2, a2, tp;   add  a3, a3, ra;                vmul.vx v11, v20,  t5
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmulh.vx v20, v20, t5
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vmul.vx v12, v4,   t5
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmulh.vx v4,  v4,  t5
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmul.vx v13, v22,  t5
addi a0, a0, 32;                                   lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
addi a1, a1, 7*4;                                  vmulh.vx v22, v22, t5
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmul.vx v14, v6,   t5
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vmulh.vx v6,  v6,  t5
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmul.vx v15, v24,  t5
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vmulh.vx v24, v24, t5
lw t0, 0*4(a1);                                    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
lw t1, 1*4(a1);                                    vmul.vx v16, v8,   t5
lw t2, 2*4(a1);                                    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
lw t3, 3*4(a1);                                    vmulh.vx v8,  v8,  t5
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vx v9,  v9,  t4
mul  tp, s10, t0;  mul  ra, s11, t0;               vmulh.vx v10, v10, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v11, v11, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v12, v12, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v18, v18, v9
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v2,  v2,  v10
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v20, v20, v11
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v4,  v4,  v12
sub  s8, s0, a7;   sub  s9, s1, gp;                vmulh.vx v13, v13, t4
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v9,  v17, v18
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v14, v14, t4
sub  s10, s2, tp;  sub  s11, s3, ra;               vadd.vv  v10, v1,  v2
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v15, v15, t4
mul  tp, a4, t0;   mul  ra, a5, t0;                vadd.vv  v11, v19, v20
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v16, v16, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v12, v3, v4
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v22, v22, v13
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v6,  v6,  v14
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v24, v24, v15
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v8,  v8,  v16
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v17, v17, v18
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v18, v1,  v2
add  s6, s6, tp;   add  s7, s7, ra;                vsub.vv  v19, v19, v20
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v20, v3,  v4
mul  tp, s6, t1;   mul  ra, s7, t1;                vadd.vv  v13, v21,  v22
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v14, v5,  v6
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v15, v23, v24
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v2, v9, v31
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v1, v17, v30
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v2, v17, v2, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm v1, v1, v9, v0
sub  s4, s0, a7;   sub  s5, s1, gp;                vadd.vv  v16, v7, v8
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v4, v10, v31
mul  a7, a2, t2;   mul  gp, a3, t2;                vrgather.vv v3, v18, v30
sub  s6, s2, tp;   sub  s7, s3, ra;                vmerge.vvm v4, v18, v4, v0
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm v3, v3, v10, v0
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v21, v21, v22
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v22, v5,  v6
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v23, v23, v24
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v24, v7,  v8
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L5 + 1*_ZETAS_EXP_1TO6_P1_L5)*2
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  a2, s8, a7;   sub  a3, s9, gp;                vmul.vv  v9,  v2,  v27
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vv v2,  v2,  v26
sub  a4, s10, tp;  sub  a5, s11, ra;               vrgather.vv v6, v11, v31
add  s10, s10, tp; add  s11, s11, ra;              vrgather.vv v5, v19, v30
lw   ra, 4*4(a1);                                  vmerge.vvm v6, v19, v6, v0
mul  a7, s2, t3;   mul  gp, s3, t3;                vmerge.vvm v5, v5, v11, v0
mul  tp, s6, ra;   mul  ra, s7, ra;                vrgather.vv v8, v12, v31
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v7, v20, v30
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm v8, v20, v8, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm v7, v7, v12, v0
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v17, v4,  v27
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vv v4,  v4,  v26
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vx v9,  v9,  t4
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v17, v17, t4
lw   gp, 5*4(a1);                                  addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s5, s5, ra;   add  s4, s4, tp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
lw   ra, 6*4(a1);                                  vmul.vv  v10, v6,  v27
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vv v6,  v6,  v26
mul  tp, a4, ra;   mul  ra, a5, ra;                vsub.vv  v2,  v2,  v9
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v10, v10, t4
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v18, v8,  v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v8,  v8,  v26
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v18, v18, t4
sub  s10, s8, a7;  sub  s11, s9, gp;               vsub.vv  v4,  v4,  v17
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v6,  v6,  v10
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v8,  v8,  v18
add  a2, a2, tp;   add  a3, a3, ra;                vadd.vv  v9,  v1,  v2
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vsub.vv  v11, v1,  v2
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vadd.vv  v17, v3,  v4
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vsub.vv  v19, v3,  v4
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vadd.vv  v10, v5,  v6
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vsub.vv  v12, v5,  v6
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vrgather.vv v2, v13, v31
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vrgather.vv v1, v21, v30
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmerge.vvm v2, v21, v2, v0
addi a0, a0, 32;                                   vmerge.vvm v1, v1, v13, v0
addi a1, a1, 7*4;                                  vrgather.vv v4, v14, v31
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vrgather.vv v3, v22, v30
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmerge.vvm v4, v22, v4, v0
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vmerge.vvm v3, v3, v14, v0
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vadd.vv  v18, v7,  v8
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vsub.vv  v20, v7,  v8
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vrgather.vv v6, v15, v31
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vrgather.vv v5, v23, v30
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vmerge.vvm v6, v23, v6, v0
lw t0, 0*4(a1);                                    vmerge.vvm v5, v5, v15, v0
lw t1, 1*4(a1);                                    vrgather.vv v8, v16, v31
lw t2, 2*4(a1);                                    vrgather.vv v7, v24, v30
lw t3, 3*4(a1);                                    vmerge.vvm v8, v24, v8, v0
mul  a7, s8, t0;   mul  gp, s9, t0;                vmerge.vvm v7, v7, v16, v0
mul  tp, s10, t0;  mul  ra, s11, t0;               addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vv  v13, v2,  v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v2,  v2,  v26
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v13, v13, t4
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vv  v21, v4,  v27
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vv v4,  v4,  v26
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v21, v21, t4
sub  s10, s2, tp;  sub  s11, s3, ra;               addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, a4, t0;   mul  ra, a5, t0;                vmul.vv  v14, v6,  v27
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vv v6,  v6,  v26
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v14, v14, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v22, v8,  v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v8,  v8,  v26
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v2,  v2, v13
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v4,  v4, v21
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v22, v22, t4
add  s6, s6, tp;   add  s7, s7, ra;                vsub.vv  v6,  v6, v14
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v8,  v8, v22
mul  tp, s6, t1;   mul  ra, s7, t1;                lw t6, 4*16(sp)
srai a7, a7, 16;   srai gp, gp, 16;                addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v13, v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v15, v1,  v2
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v21, v3,  v4
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v23, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v14, v5,  v6
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v16, v5,  v6
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v1, v11, v29
mul  a7, a2, t2;   mul  gp, a3, t2;                vmerge.vvm  v1, v1, v9, v0
sub  s6, s2, tp;   sub  s7, s3, ra;                vrgather.vv v2, v9, v28
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm  v2, v11, v2, v0
mul  tp, a4, t2;   mul  ra, a5, t2;                vadd.vv  v22, v7,  v8
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v24, v7,  v8
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v3, v19, v29
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v3, v3, v17, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v4, v17, v28
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v4, v19, v4, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L6+ 1*_ZETAS_EXP_1TO6_P1_L6)*2
sub  a2, s8, a7;   sub  a3, s9, gp;                vle16.v v27, (t6)
add  s8, s8, a7;   add  s9, s9, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  a4, s10, tp;  sub  a5, s11, ra;               vmul.vv  v9,  v2,  v27
add  s10, s10, tp; add  s11, s11, ra;              vmulh.vv v2,  v2,  v26
lw   ra, 4*4(a1);                                  vrgather.vv v5, v12, v29
mul  a7, s2, t3;   mul  gp, s3, t3;                vmerge.vvm  v5, v5, v10, v0
mul  tp, s6, ra;   mul  ra, s7, ra;                vrgather.vv v6, v10, v28
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v6, v12, v6, v0
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v11, v4,  v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vv v4,  v4,  v26
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v7, v20, v29
sub  s2, s0, a7;   sub  s3, s1, gp;                vmerge.vvm  v7, v7, v18, v0
sub  s6, s4, tp;   sub  s7, s5, ra;                vrgather.vv v8, v18, v28
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v8, v20, v8, v0
lw   gp, 5*4(a1);                                  addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s5, s5, ra;   add  s4, s4, tp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
lw   ra, 6*4(a1);                                  vmul.vv  v17, v6,  v27
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vv v6,  v6,  v26
mul  tp, a4, ra;   mul  ra, a5, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v19, v8,  v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v8,  v8,  v26
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v9,  v9,  t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v11, v11, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v17, v17, t4
sub  s10, s8, a7;  sub  s11, s9, gp;               vmulh.vx v19, v19, t4
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v2,  v2,  v9
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v4,  v4,  v11
add  a2, a2, tp;   add  a3, a3, ra;                vsub.vv  v6,  v6,  v17
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vsub.vv  v8,  v8,  v19
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vadd.vv  v9,  v1,  v2
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vsub.vv  v11, v1,  v2
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vadd.vv  v17, v3,  v4
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vsub.vv  v19, v3,  v4
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vrgather.vv v1, v15, v29
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vmerge.vvm  v1, v1, v13, v0
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vrgather.vv v2, v13, v28
addi a0, a0, 32;                                   vmerge.vvm  v2, v15, v2, v0
addi a1, a1, 7*4;                                  vadd.vv  v10, v5,  v6
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vsub.vv  v12, v5,  v6
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vadd.vv  v18, v7,  v8
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vsub.vv  v20, v7,  v8
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vrgather.vv v3, v23, v29
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vmerge.vvm  v3, v3, v21, v0
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vrgather.vv v4, v21, v28
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmerge.vvm  v4, v23, v4, v0
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          addi t6, t6, 8*2;     vle16.v v27, (t6)
lw t0, 0*4(a1);                                    addi t6, t6, 8*2;     vle16.v v26, (t6)
lw t1, 1*4(a1);                                    vmul.vv  v13, v2,  v27
lw t2, 2*4(a1);                                    vmulh.vv v2,  v2,  v26
lw t3, 3*4(a1);                                    vrgather.vv v5, v16, v29
mul  a7, s8, t0;   mul  gp, s9, t0;                vmerge.vvm  v5, v5, v14, v0
mul  tp, s10, t0;  mul  ra, s11, t0;               vrgather.vv v6, v14, v28
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v6, v16, v6, v0
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v15, v4,  v27
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v4,  v4,  v26
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v7, v24, v29
sub  s8, s0, a7;   sub  s9, s1, gp;                vmerge.vvm  v7, v7, v22, v0
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v8, v22, v28
mul  a7, a2, t0;   mul  gp, a3, t0;                vmerge.vvm  v8, v24, v8, v0
sub  s10, s2, tp;  sub  s11, s3, ra;               addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s2, s2, tp;   add  s3, s3, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, a4, t0;   mul  ra, a5, t0;                vmul.vv  v21, v6,  v27
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vv v6,  v6,  v26
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vv  v23, v8,  v27
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vv v8,  v8,  v26
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v13, v13, t4
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v15, v15, t4
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v21, v21, t4
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v23, v23, t4
add  s6, s6, tp;   add  s7, s7, ra;                vsub.vv  v2,  v2,  v13
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v4,  v4,  v15
mul  tp, s6, t1;   mul  ra, s7, t1;                vsub.vv  v6,  v6,  v21
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v8,  v8,  v23
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v13, v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v15, v1,  v2
srai tp, tp, 16;   srai ra, ra, 16;                lw t6, 4*16(sp)
addi tp, tp, 8;    addi ra, ra, 8;                 addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
sub  s4, s0, a7;   sub  s5, s1, gp;                vadd.vv  v21, v3,  v4
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v23, v3,  v4
mul  a7, a2, t2;   mul  gp, a3, t2;                vrgather.vv v1, v11, v27
sub  s6, s2, tp;   sub  s7, s3, ra;                vrgather.vv v2, v9, v27
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm  v1, v1, v9, v0
mul  tp, a4, t2;   mul  ra, a5, t2;                vmerge.vvm  v2, v11, v2, v0
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v14, v5,  v6
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v16, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v3, v19, v27
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v4, v17, v27
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v3, v3, v17, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v4, v19, v4, v0
sub  a2, s8, a7;   sub  a3, s9, gp;                vadd.vv  v22, v7,  v8
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v24, v7,  v8
sub  a4, s10, tp;  sub  a5, s11, ra;               vrgather.vv v5, v12, v27
add  s10, s10, tp; add  s11, s11, ra;              vrgather.vv v6, v10, v27
lw   ra, 4*4(a1);                                  vmerge.vvm  v5, v5, v10, v0
mul  a7, s2, t3;   mul  gp, s3, t3;                vmerge.vvm  v6, v12, v6, v0
mul  tp, s6, ra;   mul  ra, s7, ra;                vrgather.vv v7, v20, v27
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v8, v18, v27
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v7, v7, v18, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v8, v20, v8, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v9, v15, v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v11, v13, v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v9, v9, v13, v0
sub  s2, s0, a7;   sub  s3, s1, gp;                vmerge.vvm  v11, v15, v11, v0
sub  s6, s4, tp;   sub  s7, s5, ra;                vrgather.vv v17, v23, v27
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v19, v21, v27
lw   gp, 5*4(a1);                                  vmerge.vvm  v17, v17, v21, v0
add  s5, s5, ra;   add  s4, s4, tp;                vmerge.vvm  v19, v23, v19, v0
lw   ra, 6*4(a1);                                  vrgather.vv v10, v16, v27
mul  a7, s10, gp;  mul  gp, s11, gp;               vrgather.vv v12, v14, v27
mul  tp, a4, ra;   mul  ra, a5, ra;                vmerge.vvm  v10, v10, v14, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v12, v16, v12, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v18, v24, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v20, v22, v27
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v18, v18, v22, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v20, v24, v20, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                lw   t5, 4*15(sp);   addi t5, t5, (1*128)*2
sub  s10, s8, a7;  sub  s11, s9, gp;               vse16.v  v1,  (t5);  addi t5, t5, 16
sub  a4, a2, tp;   sub  a5, a3, ra;                vse16.v  v2,  (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp;                vse16.v  v3,  (t5);  addi t5, t5, 16
add  a2, a2, tp;   add  a3, a3, ra;                vse16.v  v4,  (t5);  addi t5, t5, 16
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vse16.v  v5,  (t5);  addi t5, t5, 16
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vse16.v  v6,  (t5);  addi t5, t5, 16
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vse16.v  v7,  (t5);  addi t5, t5, 16
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vse16.v  v8,  (t5);  addi t5, t5, -16*7-(1*128)*2+(64+1*128)*2
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vse16.v  v9,  (t5);  addi t5, t5, 16
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vse16.v  v11, (t5);  addi t5, t5, 16
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vse16.v  v17, (t5);  addi t5, t5, 16
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vse16.v  v19, (t5);  addi t5, t5, 16
addi a0, a0, 32;                                   vse16.v  v10, (t5);  addi t5, t5, 16
addi a1, a1, 7*4;                                  vse16.v  v12, (t5);  addi t5, t5, 16
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vse16.v  v18, (t5);  addi t5, t5, 16
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vse16.v  v20, (t5)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           lw   t5, 4*15(sp)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           addi t5, t5, (64*0+128)*2   
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vle16.v v8,  (t5);  addi t5, t5, 16
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vle16.v v9,  (t5);  addi t5, t5, 16
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vle16.v v10, (t5);  addi t5, t5, 16
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vle16.v v11, (t5);  addi t5, t5, 16
lw t0, 0*4(a1);                                    vle16.v v12, (t5);  addi t5, t5, 16
lw t1, 1*4(a1);                                    vle16.v v13, (t5);  addi t5, t5, 16
lw t2, 2*4(a1);                                    vle16.v v14, (t5);  addi t5, t5, 16
lw t3, 3*4(a1);                                    vle16.v v15, (t5);  addi t5, t5, -((64*0+128)*2+16*7)
mul  a7, s8, t0;   mul  gp, s9, t0;                vle16.v v16, (t5);  addi t5, t5, 16
mul  tp, s10, t0;  mul  ra, s11, t0;               vle16.v v17, (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v18, (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vle16.v v19, (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vle16.v v20, (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vle16.v v21, (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vle16.v v22, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v23, (t5);  addi t5, t5, -16*7
sub  s8, s0, a7;   sub  s9, s1, gp;                sw t5, 4*15(sp)
add  s0, s0, a7;   add  s1, s1, gp;                lw t6, 4*16(sp)
mul  a7, a2, t0;   mul  gp, a3, t0;                lh t5, (_ZETAS_EXP+0)*2(t6)
sub  s10, s2, tp;  sub  s11, s3, ra;               lh t6, (_ZETAS_EXP+1)*2(t6)
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vx v0, v8, t5
mul  tp, a4, t0;   mul  ra, a5, t0;                vmul.vx v1, v9, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v2, v10, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v3, v11, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v4, v12, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v5, v13, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v6, v14, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v7, v15, t5
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v8,  v8, t6
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v9,  v9, t6
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v10, v10, t6
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v11, v11, t6
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v12, v12, t6
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v13, v13, t6
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v14, v14, t6
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v15, v15, t6
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v0, v0, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v1, v1, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v2, v2, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v3, v3, t4
sub  s4, s0, a7;   sub  s5, s1, gp;                vmulh.vx v4, v4, t4
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v5, v5, t4
mul  a7, a2, t2;   mul  gp, a3, t2;                vmulh.vx v6, v6, t4
sub  s6, s2, tp;   sub  s7, s3, ra;                vmulh.vx v7, v7, t4
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v8,  v8,  v0
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v9,  v9,  v1
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v10, v10, v2
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v11, v11, v3
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v12, v12, v4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v13, v13, v5
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v14, v14, v6
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v15, v15, v7
sub  a2, s8, a7;   sub  a3, s9, gp;                vadd.vv  v0, v16, v8
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v1, v17, v9
sub  a4, s10, tp;  sub  a5, s11, ra;               vadd.vv  v2, v18, v10
add  s10, s10, tp; add  s11, s11, ra;              vadd.vv  v3, v19, v11
lw   ra, 4*4(a1);                                  vadd.vv  v4, v20, v12
mul  a7, s2, t3;   mul  gp, s3, t3;                vadd.vv  v5, v21, v13
mul  tp, s6, ra;   mul  ra, s7, ra;                vadd.vv  v6, v22, v14
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v7, v23, v15
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v8, v16, v8
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v9, v17, v9
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v10, v18, v10
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v11, v19, v11
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v12, v20, v12
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v13, v21, v13
sub  s6, s4, tp;   sub  s7, s5, ra;                vsub.vv  v14, v22, v14
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v15, v23, v15
lw   gp, 5*4(a1);                                  lw t5, 4*15(sp)
add  s5, s5, ra;   add  s4, s4, tp;                vse16.v  v0,  (t5);  addi t5, t5, 16
lw   ra, 6*4(a1);                                  vse16.v  v1,  (t5);  addi t5, t5, 16
mul  a7, s10, gp;  mul  gp, s11, gp;               vse16.v  v2,  (t5);  addi t5, t5, 16
mul  tp, a4, ra;   mul  ra, a5, ra;                vse16.v  v3,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v4,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v5,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v6,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v7,  (t5);  addi t5, t5, (64*0+128)*2-16*7
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v8,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v9,  (t5);  addi t5, t5, 16
sub  s10, s8, a7;  sub  s11, s9, gp;               vse16.v  v10, (t5);  addi t5, t5, 16
sub  a4, a2, tp;   sub  a5, a3, ra;                vse16.v  v11, (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp;                vse16.v  v12, (t5);  addi t5, t5, 16
add  a2, a2, tp;   add  a3, a3, ra;                vse16.v  v13, (t5);  addi t5, t5, 16
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vse16.v  v14, (t5);  addi t5, t5, 16
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vse16.v  v15, (t5);  addi t5, t5, 16
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vle16.v  v24, (t5);  addi t5, t5, 16
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vle16.v  v25, (t5);  addi t5, t5, 16
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vle16.v  v26, (t5);  addi t5, t5, 16
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vle16.v  v27, (t5);  addi t5, t5, 16
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vle16.v  v28, (t5);  addi t5, t5, 16
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vle16.v  v29, (t5);  addi t5, t5, 16
addi a0, a0, 32;                                   vle16.v  v30, (t5);  addi t5, t5, 16
addi a1, a1, 7*4;                                  vle16.v  v31, (t5);  addi t5, t5, -(128*2)-16*7
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vle16.v  v16, (t5);  addi t5, t5, 16
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vle16.v  v17, (t5);  addi t5, t5, 16
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vle16.v  v18, (t5);  addi t5, t5, 16
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vle16.v  v19, (t5);  addi t5, t5, 16
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vle16.v  v20, (t5);  addi t5, t5, 16
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vle16.v  v21, (t5);  addi t5, t5, 16
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vle16.v  v22, (t5);  addi t5, t5, 16
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vle16.v  v23, (t5);  addi t5, t5, -16*7
lw t0, 0*4(a1);                                    sw t5, 4*15(sp)
lw t1, 1*4(a1);                                    lw t6, 4*16(sp)
lw t2, 2*4(a1);                                    lh t5, (_ZETAS_EXP+0)*2(t6)
lw t3, 3*4(a1);                                    lh t6, (_ZETAS_EXP+1)*2(t6)
mul  a7, s8, t0;   mul  gp, s9, t0;                vmul.vx v0, v24, t5
mul  tp, s10, t0;  mul  ra, s11, t0;               vmul.vx v1, v25, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v2, v26, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v3, v27, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v4, v28, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v5, v29, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v6, v30, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v7, v31, t5
sub  s8, s0, a7;   sub  s9, s1, gp;                vmulh.vx v24, v24, t6
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v25, v25, t6
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v26, v26, t6
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vx v27, v27, t6
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v28, v28, t6
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vx v29, v29, t6
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v30, v30, t6
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v31, v31, t6
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v0, v0, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v1, v1, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v2, v2, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v3, v3, t4
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v4, v4, t4
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v5, v5, t4
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v6, v6, t4
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v7, v7, t4
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v24, v24, v0
mul  tp, s6, t1;   mul  ra, s7, t1;                vsub.vv  v25, v25, v1
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v26, v26, v2
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v27, v27, v3
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v28, v28, v4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v29, v29, v5
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v30, v30, v6
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v31, v31, v7
sub  s4, s0, a7;   sub  s5, s1, gp;                vadd.vv  v0, v16, v24
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v1, v17, v25
mul  a7, a2, t2;   mul  gp, a3, t2;                vadd.vv  v2, v18, v26
sub  s6, s2, tp;   sub  s7, s3, ra;                vadd.vv  v3, v19, v27
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v4, v20, v28
mul  tp, a4, t2;   mul  ra, a5, t2;                vadd.vv  v5, v21, v29
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v6, v22, v30
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v7, v23, v31
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v24, v16, v24
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v25, v17, v25
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v26, v18, v26
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v27, v19, v27
sub  a2, s8, a7;   sub  a3, s9, gp;                vsub.vv  v28, v20, v28
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v29, v21, v29
sub  a4, s10, tp;  sub  a5, s11, ra;               vsub.vv  v30, v22, v30
add  s10, s10, tp; add  s11, s11, ra;              vsub.vv  v31, v23, v31
lw   ra, 4*4(a1);                                  lw t5, 4*15(sp)
mul  a7, s2, t3;   mul  gp, s3, t3;                vse16.v  v0,  (t5);  addi t5, t5, 16
mul  tp, s6, ra;   mul  ra, s7, ra;                vse16.v  v1,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v2,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v3,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v4,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v5,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v6,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v7,  (t5);  addi t5, t5, -16*7+128*2
sub  s2, s0, a7;   sub  s3, s1, gp;                vse16.v  v24, (t5);  addi t5, t5, 16
sub  s6, s4, tp;   sub  s7, s5, ra;                vse16.v  v25, (t5);  addi t5, t5, 16
add  s0, s0, a7;   add  s1, s1, gp;                vse16.v  v26, (t5);  addi t5, t5, 16
lw   gp, 5*4(a1);                                  vse16.v  v27, (t5);  addi t5, t5, 16
add  s5, s5, ra;   add  s4, s4, tp;                vse16.v  v28, (t5);  addi t5, t5, 16
lw   ra, 6*4(a1);                                  vse16.v  v29, (t5);  addi t5, t5, 16
mul  a7, s10, gp;  mul  gp, s11, gp;               vse16.v  v30, (t5);  addi t5, t5, 16
mul  tp, a4, ra;   mul  ra, a5, ra;                vse16.v  v31, (t5);  addi t5, t5, -16*7-192*2
srai a7, a7, 16;   srai gp, gp, 16;                sw t5, 4*15(sp)
srai tp, tp, 16;   srai ra, ra, 16;                lw t6, 4*16(sp)
addi a7, a7, 8;    addi gp, gp, 8;                 addi t5, t6, _MASK_45674567*2;      vle16.v v31, (t5)
addi tp, tp, 8;    addi ra, ra, 8;                 addi t5, t6, _MASK_01230123*2;      vle16.v v30, (t5)
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t5, t6, _MASK_00010045*2;      vle16.v v29, (t5)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t5, t6, _MASK_23006700*2;      vle16.v v28, (t5)
sub  s10, s8, a7;  sub  s11, s9, gp;               lw   t5, 4*15(sp);  addi t5, t5, (64+0*128)*2
sub  a4, a2, tp;   sub  a5, a3, ra;                vle16.v v9,  (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp;                vle16.v v10, (t5);  addi t5, t5, 16
add  a2, a2, tp;   add  a3, a3, ra;                vle16.v v11, (t5);  addi t5, t5, 16
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vle16.v v12, (t5);  addi t5, t5, 16
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vle16.v v13, (t5);  addi t5, t5, 16
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vle16.v v14, (t5);  addi t5, t5, 16
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vle16.v v15, (t5);  addi t5, t5, 16
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vle16.v v16, (t5);  addi t5, t5, -16*7-(64+0*128)*2+(0*128)*2
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vle16.v v1,  (t5);  addi t5, t5, 16
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vle16.v v2,  (t5);  addi t5, t5, 16
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vle16.v v3,  (t5);  addi t5, t5, 16
addi a0, a0, 32;                                   vle16.v v4,  (t5);  addi t5, t5, 16
addi a1, a1, 7*4;                                  vle16.v v5,  (t5);  addi t5, t5, 16
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vle16.v v6,  (t5);  addi t5, t5, 16
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vle16.v v7,  (t5);  addi t5, t5, 16
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vle16.v v8,  (t5)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           lw t6, 4*16(sp)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          lh t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmul.vx v17, v9,  t5
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vmul.vx v18, v10, t5
lw t0, 0*4(a1);                                    vmul.vx v19, v11, t5
lw t1, 1*4(a1);                                    vmul.vx v20, v12, t5
lw t2, 2*4(a1);                                    vmul.vx v21, v13, t5
lw t3, 3*4(a1);                                    vmul.vx v22, v14, t5
mul  a7, s8, t0;   mul  gp, s9, t0;                vmul.vx v23, v15, t5
mul  tp, s10, t0;  mul  ra, s11, t0;               vmul.vx v24, v16, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v9,  v9,  t6
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v10, v10, t6
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v11, v11, t6
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v12, v12, t6
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v13, v13, t6
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v14, v14, t6
sub  s8, s0, a7;   sub  s9, s1, gp;                vmulh.vx v15, v15, t6
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v16, v16, t6
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v21, v21, t4
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vx v22, v22, t4
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v23, v23, t4
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vx v24, v24, t4
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v13, v13, v21
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v14, v14, v22
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v15, v15, v23
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v16, v16, v24
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v17, v17, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v21, v5, v13
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v18, v18, t4
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v22, v6, v14
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v19, v19, t4
add  s6, s6, tp;   add  s7, s7, ra;                vsub.vv  v23, v7, v15
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v20, v20, t4
mul  tp, s6, t1;   mul  ra, s7, t1;                vsub.vv  v24, v8, v16
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v9,  v9,  v17
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v10, v10, v18
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v11, v11, v19
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v12, v12, v20
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v17, v1, v9
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v18, v2, v10
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v19, v3, v11
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v20, v4, v12
mul  a7, a2, t2;   mul  gp, a3, t2;                vadd.vv  v13, v5, v13
sub  s6, s2, tp;   sub  s7, s3, ra;                vadd.vv  v14, v6, v14
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v15, v7, v15
mul  tp, a4, t2;   mul  ra, a5, t2;                vadd.vv  v16, v8, v16
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v9, v1, v9
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v10, v2, v10
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v11, v3, v11
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v12, v4, v12
addi tp, tp, 8;    addi ra, ra, 8;                 lw t6, 4*16(sp)
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
sub  a2, s8, a7;   sub  a3, s9, gp;                vmul.vx v1, v13, t5
add  s8, s8, a7;   add  s9, s9, gp;                vmul.vx v2, v14, t5
sub  a4, s10, tp;  sub  a5, s11, ra;               vmul.vx v3, v15, t5
add  s10, s10, tp; add  s11, s11, ra;              vmul.vx v4, v16, t5
lw   ra, 4*4(a1);                                  lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
mul  a7, s2, t3;   mul  gp, s3, t3;                vmul.vx v5, v21, t5
mul  tp, s6, ra;   mul  ra, s7, ra;                vmul.vx v6, v22, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v7, v23, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v8, v24, t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v13, v13, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v14, v14, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v15, v15, t5
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vx v16, v16, t5
sub  s6, s4, tp;   sub  s7, s5, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v21, v21, t5
lw   gp, 5*4(a1);                                  vmulh.vx v22, v22, t5
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v23, v23, t5
lw   ra, 6*4(a1);                                  vmulh.vx v24, v24, t5
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vx v1, v1, t4
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v2, v2, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v3, v3, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v4, v4, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v13, v13, v1
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v14, v14, v2
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v15, v15, v3
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v16, v16, v4
sub  s10, s8, a7;  sub  s11, s9, gp;               vmulh.vx v5, v5, t4
sub  a4, a2, tp;   sub  a5, a3, ra;                vadd.vv  v1, v9,  v13
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v6, v6, t4
add  a2, a2, tp;   add  a3, a3, ra;                vadd.vv  v2, v10, v14
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vmulh.vx v7, v7, t4
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vadd.vv  v3, v11, v15
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vmulh.vx v8, v8, t4
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vadd.vv  v4, v12, v16
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vsub.vv  v21, v21, v5
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vsub.vv  v22, v22, v6
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vsub.vv  v23, v23, v7
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vsub.vv  v24, v24, v8
addi a0, a0, 32;                                   vadd.vv  v5, v17, v21
addi a1, a1, 7*4;                                  vadd.vv  v6, v18, v22
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vadd.vv  v7, v19, v23
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vadd.vv  v8, v20, v24
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vsub.vv  v9, v9,  v13
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vsub.vv  v10, v10,v14
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vsub.vv  v11,v11, v15
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vsub.vv  v12,v12, v16
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vsub.vv  v13,v17, v21
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vsub.vv  v14,v18, v22
lw t0, 0*4(a1);                                    vsub.vv  v15,v19, v23
lw t1, 1*4(a1);                                    vsub.vv  v16,v20, v24
lw t2, 2*4(a1);                                    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
lw t3, 3*4(a1);                                    vmul.vx v17, v3,  t5
mul  a7, s8, t0;   mul  gp, s9, t0;                vmul.vx v18, v4,  t5
mul  tp, s10, t0;  mul  ra, s11, t0;               lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v19, v11, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v20, v12, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v21, v7,  t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v22, v8,  t5
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vx v23, v15, t5
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vx v24, v16, t5
mul  a7, a2, t0;   mul  gp, a3, t0;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vx v3,  v3,  t5
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v4,  v4,  t5
mul  tp, a4, t0;   mul  ra, a5, t0;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v11, v11, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v12, v12, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v7,  v7,  t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v8,  v8,  t5
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v15, v15, t5
add  s4, s4, a7;   add  s5, s5, gp;                vmulh.vx v16, v16, t5
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v17, v17, t4
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v18, v18, t4
mul  a7, s4, t1;   mul  gp, s5, t1;                vmulh.vx v19, v19, t4
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v20, v20, t4
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v3,  v3,  v17
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v4,  v4,  v18
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v11, v11, v19
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v12, v12, v20
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v21, v21, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v17, v1,  v3
sub  s4, s0, a7;   sub  s5, s1, gp;                vmulh.vx v22, v22, t4
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v18, v2,  v4
mul  a7, a2, t2;   mul  gp, a3, t2;                vmulh.vx v23, v23, t4
sub  s6, s2, tp;   sub  s7, s3, ra;                vadd.vv  v19, v9,  v11
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v24, v24, t4
mul  tp, a4, t2;   mul  ra, a5, t2;                vadd.vv  v20, v10, v12
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v7,  v7,  v21
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v8,  v8,  v22
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v15, v15, v23
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v16, v16, v24
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v21, v5,  v7
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v22, v6,  v8
sub  a2, s8, a7;   sub  a3, s9, gp;                vadd.vv  v23, v13, v15
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v24, v14, v16
sub  a4, s10, tp;  sub  a5, s11, ra;               vsub.vv  v1,  v1,  v3
add  s10, s10, tp; add  s11, s11, ra;              vsub.vv  v2,  v2,  v4
lw   ra, 4*4(a1);                                  vsub.vv  v3,  v9,  v11
mul  a7, s2, t3;   mul  gp, s3, t3;                vsub.vv  v4,  v10, v12
mul  tp, s6, ra;   mul  ra, s7, ra;                vsub.vv  v5,  v5,  v7
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v6,  v6,  v8
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v7,  v13, v15
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v8,  v14, v16
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v9,  v18,  t5
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vx v18, v18, t5
sub  s6, s4, tp;   sub  s7, s5, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vx v10, v2,   t5
lw   gp, 5*4(a1);                                  lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v2,  v2,  t5
lw   ra, 6*4(a1);                                  lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
mul  a7, s10, gp;  mul  gp, s11, gp;               vmul.vx v11, v20,  t5
mul  tp, a4, ra;   mul  ra, a5, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v20, v20, t5
srai tp, tp, 16;   srai ra, ra, 16;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v12, v4,   t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v4,  v4,  t5
mulh tp, tp, a6;   mulh ra, ra, a6;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
sub  s10, s8, a7;  sub  s11, s9, gp;               vmul.vx v13, v22,  t5
sub  a4, a2, tp;   sub  a5, a3, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
add  s8, s8, a7;   add  s9, s9, gp;                vmulh.vx v22, v22, t5
add  a2, a2, tp;   add  a3, a3, ra;                lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vmul.vx v14, v6,   t5
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vmulh.vx v6,  v6,  t5
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vmul.vx v15, v24,  t5
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vmulh.vx v24, v24, t5
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
addi a0, a0, 32;                                   vmul.vx v16, v8,   t5
addi a1, a1, 7*4;                                  lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vmulh.vx v8,  v8,  t5
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmulh.vx v9,  v9,  t4
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vmulh.vx v10, v10, t4
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vmulh.vx v11, v11, t4
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vmulh.vx v12, v12, t4
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vsub.vv  v18, v18, v9
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vsub.vv  v2,  v2,  v10
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vsub.vv  v20, v20, v11
lw t0, 0*4(a1);                                    vsub.vv  v4,  v4,  v12
lw t1, 1*4(a1);                                    vmulh.vx v13, v13, t4
lw t2, 2*4(a1);                                    vadd.vv  v9,  v17, v18
lw t3, 3*4(a1);                                    vmulh.vx v14, v14, t4
mul  a7, s8, t0;   mul  gp, s9, t0;                vadd.vv  v10, v1,  v2
mul  tp, s10, t0;  mul  ra, s11, t0;               vmulh.vx v15, v15, t4
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v11, v19, v20
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v16, v16, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v12, v3, v4
srai tp, tp, 16;   srai ra, ra, 16;                addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v22, v22, v13
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v14
sub  s8, s0, a7;   sub  s9, s1, gp;                vsub.vv  v24, v24, v15
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v8,  v8,  v16
mul  a7, a2, t0;   mul  gp, a3, t0;                vsub.vv  v17, v17, v18
sub  s10, s2, tp;  sub  s11, s3, ra;               vsub.vv  v18, v1,  v2
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v19, v19, v20
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v20, v3,  v4
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v13, v21,  v22
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v14, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v15, v23, v24
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v2, v9, v31
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v1, v17, v30
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm v2, v17, v2, v0
sub  a2, s4, a7;   sub  a3, s5, gp;                vmerge.vvm v1, v1, v9, v0
add  s4, s4, a7;   add  s5, s5, gp;                vadd.vv  v16, v7, v8
sub  a4, s6, tp;   sub  a5, s7, ra;                vrgather.vv v4, v10, v31
add  s6, s6, tp;   add  s7, s7, ra;                vrgather.vv v3, v18, v30
mul  a7, s4, t1;   mul  gp, s5, t1;                vmerge.vvm v4, v18, v4, v0
mul  tp, s6, t1;   mul  ra, s7, t1;                vmerge.vvm v3, v3, v10, v0
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v21, v21, v22
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v22, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v23, v23, v24
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v24, v7,  v8
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L5 + 0*_ZETAS_EXP_1TO6_P1_L5)*2
mulh tp, tp, a6;   mulh ra, ra, a6;                vle16.v v27, (t6)
sub  s4, s0, a7;   sub  s5, s1, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s0, s0, a7;   add  s1, s1, gp;                vmul.vv  v9,  v2,  v27
mul  a7, a2, t2;   mul  gp, a3, t2;                vmulh.vv v2,  v2,  v26
sub  s6, s2, tp;   sub  s7, s3, ra;                vrgather.vv v6, v11, v31
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v5, v19, v30
mul  tp, a4, t2;   mul  ra, a5, t2;                vmerge.vvm v6, v19, v6, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm v5, v5, v11, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v8, v12, v31
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v7, v20, v30
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm v8, v20, v8, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v7, v7, v12, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  a2, s8, a7;   sub  a3, s9, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s8, s8, a7;   add  s9, s9, gp;                vmul.vv  v17, v4,  v27
sub  a4, s10, tp;  sub  a5, s11, ra;               vmulh.vv v4,  v4,  v26
add  s10, s10, tp; add  s11, s11, ra;              vmulh.vx v9,  v9,  t4
lw   ra, 4*4(a1);                                  vmulh.vx v17, v17, t4
mul  a7, s2, t3;   mul  gp, s3, t3;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s6, ra;   mul  ra, s7, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v10, v6,  v27
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vv v6,  v6,  v26
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v2,  v2,  v9
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v10, v10, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s2, s0, a7;   sub  s3, s1, gp;                vmul.vv  v18, v8,  v27
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vv v8,  v8,  v26
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v18, v18, t4
lw   gp, 5*4(a1);                                  vsub.vv  v4,  v4,  v17
add  s5, s5, ra;   add  s4, s4, tp;                vsub.vv  v6,  v6,  v10
lw   ra, 6*4(a1);                                  vsub.vv  v8,  v8,  v18
mul  a7, s10, gp;  mul  gp, s11, gp;               vadd.vv  v9,  v1,  v2
mul  tp, a4, ra;   mul  ra, a5, ra;                vsub.vv  v11, v1,  v2
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v17, v3,  v4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v19, v3,  v4
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v10, v5,  v6
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v12, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v2, v13, v31
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v1, v21, v30
sub  s10, s8, a7;  sub  s11, s9, gp;               vmerge.vvm v2, v21, v2, v0
sub  a4, a2, tp;   sub  a5, a3, ra;                vmerge.vvm v1, v1, v13, v0
add  s8, s8, a7;   add  s9, s9, gp;                vrgather.vv v4, v14, v31
add  a2, a2, tp;   add  a3, a3, ra;                vrgather.vv v3, v22, v30
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vmerge.vvm v4, v22, v4, v0
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmerge.vvm v3, v3, v14, v0
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vadd.vv  v18, v7,  v8
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vsub.vv  v20, v7,  v8
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vrgather.vv v6, v15, v31
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vrgather.vv v5, v23, v30
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vmerge.vvm v6, v23, v6, v0
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmerge.vvm v5, v5, v15, v0
addi a0, a0, 32;                                   vrgather.vv v8, v16, v31
addi a1, a1, 7*4;                                  vrgather.vv v7, v24, v30
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vmerge.vvm v8, v24, v8, v0
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmerge.vvm v7, v7, v16, v0
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           addi t6, t6, 8*2;     vle16.v v27, (t6)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           addi t6, t6, 8*2;     vle16.v v26, (t6)
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vmul.vv  v13, v2,  v27
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmulh.vv v2,  v2,  v26
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmulh.vx v13, v13, t4
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          addi t6, t6, 8*2;     vle16.v v27, (t6)
lw t0, 0*4(a1);                                    addi t6, t6, 8*2;     vle16.v v26, (t6)
lw t1, 1*4(a1);                                    vmul.vv  v21, v4,  v27
lw t2, 2*4(a1);                                    vmulh.vv v4,  v4,  v26
lw t3, 3*4(a1);                                    vmulh.vx v21, v21, t4
mul  a7, s8, t0;   mul  gp, s9, t0;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s10, t0;  mul  ra, s11, t0;               addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v14, v6,  v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v6,  v6,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v14, v14, t4
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v22, v8,  v27
sub  s8, s0, a7;   sub  s9, s1, gp;                vmulh.vv v8,  v8,  v26
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v2,  v2, v13
mul  a7, a2, t0;   mul  gp, a3, t0;                vsub.vv  v4,  v4, v21
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vx v22, v22, t4
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v6,  v6, v14
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v8,  v8, v22
srai a7, a7, 16;   srai gp, gp, 16;                lw t6, 4*16(sp)
addi a7, a7, 8;    addi gp, gp, 8;                 addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v13, v1,  v2
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v15, v1,  v2
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v21, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v23, v3,  v4
sub  a2, s4, a7;   sub  a3, s5, gp;                vadd.vv  v14, v5,  v6
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v16, v5,  v6
sub  a4, s6, tp;   sub  a5, s7, ra;                vrgather.vv v1, v11, v29
add  s6, s6, tp;   add  s7, s7, ra;                vmerge.vvm  v1, v1, v9, v0
mul  a7, s4, t1;   mul  gp, s5, t1;                vrgather.vv v2, v9, v28
mul  tp, s6, t1;   mul  ra, s7, t1;                vmerge.vvm  v2, v11, v2, v0
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v22, v7,  v8
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v24, v7,  v8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v3, v19, v29
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v3, v3, v17, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v4, v17, v28
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v4, v19, v4, v0
sub  s4, s0, a7;   sub  s5, s1, gp;                addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L6+ 0*_ZETAS_EXP_1TO6_P1_L6)*2
add  s0, s0, a7;   add  s1, s1, gp;                vle16.v v27, (t6)
mul  a7, a2, t2;   mul  gp, a3, t2;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s6, s2, tp;   sub  s7, s3, ra;                vmul.vv  v9,  v2,  v27
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vv v2,  v2,  v26
mul  tp, a4, t2;   mul  ra, a5, t2;                vrgather.vv v5, v12, v29
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v5, v5, v10, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v6, v10, v28
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v6, v12, v6, v0
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v11, v4,  v27
sub  a2, s8, a7;   sub  a3, s9, gp;                vmulh.vv v4,  v4,  v26
add  s8, s8, a7;   add  s9, s9, gp;                vrgather.vv v7, v20, v29
sub  a4, s10, tp;  sub  a5, s11, ra;               vmerge.vvm  v7, v7, v18, v0
add  s10, s10, tp; add  s11, s11, ra;              vrgather.vv v8, v18, v28
lw   ra, 4*4(a1);                                  vmerge.vvm  v8, v20, v8, v0
mul  a7, s2, t3;   mul  gp, s3, t3;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s6, ra;   mul  ra, s7, ra;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v17, v6,  v27
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vv v6,  v6,  v26
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v19, v8,  v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v8,  v8,  v26
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vx v9,  v9,  t4
sub  s6, s4, tp;   sub  s7, s5, ra;                vmulh.vx v11, v11, t4
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v17, v17, t4
lw   gp, 5*4(a1);                                  vmulh.vx v19, v19, t4
add  s5, s5, ra;   add  s4, s4, tp;                vsub.vv  v2,  v2,  v9
lw   ra, 6*4(a1);                                  vsub.vv  v4,  v4,  v11
mul  a7, s10, gp;  mul  gp, s11, gp;               vsub.vv  v6,  v6,  v17
mul  tp, a4, ra;   mul  ra, a5, ra;                vsub.vv  v8,  v8,  v19
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v9,  v1,  v2
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v11, v1,  v2
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v17, v3,  v4
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v19, v3,  v4
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v1, v15, v29
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v1, v1, v13, v0
sub  s10, s8, a7;  sub  s11, s9, gp;               vrgather.vv v2, v13, v28
sub  a4, a2, tp;   sub  a5, a3, ra;                vmerge.vvm  v2, v15, v2, v0
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v10, v5,  v6
add  a2, a2, tp;   add  a3, a3, ra;                vsub.vv  v12, v5,  v6
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vadd.vv  v18, v7,  v8
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vsub.vv  v20, v7,  v8
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vrgather.vv v3, v23, v29
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vmerge.vvm  v3, v3, v21, v0
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vrgather.vv v4, v21, v28
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmerge.vvm  v4, v23, v4, v0
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          addi t6, t6, 8*2;     vle16.v v27, (t6)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          addi t6, t6, 8*2;     vle16.v v26, (t6)
addi a0, a0, 32;                                   vmul.vv  v13, v2,  v27
addi a1, a1, 7*4;                                  vmulh.vv v2,  v2,  v26
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vrgather.vv v5, v16, v29
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmerge.vvm  v5, v5, v14, v0
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vrgather.vv v6, v14, v28
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vmerge.vvm  v6, v16, v6, v0
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           addi t6, t6, 8*2;     vle16.v v27, (t6)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          addi t6, t6, 8*2;     vle16.v v26, (t6)
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmul.vv  v15, v4,  v27
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vmulh.vv v4,  v4,  v26
lw t0, 0*4(a1);                                    vrgather.vv v7, v24, v29
lw t1, 1*4(a1);                                    vmerge.vvm  v7, v7, v22, v0
lw t2, 2*4(a1);                                    vrgather.vv v8, v22, v28
lw t3, 3*4(a1);                                    vmerge.vvm  v8, v24, v8, v0
mul  a7, s8, t0;   mul  gp, s9, t0;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s10, t0;  mul  ra, s11, t0;               addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v21, v6,  v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v6,  v6,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v27, (t6)
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v26, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vv  v23, v8,  v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vv v8,  v8,  v26
sub  s8, s0, a7;   sub  s9, s1, gp;                vmulh.vx v13, v13, t4
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v15, v15, t4
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v21, v21, t4
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vx v23, v23, t4
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v2,  v2,  v13
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v4,  v4,  v15
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v6,  v6,  v21
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v8,  v8,  v23
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v13, v1,  v2
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v15, v1,  v2
addi tp, tp, 8;    addi ra, ra, 8;                 lw t6, 4*16(sp)
mulh tp, tp, a6;   mulh ra, ra, a6;                addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
sub  a2, s4, a7;   sub  a3, s5, gp;                addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
add  s4, s4, a7;   add  s5, s5, gp;                vadd.vv  v21, v3,  v4
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v23, v3,  v4
add  s6, s6, tp;   add  s7, s7, ra;                vrgather.vv v1, v11, v27
mul  a7, s4, t1;   mul  gp, s5, t1;                vrgather.vv v2, v9, v27
mul  tp, s6, t1;   mul  ra, s7, t1;                vmerge.vvm  v1, v1, v9, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v2, v11, v2, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v14, v5,  v6
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v16, v5,  v6
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v3, v19, v27
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v4, v17, v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v3, v3, v17, v0
sub  s4, s0, a7;   sub  s5, s1, gp;                vmerge.vvm  v4, v19, v4, v0
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v22, v7,  v8
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v24, v7,  v8
sub  s6, s2, tp;   sub  s7, s3, ra;                vrgather.vv v5, v12, v27
add  s2, s2, tp;   add  s3, s3, ra;                vrgather.vv v6, v10, v27
mul  tp, a4, t2;   mul  ra, a5, t2;                vmerge.vvm  v5, v5, v10, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v6, v12, v6, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v7, v20, v27
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v8, v18, v27
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm  v7, v7, v18, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v8, v20, v8, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v9, v15, v27
sub  a2, s8, a7;   sub  a3, s9, gp;                vrgather.vv v11, v13, v27
add  s8, s8, a7;   add  s9, s9, gp;                vmerge.vvm  v9, v9, v13, v0
sub  a4, s10, tp;  sub  a5, s11, ra;               vmerge.vvm  v11, v15, v11, v0
add  s10, s10, tp; add  s11, s11, ra;              vrgather.vv v17, v23, v27
lw   ra, 4*4(a1);                                  vrgather.vv v19, v21, v27
mul  a7, s2, t3;   mul  gp, s3, t3;                vmerge.vvm  v17, v17, v21, v0
mul  tp, s6, ra;   mul  ra, s7, ra;                vmerge.vvm  v19, v23, v19, v0
srai a7, a7, 16;   srai gp, gp, 16;                vrgather.vv v10, v16, v27
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v12, v14, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v10, v10, v14, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v12, v16, v12, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v18, v24, v27
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v20, v22, v27
sub  s2, s0, a7;   sub  s3, s1, gp;                vmerge.vvm  v18, v18, v22, v0
sub  s6, s4, tp;   sub  s7, s5, ra;                vmerge.vvm  v20, v24, v20, v0
add  s0, s0, a7;   add  s1, s1, gp;                lw   t5, 4*15(sp);   addi t5, t5, (0*128)*2
lw   gp, 5*4(a1);                                  vse16.v  v1,  (t5);  addi t5, t5, 16
add  s5, s5, ra;   add  s4, s4, tp;                vse16.v  v2,  (t5);  addi t5, t5, 16
lw   ra, 6*4(a1);                                  vse16.v  v3,  (t5);  addi t5, t5, 16
mul  a7, s10, gp;  mul  gp, s11, gp;               vse16.v  v4,  (t5);  addi t5, t5, 16
mul  tp, a4, ra;   mul  ra, a5, ra;                vse16.v  v5,  (t5);  addi t5, t5, 16
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v6,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v7,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v8,  (t5);  addi t5, t5, -16*7-(0*128)*2+(64+0*128)*2
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v9,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v11, (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v17, (t5);  addi t5, t5, 16
sub  s10, s8, a7;  sub  s11, s9, gp;               vse16.v  v19, (t5);  addi t5, t5, 16
sub  a4, a2, tp;   sub  a5, a3, ra;                vse16.v  v10, (t5);  addi t5, t5, 16
add  s8, s8, a7;   add  s9, s9, gp;                vse16.v  v12, (t5);  addi t5, t5, 16
add  a2, a2, tp;   add  a3, a3, ra;                vse16.v  v18, (t5);  addi t5, t5, 16
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vse16.v  v20, (t5)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           lw   t5, 4*15(sp);  addi t5, t5, (64+1*128)*2
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vle16.v v9,  (t5);  addi t5, t5, 16
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vle16.v v10, (t5);  addi t5, t5, 16
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vle16.v v11, (t5);  addi t5, t5, 16
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vle16.v v12, (t5);  addi t5, t5, 16
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vle16.v v13, (t5);  addi t5, t5, 16
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vle16.v v14, (t5);  addi t5, t5, 16
addi a0, a0, 32;                                   vle16.v v15, (t5);  addi t5, t5, 16
addi a1, a1, 7*4;                                  vle16.v v16, (t5);  addi t5, t5, -16*7-(64+1*128)*2+(1*128)*2
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vle16.v v1,  (t5);  addi t5, t5, 16
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vle16.v v2,  (t5);  addi t5, t5, 16
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vle16.v v3,  (t5);  addi t5, t5, 16
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vle16.v v4,  (t5);  addi t5, t5, 16
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vle16.v v5,  (t5);  addi t5, t5, 16
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vle16.v v6,  (t5);  addi t5, t5, 16
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vle16.v v7,  (t5);  addi t5, t5, 16
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vle16.v v8,  (t5)
lw t0, 0*4(a1);                                    lw t6, 4*16(sp)
lw t1, 1*4(a1);                                    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
lw t2, 2*4(a1);                                    lh t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
lw t3, 3*4(a1);                                    vmul.vx v17, v9,  t5
mul  a7, s8, t0;   mul  gp, s9, t0;                vmul.vx v18, v10, t5
mul  tp, s10, t0;  mul  ra, s11, t0;               vmul.vx v19, v11, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v20, v12, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmul.vx v21, v13, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v22, v14, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v23, v15, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v24, v16, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v9,  v9,  t6
sub  s8, s0, a7;   sub  s9, s1, gp;                vmulh.vx v10, v10, t6
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v11, v11, t6
mul  a7, a2, t0;   mul  gp, a3, t0;                vmulh.vx v12, v12, t6
sub  s10, s2, tp;  sub  s11, s3, ra;               vmulh.vx v13, v13, t6
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vx v14, v14, t6
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vx v15, v15, t6
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v16, v16, t6
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v21, v21, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v22, v22, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v23, v23, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v24, v24, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v13, v13, v21
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v14, v14, v22
add  s4, s4, a7;   add  s5, s5, gp;                vsub.vv  v15, v15, v23
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v16, v16, v24
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v17, v17, t4
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v21, v5, v13
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v18, v18, t4
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v22, v6, v14
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v19, v19, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v23, v7, v15
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v20, v20, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v24, v8, v16
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v9,  v9,  v17
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v10, v10, v18
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v11, v11, v19
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v12, v12, v20
sub  s6, s2, tp;   sub  s7, s3, ra;                vsub.vv  v17, v1, v9
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v18, v2, v10
mul  tp, a4, t2;   mul  ra, a5, t2;                vsub.vv  v19, v3, v11
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v20, v4, v12
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v13, v5, v13
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v14, v6, v14
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v15, v7, v15
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v16, v8, v16
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v9, v1, v9
sub  a2, s8, a7;   sub  a3, s9, gp;                vadd.vv  v10, v2, v10
add  s8, s8, a7;   add  s9, s9, gp;                vadd.vv  v11, v3, v11
sub  a4, s10, tp;  sub  a5, s11, ra;               vadd.vv  v12, v4, v12
add  s10, s10, tp; add  s11, s11, ra;              lw t6, 4*16(sp)
lw   ra, 4*4(a1);                                  lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
mul  a7, s2, t3;   mul  gp, s3, t3;                vmul.vx v1, v13, t5
mul  tp, s6, ra;   mul  ra, s7, ra;                vmul.vx v2, v14, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v3, v15, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v4, v16, t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v5, v21, t5
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v6, v22, t5
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v7, v23, t5
sub  s2, s0, a7;   sub  s3, s1, gp;                vmul.vx v8, v24, t5
sub  s6, s4, tp;   sub  s7, s5, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v13, v13, t5
lw   gp, 5*4(a1);                                  vmulh.vx v14, v14, t5
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vx v15, v15, t5
lw   ra, 6*4(a1);                                  vmulh.vx v16, v16, t5
mul  a7, s10, gp;  mul  gp, s11, gp;               lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v21, v21, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v22, v22, t5
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v23, v23, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v24, v24, t5
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v1, v1, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v2, v2, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v3, v3, t4
sub  s10, s8, a7;  sub  s11, s9, gp;               vmulh.vx v4, v4, t4
sub  a4, a2, tp;   sub  a5, a3, ra;                vsub.vv  v13, v13, v1
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v14, v14, v2
add  a2, a2, tp;   add  a3, a3, ra;                vsub.vv  v15, v15, v3
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vsub.vv  v16, v16, v4
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmulh.vx v5, v5, t4
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vadd.vv  v1, v9,  v13
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vmulh.vx v6, v6, t4
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vadd.vv  v2, v10, v14
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmulh.vx v7, v7, t4
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vadd.vv  v3, v11, v15
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmulh.vx v8, v8, t4
addi a0, a0, 32;                                   vadd.vv  v4, v12, v16
addi a1, a1, 7*4;                                  vsub.vv  v21, v21, v5
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vsub.vv  v22, v22, v6
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vsub.vv  v23, v23, v7
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vsub.vv  v24, v24, v8
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vadd.vv  v5, v17, v21
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vadd.vv  v6, v18, v22
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vadd.vv  v7, v19, v23
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vadd.vv  v8, v20, v24
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vsub.vv  v9, v9,  v13
lw t0, 0*4(a1);                                    vsub.vv  v10, v10,v14
lw t1, 1*4(a1);                                    vsub.vv  v11,v11, v15
lw t2, 2*4(a1);                                    vsub.vv  v12,v12, v16
lw t3, 3*4(a1);                                    vsub.vv  v13,v17, v21
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v14,v18, v22
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v15,v19, v23
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v16,v20, v24
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vx v17, v3,  t5
srai tp, tp, 16;   srai ra, ra, 16;                vmul.vx v18, v4,  t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vx v19, v11, t5
sub  s8, s0, a7;   sub  s9, s1, gp;                vmul.vx v20, v12, t5
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
mul  a7, a2, t0;   mul  gp, a3, t0;                vmul.vx v21, v7,  t5
sub  s10, s2, tp;  sub  s11, s3, ra;               vmul.vx v22, v8,  t5
add  s2, s2, tp;   add  s3, s3, ra;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
mul  tp, a4, t0;   mul  ra, a5, t0;                vmul.vx v23, v15, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vx v24, v16, t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v3,  v3,  t5
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v4,  v4,  t5
addi tp, tp, 8;    addi ra, ra, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v11, v11, t5
sub  a2, s4, a7;   sub  a3, s5, gp;                vmulh.vx v12, v12, t5
add  s4, s4, a7;   add  s5, s5, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
sub  a4, s6, tp;   sub  a5, s7, ra;                vmulh.vx v7,  v7,  t5
add  s6, s6, tp;   add  s7, s7, ra;                vmulh.vx v8,  v8,  t5
mul  a7, s4, t1;   mul  gp, s5, t1;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
mul  tp, s6, t1;   mul  ra, s7, t1;                vmulh.vx v15, v15, t5
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v16, v16, t5
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v17, v17, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v18, v18, t4
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v19, v19, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v20, v20, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v3,  v3,  v17
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v4,  v4,  v18
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v11, v11, v19
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v12, v12, v20
sub  s6, s2, tp;   sub  s7, s3, ra;                vmulh.vx v21, v21, t4
add  s2, s2, tp;   add  s3, s3, ra;                vadd.vv  v17, v1,  v3
mul  tp, a4, t2;   mul  ra, a5, t2;                vmulh.vx v22, v22, t4
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v18, v2,  v4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v23, v23, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vadd.vv  v19, v9,  v11
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v24, v24, t4
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v20, v10, v12
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v7,  v7,  v21
sub  a2, s8, a7;   sub  a3, s9, gp;                vsub.vv  v8,  v8,  v22
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v15, v15, v23
sub  a4, s10, tp;  sub  a5, s11, ra;               vsub.vv  v16, v16, v24
add  s10, s10, tp; add  s11, s11, ra;              vadd.vv  v21, v5,  v7
lw   ra, 4*4(a1);                                  vadd.vv  v22, v6,  v8
mul  a7, s2, t3;   mul  gp, s3, t3;                vadd.vv  v23, v13, v15
mul  tp, s6, ra;   mul  ra, s7, ra;                vadd.vv  v24, v14, v16
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v1,  v1,  v3
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v2,  v2,  v4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v3,  v9,  v11
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v4,  v10, v12
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v5,  v5,  v7
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v8
sub  s2, s0, a7;   sub  s3, s1, gp;                vsub.vv  v7,  v13, v15
sub  s6, s4, tp;   sub  s7, s5, ra;                vsub.vv  v8,  v14, v16
add  s0, s0, a7;   add  s1, s1, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
lw   gp, 5*4(a1);                                  vmul.vx v9,  v18,  t5
add  s5, s5, ra;   add  s4, s4, tp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
lw   ra, 6*4(a1);                                  vmulh.vx v18, v18, t5
mul  a7, s10, gp;  mul  gp, s11, gp;               lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
mul  tp, a4, ra;   mul  ra, a5, ra;                vmul.vx v10, v2,   t5
srai a7, a7, 16;   srai gp, gp, 16;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v2,  v2,  t5
addi a7, a7, 8;    addi gp, gp, 8;                 lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
addi tp, tp, 8;    addi ra, ra, 8;                 vmul.vx v11, v20,  t5
mulh a7, a7, a6;   mulh gp, gp, a6;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmulh.vx v20, v20, t5
sub  s10, s8, a7;  sub  s11, s9, gp;               lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
sub  a4, a2, tp;   sub  a5, a3, ra;                vmul.vx v12, v4,   t5
add  s8, s8, a7;   add  s9, s9, gp;                lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
add  a2, a2, tp;   add  a3, a3, ra;                vmulh.vx v4,  v4,  t5
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmul.vx v13, v22,  t5
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vmulh.vx v22, v22, t5
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmul.vx v14, v6,   t5
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vmulh.vx v6,  v6,  t5
addi a0, a0, 32;                                   lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
addi a1, a1, 7*4;                                  vmul.vx v15, v24,  t5
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmulh.vx v24, v24, t5
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vmul.vx v16, v8,   t5
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmulh.vx v8,  v8,  t5
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmulh.vx v9,  v9,  t4
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vmulh.vx v10, v10, t4
lw t0, 0*4(a1);                                    vmulh.vx v11, v11, t4
lw t1, 1*4(a1);                                    vmulh.vx v12, v12, t4
lw t2, 2*4(a1);                                    vsub.vv  v18, v18, v9
lw t3, 3*4(a1);                                    vsub.vv  v2,  v2,  v10
mul  a7, s8, t0;   mul  gp, s9, t0;                vsub.vv  v20, v20, v11
mul  tp, s10, t0;  mul  ra, s11, t0;               vsub.vv  v4,  v4,  v12
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v13, v13, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vadd.vv  v9,  v17, v18
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v14, v14, t4
srai tp, tp, 16;   srai ra, ra, 16;                vadd.vv  v10, v1,  v2
addi tp, tp, 8;    addi ra, ra, 8;                 vmulh.vx v15, v15, t4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v11, v19, v20
sub  s8, s0, a7;   sub  s9, s1, gp;                vmulh.vx v16, v16, t4
add  s0, s0, a7;   add  s1, s1, gp;                vadd.vv  v12, v3, v4
mul  a7, a2, t0;   mul  gp, a3, t0;                addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
sub  s10, s2, tp;  sub  s11, s3, ra;               vsub.vv  v22, v22, v13
add  s2, s2, tp;   add  s3, s3, ra;                vsub.vv  v6,  v6,  v14
mul  tp, a4, t0;   mul  ra, a5, t0;                vsub.vv  v24, v24, v15
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v8,  v8,  v16
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v17, v17, v18
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v18, v1,  v2
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v19, v19, v20
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v20, v3,  v4
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v13, v21,  v22
sub  a2, s4, a7;   sub  a3, s5, gp;                vadd.vv  v14, v5,  v6
add  s4, s4, a7;   add  s5, s5, gp;                vadd.vv  v15, v23, v24
sub  a4, s6, tp;   sub  a5, s7, ra;                vrgather.vv v2, v9, v31
add  s6, s6, tp;   add  s7, s7, ra;                vrgather.vv v1, v17, v30
mul  a7, s4, t1;   mul  gp, s5, t1;                vmerge.vvm v2, v17, v2, v0
mul  tp, s6, t1;   mul  ra, s7, t1;                vmerge.vvm v1, v1, v9, v0
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v16, v7, v8
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v4, v10, v31
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v3, v18, v30
srai tp, tp, 16;   srai ra, ra, 16;                vmerge.vvm v4, v18, v4, v0
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v3, v3, v10, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v21, v21, v22
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v22, v5,  v6
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v23, v23, v24
mul  a7, a2, t2;   mul  gp, a3, t2;                vsub.vv  v24, v7,  v8
sub  s6, s2, tp;   sub  s7, s3, ra;                addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L5 + 1*_ZETAS_EXP_1TO6_P1_L5)*2
add  s2, s2, tp;   add  s3, s3, ra;                vle16.v v27, (t6)
mul  tp, a4, t2;   mul  ra, a5, t2;                addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v9,  v2,  v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v2,  v2,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v6, v11, v31
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v5, v19, v30
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm v6, v19, v6, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm v5, v5, v11, v0
sub  a2, s8, a7;   sub  a3, s9, gp;                vrgather.vv v8, v12, v31
add  s8, s8, a7;   add  s9, s9, gp;                vrgather.vv v7, v20, v30
sub  a4, s10, tp;  sub  a5, s11, ra;               vmerge.vvm v8, v20, v8, v0
add  s10, s10, tp; add  s11, s11, ra;              vmerge.vvm v7, v7, v12, v0
lw   ra, 4*4(a1);                                  addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  a7, s2, t3;   mul  gp, s3, t3;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mul  tp, s6, ra;   mul  ra, s7, ra;                vmul.vv  v17, v4,  v27
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vv v4,  v4,  v26
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vx v9,  v9,  t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v17, v17, t4
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v10, v6,  v27
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vv v6,  v6,  v26
sub  s6, s4, tp;   sub  s7, s5, ra;                vsub.vv  v2,  v2,  v9
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v10, v10, t4
lw   gp, 5*4(a1);                                  addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s5, s5, ra;   add  s4, s4, tp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
lw   ra, 6*4(a1);                                  vmul.vv  v18, v8,  v27
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vv v8,  v8,  v26
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v18, v18, t4
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v4,  v4,  v17
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v6,  v6,  v10
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v8,  v8,  v18
addi tp, tp, 8;    addi ra, ra, 8;                 vadd.vv  v9,  v1,  v2
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v11, v1,  v2
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v17, v3,  v4
sub  s10, s8, a7;  sub  s11, s9, gp;               vsub.vv  v19, v3,  v4
sub  a4, a2, tp;   sub  a5, a3, ra;                vadd.vv  v10, v5,  v6
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v12, v5,  v6
add  a2, a2, tp;   add  a3, a3, ra;                vrgather.vv v2, v13, v31
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vrgather.vv v1, v21, v30
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vmerge.vvm v2, v21, v2, v0
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vmerge.vvm v1, v1, v13, v0
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vrgather.vv v4, v14, v31
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vrgather.vv v3, v22, v30
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vmerge.vvm v4, v22, v4, v0
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vmerge.vvm v3, v3, v14, v0
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vadd.vv  v18, v7,  v8
addi a0, a0, 32;                                   vsub.vv  v20, v7,  v8
addi a1, a1, 7*4;                                  vrgather.vv v6, v15, v31
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vrgather.vv v5, v23, v30
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           vmerge.vvm v6, v23, v6, v0
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           vmerge.vvm v5, v5, v15, v0
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vrgather.vv v8, v16, v31
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vrgather.vv v7, v24, v30
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vmerge.vvm v8, v24, v8, v0
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmerge.vvm v7, v7, v16, v0
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          addi t6, t6, 8*2;     vle16.v v27, (t6)
lw t0, 0*4(a1);                                    addi t6, t6, 8*2;     vle16.v v26, (t6)
lw t1, 1*4(a1);                                    vmul.vv  v13, v2,  v27
lw t2, 2*4(a1);                                    vmulh.vv v2,  v2,  v26
lw t3, 3*4(a1);                                    vmulh.vx v13, v13, t4
mul  a7, s8, t0;   mul  gp, s9, t0;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  tp, s10, t0;  mul  ra, s11, t0;               addi t6, t6, 8*2;     vle16.v v26, (t6)
srai a7, a7, 16;   srai gp, gp, 16;                vmul.vv  v21, v4,  v27
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vv v4,  v4,  v26
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v21, v21, t4
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v14, v6,  v27
sub  s8, s0, a7;   sub  s9, s1, gp;                vmulh.vv v6,  v6,  v26
add  s0, s0, a7;   add  s1, s1, gp;                vmulh.vx v14, v14, t4
mul  a7, a2, t0;   mul  gp, a3, t0;                addi t6, t6, 8*2;     vle16.v v27, (t6)
sub  s10, s2, tp;  sub  s11, s3, ra;               addi t6, t6, 8*2;     vle16.v v26, (t6)
add  s2, s2, tp;   add  s3, s3, ra;                vmul.vv  v22, v8,  v27
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vv v8,  v8,  v26
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v2,  v2, v13
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v4,  v4, v21
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v22, v22, t4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v6,  v6, v14
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v8,  v8, v22
mulh tp, tp, a6;   mulh ra, ra, a6;                lw t6, 4*16(sp)
sub  a2, s4, a7;   sub  a3, s5, gp;                addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
add  s4, s4, a7;   add  s5, s5, gp;                vadd.vv  v13, v1,  v2
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v15, v1,  v2
add  s6, s6, tp;   add  s7, s7, ra;                vadd.vv  v21, v3,  v4
mul  a7, s4, t1;   mul  gp, s5, t1;                vsub.vv  v23, v3,  v4
mul  tp, s6, t1;   mul  ra, s7, t1;                vadd.vv  v14, v5,  v6
srai a7, a7, 16;   srai gp, gp, 16;                vsub.vv  v16, v5,  v6
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v1, v11, v29
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v1, v1, v9, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v2, v9, v28
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v2, v11, v2, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v22, v7,  v8
sub  s4, s0, a7;   sub  s5, s1, gp;                vsub.vv  v24, v7,  v8
add  s0, s0, a7;   add  s1, s1, gp;                vrgather.vv v3, v19, v29
mul  a7, a2, t2;   mul  gp, a3, t2;                vmerge.vvm  v3, v3, v17, v0
sub  s6, s2, tp;   sub  s7, s3, ra;                vrgather.vv v4, v17, v28
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm  v4, v19, v4, v0
mul  tp, a4, t2;   mul  ra, a5, t2;                addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L6+ 1*_ZETAS_EXP_1TO6_P1_L6)*2
srai a7, a7, 16;   srai gp, gp, 16;                vle16.v v27, (t6)
addi a7, a7, 8;    addi gp, gp, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                vmul.vv  v9,  v2,  v27
srai tp, tp, 16;   srai ra, ra, 16;                vmulh.vv v2,  v2,  v26
addi tp, tp, 8;    addi ra, ra, 8;                 vrgather.vv v5, v12, v29
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v5, v5, v10, v0
sub  a2, s8, a7;   sub  a3, s9, gp;                vrgather.vv v6, v10, v28
add  s8, s8, a7;   add  s9, s9, gp;                vmerge.vvm  v6, v12, v6, v0
sub  a4, s10, tp;  sub  a5, s11, ra;               addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s10, s10, tp; add  s11, s11, ra;              addi t6, t6, 8*2;     vle16.v v26, (t6)
lw   ra, 4*4(a1);                                  vmul.vv  v11, v4,  v27
mul  a7, s2, t3;   mul  gp, s3, t3;                vmulh.vv v4,  v4,  v26
mul  tp, s6, ra;   mul  ra, s7, ra;                vrgather.vv v7, v20, v29
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v7, v7, v18, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v8, v18, v28
addi a7, a7, 8;    addi gp, gp, 8;                 vmerge.vvm  v8, v20, v8, v0
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v27, (t6)
mulh a7, a7, a6;   mulh gp, gp, a6;                addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v17, v6,  v27
sub  s2, s0, a7;   sub  s3, s1, gp;                vmulh.vv v6,  v6,  v26
sub  s6, s4, tp;   sub  s7, s5, ra;                addi t6, t6, 8*2;     vle16.v v27, (t6)
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, 8*2;     vle16.v v26, (t6)
lw   gp, 5*4(a1);                                  vmul.vv  v19, v8,  v27
add  s5, s5, ra;   add  s4, s4, tp;                vmulh.vv v8,  v8,  v26
lw   ra, 6*4(a1);                                  vmulh.vx v9,  v9,  t4
mul  a7, s10, gp;  mul  gp, s11, gp;               vmulh.vx v11, v11, t4
mul  tp, a4, ra;   mul  ra, a5, ra;                vmulh.vx v17, v17, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v19, v19, t4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v2,  v2,  v9
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v4,  v4,  v11
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v6,  v6,  v17
mulh a7, a7, a6;   mulh gp, gp, a6;                vsub.vv  v8,  v8,  v19
mulh tp, tp, a6;   mulh ra, ra, a6;                vadd.vv  v9,  v1,  v2
sub  s10, s8, a7;  sub  s11, s9, gp;               vsub.vv  v11, v1,  v2
sub  a4, a2, tp;   sub  a5, a3, ra;                vadd.vv  v17, v3,  v4
add  s8, s8, a7;   add  s9, s9, gp;                vsub.vv  v19, v3,  v4
add  a2, a2, tp;   add  a3, a3, ra;                vrgather.vv v1, v15, v29
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vmerge.vvm  v1, v1, v13, v0
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vrgather.vv v2, v13, v28
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vmerge.vvm  v2, v15, v2, v0
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vadd.vv  v10, v5,  v6
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vsub.vv  v12, v5,  v6
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vadd.vv  v18, v7,  v8
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0);          vsub.vv  v20, v7,  v8
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0);          vrgather.vv v3, v23, v29
addi a0, a0, 32;                                   vmerge.vvm  v3, v3, v21, v0
addi a1, a1, 7*4;                                  vrgather.vv v4, v21, v28
lh s0,  1*2*0(a0);    lh s1,  1*2*1(a0);           vmerge.vvm  v4, v23, v4, v0
lh s2,  1*2*2(a0);    lh s3,  1*2*3(a0);           addi t6, t6, 8*2;     vle16.v v27, (t6)
lh s4,  1*2*4(a0);    lh s5,  1*2*5(a0);           addi t6, t6, 8*2;     vle16.v v26, (t6)
lh s6,  1*2*6(a0);    lh s7,  1*2*7(a0);           vmul.vv  v13, v2,  v27
lh s8,  1*2*8(a0);    lh s9,  1*2*9(a0);           vmulh.vv v2,  v2,  v26
lh s10, 1*2*10(a0);   lh s11, 1*2*11(a0);          vrgather.vv v5, v16, v29
lh a2,  1*2*12(a0);   lh a3,  1*2*13(a0);          vmerge.vvm  v5, v5, v14, v0
lh a4,  1*2*14(a0);   lh a5,  1*2*15(a0);          vrgather.vv v6, v14, v28
lw t0, 0*4(a1);                                    vmerge.vvm  v6, v16, v6, v0
lw t1, 1*4(a1);                                    addi t6, t6, 8*2;     vle16.v v27, (t6)
lw t2, 2*4(a1);                                    addi t6, t6, 8*2;     vle16.v v26, (t6)
lw t3, 3*4(a1);                                    vmul.vv  v15, v4,  v27
mul  a7, s8, t0;   mul  gp, s9, t0;                vmulh.vv v4,  v4,  v26
mul  tp, s10, t0;  mul  ra, s11, t0;               vrgather.vv v7, v24, v29
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v7, v7, v22, v0
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v8, v22, v28
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v8, v24, v8, v0
srai tp, tp, 16;   srai ra, ra, 16;                addi t6, t6, 8*2;     vle16.v v27, (t6)
addi tp, tp, 8;    addi ra, ra, 8;                 addi t6, t6, 8*2;     vle16.v v26, (t6)
mulh tp, tp, a6;   mulh ra, ra, a6;                vmul.vv  v21, v6,  v27
sub  s8, s0, a7;   sub  s9, s1, gp;                vmulh.vv v6,  v6,  v26
add  s0, s0, a7;   add  s1, s1, gp;                addi t6, t6, 8*2;     vle16.v v27, (t6)
mul  a7, a2, t0;   mul  gp, a3, t0;                addi t6, t6, 8*2;     vle16.v v26, (t6)
sub  s10, s2, tp;  sub  s11, s3, ra;               vmul.vv  v23, v8,  v27
add  s2, s2, tp;   add  s3, s3, ra;                vmulh.vv v8,  v8,  v26
mul  tp, a4, t0;   mul  ra, a5, t0;                vmulh.vx v13, v13, t4
srai a7, a7, 16;   srai gp, gp, 16;                vmulh.vx v15, v15, t4
addi a7, a7, 8;    addi gp, gp, 8;                 vmulh.vx v21, v21, t4
mulh a7, a7, a6;   mulh gp, gp, a6;                vmulh.vx v23, v23, t4
srai tp, tp, 16;   srai ra, ra, 16;                vsub.vv  v2,  v2,  v13
addi tp, tp, 8;    addi ra, ra, 8;                 vsub.vv  v4,  v4,  v15
mulh tp, tp, a6;   mulh ra, ra, a6;                vsub.vv  v6,  v6,  v21
sub  a2, s4, a7;   sub  a3, s5, gp;                vsub.vv  v8,  v8,  v23
add  s4, s4, a7;   add  s5, s5, gp;                vadd.vv  v13, v1,  v2
sub  a4, s6, tp;   sub  a5, s7, ra;                vsub.vv  v15, v1,  v2
add  s6, s6, tp;   add  s7, s7, ra;                lw t6, 4*16(sp)
mul  a7, s4, t1;   mul  gp, s5, t1;                addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
mul  tp, s6, t1;   mul  ra, s7, t1;                addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v21, v3,  v4
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v23, v3,  v4
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v1, v11, v27
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v2, v9, v27
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v1, v1, v9, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v2, v11, v2, v0
sub  s4, s0, a7;   sub  s5, s1, gp;                vadd.vv  v14, v5,  v6
add  s0, s0, a7;   add  s1, s1, gp;                vsub.vv  v16, v5,  v6
mul  a7, a2, t2;   mul  gp, a3, t2;                vrgather.vv v3, v19, v27
sub  s6, s2, tp;   sub  s7, s3, ra;                vrgather.vv v4, v17, v27
add  s2, s2, tp;   add  s3, s3, ra;                vmerge.vvm  v3, v3, v17, v0
mul  tp, a4, t2;   mul  ra, a5, t2;                vmerge.vvm  v4, v19, v4, v0
srai a7, a7, 16;   srai gp, gp, 16;                vadd.vv  v22, v7,  v8
addi a7, a7, 8;    addi gp, gp, 8;                 vsub.vv  v24, v7,  v8
mulh a7, a7, a6;   mulh gp, gp, a6;                vrgather.vv v5, v12, v27
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v6, v10, v27
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v5, v5, v10, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vmerge.vvm  v6, v12, v6, v0
sub  a2, s8, a7;   sub  a3, s9, gp;                vrgather.vv v7, v20, v27
add  s8, s8, a7;   add  s9, s9, gp;                vrgather.vv v8, v18, v27
sub  a4, s10, tp;  sub  a5, s11, ra;               vmerge.vvm  v7, v7, v18, v0
add  s10, s10, tp; add  s11, s11, ra;              vmerge.vvm  v8, v20, v8, v0
lw   ra, 4*4(a1);                                  vrgather.vv v9, v15, v27
mul  a7, s2, t3;   mul  gp, s3, t3;                vrgather.vv v11, v13, v27
mul  tp, s6, ra;   mul  ra, s7, ra;                vmerge.vvm  v9, v9, v13, v0
srai a7, a7, 16;   srai gp, gp, 16;                vmerge.vvm  v11, v15, v11, v0
srai tp, tp, 16;   srai ra, ra, 16;                vrgather.vv v17, v23, v27
addi a7, a7, 8;    addi gp, gp, 8;                 vrgather.vv v19, v21, v27
addi tp, tp, 8;    addi ra, ra, 8;                 vmerge.vvm  v17, v17, v21, v0
mulh a7, a7, a6;   mulh gp, gp, a6;                vmerge.vvm  v19, v23, v19, v0
mulh tp, tp, a6;   mulh ra, ra, a6;                vrgather.vv v10, v16, v27
sub  s2, s0, a7;   sub  s3, s1, gp;                vrgather.vv v12, v14, v27
sub  s6, s4, tp;   sub  s7, s5, ra;                vmerge.vvm  v10, v10, v14, v0
add  s0, s0, a7;   add  s1, s1, gp;                vmerge.vvm  v12, v16, v12, v0
lw   gp, 5*4(a1);                                  vrgather.vv v18, v24, v27
add  s5, s5, ra;   add  s4, s4, tp;                vrgather.vv v20, v22, v27
lw   ra, 6*4(a1);                                  vmerge.vvm  v18, v18, v22, v0
mul  a7, s10, gp;  mul  gp, s11, gp;               vmerge.vvm  v20, v24, v20, v0
mul  tp, a4, ra;   mul  ra, a5, ra;                lw   t5, 4*15(sp);   addi t5, t5, (1*128)*2
srai a7, a7, 16;   srai gp, gp, 16;                vse16.v  v1,  (t5);  addi t5, t5, 16
srai tp, tp, 16;   srai ra, ra, 16;                vse16.v  v2,  (t5);  addi t5, t5, 16
addi a7, a7, 8;    addi gp, gp, 8;                 vse16.v  v3,  (t5);  addi t5, t5, 16
addi tp, tp, 8;    addi ra, ra, 8;                 vse16.v  v4,  (t5);  addi t5, t5, 16
mulh a7, a7, a6;   mulh gp, gp, a6;                vse16.v  v5,  (t5);  addi t5, t5, 16
mulh tp, tp, a6;   mulh ra, ra, a6;                vse16.v  v6,  (t5);  addi t5, t5, 16
sub  s10, s8, a7;  sub  s11, s9, gp;               vse16.v  v7,  (t5);  addi t5, t5, 16
sub  a4, a2, tp;   sub  a5, a3, ra;                vse16.v  v8,  (t5);  addi t5, t5, -16*7-(1*128)*2+(64+1*128)*2
add  s8, s8, a7;   add  s9, s9, gp;                vse16.v  v9,  (t5);  addi t5, t5, 16
add  a2, a2, tp;   add  a3, a3, ra;                vse16.v  v11, (t5);  addi t5, t5, 16
sh s0,  1*2*0(a0);    sh s1,  1*2*1(a0);           vse16.v  v17, (t5);  addi t5, t5, 16
sh s2,  1*2*2(a0);    sh s3,  1*2*3(a0);           vse16.v  v19, (t5);  addi t5, t5, 16
sh s4,  1*2*4(a0);    sh s5,  1*2*5(a0);           vse16.v  v10, (t5);  addi t5, t5, 16
sh s6,  1*2*6(a0);    sh s7,  1*2*7(a0);           vse16.v  v12, (t5);  addi t5, t5, 16
sh s8,  1*2*8(a0);    sh s9,  1*2*9(a0);           vse16.v  v18, (t5);  addi t5, t5, 16
sh s10, 1*2*10(a0);   sh s11, 1*2*11(a0);          vse16.v  v20, (t5)
sh a2,  1*2*12(a0);   sh a3,  1*2*13(a0)
sh a4,  1*2*14(a0);   sh a5,  1*2*15(a0)
    restore_regs
    addi sp, sp, 4*17
    ret