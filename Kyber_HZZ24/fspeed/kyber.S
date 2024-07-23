#include "macros.i"

.text

.equ q16, 0x0d010000
.equ qinv, 0x6ba8f301

// API: a0: rptr, a1: aptr, a2: bptr, a3: zeta; a4-a7: poly0-poly3;
// t0: q<<16, t1: qinv; t2,t3: tmp
.global doublebasemul_asm
.align 2
doublebasemul_asm:

  li t0, q16
  li t1, qinv

  lh a4, 0(a1)// poly0
  lh a5, 2(a1)// poly1
  lh a6, 0(a2)// poly2
  lh a7, 2(a2)// poly3

  plant_mul_const t0, a3, a5, t2
  mul t2, t2, a7
  mul t3, a4, a6
  add t2, t2, t3
  plant_red t0, t1, t2
  sh t2, 0(a0)

  mul t2, a4, a7
  mul t3, a5, a6
  add t2, t2, t3
  plant_red t0, t1, t2
  sh t2, 2(a0)

  sub a3, zero, a3

  lh a4, 4(a1)// poly0
  lh a5, 6(a1)// poly1
  lh a6, 4(a2)// poly2
  lh a7, 6(a2)// poly3

  plant_mul_const t0, a3, a5, t2
  mul t2, t2, a7
  mul t3, a4, a6
  add t2, t2, t3
  plant_red t0, t1, t2
  sh t2, 4(a0)

  mul t2, a4, a7
  mul t3, a5, a6
  add t2, t2, t3
  plant_red t0, t1, t2
  sh t2, 6(a0)

  ret

// API: a0: rptr, a1: aptr, a2: bptr, a3: zeta; a4-a7: poly0-poly3;
// t0: q<<16, t1: qinv; t2-t3: tmp; t4,t5: res0, res1
.global doublebasemul_asm_acc
.align 2
doublebasemul_asm_acc:
  li t0, q16
  li t1, qinv

  lh a4, 0(a1)// poly0
  lh a5, 2(a1)// poly1
  lh a6, 0(a2)// poly2
  lh a7, 2(a2)// poly3
  lh t4, 0(a0)
  lh t5, 2(a0)

  plant_mul_const t0, a3, a5, t2
  mul t2, t2, a7
  mul t3, a4, a6
  add t2, t2, t3
  plant_red t0, t1, t2
  add t4, t4, t2
  sh t4, 0(a0)

  mul t2, a4, a7
  mul t3, a5, a6
  add t2, t2, t3
  plant_red t0, t1, t2
  add t5, t5, t2
  sh t5, 2(a0)

  sub a3, zero, a3

  lh a4, 4(a1)// poly0
  lh a5, 6(a1)// poly1
  lh a6, 4(a2)// poly2
  lh a7, 6(a2)// poly3
  lh t4, 4(a0)
  lh t5, 6(a0)

  plant_mul_const t0, a3, a5, t2
  mul t2, t2, a7
  mul t3, a4, a6
  add t2, t2, t3
  plant_red t0, t1, t2
  add t4, t4, t2
  sh t4, 4(a0)

  mul t2, a4, a7
  mul t3, a5, a6
  add t2, t2, t3
  plant_red t0, t1, t2
  add t5, t5, t2
  sh t5, 6(a0)

  ret
