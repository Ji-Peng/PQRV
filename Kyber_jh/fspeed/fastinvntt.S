#include "macros.i"

.text

.equ q16, 0x0d010000 //3329<<16
.equ plantconst, 0x13afb8 //plantconst*(p^-1) % 2^32

.macro fullplant coeff0, coeff1, coeff2, coeff3, coeff4, coeff5, coeff6, coeff7, q
  ### plantconst=plantconst*(p^-1) % 2^32
  li a7, plantconst
  plant_mul_const_inplace \q, a7, \coeff0
  plant_mul_const_inplace \q, a7, \coeff1
  plant_mul_const_inplace \q, a7, \coeff2
  plant_mul_const_inplace \q, a7, \coeff3
  plant_mul_const_inplace \q, a7, \coeff4
  plant_mul_const_inplace \q, a7, \coeff5
  plant_mul_const_inplace \q, a7, \coeff6
  plant_mul_const_inplace \q, a7, \coeff7
.endm

.macro halfplant coeff0, coeff1, coeff2, coeff3, q
  ### plantconst=plantconst*(p^-1) % 2^32
  li a7, plantconst
  plant_mul_const_inplace \q, a7, \coeff0
  plant_mul_const_inplace \q, a7, \coeff1
  plant_mul_const_inplace \q, a7, \coeff2
  plant_mul_const_inplace \q, a7, \coeff3
.endm

// |input|<kq; |output|<
// API: a0: poly, a1: 32-bit twiddle ptr; a6: q<<16; a7: tmp; gp: loop;
// s0-s11, a2-a5: 16 coeffs; 
// 16+2+1+1=20 regs; 
// 8 twiddle factors: can be preloaded; t0-t6, tp; ra: tmp zeta.
.global invntt_fast
.align 2
invntt_fast:
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

  li a6, q16 // q<<16

  ### LAYER 7+6+5
  addi gp, x0, 16
  loop1:
    // load coefficients
    load_coeffs a0, 1, 2
    // load twiddle factors

    lw t0, 0*4(a1)
    lw t1, 1*4(a1)
    lw t2, 2*4(a1)
    lw t3, 3*4(a1)
    lw t4, 4*4(a1)
    lw t5, 5*4(a1)
    lw t6, 6*4(a1)

    // layer 7
    gs_butterfly s0, s2,  t0, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    gs_butterfly s1, s3,  t0, a6, a7
    gs_butterfly s4, s6,  t1, a6, a7
    gs_butterfly s5, s7,  t1, a6, a7
    gs_butterfly s8, s10, t2, a6, a7
    gs_butterfly s9, s11, t2, a6, a7
    gs_butterfly a2, a4,  t3, a6, a7
    gs_butterfly a3, a5,  t3, a6, a7

    // layer 6
    gs_butterfly s0,  s4, t4, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    gs_butterfly s1,  s5, t4, a6, a7
    gs_butterfly s2,  s6, t4, a6, a7
    gs_butterfly s3,  s7, t4, a6, a7
    gs_butterfly s8,  a2, t5, a6, a7
    gs_butterfly s9,  a3, t5, a6, a7
    gs_butterfly s10, a4, t5, a6, a7
    gs_butterfly s11, a5, t5, a6, a7

    // layer 5
    gs_butterfly s0, s8,  t6, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    gs_butterfly s1, s9,  t6, a6, a7
    gs_butterfly s2, s10, t6, a6, a7
    gs_butterfly s3, s11, t6, a6, a7
    gs_butterfly s4, a2,  t6, a6, a7
    gs_butterfly s5, a3,  t6, a6, a7
    gs_butterfly s6, a4,  t6, a6, a7
    gs_butterfly s7, a5,  t6, a6, a7

    store_coeffs a0, 1, 2

    addi a0, a0, 32
    addi a1, a1, 4*7
  addi gp, gp, -1
  bne gp, zero, loop1

  addi a0, a0, -512

  ### LAYER 4+3+2+1
  
  // load 8 zetas
  lw t0, 0*4(a1)
  lw t1, 1*4(a1)
  lw t2, 2*4(a1)
  lw t3, 3*4(a1)
  lw t4, 4*4(a1)
  lw t5, 5*4(a1)
  lw t6, 6*4(a1)
  lw tp, 7*4(a1)

  addi a0, a0, 32
  addi gp, x0, 15
  loop2:

    addi a0, a0, -2
    load_coeffs a0, 16, 2

    // layer 4
    gs_butterfly s0,  s1,  t0, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    gs_butterfly s2,  s3,  t1, a6, a7 
    gs_butterfly s4,  s5,  t2, a6, a7
    gs_butterfly s6,  s7,  t3, a6, a7
    gs_butterfly s8,  s9,  t4, a6, a7
    gs_butterfly s10, s11, t5, a6, a7
    gs_butterfly a2,  a3,  t6, a6, a7
    gs_butterfly a4,  a5,  tp, a6, a7
    
    // The following 8 twiddle factors have to be loaded at each iteration
    // layer 3
    lw ra, 8*4(a1)
    gs_butterfly s0, s2,  ra, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    gs_butterfly s1, s3,  ra, a6, a7
    lw ra, 9*4(a1)
    gs_butterfly s4, s6,  ra, a6, a7
    gs_butterfly s5, s7,  ra, a6, a7
    lw ra, 10*4(a1)
    gs_butterfly s8, s10, ra, a6, a7
    gs_butterfly s9, s11, ra, a6, a7
    lw ra, 11*4(a1)
    gs_butterfly a2, a4,  ra, a6, a7
    gs_butterfly a3, a5,  ra, a6, a7

    // layer 2
    lw ra, 12*4(a1)
    gs_butterfly s0,  s4, ra, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    gs_butterfly s1,  s5, ra, a6, a7
    gs_butterfly s2,  s6, ra, a6, a7
    gs_butterfly s3,  s7, ra, a6, a7
    lw ra, 13*4(a1)
    gs_butterfly s8,  a2, ra, a6, a7
    gs_butterfly s9,  a3, ra, a6, a7
    gs_butterfly s10, a4, ra, a6, a7
    gs_butterfly s11, a5, ra, a6, a7

    // layer 1
    lw ra, 14*4(a1)
    gs_butterfly s0, s8,  ra, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    gs_butterfly s1, s9,  ra, a6, a7
    gs_butterfly s2, s10, ra, a6, a7
    gs_butterfly s3, s11, ra, a6, a7
    gs_butterfly s4, a2,  ra, a6, a7
    gs_butterfly s5, a3,  ra, a6, a7
    gs_butterfly s6, a4,  ra, a6, a7
    gs_butterfly s7, a5,  ra, a6, a7
    
    lw ra, 15*4(a1)
    plant_mul_const_inplace a6, ra, s0
    plant_mul_const_inplace a6, ra, s1
    plant_mul_const_inplace a6, ra, s2
    plant_mul_const_inplace a6, ra, s3
    plant_mul_const_inplace a6, ra, s4
    plant_mul_const_inplace a6, ra, s5
    plant_mul_const_inplace a6, ra, s6
    plant_mul_const_inplace a6, ra, s7

    store_coeffs a0, 16, 2

  addi gp, gp, -1
  bge gp, zero, loop2
  
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