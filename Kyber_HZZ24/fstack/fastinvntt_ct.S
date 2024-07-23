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

// input <1q
.macro _3_layer_inv_CT_light c0, c1, c2, c3, c4, c5, c6, c7, z2, z4, z5, z6, q, tmp, tmp2
  // layer 1
  add \tmp, \c0, \c1
  sub \c1, \c0, \c1 
  add \tmp2, \c2, \c3 
  sub \c3, \c2, \c3 

  add \c0, \c4, \c5
  sub \c5, \c4, \c5 
  add \c2, \c6, \c7
  sub \c7, \c6, \c7 
  // c4, c6 are free at this point
  // 2q

  // layer 2
  add \c6, \tmp, \tmp2
  sub \tmp2, \tmp, \tmp2
  add \c4, \c0, \c2 
  sub \c2, \c0, \c2 
  // 4q

  ct_butterfly \c1, \c3, \z2, \q, \tmp
  ct_butterfly \c5, \c7, \z2, \q, \tmp
  // 2.5q
  li \tmp, plantconst
  plant_mul_const_inplace \q, \tmp, \c6

  // layer 3
  add \c0, \c6, \c4
  sub \c4, \c6, \c4
  
  // 8q
  ct_butterfly \c1, \c5, \z4, \q, \tmp
  // 3q

  // this block is one butterfly
  plant_mul_const \q, \z5, \c2, \tmp
  sub \c6, \tmp2, \tmp
  add \c2, \tmp2, \tmp
  // 16.5q or 9.5q
  ct_butterfly \c3, \c7, \z6, \q, \tmp
  // 5q
.endm

.macro _3_layer_inv_CT c0, c1, c2, c3, c4, c5, c6, c7, z0, z1, z2, z3, z4, z5, z6, q, tmp
  // layer 3
  ct_butterfly \c0, \c1, \z0, \q, \tmp
  ct_butterfly \c2, \c3, \z0, \q, \tmp
  ct_butterfly \c4, \c5, \z0, \q, \tmp
  ct_butterfly \c6, \c7, \z0, \q, \tmp

  // layer 2
  ct_butterfly \c0, \c2, \z1, \q, \tmp
  ct_butterfly \c1, \c3, \z2, \q, \tmp
  ct_butterfly \c4, \c6, \z1, \q, \tmp
  ct_butterfly \c5, \c7, \z2, \q, \tmp

  // layer 1
  ct_butterfly \c0, \c4, \z3, \q, \tmp
  ct_butterfly \c1, \c5, \z4, \q, \tmp
  ct_butterfly \c2, \c6, \z5, \q, \tmp
  ct_butterfly \c3, \c7, \z6, \q, \tmp
.endm

.macro load_neighbor_coeffs poly, len, wordLen
  lh s0,  \len*\wordLen*0(\poly)
  lh s1,  \len*\wordLen*1(\poly)
  lh s2,  \len*\wordLen*2(\poly)
  lh s3,  \len*\wordLen*3(\poly)
  lh s4,  \len*\wordLen*4(\poly)
  lh s5,  \len*\wordLen*5(\poly)
  lh s6,  \len*\wordLen*6(\poly)
  lh s7,  \len*\wordLen*7(\poly)
  lh s8,  (\len*\wordLen*0+2)(\poly)
  lh s9,  (\len*\wordLen*1+2)(\poly)
  lh s10, (\len*\wordLen*2+2)(\poly)
  lh s11, (\len*\wordLen*3+2)(\poly)
  lh a2,  (\len*\wordLen*4+2)(\poly)
  lh a3,  (\len*\wordLen*5+2)(\poly)
  lh a4,  (\len*\wordLen*6+2)(\poly)
  lh a5,  (\len*\wordLen*7+2)(\poly)
.endm

.macro store_neighbor_coeffs poly, len, wordLen
  sh s0,  \len*\wordLen*0(\poly)
  sh s1,  \len*\wordLen*1(\poly)
  sh s2,  \len*\wordLen*2(\poly)
  sh s3,  \len*\wordLen*3(\poly)
  sh s4,  \len*\wordLen*4(\poly)
  sh s5,  \len*\wordLen*5(\poly)
  sh s6,  \len*\wordLen*6(\poly)
  sh s7,  \len*\wordLen*7(\poly)
  sh s8,  (\len*\wordLen*0+2)(\poly)
  sh s9,  (\len*\wordLen*1+2)(\poly)
  sh s10, (\len*\wordLen*2+2)(\poly)
  sh s11, (\len*\wordLen*3+2)(\poly)
  sh a2,  (\len*\wordLen*4+2)(\poly)
  sh a3,  (\len*\wordLen*5+2)(\poly)
  sh a4,  (\len*\wordLen*6+2)(\poly)
  sh a5,  (\len*\wordLen*7+2)(\poly)
.endm
// The first 4 layers light

// |input|<kq; |output|<
// API: a0: poly, a1: 32-bit twiddle ptr; a6: q<<16; a7: tmp; gp: loop;
// s0-s11, a2-a5: 16 coeffs; 
// 16+2+1+1+1=21 regs; 
// 8 twiddle factors: can be preloaded; t0-t6, tp; ra: tmp zeta.
.global invntt_fast_ct
.align 2
invntt_fast_ct:
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

  // load twiddle factors
  lw t0, 2*4(a1)
  lw t1, 4*4(a1)
  lw t2, 5*4(a1)
  lw t3, 6*4(a1)

  lw t4, 7*4(a1)// 8th
  lw t5, 8*4(a1)
  lw t6, 9*4(a1)
  lw tp, 10*4(a1)

  addi gp, x0, 8
  loop1:
    ### LAYER 7+6+5+4
    // load coefficients
    load_coeffs a0, 2, 2

    ### LAYER 7+6+5
    _3_layer_inv_CT_light s0, s1, s2, s3, s4, s5, s6, s7, t0, t1, t2, t3, a6, a7, ra

    _3_layer_inv_CT_light s8, s9, s10, s11, a2, a3, a4, a5, t0, t1, t2, t3, a6, a7, ra

    // LAYER 4
    ct_butterfly s0, s8,  t4, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    ct_butterfly s1, s9,  t5, a6, a7
    ct_butterfly s2, s10, t6, a6, a7
    ct_butterfly s3, s11, tp, a6, a7
    lw ra, 11*4(a1)
    ct_butterfly s4, a2,  ra, a6, a7
    lw ra, 12*4(a1)
    ct_butterfly s5, a3,  ra, a6, a7
    lw ra, 13*4(a1)
    ct_butterfly s6, a4,  ra, a6, a7
    lw ra, 14*4(a1)
    ct_butterfly s7, a5,  ra, a6, a7

    store_coeffs a0, 2, 2

    addi a0, a0, 2

    // load coefficients
    load_coeffs a0, 2, 2
    ### LAYER 7+6+5
    _3_layer_inv_CT_light s0, s1, s2, s3, s4, s5, s6, s7, t0, t1, t2, t3, a6, a7, ra

    _3_layer_inv_CT_light s8, s9, s10, s11, a2, a3, a4, a5, t0, t1, t2, t3, a6, a7, ra
    ### LAYER 4
    ct_butterfly s0, s8,  t4, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    ct_butterfly s1, s9,  t5, a6, a7
    ct_butterfly s2, s10, t6, a6, a7
    ct_butterfly s3, s11, tp, a6, a7
    lw ra, 11*4(a1)
    ct_butterfly s4, a2,  ra, a6, a7
    lw ra, 12*4(a1)
    ct_butterfly s5, a3,  ra, a6, a7
    lw ra, 13*4(a1)
    ct_butterfly s6, a4,  ra, a6, a7
    lw ra, 14*4(a1)
    ct_butterfly s7, a5,  ra, a6, a7

    // fullplant s0, s1, s2, s3, s4, s5, s6, s7, a6
    // fullplant s8, s9, s10, s11, a2, a3, a4, a5, a6
    store_coeffs a0, 2, 2

    addi a0, a0, 62
  addi gp, gp, -1
  bne gp, zero, loop1

  addi a0, a0, -512
  addi a1, a1, 15*4
  ### LAYER 3+2+1

  // ITER 0
  // load twiddle factors
  lw t0, 1*4(a1)
  lw t1, 3*4(a1)
  lw t2, 4*4(a1)
  lw t3, 5*4(a1)

  lw t4, 6*4(a1)// 8th
  lw t5, 7*4(a1)
  lw t6, 8*4(a1)
  lw tp, 9*4(a1)

  load_neighbor_coeffs a0, 32, 2
  _3_layer_inv_CT_light s0, s1, s2, s3, s4, s5, s6, s7, t0, t1, t2, t3, a6, a7, ra
  _3_layer_inv_CT_light s8, s9, s10, s11, a2, a3, a4, a5, t0, t1, t2, t3, a6, a7, ra
  
  // twisting
  plant_mul_const_inplace a6, t4, s0
  plant_mul_const_inplace a6, t4, s8
  plant_mul_const_inplace a6, t5, s1
  plant_mul_const_inplace a6, t5, s9
  plant_mul_const_inplace a6, t6, s2
  plant_mul_const_inplace a6, t6, s10
  plant_mul_const_inplace a6, tp, s3
  plant_mul_const_inplace a6, tp, s11

  lw ra, 10*4(a1)
  plant_mul_const_inplace a6, ra, s4
  plant_mul_const_inplace a6, ra, a2
  lw ra, 11*4(a1)
  plant_mul_const_inplace a6, ra, s5
  plant_mul_const_inplace a6, ra, a3
  lw ra, 12*4(a1)
  plant_mul_const_inplace a6, ra, s6
  plant_mul_const_inplace a6, ra, a4
  lw ra, 13*4(a1)
  plant_mul_const_inplace a6, ra, s7
  plant_mul_const_inplace a6, ra, a5 
  
  store_neighbor_coeffs a0, 32, 2 
  addi a1, a1, 14*4
  addi a0, a0, 4
   
  // ITER 1-15
  addi gp, x0, 15
  loop2:
    lw t0, 0*4(a1)
    lw t1, 1*4(a1)
    lw t2, 2*4(a1)
    lw t3, 3*4(a1)
    lw t4, 4*4(a1)// 8th
    lw t5, 5*4(a1)
    lw t6, 6*4(a1)

    lw tp, 7*4(a1)

    load_neighbor_coeffs a0, 32, 2
    _3_layer_inv_CT s0, s1, s2, s3, s4, s5, s6, s7, t0, t1, t2, t3, t4, t5, t6, a6, a7
    _3_layer_inv_CT s8, s9, s10, s11, a2, a3, a4, a5, t0, t1, t2, t3, t4, t5, t6, a6, a7

    // twisting
    plant_mul_const_inplace a6, tp, s0
    plant_mul_const_inplace a6, tp, s8
    lw ra, 8*4(a1)
    plant_mul_const_inplace a6, ra, s1
    plant_mul_const_inplace a6, ra, s9
    lw ra, 9*4(a1)
    plant_mul_const_inplace a6, ra, s2
    plant_mul_const_inplace a6, ra, s10
    lw ra, 10*4(a1)
    plant_mul_const_inplace a6, ra, s3
    plant_mul_const_inplace a6, ra, s11
    lw ra, 11*4(a1)
    plant_mul_const_inplace a6, ra, s4
    plant_mul_const_inplace a6, ra, a2
    lw ra, 12*4(a1)
    plant_mul_const_inplace a6, ra, s5
    plant_mul_const_inplace a6, ra, a3
    lw ra, 13*4(a1)
    plant_mul_const_inplace a6, ra, s6
    plant_mul_const_inplace a6, ra, a4
    lw ra, 14*4(a1)
    plant_mul_const_inplace a6, ra, s7
    plant_mul_const_inplace a6, ra, a5 
    
    store_neighbor_coeffs a0, 32, 2 
    addi a1, a1, 15*4
    addi a0, a0, 4

  addi gp, gp, -1
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