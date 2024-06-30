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
  sd s0,  0*8(sp)
  sd s1,  1*8(sp)
  sd s2,  2*8(sp)
  sd s3,  3*8(sp)
  sd s4,  4*8(sp)
  sd s5,  5*8(sp)
  sd s6,  6*8(sp)
  sd s7,  7*8(sp)
  sd s8,  8*8(sp)
  sd s9,  9*8(sp)
  sd s10, 10*8(sp)
  sd s11, 11*8(sp)
  sd gp,  12*8(sp)
  sd tp,  13*8(sp)
  sd ra,  14*8(sp)
.endm

.macro restore_regs
  ld s0,  0*8(sp)
  ld s1,  1*8(sp)
  ld s2,  2*8(sp)
  ld s3,  3*8(sp)
  ld s4,  4*8(sp)
  ld s5,  5*8(sp)
  ld s6,  6*8(sp)
  ld s7,  7*8(sp)
  ld s8,  8*8(sp)
  ld s9,  9*8(sp)
  ld s10, 10*8(sp)
  ld s11, 11*8(sp)
  ld gp,  12*8(sp)
  ld tp,  13*8(sp)
  ld ra,  14*8(sp)
.endm

// a <- a*b*(-2^{-64}) mod+- q
// q32: q<<32; bqinv: b*qinv
.macro plant_mul_const_inplace q32, bqinv, a
  mul  \a, \a, \bqinv
  srai \a, \a, 32
  addi \a, \a, 8
  mulh \a, \a, \q32
.endm

// r <- a*b*(-2^{-64}) mod+- q
// q32: q<<32; bqinv: b*qinv
.macro plant_mul_const q32, bqinv, a, r
    mul  \r, \a, \bqinv
    srai \r, \r, 32
    addi \r, \r, 8
    mulh \r, \r, \q32
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

// in-place plantard reduction to a
// output \in (-0.5q, 0.5q); q32: q<<32
.macro plant_red q32, qinv, a
  mul  \a, \a, \qinv
  srai \a, \a, 32
  addi \a, \a, 8
  mulh \a, \a, \q32
.endm

.equ q,    3329
.equ q32,  0xd0100000000                // q << 32
.equ qinv, 0x3c0f12886ba8f301           // q^-1 mod 2^64
.equ plantconst, 0x13afb7680bb055       // (((-2**64) % q) * qinv) % (2**64)
.equ plantconst2, 0x1a390f4d9791e139    // (((-2**64) % q) * ((-2**64) % q) * qinv) % (2**64)

// |input| < 0.5q; |output| < 3.5q
// API: a0: poly, a1: 64-bit twiddle ptr; a6: q<<32; a7: tmp, variable twiddle factors; gp: loop;
// s0-s11, a2-a5: 16 coeffs; 
// 16+2+1+1=20 regs; 
// 9 twiddle factors: can be preloaded; t0-t6, tp, ra.
.global ntt_rv64im
.align 2
ntt_rv64im:
  addi sp, sp, -8*15
  save_regs
  li a6, q32        // q<<32
  addi a0, a0, 32   // poly[16]
  addi gp, x0, 15   // loop
  // load 9 twiddle factors
  ld t0, 0*8(a1)
  ld t1, 1*8(a1)
  ld t2, 2*8(a1)
  ld t3, 3*8(a1)
  ld t4, 4*8(a1)
  ld t5, 5*8(a1)
  ld t6, 6*8(a1)
  ld tp, 7*8(a1)
  ld ra, 8*8(a1)
  ### LAYER 1+2+3+4
  ntt_rv64im_loop1:
    addi a0, a0, -2
    // 16*i, i \in [0-15]
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
    ld a7, 9*8(a1)
    ct_butterfly s4,  s5,  a7, a6, a7 // In ct_butterfly, twiddle and tmp can be reused because each twiddle is only used once. The gs_butterfly cannot.
    ld a7, 10*8(a1)
    ct_butterfly s6,  s7,  a7, a6, a7
    ld a7, 11*8(a1)
    ct_butterfly s8,  s9,  a7, a6, a7
    ld a7, 12*8(a1)
    ct_butterfly s10, s11, a7, a6, a7
    ld a7, 13*8(a1)
    ct_butterfly a2,  a3,  a7, a6, a7
    ld a7, 14*8(a1)
    ct_butterfly a4,  a5,  a7, a6, a7
    // store 16 coeffs
    store_coeffs a0, 16, 2
  addi gp, gp, -1
  bge gp, zero, ntt_rv64im_loop1 # 16 loops
  addi a1, a1, 15*8
  ### LAYER 5-6-7
  addi gp, x0, 16
  ntt_rv64im_loop2:
    // load coefficients
    load_coeffs a0, 1, 2
    // load twiddle factors
    ld t0, 0*8(a1)
    ld t1, 1*8(a1)
    ld t2, 2*8(a1)
    ld t3, 3*8(a1)
    ld t4, 4*8(a1)
    ld t5, 5*8(a1)
    ld t6, 6*8(a1)
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
    addi a1, a1, 7*8 // zeta
  addi gp, gp, -1 // loop
  bne gp, zero, ntt_rv64im_loop2
  restore_regs
  addi sp, sp, 8*15
  ret

// |input| < kq; |output| < 0.5q
// API: a0: poly, a1: 64-bit twiddle ptr; a6: q<<32; a7: tmp; gp: loop;
// s0-s11, a2-a5: 16 coeffs; 
// 16+2+1+1=20 regs; 
// 8 twiddle factors: can be preloaded; t0-t6, tp; ra: tmp zeta.
.global intt_rv64im
.align 2
intt_rv64im:
  addi sp, sp, -8*15
  save_regs
  li a6, q32 // q<<32
  ### LAYER 7+6+5
  addi gp, x0, 16
  intt_rv64im_loop1:
    // load coefficients
    load_coeffs a0, 1, 2
    // load twiddle factors
    ld t0, 0*8(a1)
    ld t1, 1*8(a1)
    ld t2, 2*8(a1)
    ld t3, 3*8(a1)
    ld t4, 4*8(a1)
    ld t5, 5*8(a1)
    ld t6, 6*8(a1)
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
    addi a1, a1, 8*7
  addi gp, gp, -1
  bne gp, zero, intt_rv64im_loop1
  addi a0, a0, -512
  ### LAYER 4+3+2+1
  // load 8 zetas
  ld t0, 0*8(a1)
  ld t1, 1*8(a1)
  ld t2, 2*8(a1)
  ld t3, 3*8(a1)
  ld t4, 4*8(a1)
  ld t5, 5*8(a1)
  ld t6, 6*8(a1)
  ld tp, 7*8(a1)
  addi a0, a0, 32
  addi gp, x0, 15
  intt_rv64im_loop2:
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
    ld ra, 8*8(a1)
    gs_butterfly s0, s2,  ra, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    gs_butterfly s1, s3,  ra, a6, a7
    ld ra, 9*8(a1)
    gs_butterfly s4, s6,  ra, a6, a7
    gs_butterfly s5, s7,  ra, a6, a7
    ld ra, 10*8(a1)
    gs_butterfly s8, s10, ra, a6, a7
    gs_butterfly s9, s11, ra, a6, a7
    ld ra, 11*8(a1)
    gs_butterfly a2, a4,  ra, a6, a7
    gs_butterfly a3, a5,  ra, a6, a7
    // layer 2
    ld ra, 12*8(a1)
    gs_butterfly s0,  s4, ra, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    gs_butterfly s1,  s5, ra, a6, a7
    gs_butterfly s2,  s6, ra, a6, a7
    gs_butterfly s3,  s7, ra, a6, a7
    ld ra, 13*8(a1)
    gs_butterfly s8,  a2, ra, a6, a7
    gs_butterfly s9,  a3, ra, a6, a7
    gs_butterfly s10, a4, ra, a6, a7
    gs_butterfly s11, a5, ra, a6, a7
    // layer 1
    ld ra, 14*8(a1)
    gs_butterfly s0, s8,  ra, a6, a7 // coeff0, coeff1, twiddle, q, tmp
    gs_butterfly s1, s9,  ra, a6, a7
    gs_butterfly s2, s10, ra, a6, a7
    gs_butterfly s3, s11, ra, a6, a7
    gs_butterfly s4, a2,  ra, a6, a7
    gs_butterfly s5, a3,  ra, a6, a7
    gs_butterfly s6, a4,  ra, a6, a7
    gs_butterfly s7, a5,  ra, a6, a7
    ld ra, 15*8(a1)
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
  bge gp, zero, intt_rv64im_loop2
  restore_regs
  addi sp, sp, 8*15
  ret

// void poly_basemul_acc_rv64im(int32_t *r, const int16_t *a, const int16_t *b, uint64_t *zetas)
// compute basemul and accumulate the 32-bit results into r
// a0: r, a1: a, a2: b, a3: zetas
// a5: q<<32, a6: loop control
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: zeta, t5-t6: temp
.global poly_basemul_acc_rv64im
.align 2
poly_basemul_acc_rv64im:
    li a5, q32
    li a6, 64
poly_basemul_acc_rv64im_loop:
    lh t2, 2*0(a2) // b[0]
    lh t3, 2*1(a2) // b[1]
    ld t4, 8*0(a3) // zeta
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
    addi a3, a3, 8*1
    addi a6, a6, -1
    bne a6, zero, poly_basemul_acc_rv64im_loop
ret

// void poly_basemul_acc_end_rv64im(int16_t *r, const int16_t *a, const int16_t *b, uint64_t *zetas, int32_t *r_double)
// compute basemul, accumulate the 32-bit results into r_double, and reduce r_double to r
// a0: r, a1: a, a2: b, a3: zetas, a4: r_double
// a5: q<<32, a6: loop control
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: zeta, t5-t6: temp
.global poly_basemul_acc_end_rv64im
.align 2
poly_basemul_acc_end_rv64im:
    addi sp, sp, -8*2
    sd   s0, 0*8(sp)
    sd   s1, 1*8(sp)
    li s0, q32
    li s1, qinv
    li a6, 64
poly_basemul_acc_end_rv64im_loop:
    lh t2, 2*0(a2) // b[0]
    lh t3, 2*1(a2) // b[1]
    ld t4, 8*0(a3) // zeta
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
    addi a3, a3, 8*1
    addi a4, a4, 4*4
    addi a6, a6, -1
    bne a6, zero, poly_basemul_acc_end_rv64im_loop
    ld   s0, 0*8(sp)
    ld   s1, 1*8(sp)
    addi sp, sp, 8*2
ret

// void poly_basemul_cache_init_rv64im(int32_t *r, const int16_t *a, const int16_t *b, int16_t *b_cache, uint64_t *zetas)
// compute basemul, cache bzeta into b_cache, and store the 32-bit results into r
// a0: r, a1: a, a2: b, a3: b_cache, a4: zetas
// a5: q<<32, a6: loop control
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: zeta, t5-t6: temp
.global poly_basemul_cache_init_rv64im
.align 2
poly_basemul_cache_init_rv64im:
    li a5, q32
    li a6, 64
poly_basemul_cache_init_rv64im_loop:
    lh t2, 2*0(a2) // b[0]
    lh t3, 2*1(a2) // b[1]
    ld t4, 8*0(a4) // zeta
    lh t0, 2*0(a1) // a[0]
    lh t1, 2*1(a1) // a[1]
    // r[0]=a[0]b[0]+a[1](b[1]zeta), r[1]=a[0]b[1]+a[1]b[0]
    plant_mul_const a5, t4, t3, t5
    sh  t5, 2*0(a3)  // store b[1]zeta for later usage
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
    sh  t5, 2*1(a3)
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
    addi a4, a4, 8*1
    addi a6, a6, -1
    bne a6, zero, poly_basemul_cache_init_rv64im_loop
ret

// void poly_basemul_acc_cache_init_rv64im(int32_t *r, const int16_t *a, const int16_t *b, int16_t *b_cache, uint64_t *zetas)
// compute basemul, cache bzeta into b_cache, and accumulate the 32-bit results into r
// a0: r, a1: a, a2: b, a3: b_cache, a4: zetas
// a5: q<<32, a6: loop control, a7: accumulated value
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: zeta, t5-t6: temp
.global poly_basemul_acc_cache_init_rv64im
.align 2
poly_basemul_acc_cache_init_rv64im:
    li a5, q32
    li a6, 64
poly_basemul_acc_cache_init_rv64im_loop:
    lh t2, 2*0(a2) // b[0]
    lh t3, 2*1(a2) // b[1]
    ld t4, 8*0(a4) // zeta
    lh t0, 2*0(a1) // a[0]
    lh t1, 2*1(a1) // a[1]
    // r[0]=a[0]b[0]+a[1](b[1]zeta), r[1]=a[0]b[1]+a[1]b[0]
    plant_mul_const a5, t4, t3, t5
    sh  t5, 2*0(a3)  // store b[1]zeta for later usage
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
    addi a4, a4, 8*1
    addi a6, a6, -1
    bne a6, zero, poly_basemul_acc_cache_init_rv64im_loop
ret

// void poly_basemul_acc_cache_init_end_rv64im(int16_t *r, const int16_t *a, const int16_t *b, int16_t *b_cache, uint64_t *zetas, int32_t *r_double)
// compute basemul, cache bzeta into b_cache, accumulate the 32-bit results into r_double, and reduce r_double to r
// a0: r, a1: a, a2: b, a3: b_cache, a4: zetas, a5: r_double
// a6: loop control, a7: accumulated value
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: zeta, t5-t6: temp
// s0: q<<32, s1: qinv
.global poly_basemul_acc_cache_init_end_rv64im
.align 2
poly_basemul_acc_cache_init_end_rv64im:
    addi sp, sp, -8*2
    sd   s0, 0*8(sp)
    sd   s1, 1*8(sp)
    li s0, q32
    li s1, qinv
    li a6, 64
poly_basemul_acc_cache_init_end_rv64im_loop:
    lh t2, 2*0(a2) // b[0]
    lh t3, 2*1(a2) // b[1]
    ld t4, 8*0(a4) // zeta
    lh t0, 2*0(a1) // a[0]
    lh t1, 2*1(a1) // a[1]
    // r[0]=a[0]b[0]+a[1](b[1]zeta), r[1]=a[0]b[1]+a[1]b[0]
    plant_mul_const s0, t4, t3, t5
    sh  t5, 2*0(a3)  // store b[1]zeta for later usage
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
    sh  t5, 2*1(a3)
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
    addi a4, a4, 8*1
    addi a5, a5, 4*4
    addi a6, a6, -1
    bne a6, zero, poly_basemul_acc_cache_init_end_rv64im_loop
    ld   s0, 0*8(sp)
    ld   s1, 1*8(sp)
    addi sp, sp, 8*2
ret

// void poly_basemul_acc_cached_rv64im(int32_t *r, const int16_t *a, const int16_t *b, int16_t *b_cache)
// compute basemul using cached b_cache and accumulate the 32-bit results into r
// a0: r, a1: a, a2: b, a3: b_cache
// a5: q<<32, a6: loop control
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: accumulated value, t5-t6: temp
.global poly_basemul_acc_cached_rv64im
.align 2
poly_basemul_acc_cached_rv64im:
    li a5, q32
    li a6, 64
poly_basemul_acc_cached_rv64im_loop:
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
    bne a6, zero, poly_basemul_acc_cached_rv64im_loop
ret

// void poly_basemul_acc_cache_end_rv64im(int16_t *r, const int16_t *a, const int16_t *b, int16_t *b_cache, int32_t *r_double)
// compute basemul using cached b_cache, accumulate the 32-bit results into r_double, and reduce r_double to r
// a0: r, a1: a, a2: b, a3: b_cache, a4: r_double
// a5: q<<32, a6: loop control, a7: qinv
// t0-t3: a[2i,2i+1],b[2i,2i+1]
// t4: accumulated value, t5-t6: temp
.global poly_basemul_acc_cache_end_rv64im
.align 2
poly_basemul_acc_cache_end_rv64im:
    li a5, q32
    li a6, 64
    li a7, qinv
poly_basemul_acc_cache_end_rv64im_loop:
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
    bne a6, zero, poly_basemul_acc_cache_end_rv64im_loop
ret

// each coeff is multiplied by plantconst2 using plantard multiplication
.global poly_toplant_rv64im
.align 2
poly_toplant_rv64im:
  addi sp, sp, -8*15
  save_regs
  li t4, plantconst2
  li tp, q32
  addi gp, x0, 16
  addi a1, a0, 0
  poly_toplant_rv64im_loop:
    lh s0,  2*0(a0)
    lh s1,  2*1(a0)
    lh s2,  2*2(a0)
    lh s3,  2*3(a0)
    plant_mul_const_inplace tp, t4, s0
    plant_mul_const_inplace tp, t4, s1
    sh s0,  2*0(a1)
    plant_mul_const_inplace tp, t4, s2
    sh s1,  2*1(a1)
    plant_mul_const_inplace tp, t4, s3
    sh s2,  2*2(a1)
    lh s4,  2*4(a0)
    lh s5,  2*5(a0)
    lh s6,  2*6(a0)
    lh s7,  2*7(a0)
    plant_mul_const_inplace tp, t4, s4
    sh s3,  2*3(a1)
    plant_mul_const_inplace tp, t4, s5
    sh s4,  2*4(a1)
    plant_mul_const_inplace tp, t4, s6
    sh s5,  2*5(a1)
    plant_mul_const_inplace tp, t4, s7
    sh s6,  2*6(a1)
    lh s8,  2*8(a0)
    lh s9,  2*9(a0)
    lh s10, 2*10(a0)
    lh s11, 2*11(a0)
    plant_mul_const_inplace tp, t4, s8
    sh s7,  2*7(a1)
    plant_mul_const_inplace tp, t4, s9
    sh s8,  2*8(a1)
    plant_mul_const_inplace tp, t4, s10
    sh s9,  2*9(a1)
    plant_mul_const_inplace tp, t4, s11
    sh s10, 2*10(a1)
    lh t0,  2*12(a0) 
    lh t1,  2*13(a0)
    lh t2,  2*14(a0)
    lh t3,  2*15(a0) 
    plant_mul_const_inplace tp, t4, t0
    sh s11, 2*11(a1)
    plant_mul_const_inplace tp, t4, t1
    sh t0,  2*12(a1)
    plant_mul_const_inplace tp, t4, t2
    sh t1,  2*13(a1)
    plant_mul_const_inplace tp, t4, t3
    sh t2,  2*14(a1)
    sh t3,  2*15(a1)
    addi a0, a0, 16*2
    addi a1, a1, 16*2
    addi gp, gp, -1
  bne gp, zero, poly_toplant_rv64im_loop
  restore_regs
  addi sp, sp, 8*15
  ret

// plantard reduction to a poly
.global poly_plantard_rdc_rv64im
.align 2
poly_plantard_rdc_rv64im:
  addi sp, sp, -8*15
  save_regs
  li t6, plantconst
  li tp, q32
  addi gp, x0, 16
  addi a1, a0, 0
  poly_plantard_rdc_rv64im_loop:
    lh s0,  2*0(a0)
    lh s1,  2*1(a0)
    lh s2,  2*2(a0)
    lh s3,  2*3(a0)
    plant_red tp, t6, s0
    plant_red tp, t6, s1
    sh s0,  2*0(a1)
    plant_red tp, t6, s2
    sh s1,  2*1(a1)
    plant_red tp, t6, s3
    sh s2,  2*2(a1)
    lh s4,  2*4(a0)
    lh s5,  2*5(a0)
    lh s6,  2*6(a0)
    lh s7,  2*7(a0)
    plant_red tp, t6, s4
    sh s3,  2*3(a1)
    plant_red tp, t6, s5
    sh s4,  2*4(a1)
    plant_red tp, t6, s6
    sh s5,  2*5(a1)
    plant_red tp, t6, s7
    sh s6,  2*6(a1)
    lh s8,  2*8(a0)
    lh s9,  2*9(a0)
    lh s10, 2*10(a0)
    lh s11, 2*11(a0)
    plant_red tp, t6, s8
    sh s7,  2*7(a1)
    plant_red tp, t6, s9
    sh s8,  2*8(a1)
    plant_red tp, t6, s10
    sh s9,  2*9(a1)
    plant_red tp, t6, s11
    sh s10, 2*10(a1)
    lh t0,  2*12(a0) 
    lh t1,  2*13(a0)
    lh t2,  2*14(a0)
    lh t3,  2*15(a0) 
    plant_red tp, t6, t0
    sh s11, 2*11(a1)
    plant_red tp, t6, t1
    sh t0,  2*12(a1) 
    plant_red tp, t6, t2
    sh t1,  2*13(a1)
    plant_red tp, t6, t3
    sh t2,  2*14(a1)
    sh t3,  2*15(a1)
    addi a0, a0, 16*2
    addi a1, a1, 16*2
    addi gp, gp, -1
  bne gp, zero, poly_plantard_rdc_rv64im_loop
  restore_regs
  addi sp, sp, 8*15
  ret
