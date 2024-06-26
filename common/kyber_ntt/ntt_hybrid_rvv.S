#include "consts.h"

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

.globl ntt_rvv
.align 2
ntt_rvv:
    addi sp, sp, -4*17
    save_regs
    # stack init: 4*15(sp) for vector-*a; 4*16(sp) for *vector_zetas
    # addi t4, a0, 256*2
    addi t4, a0, 0
    sw   t4, 4*15(sp)
    # sw   a2, 4*16(sp)
    sw   a1, 4*16(sp)
    li t4, 128
    vsetvli t5, t4, e16, m1, tu, mu
    li t4, 3329
    lw   t5, 4*15(sp)
    addi t5, t5, (64*0+128)*2   
    vle16.v v8,  (t5);  addi t5, t5, 16
    vle16.v v9,  (t5);  addi t5, t5, 16
    vle16.v v10, (t5);  addi t5, t5, 16
    vle16.v v11, (t5);  addi t5, t5, 16
    vle16.v v12, (t5);  addi t5, t5, 16
    vle16.v v13, (t5);  addi t5, t5, 16
    vle16.v v14, (t5);  addi t5, t5, 16
    vle16.v v15, (t5);  addi t5, t5, -((64*0+128)*2+16*7)
    vle16.v v16, (t5);  addi t5, t5, 16
    vle16.v v17, (t5);  addi t5, t5, 16
    vle16.v v18, (t5);  addi t5, t5, 16
    vle16.v v19, (t5);  addi t5, t5, 16
    vle16.v v20, (t5);  addi t5, t5, 16
    vle16.v v21, (t5);  addi t5, t5, 16
    vle16.v v22, (t5);  addi t5, t5, 16
    vle16.v v23, (t5);  addi t5, t5, -16*7
    sw t5, 4*15(sp)
    lw t6, 4*16(sp)
    lh t5, (_ZETAS_EXP+0)*2(t6)
    lh t6, (_ZETAS_EXP+1)*2(t6)
    vmul.vx v0, v8, t5
    vmul.vx v1, v9, t5
    vmul.vx v2, v10, t5
    vmul.vx v3, v11, t5
    vmul.vx v4, v12, t5
    vmul.vx v5, v13, t5
    vmul.vx v6, v14, t5
    vmul.vx v7, v15, t5
    vmulh.vx v8,  v8, t6
    vmulh.vx v9,  v9, t6
    vmulh.vx v10, v10, t6
    vmulh.vx v11, v11, t6
    vmulh.vx v12, v12, t6
    vmulh.vx v13, v13, t6
    vmulh.vx v14, v14, t6
    vmulh.vx v15, v15, t6
    vmulh.vx v0, v0, t4
    vmulh.vx v1, v1, t4
    vmulh.vx v2, v2, t4
    vmulh.vx v3, v3, t4
    vmulh.vx v4, v4, t4
    vmulh.vx v5, v5, t4
    vmulh.vx v6, v6, t4
    vmulh.vx v7, v7, t4
    vsub.vv  v8,  v8,  v0
    vsub.vv  v9,  v9,  v1
    vsub.vv  v10, v10, v2
    vsub.vv  v11, v11, v3
    vsub.vv  v12, v12, v4
    vsub.vv  v13, v13, v5
    vsub.vv  v14, v14, v6
    vsub.vv  v15, v15, v7
    vadd.vv  v0, v16, v8
    vadd.vv  v1, v17, v9
    vadd.vv  v2, v18, v10
    vadd.vv  v3, v19, v11
    vadd.vv  v4, v20, v12
    vadd.vv  v5, v21, v13
    vadd.vv  v6, v22, v14
    vadd.vv  v7, v23, v15
    vsub.vv  v8, v16, v8
    vsub.vv  v9, v17, v9
    vsub.vv  v10, v18, v10
    vsub.vv  v11, v19, v11
    vsub.vv  v12, v20, v12
    vsub.vv  v13, v21, v13
    vsub.vv  v14, v22, v14
    vsub.vv  v15, v23, v15
    lw t5, 4*15(sp)
    vse16.v  v0,  (t5);  addi t5, t5, 16
    vse16.v  v1,  (t5);  addi t5, t5, 16
    vse16.v  v2,  (t5);  addi t5, t5, 16
    vse16.v  v3,  (t5);  addi t5, t5, 16
    vse16.v  v4,  (t5);  addi t5, t5, 16
    vse16.v  v5,  (t5);  addi t5, t5, 16
    vse16.v  v6,  (t5);  addi t5, t5, 16
    vse16.v  v7,  (t5);  addi t5, t5, (64*0+128)*2-16*7
    vse16.v  v8,  (t5);  addi t5, t5, 16
    vse16.v  v9,  (t5);  addi t5, t5, 16
    vse16.v  v10, (t5);  addi t5, t5, 16
    vse16.v  v11, (t5);  addi t5, t5, 16
    vse16.v  v12, (t5);  addi t5, t5, 16
    vse16.v  v13, (t5);  addi t5, t5, 16
    vse16.v  v14, (t5);  addi t5, t5, 16
    vse16.v  v15, (t5);  addi t5, t5, 16
    vle16.v  v24, (t5);  addi t5, t5, 16
    vle16.v  v25, (t5);  addi t5, t5, 16
    vle16.v  v26, (t5);  addi t5, t5, 16
    vle16.v  v27, (t5);  addi t5, t5, 16
    vle16.v  v28, (t5);  addi t5, t5, 16
    vle16.v  v29, (t5);  addi t5, t5, 16
    vle16.v  v30, (t5);  addi t5, t5, 16
    vle16.v  v31, (t5);  addi t5, t5, -(128*2)-16*7
    vle16.v  v16, (t5);  addi t5, t5, 16
    vle16.v  v17, (t5);  addi t5, t5, 16
    vle16.v  v18, (t5);  addi t5, t5, 16
    vle16.v  v19, (t5);  addi t5, t5, 16
    vle16.v  v20, (t5);  addi t5, t5, 16
    vle16.v  v21, (t5);  addi t5, t5, 16
    vle16.v  v22, (t5);  addi t5, t5, 16
    vle16.v  v23, (t5);  addi t5, t5, -16*7
    sw t5, 4*15(sp)
    lw t6, 4*16(sp)
    lh t5, (_ZETAS_EXP+0)*2(t6)
    lh t6, (_ZETAS_EXP+1)*2(t6)
    vmul.vx v0, v24, t5
    vmul.vx v1, v25, t5
    vmul.vx v2, v26, t5
    vmul.vx v3, v27, t5
    vmul.vx v4, v28, t5
    vmul.vx v5, v29, t5
    vmul.vx v6, v30, t5
    vmul.vx v7, v31, t5
    vmulh.vx v24, v24, t6
    vmulh.vx v25, v25, t6
    vmulh.vx v26, v26, t6
    vmulh.vx v27, v27, t6
    vmulh.vx v28, v28, t6
    vmulh.vx v29, v29, t6
    vmulh.vx v30, v30, t6
    vmulh.vx v31, v31, t6
    vmulh.vx v0, v0, t4
    vmulh.vx v1, v1, t4
    vmulh.vx v2, v2, t4
    vmulh.vx v3, v3, t4
    vmulh.vx v4, v4, t4
    vmulh.vx v5, v5, t4
    vmulh.vx v6, v6, t4
    vmulh.vx v7, v7, t4
    vsub.vv  v24, v24, v0
    vsub.vv  v25, v25, v1
    vsub.vv  v26, v26, v2
    vsub.vv  v27, v27, v3
    vsub.vv  v28, v28, v4
    vsub.vv  v29, v29, v5
    vsub.vv  v30, v30, v6
    vsub.vv  v31, v31, v7
    vadd.vv  v0, v16, v24
    vadd.vv  v1, v17, v25
    vadd.vv  v2, v18, v26
    vadd.vv  v3, v19, v27
    vadd.vv  v4, v20, v28
    vadd.vv  v5, v21, v29
    vadd.vv  v6, v22, v30
    vadd.vv  v7, v23, v31
    vsub.vv  v24, v16, v24
    vsub.vv  v25, v17, v25
    vsub.vv  v26, v18, v26
    vsub.vv  v27, v19, v27
    vsub.vv  v28, v20, v28
    vsub.vv  v29, v21, v29
    vsub.vv  v30, v22, v30
    vsub.vv  v31, v23, v31
    lw t5, 4*15(sp)
    vse16.v  v0,  (t5);  addi t5, t5, 16
    vse16.v  v1,  (t5);  addi t5, t5, 16
    vse16.v  v2,  (t5);  addi t5, t5, 16
    vse16.v  v3,  (t5);  addi t5, t5, 16
    vse16.v  v4,  (t5);  addi t5, t5, 16
    vse16.v  v5,  (t5);  addi t5, t5, 16
    vse16.v  v6,  (t5);  addi t5, t5, 16
    vse16.v  v7,  (t5);  addi t5, t5, -16*7+128*2
    vse16.v  v24, (t5);  addi t5, t5, 16
    vse16.v  v25, (t5);  addi t5, t5, 16
    vse16.v  v26, (t5);  addi t5, t5, 16
    vse16.v  v27, (t5);  addi t5, t5, 16
    vse16.v  v28, (t5);  addi t5, t5, 16
    vse16.v  v29, (t5);  addi t5, t5, 16
    vse16.v  v30, (t5);  addi t5, t5, 16
    vse16.v  v31, (t5);  addi t5, t5, -16*7-192*2
    sw t5, 4*15(sp)
    lw t6, 4*16(sp)
    addi t5, t6, _MASK_45674567*2;      vle16.v v31, (t5)
    addi t5, t6, _MASK_01230123*2;      vle16.v v30, (t5)
    addi t5, t6, _MASK_00010045*2;      vle16.v v29, (t5)
    addi t5, t6, _MASK_23006700*2;      vle16.v v28, (t5)
    lw   t5, 4*15(sp);  addi t5, t5, (64+0*128)*2
    vle16.v v9,  (t5);  addi t5, t5, 16
    vle16.v v10, (t5);  addi t5, t5, 16
    vle16.v v11, (t5);  addi t5, t5, 16
    vle16.v v12, (t5);  addi t5, t5, 16
    vle16.v v13, (t5);  addi t5, t5, 16
    vle16.v v14, (t5);  addi t5, t5, 16
    vle16.v v15, (t5);  addi t5, t5, 16
    vle16.v v16, (t5);  addi t5, t5, -16*7-(64+0*128)*2+(0*128)*2
    vle16.v v1,  (t5);  addi t5, t5, 16
    vle16.v v2,  (t5);  addi t5, t5, 16
    vle16.v v3,  (t5);  addi t5, t5, 16
    vle16.v v4,  (t5);  addi t5, t5, 16
    vle16.v v5,  (t5);  addi t5, t5, 16
    vle16.v v6,  (t5);  addi t5, t5, 16
    vle16.v v7,  (t5);  addi t5, t5, 16
    vle16.v v8,  (t5)
    lw t6, 4*16(sp)
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
    lh t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
    vmul.vx v17, v9,  t5
    vmul.vx v18, v10, t5
    vmul.vx v19, v11, t5
    vmul.vx v20, v12, t5
    vmul.vx v21, v13, t5
    vmul.vx v22, v14, t5
    vmul.vx v23, v15, t5
    vmul.vx v24, v16, t5
    vmulh.vx v9,  v9,  t6
    vmulh.vx v10, v10, t6
    vmulh.vx v11, v11, t6
    vmulh.vx v12, v12, t6
    vmulh.vx v13, v13, t6
    vmulh.vx v14, v14, t6
    vmulh.vx v15, v15, t6
    vmulh.vx v16, v16, t6
    vmulh.vx v21, v21, t4
    vmulh.vx v22, v22, t4
    vmulh.vx v23, v23, t4
    vmulh.vx v24, v24, t4
    vsub.vv  v13, v13, v21
    vsub.vv  v14, v14, v22
    vsub.vv  v15, v15, v23
    vsub.vv  v16, v16, v24
    vmulh.vx v17, v17, t4
    vsub.vv  v21, v5, v13
    vmulh.vx v18, v18, t4
    vsub.vv  v22, v6, v14
    vmulh.vx v19, v19, t4
    vsub.vv  v23, v7, v15
    vmulh.vx v20, v20, t4
    vsub.vv  v24, v8, v16
    vsub.vv  v9,  v9,  v17
    vsub.vv  v10, v10, v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    vsub.vv  v17, v1, v9
    vsub.vv  v18, v2, v10
    vsub.vv  v19, v3, v11
    vsub.vv  v20, v4, v12
    vadd.vv  v13, v5, v13
    vadd.vv  v14, v6, v14
    vadd.vv  v15, v7, v15
    vadd.vv  v16, v8, v16
    vadd.vv  v9, v1, v9
    vadd.vv  v10, v2, v10
    vadd.vv  v11, v3, v11
    vadd.vv  v12, v4, v12
    lw t6, 4*16(sp)
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
    vmul.vx v1, v13, t5
    vmul.vx v2, v14, t5
    vmul.vx v3, v15, t5
    vmul.vx v4, v16, t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
    vmul.vx v5, v21, t5
    vmul.vx v6, v22, t5
    vmul.vx v7, v23, t5
    vmul.vx v8, v24, t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
    vmulh.vx v13, v13, t5
    vmulh.vx v14, v14, t5
    vmulh.vx v15, v15, t5
    vmulh.vx v16, v16, t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
    vmulh.vx v21, v21, t5
    vmulh.vx v22, v22, t5
    vmulh.vx v23, v23, t5
    vmulh.vx v24, v24, t5
    vmulh.vx v1, v1, t4
    vmulh.vx v2, v2, t4
    vmulh.vx v3, v3, t4
    vmulh.vx v4, v4, t4
    vsub.vv  v13, v13, v1
    vsub.vv  v14, v14, v2
    vsub.vv  v15, v15, v3
    vsub.vv  v16, v16, v4
    vmulh.vx v5, v5, t4
    vadd.vv  v1, v9,  v13
    vmulh.vx v6, v6, t4
    vadd.vv  v2, v10, v14
    vmulh.vx v7, v7, t4
    vadd.vv  v3, v11, v15
    vmulh.vx v8, v8, t4
    vadd.vv  v4, v12, v16
    vsub.vv  v21, v21, v5
    vsub.vv  v22, v22, v6
    vsub.vv  v23, v23, v7
    vsub.vv  v24, v24, v8
    vadd.vv  v5, v17, v21
    vadd.vv  v6, v18, v22
    vadd.vv  v7, v19, v23
    vadd.vv  v8, v20, v24
    vsub.vv  v9, v9,  v13
    vsub.vv  v10, v10,v14
    vsub.vv  v11,v11, v15
    vsub.vv  v12,v12, v16
    vsub.vv  v13,v17, v21
    vsub.vv  v14,v18, v22
    vsub.vv  v15,v19, v23
    vsub.vv  v16,v20, v24
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
    vmul.vx v17, v3,  t5
    vmul.vx v18, v4,  t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
    vmul.vx v19, v11, t5
    vmul.vx v20, v12, t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
    vmul.vx v21, v7,  t5
    vmul.vx v22, v8,  t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
    vmul.vx v23, v15, t5
    vmul.vx v24, v16, t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
    vmulh.vx v3,  v3,  t5
    vmulh.vx v4,  v4,  t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
    vmulh.vx v11, v11, t5
    vmulh.vx v12, v12, t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
    vmulh.vx v7,  v7,  t5
    vmulh.vx v8,  v8,  t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
    vmulh.vx v15, v15, t5
    vmulh.vx v16, v16, t5
    vmulh.vx v17, v17, t4
    vmulh.vx v18, v18, t4
    vmulh.vx v19, v19, t4
    vmulh.vx v20, v20, t4
    vsub.vv  v3,  v3,  v17
    vsub.vv  v4,  v4,  v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    vmulh.vx v21, v21, t4
    vadd.vv  v17, v1,  v3
    vmulh.vx v22, v22, t4
    vadd.vv  v18, v2,  v4
    vmulh.vx v23, v23, t4
    vadd.vv  v19, v9,  v11
    vmulh.vx v24, v24, t4
    vadd.vv  v20, v10, v12
    vsub.vv  v7,  v7,  v21
    vsub.vv  v8,  v8,  v22
    vsub.vv  v15, v15, v23
    vsub.vv  v16, v16, v24
    vadd.vv  v21, v5,  v7
    vadd.vv  v22, v6,  v8
    vadd.vv  v23, v13, v15
    vadd.vv  v24, v14, v16
    vsub.vv  v1,  v1,  v3
    vsub.vv  v2,  v2,  v4
    vsub.vv  v3,  v9,  v11
    vsub.vv  v4,  v10, v12
    vsub.vv  v5,  v5,  v7
    vsub.vv  v6,  v6,  v8
    vsub.vv  v7,  v13, v15
    vsub.vv  v8,  v14, v16
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
    vmul.vx v9,  v18,  t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
    vmulh.vx v18, v18, t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
    vmul.vx v10, v2,   t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
    vmulh.vx v2,  v2,  t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
    vmul.vx v11, v20,  t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
    vmulh.vx v20, v20, t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
    vmul.vx v12, v4,   t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
    vmulh.vx v4,  v4,  t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
    vmul.vx v13, v22,  t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
    vmulh.vx v22, v22, t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
    vmul.vx v14, v6,   t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
    vmulh.vx v6,  v6,  t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
    vmul.vx v15, v24,  t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
    vmulh.vx v24, v24, t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
    vmul.vx v16, v8,   t5
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
    vmulh.vx v8,  v8,  t5
    vmulh.vx v9,  v9,  t4
    vmulh.vx v10, v10, t4
    vmulh.vx v11, v11, t4
    vmulh.vx v12, v12, t4
    vsub.vv  v18, v18, v9
    vsub.vv  v2,  v2,  v10
    vsub.vv  v20, v20, v11
    vsub.vv  v4,  v4,  v12
    vmulh.vx v13, v13, t4
    vadd.vv  v9,  v17, v18
    vmulh.vx v14, v14, t4
    vadd.vv  v10, v1,  v2
    vmulh.vx v15, v15, t4
    vadd.vv  v11, v19, v20
    vmulh.vx v16, v16, t4
    vadd.vv  v12, v3, v4
    addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
    vsub.vv  v22, v22, v13
    vsub.vv  v6,  v6,  v14
    vsub.vv  v24, v24, v15
    vsub.vv  v8,  v8,  v16
    vsub.vv  v17, v17, v18
    vsub.vv  v18, v1,  v2
    vsub.vv  v19, v19, v20
    vsub.vv  v20, v3,  v4
    vadd.vv  v13, v21,  v22
    vadd.vv  v14, v5,  v6
    vadd.vv  v15, v23, v24
    vrgather.vv v2, v9, v31
    vrgather.vv v1, v17, v30
    vmerge.vvm v2, v17, v2, v0
    vmerge.vvm v1, v1, v9, v0
    vadd.vv  v16, v7, v8
    vrgather.vv v4, v10, v31
    vrgather.vv v3, v18, v30
    vmerge.vvm v4, v18, v4, v0
    vmerge.vvm v3, v3, v10, v0
    vsub.vv  v21, v21, v22
    vsub.vv  v22, v5,  v6
    vsub.vv  v23, v23, v24
    vsub.vv  v24, v7,  v8
    addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L5 + 0*_ZETAS_EXP_1TO6_P1_L5)*2
    vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v9,  v2,  v27
    vmulh.vv v2,  v2,  v26
    vrgather.vv v6, v11, v31
    vrgather.vv v5, v19, v30
    vmerge.vvm v6, v19, v6, v0
    vmerge.vvm v5, v5, v11, v0
    vrgather.vv v8, v12, v31
    vrgather.vv v7, v20, v30
    vmerge.vvm v8, v20, v8, v0
    vmerge.vvm v7, v7, v12, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v17, v4,  v27
    vmulh.vv v4,  v4,  v26
    vmulh.vx v9,  v9,  t4
    vmulh.vx v17, v17, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v10, v6,  v27
    vmulh.vv v6,  v6,  v26
    vsub.vv  v2,  v2,  v9
    vmulh.vx v10, v10, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v18, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v18, v18, t4
    vsub.vv  v4,  v4,  v17
    vsub.vv  v6,  v6,  v10
    vsub.vv  v8,  v8,  v18
    vadd.vv  v9,  v1,  v2
    vsub.vv  v11, v1,  v2
    vadd.vv  v17, v3,  v4
    vsub.vv  v19, v3,  v4
    vadd.vv  v10, v5,  v6
    vsub.vv  v12, v5,  v6
    vrgather.vv v2, v13, v31
    vrgather.vv v1, v21, v30
    vmerge.vvm v2, v21, v2, v0
    vmerge.vvm v1, v1, v13, v0
    vrgather.vv v4, v14, v31
    vrgather.vv v3, v22, v30
    vmerge.vvm v4, v22, v4, v0
    vmerge.vvm v3, v3, v14, v0
    vadd.vv  v18, v7,  v8
    vsub.vv  v20, v7,  v8
    vrgather.vv v6, v15, v31
    vrgather.vv v5, v23, v30
    vmerge.vvm v6, v23, v6, v0
    vmerge.vvm v5, v5, v15, v0
    vrgather.vv v8, v16, v31
    vrgather.vv v7, v24, v30
    vmerge.vvm v8, v24, v8, v0
    vmerge.vvm v7, v7, v16, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v13, v2,  v27
    vmulh.vv v2,  v2,  v26
    vmulh.vx v13, v13, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v21, v4,  v27
    vmulh.vv v4,  v4,  v26
    vmulh.vx v21, v21, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v14, v6,  v27
    vmulh.vv v6,  v6,  v26
    vmulh.vx v14, v14, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v22, v8,  v27
    vmulh.vv v8,  v8,  v26
    vsub.vv  v2,  v2, v13
    vsub.vv  v4,  v4, v21
    vmulh.vx v22, v22, t4
    vsub.vv  v6,  v6, v14
    vsub.vv  v8,  v8, v22
    lw t6, 4*16(sp)
    addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
    vadd.vv  v13, v1,  v2
    vsub.vv  v15, v1,  v2
    vadd.vv  v21, v3,  v4
    vsub.vv  v23, v3,  v4
    vadd.vv  v14, v5,  v6
    vsub.vv  v16, v5,  v6
    vrgather.vv v1, v11, v29
    vmerge.vvm  v1, v1, v9, v0
    vrgather.vv v2, v9, v28
    vmerge.vvm  v2, v11, v2, v0
    vadd.vv  v22, v7,  v8
    vsub.vv  v24, v7,  v8
    vrgather.vv v3, v19, v29
    vmerge.vvm  v3, v3, v17, v0
    vrgather.vv v4, v17, v28
    vmerge.vvm  v4, v19, v4, v0
    addi t6, t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L6+ 0*_ZETAS_EXP_1TO6_P1_L6)*2
    vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v9,  v2,  v27
    vmulh.vv v2,  v2,  v26
    vrgather.vv v5, v12, v29
    vmerge.vvm  v5, v5, v10, v0
    vrgather.vv v6, v10, v28
    vmerge.vvm  v6, v12, v6, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v11, v4,  v27
    vmulh.vv v4,  v4,  v26
    vrgather.vv v7, v20, v29
    vmerge.vvm  v7, v7, v18, v0
    vrgather.vv v8, v18, v28
    vmerge.vvm  v8, v20, v8, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v17, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v19, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v9,  v9,  t4
    vmulh.vx v11, v11, t4
    vmulh.vx v17, v17, t4
    vmulh.vx v19, v19, t4
    vsub.vv  v2,  v2,  v9
    vsub.vv  v4,  v4,  v11
    vsub.vv  v6,  v6,  v17
    vsub.vv  v8,  v8,  v19
    vadd.vv  v9,  v1,  v2
    vsub.vv  v11, v1,  v2
    vadd.vv  v17, v3,  v4
    vsub.vv  v19, v3,  v4
    vrgather.vv v1, v15, v29
    vmerge.vvm  v1, v1, v13, v0
    vrgather.vv v2, v13, v28
    vmerge.vvm  v2, v15, v2, v0
    vadd.vv  v10, v5,  v6
    vsub.vv  v12, v5,  v6
    vadd.vv  v18, v7,  v8
    vsub.vv  v20, v7,  v8
    vrgather.vv v3, v23, v29
    vmerge.vvm  v3, v3, v21, v0
    vrgather.vv v4, v21, v28
    vmerge.vvm  v4, v23, v4, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v13, v2,  v27
    vmulh.vv v2,  v2,  v26
    vrgather.vv v5, v16, v29
    vmerge.vvm  v5, v5, v14, v0
    vrgather.vv v6, v14, v28
    vmerge.vvm  v6, v16, v6, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v15, v4,  v27
    vmulh.vv v4,  v4,  v26
    vrgather.vv v7, v24, v29
    vmerge.vvm  v7, v7, v22, v0
    vrgather.vv v8, v22, v28
    vmerge.vvm  v8, v24, v8, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v21, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v23, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v13, v13, t4
    vmulh.vx v15, v15, t4
    vmulh.vx v21, v21, t4
    vmulh.vx v23, v23, t4
    vsub.vv  v2,  v2,  v13
    vsub.vv  v4,  v4,  v15
    vsub.vv  v6,  v6,  v21
    vsub.vv  v8,  v8,  v23
    vadd.vv  v13, v1,  v2
    vsub.vv  v15, v1,  v2
    lw t6, 4*16(sp)
    addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
    addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
    vadd.vv  v21, v3,  v4
    vsub.vv  v23, v3,  v4
    vrgather.vv v1, v11, v27
    vrgather.vv v2, v9, v27
    vmerge.vvm  v1, v1, v9, v0
    vmerge.vvm  v2, v11, v2, v0
    vadd.vv  v14, v5,  v6
    vsub.vv  v16, v5,  v6
    vrgather.vv v3, v19, v27
    vrgather.vv v4, v17, v27
    vmerge.vvm  v3, v3, v17, v0
    vmerge.vvm  v4, v19, v4, v0
    vadd.vv  v22, v7,  v8
    vsub.vv  v24, v7,  v8
    vrgather.vv v5, v12, v27
    vrgather.vv v6, v10, v27
    vmerge.vvm  v5, v5, v10, v0
    vmerge.vvm  v6, v12, v6, v0
    vrgather.vv v7, v20, v27
    vrgather.vv v8, v18, v27
    vmerge.vvm  v7, v7, v18, v0
    vmerge.vvm  v8, v20, v8, v0
    vrgather.vv v9, v15, v27
    vrgather.vv v11, v13, v27
    vmerge.vvm  v9, v9, v13, v0
    vmerge.vvm  v11, v15, v11, v0
    vrgather.vv v17, v23, v27
    vrgather.vv v19, v21, v27
    vmerge.vvm  v17, v17, v21, v0
    vmerge.vvm  v19, v23, v19, v0
    vrgather.vv v10, v16, v27
    vrgather.vv v12, v14, v27
    vmerge.vvm  v10, v10, v14, v0
    vmerge.vvm  v12, v16, v12, v0
    vrgather.vv v18, v24, v27
    vrgather.vv v20, v22, v27
    vmerge.vvm  v18, v18, v22, v0
    vmerge.vvm  v20, v24, v20, v0
    lw   t5, 4*15(sp);   addi t5, t5, (0*128)*2
    vse16.v  v1,  (t5);  addi t5, t5, 16
    vse16.v  v2,  (t5);  addi t5, t5, 16
    vse16.v  v3,  (t5);  addi t5, t5, 16
    vse16.v  v4,  (t5);  addi t5, t5, 16
    vse16.v  v5,  (t5);  addi t5, t5, 16
    vse16.v  v6,  (t5);  addi t5, t5, 16
    vse16.v  v7,  (t5);  addi t5, t5, 16
    vse16.v  v8,  (t5);  addi t5, t5, -16*7-(0*128)*2+(64+0*128)*2
    vse16.v  v9,  (t5);  addi t5, t5, 16
    vse16.v  v11, (t5);  addi t5, t5, 16
    vse16.v  v17, (t5);  addi t5, t5, 16
    vse16.v  v19, (t5);  addi t5, t5, 16
    vse16.v  v10, (t5);  addi t5, t5, 16
    vse16.v  v12, (t5);  addi t5, t5, 16
    vse16.v  v18, (t5);  addi t5, t5, 16
    vse16.v  v20, (t5)
    lw   t5, 4*15(sp);  addi t5, t5, (64+1*128)*2
    vle16.v v9,  (t5);  addi t5, t5, 16
    vle16.v v10, (t5);  addi t5, t5, 16
    vle16.v v11, (t5);  addi t5, t5, 16
    vle16.v v12, (t5);  addi t5, t5, 16
    vle16.v v13, (t5);  addi t5, t5, 16
    vle16.v v14, (t5);  addi t5, t5, 16
    vle16.v v15, (t5);  addi t5, t5, 16
    vle16.v v16, (t5);  addi t5, t5, -16*7-(64+1*128)*2+(1*128)*2
    vle16.v v1,  (t5);  addi t5, t5, 16
    vle16.v v2,  (t5);  addi t5, t5, 16
    vle16.v v3,  (t5);  addi t5, t5, 16
    vle16.v v4,  (t5);  addi t5, t5, 16
    vle16.v v5,  (t5);  addi t5, t5, 16
    vle16.v v6,  (t5);  addi t5, t5, 16
    vle16.v v7,  (t5);  addi t5, t5, 16
    vle16.v v8,  (t5)
    lw t6, 4*16(sp)
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
    lh t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
    vmul.vx v17, v9,  t5
    vmul.vx v18, v10, t5
    vmul.vx v19, v11, t5
    vmul.vx v20, v12, t5
    vmul.vx v21, v13, t5
    vmul.vx v22, v14, t5
    vmul.vx v23, v15, t5
    vmul.vx v24, v16, t5
    vmulh.vx v9,  v9,  t6
    vmulh.vx v10, v10, t6
    vmulh.vx v11, v11, t6
    vmulh.vx v12, v12, t6
    vmulh.vx v13, v13, t6
    vmulh.vx v14, v14, t6
    vmulh.vx v15, v15, t6
    vmulh.vx v16, v16, t6
    vmulh.vx v21, v21, t4
    vmulh.vx v22, v22, t4
    vmulh.vx v23, v23, t4
    vmulh.vx v24, v24, t4
    vsub.vv  v13, v13, v21
    vsub.vv  v14, v14, v22
    vsub.vv  v15, v15, v23
    vsub.vv  v16, v16, v24
    vmulh.vx v17, v17, t4
    vsub.vv  v21, v5, v13
    vmulh.vx v18, v18, t4
    vsub.vv  v22, v6, v14
    vmulh.vx v19, v19, t4
    vsub.vv  v23, v7, v15
    vmulh.vx v20, v20, t4
    vsub.vv  v24, v8, v16
    vsub.vv  v9,  v9,  v17
    vsub.vv  v10, v10, v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    vsub.vv  v17, v1, v9
    vsub.vv  v18, v2, v10
    vsub.vv  v19, v3, v11
    vsub.vv  v20, v4, v12
    vadd.vv  v13, v5, v13
    vadd.vv  v14, v6, v14
    vadd.vv  v15, v7, v15
    vadd.vv  v16, v8, v16
    vadd.vv  v9, v1, v9
    vadd.vv  v10, v2, v10
    vadd.vv  v11, v3, v11
    vadd.vv  v12, v4, v12
    lw t6, 4*16(sp)
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
    vmul.vx v1, v13, t5
    vmul.vx v2, v14, t5
    vmul.vx v3, v15, t5
    vmul.vx v4, v16, t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
    vmul.vx v5, v21, t5
    vmul.vx v6, v22, t5
    vmul.vx v7, v23, t5
    vmul.vx v8, v24, t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
    vmulh.vx v13, v13, t5
    vmulh.vx v14, v14, t5
    vmulh.vx v15, v15, t5
    vmulh.vx v16, v16, t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
    vmulh.vx v21, v21, t5
    vmulh.vx v22, v22, t5
    vmulh.vx v23, v23, t5
    vmulh.vx v24, v24, t5
    vmulh.vx v1, v1, t4
    vmulh.vx v2, v2, t4
    vmulh.vx v3, v3, t4
    vmulh.vx v4, v4, t4
    vsub.vv  v13, v13, v1
    vsub.vv  v14, v14, v2
    vsub.vv  v15, v15, v3
    vsub.vv  v16, v16, v4
    vmulh.vx v5, v5, t4
    vadd.vv  v1, v9,  v13
    vmulh.vx v6, v6, t4
    vadd.vv  v2, v10, v14
    vmulh.vx v7, v7, t4
    vadd.vv  v3, v11, v15
    vmulh.vx v8, v8, t4
    vadd.vv  v4, v12, v16
    vsub.vv  v21, v21, v5
    vsub.vv  v22, v22, v6
    vsub.vv  v23, v23, v7
    vsub.vv  v24, v24, v8
    vadd.vv  v5, v17, v21
    vadd.vv  v6, v18, v22
    vadd.vv  v7, v19, v23
    vadd.vv  v8, v20, v24
    vsub.vv  v9, v9,  v13
    vsub.vv  v10, v10,v14
    vsub.vv  v11,v11, v15
    vsub.vv  v12,v12, v16
    vsub.vv  v13,v17, v21
    vsub.vv  v14,v18, v22
    vsub.vv  v15,v19, v23
    vsub.vv  v16,v20, v24
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
    vmul.vx v17, v3,  t5
    vmul.vx v18, v4,  t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
    vmul.vx v19, v11, t5
    vmul.vx v20, v12, t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
    vmul.vx v21, v7,  t5
    vmul.vx v22, v8,  t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
    vmul.vx v23, v15, t5
    vmul.vx v24, v16, t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
    vmulh.vx v3,  v3,  t5
    vmulh.vx v4,  v4,  t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
    vmulh.vx v11, v11, t5
    vmulh.vx v12, v12, t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
    vmulh.vx v7,  v7,  t5
    vmulh.vx v8,  v8,  t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
    vmulh.vx v15, v15, t5
    vmulh.vx v16, v16, t5
    vmulh.vx v17, v17, t4
    vmulh.vx v18, v18, t4
    vmulh.vx v19, v19, t4
    vmulh.vx v20, v20, t4
    vsub.vv  v3,  v3,  v17
    vsub.vv  v4,  v4,  v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    vmulh.vx v21, v21, t4
    vadd.vv  v17, v1,  v3
    vmulh.vx v22, v22, t4
    vadd.vv  v18, v2,  v4
    vmulh.vx v23, v23, t4
    vadd.vv  v19, v9,  v11
    vmulh.vx v24, v24, t4
    vadd.vv  v20, v10, v12
    vsub.vv  v7,  v7,  v21
    vsub.vv  v8,  v8,  v22
    vsub.vv  v15, v15, v23
    vsub.vv  v16, v16, v24
    vadd.vv  v21, v5,  v7
    vadd.vv  v22, v6,  v8
    vadd.vv  v23, v13, v15
    vadd.vv  v24, v14, v16
    vsub.vv  v1,  v1,  v3
    vsub.vv  v2,  v2,  v4
    vsub.vv  v3,  v9,  v11
    vsub.vv  v4,  v10, v12
    vsub.vv  v5,  v5,  v7
    vsub.vv  v6,  v6,  v8
    vsub.vv  v7,  v13, v15
    vsub.vv  v8,  v14, v16
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
    vmul.vx v9,  v18,  t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
    vmulh.vx v18, v18, t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
    vmul.vx v10, v2,   t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
    vmulh.vx v2,  v2,  t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
    vmul.vx v11, v20,  t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
    vmulh.vx v20, v20, t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
    vmul.vx v12, v4,   t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
    vmulh.vx v4,  v4,  t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
    vmul.vx v13, v22,  t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
    vmulh.vx v22, v22, t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
    vmul.vx v14, v6,   t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
    vmulh.vx v6,  v6,  t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
    vmul.vx v15, v24,  t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
    vmulh.vx v24, v24, t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
    vmul.vx v16, v8,   t5
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
    vmulh.vx v8,  v8,  t5
    vmulh.vx v9,  v9,  t4
    vmulh.vx v10, v10, t4
    vmulh.vx v11, v11, t4
    vmulh.vx v12, v12, t4
    vsub.vv  v18, v18, v9
    vsub.vv  v2,  v2,  v10
    vsub.vv  v20, v20, v11
    vsub.vv  v4,  v4,  v12
    vmulh.vx v13, v13, t4
    vadd.vv  v9,  v17, v18
    vmulh.vx v14, v14, t4
    vadd.vv  v10, v1,  v2
    vmulh.vx v15, v15, t4
    vadd.vv  v11, v19, v20
    vmulh.vx v16, v16, t4
    vadd.vv  v12, v3, v4
    addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
    vsub.vv  v22, v22, v13
    vsub.vv  v6,  v6,  v14
    vsub.vv  v24, v24, v15
    vsub.vv  v8,  v8,  v16
    vsub.vv  v17, v17, v18
    vsub.vv  v18, v1,  v2
    vsub.vv  v19, v19, v20
    vsub.vv  v20, v3,  v4
    vadd.vv  v13, v21,  v22
    vadd.vv  v14, v5,  v6
    vadd.vv  v15, v23, v24
    vrgather.vv v2, v9, v31
    vrgather.vv v1, v17, v30
    vmerge.vvm v2, v17, v2, v0
    vmerge.vvm v1, v1, v9, v0
    vadd.vv  v16, v7, v8
    vrgather.vv v4, v10, v31
    vrgather.vv v3, v18, v30
    vmerge.vvm v4, v18, v4, v0
    vmerge.vvm v3, v3, v10, v0
    vsub.vv  v21, v21, v22
    vsub.vv  v22, v5,  v6
    vsub.vv  v23, v23, v24
    vsub.vv  v24, v7,  v8
    addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L5 + 1*_ZETAS_EXP_1TO6_P1_L5)*2
    vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v9,  v2,  v27
    vmulh.vv v2,  v2,  v26
    vrgather.vv v6, v11, v31
    vrgather.vv v5, v19, v30
    vmerge.vvm v6, v19, v6, v0
    vmerge.vvm v5, v5, v11, v0
    vrgather.vv v8, v12, v31
    vrgather.vv v7, v20, v30
    vmerge.vvm v8, v20, v8, v0
    vmerge.vvm v7, v7, v12, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v17, v4,  v27
    vmulh.vv v4,  v4,  v26
    vmulh.vx v9,  v9,  t4
    vmulh.vx v17, v17, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v10, v6,  v27
    vmulh.vv v6,  v6,  v26
    vsub.vv  v2,  v2,  v9
    vmulh.vx v10, v10, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v18, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v18, v18, t4
    vsub.vv  v4,  v4,  v17
    vsub.vv  v6,  v6,  v10
    vsub.vv  v8,  v8,  v18
    vadd.vv  v9,  v1,  v2
    vsub.vv  v11, v1,  v2
    vadd.vv  v17, v3,  v4
    vsub.vv  v19, v3,  v4
    vadd.vv  v10, v5,  v6
    vsub.vv  v12, v5,  v6
    vrgather.vv v2, v13, v31
    vrgather.vv v1, v21, v30
    vmerge.vvm v2, v21, v2, v0
    vmerge.vvm v1, v1, v13, v0
    vrgather.vv v4, v14, v31
    vrgather.vv v3, v22, v30
    vmerge.vvm v4, v22, v4, v0
    vmerge.vvm v3, v3, v14, v0
    vadd.vv  v18, v7,  v8
    vsub.vv  v20, v7,  v8
    vrgather.vv v6, v15, v31
    vrgather.vv v5, v23, v30
    vmerge.vvm v6, v23, v6, v0
    vmerge.vvm v5, v5, v15, v0
    vrgather.vv v8, v16, v31
    vrgather.vv v7, v24, v30
    vmerge.vvm v8, v24, v8, v0
    vmerge.vvm v7, v7, v16, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v13, v2,  v27
    vmulh.vv v2,  v2,  v26
    vmulh.vx v13, v13, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v21, v4,  v27
    vmulh.vv v4,  v4,  v26
    vmulh.vx v21, v21, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v14, v6,  v27
    vmulh.vv v6,  v6,  v26
    vmulh.vx v14, v14, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v22, v8,  v27
    vmulh.vv v8,  v8,  v26
    vsub.vv  v2,  v2, v13
    vsub.vv  v4,  v4, v21
    vmulh.vx v22, v22, t4
    vsub.vv  v6,  v6, v14
    vsub.vv  v8,  v8, v22
    lw t6, 4*16(sp)
    addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
    vadd.vv  v13, v1,  v2
    vsub.vv  v15, v1,  v2
    vadd.vv  v21, v3,  v4
    vsub.vv  v23, v3,  v4
    vadd.vv  v14, v5,  v6
    vsub.vv  v16, v5,  v6
    vrgather.vv v1, v11, v29
    vmerge.vvm  v1, v1, v9, v0
    vrgather.vv v2, v9, v28
    vmerge.vvm  v2, v11, v2, v0
    vadd.vv  v22, v7,  v8
    vsub.vv  v24, v7,  v8
    vrgather.vv v3, v19, v29
    vmerge.vvm  v3, v3, v17, v0
    vrgather.vv v4, v17, v28
    vmerge.vvm  v4, v19, v4, v0
    addi t6, t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L6+ 1*_ZETAS_EXP_1TO6_P1_L6)*2
    vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v9,  v2,  v27
    vmulh.vv v2,  v2,  v26
    vrgather.vv v5, v12, v29
    vmerge.vvm  v5, v5, v10, v0
    vrgather.vv v6, v10, v28
    vmerge.vvm  v6, v12, v6, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v11, v4,  v27
    vmulh.vv v4,  v4,  v26
    vrgather.vv v7, v20, v29
    vmerge.vvm  v7, v7, v18, v0
    vrgather.vv v8, v18, v28
    vmerge.vvm  v8, v20, v8, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v17, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v19, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v9,  v9,  t4
    vmulh.vx v11, v11, t4
    vmulh.vx v17, v17, t4
    vmulh.vx v19, v19, t4
    vsub.vv  v2,  v2,  v9
    vsub.vv  v4,  v4,  v11
    vsub.vv  v6,  v6,  v17
    vsub.vv  v8,  v8,  v19
    vadd.vv  v9,  v1,  v2
    vsub.vv  v11, v1,  v2
    vadd.vv  v17, v3,  v4
    vsub.vv  v19, v3,  v4
    vrgather.vv v1, v15, v29
    vmerge.vvm  v1, v1, v13, v0
    vrgather.vv v2, v13, v28
    vmerge.vvm  v2, v15, v2, v0
    vadd.vv  v10, v5,  v6
    vsub.vv  v12, v5,  v6
    vadd.vv  v18, v7,  v8
    vsub.vv  v20, v7,  v8
    vrgather.vv v3, v23, v29
    vmerge.vvm  v3, v3, v21, v0
    vrgather.vv v4, v21, v28
    vmerge.vvm  v4, v23, v4, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v13, v2,  v27
    vmulh.vv v2,  v2,  v26
    vrgather.vv v5, v16, v29
    vmerge.vvm  v5, v5, v14, v0
    vrgather.vv v6, v14, v28
    vmerge.vvm  v6, v16, v6, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v15, v4,  v27
    vmulh.vv v4,  v4,  v26
    vrgather.vv v7, v24, v29
    vmerge.vvm  v7, v7, v22, v0
    vrgather.vv v8, v22, v28
    vmerge.vvm  v8, v24, v8, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v21, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v23, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v13, v13, t4
    vmulh.vx v15, v15, t4
    vmulh.vx v21, v21, t4
    vmulh.vx v23, v23, t4
    vsub.vv  v2,  v2,  v13
    vsub.vv  v4,  v4,  v15
    vsub.vv  v6,  v6,  v21
    vsub.vv  v8,  v8,  v23
    vadd.vv  v13, v1,  v2
    vsub.vv  v15, v1,  v2
    lw t6, 4*16(sp)
    addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
    addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
    vadd.vv  v21, v3,  v4
    vsub.vv  v23, v3,  v4
    vrgather.vv v1, v11, v27
    vrgather.vv v2, v9, v27
    vmerge.vvm  v1, v1, v9, v0
    vmerge.vvm  v2, v11, v2, v0
    vadd.vv  v14, v5,  v6
    vsub.vv  v16, v5,  v6
    vrgather.vv v3, v19, v27
    vrgather.vv v4, v17, v27
    vmerge.vvm  v3, v3, v17, v0
    vmerge.vvm  v4, v19, v4, v0
    vadd.vv  v22, v7,  v8
    vsub.vv  v24, v7,  v8
    vrgather.vv v5, v12, v27
    vrgather.vv v6, v10, v27
    vmerge.vvm  v5, v5, v10, v0
    vmerge.vvm  v6, v12, v6, v0
    vrgather.vv v7, v20, v27
    vrgather.vv v8, v18, v27
    vmerge.vvm  v7, v7, v18, v0
    vmerge.vvm  v8, v20, v8, v0
    vrgather.vv v9, v15, v27
    vrgather.vv v11, v13, v27
    vmerge.vvm  v9, v9, v13, v0
    vmerge.vvm  v11, v15, v11, v0
    vrgather.vv v17, v23, v27
    vrgather.vv v19, v21, v27
    vmerge.vvm  v17, v17, v21, v0
    vmerge.vvm  v19, v23, v19, v0
    vrgather.vv v10, v16, v27
    vrgather.vv v12, v14, v27
    vmerge.vvm  v10, v10, v14, v0
    vmerge.vvm  v12, v16, v12, v0
    vrgather.vv v18, v24, v27
    vrgather.vv v20, v22, v27
    vmerge.vvm  v18, v18, v22, v0
    vmerge.vvm  v20, v24, v20, v0
    lw   t5, 4*15(sp);   addi t5, t5, (1*128)*2
    vse16.v  v1,  (t5);  addi t5, t5, 16
    vse16.v  v2,  (t5);  addi t5, t5, 16
    vse16.v  v3,  (t5);  addi t5, t5, 16
    vse16.v  v4,  (t5);  addi t5, t5, 16
    vse16.v  v5,  (t5);  addi t5, t5, 16
    vse16.v  v6,  (t5);  addi t5, t5, 16
    vse16.v  v7,  (t5);  addi t5, t5, 16
    vse16.v  v8,  (t5);  addi t5, t5, -16*7-(1*128)*2+(64+1*128)*2
    vse16.v  v9,  (t5);  addi t5, t5, 16
    vse16.v  v11, (t5);  addi t5, t5, 16
    vse16.v  v17, (t5);  addi t5, t5, 16
    vse16.v  v19, (t5);  addi t5, t5, 16
    vse16.v  v10, (t5);  addi t5, t5, 16
    vse16.v  v12, (t5);  addi t5, t5, 16
    vse16.v  v18, (t5);  addi t5, t5, 16
    vse16.v  v20, (t5)
    restore_regs
    addi sp, sp, 4*17
ret

.macro shuffle4 out0, out1, in0, in1, vt0, vt1
    vrgather.vv \out1, \in0, \vt0
    vrgather.vv \out0, \in1, \vt1
    vmerge.vvm \out1, \in1, \out1, v0
    vmerge.vvm \out0, \out0, \in0, v0
.endm

// in0 = [a0~a1,a2~a3,a8~a9,a10~a11], in1 = [a4~a5,a6~a7,a12~a13,a14~a15]
// out0= [a0~a1,a4~a5,a8~a9,a12~a13], out1= [a2~a3,a6~a7,a10~a11,a14~a15]
// related masks are ready for using
// v0: _MASK_11001100, vmt0/vmt1: _MASK_00010045/_MASK_23006700
.macro shuffle2 out0, out1, in0, in1, vmt0, vmt1
    vrgather.vv \out0, \in1, \vmt0
    vmerge.vvm  \out0, \out0, \in0, v0
    vrgather.vv \out1, \in0, \vmt1
    vmerge.vvm  \out1, \in1, \out1, v0
.endm

// in0/1 = [a0~a1,a4~a5,a8~a9,a12~a13], [a2~a3,a6~a7,a10~a11,a14~a15]
// out0/1= [a0,a2,a4,a6,a8,a10,a12,a14],[a1,a3,a5,a7,a9,a11,a13,a15]
// related masks are ready for using
// v0: _MASK_10101010, vmt0: _MASK_10325476
.macro shuffle1 out0, out1, in0, in1, vmt0
    vrgather.vv \out0, \in1, \vmt0
    vrgather.vv \out1, \in0, \vmt0
    vmerge.vvm  \out0, \out0, \in0, v0
    vmerge.vvm  \out1, \in1, \out1, v0
.endm

.globl ntt2normal_order
.align 2
ntt2normal_order:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    // for vrgather
    addi t4, a2, _MASK_45674567*2
    vle16.v v31, (t4)
    addi t4, a2, _MASK_01230123*2
    vle16.v v30, (t4)
    addi t4, a2, _MASK_00010045*2
    vle16.v v29, (t4)
    addi t4, a2, _MASK_23006700*2
    vle16.v v28, (t4)
    addi t4, a2, _MASK_10325476*2
    vle16.v v27, (t4)
    // for vmerge
    addi t4, a2, _MASK_11110000*2
    vle16.v v26, (t4)   # for shuffle4
    addi t4, a2, _MASK_11001100*2
    vle16.v v25, (t4)   # for shuffle2
    addi t4, a2, _MASK_10101010*2
    vle16.v v24, (t4)   # for shuffle1
    li a2, 4
ntt2normal_order_loop:
    vle16.v v1, (a1);       addi a1, a1, 16
    vle16.v v2, (a1);       addi a1, a1, 16
    vle16.v v3, (a1);       addi a1, a1, 16
    vle16.v v4, (a1);       addi a1, a1, 16
    vmv.v.v v0, v24
    shuffle1 v9,  v10, v1, v2, v27
    shuffle1 v11, v12, v3, v4, v27
    vle16.v v5, (a1);       addi a1, a1, 16
    vle16.v v6, (a1);       addi a1, a1, 16
    vle16.v v7, (a1);       addi a1, a1, 16
    vle16.v v8, (a1);       addi a1, a1, 16
    shuffle1 v13, v14, v5, v6, v27
    shuffle1 v15, v16, v7, v8, v27
    vmv.v.v v0, v25
    shuffle2 v1, v2, v9,  v10, v29, v28
    shuffle2 v3, v4, v11, v12, v29, v28
    vmv.v.v v0, v26
    shuffle4 v9,  v10, v1, v2, v31, v30
    shuffle4 v11, v12, v3, v4, v31, v30
    vse16.v v9,  (a0);       addi a0, a0, 16
    vse16.v v10, (a0);       addi a0, a0, 16
    vse16.v v11, (a0);       addi a0, a0, 16
    vse16.v v12, (a0);       addi a0, a0, 16
    vmv.v.v v0, v25
    shuffle2 v5, v6, v13, v14, v29, v28
    shuffle2 v7, v8, v15, v16, v29, v28
    vmv.v.v v0, v26
    shuffle4 v13,v14,v5,  v6,  v31, v30
    shuffle4 v15,v16,v7,  v8,  v31, v30
    vse16.v v13, (a0);       addi a0, a0, 16
    vse16.v v14, (a0);       addi a0, a0, 16
    vse16.v v15, (a0);       addi a0, a0, 16
    vse16.v v16, (a0);       addi a0, a0, 16
    addi a2, a2, -1
    bnez a2, ntt2normal_order_loop
ret

.macro ntt_rvv_level1to6 off
    lw   t5, 4*15(sp);  addi t5, t5, (64+\off*128)*2
    vle16.v v9,  (t5);  addi t5, t5, 16
    vle16.v v10, (t5);  addi t5, t5, 16
    vle16.v v11, (t5);  addi t5, t5, 16
    vle16.v v12, (t5);  addi t5, t5, 16
    vle16.v v13, (t5);  addi t5, t5, 16
    vle16.v v14, (t5);  addi t5, t5, 16
    vle16.v v15, (t5);  addi t5, t5, 16
    vle16.v v16, (t5);  addi t5, t5, -16*7-(64+\off*128)*2+(\off*128)*2
    vle16.v v1,  (t5);  addi t5, t5, 16
    vle16.v v2,  (t5);  addi t5, t5, 16
    vle16.v v3,  (t5);  addi t5, t5, 16
    vle16.v v4,  (t5);  addi t5, t5, 16
    vle16.v v5,  (t5);  addi t5, t5, 16
    vle16.v v6,  (t5);  addi t5, t5, 16
    vle16.v v7,  (t5);  addi t5, t5, 16
    vle16.v v8,  (t5)
    lw t6, 4*16(sp)
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L1 + \off*_ZETAS_EXP_1TO6_P1_L1)*2(t6)
    lh t6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L1 + \off*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(t6)
    vmul.vx v17, v9,  t5
    vmul.vx v18, v10, t5
    vmul.vx v19, v11, t5
    vmul.vx v20, v12, t5
    vmul.vx v21, v13, t5
    vmul.vx v22, v14, t5
    vmul.vx v23, v15, t5
    vmul.vx v24, v16, t5
    vmulh.vx v9,  v9,  t6
    vmulh.vx v10, v10, t6
    vmulh.vx v11, v11, t6
    vmulh.vx v12, v12, t6
    vmulh.vx v13, v13, t6
    vmulh.vx v14, v14, t6
    vmulh.vx v15, v15, t6
    vmulh.vx v16, v16, t6
    vmulh.vx v21, v21, t4
    vmulh.vx v22, v22, t4
    vmulh.vx v23, v23, t4
    vmulh.vx v24, v24, t4
    vsub.vv  v13, v13, v21
    vsub.vv  v14, v14, v22
    vsub.vv  v15, v15, v23
    vsub.vv  v16, v16, v24
    vmulh.vx v17, v17, t4
    vsub.vv  v21, v5, v13
    vmulh.vx v18, v18, t4
    vsub.vv  v22, v6, v14
    vmulh.vx v19, v19, t4
    vsub.vv  v23, v7, v15
    vmulh.vx v20, v20, t4
    vsub.vv  v24, v8, v16
    vsub.vv  v9,  v9,  v17
    vsub.vv  v10, v10, v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    vsub.vv  v17, v1, v9
    vsub.vv  v18, v2, v10
    vsub.vv  v19, v3, v11
    vsub.vv  v20, v4, v12
    vadd.vv  v13, v5, v13
    vadd.vv  v14, v6, v14
    vadd.vv  v15, v7, v15
    vadd.vv  v16, v8, v16
    vadd.vv  v9, v1, v9
    vadd.vv  v10, v2, v10
    vadd.vv  v11, v3, v11
    vadd.vv  v12, v4, v12
    lw t6, 4*16(sp)
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2)*2(t6)
    vmul.vx v1, v13, t5
    vmul.vx v2, v14, t5
    vmul.vx v3, v15, t5
    vmul.vx v4, v16, t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(t6)
    vmul.vx v5, v21, t5
    vmul.vx v6, v22, t5
    vmul.vx v7, v23, t5
    vmul.vx v8, v24, t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(t6)
    vmulh.vx v13, v13, t5
    vmulh.vx v14, v14, t5
    vmulh.vx v15, v15, t5
    vmulh.vx v16, v16, t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(t6)
    vmulh.vx v21, v21, t5
    vmulh.vx v22, v22, t5
    vmulh.vx v23, v23, t5
    vmulh.vx v24, v24, t5
    vmulh.vx v1, v1, t4
    vmulh.vx v2, v2, t4
    vmulh.vx v3, v3, t4
    vmulh.vx v4, v4, t4
    vsub.vv  v13, v13, v1
    vsub.vv  v14, v14, v2
    vsub.vv  v15, v15, v3
    vsub.vv  v16, v16, v4
    vmulh.vx v5, v5, t4
    vadd.vv  v1, v9,  v13
    vmulh.vx v6, v6, t4
    vadd.vv  v2, v10, v14
    vmulh.vx v7, v7, t4
    vadd.vv  v3, v11, v15
    vmulh.vx v8, v8, t4
    vadd.vv  v4, v12, v16
    vsub.vv  v21, v21, v5
    vsub.vv  v22, v22, v6
    vsub.vv  v23, v23, v7
    vsub.vv  v24, v24, v8
    vadd.vv  v5, v17, v21
    vadd.vv  v6, v18, v22
    vadd.vv  v7, v19, v23
    vadd.vv  v8, v20, v24
    vsub.vv  v9, v9,  v13
    vsub.vv  v10, v10,v14
    vsub.vv  v11,v11, v15
    vsub.vv  v12,v12, v16
    vsub.vv  v13,v17, v21
    vsub.vv  v14,v18, v22
    vsub.vv  v15,v19, v23
    vsub.vv  v16,v20, v24
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(t6)
    vmul.vx v17, v3,  t5
    vmul.vx v18, v4,  t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(t6)
    vmul.vx v19, v11, t5
    vmul.vx v20, v12, t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(t6)
    vmul.vx v21, v7,  t5
    vmul.vx v22, v8,  t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(t6)
    vmul.vx v23, v15, t5
    vmul.vx v24, v16, t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(t6)
    vmulh.vx v3,  v3,  t5
    vmulh.vx v4,  v4,  t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(t6)
    vmulh.vx v11, v11, t5
    vmulh.vx v12, v12, t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(t6)
    vmulh.vx v7,  v7,  t5
    vmulh.vx v8,  v8,  t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(t6)
    vmulh.vx v15, v15, t5
    vmulh.vx v16, v16, t5
    vmulh.vx v17, v17, t4
    vmulh.vx v18, v18, t4
    vmulh.vx v19, v19, t4
    vmulh.vx v20, v20, t4
    vsub.vv  v3,  v3,  v17
    vsub.vv  v4,  v4,  v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    vmulh.vx v21, v21, t4
    vadd.vv  v17, v1,  v3
    vmulh.vx v22, v22, t4
    vadd.vv  v18, v2,  v4
    vmulh.vx v23, v23, t4
    vadd.vv  v19, v9,  v11
    vmulh.vx v24, v24, t4
    vadd.vv  v20, v10, v12
    vsub.vv  v7,  v7,  v21
    vsub.vv  v8,  v8,  v22
    vsub.vv  v15, v15, v23
    vsub.vv  v16, v16, v24
    vadd.vv  v21, v5,  v7
    vadd.vv  v22, v6,  v8
    vadd.vv  v23, v13, v15
    vadd.vv  v24, v14, v16
    vsub.vv  v1,  v1,  v3
    vsub.vv  v2,  v2,  v4
    vsub.vv  v3,  v9,  v11
    vsub.vv  v4,  v10, v12
    vsub.vv  v5,  v5,  v7
    vsub.vv  v6,  v6,  v8
    vsub.vv  v7,  v13, v15
    vsub.vv  v8,  v14, v16
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(t6)
    vmul.vx v9,  v18,  t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(t6)
    vmulh.vx v18, v18, t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(t6)
    vmul.vx v10, v2,   t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(t6)
    vmulh.vx v2,  v2,  t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(t6)
    vmul.vx v11, v20,  t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(t6)
    vmulh.vx v20, v20, t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(t6)
    vmul.vx v12, v4,   t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(t6)
    vmulh.vx v4,  v4,  t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(t6)
    vmul.vx v13, v22,  t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(t6)
    vmulh.vx v22, v22, t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +10)*2(t6)
    vmul.vx v14, v6,   t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +11)*2(t6)
    vmulh.vx v6,  v6,  t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +12)*2(t6)
    vmul.vx v15, v24,  t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +13)*2(t6)
    vmulh.vx v24, v24, t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +14)*2(t6)
    vmul.vx v16, v8,   t5
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +15)*2(t6)
    vmulh.vx v8,  v8,  t5
    vmulh.vx v9,  v9,  t4
    vmulh.vx v10, v10, t4
    vmulh.vx v11, v11, t4
    vmulh.vx v12, v12, t4
    vsub.vv  v18, v18, v9
    vsub.vv  v2,  v2,  v10
    vsub.vv  v20, v20, v11
    vsub.vv  v4,  v4,  v12
    vmulh.vx v13, v13, t4
    vadd.vv  v9,  v17, v18
    vmulh.vx v14, v14, t4
    vadd.vv  v10, v1,  v2
    vmulh.vx v15, v15, t4
    vadd.vv  v11, v19, v20
    vmulh.vx v16, v16, t4
    vadd.vv  v12, v3, v4
    addi t5, t6, _MASK_11110000*2;  vle16.v v0, (t5)
    vsub.vv  v22, v22, v13
    vsub.vv  v6,  v6,  v14
    vsub.vv  v24, v24, v15
    vsub.vv  v8,  v8,  v16
    vsub.vv  v17, v17, v18
    vsub.vv  v18, v1,  v2
    vsub.vv  v19, v19, v20
    vsub.vv  v20, v3,  v4
    vadd.vv  v13, v21,  v22
    vadd.vv  v14, v5,  v6
    vadd.vv  v15, v23, v24
    vrgather.vv v2, v9, v31
    vrgather.vv v1, v17, v30
    vmerge.vvm v2, v17, v2, v0
    vmerge.vvm v1, v1, v9, v0
    vadd.vv  v16, v7, v8
    vrgather.vv v4, v10, v31
    vrgather.vv v3, v18, v30
    vmerge.vvm v4, v18, v4, v0
    vmerge.vvm v3, v3, v10, v0
    vsub.vv  v21, v21, v22
    vsub.vv  v22, v5,  v6
    vsub.vv  v23, v23, v24
    vsub.vv  v24, v7,  v8
    addi t6, t6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L5 + \off*_ZETAS_EXP_1TO6_P1_L5)*2
    vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v9,  v2,  v27
    vmulh.vv v2,  v2,  v26
    vrgather.vv v6, v11, v31
    vrgather.vv v5, v19, v30
    vmerge.vvm v6, v19, v6, v0
    vmerge.vvm v5, v5, v11, v0
    vrgather.vv v8, v12, v31
    vrgather.vv v7, v20, v30
    vmerge.vvm v8, v20, v8, v0
    vmerge.vvm v7, v7, v12, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v17, v4,  v27
    vmulh.vv v4,  v4,  v26
    vmulh.vx v9,  v9,  t4
    vmulh.vx v17, v17, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v10, v6,  v27
    vmulh.vv v6,  v6,  v26
    vsub.vv  v2,  v2,  v9
    vmulh.vx v10, v10, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v18, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v18, v18, t4
    vsub.vv  v4,  v4,  v17
    vsub.vv  v6,  v6,  v10
    vsub.vv  v8,  v8,  v18
    vadd.vv  v9,  v1,  v2
    vsub.vv  v11, v1,  v2
    vadd.vv  v17, v3,  v4
    vsub.vv  v19, v3,  v4
    vadd.vv  v10, v5,  v6
    vsub.vv  v12, v5,  v6
    vrgather.vv v2, v13, v31
    vrgather.vv v1, v21, v30
    vmerge.vvm v2, v21, v2, v0
    vmerge.vvm v1, v1, v13, v0
    vrgather.vv v4, v14, v31
    vrgather.vv v3, v22, v30
    vmerge.vvm v4, v22, v4, v0
    vmerge.vvm v3, v3, v14, v0
    vadd.vv  v18, v7,  v8
    vsub.vv  v20, v7,  v8
    vrgather.vv v6, v15, v31
    vrgather.vv v5, v23, v30
    vmerge.vvm v6, v23, v6, v0
    vmerge.vvm v5, v5, v15, v0
    vrgather.vv v8, v16, v31
    vrgather.vv v7, v24, v30
    vmerge.vvm v8, v24, v8, v0
    vmerge.vvm v7, v7, v16, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v13, v2,  v27
    vmulh.vv v2,  v2,  v26
    vmulh.vx v13, v13, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v21, v4,  v27
    vmulh.vv v4,  v4,  v26
    vmulh.vx v21, v21, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v14, v6,  v27
    vmulh.vv v6,  v6,  v26
    vmulh.vx v14, v14, t4
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v22, v8,  v27
    vmulh.vv v8,  v8,  v26
    vsub.vv  v2,  v2, v13
    vsub.vv  v4,  v4, v21
    vmulh.vx v22, v22, t4
    vsub.vv  v6,  v6, v14
    vsub.vv  v8,  v8, v22
    lw t6, 4*16(sp)
    addi t5, t6, _MASK_11001100*2;  vle16.v v0, (t5)
    vadd.vv  v13, v1,  v2
    vsub.vv  v15, v1,  v2
    vadd.vv  v21, v3,  v4
    vsub.vv  v23, v3,  v4
    vadd.vv  v14, v5,  v6
    vsub.vv  v16, v5,  v6
    vrgather.vv v1, v11, v29
    vmerge.vvm  v1, v1, v9, v0
    vrgather.vv v2, v9, v28
    vmerge.vvm  v2, v11, v2, v0
    vadd.vv  v22, v7,  v8
    vsub.vv  v24, v7,  v8
    vrgather.vv v3, v19, v29
    vmerge.vvm  v3, v3, v17, v0
    vrgather.vv v4, v17, v28
    vmerge.vvm  v4, v19, v4, v0
    addi t6, t6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L6+ \off*_ZETAS_EXP_1TO6_P1_L6)*2
    vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v9,  v2,  v27
    vmulh.vv v2,  v2,  v26
    vrgather.vv v5, v12, v29
    vmerge.vvm  v5, v5, v10, v0
    vrgather.vv v6, v10, v28
    vmerge.vvm  v6, v12, v6, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v11, v4,  v27
    vmulh.vv v4,  v4,  v26
    vrgather.vv v7, v20, v29
    vmerge.vvm  v7, v7, v18, v0
    vrgather.vv v8, v18, v28
    vmerge.vvm  v8, v20, v8, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v17, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v19, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v9,  v9,  t4
    vmulh.vx v11, v11, t4
    vmulh.vx v17, v17, t4
    vmulh.vx v19, v19, t4
    vsub.vv  v2,  v2,  v9
    vsub.vv  v4,  v4,  v11
    vsub.vv  v6,  v6,  v17
    vsub.vv  v8,  v8,  v19
    vadd.vv  v9,  v1,  v2
    vsub.vv  v11, v1,  v2
    vadd.vv  v17, v3,  v4
    vsub.vv  v19, v3,  v4
    vrgather.vv v1, v15, v29
    vmerge.vvm  v1, v1, v13, v0
    vrgather.vv v2, v13, v28
    vmerge.vvm  v2, v15, v2, v0
    vadd.vv  v10, v5,  v6
    vsub.vv  v12, v5,  v6
    vadd.vv  v18, v7,  v8
    vsub.vv  v20, v7,  v8
    vrgather.vv v3, v23, v29
    vmerge.vvm  v3, v3, v21, v0
    vrgather.vv v4, v21, v28
    vmerge.vvm  v4, v23, v4, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v13, v2,  v27
    vmulh.vv v2,  v2,  v26
    vrgather.vv v5, v16, v29
    vmerge.vvm  v5, v5, v14, v0
    vrgather.vv v6, v14, v28
    vmerge.vvm  v6, v16, v6, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v15, v4,  v27
    vmulh.vv v4,  v4,  v26
    vrgather.vv v7, v24, v29
    vmerge.vvm  v7, v7, v22, v0
    vrgather.vv v8, v22, v28
    vmerge.vvm  v8, v24, v8, v0
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v21, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t6, t6, 8*2;     vle16.v v27, (t6)
    addi t6, t6, 8*2;     vle16.v v26, (t6)
    vmul.vv  v23, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v13, v13, t4
    vmulh.vx v15, v15, t4
    vmulh.vx v21, v21, t4
    vmulh.vx v23, v23, t4
    vsub.vv  v2,  v2,  v13
    vsub.vv  v4,  v4,  v15
    vsub.vv  v6,  v6,  v21
    vsub.vv  v8,  v8,  v23
    vadd.vv  v13, v1,  v2
    vsub.vv  v15, v1,  v2
    lw t6, 4*16(sp)
    addi t5, t6, _MASK_10101010*2;      vle16.v v0, (t5)
    addi t5, t6, _MASK_10325476*2;      vle16.v v27, (t5)
    vadd.vv  v21, v3,  v4
    vsub.vv  v23, v3,  v4
    vrgather.vv v1, v11, v27
    vrgather.vv v2, v9, v27
    vmerge.vvm  v1, v1, v9, v0
    vmerge.vvm  v2, v11, v2, v0
    vadd.vv  v14, v5,  v6
    vsub.vv  v16, v5,  v6
    vrgather.vv v3, v19, v27
    vrgather.vv v4, v17, v27
    vmerge.vvm  v3, v3, v17, v0
    vmerge.vvm  v4, v19, v4, v0
    vadd.vv  v22, v7,  v8
    vsub.vv  v24, v7,  v8
    vrgather.vv v5, v12, v27
    vrgather.vv v6, v10, v27
    vmerge.vvm  v5, v5, v10, v0
    vmerge.vvm  v6, v12, v6, v0
    vrgather.vv v7, v20, v27
    vrgather.vv v8, v18, v27
    vmerge.vvm  v7, v7, v18, v0
    vmerge.vvm  v8, v20, v8, v0
    vrgather.vv v9, v15, v27
    vrgather.vv v11, v13, v27
    vmerge.vvm  v9, v9, v13, v0
    vmerge.vvm  v11, v15, v11, v0
    vrgather.vv v17, v23, v27
    vrgather.vv v19, v21, v27
    vmerge.vvm  v17, v17, v21, v0
    vmerge.vvm  v19, v23, v19, v0
    vrgather.vv v10, v16, v27
    vrgather.vv v12, v14, v27
    vmerge.vvm  v10, v10, v14, v0
    vmerge.vvm  v12, v16, v12, v0
    vrgather.vv v18, v24, v27
    vrgather.vv v20, v22, v27
    vmerge.vvm  v18, v18, v22, v0
    vmerge.vvm  v20, v24, v20, v0
    lw   t5, 4*15(sp);   addi t5, t5, (\off*128)*2
    vse16.v  v1,  (t5);  addi t5, t5, 16
    vse16.v  v2,  (t5);  addi t5, t5, 16
    vse16.v  v3,  (t5);  addi t5, t5, 16
    vse16.v  v4,  (t5);  addi t5, t5, 16
    vse16.v  v5,  (t5);  addi t5, t5, 16
    vse16.v  v6,  (t5);  addi t5, t5, 16
    vse16.v  v7,  (t5);  addi t5, t5, 16
    vse16.v  v8,  (t5);  addi t5, t5, -16*7-(\off*128)*2+(64+\off*128)*2
    vse16.v  v9,  (t5);  addi t5, t5, 16
    vse16.v  v11, (t5);  addi t5, t5, 16
    vse16.v  v17, (t5);  addi t5, t5, 16
    vse16.v  v19, (t5);  addi t5, t5, 16
    vse16.v  v10, (t5);  addi t5, t5, 16
    vse16.v  v12, (t5);  addi t5, t5, 16
    vse16.v  v18, (t5);  addi t5, t5, 16
    vse16.v  v20, (t5)
.endm