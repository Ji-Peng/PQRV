#include "consts.h"

// register usage:
// v0: mask used for vmerge.vvm instruction
// v28~v31: masks used for shuffle4/2
.globl ntt_rvv
.align 2
ntt_rvv:
    li s10, 128
    vsetvli s11, s10, e16, m1, tu, mu
    li a6, 3329
    # ntt_rvv_level0
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
    vmulh.vx v8,  v8, t1
    vle16.v v17, (a0);  addi a0, a0, 16
    vmulh.vx v9,  v9, t1
    vle16.v v18, (a0);  addi a0, a0, 16
    vmulh.vx v10, v10, t1
    vle16.v v19, (a0);  addi a0, a0, 16
    vmulh.vx v11, v11, t1
    vle16.v v20, (a0);  addi a0, a0, 16
    vmulh.vx v12, v12, t1
    vle16.v v21, (a0);  addi a0, a0, 16
    vmulh.vx v13, v13, t1
    vle16.v v22, (a0);  addi a0, a0, 16
    vmulh.vx v14, v14, t1
    vle16.v v23, (a0);  addi a0, a0, -16*7
    vmulh.vx v15, v15, t1
    vmulh.vx v0, v0, a6
    vmulh.vx v1, v1, a6
    vmulh.vx v2, v2, a6
    vmulh.vx v3, v3, a6
    vsub.vv  v8,  v8,  v0
    vsub.vv  v9,  v9,  v1
    vsub.vv  v10, v10, v2
    vsub.vv  v11, v11, v3
    vmulh.vx v4, v4, a6
    vadd.vv  v0, v16, v8
    vmulh.vx v5, v5, a6
    vadd.vv  v1, v17, v9
    vmulh.vx v6, v6, a6
    vadd.vv  v2, v18, v10
    vmulh.vx v7, v7, a6
    vadd.vv  v3, v19, v11
    vse16.v  v0, (a0);  addi a0, a0, 16
    vsub.vv  v12, v12, v4
    vse16.v  v1, (a0);  addi a0, a0, 16
    vsub.vv  v13, v13, v5
    vse16.v  v2, (a0);  addi a0, a0, 16
    vsub.vv  v14, v14, v6
    vse16.v  v3, (a0);  addi a0, a0, 16
    vsub.vv  v15, v15, v7
    vadd.vv  v4, v20, v12
    vadd.vv  v5, v21, v13
    vadd.vv  v6, v22, v14
    vadd.vv  v7, v23, v15
    vse16.v  v4, (a0);  addi a0, a0, 16
    vsub.vv  v8, v16, v8
    vse16.v  v5, (a0);  addi a0, a0, 16
    vsub.vv  v9, v17, v9
    vse16.v  v6, (a0);  addi a0, a0, 16
    vsub.vv  v10, v18, v10
    vse16.v  v7, (a0);  addi a0, a0, (64*0+128)*2-16*7 // a[128]
    vsub.vv  v11, v19, v11
    vse16.v  v8,  (a0);  addi a0, a0, 16
    vsub.vv  v12, v20, v12
    vse16.v  v9,  (a0);  addi a0, a0, 16
    vsub.vv  v13, v21, v13
    vse16.v  v10, (a0);  addi a0, a0, 16
    vsub.vv  v14, v22, v14
    vse16.v  v11, (a0);  addi a0, a0, 16
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
    vmulh.vx v24, v24, t1
    vle16.v  v17, (a0);  addi a0, a0, 16
    vmulh.vx v25, v25, t1
    vle16.v  v18, (a0);  addi a0, a0, 16
    vmulh.vx v26, v26, t1
    vle16.v  v19, (a0);  addi a0, a0, 16
    vmulh.vx v27, v27, t1
    vle16.v  v20, (a0);  addi a0, a0, 16
    vmulh.vx v28, v28, t1
    vle16.v  v21, (a0);  addi a0, a0, 16
    vmulh.vx v29, v29, t1
    vle16.v  v22, (a0);  addi a0, a0, 16
    vmulh.vx v30, v30, t1
    vle16.v  v23, (a0);  addi a0, a0, -16*7 // a[64]
    vmulh.vx v31, v31, t1
    vmulh.vx v0, v0, a6
    vmulh.vx v1, v1, a6
    vmulh.vx v2, v2, a6
    vmulh.vx v3, v3, a6
    vsub.vv  v24, v24, v0
    vsub.vv  v25, v25, v1
    vsub.vv  v26, v26, v2
    vsub.vv  v27, v27, v3
    vmulh.vx v4, v4, a6
    vadd.vv  v0, v16, v24
    vmulh.vx v5, v5, a6
    vadd.vv  v1, v17, v25
    vmulh.vx v6, v6, a6
    vadd.vv  v2, v18, v26
    vmulh.vx v7, v7, a6
    vadd.vv  v3, v19, v27
    vse16.v  v0, (a0);  addi a0, a0, 16
    vsub.vv  v28, v28, v4
    vse16.v  v1, (a0);  addi a0, a0, 16
    vsub.vv  v29, v29, v5
    vse16.v  v2, (a0);  addi a0, a0, 16
    vsub.vv  v30, v30, v6
    vse16.v  v3, (a0);  addi a0, a0, 16
    vsub.vv  v31, v31, v7
    vadd.vv  v4, v20, v28
    vadd.vv  v5, v21, v29
    vadd.vv  v6, v22, v30
    vadd.vv  v7, v23, v31
    vse16.v  v4, (a0);  addi a0, a0, 16
    vsub.vv  v24, v16, v24
    vse16.v  v5, (a0);  addi a0, a0, 16
    vsub.vv  v25, v17, v25
    vse16.v  v6, (a0);  addi a0, a0, 16
    vsub.vv  v26, v18, v26
    vse16.v  v7, (a0);  addi a0, a0, -16*7+128*2 // a[192]
    vsub.vv  v27, v19, v27
    vse16.v  v24, (a0);  addi a0, a0, 16
    vsub.vv  v28, v20, v28
    vse16.v  v25, (a0);  addi a0, a0, 16
    vsub.vv  v29, v21, v29
    vse16.v  v26, (a0);  addi a0, a0, 16
    vsub.vv  v30, v22, v30
    vse16.v  v27, (a0);  addi a0, a0, 16
    vsub.vv  v31, v23, v31
    vse16.v  v28, (a0);  addi a0, a0, 16
    vse16.v  v29, (a0);  addi a0, a0, 16
    vse16.v  v30, (a0);  addi a0, a0, 16
    vse16.v  v31, (a0);  addi a0, a0, -16*7-192*2 // a[0]
    // load some masks used by shuffle4/2/1
    addi t4, a1, _MASK_45674567*2
    vle16.v v31, (t4)
    addi t4, a1, _MASK_01230123*2
    vle16.v v30, (t4)
    addi t4, a1, _MASK_00010045*2
    vle16.v v29, (t4)
    addi t4, a1, _MASK_23006700*2
    vle16.v v28, (t4)
    # ntt_rvv_level1to6 0
    // level 1
    lh t2, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1)*2(a1)
    addi t3, a0, (64+0*128)*2 # a[64] or a[192]
    lh t1, ((1-0)*_ZETAS_EXP_1TO6_P0_L1 + 0*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(a1)
    vle16.v v9,  (t3);  addi t3, t3, 16
    vle16.v v10, (t3);  addi t3, t3, 16
    vle16.v v11, (t3);  addi t3, t3, 16
    vle16.v v12, (t3);  addi t3, t3, 16
    vmul.vx v17, v9, t2
    vmul.vx v18, v10, t2
    vmul.vx v19, v11, t2
    vmul.vx v20, v12, t2
    vle16.v v13, (t3);  addi t3, t3, 16
    vle16.v v14, (t3);  addi t3, t3, 16
    vle16.v v15, (t3);  addi t3, t3, 16
    vle16.v v16, (t3);  addi t3, a0, (0*128)*2 # a[0] or a[128]
    vmul.vx v21, v13, t2
    vmul.vx v22, v14, t2
    vmul.vx v23, v15, t2
    vmul.vx v24, v16, t2
    vle16.v v1, (t3);  addi t3, t3, 16
    vmulh.vx v9, v9, t1
    vle16.v v2, (t3);  addi t3, t3, 16
    vmulh.vx v10, v10, t1
    vle16.v v3, (t3);  addi t3, t3, 16
    vmulh.vx v11, v11, t1
    vle16.v v4, (t3);  addi t3, t3, 16
    vmulh.vx v12, v12, t1
    vle16.v v5, (t3);  addi t3, t3, 16
    vmulh.vx v13, v13, t1
    vle16.v v6, (t3);  addi t3, t3, 16
    vmulh.vx v14, v14, t1
    vle16.v v7, (t3);  addi t3, t3, 16
    vmulh.vx v15, v15, t1
    vle16.v v8, (t3)
    vmulh.vx v16, v16, t1
    vmulh.vx v21, v21, a6
    vmulh.vx v22, v22, a6
    vmulh.vx v23, v23, a6
    vmulh.vx v24, v24, a6
    vsub.vv  v13, v13, v21
    vsub.vv  v14, v14, v22
    vsub.vv  v15, v15, v23
    vsub.vv  v16, v16, v24
    vmulh.vx v17, v17, a6
    vsub.vv  v21, v5, v13
    vmulh.vx v18, v18, a6
    vsub.vv  v22, v6, v14
    vmulh.vx v19, v19, a6
    vsub.vv  v23, v7, v15
    vmulh.vx v20, v20, a6
    vsub.vv  v24, v8, v16
    vsub.vv  v9,  v9,  v17
    vsub.vv  v10, v10, v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    lh t2, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2)*2(a1)
    vsub.vv  v17, v1, v9
    vsub.vv  v18, v2, v10
    lh t1, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(a1)
    vsub.vv  v19, v3, v11
    vsub.vv  v20, v4, v12
    lh t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(a1)
    vadd.vv  v13, v5, v13
    vadd.vv  v14, v6, v14
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L2 + 0*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(a1)
    vadd.vv  v15, v7, v15
    vadd.vv  v16, v8, v16
    vadd.vv  v9, v1, v9
    vadd.vv  v10, v2, v10
    vadd.vv  v11, v3, v11
    vadd.vv  v12, v4, v12
    // v9~v16 = a0~a63; v17~v24 = a64~a127
    // level 2
    vmul.vx v1, v13, t2
    vmul.vx v2, v14, t2
    vmul.vx v3, v15, t2
    vmul.vx v4, v16, t2
    vmul.vx v5, v21, t6
    vmul.vx v6, v22, t6
    vmul.vx v7, v23, t6
    vmul.vx v8, v24, t6
    vmulh.vx v13, v13, t1
    vmulh.vx v14, v14, t1
    vmulh.vx v15, v15, t1
    vmulh.vx v16, v16, t1
    vmulh.vx v21, v21, t5
    vmulh.vx v22, v22, t5
    vmulh.vx v23, v23, t5
    vmulh.vx v24, v24, t5
    vmulh.vx v1, v1, a6
    vmulh.vx v2, v2, a6
    vmulh.vx v3, v3, a6
    vmulh.vx v4, v4, a6
    vsub.vv  v13, v13, v1
    vsub.vv  v14, v14, v2
    vsub.vv  v15, v15, v3
    vsub.vv  v16, v16, v4
    vmulh.vx v5, v5, a6
    vadd.vv  v1, v9,  v13
    vmulh.vx v6, v6, a6
    vadd.vv  v2, v10, v14
    vmulh.vx v7, v7, a6
    vadd.vv  v3, v11, v15
    vmulh.vx v8, v8, a6
    lh t2, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(a1)
    vadd.vv  v4, v12, v16
    vsub.vv  v21, v21, v5
    lh t1, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(a1)
    vsub.vv  v22, v22, v6
    vsub.vv  v23, v23, v7
    lh t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(a1)
    vsub.vv  v24, v24, v8
    vadd.vv  v5, v17, v21
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(a1)
    vadd.vv  v6, v18, v22
    vadd.vv  v7, v19, v23
    lh a3, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(a1)
    vadd.vv  v8, v20, v24
    vsub.vv  v9, v9,  v13
    lh a2, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(a1)
    vsub.vv  v10, v10,v14
    vsub.vv  v11,v11, v15
    lh a5, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(a1)
    vsub.vv  v12,v12, v16
    vsub.vv  v13,v17, v21
    lh a4, ((1-0)*_ZETAS_EXP_1TO6_P0_L3 + 0*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(a1)
    vsub.vv  v14,v18, v22
    vsub.vv  v15,v19, v23
    vsub.vv  v16,v20, v24
    // v1~v4,v9~v12,v5~v8,v13~v16 = a0~a127
    // level 3
    vmul.vx v17, v3,  t2
    vmul.vx v18, v4,  t2
    vmul.vx v19, v11, t6
    vmul.vx v20, v12, t6
    vmul.vx v21, v7,  a3
    vmul.vx v22, v8,  a3
    vmul.vx v23, v15, a5
    vmul.vx v24, v16, a5
    vmulh.vx v3,  v3,  t1
    vmulh.vx v4,  v4,  t1
    vmulh.vx v11, v11, t5
    vmulh.vx v12, v12, t5
    vmulh.vx v7,  v7,  a2
    vmulh.vx v8,  v8,  a2
    vmulh.vx v15, v15, a4
    vmulh.vx v16, v16, a4
    vmulh.vx v17, v17, a6
    vmulh.vx v18, v18, a6
    vmulh.vx v19, v19, a6
    vmulh.vx v20, v20, a6
    vsub.vv  v3,  v3,  v17
    vsub.vv  v4,  v4,  v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    vmulh.vx v21, v21, a6
    vadd.vv  v17, v1,  v3
    vmulh.vx v22, v22, a6
    vadd.vv  v18, v2,  v4
    vmulh.vx v23, v23, a6
    vadd.vv  v19, v9,  v11
    vmulh.vx v24, v24, a6
    lh t2, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(a1)
    vadd.vv  v20, v10, v12
    vsub.vv  v7,  v7,  v21
    lh t1, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(a1)
    vsub.vv  v8,  v8,  v22
    vsub.vv  v15, v15, v23
    lh t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(a1)
    vsub.vv  v16, v16, v24
    vadd.vv  v21, v5,  v7
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(a1)
    vadd.vv  v22, v6,  v8
    vadd.vv  v23, v13, v15
    lh a3, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(a1)
    vadd.vv  v24, v14, v16
    vsub.vv  v1,  v1,  v3
    lh a2, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(a1)
    vsub.vv  v2,  v2,  v4
    vsub.vv  v3,  v9,  v11
    lh a5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(a1)
    vsub.vv  v4,  v10, v12
    vsub.vv  v5,  v5,  v7
    lh a4, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(a1)
    vsub.vv  v6,  v6,  v8
    vsub.vv  v7,  v13, v15
    vsub.vv  v8,  v14, v16
    // v17,v18,v1,v2,v19,v20,v3,v4,v21,v22,v5,v6,v23,v24,v7,v8=a0~a127
    // level 4
    vmul.vx v9,  v18,  t2
    vmulh.vx v18, v18, t1
    lh t2, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(a1)
    lh t1, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(a1)
    vmul.vx v10, v2,   t6
    vmulh.vx v2,  v2,  t5
    lh t6, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +10)*2(a1)
    lh t5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +11)*2(a1)
    vmul.vx v11, v20,  a3
    vmulh.vx v20, v20, a2
    lh a3, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +12)*2(a1)
    lh a2, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +13)*2(a1)
    vmul.vx v12, v4,   a5
    vmulh.vx v4,  v4,  a4
    lh a5, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +14)*2(a1)
    lh a4, ((1-0)*_ZETAS_EXP_1TO6_P0_L4 + 0*_ZETAS_EXP_1TO6_P1_L4 +15)*2(a1)
    vmul.vx v13, v22,  t2
    vmulh.vx v22, v22, t1
    vmul.vx v14, v6,   t6
    vmulh.vx v6,  v6,  t5
    vmul.vx v15, v24,  a3
    vmulh.vx v24, v24, a2
    vmul.vx v16, v8,   a5
    vmulh.vx v8,  v8,  a4
    vmulh.vx v9,  v9,  a6
    vmulh.vx v10, v10, a6
    vmulh.vx v11, v11, a6
    vmulh.vx v12, v12, a6
    vsub.vv  v18, v18, v9
    vsub.vv  v2,  v2,  v10
    vsub.vv  v20, v20, v11
    vsub.vv  v4,  v4,  v12
    vmulh.vx v13, v13, a6
    vadd.vv  v9,  v17, v18
    vmulh.vx v14, v14, a6
    vadd.vv  v10, v1,  v2
    vmulh.vx v15, v15, a6
    vadd.vv  v11, v19, v20
    vmulh.vx v16, v16, a6
    vadd.vv  v12, v3, v4
    addi t4, a1, _MASK_11110000*2
    vle16.v v0, (t4)
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
    shuffle4 v1, v2, v9,  v17, v31, v30
    vadd.vv  v16, v7, v8
    shuffle4 v3, v4, v10, v18, v31, v30
    addi t4, a1, ((1-0)*_ZETAS_EXP_1TO6_P0_L5 + 0*_ZETAS_EXP_1TO6_P1_L5)*2
    vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vsub.vv  v21, v21, v22
    vsub.vv  v22, v5,  v6
    vsub.vv  v23, v23, v24
    vsub.vv  v24, v7,  v8
    // v9,v17,v10,v18,v11,v19,v12,v20,v13,v21,v14,v22,v15,v23,v16,v24 = a0~a127
    // level 5
    vmul.vv  v9,  v2,  v27
    vmulh.vv v2,  v2,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    shuffle4 v5, v6, v11, v19, v31, v30
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle4 v7, v8, v12, v20, v31, v30
    vmul.vv  v17, v4,  v27
    vmulh.vv v4,  v4,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    vmulh.vx v9,  v9,  a6
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v17, v17, a6
    vmul.vv  v10, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    vsub.vv  v2,  v2,  v9
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v10, v10, a6
    vmul.vv  v18, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v18, v18, a6
    vsub.vv  v4,  v4,  v17
    vsub.vv  v6,  v6,  v10
    vsub.vv  v8,  v8,  v18
    // butterfly unit a+b, a-b
    vadd.vv  v9,  v1,  v2
    vsub.vv  v11, v1,  v2
    vadd.vv  v17, v3,  v4
    vsub.vv  v19, v3,  v4
    vadd.vv  v10, v5,  v6
    vsub.vv  v12, v5,  v6
    shuffle4 v1, v2, v13, v21, v31, v30
    shuffle4 v3, v4, v14, v22, v31, v30
    vadd.vv  v18, v7,  v8
    vsub.vv  v20, v7,  v8
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    shuffle4 v5, v6, v15, v23, v31, v30
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle4 v7, v8, v16, v24, v31, v30
    vmul.vv  v13, v2,  v27
    vmulh.vv v2,  v2,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v13, v13, a6
    vmul.vv  v21, v4,  v27
    vmulh.vv v4,  v4,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v21, v21, a6
    vmul.vv  v14, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v14, v14, a6
    vmul.vv  v22, v8,  v27
    vmulh.vv v8,  v8,  v26
    vsub.vv  v2,  v2, v13
    vsub.vv  v4,  v4, v21
    vmulh.vx v22, v22, a6
    vsub.vv  v6,  v6, v14
    vsub.vv  v8,  v8, v22
    addi t4, a1, _MASK_11001100*2
    vle16.v v0, (t4)
    // butterfly unit a+b, a-b
    vadd.vv  v13, v1,  v2
    vsub.vv  v15, v1,  v2
    vadd.vv  v21, v3,  v4
    vsub.vv  v23, v3,  v4
    vadd.vv  v14, v5,  v6
    vsub.vv  v16, v5,  v6
    shuffle2 v1, v2, v9, v11, v29, v28
    vadd.vv  v22, v7,  v8
    vsub.vv  v24, v7,  v8
    // v9 =a0~a3,   a8~a11, v11=a4~a7,   a12~a15
    // v17=a16~a19, a24~a27,v19=a20~a23, a28~a31
    // v10,v12,v18,v20,v13,v15,v21,v23,v14,v16,v22,v24
    // level 6
    addi t4, a1, ((1-0)*_ZETAS_EXP_1TO6_P0_L6+ 0*_ZETAS_EXP_1TO6_P1_L6)*2
    vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v3, v4, v17,v19, v29, v28
    vmul.vv  v9,  v2,  v27
    vmulh.vv v2,  v2,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v5, v6, v10,v12, v29, v28
    vmul.vv  v11, v4,  v27
    vmulh.vv v4,  v4,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v7, v8, v18,v20, v29, v28
    vmul.vv  v17, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmul.vv  v19, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v9,  v9,  a6
    vmulh.vx v11, v11, a6
    vmulh.vx v17, v17, a6
    vmulh.vx v19, v19, a6
    vsub.vv  v2,  v2,  v9
    vsub.vv  v4,  v4,  v11
    vsub.vv  v6,  v6,  v17
    vsub.vv  v8,  v8,  v19
    // butterfly unit a+b, a-b
    vadd.vv  v9,  v1,  v2
    vsub.vv  v11, v1,  v2
    vadd.vv  v17, v3,  v4
    vsub.vv  v19, v3,  v4
    shuffle2 v1, v2, v13,v15, v29, v28
    vadd.vv  v10, v5,  v6
    vsub.vv  v12, v5,  v6
    vadd.vv  v18, v7,  v8
    vsub.vv  v20, v7,  v8
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v3, v4, v21,v23, v29, v28
    vmul.vv  v13, v2,  v27
    vmulh.vv v2,  v2,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v5, v6, v14,v16, v29, v28
    vmul.vv  v15, v4,  v27
    vmulh.vv v4,  v4,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v7, v8, v22,v24, v29, v28
    vmul.vv  v21, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmul.vv  v23, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v13, v13, a6
    vmulh.vx v15, v15, a6
    vmulh.vx v21, v21, a6
    vmulh.vx v23, v23, a6
    vsub.vv  v2,  v2,  v13
    vsub.vv  v4,  v4,  v15
    vsub.vv  v6,  v6,  v21
    vsub.vv  v8,  v8,  v23
    vadd.vv  v13, v1,  v2
    vsub.vv  v15, v1,  v2
    addi t4, a1, _MASK_10101010*2
    vle16.v v0, (t4)
    addi t4, a1, _MASK_10325476*2
    vle16.v v27, (t4)
    vadd.vv  v21, v3,  v4
    vsub.vv  v23, v3,  v4
    shuffle1 v1, v2, v9,  v11, v27
    vadd.vv  v14, v5,  v6
    vsub.vv  v16, v5,  v6
    shuffle1 v3, v4, v17, v19, v27
    vadd.vv  v22, v7,  v8
    vsub.vv  v24, v7,  v8
    // v9=[a0~a1,a4~a5,a8~a9,a12~a13], v11=[a2~a3,a6~a7,a10~a11,a14~a15]
    // v9, v11,v17,v19,v10,v12,v18,v20
    // v13,v15,v21,v23,v14,v16,v22,v24
    addi t3, a0, (0*128)*2 # a[0] or a[128]
    vse16.v  v1, (t3);   addi t3, t3, 16
    vse16.v  v2, (t3);   addi t3, t3, 16
    shuffle1 v5, v6, v10, v12, v27
    vse16.v  v3, (t3);   addi t3, t3, 16
    vse16.v  v4, (t3);   addi t3, t3, 16
    shuffle1 v7, v8, v18, v20, v27
    vse16.v  v5, (t3);   addi t3, t3, 16
    vse16.v  v6, (t3);   addi t3, t3, 16
    vse16.v  v7, (t3);   addi t3, t3, 16
    vse16.v  v8, (t3);   addi t3, a0, (64+0*128)*2 # a[64] or a[192]
    shuffle1 v9,  v11, v13, v15, v27
    shuffle1 v17, v19, v21, v23, v27
    vse16.v  v9, (t3);   addi t3, t3, 16
    vse16.v  v11, (t3);  addi t3, t3, 16
    shuffle1 v10, v12, v14, v16, v27
    vse16.v  v17, (t3);  addi t3, t3, 16
    vse16.v  v19, (t3);  addi t3, t3, 16
    shuffle1 v18, v20, v22, v24, v27
    vse16.v  v10, (t3);  addi t3, t3, 16
    vse16.v  v12, (t3);  addi t3, t3, 16
    vse16.v  v18, (t3);  addi t3, t3, 16
    vse16.v  v20, (t3);  addi t3, t3, 16
    # ntt_rvv_level1to6 1
    // level 1
    lh t2, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1)*2(a1)
    addi t3, a0, (64+1*128)*2 # a[64] or a[192]
    lh t1, ((1-1)*_ZETAS_EXP_1TO6_P0_L1 + 1*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(a1)
    vle16.v v9,  (t3);  addi t3, t3, 16
    vle16.v v10, (t3);  addi t3, t3, 16
    vle16.v v11, (t3);  addi t3, t3, 16
    vle16.v v12, (t3);  addi t3, t3, 16
    vmul.vx v17, v9, t2
    vmul.vx v18, v10, t2
    vmul.vx v19, v11, t2
    vmul.vx v20, v12, t2
    vle16.v v13, (t3);  addi t3, t3, 16
    vle16.v v14, (t3);  addi t3, t3, 16
    vle16.v v15, (t3);  addi t3, t3, 16
    vle16.v v16, (t3);  addi t3, a0, (1*128)*2 # a[0] or a[128]
    vmul.vx v21, v13, t2
    vmul.vx v22, v14, t2
    vmul.vx v23, v15, t2
    vmul.vx v24, v16, t2
    vle16.v v1, (t3);  addi t3, t3, 16
    vmulh.vx v9, v9, t1
    vle16.v v2, (t3);  addi t3, t3, 16
    vmulh.vx v10, v10, t1
    vle16.v v3, (t3);  addi t3, t3, 16
    vmulh.vx v11, v11, t1
    vle16.v v4, (t3);  addi t3, t3, 16
    vmulh.vx v12, v12, t1
    vle16.v v5, (t3);  addi t3, t3, 16
    vmulh.vx v13, v13, t1
    vle16.v v6, (t3);  addi t3, t3, 16
    vmulh.vx v14, v14, t1
    vle16.v v7, (t3);  addi t3, t3, 16
    vmulh.vx v15, v15, t1
    vle16.v v8, (t3)
    vmulh.vx v16, v16, t1
    vmulh.vx v21, v21, a6
    vmulh.vx v22, v22, a6
    vmulh.vx v23, v23, a6
    vmulh.vx v24, v24, a6
    vsub.vv  v13, v13, v21
    vsub.vv  v14, v14, v22
    vsub.vv  v15, v15, v23
    vsub.vv  v16, v16, v24
    vmulh.vx v17, v17, a6
    vsub.vv  v21, v5, v13
    vmulh.vx v18, v18, a6
    vsub.vv  v22, v6, v14
    vmulh.vx v19, v19, a6
    vsub.vv  v23, v7, v15
    vmulh.vx v20, v20, a6
    vsub.vv  v24, v8, v16
    vsub.vv  v9,  v9,  v17
    vsub.vv  v10, v10, v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    lh t2, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2)*2(a1)
    vsub.vv  v17, v1, v9
    vsub.vv  v18, v2, v10
    lh t1, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(a1)
    vsub.vv  v19, v3, v11
    vsub.vv  v20, v4, v12
    lh t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(a1)
    vadd.vv  v13, v5, v13
    vadd.vv  v14, v6, v14
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L2 + 1*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(a1)
    vadd.vv  v15, v7, v15
    vadd.vv  v16, v8, v16
    vadd.vv  v9, v1, v9
    vadd.vv  v10, v2, v10
    vadd.vv  v11, v3, v11
    vadd.vv  v12, v4, v12
    // v9~v16 = a0~a63; v17~v24 = a64~a127
    // level 2
    vmul.vx v1, v13, t2
    vmul.vx v2, v14, t2
    vmul.vx v3, v15, t2
    vmul.vx v4, v16, t2
    vmul.vx v5, v21, t6
    vmul.vx v6, v22, t6
    vmul.vx v7, v23, t6
    vmul.vx v8, v24, t6
    vmulh.vx v13, v13, t1
    vmulh.vx v14, v14, t1
    vmulh.vx v15, v15, t1
    vmulh.vx v16, v16, t1
    vmulh.vx v21, v21, t5
    vmulh.vx v22, v22, t5
    vmulh.vx v23, v23, t5
    vmulh.vx v24, v24, t5
    vmulh.vx v1, v1, a6
    vmulh.vx v2, v2, a6
    vmulh.vx v3, v3, a6
    vmulh.vx v4, v4, a6
    vsub.vv  v13, v13, v1
    vsub.vv  v14, v14, v2
    vsub.vv  v15, v15, v3
    vsub.vv  v16, v16, v4
    vmulh.vx v5, v5, a6
    vadd.vv  v1, v9,  v13
    vmulh.vx v6, v6, a6
    vadd.vv  v2, v10, v14
    vmulh.vx v7, v7, a6
    vadd.vv  v3, v11, v15
    vmulh.vx v8, v8, a6
    lh t2, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(a1)
    vadd.vv  v4, v12, v16
    vsub.vv  v21, v21, v5
    lh t1, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(a1)
    vsub.vv  v22, v22, v6
    vsub.vv  v23, v23, v7
    lh t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(a1)
    vsub.vv  v24, v24, v8
    vadd.vv  v5, v17, v21
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(a1)
    vadd.vv  v6, v18, v22
    vadd.vv  v7, v19, v23
    lh a3, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(a1)
    vadd.vv  v8, v20, v24
    vsub.vv  v9, v9,  v13
    lh a2, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(a1)
    vsub.vv  v10, v10,v14
    vsub.vv  v11,v11, v15
    lh a5, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(a1)
    vsub.vv  v12,v12, v16
    vsub.vv  v13,v17, v21
    lh a4, ((1-1)*_ZETAS_EXP_1TO6_P0_L3 + 1*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(a1)
    vsub.vv  v14,v18, v22
    vsub.vv  v15,v19, v23
    vsub.vv  v16,v20, v24
    // v1~v4,v9~v12,v5~v8,v13~v16 = a0~a127
    // level 3
    vmul.vx v17, v3,  t2
    vmul.vx v18, v4,  t2
    vmul.vx v19, v11, t6
    vmul.vx v20, v12, t6
    vmul.vx v21, v7,  a3
    vmul.vx v22, v8,  a3
    vmul.vx v23, v15, a5
    vmul.vx v24, v16, a5
    vmulh.vx v3,  v3,  t1
    vmulh.vx v4,  v4,  t1
    vmulh.vx v11, v11, t5
    vmulh.vx v12, v12, t5
    vmulh.vx v7,  v7,  a2
    vmulh.vx v8,  v8,  a2
    vmulh.vx v15, v15, a4
    vmulh.vx v16, v16, a4
    vmulh.vx v17, v17, a6
    vmulh.vx v18, v18, a6
    vmulh.vx v19, v19, a6
    vmulh.vx v20, v20, a6
    vsub.vv  v3,  v3,  v17
    vsub.vv  v4,  v4,  v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    vmulh.vx v21, v21, a6
    vadd.vv  v17, v1,  v3
    vmulh.vx v22, v22, a6
    vadd.vv  v18, v2,  v4
    vmulh.vx v23, v23, a6
    vadd.vv  v19, v9,  v11
    vmulh.vx v24, v24, a6
    lh t2, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(a1)
    vadd.vv  v20, v10, v12
    vsub.vv  v7,  v7,  v21
    lh t1, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(a1)
    vsub.vv  v8,  v8,  v22
    vsub.vv  v15, v15, v23
    lh t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(a1)
    vsub.vv  v16, v16, v24
    vadd.vv  v21, v5,  v7
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(a1)
    vadd.vv  v22, v6,  v8
    vadd.vv  v23, v13, v15
    lh a3, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(a1)
    vadd.vv  v24, v14, v16
    vsub.vv  v1,  v1,  v3
    lh a2, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(a1)
    vsub.vv  v2,  v2,  v4
    vsub.vv  v3,  v9,  v11
    lh a5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(a1)
    vsub.vv  v4,  v10, v12
    vsub.vv  v5,  v5,  v7
    lh a4, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(a1)
    vsub.vv  v6,  v6,  v8
    vsub.vv  v7,  v13, v15
    vsub.vv  v8,  v14, v16
    // v17,v18,v1,v2,v19,v20,v3,v4,v21,v22,v5,v6,v23,v24,v7,v8=a0~a127
    // level 4
    vmul.vx v9,  v18,  t2
    vmulh.vx v18, v18, t1
    lh t2, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(a1)
    lh t1, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(a1)
    vmul.vx v10, v2,   t6
    vmulh.vx v2,  v2,  t5
    lh t6, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +10)*2(a1)
    lh t5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +11)*2(a1)
    vmul.vx v11, v20,  a3
    vmulh.vx v20, v20, a2
    lh a3, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +12)*2(a1)
    lh a2, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +13)*2(a1)
    vmul.vx v12, v4,   a5
    vmulh.vx v4,  v4,  a4
    lh a5, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +14)*2(a1)
    lh a4, ((1-1)*_ZETAS_EXP_1TO6_P0_L4 + 1*_ZETAS_EXP_1TO6_P1_L4 +15)*2(a1)
    vmul.vx v13, v22,  t2
    vmulh.vx v22, v22, t1
    vmul.vx v14, v6,   t6
    vmulh.vx v6,  v6,  t5
    vmul.vx v15, v24,  a3
    vmulh.vx v24, v24, a2
    vmul.vx v16, v8,   a5
    vmulh.vx v8,  v8,  a4
    vmulh.vx v9,  v9,  a6
    vmulh.vx v10, v10, a6
    vmulh.vx v11, v11, a6
    vmulh.vx v12, v12, a6
    vsub.vv  v18, v18, v9
    vsub.vv  v2,  v2,  v10
    vsub.vv  v20, v20, v11
    vsub.vv  v4,  v4,  v12
    vmulh.vx v13, v13, a6
    vadd.vv  v9,  v17, v18
    vmulh.vx v14, v14, a6
    vadd.vv  v10, v1,  v2
    vmulh.vx v15, v15, a6
    vadd.vv  v11, v19, v20
    vmulh.vx v16, v16, a6
    vadd.vv  v12, v3, v4
    addi t4, a1, _MASK_11110000*2
    vle16.v v0, (t4)
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
    shuffle4 v1, v2, v9,  v17, v31, v30
    vadd.vv  v16, v7, v8
    shuffle4 v3, v4, v10, v18, v31, v30
    addi t4, a1, ((1-1)*_ZETAS_EXP_1TO6_P0_L5 + 1*_ZETAS_EXP_1TO6_P1_L5)*2
    vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vsub.vv  v21, v21, v22
    vsub.vv  v22, v5,  v6
    vsub.vv  v23, v23, v24
    vsub.vv  v24, v7,  v8
    // v9,v17,v10,v18,v11,v19,v12,v20,v13,v21,v14,v22,v15,v23,v16,v24 = a0~a127
    // level 5
    vmul.vv  v9,  v2,  v27
    vmulh.vv v2,  v2,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    shuffle4 v5, v6, v11, v19, v31, v30
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle4 v7, v8, v12, v20, v31, v30
    vmul.vv  v17, v4,  v27
    vmulh.vv v4,  v4,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    vmulh.vx v9,  v9,  a6
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v17, v17, a6
    vmul.vv  v10, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    vsub.vv  v2,  v2,  v9
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v10, v10, a6
    vmul.vv  v18, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v18, v18, a6
    vsub.vv  v4,  v4,  v17
    vsub.vv  v6,  v6,  v10
    vsub.vv  v8,  v8,  v18
    // butterfly unit a+b, a-b
    vadd.vv  v9,  v1,  v2
    vsub.vv  v11, v1,  v2
    vadd.vv  v17, v3,  v4
    vsub.vv  v19, v3,  v4
    vadd.vv  v10, v5,  v6
    vsub.vv  v12, v5,  v6
    shuffle4 v1, v2, v13, v21, v31, v30
    shuffle4 v3, v4, v14, v22, v31, v30
    vadd.vv  v18, v7,  v8
    vsub.vv  v20, v7,  v8
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    shuffle4 v5, v6, v15, v23, v31, v30
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle4 v7, v8, v16, v24, v31, v30
    vmul.vv  v13, v2,  v27
    vmulh.vv v2,  v2,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v13, v13, a6
    vmul.vv  v21, v4,  v27
    vmulh.vv v4,  v4,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v21, v21, a6
    vmul.vv  v14, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v14, v14, a6
    vmul.vv  v22, v8,  v27
    vmulh.vv v8,  v8,  v26
    vsub.vv  v2,  v2, v13
    vsub.vv  v4,  v4, v21
    vmulh.vx v22, v22, a6
    vsub.vv  v6,  v6, v14
    vsub.vv  v8,  v8, v22
    addi t4, a1, _MASK_11001100*2
    vle16.v v0, (t4)
    // butterfly unit a+b, a-b
    vadd.vv  v13, v1,  v2
    vsub.vv  v15, v1,  v2
    vadd.vv  v21, v3,  v4
    vsub.vv  v23, v3,  v4
    vadd.vv  v14, v5,  v6
    vsub.vv  v16, v5,  v6
    shuffle2 v1, v2, v9, v11, v29, v28
    vadd.vv  v22, v7,  v8
    vsub.vv  v24, v7,  v8
    // v9 =a0~a3,   a8~a11, v11=a4~a7,   a12~a15
    // v17=a16~a19, a24~a27,v19=a20~a23, a28~a31
    // v10,v12,v18,v20,v13,v15,v21,v23,v14,v16,v22,v24
    // level 6
    addi t4, a1, ((1-1)*_ZETAS_EXP_1TO6_P0_L6+ 1*_ZETAS_EXP_1TO6_P1_L6)*2
    vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v3, v4, v17,v19, v29, v28
    vmul.vv  v9,  v2,  v27
    vmulh.vv v2,  v2,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v5, v6, v10,v12, v29, v28
    vmul.vv  v11, v4,  v27
    vmulh.vv v4,  v4,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v7, v8, v18,v20, v29, v28
    vmul.vv  v17, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmul.vv  v19, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v9,  v9,  a6
    vmulh.vx v11, v11, a6
    vmulh.vx v17, v17, a6
    vmulh.vx v19, v19, a6
    vsub.vv  v2,  v2,  v9
    vsub.vv  v4,  v4,  v11
    vsub.vv  v6,  v6,  v17
    vsub.vv  v8,  v8,  v19
    // butterfly unit a+b, a-b
    vadd.vv  v9,  v1,  v2
    vsub.vv  v11, v1,  v2
    vadd.vv  v17, v3,  v4
    vsub.vv  v19, v3,  v4
    shuffle2 v1, v2, v13,v15, v29, v28
    vadd.vv  v10, v5,  v6
    vsub.vv  v12, v5,  v6
    vadd.vv  v18, v7,  v8
    vsub.vv  v20, v7,  v8
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v3, v4, v21,v23, v29, v28
    vmul.vv  v13, v2,  v27
    vmulh.vv v2,  v2,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v5, v6, v14,v16, v29, v28
    vmul.vv  v15, v4,  v27
    vmulh.vv v4,  v4,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    shuffle2 v7, v8, v22,v24, v29, v28
    vmul.vv  v21, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmul.vv  v23, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v13, v13, a6
    vmulh.vx v15, v15, a6
    vmulh.vx v21, v21, a6
    vmulh.vx v23, v23, a6
    vsub.vv  v2,  v2,  v13
    vsub.vv  v4,  v4,  v15
    vsub.vv  v6,  v6,  v21
    vsub.vv  v8,  v8,  v23
    vadd.vv  v13, v1,  v2
    vsub.vv  v15, v1,  v2
    addi t4, a1, _MASK_10101010*2
    vle16.v v0, (t4)
    addi t4, a1, _MASK_10325476*2
    vle16.v v27, (t4)
    vadd.vv  v21, v3,  v4
    vsub.vv  v23, v3,  v4
    shuffle1 v1, v2, v9,  v11, v27
    vadd.vv  v14, v5,  v6
    vsub.vv  v16, v5,  v6
    shuffle1 v3, v4, v17, v19, v27
    vadd.vv  v22, v7,  v8
    vsub.vv  v24, v7,  v8
    // v9=[a0~a1,a4~a5,a8~a9,a12~a13], v11=[a2~a3,a6~a7,a10~a11,a14~a15]
    // v9, v11,v17,v19,v10,v12,v18,v20
    // v13,v15,v21,v23,v14,v16,v22,v24
    addi t3, a0, (1*128)*2 # a[0] or a[128]
    vse16.v  v1, (t3);   addi t3, t3, 16
    vse16.v  v2, (t3);   addi t3, t3, 16
    shuffle1 v5, v6, v10, v12, v27
    vse16.v  v3, (t3);   addi t3, t3, 16
    vse16.v  v4, (t3);   addi t3, t3, 16
    shuffle1 v7, v8, v18, v20, v27
    vse16.v  v5, (t3);   addi t3, t3, 16
    vse16.v  v6, (t3);   addi t3, t3, 16
    vse16.v  v7, (t3);   addi t3, t3, 16
    vse16.v  v8, (t3);   addi t3, a0, (64+1*128)*2 # a[64] or a[192]
    shuffle1 v9,  v11, v13, v15, v27
    shuffle1 v17, v19, v21, v23, v27
    vse16.v  v9, (t3);   addi t3, t3, 16
    vse16.v  v11, (t3);  addi t3, t3, 16
    shuffle1 v10, v12, v14, v16, v27
    vse16.v  v17, (t3);  addi t3, t3, 16
    vse16.v  v19, (t3);  addi t3, t3, 16
    shuffle1 v18, v20, v22, v24, v27
    vse16.v  v10, (t3);  addi t3, t3, 16
    vse16.v  v12, (t3);  addi t3, t3, 16
    vse16.v  v18, (t3);  addi t3, t3, 16
    vse16.v  v20, (t3);  addi t3, t3, 16
ret

// v0: mask used for vmerge.vvm instruction
// v28~v31: masks used for shuffle4/2
.globl intt_rvv
.align 2
intt_rvv:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li a6, 3329
    li a6, 20159
    // load some masks used by shuffle4/2/1
    addi t4, a1, _MASK_45674567*2
    vle16.v v31, (t4)
    addi t4, a1, _MASK_01230123*2
    vle16.v v30, (t4)
    addi t4, a1, _MASK_00010045*2
    vle16.v v29, (t4)
    addi t4, a1, _MASK_23006700*2
    vle16.v v28, (t4)
    intt_rvv_level0to5 0
    intt_rvv_level0to5 1

    li t5, _ZETA_EXP_INTT_L6*2
    add t4, a1, t5
    lh t2, (t4)
    lh t1, 2(t4)
    intt_rvv_level6 0
    intt_rvv_level6 1
ret