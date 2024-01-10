#include "macros.i"

.text

.equ q16, 0x0d010000 //3329<<16

// |input|<0.5q; |output|<3.5q
// API: a0: poly, a1: 32-bit twiddle ptr; a6: q<<16; a7: tmp, variable twiddle factors; gp: loop;
// s0-s11, a2-a5: 16 coeffs; 
// 16+2+1+1=20 regs; 
// 9 twiddle factors: can be preloaded; t0-t6, tp, ra.
.global ntt_fast
.align 2
ntt_fast:
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

  addi a0, a0, 32  // poly[16]
  addi gp, x0, 15 // loop 

  // load 9 twiddle factors
  lw t0, 0*4(a1)
  lw t1, 1*4(a1)
  lw t2, 2*4(a1)
  lw t3, 3*4(a1)
  lw t4, 4*4(a1)
  lw t5, 5*4(a1)
  lw t6, 6*4(a1)
  lw tp, 7*4(a1)
  lw ra, 8*4(a1)
  
  ### LAYER 1+2+3+4
  loop1:
    addi a0, a0, -2

    // 16*i, i\in [0-15]
    load_coeffs a0, 16, 2
    // layer 1
    ct_butterfly s0, s8,  t0, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    ct_butterfly s1, s9,  t0, a6, a7
    ct_butterfly s2, s10, t0, a6, a7
    ct_butterfly s3, s11, t0, a6, a7
    ct_butterfly s4, a2,  t0, a6, a7
    ct_butterfly s5, a3,  t0, a6, a7
    ct_butterfly s6, a4,  t0, a6, a7
    ct_butterfly s7, a5,  t0, a6, a7

    // layer 2
    ct_butterfly s0,  s4, t1, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    ct_butterfly s1,  s5, t1, a6, a7
    ct_butterfly s2,  s6, t1, a6, a7
    ct_butterfly s3,  s7, t1, a6, a7
    ct_butterfly s8,  a2, t2, a6, a7
    ct_butterfly s9,  a3, t2, a6, a7
    ct_butterfly s10, a4, t2, a6, a7
    ct_butterfly s11, a5, t2, a6, a7
    
    // layer 3
    ct_butterfly s0, s2,  t3, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    ct_butterfly s1, s3,  t3, a6, a7
    ct_butterfly s4, s6,  t4, a6, a7
    ct_butterfly s5, s7,  t4, a6, a7
    ct_butterfly s8, s10, t5, a6, a7
    ct_butterfly s9, s11, t5, a6, a7
    ct_butterfly a2, a4,  t6, a6, a7
    ct_butterfly a3, a5,  t6, a6, a7

    // layer 4
    ct_butterfly s0,  s1,  tp, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    ct_butterfly s2,  s3,  ra, a6, a7 
    // The following 6 twiddle factors have to be loaded at each iteration
    lw a7, 9*4(a1)
    ct_butterfly s4,  s5,  a7, a6, a7 // In ct_butterfly, twiddle and tmp can be reused because each twiddle is only used once. The gs_butterfly cannot.
    lw a7, 10*4(a1)
    ct_butterfly s6,  s7,  a7, a6, a7
    lw a7, 11*4(a1)
    ct_butterfly s8,  s9,  a7, a6, a7
    lw a7, 12*4(a1)
    ct_butterfly s10, s11, a7, a6, a7
    lw a7, 13*4(a1)
    ct_butterfly a2,  a3,  a7, a6, a7
    lw a7, 14*4(a1)
    ct_butterfly a4,  a5,  a7, a6, a7

    // store 16 coeffs
    store_coeffs a0, 16, 2

  addi gp, gp, -1
  bge gp, zero, loop1 # 16 loops

  addi a1, a1, 15*4

  ### LAYER 5-6-7
  addi gp, x0, 16
  loop2:
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

    // layer 5
    ct_butterfly s0, s8,  t0, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    ct_butterfly s1, s9,  t0, a6, a7
    ct_butterfly s2, s10, t0, a6, a7
    ct_butterfly s3, s11, t0, a6, a7
    ct_butterfly s4, a2,  t0, a6, a7
    ct_butterfly s5, a3,  t0, a6, a7
    ct_butterfly s6, a4,  t0, a6, a7
    ct_butterfly s7, a5,  t0, a6, a7

    // layer 6
    ct_butterfly s0,  s4, t1, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    ct_butterfly s1,  s5, t1, a6, a7
    ct_butterfly s2,  s6, t1, a6, a7
    ct_butterfly s3,  s7, t1, a6, a7
    ct_butterfly s8,  a2, t2, a6, a7
    ct_butterfly s9,  a3, t2, a6, a7
    ct_butterfly s10, a4, t2, a6, a7
    ct_butterfly s11, a5, t2, a6, a7
    
    // layer 7
    ct_butterfly s0, s2,  t3, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    ct_butterfly s1, s3,  t3, a6, a7
    ct_butterfly s4, s6,  t4, a6, a7
    ct_butterfly s5, s7,  t4, a6, a7
    ct_butterfly s8, s10, t5, a6, a7
    ct_butterfly s9, s11, t5, a6, a7
    ct_butterfly a2, a4,  t6, a6, a7
    ct_butterfly a3, a5,  t6, a6, a7

    store_coeffs a0, 1, 2

    addi a0, a0, 32 // poly+=16
    addi a1, a1, 7*4 // zeta
  addi gp, gp, -1 // loop
  bne gp, zero, loop2

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
