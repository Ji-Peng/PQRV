.text

// 30-gp, a0, a1, a2; 26 usable.
// s0-s11, a3: 13 coeffs from poly0
// a5-a7, t0-t6: 3+7=10; tp, ra
.macro load_26coeffs poly0, poly1
  lh s0,  2*0(\poly0)
  lh s1,  2*1(\poly0)
  lh s2,  2*2(\poly0)
  lh s3,  2*3(\poly0)
  lh s4,  2*4(\poly0)
  lh s5,  2*5(\poly0)
  lh s6,  2*6(\poly0)
  lh s7,  2*7(\poly0)
  lh s8,  2*8(\poly0)
  lh s9,  2*9(\poly0)
  lh s10, 2*10(\poly0)
  lh s11, 2*11(\poly0)
  lh a3,  2*12(\poly0)

  lh a4,  2*0(\poly1)
  lh a5,  2*1(\poly1)
  lh a6,  2*2(\poly1)
  lh a7,  2*3(\poly1)
  lh t0,  2*4(\poly1)
  lh t1,  2*5(\poly1)
  lh t2,  2*6(\poly1)
  lh t3,  2*7(\poly1)
  lh t4,  2*8(\poly1)
  lh t5,  2*9(\poly1)
  lh t6,  2*10(\poly1)
  lh tp,  2*11(\poly1)
  lh ra,  2*12(\poly1)
.endm

.macro store_13coeffs poly0
  sh s0,  2*0(\poly0)
  sh s1,  2*1(\poly0)
  sh s2,  2*2(\poly0)
  sh s3,  2*3(\poly0)
  sh s4,  2*4(\poly0)
  sh s5,  2*5(\poly0)
  sh s6,  2*6(\poly0)
  sh s7,  2*7(\poly0)
  sh s8,  2*8(\poly0)
  sh s9,  2*9(\poly0)
  sh s10, 2*10(\poly0)
  sh s11, 2*11(\poly0)
  sh a3,  2*12(\poly0)
.endm

.macro load_18coeffs poly0, poly1
  lh s0,  2*0(\poly0)
  lh s1,  2*1(\poly0)
  lh s2,  2*2(\poly0)
  lh s3,  2*3(\poly0)
  lh s4,  2*4(\poly0)
  lh s5,  2*5(\poly0)
  lh s6,  2*6(\poly0)
  lh s7,  2*7(\poly0)
  lh s8,  2*8(\poly0)

  lh a4,  2*0(\poly1)
  lh a5,  2*1(\poly1)
  lh a6,  2*2(\poly1)
  lh a7,  2*3(\poly1)
  lh t0,  2*4(\poly1)
  lh t1,  2*5(\poly1)
  lh t2,  2*6(\poly1)
  lh t3,  2*7(\poly1)
  lh t4,  2*8(\poly1)
.endm

.macro store_9coeffs poly0
  sh s0,  2*0(\poly0)
  sh s1,  2*1(\poly0)
  sh s2,  2*2(\poly0)
  sh s3,  2*3(\poly0)
  sh s4,  2*4(\poly0)
  sh s5,  2*5(\poly0)
  sh s6,  2*6(\poly0)
  sh s7,  2*7(\poly0)
  sh s8,  2*8(\poly0)
.endm

.macro operate_13coeffs oper
    \oper s0,  s0,  a4
    \oper s1,  s1,  a5
    \oper s2,  s2,  a6
    \oper s3,  s3,  a7
    \oper s4,  s4,  t0
    \oper s5,  s5,  t1
    \oper s6,  s6,  t2
    \oper s7,  s7,  t3
    \oper s8,  s8,  t4
    \oper s9,  s9,  t5
    \oper s10, s10, t6
    \oper s11, s11, tp
    \oper a3,  a3,  ra
.endm

.macro operate_9coeffs oper
    \oper s0,  s0,  a4
    \oper s1,  s1,  a5
    \oper s2,  s2,  a6
    \oper s3,  s3,  a7
    \oper s4,  s4,  t0
    \oper s5,  s5,  t1
    \oper s6,  s6,  t2
    \oper s7,  s7,  t3
    \oper s8,  s8,  t4
.endm

// API: a0: r, a1: a, a2: b; 
// usable: a3-a7: 5, t0-t6: 7

.align 2
.global pointwise_sub
pointwise_sub:
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
  
  addi gp, x0, 19
  loop1:
    load_26coeffs a1, a2

    operate_13coeffs sub

    store_13coeffs a0

    addi a0, a0, 13*2
    addi a1, a1, 13*2
    addi a2, a2, 13*2
    addi gp, gp, -1
  bne gp, zero, loop1

  // 9 coeffs left
  load_18coeffs a1, a2

  operate_9coeffs sub

  store_9coeffs a0

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

.align 2
.global pointwise_add
pointwise_add:
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
  
  addi gp, x0, 19
  loop2:
    load_26coeffs a1, a2

    operate_13coeffs add

    store_13coeffs a0

    addi a0, a0, 13*2
    addi a1, a1, 13*2
    addi a2, a2, 13*2
    addi gp, gp, -1
  bne gp, zero, loop2

  // 9 coeffs left
  load_18coeffs a1, a2

  operate_9coeffs add

  store_9coeffs a0

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