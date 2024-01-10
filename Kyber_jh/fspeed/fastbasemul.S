#include "macros.i"

.text

.equ q16, 0x0d010000
.equ qinv, 0x6ba8f301
// void basemul_asm_opt_16_32(int32_t * t_tmp, const int16_t * b, const int16_t * c, const int16_t * bprime_ptr)
// API: a0: t_tmp, a1: bptr, a2: cptr, a3: bprime_ptr; a4: empty
// a5: q<<16, a6: qinv; t0-t3: poly0-poly3, t4, t5: tmp, t6: loop
.global basemul_asm_opt_16_32
.align 2
basemul_asm_opt_16_32:
  li a5, q16
  //li a6, qinv

  addi t6, x0, 64
  loop1:
    lh t0, 0(a1) // poly0
    lh t1, 2(a1) // poly1
    lh t2, 0(a2) // poly2
    lh t3, 2(a2) // poly3

    lh t5, 2*0(a3) // load cached value
    mul t4, t3, t5
    mul t5, t0, t2
    add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
    sw t4, 4*0(a0)

    mul t4, t0, t3
    mul t5, t1, t2
    add t4, t4, t5
    sw t4, 4*1(a0)

    lh t0, 4(a1) // poly0
    lh t1, 6(a1) // poly1
    lh t2, 4(a2) // poly2
    lh t3, 6(a2) // poly3

    lh t5, 2*1(a3) // load cached value
    mul t4, t3, t5
    mul t5, t0, t2
    add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
    sw t4, 4*2(a0)

    mul t4, t0, t3
    mul t5, t1, t2
    add t4, t4, t5
    sw t4, 4*3(a0)

    addi a0, a0, 16
    addi a1, a1, 8
    addi a2, a2, 8
    addi a3, a3, 4
    addi t6, t6, -1
  bne t6, zero, loop1
  ret


// basemul_asm_acc_opt_32_32(int32_t* r_tmp_ptr, int16_t* bptr, int16_t* cptr, int16_t* bprimeptr);
// API: a0: t_tmp, a1: bptr, a2: cptr, a3: bprime_ptr; a4: empty
// a5: q<<16, a6: qinv; t0-t3: poly0-poly3, t4, t5: tmp, t6: loop
.global basemul_asm_acc_opt_32_32
.align 2
basemul_asm_acc_opt_32_32:
  li a5, q16
  //li a6, qinv

  addi t6, x0, 64
  loop2:
    lh t0, 0(a1) // poly0
    lh t1, 2(a1) // poly1
    lh t2, 0(a2) // poly2
    lh t3, 2(a2) // poly3

    lh t5, 2*0(a3) // load cached value
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

    lh t0, 4(a1) // poly0
    lh t1, 6(a1) // poly1
    lh t2, 4(a2) // poly2
    lh t3, 6(a2) // poly3

    lh t5, 2*1(a3) // load cached value
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

    addi a0, a0, 16
    addi a1, a1, 8
    addi a2, a2, 8
    addi a3, a3, 4
    addi t6, t6, -1
  bne t6, zero, loop2
  ret

// basemul_asm_opt_32_16(int16_t* rptr, int16_t* bptr, int16_t* cptr, int16_t* bprimeptr, int32_t* r_tmp_ptr);
// API: a0: r, a1: bptr, a2: cptr, a3: bprime_ptr; a4: t_tmp_ptr
// a5: q<<16, a6: qinv; t0-t3: poly0-poly3, t4, t5: tmp, t6: loop
.global basemul_asm_acc_opt_32_16
.align 2
basemul_asm_acc_opt_32_16:
  li a5, q16
  li a6, qinv

  addi t6, x0, 64
  loop3:
    lh t0, 0(a1) // poly0
    lh t1, 2(a1) // poly1
    lh t2, 0(a2) // poly2
    lh t3, 2(a2) // poly3

    lh t5, 2*0(a3) // load cached value
    mul t4, t3, t5
    mul t5, t0, t2
    add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
    lw t5, 4*0(a4)
    add t4, t4, t5
    plant_red a5, a6, t4
    sh t4, 2*0(a0)

    mul t4, t0, t3
    mul t5, t1, t2
    add t4, t4, t5
    lw t5, 4*1(a4)
    add t4, t4, t5
    plant_red a5, a6, t4
    sh t4, 2*1(a0)

    lh t0, 4(a1) // poly0
    lh t1, 6(a1) // poly1
    lh t2, 4(a2) // poly2
    lh t3, 6(a2) // poly3

    lh t5, 2*1(a3) // load cached value
    mul t4, t3, t5
    mul t5, t0, t2
    add t4, t4, t5 // poly1*zeta*poly3+poly0*poly2
    lw t5, 4*2(a4)
    add t4, t4, t5
    plant_red a5, a6, t4
    sh t4, 2*2(a0)

    mul t4, t0, t3
    mul t5, t1, t2
    add t4, t4, t5
    lw t5, 4*3(a4)
    add t4, t4, t5
    plant_red a5, a6, t4
    sh t4, 2*3(a0)

    addi a0, a0, 8
    addi a1, a1, 8
    addi a2, a2, 8
    addi a3, a3, 4
    addi a4, a4, 16
    addi t6, t6, -1
  bne t6, zero, loop3
  ret
