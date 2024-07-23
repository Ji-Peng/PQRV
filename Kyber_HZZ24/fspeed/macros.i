#ifndef MACROS_I
#define MACROS_I

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


#endif /* MACROS_I */