#include "macros.i"
.text

.equ barrettconst, 20159
.equ q, 3329

// 30-gp: loop, a0: poly, tp: q, ra: tmp, a1: barrettconst; 25 usable. can load 25 coeffs
// s0-s11, a2-a7:12+6, t0-t6: 7
.global asm_barrett_reduce
.align 2
asm_barrett_reduce:
  addi sp, sp, -4*15
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

  li a1, barrettconst
  li tp, q
  
  addi gp, x0, 10
  loop1:
    lh s0,  2*0(a0)
    lh s1,  2*1(a0)
    lh s2,  2*2(a0)
    lh s3,  2*3(a0)
    lh s4,  2*4(a0)
    lh s5,  2*5(a0)
    lh s6,  2*6(a0)
    lh s7,  2*7(a0)
    lh s8,  2*8(a0)
    lh s9,  2*9(a0)
    lh s10, 2*10(a0)
    lh s11, 2*11(a0)
    lh a2,  2*12(a0) 
    lh a3,  2*13(a0)
    lh a4,  2*14(a0)
    lh a5,  2*15(a0) 
    lh a6,  2*16(a0)
    lh a7,  2*17(a0)
    lh t0,  2*18(a0)
    lh t1,  2*19(a0)
    lh t2,  2*20(a0)
    lh t3,  2*21(a0)
    lh t4,  2*22(a0)
    lh t5,  2*23(a0)
    lh t6,  2*24(a0)

    barrett_red s0,  ra, tp, a1
    barrett_red s1,  ra, tp, a1
    barrett_red s2,  ra, tp, a1
    barrett_red s3,  ra, tp, a1
    barrett_red s4,  ra, tp, a1
    barrett_red s5,  ra, tp, a1
    barrett_red s6,  ra, tp, a1
    barrett_red s7,  ra, tp, a1
    barrett_red s8,  ra, tp, a1
    barrett_red s9,  ra, tp, a1
    barrett_red s10, ra, tp, a1
    barrett_red s11, ra, tp, a1
    barrett_red a2,  ra, tp, a1
    barrett_red a3,  ra, tp, a1
    barrett_red a4,  ra, tp, a1
    barrett_red a5,  ra, tp, a1
    barrett_red a6,  ra, tp, a1
    barrett_red a7,  ra, tp, a1
    barrett_red t0,  ra, tp, a1
    barrett_red t1,  ra, tp, a1
    barrett_red t2,  ra, tp, a1
    barrett_red t3,  ra, tp, a1
    barrett_red t4,  ra, tp, a1
    barrett_red t5,  ra, tp, a1
    barrett_red t6,  ra, tp, a1

    sh s0,  2*0(a0)
    sh s1,  2*1(a0)
    sh s2,  2*2(a0)
    sh s3,  2*3(a0)
    sh s4,  2*4(a0)
    sh s5,  2*5(a0)
    sh s6,  2*6(a0)
    sh s7,  2*7(a0)
    sh s8,  2*8(a0)
    sh s9,  2*9(a0)
    sh s10, 2*10(a0)
    sh s11, 2*11(a0)
    sh a2,  2*12(a0) 
    sh a3,  2*13(a0)
    sh a4,  2*14(a0)
    sh a5,  2*15(a0) 
    sh a6,  2*16(a0)
    sh a7,  2*17(a0)
    sh t0,  2*18(a0)
    sh t1,  2*19(a0)
    sh t2,  2*20(a0)
    sh t3,  2*21(a0)
    sh t4,  2*22(a0)
    sh t5,  2*23(a0)
    sh t6,  2*24(a0)
    addi a0, a0, 25*2
    addi gp, gp, -1
  bne gp, zero, loop1

  lh s0,  2*0(a0)
  lh s1,  2*1(a0)
  lh s2,  2*2(a0)
  lh s3,  2*3(a0)
  lh s4,  2*4(a0)
  lh s5,  2*5(a0)

  barrett_red s0, ra, tp, a1
  barrett_red s1, ra, tp, a1
  barrett_red s2, ra, tp, a1
  barrett_red s3, ra, tp, a1
  barrett_red s4, ra, tp, a1
  barrett_red s5, ra, tp, a1

  sh s0,  2*0(a0)
  sh s1,  2*1(a0)
  sh s2,  2*2(a0)
  sh s3,  2*3(a0)
  sh s4,  2*4(a0)
  sh s5,  2*5(a0)
  
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
  addi sp, sp, 4*15
  ret
