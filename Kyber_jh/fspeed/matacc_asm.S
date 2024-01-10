#include "macros.i"

.text

.equ q16, 0x0d010000
.equ qinv, 0x6ba8f301

// doublebasemul_asm_cache_16_32(int32_t r_tmp_ptr[4], int16_t bprimeptr[2], int16_t bptr[4], int16_t cptr[4], int32_t zeta);
// a0: r_tmp_ptr, a1: bprimeptr, a2: bptr, a3: cptr; a4: zeta;
// a5: q<<16; a6: qinv; a7: tmp
// t0-t3: poly0, poly1; poly2, poly3
// t4, t5, t6: tmp
.global doublebasemul_asm_cache_16_32
.align 2
doublebasemul_asm_cache_16_32:
  li a5, q16

  lh t0, 0(a2) // poly0
  lh t1, 2(a2) // poly1
  lh t2, 0(a3) // poly2
  lh t3, 2(a3) // poly3

  plant_mul_const a5, a4, t1, t4
  sh t4, 2*0(a1) // store poly1*zeta for later use;
  mul t4, t4, t3
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  sw t4, 4*0(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  sw t4, 4*1(a0) // int32_t r_tmp

  neg a4, a4

  lh t0, 4(a2) // poly0
  lh t1, 6(a2) // poly1
  lh t2, 4(a3) // poly2
  lh t3, 6(a3) // poly3

  plant_mul_const a5, a4, t1, t4
  sh t4, 2*1(a1) // store poly1*zeta for later use;
  mul t4, t4, t3
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  sw t4, 4*2(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  sw t4, 4*3(a0) // int32_t r_tmp
  ret

// doublebasemul_asm_acc_cache_32_32(int32_t r_tmp_ptr[4], int16_t bprimeptr[2], int16_t bptr[4], int16_t cptr[4], int32_t zeta)
// a0: r_tmp_ptr, a1: bprimeptr, a2: bptr, a3: cptr; a4: zeta;
// a5: q<<16; a6: qinv; a7: tmp
// t0-t3: poly0, poly1; poly2, poly3
// t4, t5, t6: res
.global doublebasemul_asm_acc_cache_32_32
.align 2
doublebasemul_asm_acc_cache_32_32:
  li a5, q16

  lh t0, 0(a2) // poly0
  lh t1, 2(a2) // poly1
  lh t2, 0(a3) // poly2
  lh t3, 2(a3) // poly3

  plant_mul_const a5, a4, t1, t4
  sh t4, 2*0(a1) // store poly1*zeta for later use;
  mul t4, t4, t3
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  lw t5, 4*0(a0)
  add t4, t4, t5
  sw t4, 4*0(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  lw t5, 4*1(a0)
  add t4, t4, t5
  sw t4, 4*1(a0) // int32_t r_tmp

  neg a4, a4

  lh t0, 4(a2) // poly0
  lh t1, 6(a2) // poly1
  lh t2, 4(a3) // poly2
  lh t3, 6(a3) // poly3

  plant_mul_const a5, a4, t1, t4
  sh t4, 2*1(a1) // store poly1*zeta for later use;
  mul t4, t4, t3
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  lw t5, 4*2(a0)
  add t4, t4, t5
  sw t4, 4*2(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  lw t5, 4*3(a0)
  add t4, t4, t5
  sw t4, 4*3(a0) // int32_t r_tmp
  ret

// void doublebasemul_asm_acc_cache_32_16(int16_t r[4], int32_t r_tmp_ptr[4], int16_t bprimeptr[2], int16_t b_ptr[4], int16_t c_ptr[4], int32_t zeta);
// a0: r, a1: r_tmp_ptr, a2: bprimeptr, a3: bptr, a4: cptr; a5: zeta;
// a6: q<<16; a7: qinv
// t0-t3: poly0, poly1; poly2, poly3
// t4, t5, t6: res
.global doublebasemul_asm_acc_cache_32_16
.align 2
doublebasemul_asm_acc_cache_32_16:
  li a6, q16
  li a7, qinv

  lh t0, 0(a3) // poly0
  lh t1, 2(a3) // poly1
  lh t2, 0(a4) // poly2
  lh t3, 2(a4) // poly3

  plant_mul_const a6, a5, t1, t4
  sh t4, 2*0(a2) // store poly1*zeta for later use;
  mul t4, t4, t3
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  lw t5, 4*0(a1)
  add t4, t4, t5
  plant_red a6, a7, t4
  sh t4, 2*0(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  lw t5, 4*1(a1)
  add t4, t4, t5
  plant_red a6, a7, t4
  sh t4, 2*1(a0)

  neg a5, a5

  lh t0, 4(a3) // poly0
  lh t1, 6(a3) // poly1
  lh t2, 4(a4) // poly2
  lh t3, 6(a4) // poly3

  plant_mul_const a6, a5, t1, t4
  sh t4, 2*1(a2) // store poly1*zeta for later use;
  mul t4, t4, t3
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  lw t5, 4*2(a1)
  add t4, t4, t5
  plant_red a6, a7, t4
  sh t4, 2*2(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  lw t5, 4*3(a1)
  add t4, t4, t5
  plant_red a6, a7, t4
  sh t4, 2*3(a0)
  ret

// doublebasemul_asm_opt_16_32(int32_t r_tmp_ptr[4], int16_t bprimeptr[2], int16_t bptr[4], int16_t cptr[4]);
// a0: r_tmp_ptr, a1: bprimeptr, a2: bptr, a3: cptr;
// a5: q<<16; a6: qinv; a7: tmp
// t0-t3: poly0, poly1; poly2, poly3
// t4, t5, t6: res
.global doublebasemul_asm_opt_16_32
.align 2
doublebasemul_asm_opt_16_32:
  li a5, q16

  lh t0, 0(a2) // poly0
  lh t1, 2(a2) // poly1
  lh t2, 0(a3) // poly2
  lh t3, 2(a3) // poly3

  lh t5, 2*0(a1) // load cached value
  mul t4, t3, t5
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  sw t4, 4*0(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  sw t4, 4*1(a0)

  lh t0, 4(a2) // poly0
  lh t1, 6(a2) // poly1
  lh t2, 4(a3) // poly2
  lh t3, 6(a3) // poly3

  lh t5, 2*1(a1) // load cached value
  mul t4, t3, t5
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  sw t4, 4*2(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  sw t4, 4*3(a0)
  ret

// doublebasemul_asm_acc_opt_32_32(int32_t r_tmp_ptr[4], int16_t bprimeptr[2], int16_t bptr[4], int16_t cptr[4]);
// a0: r_tmp_ptr, a1: bprimeptr, a2: bptr, a3: cptr;
// a5: q<<16; a6: qinv; a7: tmp
// t0-t3: poly0, poly1; poly2, poly3
// t4, t5, t6: res
.global doublebasemul_asm_acc_opt_32_32
.align 2
doublebasemul_asm_acc_opt_32_32:
  li a5, q16

  lh t0, 0(a2) // poly0
  lh t1, 2(a2) // poly1
  lh t2, 0(a3) // poly2
  lh t3, 2(a3) // poly3

  lh t5, 2*0(a1) // load cached value
  mul t4, t3, t5
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  lw t5, 4*0(a0)
  add t4, t4, t5
  sw t4, 4*0(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  lw t5, 4*1(a0)
  add t4, t4, t5
  sw t4, 4*1(a0)

  lh t0, 4(a2) // poly0
  lh t1, 6(a2) // poly1
  lh t2, 4(a3) // poly2
  lh t3, 6(a3) // poly3

  lh t5, 2*1(a1) // load cached value
  mul t4, t3, t5
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  lw t5, 4*2(a0)
  add t4, t4, t5
  sw t4, 4*2(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  lw t5, 4*3(a0)
  add t4, t4, t5
  sw t4, 4*3(a0)
  ret

// doublebasemul_asm_acc_opt_32_16(int16_t r_ptr[4], int32_t r_tmp_ptr[4], int16_t bprimeptr[2], int16_t bptr[4], int16_t cptr[4]);
// a0: r_ptr, a1: r_tmp_ptr, a2: bprimeptr, a3: bptr, a4: cptr;
// a5: q<<16; a6: qinv; a7: tmp
// t0-t3: poly0, poly1; poly2, poly3
// t4, t5, t6: res
.global doublebasemul_asm_acc_opt_32_16
.align 2
doublebasemul_asm_acc_opt_32_16:
  li a5, q16
  li a6, qinv

  lh t0, 0(a3) // poly0
  lh t1, 2(a3) // poly1
  lh t2, 0(a4) // poly2
  lh t3, 2(a4) // poly3

  lh t5, 2*0(a2) // load cached value
  mul t4, t3, t5
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  lw t5, 4*0(a1)
  add t4, t4, t5
  plant_red a5, a6, t4
  sh t4, 2*0(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  lw t5, 4*1(a1)
  add t4, t4, t5
  plant_red a5, a6, t4
  sh t4, 2*1(a0)

  lh t0, 4(a3) // poly0
  lh t1, 6(a3) // poly1
  lh t2, 4(a4) // poly2
  lh t3, 6(a4) // poly3

  lh t5, 2*1(a2) // load cached value
  mul t4, t3, t5
  mul t5, t0, t2
  add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
  lw t5, 4*2(a1)
  add t4, t4, t5
  plant_red a5, a6, t4
  sh t4, 2*2(a0)

  mul t4, t0, t3
  mul t5, t1, t2
  add t4, t4, t5
  lw t5, 4*3(a1)
  add t4, t4, t5
  plant_red a5, a6, t4
  sh t4, 2*3(a0)
  ret
