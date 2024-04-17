#include "consts.h"

.macro SaveRegs
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

.macro RestoreRegs
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

.globl test_vector_scalar_hybrid_1_0
.align 2
test_vector_scalar_hybrid_1_0:
    addi sp, sp, -8*18
    SaveRegs
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329

    lh t2, (_ZETAS_EXP+0)*2(a1)
    addi a0, a0, (64*0+128)*2
    lh t1, (_ZETAS_EXP+1)*2(a1)
    vle16.v v8, (a0);   addi a0, a0, 16
    vle16.v v9, (a0);   addi a0, a0, 16
    vle16.v v10, (a0);  addi a0, a0, 16
    vle16.v v11, (a0);  addi a0, a0, 16
    vmul.vx v0, v8, t2
    vmul.vx v1, v9, t2
    vmul.vx v2, v10, t2
    vmul.vx v3, v11, t2
    vle16.v v12, (a0);  addi a0, a0, 16
    vle16.v v13, (a0);  addi a0, a0, 16
    vle16.v v14, (a0);  addi a0, a0, 16
    vle16.v v15, (a0);  addi a0, a0, -((64*0+128)*2+16*7)
    vmul.vx v4, v12, t2
    vmul.vx v5, v13, t2
    vmul.vx v6, v14, t2
    vmul.vx v7, v15, t2
    vle16.v v16, (a0);  addi a0, a0, 16
    vle16.v v17, (a0);  addi a0, a0, 16
    vle16.v v18, (a0);  addi a0, a0, 16
    vle16.v v19, (a0);  addi a0, a0, 16
    vmulh.vx v8,  v8, t1
    vmulh.vx v9,  v9, t1
    vmulh.vx v10, v10, t1
    vmulh.vx v11, v11, t1
    vle16.v v20, (a0);  addi a0, a0, 16
    vle16.v v21, (a0);  addi a0, a0, 16
    vle16.v v22, (a0);  addi a0, a0, 16
    vle16.v v23, (a0);  addi a0, a0, -16*7
    vmulh.vx v12, v12, t1
    vmulh.vx v13, v13, t1
    vmulh.vx v14, v14, t1
    vmulh.vx v15, v15, t1
    vmulh.vx v0, v0, t0
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vsub.vv  v8,  v8,  v0
    vsub.vv  v9,  v9,  v1
    vsub.vv  v10, v10, v2
    vsub.vv  v11, v11, v3
    vmulh.vx v4, v4, t0
    vmulh.vx v5, v5, t0
    vmulh.vx v6, v6, t0
    vmulh.vx v7, v7, t0
    vadd.vv  v0, v16, v8
    vadd.vv  v1, v17, v9
    vadd.vv  v2, v18, v10
    vadd.vv  v3, v19, v11
    vse16.v  v0, (a0);  addi a0, a0, 16
    vse16.v  v1, (a0);  addi a0, a0, 16
    vse16.v  v2, (a0);  addi a0, a0, 16
    vse16.v  v3, (a0);  addi a0, a0, 16
    vsub.vv  v12, v12, v4
    vsub.vv  v13, v13, v5
    vsub.vv  v14, v14, v6
    vsub.vv  v15, v15, v7
    vadd.vv  v4, v20, v12
    vadd.vv  v5, v21, v13
    vadd.vv  v6, v22, v14
    vadd.vv  v7, v23, v15
    vse16.v  v4, (a0);  addi a0, a0, 16
    vse16.v  v5, (a0);  addi a0, a0, 16
    vse16.v  v6, (a0);  addi a0, a0, 16
    vse16.v  v7, (a0);  addi a0, a0, (64*0+128)*2-16*7 // a[128]
    vsub.vv  v8, v16, v8
    vsub.vv  v9, v17, v9
    vsub.vv  v10, v18, v10
    vsub.vv  v11, v19, v11
    vse16.v  v8,  (a0);  addi a0, a0, 16
    vse16.v  v9,  (a0);  addi a0, a0, 16
    vse16.v  v10, (a0);  addi a0, a0, 16
    vse16.v  v11, (a0);  addi a0, a0, 16
    vsub.vv  v12, v20, v12
    vsub.vv  v13, v21, v13
    vsub.vv  v14, v22, v14
    vsub.vv  v15, v23, v15
    vse16.v  v12, (a0);  addi a0, a0, 16
    vse16.v  v13, (a0);  addi a0, a0, 16
    vse16.v  v14, (a0);  addi a0, a0, 16
    vse16.v  v15, (a0);  addi a0, a0, 16 // a[192]
    vle16.v  v24, (a0);  addi a0, a0, 16
    vle16.v  v25, (a0);  addi a0, a0, 16
    vle16.v  v26, (a0);  addi a0, a0, 16
    vle16.v  v27, (a0);  addi a0, a0, 16
    vmul.vx v0, v24, t2
    vmul.vx v1, v25, t2
    vmul.vx v2, v26, t2
    vmul.vx v3, v27, t2
    vle16.v  v28, (a0);  addi a0, a0, 16
    vle16.v  v29, (a0);  addi a0, a0, 16
    vle16.v  v30, (a0);  addi a0, a0, 16
    vle16.v  v31, (a0);  addi a0, a0, -(128*2)-16*7 // a[64]
    vmul.vx v4, v28, t2
    vmul.vx v5, v29, t2
    vmul.vx v6, v30, t2
    vmul.vx v7, v31, t2
    vle16.v  v16, (a0);  addi a0, a0, 16
    vle16.v  v17, (a0);  addi a0, a0, 16
    vle16.v  v18, (a0);  addi a0, a0, 16
    vle16.v  v19, (a0);  addi a0, a0, 16
    vmulh.vx v24, v24, t1
    vmulh.vx v25, v25, t1
    vmulh.vx v26, v26, t1
    vmulh.vx v27, v27, t1
    vle16.v  v20, (a0);  addi a0, a0, 16
    vle16.v  v21, (a0);  addi a0, a0, 16
    vle16.v  v22, (a0);  addi a0, a0, 16
    vle16.v  v23, (a0);  addi a0, a0, -16*7 // a[64]
    vmulh.vx v28, v28, t1
    vmulh.vx v29, v29, t1
    vmulh.vx v30, v30, t1
    vmulh.vx v31, v31, t1
    vmulh.vx v0, v0, t0
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vsub.vv  v24, v24, v0
    vsub.vv  v25, v25, v1
    vsub.vv  v26, v26, v2
    vsub.vv  v27, v27, v3
    vmulh.vx v4, v4, t0
    vmulh.vx v5, v5, t0
    vmulh.vx v6, v6, t0
    vmulh.vx v7, v7, t0
    vadd.vv  v0, v16, v24
    vadd.vv  v1, v17, v25
    vadd.vv  v2, v18, v26
    vadd.vv  v3, v19, v27
    vse16.v  v0, (a0);  addi a0, a0, 16
    vse16.v  v1, (a0);  addi a0, a0, 16
    vse16.v  v2, (a0);  addi a0, a0, 16
    vse16.v  v3, (a0);  addi a0, a0, 16
    vsub.vv  v28, v28, v4
    vsub.vv  v29, v29, v5
    vsub.vv  v30, v30, v6
    vsub.vv  v31, v31, v7
    vadd.vv  v4, v20, v28
    vadd.vv  v5, v21, v29
    vadd.vv  v6, v22, v30
    vadd.vv  v7, v23, v31
    vse16.v  v4, (a0);  addi a0, a0, 16
    vse16.v  v5, (a0);  addi a0, a0, 16
    vse16.v  v6, (a0);  addi a0, a0, 16
    vse16.v  v7, (a0);  addi a0, a0, -16*7+128*2 // a[192]
    vsub.vv  v24, v16, v24
    vsub.vv  v25, v17, v25
    vsub.vv  v26, v18, v26
    vsub.vv  v27, v19, v27
    vse16.v  v24, (a0);  addi a0, a0, 16
    vse16.v  v25, (a0);  addi a0, a0, 16
    vse16.v  v26, (a0);  addi a0, a0, 16
    vse16.v  v27, (a0);  addi a0, a0, 16
    vsub.vv  v28, v20, v28
    vsub.vv  v29, v21, v29
    vsub.vv  v30, v22, v30
    vsub.vv  v31, v23, v31
    vse16.v  v28, (a0);  addi a0, a0, 16
    vse16.v  v29, (a0);  addi a0, a0, 16
    vse16.v  v30, (a0);  addi a0, a0, 16
    vse16.v  v31, (a0);  addi a0, a0, -16*7-192*2 // a[0]
    RestoreRegs
    addi sp, sp, 8*18
ret

.globl test_vector_scalar_hybrid_3_8
.align 2
test_vector_scalar_hybrid_3_8:
    addi sp, sp, -8*18
    SaveRegs
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329

    lh t2, (_ZETAS_EXP+0)*2(a1)
    addi a0, a0, (64*0+128)*2
    lh t1, (_ZETAS_EXP+1)*2(a1)
    vle16.v v8, (a0);   addi a0, a0, 16
    vle16.v v9, (a0);   addi a0, a0, 16
    vle16.v v10, (a0);  addi a0, a0, 16
    # vle16.v v11, (a0);  addi a0, a0, 16
    lh t3, 0(a0); lh t4, 2(a0); lh t5, 4(a0); lh t6, 6(a0)
    lh a2, 8(a0); lh a3, 10(a0);lh a4,12(a0); lh a5,14(a0)
    addi a0, a0, 16
    vmul.vx v0, v8, t2
    mul s0, t3, t2
    vmul.vx v1, v9, t2
    mul s1, t4, t2
    vmul.vx v2, v10, t2
    # vmul.vx v3, v11, t2
    mul s2, t5, t2
    vle16.v v12, (a0);  addi a0, a0, 16
    mul s3, t6, t2
    vle16.v v13, (a0);  addi a0, a0, 16
    mul s4, a2, t2
    vle16.v v14, (a0);  addi a0, a0, 16
    # vle16.v v15, (a0);  addi a0, a0, -((64*0+128)*2+16*7)
    lh t3, 0(a0); lh t4, 2(a0); lh t5, 4(a0); lh t6, 6(a0)
    mul s5, a3, t2
    lh a2, 8(a0); lh a3, 10(a0);lh a4,12(a0); lh a5,14(a0)
    mul s6, a4, t2
    addi a0, a0, -((64*0+128)*2+16*7)
    mul s7, a5, t2
    vmul.vx v4, v12, t2
    mul s0, t3, t2
    vmul.vx v5, v13, t2
    mul s1, t4, t2
    vmul.vx v6, v14, t2
    # vmul.vx v7, v15, t2
    mul s2, t5, t2
    vle16.v v16, (a0);  addi a0, a0, 16
    mul s3, t6, t2
    vle16.v v17, (a0);  addi a0, a0, 16
    mul s4, a2, t2
    vle16.v v18, (a0);  addi a0, a0, 16
    mul s5, a3, t2
    mul s6, a4, t2
    mul s7, a5, t2
    vle16.v v19, (a0);  addi a0, a0, 16
    vmulh.vx v8,  v8, t1
    vmulh.vx v9,  v9, t1
    vmulh.vx v10, v10, t1
    vmulh.vx v11, v11, t1
    vle16.v v20, (a0);  addi a0, a0, 16
    vle16.v v21, (a0);  addi a0, a0, 16
    vle16.v v22, (a0);  addi a0, a0, 16
    vle16.v v23, (a0);  addi a0, a0, -16*7
    vmulh.vx v12, v12, t1
    vmulh.vx v13, v13, t1
    vmulh.vx v14, v14, t1
    vmulh.vx v15, v15, t1
    vmulh.vx v0, v0, t0
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vsub.vv  v8,  v8,  v0
    vsub.vv  v9,  v9,  v1
    vsub.vv  v10, v10, v2
    vsub.vv  v11, v11, v3
    vmulh.vx v4, v4, t0
    vmulh.vx v5, v5, t0
    vmulh.vx v6, v6, t0
    vmulh.vx v7, v7, t0
    vadd.vv  v0, v16, v8
    vadd.vv  v1, v17, v9
    vadd.vv  v2, v18, v10
    vadd.vv  v3, v19, v11
    vse16.v  v0, (a0);  addi a0, a0, 16
    vse16.v  v1, (a0);  addi a0, a0, 16
    vse16.v  v2, (a0);  addi a0, a0, 16
    vse16.v  v3, (a0);  addi a0, a0, 16
    vsub.vv  v12, v12, v4
    vsub.vv  v13, v13, v5
    vsub.vv  v14, v14, v6
    vsub.vv  v15, v15, v7
    vadd.vv  v4, v20, v12
    vadd.vv  v5, v21, v13
    vadd.vv  v6, v22, v14
    vadd.vv  v7, v23, v15
    vse16.v  v4, (a0);  addi a0, a0, 16
    vse16.v  v5, (a0);  addi a0, a0, 16
    vse16.v  v6, (a0);  addi a0, a0, 16
    vse16.v  v7, (a0);  addi a0, a0, (64*0+128)*2-16*7 // a[128]
    vsub.vv  v8, v16, v8
    vsub.vv  v9, v17, v9
    vsub.vv  v10, v18, v10
    vsub.vv  v11, v19, v11
    vse16.v  v8,  (a0);  addi a0, a0, 16
    vse16.v  v9,  (a0);  addi a0, a0, 16
    vse16.v  v10, (a0);  addi a0, a0, 16
    vse16.v  v11, (a0);  addi a0, a0, 16
    vsub.vv  v12, v20, v12
    vsub.vv  v13, v21, v13
    vsub.vv  v14, v22, v14
    vsub.vv  v15, v23, v15
    vse16.v  v12, (a0);  addi a0, a0, 16
    vse16.v  v13, (a0);  addi a0, a0, 16
    vse16.v  v14, (a0);  addi a0, a0, 16
    vse16.v  v15, (a0);  addi a0, a0, 16 // a[192]
    vle16.v  v24, (a0);  addi a0, a0, 16
    vle16.v  v25, (a0);  addi a0, a0, 16
    vle16.v  v26, (a0);  addi a0, a0, 16
    vle16.v  v27, (a0);  addi a0, a0, 16
    vmul.vx v0, v24, t2
    vmul.vx v1, v25, t2
    vmul.vx v2, v26, t2
    vmul.vx v3, v27, t2
    vle16.v  v28, (a0);  addi a0, a0, 16
    vle16.v  v29, (a0);  addi a0, a0, 16
    vle16.v  v30, (a0);  addi a0, a0, 16
    vle16.v  v31, (a0);  addi a0, a0, -(128*2)-16*7 // a[64]
    vmul.vx v4, v28, t2
    vmul.vx v5, v29, t2
    vmul.vx v6, v30, t2
    vmul.vx v7, v31, t2
    vle16.v  v16, (a0);  addi a0, a0, 16
    vle16.v  v17, (a0);  addi a0, a0, 16
    vle16.v  v18, (a0);  addi a0, a0, 16
    vle16.v  v19, (a0);  addi a0, a0, 16
    vmulh.vx v24, v24, t1
    vmulh.vx v25, v25, t1
    vmulh.vx v26, v26, t1
    vmulh.vx v27, v27, t1
    vle16.v  v20, (a0);  addi a0, a0, 16
    vle16.v  v21, (a0);  addi a0, a0, 16
    vle16.v  v22, (a0);  addi a0, a0, 16
    vle16.v  v23, (a0);  addi a0, a0, -16*7 // a[64]
    vmulh.vx v28, v28, t1
    vmulh.vx v29, v29, t1
    vmulh.vx v30, v30, t1
    vmulh.vx v31, v31, t1
    vmulh.vx v0, v0, t0
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vsub.vv  v24, v24, v0
    vsub.vv  v25, v25, v1
    vsub.vv  v26, v26, v2
    vsub.vv  v27, v27, v3
    vmulh.vx v4, v4, t0
    vmulh.vx v5, v5, t0
    vmulh.vx v6, v6, t0
    vmulh.vx v7, v7, t0
    vadd.vv  v0, v16, v24
    vadd.vv  v1, v17, v25
    vadd.vv  v2, v18, v26
    vadd.vv  v3, v19, v27
    vse16.v  v0, (a0);  addi a0, a0, 16
    vse16.v  v1, (a0);  addi a0, a0, 16
    vse16.v  v2, (a0);  addi a0, a0, 16
    vse16.v  v3, (a0);  addi a0, a0, 16
    vsub.vv  v28, v28, v4
    vsub.vv  v29, v29, v5
    vsub.vv  v30, v30, v6
    vsub.vv  v31, v31, v7
    vadd.vv  v4, v20, v28
    vadd.vv  v5, v21, v29
    vadd.vv  v6, v22, v30
    vadd.vv  v7, v23, v31
    vse16.v  v4, (a0);  addi a0, a0, 16
    vse16.v  v5, (a0);  addi a0, a0, 16
    vse16.v  v6, (a0);  addi a0, a0, 16
    vse16.v  v7, (a0);  addi a0, a0, -16*7+128*2 // a[192]
    vsub.vv  v24, v16, v24
    vsub.vv  v25, v17, v25
    vsub.vv  v26, v18, v26
    vsub.vv  v27, v19, v27
    vse16.v  v24, (a0);  addi a0, a0, 16
    vse16.v  v25, (a0);  addi a0, a0, 16
    vse16.v  v26, (a0);  addi a0, a0, 16
    vse16.v  v27, (a0);  addi a0, a0, 16
    vsub.vv  v28, v20, v28
    vsub.vv  v29, v21, v29
    vsub.vv  v30, v22, v30
    vsub.vv  v31, v23, v31
    vse16.v  v28, (a0);  addi a0, a0, 16
    vse16.v  v29, (a0);  addi a0, a0, 16
    vse16.v  v30, (a0);  addi a0, a0, 16
    vse16.v  v31, (a0);  addi a0, a0, -16*7-192*2 // a[0]
    RestoreRegs
    addi sp, sp, 8*18
ret

.globl test_vector_scalar_hybrid_7_1
.align 2
test_vector_scalar_hybrid_7_1:
    addi sp, sp, -8*18
    SaveRegs
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329
    lh t2, (_ZETAS_EXP+0)*2(a1)
    addi a0, a0, (64*0+128)*2
    lh t1, (_ZETAS_EXP+1)*2(a1)
    vle16.v v8, (a0);   addi a0, a0, 16
    vle16.v v9, (a0);   addi a0, a0, 16
    vle16.v v10, (a0);  addi a0, a0, 16
    vle16.v v11, (a0);  addi a0, a0, 16
    vmul.vx v0, v8,  t2
    mul s0, t3, t2
    vmul.vx v1, v9,  t2
    mul s1, t4, t2
    vmul.vx v2, v10, t2
    vle16.v v12, (a0);  addi a0, a0, 16
    mul s2, t5, t2
    vmul.vx v3, v11, t2
    vle16.v v13, (a0);  addi a0, a0, 16
    mul s3, t6, t2
    vmul.vx v4, v12, t2
    vle16.v v14, (a0);  addi a0, a0, 16
    # vle16.v v15, (a0);  addi a0, a0, -((64*0+128)*2+16*7)
    lh t3, 0(a0); lh t4, 2(a0)
    lh t5, 4(a0); lh t6, 6(a0)
    lh a2, 8(a0); lh a3, 10(a0)
    lh a4,12(a0); lh a5,14(a0)
    addi a0, a0, -((64*0+128)*2+16*7)
    mul s4, a2, t2
    vmul.vx v5, v13, t2
    mul s5, a3, t2
    vmul.vx v6, v14, t2
    mul s6, a4, t2
    mul s7, a5, t2
    vmulh.vx v8,  v8,  t1
    mulh s0, t3, t2
    vmulh.vx v9,  v9,  t1
    mulh s1, t4, t2
    vmulh.vx v10, v10, t1
    mulh s2, t5, t2
    vmulh.vx v11, v11, t1
    mulh s3, t6, t2
    vle16.v v16, (a0);  addi a0, a0, 16
    vmulh.vx v12, v12, t1
    mulh s4, a2, t2
    vle16.v v17, (a0);  addi a0, a0, 16
    vmulh.vx v13, v13, t1
    mulh s5, a3, t2
    vle16.v v18, (a0);  addi a0, a0, 16
    vmulh.vx v14, v14, t1
    mulh s6, a4, t2
    vle16.v v19, (a0);  addi a0, a0, 16
    mulh s7, a5, t2
    vle16.v v20, (a0);  addi a0, a0, 16
    vle16.v v21, (a0);  addi a0, a0, 16
    vle16.v v22, (a0);  addi a0, a0, 16
    vle16.v v23, (a0);  addi a0, a0, -16*7
    vmulh.vx v0, v0, t0
    mulh s0, t3, t2
    vmulh.vx v1, v1, t0
    mulh s1, t4, t2
    vmulh.vx v2, v2, t0
    mulh s2, t5, t2
    vmulh.vx v3, v3, t0
    mulh s3, t6, t2
    vmulh.vx v4, v4, t0
    mulh s4, a2, t2
    vmulh.vx v5, v5, t0
    mulh s5, a3, t2
    vmulh.vx v6, v6, t0
    mulh s6, a4, t2
    mulh s7, a5, t2
    # vmulh.vx v7, v7, t0
    vsub.vv  v8,  v8,  v0
    add s7, s7, a5
    vsub.vv  v9,  v9,  v1
    add s7, s7, a5
    vsub.vv  v10, v10, v2
    add s7, s7, a5
    vsub.vv  v11, v11, v3
    add s7, s7, a5
    vadd.vv  v0, v16, v8
    add s7, s7, a5
    vadd.vv  v1, v17, v9
    add s7, s7, a5
    vadd.vv  v2, v18, v10
    # vadd.vv  v3, v19, v11
    add s7, s7, a5
    add s7, s7, a5
    vse16.v  v0, (a0);  addi a0, a0, 16
    vse16.v  v1, (a0);  addi a0, a0, 16
    vse16.v  v2, (a0);  addi a0, a0, 16
    vse16.v  v3, (a0);  addi a0, a0, 16
    vsub.vv  v12, v12, v4
    vsub.vv  v13, v13, v5
    vsub.vv  v14, v14, v6
    vsub.vv  v15, v15, v7
    vadd.vv  v4, v20, v12
    vadd.vv  v5, v21, v13
    vadd.vv  v6, v22, v14
    vadd.vv  v7, v23, v15
    vse16.v  v4, (a0);  addi a0, a0, 16
    vse16.v  v5, (a0);  addi a0, a0, 16
    vse16.v  v6, (a0);  addi a0, a0, 16
    vse16.v  v7, (a0);  addi a0, a0, (64*0+128)*2-16*7 // a[128]
    vsub.vv  v8, v16, v8
    vsub.vv  v9, v17, v9
    vsub.vv  v10, v18, v10
    vsub.vv  v11, v19, v11
    vse16.v  v8,  (a0);  addi a0, a0, 16
    vse16.v  v9,  (a0);  addi a0, a0, 16
    vse16.v  v10, (a0);  addi a0, a0, 16
    vse16.v  v11, (a0);  addi a0, a0, 16
    vsub.vv  v12, v20, v12
    vsub.vv  v13, v21, v13
    vsub.vv  v14, v22, v14
    vsub.vv  v15, v23, v15
    vse16.v  v12, (a0);  addi a0, a0, 16
    vse16.v  v13, (a0);  addi a0, a0, 16
    vse16.v  v14, (a0);  addi a0, a0, 16
    vse16.v  v15, (a0);  addi a0, a0, 16 // a[192]
    vle16.v  v24, (a0);  addi a0, a0, 16
    vle16.v  v25, (a0);  addi a0, a0, 16
    vle16.v  v26, (a0);  addi a0, a0, 16
    vle16.v  v27, (a0);  addi a0, a0, 16
    vmul.vx v0, v24, t2
    vmul.vx v1, v25, t2
    vmul.vx v2, v26, t2
    vmul.vx v3, v27, t2
    vle16.v  v28, (a0);  addi a0, a0, 16
    vle16.v  v29, (a0);  addi a0, a0, 16
    vle16.v  v30, (a0);  addi a0, a0, 16
    vle16.v  v31, (a0);  addi a0, a0, -(128*2)-16*7 // a[64]
    vmul.vx v4, v28, t2
    vmul.vx v5, v29, t2
    vmul.vx v6, v30, t2
    vmul.vx v7, v31, t2
    vle16.v  v16, (a0);  addi a0, a0, 16
    vle16.v  v17, (a0);  addi a0, a0, 16
    vle16.v  v18, (a0);  addi a0, a0, 16
    vle16.v  v19, (a0);  addi a0, a0, 16
    vmulh.vx v24, v24, t1
    vmulh.vx v25, v25, t1
    vmulh.vx v26, v26, t1
    vmulh.vx v27, v27, t1
    vle16.v  v20, (a0);  addi a0, a0, 16
    vle16.v  v21, (a0);  addi a0, a0, 16
    vle16.v  v22, (a0);  addi a0, a0, 16
    vle16.v  v23, (a0);  addi a0, a0, -16*7 // a[64]
    vmulh.vx v28, v28, t1
    vmulh.vx v29, v29, t1
    vmulh.vx v30, v30, t1
    vmulh.vx v31, v31, t1
    vmulh.vx v0, v0, t0
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vsub.vv  v24, v24, v0
    vsub.vv  v25, v25, v1
    vsub.vv  v26, v26, v2
    vsub.vv  v27, v27, v3
    vmulh.vx v4, v4, t0
    vmulh.vx v5, v5, t0
    vmulh.vx v6, v6, t0
    vmulh.vx v7, v7, t0
    vadd.vv  v0, v16, v24
    vadd.vv  v1, v17, v25
    vadd.vv  v2, v18, v26
    vadd.vv  v3, v19, v27
    vse16.v  v0, (a0);  addi a0, a0, 16
    vse16.v  v1, (a0);  addi a0, a0, 16
    vse16.v  v2, (a0);  addi a0, a0, 16
    vse16.v  v3, (a0);  addi a0, a0, 16
    vsub.vv  v28, v28, v4
    vsub.vv  v29, v29, v5
    vsub.vv  v30, v30, v6
    vsub.vv  v31, v31, v7
    vadd.vv  v4, v20, v28
    vadd.vv  v5, v21, v29
    vadd.vv  v6, v22, v30
    vadd.vv  v7, v23, v31
    vse16.v  v4, (a0);  addi a0, a0, 16
    vse16.v  v5, (a0);  addi a0, a0, 16
    vse16.v  v6, (a0);  addi a0, a0, 16
    vse16.v  v7, (a0);  addi a0, a0, -16*7+128*2 // a[192]
    vsub.vv  v24, v16, v24
    vsub.vv  v25, v17, v25
    vsub.vv  v26, v18, v26
    vsub.vv  v27, v19, v27
    vse16.v  v24, (a0);  addi a0, a0, 16
    vse16.v  v25, (a0);  addi a0, a0, 16
    vse16.v  v26, (a0);  addi a0, a0, 16
    vse16.v  v27, (a0);  addi a0, a0, 16
    vsub.vv  v28, v20, v28
    vsub.vv  v29, v21, v29
    vsub.vv  v30, v22, v30
    vsub.vv  v31, v23, v31
    vse16.v  v28, (a0);  addi a0, a0, 16
    vse16.v  v29, (a0);  addi a0, a0, 16
    vse16.v  v30, (a0);  addi a0, a0, 16
    vse16.v  v31, (a0);  addi a0, a0, -16*7-192*2 // a[0]
    RestoreRegs
    addi sp, sp, 8*18
ret

.globl test_vector_scalar_hybrid_15_1
.align 2
test_vector_scalar_hybrid_15_1:
    addi sp, sp, -8*18
    SaveRegs
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329

    lh t2, (_ZETAS_EXP+0)*2(a1)
    addi a0, a0, (64*0+128)*2
    lh t1, (_ZETAS_EXP+1)*2(a1)
    vle16.v v8, (a0);   addi a0, a0, 16
    vle16.v v9, (a0);   addi a0, a0, 16
    vle16.v v10, (a0);  addi a0, a0, 16
    vle16.v v11, (a0);  addi a0, a0, 16
    vle16.v v12, (a0);  addi a0, a0, 16
    vle16.v v13, (a0);  addi a0, a0, 16
    vle16.v v14, (a0);  addi a0, a0, 16
    vle16.v v15, (a0);  addi a0, a0, -((64*0+128)*2+16*7)
    vle16.v v16, (a0);  addi a0, a0, 16
    vle16.v v17, (a0);  addi a0, a0, 16
    vle16.v v18, (a0);  addi a0, a0, 16
    vle16.v v19, (a0);  addi a0, a0, 16
    vle16.v v20, (a0);  addi a0, a0, 16
    vle16.v v21, (a0);  addi a0, a0, 16
    vle16.v v22, (a0);  addi a0, a0, 16
    # vle16.v v23, (a0);  addi a0, a0, -16*7
    lh t3, 0(a0); lh t4, 2(a0); lh t5, 4(a0); lh t6, 6(a0)
    lh a2, 8(a0); lh a3, 10(a0);lh a4,12(a0); lh a5,14(a0)
    vmul.vx v0, v8, t2
    vmul.vx v1, v9, t2
    vmul.vx v2, v10, t2
    vmul.vx v3, v11, t2
    vmul.vx v4, v12, t2
    vmul.vx v5, v13, t2
    vmul.vx v6, v14, t2
    vmul.vx v7, v15, t2
    vmulh.vx v8,  v8, t1
    vmulh.vx v9,  v9, t1
    vmulh.vx v10, v10, t1
    vmulh.vx v11, v11, t1
    vmulh.vx v12, v12, t1
    vmulh.vx v13, v13, t1
    vmulh.vx v14, v14, t1
    # vmulh.vx v15, v15, t1
    mulh s0, t3, t2
    mulh s1, t4, t2
    mulh s2, t5, t2
    mulh s3, t6, t2
    mulh s4, a2, t2
    mulh s5, a3, t2
    mulh s6, a4, t2
    mulh s7, a5, t2
    vmulh.vx v0, v0, t0
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vmulh.vx v4, v4, t0
    vmulh.vx v5, v5, t0
    vmulh.vx v6, v6, t0
    vmulh.vx v7, v7, t0
    vsub.vv  v8,  v8,  v0
    vsub.vv  v9,  v9,  v1
    vsub.vv  v10, v10, v2
    vsub.vv  v11, v11, v3
    vadd.vv  v0, v16, v8
    vadd.vv  v1, v17, v9
    vadd.vv  v2, v18, v10
    vadd.vv  v3, v19, v11
    vsub.vv  v12, v12, v4
    vsub.vv  v13, v13, v5
    vsub.vv  v14, v14, v6
    vsub.vv  v15, v15, v7
    vadd.vv  v4, v20, v12
    vadd.vv  v5, v21, v13
    vadd.vv  v6, v22, v14
    # vadd.vv  v7, v23, v15
    add s0, t3, t2
    add s1, t4, t2
    add s2, t5, t2
    add s3, t6, t2
    add s4, a2, t2
    add s5, a3, t2
    add s6, a4, t2
    add s7, a5, t2
    vsub.vv  v8, v16, v8
    vsub.vv  v9, v17, v9
    vsub.vv  v10, v18, v10
    vsub.vv  v11, v19, v11
    vsub.vv  v12, v20, v12
    vsub.vv  v13, v21, v13
    vsub.vv  v14, v22, v14
    vsub.vv  v15, v23, v15
    vse16.v  v0, (a0);  addi a0, a0, 16
    vse16.v  v1, (a0);  addi a0, a0, 16
    vse16.v  v2, (a0);  addi a0, a0, 16
    vse16.v  v3, (a0);  addi a0, a0, 16
    vse16.v  v4, (a0);  addi a0, a0, 16
    vse16.v  v5, (a0);  addi a0, a0, 16
    vse16.v  v6, (a0);  addi a0, a0, 16
    vse16.v  v7, (a0);  addi a0, a0, (64*0+128)*2-16*7 // a[128]
    vse16.v  v8,  (a0);  addi a0, a0, 16
    vse16.v  v9,  (a0);  addi a0, a0, 16
    vse16.v  v10, (a0);  addi a0, a0, 16
    vse16.v  v11, (a0);  addi a0, a0, 16
    vse16.v  v12, (a0);  addi a0, a0, 16
    vse16.v  v13, (a0);  addi a0, a0, 16
    vse16.v  v14, (a0);  addi a0, a0, 16
    # vse16.v  v15, (a0);  addi a0, a0, 16 // a[192]
    sh t3, 0(a0); sh t4, 2(a0); sh t5, 4(a0); sh t6, 6(a0)
    sh a2, 8(a0); sh a3, 10(a0);sh a4,12(a0); sh a5,14(a0)
    vle16.v  v24, (a0);  addi a0, a0, 16
    vle16.v  v25, (a0);  addi a0, a0, 16
    vle16.v  v26, (a0);  addi a0, a0, 16
    vle16.v  v27, (a0);  addi a0, a0, 16
    vmul.vx v0, v24, t2
    vmul.vx v1, v25, t2
    vmul.vx v2, v26, t2
    vmul.vx v3, v27, t2
    vle16.v  v28, (a0);  addi a0, a0, 16
    vle16.v  v29, (a0);  addi a0, a0, 16
    vle16.v  v30, (a0);  addi a0, a0, 16
    vle16.v  v31, (a0);  addi a0, a0, -(128*2)-16*7 // a[64]
    vmul.vx v4, v28, t2
    vmul.vx v5, v29, t2
    vmul.vx v6, v30, t2
    vmul.vx v7, v31, t2
    vle16.v  v16, (a0);  addi a0, a0, 16
    vle16.v  v17, (a0);  addi a0, a0, 16
    vle16.v  v18, (a0);  addi a0, a0, 16
    vle16.v  v19, (a0);  addi a0, a0, 16
    vmulh.vx v24, v24, t1
    vmulh.vx v25, v25, t1
    vmulh.vx v26, v26, t1
    vmulh.vx v27, v27, t1
    vle16.v  v20, (a0);  addi a0, a0, 16
    vle16.v  v21, (a0);  addi a0, a0, 16
    vle16.v  v22, (a0);  addi a0, a0, 16
    vle16.v  v23, (a0);  addi a0, a0, -16*7 // a[64]
    vmulh.vx v28, v28, t1
    vmulh.vx v29, v29, t1
    vmulh.vx v30, v30, t1
    vmulh.vx v31, v31, t1
    vmulh.vx v0, v0, t0
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vsub.vv  v24, v24, v0
    vsub.vv  v25, v25, v1
    vsub.vv  v26, v26, v2
    vsub.vv  v27, v27, v3
    vmulh.vx v4, v4, t0
    vmulh.vx v5, v5, t0
    vmulh.vx v6, v6, t0
    vmulh.vx v7, v7, t0
    vadd.vv  v0, v16, v24
    vadd.vv  v1, v17, v25
    vadd.vv  v2, v18, v26
    vadd.vv  v3, v19, v27
    vse16.v  v0, (a0);  addi a0, a0, 16
    vse16.v  v1, (a0);  addi a0, a0, 16
    vse16.v  v2, (a0);  addi a0, a0, 16
    vse16.v  v3, (a0);  addi a0, a0, 16
    vsub.vv  v28, v28, v4
    vsub.vv  v29, v29, v5
    vsub.vv  v30, v30, v6
    vsub.vv  v31, v31, v7
    vadd.vv  v4, v20, v28
    vadd.vv  v5, v21, v29
    vadd.vv  v6, v22, v30
    vadd.vv  v7, v23, v31
    vse16.v  v4, (a0);  addi a0, a0, 16
    vse16.v  v5, (a0);  addi a0, a0, 16
    vse16.v  v6, (a0);  addi a0, a0, 16
    vse16.v  v7, (a0);  addi a0, a0, -16*7+128*2 // a[192]
    vsub.vv  v24, v16, v24
    vsub.vv  v25, v17, v25
    vsub.vv  v26, v18, v26
    vsub.vv  v27, v19, v27
    vse16.v  v24, (a0);  addi a0, a0, 16
    vse16.v  v25, (a0);  addi a0, a0, 16
    vse16.v  v26, (a0);  addi a0, a0, 16
    vse16.v  v27, (a0);  addi a0, a0, 16
    vsub.vv  v28, v20, v28
    vsub.vv  v29, v21, v29
    vsub.vv  v30, v22, v30
    vsub.vv  v31, v23, v31
    vse16.v  v28, (a0);  addi a0, a0, 16
    vse16.v  v29, (a0);  addi a0, a0, 16
    vse16.v  v30, (a0);  addi a0, a0, 16
    vse16.v  v31, (a0);  addi a0, a0, -16*7-192*2 // a[0]
    RestoreRegs
    addi sp, sp, 8*18
ret