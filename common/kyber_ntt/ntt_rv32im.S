.macro load_coeffs poly, len, wordLen
  lh s0,  \len*\wordLen*0(\poly)
  lh s1,  \len*\wordLen*1(\poly)
  lh s2,  \len*\wordLen*2(\poly)
  lh s3,  \len*\wordLen*3(\poly)
  lh s4,  \len*\wordLen*4(\poly)
  lh s5,  \len*\wordLen*5(\poly)
  lh s6,  \len*\wordLen*6(\poly)
  lh s7,  \len*\wordLen*7(\poly)
  lh s8,  \len*\wordLen*8(\poly)
  lh s9,  \len*\wordLen*9(\poly)
  lh s10, \len*\wordLen*10(\poly)
  lh s11, \len*\wordLen*11(\poly)
  lh a2,  \len*\wordLen*12(\poly)
  lh a3,  \len*\wordLen*13(\poly)
  lh a4,  \len*\wordLen*14(\poly)
  lh a5,  \len*\wordLen*15(\poly)
.endm

.macro store_coeffs poly, len, wordLen
  sh s0,  \len*\wordLen*0(\poly)
  sh s1,  \len*\wordLen*1(\poly)
  sh s2,  \len*\wordLen*2(\poly)
  sh s3,  \len*\wordLen*3(\poly)
  sh s4,  \len*\wordLen*4(\poly)
  sh s5,  \len*\wordLen*5(\poly)
  sh s6,  \len*\wordLen*6(\poly)
  sh s7,  \len*\wordLen*7(\poly)
  sh s8,  \len*\wordLen*8(\poly)
  sh s9,  \len*\wordLen*9(\poly)
  sh s10, \len*\wordLen*10(\poly)
  sh s11, \len*\wordLen*11(\poly)
  sh a2,  \len*\wordLen*12(\poly)
  sh a3,  \len*\wordLen*13(\poly)
  sh a4,  \len*\wordLen*14(\poly)
  sh a5,  \len*\wordLen*15(\poly)
.endm

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

// a*b*qinv*plantconst; result in the bottom half of a
// q=q<<16
.macro plant_mul_const_inplace q, bq, coeff
  mul \coeff, \coeff, \bq
  srai \coeff, \coeff, 16
  addi \coeff, \coeff, 8
  mulh \coeff, \coeff, \q
.endm

// a*b*qinv*plantconst; result in the bottom half of a
// q=q<<16
.macro plant_mul_const q, bq, coeff, res
  mul \res, \coeff, \bq
  srai \res, \res, 16
  addi \res, \res, 8
  mulh \res, \res, \q
.endm

// each layer increases coefficients by 0.5q; In ct_butterfly, twiddle and tmp can be reused because each twiddle is only used once. The gs_butterfly cannot.
.macro ct_butterfly coeff0, coeff1, twiddle, q, tmp
  plant_mul_const \q, \twiddle, \coeff1, \tmp
  sub \coeff1, \coeff0, \tmp
  add \coeff0, \coeff0, \tmp
.endm

.macro gs_butterfly coeff0, coeff1, twiddle, q, tmp
  sub \tmp, \coeff0, \coeff1
  add \coeff0, \coeff0, \coeff1
  plant_mul_const \q, \twiddle, \tmp, \coeff1
.endm

// output (-0.5q, 0.5q) q=q<<16
.macro plant_red q, qinv, coeff 
  mul \coeff, \coeff, \qinv
  srai \coeff, \coeff, 16
  addi \coeff, \coeff, 8
  mulh \coeff, \coeff, \q
.endm

// output (0, q)
.macro barrett_red coeff, tmp, q, barrettconst
  mul \tmp, \coeff, \barrettconst
  srai \tmp, \tmp, 26
  mul \tmp, \tmp, \q
  sub \coeff, \coeff, \tmp
.endm

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

.equ q16, 0x0d010000            // 3329<<16
.equ qinv, 0x6ba8f301
.equ q, 3329
.equ barrettconst, 20159
.equ plantconst, 0x13afb8       // (-2^{32} mod q)*qinv % 2^32
.equ plantconst2, 0x680bb055    // (-2^{64} mod q)*qinv % 2^32

// |input|<0.5q; |output|<3.5q
// API: a0: poly, a1: 32-bit twiddle ptr; a6: q<<16; a7: tmp, variable twiddle factors; gp: loop;
// s0-s11, a2-a5: 16 coeffs; 
// 16+2+1+1=20 regs; 
// 9 twiddle factors: can be preloaded; t0-t6, tp, ra.
.global ntt_rv32im
.align 2
ntt_rv32im:
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
  ntt_rv32im_loop1:
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
  bge gp, zero, ntt_rv32im_loop1 # 16 loops

  addi a1, a1, 15*4

  ### LAYER 5-6-7
  addi gp, x0, 16
  ntt_rv32im_loop2:
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
  bne gp, zero, ntt_rv32im_loop2

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

// |input|<kq; |output|<
// API: a0: poly, a1: 32-bit twiddle ptr; a6: q<<16; a7: tmp; gp: loop;
// s0-s11, a2-a5: 16 coeffs; 
// 16+2+1+1=20 regs; 
// 8 twiddle factors: can be preloaded; t0-t6, tp; ra: tmp zeta.
.global invntt_rv32im
.align 2
invntt_rv32im:
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
  invntt_rv32im_loop1:
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
  bne gp, zero, invntt_rv32im_loop1

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
  invntt_rv32im_loop2:

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
  bge gp, zero, invntt_rv32im_loop2
  
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

// void poly_basemul_acc_rv32im(int32_t *r, const int16_t *a, const int16_t *b, uint32_t *zetas)
// a0: r, a1: a, a2: b, a3: zetas
// a5: q<<16, a6: loop control
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: zeta, t5-t6: temp
.global poly_basemul_acc_rv32im
.align 2
poly_basemul_acc_rv32im:
    li a5, q16
    li a6, 64
poly_basemul_acc_rv32im_loop:
    lh t2, 2*0(a2) // b[0]
    lh t3, 2*1(a2) // b[1]
    lw t4, 4*0(a3) // zeta
    lh t0, 2*0(a1) // a[0]
    lh t1, 2*1(a1) // a[1]
    // r[0]=a[0]b[0]+a[1](b[1]zeta), r[1]=a[0]b[1]+a[1]b[0]
    plant_mul_const a5, t4, t3, t5
    lw  a7, 4*0(a0)
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6  // r[0]
    add t5, t5, a7
    sw  t5, 4*0(a0)
    lw  a7, 4*1(a0)
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6  // r[1]
    add t5, t5, a7
    sw  t5, 4*1(a0)
    neg t4, t4      // -zeta

    // r[2], r[3]
    lh t2, 2*2(a2)
    lh t3, 2*3(a2)
    lh t0, 2*2(a1)
    lh t1, 2*3(a1)
    plant_mul_const a5, t4, t3, t5
    lw  a7, 4*2(a0)
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6
    add t5, t5, a7
    sw  t5, 4*2(a0)
    lw  a7, 4*3(a0)
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6
    add t5, t5, a7
    sw  t5, 4*3(a0)
    // loop control
    addi a0, a0, 4*4
    addi a1, a1, 2*4
    addi a2, a2, 2*4
    addi a3, a3, 4*1
    addi a6, a6, -1
    bne a6, zero, poly_basemul_acc_rv32im_loop
ret

// void poly_basemul_acc_end_rv32im(int16_t *r, const int16_t *a, const int16_t *b, uint32_t *zetas, int32_t *r_double)
// a0: r, a1: a, a2: b, a3: zetas, a4: r_double
// a5: q<<16, a6: loop control
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: zeta, t5-t6: temp
.global poly_basemul_acc_end_rv32im
.align 2
poly_basemul_acc_end_rv32im:
    addi sp, sp, -4*2
    sw   s0, 0*4(sp)
    sw   s1, 1*4(sp)

    li s0, q16
    li s1, qinv
    li a6, 64
poly_basemul_acc_end_rv32im_loop:
    lh t2, 2*0(a2) // b[0]
    lh t3, 2*1(a2) // b[1]
    lw t4, 4*0(a3) // zeta
    lh t0, 2*0(a1) // a[0]
    lh t1, 2*1(a1) // a[1]
    // r[0]=a[0]b[0]+a[1](b[1]zeta), r[1]=a[0]b[1]+a[1]b[0]
    plant_mul_const s0, t4, t3, t5
    lw  a7, 4*0(a4)
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6  // r[0]
    add t5, t5, a7
    plant_red s0, s1, t5
    sh  t5, 2*0(a0)
    lw  a7, 4*1(a4)
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6  // r[1]
    add t5, t5, a7
    plant_red s0, s1, t5
    sh  t5, 2*1(a0)
    neg t4, t4      // -zeta

    // r[2], r[3]
    lh t2, 2*2(a2)
    lh t3, 2*3(a2)
    lh t0, 2*2(a1)
    lh t1, 2*3(a1)
    plant_mul_const s0, t4, t3, t5
    lw  a7, 4*2(a4)
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6
    add t5, t5, a7
    plant_red s0, s1, t5
    sh  t5, 2*2(a0)
    lw  a7, 4*3(a4)
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6
    add t5, t5, a7
    plant_red s0, s1, t5
    sh  t5, 2*3(a0)
    // loop control
    addi a0, a0, 2*4
    addi a1, a1, 2*4
    addi a2, a2, 2*4
    addi a3, a3, 4*1
    addi a4, a4, 4*4
    addi a6, a6, -1
    bne a6, zero, poly_basemul_acc_end_rv32im_loop

    lw   s0, 0*4(sp)
    lw   s1, 1*4(sp)
    addi sp, sp, 4*2
ret

// void poly_basemul_cache_init_rv32im(int32_t *r, const int16_t *a, const int16_t *b, int16_t *b_cache, uint32_t *zetas)
// a0: r, a1: a, a2: b, a3: b_cache, a4: zetas
// a5: q<<16, a6: loop control
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: zeta, t5-t6: temp
.global poly_basemul_cache_init_rv32im
.align 2
poly_basemul_cache_init_rv32im:
    li a5, q16
    li a6, 64
poly_basemul_cache_init_rv32im_loop:
    lh t2, 2*0(a2) // b[0]
    lh t3, 2*1(a2) // b[1]
    lw t4, 4*0(a4) // zeta
    lh t0, 2*0(a1) // a[0]
    lh t1, 2*1(a1) // a[1]
    // r[0]=a[0]b[0]+a[1](b[1]zeta), r[1]=a[0]b[1]+a[1]b[0]
    plant_mul_const a5, t4, t3, t5
    sh t5, 2*0(a3)  // store b[1]zeta for later usage
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6  // r[0]
    sw  t5, 4*0(a0)
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6  // r[1]
    sw  t5, 4*1(a0)
    neg t4, t4      // -zeta

    // r[2], r[3]
    lh t2, 2*2(a2)
    lh t3, 2*3(a2)
    lh t0, 2*2(a1)
    lh t1, 2*3(a1)
    plant_mul_const a5, t4, t3, t5
    sh t5, 2*1(a3)
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6
    sw  t5, 4*2(a0)
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6
    sw  t5, 4*3(a0)
    // loop control
    addi a0, a0, 4*4
    addi a1, a1, 2*4
    addi a2, a2, 2*4
    addi a3, a3, 2*2
    addi a4, a4, 4*1
    addi a6, a6, -1
    bne a6, zero, poly_basemul_cache_init_rv32im_loop
ret

// void poly_basemul_acc_cache_init_rv32im(int32_t *r, const int16_t *a, const int16_t *b, int16_t *b_cache, uint32_t *zetas)
// a0: r, a1: a, a2: b, a3: b_cache, a4: zetas
// a5: q<<16, a6: loop control, a7: accumulated value
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: zeta, t5-t6: temp
.global poly_basemul_acc_cache_init_rv32im
.align 2
poly_basemul_acc_cache_init_rv32im:
    li a5, q16
    li a6, 64
poly_basemul_acc_cache_init_rv32im_loop:
    lh t2, 2*0(a2) // b[0]
    lh t3, 2*1(a2) // b[1]
    lw t4, 4*0(a4) // zeta
    lh t0, 2*0(a1) // a[0]
    lh t1, 2*1(a1) // a[1]
    // r[0]=a[0]b[0]+a[1](b[1]zeta), r[1]=a[0]b[1]+a[1]b[0]
    plant_mul_const a5, t4, t3, t5
    sh t5, 2*0(a3)  // store b[1]zeta for later usage
    lw a7, 4*0(a0)
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6  // r[0]
    add t5, t5, a7
    sw  t5, 4*0(a0)
    lw  a7, 4*1(a0)
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6  // r[1]
    add t5, t5, a7
    sw  t5, 4*1(a0)

    neg t4, t4      // -zeta

    // r[2], r[3]
    lh t2, 2*2(a2)
    lh t3, 2*3(a2)
    lh t0, 2*2(a1)
    lh t1, 2*3(a1)
    plant_mul_const a5, t4, t3, t5
    sh  t5, 2*1(a3)
    lw  a7, 4*2(a0)
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6
    add t5, t5, a7
    sw  t5, 4*2(a0)
    lw  a7, 4*3(a0)
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6
    add t5, t5, a7
    sw  t5, 4*3(a0)
    // loop control
    addi a0, a0, 4*4
    addi a1, a1, 2*4
    addi a2, a2, 2*4
    addi a3, a3, 2*2
    addi a4, a4, 4*1
    addi a6, a6, -1
    bne a6, zero, poly_basemul_acc_cache_init_rv32im_loop
ret

// void poly_basemul_acc_cache_init_end_rv32im(int16_t *r, const int16_t *a, const int16_t *b, int16_t *b_cache, uint32_t *zetas, int32_t *r_double)
// a0: r, a1: a, a2: b, a3: b_cache, a4: zetas, a5: r_double
// a6: loop control, a7: accumulated value
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: zeta, t5-t6: temp
// s0: q<<16, s1: qinv
.global poly_basemul_acc_cache_init_end_rv32im
.align 2
poly_basemul_acc_cache_init_end_rv32im:
    addi sp, sp, -4*2
    sw   s0, 0*4(sp)
    sw   s1, 1*4(sp)

    li s0, q16
    li s1, qinv
    li a6, 64
poly_basemul_acc_cache_init_end_rv32im_loop:
    lh t2, 2*0(a2) // b[0]
    lh t3, 2*1(a2) // b[1]
    lw t4, 4*0(a4) // zeta
    lh t0, 2*0(a1) // a[0]
    lh t1, 2*1(a1) // a[1]
    // r[0]=a[0]b[0]+a[1](b[1]zeta), r[1]=a[0]b[1]+a[1]b[0]
    plant_mul_const s0, t4, t3, t5
    sh t5, 2*0(a3)  // store b[1]zeta for later usage
    lw a7, 4*0(a5)
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6  // r[0]
    add t5, t5, a7
    plant_red s0, s1, t5
    sh  t5, 2*0(a0)
    lw  a7, 4*1(a5)
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6  // r[1]
    add t5, t5, a7
    plant_red s0, s1, t5
    sh  t5, 2*1(a0)
    neg t4, t4      // -zeta

    // r[2], r[3]
    lh t2, 2*2(a2)
    lh t3, 2*3(a2)
    lh t0, 2*2(a1)
    lh t1, 2*3(a1)
    plant_mul_const s0, t4, t3, t5
    sh t5, 2*1(a3)
    lw  a7, 4*2(a5)
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6
    add t5, t5, a7
    plant_red s0, s1, t5
    sh  t5, 2*2(a0)
    lw  a7, 4*3(a5)
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6
    add t5, t5, a7
    plant_red s0, s1, t5
    sh  t5, 2*3(a0)
    // loop control
    addi a0, a0, 2*4
    addi a1, a1, 2*4
    addi a2, a2, 2*4
    addi a3, a3, 2*2
    addi a4, a4, 4*1
    addi a5, a5, 4*4
    addi a6, a6, -1
    bne a6, zero, poly_basemul_acc_cache_init_end_rv32im_loop

    lw   s0, 0*4(sp)
    lw   s1, 1*4(sp)
    addi sp, sp, 4*2
ret

// void poly_basemul_acc_cached_rv32im(int32_t *r, const int16_t *a, const int16_t *b, int16_t *b_cache)
// a0: r, a1: a, a2: b, a3: b_cache
// a5: q<<16, a6: loop control
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: accumulated value, t5-t6: temp
.global poly_basemul_acc_cached_rv32im
.align 2
poly_basemul_acc_cached_rv32im:
    li a5, q16
    li a6, 64
poly_basemul_acc_cached_rv32im_loop:
    lh t0, 2*0(a1)  // a[0]
    lh t1, 2*1(a1)  // a[1]
    lh t5, 2*0(a3)  // load b[1]zeta
    lh t2, 2*0(a2)  // b[0]
    lh t3, 2*1(a2)  // b[1]
    lw t4, 4*0(a0)  // load accumulated value
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6  // r[0]
    add t5, t5, t4
    sw  t5, 4*0(a0)
    lw  t4, 4*1(a0)  // load accumulated value
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6  // r[1]
    add t5, t5, t4
    sw  t5, 4*1(a0)

    // r[2], r[3]
    lh t0, 2*2(a1)
    lh t1, 2*3(a1)
    lh t5, 2*1(a3)  // load cached value
    lh t2, 2*2(a2)
    lh t3, 2*3(a2)
    lw t4, 4*2(a0)  // load accumulated value
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6
    add t5, t5, t4
    sw  t5, 4*2(a0)
    lw  t4, 4*3(a0)  // load accumulated value
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6
    add t5, t5, t4
    sw  t5, 4*3(a0)
    // loop control
    addi a0, a0, 4*4
    addi a1, a1, 2*4
    addi a2, a2, 2*4
    addi a3, a3, 2*2
    addi a6, a6, -1
    bne a6, zero, poly_basemul_acc_cached_rv32im_loop
ret

// void poly_basemul_acc_cache_end_rv32im(int16_t *r, const int16_t *a, const int16_t *b, int16_t *b_cache, int32_t *r_double)
// a0: r, a1: a, a2: b, a3: b_cache, a4: r_double
// a5: q<<16, a6: loop control, a7: qinv
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: accumulated value, t5-t6: temp
.global poly_basemul_acc_cache_end_rv32im
.align 2
poly_basemul_acc_cache_end_rv32im:
    li a5, q16
    li a6, 64
    li a7, qinv
poly_basemul_acc_cache_end_rv32im_loop:
    lh t0, 2*0(a1)  // a[0]
    lh t1, 2*1(a1)  // a[1]
    lh t5, 2*0(a3)  // load b[1]zeta
    lh t2, 2*0(a2)  // b[0]
    lh t3, 2*1(a2)  // b[1]
    lw t4, 4*0(a4)  // load accumulated value
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6  // r[0]
    add t5, t5, t4
    plant_red a5, a7, t5
    sh  t5, 2*0(a0)
    lw  t4, 4*1(a4)  // load accumulated value
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6  // r[1]
    add t5, t5, t4
    plant_red a5, a7, t5
    sh  t5, 2*1(a0)

    // r[2], r[3]
    lh t0, 2*2(a1)
    lh t1, 2*3(a1)
    lh t5, 2*1(a3)  // load cached value
    lh t2, 2*2(a2)
    lh t3, 2*3(a2)
    lw t4, 4*2(a4)  // load accumulated value
    mul t5, t1, t5
    mul t6, t0, t2
    add t5, t5, t6
    add t5, t5, t4
    plant_red a5, a7, t5
    sh  t5, 2*2(a0)
    lw  t4, 4*3(a4)  // load accumulated value
    mul t5, t0, t3
    mul t6, t1, t2
    add t5, t5, t6
    add t5, t5, t4
    plant_red a5, a7, t5
    sh  t5, 2*3(a0)
    // loop control
    addi a0, a0, 2*4
    addi a1, a1, 2*4
    addi a2, a2, 2*4
    addi a3, a3, 2*2
    addi a4, a4, 4*4
    addi a6, a6, -1
    bne a6, zero, poly_basemul_acc_cache_end_rv32im_loop
ret

// 30-gp: loop, a0: poly, tp: q, ra: tmp, a1: barrettconst; 25 usable. can load 25 coeffs
// s0-s11, a2-a7:12+6, t0-t6: 7
.global poly_barrett_rdc_rv32im
.align 2
poly_barrett_rdc_rv32im:
  addi sp, sp, -4*15
  save_regs

  li a1, barrettconst
  li tp, q
  
  addi gp, x0, 10
  poly_barrett_rdc_rv32im_loop:
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
// TODO: pipeline opt
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
  bne gp, zero, poly_barrett_rdc_rv32im_loop

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
  
  restore_regs
  addi sp, sp, 4*15
  ret

.global poly_to_plant_rv32im
.align 2
poly_to_plant_rv32im:
  addi sp, sp, -4*15
  save_regs

  li a1, plantconst2
  li tp, q16
// TODO: pipeline opt
  addi gp, x0, 10
  poly_to_plant_rv32im_loop:
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
    plant_mul_const_inplace tp, a1, s0
    plant_mul_const_inplace tp, a1, s1
    plant_mul_const_inplace tp, a1, s2
    plant_mul_const_inplace tp, a1, s3
    plant_mul_const_inplace tp, a1, s4
    plant_mul_const_inplace tp, a1, s5
    plant_mul_const_inplace tp, a1, s6
    plant_mul_const_inplace tp, a1, s7
    plant_mul_const_inplace tp, a1, s8
    plant_mul_const_inplace tp, a1, s9
    plant_mul_const_inplace tp, a1, s10
    plant_mul_const_inplace tp, a1, s11
    plant_mul_const_inplace tp, a1, a2
    plant_mul_const_inplace tp, a1, a3
    plant_mul_const_inplace tp, a1, a4
    plant_mul_const_inplace tp, a1, a5
    plant_mul_const_inplace tp, a1, a6
    plant_mul_const_inplace tp, a1, a7
    plant_mul_const_inplace tp, a1, t0
    plant_mul_const_inplace tp, a1, t1
    plant_mul_const_inplace tp, a1, t2
    plant_mul_const_inplace tp, a1, t3
    plant_mul_const_inplace tp, a1, t4
    plant_mul_const_inplace tp, a1, t5
    plant_mul_const_inplace tp, a1, t6
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
  bne gp, zero, poly_to_plant_rv32im_loop
  lh s0,  2*0(a0)
  lh s1,  2*1(a0)
  lh s2,  2*2(a0)
  lh s3,  2*3(a0)
  lh s4,  2*4(a0)
  lh s5,  2*5(a0)
  plant_mul_const_inplace tp, a1, s0
  plant_mul_const_inplace tp, a1, s1
  plant_mul_const_inplace tp, a1, s2
  plant_mul_const_inplace tp, a1, s3
  plant_mul_const_inplace tp, a1, s4
  plant_mul_const_inplace tp, a1, s5
  sh s0,  2*0(a0)
  sh s1,  2*1(a0)
  sh s2,  2*2(a0)
  sh s3,  2*3(a0)
  sh s4,  2*4(a0)
  sh s5,  2*5(a0)
  restore_regs
  addi sp, sp, 4*15
  ret