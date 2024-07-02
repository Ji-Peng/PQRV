#include "consts.h"

// in0 = [a0~a3, a4~a7], in1 = [a8~a11, a12~a15]
// out0= [a0~a3, a8~a11],out1= [a4~a7,  a12~a15]
// related masks are ready for using
// v0: _MASK_11110000, vt0/vt1: _MASK_45674567/_MASK_01230123
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
    vrgather.vv \out1, \in0, \vmt1
    vmerge.vvm  \out0, \out0, \in0, v0
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

.macro barrettRdc in, vt0, const_v, const_q
    vmulh.vx \vt0, \in, \const_v
    vsra.vi  \vt0, \vt0, 10
    vmul.vx  \vt0, \vt0, \const_q
    vsub.vv  \in,  \in, \vt0
.endm

.macro barrettRdcX4 in0, in1, in2, in3, \
        vt0, vt1, vt2, vt3, const_v, const_q
    vmulh.vx \vt0, \in0, \const_v
    vmulh.vx \vt1, \in1, \const_v
    vmulh.vx \vt2, \in2, \const_v
    vmulh.vx \vt3, \in3, \const_v
    vsra.vi  \vt0, \vt0, 10
    vsra.vi  \vt1, \vt1, 10
    vsra.vi  \vt2, \vt2, 10
    vsra.vi  \vt3, \vt3, 10
    vmul.vx  \vt0, \vt0, \const_q
    vmul.vx  \vt1, \vt1, \const_q
    vmul.vx  \vt2, \vt2, \const_q
    vmul.vx  \vt3, \vt3, \const_q
    vsub.vv  \in0, \in0, \vt0
    vsub.vv  \in1, \in1, \vt1
    vsub.vv  \in2, \in2, \vt2
    vsub.vv  \in3, \in3, \vt3
.endm

.macro ntt_rvv_level0
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
    vmulh.vx v0, v0, t0
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vsub.vv  v8,  v8,  v0
    vsub.vv  v9,  v9,  v1
    vsub.vv  v10, v10, v2
    vsub.vv  v11, v11, v3
    vmulh.vx v4, v4, t0
    vadd.vv  v0, v16, v8
    vmulh.vx v5, v5, t0
    vadd.vv  v1, v17, v9
    vmulh.vx v6, v6, t0
    vadd.vv  v2, v18, v10
    vmulh.vx v7, v7, t0
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
    vmulh.vx v0, v0, t0
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vsub.vv  v24, v24, v0
    vsub.vv  v25, v25, v1
    vsub.vv  v26, v26, v2
    vsub.vv  v27, v27, v3
    vmulh.vx v4, v4, t0
    vadd.vv  v0, v16, v24
    vmulh.vx v5, v5, t0
    vadd.vv  v1, v17, v25
    vmulh.vx v6, v6, t0
    vadd.vv  v2, v18, v26
    vmulh.vx v7, v7, t0
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
.endm

.macro ntt_rvv_level1to6 off
    // level 1
    lh t2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L1 + \off*_ZETAS_EXP_1TO6_P1_L1)*2(a1)
    addi t3, a0, (64+\off*128)*2 # a[64] or a[192]
    lh t1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L1 + \off*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(a1)
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
    vle16.v v16, (t3);  addi t3, a0, (\off*128)*2 # a[0] or a[128]
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
    vmulh.vx v21, v21, t0
    vmulh.vx v22, v22, t0
    vmulh.vx v23, v23, t0
    vmulh.vx v24, v24, t0
    vsub.vv  v13, v13, v21
    vsub.vv  v14, v14, v22
    vsub.vv  v15, v15, v23
    vsub.vv  v16, v16, v24
    vmulh.vx v17, v17, t0
    vsub.vv  v21, v5, v13
    vmulh.vx v18, v18, t0
    vsub.vv  v22, v6, v14
    vmulh.vx v19, v19, t0
    vsub.vv  v23, v7, v15
    vmulh.vx v20, v20, t0
    vsub.vv  v24, v8, v16
    vsub.vv  v9,  v9,  v17
    vsub.vv  v10, v10, v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    lh t2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2)*2(a1)
    vsub.vv  v17, v1, v9
    vsub.vv  v18, v2, v10
    lh t1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(a1)
    vsub.vv  v19, v3, v11
    vsub.vv  v20, v4, v12
    lh t6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(a1)
    vadd.vv  v13, v5, v13
    vadd.vv  v14, v6, v14
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(a1)
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
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vmulh.vx v4, v4, t0
    vsub.vv  v13, v13, v1
    vsub.vv  v14, v14, v2
    vsub.vv  v15, v15, v3
    vsub.vv  v16, v16, v4
    vmulh.vx v5, v5, t0
    vadd.vv  v1, v9,  v13
    vmulh.vx v6, v6, t0
    vadd.vv  v2, v10, v14
    vmulh.vx v7, v7, t0
    vadd.vv  v3, v11, v15
    vmulh.vx v8, v8, t0
    lh t2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(a1)
    vadd.vv  v4, v12, v16
    vsub.vv  v21, v21, v5
    lh t1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(a1)
    vsub.vv  v22, v22, v6
    vsub.vv  v23, v23, v7
    lh t6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(a1)
    vsub.vv  v24, v24, v8
    vadd.vv  v5, v17, v21
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(a1)
    vadd.vv  v6, v18, v22
    vadd.vv  v7, v19, v23
    lh a3, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(a1)
    vadd.vv  v8, v20, v24
    vsub.vv  v9, v9,  v13
    lh a2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(a1)
    vsub.vv  v10, v10,v14
    vsub.vv  v11,v11, v15
    lh a5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(a1)
    vsub.vv  v12,v12, v16
    vsub.vv  v13,v17, v21
    lh a4, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(a1)
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
    vmulh.vx v17, v17, t0
    vmulh.vx v18, v18, t0
    vmulh.vx v19, v19, t0
    vmulh.vx v20, v20, t0
    vsub.vv  v3,  v3,  v17
    vsub.vv  v4,  v4,  v18
    vsub.vv  v11, v11, v19
    vsub.vv  v12, v12, v20
    vmulh.vx v21, v21, t0
    vadd.vv  v17, v1,  v3
    vmulh.vx v22, v22, t0
    vadd.vv  v18, v2,  v4
    vmulh.vx v23, v23, t0
    vadd.vv  v19, v9,  v11
    vmulh.vx v24, v24, t0
    lh t2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(a1)
    vadd.vv  v20, v10, v12
    vsub.vv  v7,  v7,  v21
    lh t1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(a1)
    vsub.vv  v8,  v8,  v22
    vsub.vv  v15, v15, v23
    lh t6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(a1)
    vsub.vv  v16, v16, v24
    vadd.vv  v21, v5,  v7
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(a1)
    vadd.vv  v22, v6,  v8
    vadd.vv  v23, v13, v15
    lh a3, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(a1)
    vadd.vv  v24, v14, v16
    vsub.vv  v1,  v1,  v3
    lh a2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(a1)
    vsub.vv  v2,  v2,  v4
    vsub.vv  v3,  v9,  v11
    lh a5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(a1)
    vsub.vv  v4,  v10, v12
    vsub.vv  v5,  v5,  v7
    lh a4, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(a1)
    vsub.vv  v6,  v6,  v8
    vsub.vv  v7,  v13, v15
    vsub.vv  v8,  v14, v16
    // v17,v18,v1,v2,v19,v20,v3,v4,v21,v22,v5,v6,v23,v24,v7,v8=a0~a127
    // level 4
    vmul.vx v9,  v18,  t2
    vmulh.vx v18, v18, t1
    lh t2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(a1)
    lh t1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(a1)
    vmul.vx v10, v2,   t6
    vmulh.vx v2,  v2,  t5
    lh t6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +10)*2(a1)
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +11)*2(a1)
    vmul.vx v11, v20,  a3
    vmulh.vx v20, v20, a2
    lh a3, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +12)*2(a1)
    lh a2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +13)*2(a1)
    vmul.vx v12, v4,   a5
    vmulh.vx v4,  v4,  a4
    lh a5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +14)*2(a1)
    lh a4, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +15)*2(a1)
    vmul.vx v13, v22,  t2
    vmulh.vx v22, v22, t1
    vmul.vx v14, v6,   t6
    vmulh.vx v6,  v6,  t5
    vmul.vx v15, v24,  a3
    vmulh.vx v24, v24, a2
    vmul.vx v16, v8,   a5
    vmulh.vx v8,  v8,  a4
    vmulh.vx v9,  v9,  t0
    vmulh.vx v10, v10, t0
    vmulh.vx v11, v11, t0
    vmulh.vx v12, v12, t0
    vsub.vv  v18, v18, v9
    vsub.vv  v2,  v2,  v10
    vsub.vv  v20, v20, v11
    vsub.vv  v4,  v4,  v12
    vmulh.vx v13, v13, t0
    vadd.vv  v9,  v17, v18
    vmulh.vx v14, v14, t0
    vadd.vv  v10, v1,  v2
    vmulh.vx v15, v15, t0
    vadd.vv  v11, v19, v20
    vmulh.vx v16, v16, t0
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
    addi t4, a1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L5 + \off*_ZETAS_EXP_1TO6_P1_L5)*2
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
    vmulh.vx v9,  v9,  t0
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v17, v17, t0
    vmul.vv  v10, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    vsub.vv  v2,  v2,  v9
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v10, v10, t0
    vmul.vv  v18, v8,  v27
    vmulh.vv v8,  v8,  v26
    vmulh.vx v18, v18, t0
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
    vmulh.vx v13, v13, t0
    vmul.vv  v21, v4,  v27
    vmulh.vv v4,  v4,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v21, v21, t0
    vmul.vv  v14, v6,  v27
    vmulh.vv v6,  v6,  v26
    addi t4, t4, 8*2;     vle16.v v27, (t4)
    addi t4, t4, 8*2;     vle16.v v26, (t4)
    vmulh.vx v14, v14, t0
    vmul.vv  v22, v8,  v27
    vmulh.vv v8,  v8,  v26
    vsub.vv  v2,  v2, v13
    vsub.vv  v4,  v4, v21
    vmulh.vx v22, v22, t0
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
    addi t4, a1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L6+ \off*_ZETAS_EXP_1TO6_P1_L6)*2
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
    vmulh.vx v9,  v9,  t0
    vmulh.vx v11, v11, t0
    vmulh.vx v17, v17, t0
    vmulh.vx v19, v19, t0
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
    vmulh.vx v13, v13, t0
    vmulh.vx v15, v15, t0
    vmulh.vx v21, v21, t0
    vmulh.vx v23, v23, t0
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
    addi t3, a0, (\off*128)*2 # a[0] or a[128]
    vse16.v  v1, (t3);   addi t3, t3, 16
    vse16.v  v2, (t3);   addi t3, t3, 16
    shuffle1 v5, v6, v10, v12, v27
    vse16.v  v3, (t3);   addi t3, t3, 16
    vse16.v  v4, (t3);   addi t3, t3, 16
    shuffle1 v7, v8, v18, v20, v27
    vse16.v  v5, (t3);   addi t3, t3, 16
    vse16.v  v6, (t3);   addi t3, t3, 16
    vse16.v  v7, (t3);   addi t3, t3, 16
    vse16.v  v8, (t3);   addi t3, a0, (64+\off*128)*2 # a[64] or a[192]
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
.endm

// register usage:
// t0 = Q
// t1/t2, t5/t6, a2/a3, a4/a5: zeta/zeta*qinv
// t3: address related to the input polynomial
// t4: address related to the pre-computed table
// v0: mask used for vmerge.vvm instruction
// v28~v31: masks used for shuffle4/2
.globl ntt_rvv
.align 2
ntt_rvv:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329
    ntt_rvv_level0
    // load some masks used by shuffle4/2/1
    addi t4, a1, _MASK_45674567*2
    vle16.v v31, (t4)
    addi t4, a1, _MASK_01230123*2
    vle16.v v30, (t4)
    addi t4, a1, _MASK_00010045*2
    vle16.v v29, (t4)
    addi t4, a1, _MASK_23006700*2
    vle16.v v28, (t4)
    ntt_rvv_level1to6 0
    ntt_rvv_level1to6 1
ret

// void poly_basemul_rvv(int16_t *r, const int16_t *a, const int16_t *b, const int16_t *table);
// (a0b0 + b1 * (a1zeta mod q)) mod q + ((a0b1 + a1b0) mod q)x
// (a2b2 + b3 * (a3zeta mod q)) mod q + ((a2b3 + a3b2) mod q)x
.globl poly_basemul_rvv
.align 2
poly_basemul_rvv:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329     // q
    li t1, -3327    // qinv
    addi t3, a3, _ZETAS_QINV_BASEMUL*2  // for loading zetaqinv
    addi t4, a3, _ZETAS_BASEMUL*2       // for loading zeta
    li   t5, 8
poly_basemul_rvv_loop:
    vle16.v v0, (a1);  addi a1, a1, 16 // a0
    vle16.v v1, (a1);  addi a1, a1, 16 // a1
    vle16.v v2, (a1);  addi a1, a1, 16 // a2
    vle16.v v3, (a1);  addi a1, a1, 16 // a3
    vle16.v v30, (t3); addi t3, t3, 16  // zetaqinv
    vle16.v v31, (t3); addi t3, t3, 16
    vle16.v v28, (t4); addi t4, t4, 16  // zeta
    vle16.v v29, (t4); addi t4, t4, 16
    vmul.vv  v4, v1, v30
    vmul.vv  v5, v3, v31
    vle16.v v8,  (a2);  addi a2, a2, 16 // b0
    vle16.v v9,  (a2);  addi a2, a2, 16 // b1
    vmulh.vv v6, v1, v28
    vmulh.vv v7, v3, v29
    vmulh.vx v4, v4, t0
    vmulh.vx v5, v5, t0
    vle16.v v10, (a2);  addi a2, a2, 16 // b2
    vle16.v v11, (a2);  addi a2, a2, 16 // b3
    vsub.vv  v4, v6, v4 // a1zeta mod q
    vsub.vv  v5, v7, v5 // a3zeta mod q
    vmul.vv  v12, v0, v8     // a0b0.lo
    vmul.vv  v13, v0, v9     // a0b1.lo
    vmul.vv  v14, v4, v9     // b1(a1zeta).lo
    vmul.vv  v15, v1, v8     // a1b0.lo
    vmulh.vv v16, v0, v8     // a0b0.hi
    vmulh.vv v17, v0, v9     // a0b1.hi
    vmulh.vv v18, v4, v9     // b1(a1zeta).hi
    vmulh.vv v19, v1, v8     // a1b0.hi
    vmul.vx  v12, v12, t1   // *qinv
    vmul.vx  v13, v13, t1   // *qinv
    vmul.vx  v14, v14, t1   // *qinv
    vmul.vx  v15, v15, t1   // *qinv
    vmulh.vx v12, v12, t0   // *q
    vmulh.vx v13, v13, t0   // *q
    vmulh.vx v14, v14, t0   // *q
    vmulh.vx v15, v15, t0   // *q
    vsub.vv  v12, v16, v12  // a0b0
    vsub.vv  v13, v17, v13  // a0b1
    vsub.vv  v14, v18, v14  // b1(a1zeta)
    vsub.vv  v15, v19, v15  // a1b0
    vadd.vv  v12, v12, v14
    vadd.vv  v13, v13, v15
    vse16.v  v12, (a0);     addi a0, a0, 16
    vse16.v  v13, (a0);     addi a0, a0, 16
    vmul.vv  v16, v2, v10   // a2b2.lo
    vmul.vv  v17, v2, v11   // a2b3.lo
    vmul.vv  v18, v5, v11   // b3(a3zeta).lo
    vmul.vv  v19, v3, v10   // a3b2.lo
    vmulh.vv v20, v2, v10   // a2b2.hi
    vmulh.vv v21, v2, v11   // a2b3.hi
    vmulh.vv v22, v5, v11   // b3(a3zeta).hi
    vmulh.vv v23, v3, v10   // a3b2.hi
    vmul.vx  v16, v16, t1   // *qinv
    vmul.vx  v17, v17, t1   // *qinv
    vmul.vx  v18, v18, t1   // *qinv
    vmul.vx  v19, v19, t1   // *qinv
    vmulh.vx v16, v16, t0   // *q
    vmulh.vx v17, v17, t0   // *q
    vmulh.vx v18, v18, t0   // *q
    vmulh.vx v19, v19, t0   // *q
    vsub.vv  v16, v20, v16  // a2b2
    vsub.vv  v17, v21, v17  // a2b3
    vsub.vv  v18, v22, v18  // b3(a3zeta)
    vsub.vv  v19, v23, v19  // a3b2
    vadd.vv  v16, v16, v18
    vadd.vv  v17, v17, v19
    vse16.v  v16, (a0);     addi a0, a0, 16
    vse16.v  v17, (a0);     addi a0, a0, 16
    addi t5, t5, -1
    bnez t5, poly_basemul_rvv_loop
ret

// void poly_basemul_acc_rvv(int16_t *r, const int16_t *a, const int16_t *b, const int16_t *table);
// (a0b0 + b1 * (a1zeta mod q)) mod q + ((a0b1 + a1b0) mod q)x
// (a2b2 + b3 * (a3zeta mod q)) mod q + ((a2b3 + a3b2) mod q)x
.globl poly_basemul_acc_rvv
.align 2
poly_basemul_acc_rvv:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329     // q
    li t1, -3327    // qinv
    addi t3, a3, _ZETAS_QINV_BASEMUL*2  // for loading zetaqinv
    addi t4, a3, _ZETAS_BASEMUL*2       // for loading zeta
    li   t5, 8
poly_basemul_acc_rvv_loop:
    vle16.v v0, (a1);  addi a1, a1, 16 // a0
    vle16.v v1, (a1);  addi a1, a1, 16 // a1
    vle16.v v2, (a1);  addi a1, a1, 16 // a2
    vle16.v v3, (a1);  addi a1, a1, 16 // a3
    vle16.v v30, (t3); addi t3, t3, 16  // zetaqinv
    vle16.v v31, (t3); addi t3, t3, 16
    vle16.v v28, (t4); addi t4, t4, 16  // zeta
    vle16.v v29, (t4); addi t4, t4, 16
    vmul.vv  v4, v1, v30
    vmul.vv  v5, v3, v31
    vle16.v v8,  (a2);  addi a2, a2, 16 // b0
    vle16.v v9,  (a2);  addi a2, a2, 16 // b1
    vmulh.vv v6, v1, v28
    vmulh.vv v7, v3, v29
    vmulh.vx v4, v4, t0
    vmulh.vx v5, v5, t0
    vle16.v v10, (a2);  addi a2, a2, 16 // b2
    vle16.v v11, (a2);  addi a2, a2, 16 // b3
    vsub.vv  v4, v6, v4 // a1zeta mod q
    vsub.vv  v5, v7, v5 // a3zeta mod q
    vmul.vv  v12, v0, v8     // a0b0.lo
    vmul.vv  v13, v0, v9     // a0b1.lo
    vmul.vv  v14, v4, v9     // b1(a1zeta).lo
    vmul.vv  v15, v1, v8     // a1b0.lo
    vmulh.vv v16, v0, v8     // a0b0.hi
    vmulh.vv v17, v0, v9     // a0b1.hi
    vmulh.vv v18, v4, v9     // b1(a1zeta).hi
    vmulh.vv v19, v1, v8     // a1b0.hi
    vmul.vx  v12, v12, t1   // *qinv
    vmul.vx  v13, v13, t1   // *qinv
    vmul.vx  v14, v14, t1   // *qinv
    vmul.vx  v15, v15, t1   // *qinv
    vmulh.vx v12, v12, t0   // *q
    vmulh.vx v13, v13, t0   // *q
    vmulh.vx v14, v14, t0   // *q
    vmulh.vx v15, v15, t0   // *q
    vle16.v  v24, (a0);     addi a0, a0, 16
    vle16.v  v25, (a0);     addi a0, a0, -16
    vsub.vv  v12, v16, v12  // a0b0
    vsub.vv  v13, v17, v13  // a0b1
    vsub.vv  v14, v18, v14  // b1(a1zeta)
    vsub.vv  v15, v19, v15  // a1b0
    vadd.vv  v12, v12, v14
    vadd.vv  v13, v13, v15
    vadd.vv  v12, v12, v24
    vadd.vv  v13, v13, v25
    vse16.v  v12, (a0);     addi a0, a0, 16
    vse16.v  v13, (a0);     addi a0, a0, 16
    vmul.vv  v16, v2, v10   // a2b2.lo
    vmul.vv  v17, v2, v11   // a2b3.lo
    vmul.vv  v18, v5, v11   // b3(a3zeta).lo
    vmul.vv  v19, v3, v10   // a3b2.lo
    vmulh.vv v20, v2, v10   // a2b2.hi
    vmulh.vv v21, v2, v11   // a2b3.hi
    vmulh.vv v22, v5, v11   // b3(a3zeta).hi
    vmulh.vv v23, v3, v10   // a3b2.hi
    vmul.vx  v16, v16, t1   // *qinv
    vmul.vx  v17, v17, t1   // *qinv
    vmul.vx  v18, v18, t1   // *qinv
    vmul.vx  v19, v19, t1   // *qinv
    vmulh.vx v16, v16, t0   // *q
    vmulh.vx v17, v17, t0   // *q
    vmulh.vx v18, v18, t0   // *q
    vmulh.vx v19, v19, t0   // *q
    vle16.v  v24, (a0);     addi a0, a0, 16
    vle16.v  v25, (a0);     addi a0, a0, -16
    vsub.vv  v16, v20, v16  // a2b2
    vsub.vv  v17, v21, v17  // a2b3
    vsub.vv  v18, v22, v18  // b3(a3zeta)
    vsub.vv  v19, v23, v19  // a3b2
    vadd.vv  v16, v16, v18
    vadd.vv  v17, v17, v19
    vadd.vv  v16, v16, v24
    vadd.vv  v17, v17, v25
    vse16.v  v16, (a0);     addi a0, a0, 16
    vse16.v  v17, (a0);     addi a0, a0, 16
    addi t5, t5, -1
    bnez t5, poly_basemul_acc_rvv_loop
ret

// void poly_basemul_acc_double_rvv(int32_t *r, const int16_t *a, const int16_t *b, const int16_t *table);
# .globl poly_basemul_acc_double_rvv
# .align 2
# poly_basemul_acc_double_rvv:
#     li t0, 3329     // q
#     li t1, -3327    // qinv
#     addi t3, a3, _ZETAS_QINV_BASEMUL*2  // for loading zetaqinv
#     addi t4, a3, _ZETAS_BASEMUL*2       // for loading zeta
#     li   t5, 8
# poly_basemul_acc_double_rvv_loop:
#     li t1, 128
#     vsetvli t2, t1, e32, m1, tu, mu
#     vle32.v v0, (a0);       addi a0, a0, 4*4
#     vle32.v v1, (a0);       addi a0, a0, 4*4
#     vle32.v v2, (a0);       addi a0, a0, 4*4
#     vle32.v v3, (a0);       addi a0, a0, 4*4

#     addi t5, t5, -1
#     bnez t5, poly_basemul_acc_double_rvv_loop

// void poly_basemul_cache_init_rvv(int16_t *r, const int16_t *a, const int16_t *b, const int16_t *table, int16_t *b_cache);
// basemul and store b1zeta, b3zeta, ... into b_cache
// (a0b0 + a1 * (b1zeta mod q)) mod q + ((a0b1 + a1b0) mod q)x
// (a2b2 + a3 * (b3zeta mod q)) mod q + ((a2b3 + a3b2) mod q)x
.globl poly_basemul_cache_init_rvv
.align 2
poly_basemul_cache_init_rvv:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329     // q
    li t1, -3327    // qinv
    addi t3, a3, _ZETAS_QINV_BASEMUL*2  // for loading zetaqinv
    addi t4, a3, _ZETAS_BASEMUL*2       // for loading zeta
    li   t5, 8
poly_basemul_cache_init_rvv_loop:
    vle16.v v0, (a2);  addi a2, a2, 16      // b0
    vle16.v v1, (a2);  addi a2, a2, 16      // b1
    vle16.v v2, (a2);  addi a2, a2, 16      // b2
    vle16.v v3, (a2);  addi a2, a2, 16      // b3
    vle16.v v30, (t3); addi t3, t3, 16      // zetaqinv
    vle16.v v31, (t3); addi t3, t3, 16
    vle16.v v28, (t4); addi t4, t4, 16      // zeta
    vle16.v v29, (t4); addi t4, t4, 16
    vmul.vv  v4, v1, v30
    vmul.vv  v5, v3, v31
    vle16.v v8,  (a1);  addi a1, a1, 16 // a0
    vle16.v v9,  (a1);  addi a1, a1, 16 // a1
    vmulh.vv v6, v1, v28
    vmulh.vv v7, v3, v29
    vmulh.vx v4, v4, t0
    vmulh.vx v5, v5, t0
    vle16.v v10, (a1);  addi a1, a1, 16 // a2
    vle16.v v11, (a1);  addi a1, a1, 16 // a3
    vsub.vv  v4, v6, v4     // b1zeta mod q
    vsub.vv  v5, v7, v5     // b3zeta mod q
    vse16.v  v4, (a4);  addi a4, a4, 16
    vse16.v  v5, (a4);  addi a4, a4, 16
    vmul.vv  v12, v0, v8     // b0a0.lo
    vmul.vv  v13, v0, v9     // b0a1.lo
    vmul.vv  v14, v4, v9     // a1(b1zeta).lo
    vmul.vv  v15, v1, v8     // b1a0.lo
    vmulh.vv v16, v0, v8     // b0a0.hi
    vmulh.vv v17, v0, v9     // b0a1.hi
    vmulh.vv v18, v4, v9     // a1(b1zeta).hi
    vmulh.vv v19, v1, v8     // b1a0.hi
    vmul.vx  v12, v12, t1   // *qinv
    vmul.vx  v13, v13, t1   // *qinv
    vmul.vx  v14, v14, t1   // *qinv
    vmul.vx  v15, v15, t1   // *qinv
    vmulh.vx v12, v12, t0   // *q
    vmulh.vx v13, v13, t0   // *q
    vmulh.vx v14, v14, t0   // *q
    vmulh.vx v15, v15, t0   // *q
    vsub.vv  v12, v16, v12  // b0a0
    vsub.vv  v13, v17, v13  // b0a1
    vsub.vv  v14, v18, v14  // a1(b1zeta)
    vsub.vv  v15, v19, v15  // b1a0
    vadd.vv  v12, v12, v14  // b0a0+a1(b1zeta)
    vadd.vv  v13, v13, v15  // b0a1+b1a0
    vse16.v  v12, (a0);     addi a0, a0, 16
    vse16.v  v13, (a0);     addi a0, a0, 16
    vmul.vv  v16, v2, v10   // b2a2.lo
    vmul.vv  v17, v2, v11   // b2a3.lo
    vmul.vv  v18, v5, v11   // a3(b3zeta).lo
    vmul.vv  v19, v3, v10   // b3a2.lo
    vmulh.vv v20, v2, v10   // b2a2.hi
    vmulh.vv v21, v2, v11   // b2a3.hi
    vmulh.vv v22, v5, v11   // a3(b3zeta).hi
    vmulh.vv v23, v3, v10   // b3a2.hi
    vmul.vx  v16, v16, t1   // *qinv
    vmul.vx  v17, v17, t1   // *qinv
    vmul.vx  v18, v18, t1   // *qinv
    vmul.vx  v19, v19, t1   // *qinv
    vmulh.vx v16, v16, t0   // *q
    vmulh.vx v17, v17, t0   // *q
    vmulh.vx v18, v18, t0   // *q
    vmulh.vx v19, v19, t0   // *q
    vsub.vv  v16, v20, v16  // b2a2
    vsub.vv  v17, v21, v17  // b2a3
    vsub.vv  v18, v22, v18  // a3(b3zeta)
    vsub.vv  v19, v23, v19  // b3a2
    vadd.vv  v16, v16, v18
    vadd.vv  v17, v17, v19
    vse16.v  v16, (a0);     addi a0, a0, 16
    vse16.v  v17, (a0);     addi a0, a0, 16
    addi t5, t5, -1
    bnez t5, poly_basemul_cache_init_rvv_loop
ret

// void poly_basemul_acc_cache_init_rvv(int16_t *r, const int16_t *a, const int16_t *b, const int16_t *table, int16_t *b_cache);
// basemul_acc and store b1zeta, b3zeta, ... into b_cache
// (a0b0 + a1 * (b1zeta mod q)) mod q + ((a0b1 + a1b0) mod q)x
// (a2b2 + a3 * (b3zeta mod q)) mod q + ((a2b3 + a3b2) mod q)x
.globl poly_basemul_acc_cache_init_rvv
.align 2
poly_basemul_acc_cache_init_rvv:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329     // q
    li t1, -3327    // qinv
    addi t3, a3, _ZETAS_QINV_BASEMUL*2  // for loading zetaqinv
    addi t4, a3, _ZETAS_BASEMUL*2       // for loading zeta
    li   t5, 8
poly_basemul_acc_cache_init_rvv_loop:
    vle16.v v0, (a2);  addi a2, a2, 16      // b0
    vle16.v v1, (a2);  addi a2, a2, 16      // b1
    vle16.v v2, (a2);  addi a2, a2, 16      // b2
    vle16.v v3, (a2);  addi a2, a2, 16      // b3
    vle16.v v30, (t3); addi t3, t3, 16      // zetaqinv
    vle16.v v31, (t3); addi t3, t3, 16
    vle16.v v28, (t4); addi t4, t4, 16      // zeta
    vle16.v v29, (t4); addi t4, t4, 16
    vmul.vv  v4, v1, v30
    vmul.vv  v5, v3, v31
    vle16.v v8,  (a1);  addi a1, a1, 16 // a0
    vle16.v v9,  (a1);  addi a1, a1, 16 // a1
    vmulh.vv v6, v1, v28
    vmulh.vv v7, v3, v29
    vmulh.vx v4, v4, t0
    vmulh.vx v5, v5, t0
    vle16.v v10, (a1);  addi a1, a1, 16 // a2
    vle16.v v11, (a1);  addi a1, a1, 16 // a3
    vsub.vv  v4, v6, v4     // b1zeta mod q
    vsub.vv  v5, v7, v5     // b3zeta mod q
    vse16.v  v4, (a4);  addi a4, a4, 16
    vse16.v  v5, (a4);  addi a4, a4, 16
    vmul.vv  v12, v0, v8     // b0a0.lo
    vmul.vv  v13, v0, v9     // b0a1.lo
    vmul.vv  v14, v4, v9     // a1(b1zeta).lo
    vmul.vv  v15, v1, v8     // b1a0.lo
    vmulh.vv v16, v0, v8     // b0a0.hi
    vmulh.vv v17, v0, v9     // b0a1.hi
    vmulh.vv v18, v4, v9     // a1(b1zeta).hi
    vmulh.vv v19, v1, v8     // b1a0.hi
    vmul.vx  v12, v12, t1   // *qinv
    vmul.vx  v13, v13, t1   // *qinv
    vmul.vx  v14, v14, t1   // *qinv
    vmul.vx  v15, v15, t1   // *qinv
    vle16.v  v24, (a0);     addi a0, a0, 16
    vle16.v  v25, (a0);     addi a0, a0, -16
    vmulh.vx v12, v12, t0   // *q
    vmulh.vx v13, v13, t0   // *q
    vmulh.vx v14, v14, t0   // *q
    vmulh.vx v15, v15, t0   // *q
    vsub.vv  v12, v16, v12  // b0a0
    vsub.vv  v13, v17, v13  // b0a1
    vsub.vv  v14, v18, v14  // a1(b1zeta)
    vsub.vv  v15, v19, v15  // b1a0
    vadd.vv  v12, v12, v14  // b0a0+a1(b1zeta)
    vadd.vv  v13, v13, v15  // b0a1+b1a0
    vadd.vv  v12, v12, v24
    vadd.vv  v13, v13, v25
    vse16.v  v12, (a0);     addi a0, a0, 16
    vse16.v  v13, (a0);     addi a0, a0, 16
    vmul.vv  v16, v2, v10   // b2a2.lo
    vmul.vv  v17, v2, v11   // b2a3.lo
    vmul.vv  v18, v5, v11   // a3(b3zeta).lo
    vmul.vv  v19, v3, v10   // b3a2.lo
    vmulh.vv v20, v2, v10   // b2a2.hi
    vmulh.vv v21, v2, v11   // b2a3.hi
    vmulh.vv v22, v5, v11   // a3(b3zeta).hi
    vmulh.vv v23, v3, v10   // b3a2.hi
    vmul.vx  v16, v16, t1   // *qinv
    vmul.vx  v17, v17, t1   // *qinv
    vmul.vx  v18, v18, t1   // *qinv
    vmul.vx  v19, v19, t1   // *qinv
    vle16.v  v24, (a0);     addi a0, a0, 16
    vle16.v  v25, (a0);     addi a0, a0, -16
    vmulh.vx v16, v16, t0   // *q
    vmulh.vx v17, v17, t0   // *q
    vmulh.vx v18, v18, t0   // *q
    vmulh.vx v19, v19, t0   // *q
    vsub.vv  v16, v20, v16  // b2a2
    vsub.vv  v17, v21, v17  // b2a3
    vsub.vv  v18, v22, v18  // a3(b3zeta)
    vsub.vv  v19, v23, v19  // b3a2
    vadd.vv  v16, v16, v18
    vadd.vv  v17, v17, v19
    vadd.vv  v16, v16, v24
    vadd.vv  v17, v17, v25
    vse16.v  v16, (a0);     addi a0, a0, 16
    vse16.v  v17, (a0);     addi a0, a0, 16
    addi t5, t5, -1
    bnez t5, poly_basemul_acc_cache_init_rvv_loop
ret

// void poly_basemul_cached_rvv(int16_t *r, const int16_t *a, const int16_t *b, const int16_t *table, int16_t *b_cache);
// basemul; b1zeta and b3zeta have been cached
// (a0b0 + a1 * (b1zeta mod q)) mod q + ((a0b1 + a1b0) mod q)x
// (a2b2 + a3 * (b3zeta mod q)) mod q + ((a2b3 + a3b2) mod q)x
.globl poly_basemul_cached_rvv
.align 2
poly_basemul_cached_rvv:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329     // q
    li t1, -3327    // qinv
    li t5, 8
poly_basemul_cached_rvv_loop:
    vle16.v v0, (a1);   addi a1, a1, 16 // a0
    vle16.v v1, (a1);   addi a1, a1, 16 // a1
    vle16.v v2, (a1);   addi a1, a1, 16 // a2
    vle16.v v3, (a1);   addi a1, a1, 16 // a3
    vle16.v v8,  (a2);  addi a2, a2, 16 // b0
    vle16.v v9,  (a2);  addi a2, a2, 16 // b1
    vle16.v v10, (a2);  addi a2, a2, 16 // b2
    vle16.v v11, (a2);  addi a2, a2, 16 // b3
    vle16.v v4,  (a4);  addi a4, a4, 16 // b1zeta
    vle16.v v5,  (a4);  addi a4, a4, 16 // b3zeta
    vmul.vv  v12, v0, v8        // a0b0.lo
    vmul.vv  v13, v0, v9        // a0b1.lo
    vmul.vv  v14, v1, v4        // a1(b1zeta).lo
    vmul.vv  v15, v1, v8        // a1b0.lo
    vmulh.vv v16, v0, v8        // a0b0.hi
    vmulh.vv v17, v0, v9        // a0b1.hi
    vmulh.vv v18, v1, v4        // a1(b1zeta).hi
    vmulh.vv v19, v1, v8        // a1b0.hi
    vmul.vx  v12, v12, t1       // *qinv
    vmul.vx  v13, v13, t1       // *qinv
    vmul.vx  v14, v14, t1       // *qinv
    vmul.vx  v15, v15, t1       // *qinv
    vmulh.vx v12, v12, t0       // *q
    vmulh.vx v13, v13, t0       // *q
    vmulh.vx v14, v14, t0       // *q
    vmulh.vx v15, v15, t0       // *q
    vsub.vv  v12, v16, v12      // a0b0
    vsub.vv  v13, v17, v13      // a0b1
    vsub.vv  v14, v18, v14      // b1(a1zeta)
    vsub.vv  v15, v19, v15      // a1b0
    vadd.vv  v12, v12, v14
    vadd.vv  v13, v13, v15
    vse16.v  v12, (a0);     addi a0, a0, 16
    vse16.v  v13, (a0);     addi a0, a0, 16
    vmul.vv  v16, v2, v10       // a2b2.lo
    vmul.vv  v17, v2, v11       // a2b3.lo
    vmul.vv  v18, v3, v5        // a3(b3zeta).lo
    vmul.vv  v19, v3, v10       // a3b2.lo
    vmulh.vv v20, v2, v10       // a2b2.hi
    vmulh.vv v21, v2, v11       // a2b3.hi
    vmulh.vv v22, v3, v5        // a3(b3zeta).hi
    vmulh.vv v23, v3, v10       // a3b2.hi
    vmul.vx  v16, v16, t1       // *qinv
    vmul.vx  v17, v17, t1       // *qinv
    vmul.vx  v18, v18, t1       // *qinv
    vmul.vx  v19, v19, t1       // *qinv
    vmulh.vx v16, v16, t0       // *q
    vmulh.vx v17, v17, t0       // *q
    vmulh.vx v18, v18, t0       // *q
    vmulh.vx v19, v19, t0       // *q
    vsub.vv  v16, v20, v16      // a2b2
    vsub.vv  v17, v21, v17      // a2b3
    vsub.vv  v18, v22, v18      // b3(a3zeta)
    vsub.vv  v19, v23, v19      // a3b2
    vadd.vv  v16, v16, v18
    vadd.vv  v17, v17, v19
    vse16.v  v16, (a0);     addi a0, a0, 16
    vse16.v  v17, (a0);     addi a0, a0, 16
    addi t5, t5, -1
    bnez t5, poly_basemul_cached_rvv_loop
ret

// void poly_basemul_acc_cached_rvv(int16_t *r, const int16_t *a, const int16_t *b, const int16_t *table, int16_t *b_cache);
// basemul_acc; b1zeta and b3zeta have been cached
// (a0b0 + a1 * (b1zeta mod q)) mod q + ((a0b1 + a1b0) mod q)x
// (a2b2 + a3 * (b3zeta mod q)) mod q + ((a2b3 + a3b2) mod q)x
.globl poly_basemul_acc_cached_rvv
.align 2
poly_basemul_acc_cached_rvv:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329     // q
    li t1, -3327    // qinv
    li t5, 8
poly_basemul_acc_cached_rvv_loop:
    vle16.v v0, (a1);   addi a1, a1, 16 // a0
    vle16.v v1, (a1);   addi a1, a1, 16 // a1
    vle16.v v2, (a1);   addi a1, a1, 16 // a2
    vle16.v v3, (a1);   addi a1, a1, 16 // a3
    vle16.v v8,  (a2);  addi a2, a2, 16 // b0
    vle16.v v9,  (a2);  addi a2, a2, 16 // b1
    vle16.v v10, (a2);  addi a2, a2, 16 // b2
    vle16.v v11, (a2);  addi a2, a2, 16 // b3
    vle16.v v4,  (a4);  addi a4, a4, 16 // b1zeta
    vle16.v v5,  (a4);  addi a4, a4, 16 // b3zeta
    vmul.vv  v12, v0, v8        // a0b0.lo
    vmul.vv  v13, v0, v9        // a0b1.lo
    vmul.vv  v14, v1, v4        // a1(b1zeta).lo
    vmul.vv  v15, v1, v8        // a1b0.lo
    vmulh.vv v16, v0, v8        // a0b0.hi
    vmulh.vv v17, v0, v9        // a0b1.hi
    vmulh.vv v18, v1, v4        // a1(b1zeta).hi
    vmulh.vv v19, v1, v8        // a1b0.hi
    vmul.vx  v12, v12, t1       // *qinv
    vmul.vx  v13, v13, t1       // *qinv
    vmul.vx  v14, v14, t1       // *qinv
    vmul.vx  v15, v15, t1       // *qinv
    vmulh.vx v12, v12, t0       // *q
    vmulh.vx v13, v13, t0       // *q
    vmulh.vx v14, v14, t0       // *q
    vmulh.vx v15, v15, t0       // *q
    vle16.v  v24, (a0);     addi a0, a0, 16
    vle16.v  v25, (a0);     addi a0, a0, -16
    vsub.vv  v12, v16, v12      // a0b0
    vsub.vv  v13, v17, v13      // a0b1
    vsub.vv  v14, v18, v14      // b1(a1zeta)
    vsub.vv  v15, v19, v15      // a1b0
    vadd.vv  v12, v12, v14
    vadd.vv  v13, v13, v15
    vadd.vv  v12, v12, v24
    vadd.vv  v13, v13, v25
    vse16.v  v12, (a0);     addi a0, a0, 16
    vse16.v  v13, (a0);     addi a0, a0, 16
    vmul.vv  v16, v2, v10       // a2b2.lo
    vmul.vv  v17, v2, v11       // a2b3.lo
    vmul.vv  v18, v3, v5        // a3(b3zeta).lo
    vmul.vv  v19, v3, v10       // a3b2.lo
    vmulh.vv v20, v2, v10       // a2b2.hi
    vmulh.vv v21, v2, v11       // a2b3.hi
    vmulh.vv v22, v3, v5        // a3(b3zeta).hi
    vmulh.vv v23, v3, v10       // a3b2.hi
    vmul.vx  v16, v16, t1       // *qinv
    vmul.vx  v17, v17, t1       // *qinv
    vmul.vx  v18, v18, t1       // *qinv
    vmul.vx  v19, v19, t1       // *qinv
    vmulh.vx v16, v16, t0       // *q
    vmulh.vx v17, v17, t0       // *q
    vmulh.vx v18, v18, t0       // *q
    vmulh.vx v19, v19, t0       // *q
    vle16.v  v24, (a0);     addi a0, a0, 16
    vle16.v  v25, (a0);     addi a0, a0, -16
    vsub.vv  v16, v20, v16      // a2b2
    vsub.vv  v17, v21, v17      // a2b3
    vsub.vv  v18, v22, v18      // b3(a3zeta)
    vsub.vv  v19, v23, v19      // a3b2
    vadd.vv  v16, v16, v18
    vadd.vv  v17, v17, v19
    vadd.vv  v16, v16, v24
    vadd.vv  v17, v17, v25
    vse16.v  v16, (a0);     addi a0, a0, 16
    vse16.v  v17, (a0);     addi a0, a0, 16
    addi t5, t5, -1
    bnez t5, poly_basemul_acc_cached_rvv_loop
ret

.macro intt_rvv_level0to5 off
    // level 0
    addi t3, a0, (\off*128)*2 # a[0] or a[128]
    addi t4, a1, _MASK_10101010*2   # for shuffle1
    vle16.v v0, (t4)
    addi t4, a1, _MASK_10325476*2
    vle16.v v27, (t4)
    vle16.v v9,  (t3);  addi t3, t3, 16
    vle16.v v10, (t3);  addi t3, t3, 16
    vle16.v v11, (t3);  addi t3, t3, 16
    vle16.v v12, (t3);  addi t3, t3, 16
    li t1, 1441     // mont^2/128
    li t2, -10079   // qinv(mont^2/128)
    li t5, ((1-\off)*_ZETA_EXP_INTT_0TO5_P0_L0+ \off*_ZETA_EXP_INTT_0TO5_P1_L0)*2
    add t4, a1, t5
    shuffle1 v1, v2, v9, v10, v27
    shuffle1 v3, v4, v11,v12, v27
    vmul.vx  v9,  v1, t2
    vmul.vx  v10, v2, t2
    vmul.vx  v11, v3, t2
    vmul.vx  v12, v4, t2
    vmulh.vx v1, v1, t1
    vmulh.vx v2, v2, t1
    vmulh.vx v3, v3, t1
    vmulh.vx v4, v4, t1
    vmulh.vx v9,  v9,  t0
    vmulh.vx v10, v10, t0
    vmulh.vx v11, v11, t0
    vmulh.vx v12, v12, t0
    vle16.v v13, (t3);  addi t3, t3, 16
    vle16.v v14, (t3);  addi t3, t3, 16
    vsub.vv  v1, v1, v9
    vsub.vv  v2, v2, v10
    vle16.v v15, (t3);  addi t3, t3, 16
    vle16.v v16, (t3);  addi t3, t3, 16
    vsub.vv  v3, v3, v11
    vsub.vv  v4, v4, v12
    shuffle1 v5, v6, v13, v14, v27
    shuffle1 v7, v8, v15, v16, v27
    vmul.vx  v13, v5, t2
    vmul.vx  v14, v6, t2
    vmul.vx  v15, v7, t2
    vmul.vx  v16, v8, t2
    vmulh.vx v5, v5, t1
    vmulh.vx v6, v6, t1
    vmulh.vx v7, v7, t1
    vmulh.vx v8, v8, t1
    vmulh.vx v13, v13,  t0
    vmulh.vx v14, v14, t0
    vmulh.vx v15, v15, t0
    vmulh.vx v16, v16, t0
    vsub.vv  v5, v5, v13
    vsub.vv  v6, v6, v14
    vsub.vv  v7, v7, v15
    vsub.vv  v8, v8, v16
    vle16.v v26, (t4);  addi t4, t4, 16
    vle16.v v25, (t4);  addi t4, t4, 16
    vle16.v v24, (t4);  addi t4, t4, 16
    vle16.v v23, (t4);  addi t4, t4, 16
    vadd.vv v9,  v1,  v2
    vsub.vv v10, v1,  v2
    vadd.vv v11, v3,  v4
    vsub.vv v12, v3,  v4
    vadd.vv v13, v5,  v6
    vsub.vv v14, v5,  v6
    vadd.vv v15, v7,  v8
    vsub.vv v16, v7,  v8
    vmul.vv v1, v10, v26
    vmulh.vv v10, v10, v25
    vle16.v v26, (t4);  addi t4, t4, 16
    vle16.v v25, (t4);  addi t4, t4, 16
    vmul.vv v2, v12, v24
    vmulh.vv v12, v12, v23
    vle16.v v24, (t4);  addi t4, t4, 16
    vle16.v v23, (t4);  addi t4, t4, 16
    vmul.vv v3, v14, v26
    vmulh.vv v14, v14, v25
    vmul.vv v4, v16, v24
    vmulh.vv v16, v16, v23
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vmulh.vx v4, v4, t0
    vle16.v v17, (t3);  addi t3, t3, 16
    vle16.v v18, (t3);  addi t3, t3, 16
    vsub.vv  v10, v10, v1
    vsub.vv  v12, v12, v2
    vle16.v v19, (t3);  addi t3, t3, 16
    vle16.v v20, (t3);  addi t3, t3, 16
    vsub.vv  v14, v14, v3
    vsub.vv  v16, v16, v4
    // v9,v10,v11,v12,v13,v14,v15,v16
    shuffle1 v1, v2, v17, v18, v27
    shuffle1 v3, v4, v19, v20, v27
    vmul.vx  v17, v1, t2
    vmul.vx  v18, v2, t2
    vmul.vx  v19, v3, t2
    vmul.vx  v20, v4, t2
    vmulh.vx v1, v1, t1
    vmulh.vx v2, v2, t1
    vmulh.vx v3, v3, t1
    vmulh.vx v4, v4, t1
    vmulh.vx v17, v17,  t0
    vmulh.vx v18, v18, t0
    vmulh.vx v19, v19, t0
    vmulh.vx v20, v20, t0
    vle16.v v21, (t3);  addi t3, t3, 16
    vle16.v v22, (t3);  addi t3, t3, 16
    vsub.vv  v1, v1, v17
    vsub.vv  v2, v2, v18
    vle16.v v23, (t3);  addi t3, t3, 16
    vle16.v v24, (t3);  addi t3, t3, 16
    vsub.vv  v3, v3, v19
    vsub.vv  v4, v4, v20
    shuffle1 v5, v6, v21, v22, v27
    shuffle1 v7, v8, v23, v24, v27
    vmul.vx  v21, v5, t2
    vmul.vx  v22, v6, t2
    vmul.vx  v23, v7, t2
    vmul.vx  v24, v8, t2
    vmulh.vx v5, v5, t1
    vmulh.vx v6, v6, t1
    vmulh.vx v7, v7, t1
    vmulh.vx v8, v8, t1
    vmulh.vx v21, v21,  t0
    vmulh.vx v22, v22, t0
    vmulh.vx v23, v23, t0
    vmulh.vx v24, v24, t0
    vsub.vv  v5, v5, v21
    vsub.vv  v6, v6, v22
    vsub.vv  v7, v7, v23
    vsub.vv  v8, v8, v24
    vle16.v v26, (t4);  addi t4, t4, 16
    vle16.v v25, (t4);  addi t4, t4, 16
    vadd.vv v17, v1, v2
    vsub.vv v18, v1, v2
    vadd.vv v19, v3, v4
    vsub.vv v20, v3, v4
    vadd.vv v21, v5, v6
    vsub.vv v22, v5, v6
    vadd.vv v23, v7, v8
    vsub.vv v24, v7, v8
    vmul.vv  v1,  v18, v26
    vmulh.vv v18, v18, v25
    vle16.v v26, (t4);  addi t4, t4, 16
    vle16.v v25, (t4);  addi t4, t4, 16
    vmul.vv  v2,  v20, v26
    vmulh.vv v20, v20, v25
    vle16.v v26, (t4);  addi t4, t4, 16
    vle16.v v25, (t4);  addi t4, t4, 16
    vmul.vv  v3,  v22, v26
    vmulh.vv v22, v22, v25
    vle16.v v26, (t4);  addi t4, t4, 16
    vle16.v v25, (t4)
    vmul.vv  v4,  v24, v26
    vmulh.vv v24, v24, v25
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vmulh.vx v4, v4, t0
    vsub.vv  v18, v18, v1
    vsub.vv  v20, v20, v2
    addi t4, a1, _MASK_11001100*2
    vle16.v v0, (t4)
    vsub.vv  v22, v22, v3
    vsub.vv  v24, v24, v4
    // v9, v10,v11,v12,v13,v14,v15,v16
    // v17,v18,v19,v20,v21,v22,v23,v24
    // level1
    shuffle2 v1, v2, v9,  v10, v29, v28
    shuffle2 v3, v4, v11, v12, v29, v28
    li t5, ((1-\off)*_ZETA_EXP_INTT_0TO5_P0_L1+ \off*_ZETA_EXP_INTT_0TO5_P1_L1)*2
    add t4, a1, t5
    shuffle2 v5, v6, v13, v14, v29, v28
    shuffle2 v7, v8, v15, v16, v29, v28
    vadd.vv v9,  v1, v2
    vsub.vv v10, v1, v2
    vadd.vv v11, v3, v4
    vsub.vv v12, v3, v4
    vle16.v v27, (t4);  addi t4, t4, 16
    vle16.v v26, (t4);  addi t4, t4, 16
    vadd.vv v13, v5, v6
    vsub.vv v14, v5, v6
    vadd.vv v15, v7, v8
    vsub.vv v16, v7, v8
    vmul.vv  v1,  v10, v27
    vmulh.vv v10, v10, v26
    vle16.v v27, (t4);  addi t4, t4, 16
    vle16.v v26, (t4);  addi t4, t4, 16
    vmul.vv  v2,  v12, v27
    vmulh.vv v12, v12, v26
    vle16.v v27, (t4);  addi t4, t4, 16
    vle16.v v26, (t4);  addi t4, t4, 16
    vmul.vv  v3,  v14, v27
    vmulh.vv v14, v14, v26
    vle16.v v27, (t4);  addi t4, t4, 16
    vle16.v v26, (t4);  addi t4, t4, 16
    vmul.vv  v4,  v16, v27
    vmulh.vv v16, v16, v26
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vmulh.vx v4, v4, t0
    vsub.vv  v10, v10, v1
    vsub.vv  v12, v12, v2
    shuffle2 v1, v2, v17, v18, v29, v28
    vsub.vv  v14, v14, v3
    vsub.vv  v16, v16, v4
    // v9,v10,v11,v12,v13,v14,v15,v16
    shuffle2 v3, v4, v19, v20, v29, v28
    vadd.vv v17, v1, v2
    vsub.vv v18, v1, v2
    shuffle2 v5, v6, v21, v22, v29, v28
    vadd.vv v19, v3, v4
    vsub.vv v20, v3, v4
    shuffle2 v7, v8, v23, v24, v29, v28
    vle16.v v27, (t4);  addi t4, t4, 16
    vle16.v v26, (t4);  addi t4, t4, 16
    vadd.vv v21, v5, v6
    vsub.vv v22, v5, v6
    vadd.vv v23, v7, v8
    vsub.vv v24, v7, v8
    vmul.vv  v1,  v18, v27
    vmulh.vv v18, v18, v26
    vle16.v v27, (t4);  addi t4, t4, 16
    vle16.v v26, (t4);  addi t4, t4, 16
    vmul.vv  v2,  v20, v27
    vmulh.vv v20, v20, v26
    vle16.v v27, (t4);  addi t4, t4, 16
    vle16.v v26, (t4);  addi t4, t4, 16
    vmul.vv  v3,  v22, v27
    vmulh.vv v22, v22, v26
    vle16.v v27, (t4);  addi t4, t4, 16
    vle16.v v26, (t4)
    vmul.vv  v4,  v24, v27
    vmulh.vv v24, v24, v26
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vmulh.vx v4, v4, t0
    vsub.vv  v18, v18, v1
    vsub.vv  v20, v20, v2
    vsub.vv  v22, v22, v3
    vsub.vv  v24, v24, v4
    // v9, v10,v11,v12,v13,v14,v15,v16
    // v17,v18,v19,v20,v21,v22,v23,v24
    // level 2
    addi t4, a1, _MASK_11110000*2
    vle16.v v0, (t4)
    li t5, ((1-\off)*_ZETA_EXP_INTT_0TO5_P0_L2+ \off*_ZETA_EXP_INTT_0TO5_P1_L2)*2
    add t4, a1, t5
    shuffle4 v1, v2, v9,  v10, v31, v30
    lh t2, 0*2(t4);     lh t1, 1*2(t4)
    lh t6, 2*2(t4);     lh t5, 3*2(t4)
    shuffle4 v3, v4, v11, v12, v31, v30
    lh a3, 4*2(t4);     lh a2, 5*2(t4)
    lh a5, 6*2(t4);     lh a4, 7*2(t4)
    shuffle4 v5, v6, v13, v14, v31, v30
    vadd.vv v9,  v1, v2
    vsub.vv v10, v1, v2
    shuffle4 v7, v8, v15, v16, v31, v30
    vadd.vv v11, v3, v4
    vsub.vv v12, v3, v4
    vadd.vv v13, v5, v6
    vsub.vv v14, v5, v6
    vadd.vv v15, v7, v8
    vsub.vv v16, v7, v8
    vmul.vx  v1,  v10, t2
    vmulh.vx v10, v10, t1
    vmul.vx  v2,  v12, t6
    vmulh.vx v12, v12, t5
    vmul.vx  v3,  v14, a3
    vmulh.vx v14, v14, a2
    vmul.vx  v4,  v16, a5
    vmulh.vx v16, v16, a4
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vmulh.vx v4, v4, t0
    vsub.vv  v10, v10, v1
    vsub.vv  v12, v12, v2
    vsub.vv  v14, v14, v3
    vsub.vv  v16, v16, v4
    // v9,v10,v11,v12,v13,v14,v15,v16
    shuffle4 v1, v2, v17, v18, v31, v30
    lh t2, 8*2(t4);         lh t1, 9*2(t4)
    lh t6, 10*2(t4);        lh t5, 11*2(t4)
    shuffle4 v3, v4, v19, v20, v31, v30
    lh a3, 12*2(t4);        lh a2, 13*2(t4)
    lh a5, 14*2(t4);        lh a4, 15*2(t4)
    shuffle4 v5, v6, v21, v22, v31, v30
    vadd.vv v17, v1, v2
    vsub.vv v18, v1, v2
    shuffle4 v7, v8, v23, v24, v31, v30
    vadd.vv v19, v3, v4
    vsub.vv v20, v3, v4
    vadd.vv v21, v5, v6
    vsub.vv v22, v5, v6
    vadd.vv v23, v7, v8
    vsub.vv v24, v7, v8
    vmul.vx  v1,  v18, t2
    vmulh.vx v18, v18, t1
    vmul.vx  v2,  v20, t6
    vmulh.vx v20, v20, t5
    vmul.vx  v3,  v22, a3
    vmulh.vx v22, v22, a2
    vmul.vx  v4,  v24, a5
    vmulh.vx v24, v24, a4
    vmulh.vx v1, v1, t0
    vmulh.vx v2, v2, t0
    vmulh.vx v3, v3, t0
    vmulh.vx v4, v4, t0
    vsub.vv  v18, v18, v1
    vsub.vv  v20, v20, v2
    vsub.vv  v22, v22, v3
    vsub.vv  v24, v24, v4
    // v9, v10,v11,v12,v13,v14,v15,v16
    // v17,v18,v19,v20,v21,v22,v23,v24
    barrettRdcX4 v9,  v11, v13, v15, v1, v2, v3, v4, a6, t0
    barrettRdcX4 v17, v19, v21, v23, v1, v2, v3, v4, a6, t0
    // level 3
    li t5, ((1-\off)*_ZETA_EXP_INTT_0TO5_P0_L3+ \off*_ZETA_EXP_INTT_0TO5_P1_L3)*2
    add t4, a1, t5
    lh t2, 0*2(t4);     lh t1, 1*2(t4)
    lh t6, 2*2(t4);     lh t5, 3*2(t4)
    lh a3, 4*2(t4);     lh a2, 5*2(t4)
    lh a5, 6*2(t4);     lh a4, 7*2(t4)
    vadd.vv v1, v9,  v11
    vadd.vv v2, v10, v12
    vsub.vv v3, v9,  v11
    vsub.vv v4, v10, v12
    vadd.vv v5, v13, v15
    vadd.vv v6, v14, v16
    vsub.vv v7, v13, v15
    vsub.vv v8, v14, v16
    vmul.vx  v9, v3, t2
    vmulh.vx v3, v3, t1
    vmul.vx  v10,v4, t2
    vmulh.vx v4, v4, t1
    vmul.vx  v11, v7,t6
    vmulh.vx v7, v7, t5
    vmul.vx  v12,v8, t6
    vmulh.vx v8, v8, t5
    vmulh.vx v9,  v9,  t0
    vmulh.vx v10, v10, t0
    vmulh.vx v11, v11, t0
    vmulh.vx v12, v12, t0
    vsub.vv  v3, v3, v9
    vsub.vv  v4, v4, v10
    vsub.vv  v7, v7, v11
    vsub.vv  v8, v8, v12
    // v1,v2,v3,v4,v5,v6,v7,v8
    vadd.vv v9, v17, v19
    vadd.vv v10,v18, v20
    vsub.vv v11, v17, v19
    vsub.vv v12, v18, v20
    vadd.vv v13, v21, v23
    vadd.vv v14, v22, v24
    vsub.vv v15, v21, v23
    vsub.vv v16, v22, v24
    vmul.vx  v17, v11, a3
    vmulh.vx v11, v11, a2
    vmul.vx  v18, v12, a3
    vmulh.vx v12, v12, a2
    vmul.vx  v19, v15, a5
    vmulh.vx v15, v15, a4
    vmul.vx  v20, v16, a5
    vmulh.vx v16, v16, a4
    vmulh.vx v17, v17, t0
    vmulh.vx v18, v18, t0
    vmulh.vx v19, v19, t0
    vmulh.vx v20, v20, t0
    vsub.vv  v11, v11, v17
    vsub.vv  v12, v12, v18
    vsub.vv  v15, v15, v19
    vsub.vv  v16, v16, v20
    // v1,v2,v3,v4,v5,v6,v7,v8
    // v9,v10,v11,v12,v13,v14,v15,v16
    // level 4
    li t5, ((1-\off)*_ZETA_EXP_INTT_0TO5_P0_L4+ \off*_ZETA_EXP_INTT_0TO5_P1_L4)*2
    add t4, a1, t5
    lh t2, 0*2(t4);     lh t1, 1*2(t4)
    lh t6, 2*2(t4);     lh t5, 3*2(t4)
    vadd.vv v17, v1, v5
    vadd.vv v18, v2, v6
    vadd.vv v19, v3, v7
    vadd.vv v20, v4, v8
    vsub.vv v21, v1, v5
    vsub.vv v22, v2, v6
    vsub.vv v23, v3, v7
    vsub.vv v24, v4, v8
    vmul.vx  v1,  v21, t2
    vmulh.vx v21, v21, t1
    vmul.vx  v2,  v22, t2
    vmulh.vx v22, v22, t1
    vmul.vx  v3,  v23, t2
    vmulh.vx v23, v23, t1
    vmul.vx  v4,  v24, t2
    vmulh.vx v24, v24, t1
    vmulh.vx v1,  v1, t0
    vmulh.vx v2,  v2, t0
    vmulh.vx v3,  v3, t0
    vmulh.vx v4,  v4, t0
    vsub.vv  v21, v21, v1
    vsub.vv  v22, v22, v2
    vsub.vv  v23, v23, v3
    vsub.vv  v24, v24, v4
    // v17,v18,v19,v20,v21,v22,v23,v24
    vadd.vv v1, v9,  v13
    vadd.vv v2, v10, v14
    vadd.vv v3, v11, v15
    vadd.vv v4, v12, v16
    vsub.vv v5, v9,  v13
    vsub.vv v6, v10, v14
    vsub.vv v7, v11, v15
    vsub.vv v8, v12, v16
    vmul.vx  v9, v5, t6
    vmulh.vx v5, v5, t5
    vmul.vx  v10,v6, t6
    vmulh.vx v6, v6, t5
    vmul.vx  v11,v7, t6
    vmulh.vx v7, v7, t5
    vmul.vx  v12,v8, t6
    vmulh.vx v8, v8, t5
    vmulh.vx v9, v9,  t0
    vmulh.vx v10,v10, t0
    vmulh.vx v11,v11, t0
    vmulh.vx v12,v12, t0
    vsub.vv  v5, v5, v9
    vsub.vv  v6, v6, v10
    vsub.vv  v7, v7, v11
    vsub.vv  v8, v8, v12
    // v17,v18,v19,v20,v21,v22,v23,v24
    // v1,v2,v3,v4,v5,v6,v7,v8
    // level 5
    li t5, ((1-\off)*_ZETA_EXP_INTT_0TO5_P0_L5+ \off*_ZETA_EXP_INTT_0TO5_P1_L5)*2
    add t4, a1, t5
    lh t2, 0*2(t4);     lh t1, 1*2(t4)
    vadd.vv v9,  v17, v1
    vadd.vv v10, v18, v2
    vadd.vv v11, v19, v3
    vadd.vv v12, v20, v4
    vsub.vv v13, v17, v1
    vsub.vv v14, v18, v2
    vsub.vv v15, v19, v3
    vsub.vv v16, v20, v4
    barrettRdc v9, v17, a6, t0
    addi t3, a0, (\off*128)*2 # a[0] or a[128]
    vse16.v v9,  (t3);  addi t3, t3, 16
    vmul.vx  v17, v13, t2
    vmulh.vx v13, v13, t1
    vse16.v v10, (t3);  addi t3, t3, 16
    vmul.vx  v18, v14, t2
    vmulh.vx v14, v14, t1
    vse16.v v11, (t3);  addi t3, t3, 16
    vmul.vx  v19, v15, t2
    vmulh.vx v15, v15, t1
    vse16.v v12, (t3);  addi t3, t3, 16
    vmul.vx  v20, v16, t2
    vmulh.vx v16, v16, t1
    vmulh.vx v17, v17, t0
    vmulh.vx v18, v18, t0
    vmulh.vx v19, v19, t0
    vmulh.vx v20, v20, t0
    vsub.vv  v13, v13, v17
    vsub.vv  v14, v14, v18
    vsub.vv  v15, v15, v19
    vsub.vv  v16, v16, v20
    vadd.vv v1, v21, v5
    vadd.vv v2, v22, v6
    vadd.vv v3, v23, v7
    vadd.vv v4, v24, v8
    vsub.vv v5, v21, v5
    vsub.vv v6, v22, v6
    vsub.vv v7, v23, v7
    vsub.vv v8, v24, v8
    vse16.v v1, (t3);  addi t3, t3, 16
    vmul.vx  v21, v5, t2
    vmulh.vx v5,  v5, t1
    vse16.v v2, (t3);  addi t3, t3, 16
    vmul.vx  v22, v6, t2
    vmulh.vx v6,  v6, t1
    vse16.v v3, (t3);  addi t3, t3, 16
    vmul.vx  v23, v7, t2
    vmulh.vx v7,  v7, t1
    vse16.v v4, (t3);  addi t3, t3, 16
    vmul.vx  v24, v8, t2
    vmulh.vx v8,  v8, t1
    addi t3, a0, (64+\off*128)*2 # a[64] or a[192]
    vse16.v v13, (t3);  addi t3, t3, 16
    vmulh.vx v21, v21, t0
    vmulh.vx v22, v22, t0
    vse16.v v14, (t3);  addi t3, t3, 16
    vmulh.vx v23, v23, t0
    vmulh.vx v24, v24, t0
    vse16.v v15, (t3);  addi t3, t3, 16
    vsub.vv  v5,  v5, v21
    vsub.vv  v6,  v6, v22
    vse16.v v16, (t3);  addi t3, t3, 16
    vsub.vv  v7,  v7, v23
    vsub.vv  v8,  v8, v24
    // v9,v10,v11,v12, v1,v2,v3,v4
    // v13,v14,v15,v16,v5,v6,v7,v8
    vse16.v v5, (t3);  addi t3, t3, 16
    vse16.v v6, (t3);  addi t3, t3, 16
    vse16.v v7, (t3);  addi t3, t3, 16
    vse16.v v8, (t3);  addi t3, t3, 16
.endm

.macro intt_rvv_level6 off
    addi t3, a0, (\off*64)*2 # a[0] or a[64]
    vle16.v v9,  (t3);  addi t3, t3, 16
    vle16.v v10, (t3);  addi t3, t3, 16
    vle16.v v11, (t3);  addi t3, t3, 16
    vle16.v v12, (t3)
    addi t3, a0, (128+\off*64)*2 # a[128] or a[192]
    vle16.v v13, (t3);  addi t3, t3, 16
    vle16.v v14, (t3);  addi t3, t3, 16
    vle16.v v15, (t3);  addi t3, t3, 16
    vle16.v v16, (t3)
    vadd.vv v1, v9,  v13
    vadd.vv v2, v10, v14
    vadd.vv v3, v11, v15
    vadd.vv v4, v12, v16
    vsub.vv v5, v9,  v13
    vsub.vv v6, v10, v14
    vsub.vv v7, v11, v15
    vsub.vv v8, v12, v16
    addi t3, a0, (\off*64)*2 # a[0] or a[64]
    vse16.v v1, (t3);  addi t3, t3, 16
    vmul.vx  v9,  v5, t2
    vmul.vx  v10, v6, t2
    vse16.v v2, (t3);  addi t3, t3, 16
    vmul.vx  v11, v7, t2
    vmul.vx  v12, v8, t2
    vse16.v v3, (t3);  addi t3, t3, 16
    vmulh.vx v5, v5, t1
    vmulh.vx v6, v6, t1
    vse16.v v4, (t3);  addi t3, t3, 16
    vmulh.vx v7, v7, t1
    vmulh.vx v8, v8, t1
    vle16.v v17, (t3);  addi t3, t3, 16
    vmulh.vx v9,  v9,  t0
    vmulh.vx v10, v10, t0
    vle16.v v18, (t3);  addi t3, t3, 16
    vmulh.vx v11, v11, t0
    vmulh.vx v12, v12, t0
    vle16.v v19, (t3);  addi t3, t3, 16
    vsub.vv  v5, v5, v9
    vsub.vv  v6, v6, v10
    vle16.v v20, (t3)
    vsub.vv  v7, v7, v11
    vsub.vv  v8, v8, v12
    addi t3, a0, (128+\off*64)*2 # a[128] or a[192]
    vse16.v v5, (t3);  addi t3, t3, 16
    vse16.v v6, (t3);  addi t3, t3, 16
    vse16.v v7, (t3);  addi t3, t3, 16
    vse16.v v8, (t3);  addi t3, t3, 16
    vle16.v v21, (t3);  addi t3, t3, 16
    vle16.v v22, (t3);  addi t3, t3, 16
    vle16.v v23, (t3);  addi t3, t3, 16
    vle16.v v24, (t3)
    vadd.vv v1, v17, v21
    vadd.vv v2, v18, v22
    vadd.vv v3, v19, v23
    vadd.vv v4, v20, v24
    vsub.vv v5, v17, v21
    vsub.vv v6, v18, v22
    vsub.vv v7, v19, v23
    vsub.vv v8, v20, v24
    addi t3, a0, (32+\off*64)*2 # a[0] or a[64]
    vse16.v v1, (t3);  addi t3, t3, 16
    vmul.vx  v9,  v5, t2
    vmul.vx  v10, v6, t2
    vse16.v v2, (t3);  addi t3, t3, 16
    vmul.vx  v11, v7, t2
    vmul.vx  v12, v8, t2
    vse16.v v3, (t3);  addi t3, t3, 16
    vmulh.vx v5, v5, t1
    vmulh.vx v6, v6, t1
    vse16.v v4, (t3)
    vmulh.vx v7, v7, t1
    vmulh.vx v8, v8, t1
    vmulh.vx v9,  v9,  t0
    vmulh.vx v10, v10, t0
    vmulh.vx v11, v11, t0
    vmulh.vx v12, v12, t0
    vsub.vv  v5, v5, v9
    vsub.vv  v6, v6, v10
    vsub.vv  v7, v7, v11
    vsub.vv  v8, v8, v12
    addi t3, a0, (32+128+\off*64)*2 # a[128] or a[192]
    vse16.v v5, (t3);  addi t3, t3, 16
    vse16.v v6, (t3);  addi t3, t3, 16
    vse16.v v7, (t3);  addi t3, t3, 16
    vse16.v v8, (t3)
.endm

// register usage:
// t0 = Q
// t1/t2, t5/t6, a2/a3, a4/a5: zeta/zeta*qinv
// a6: const_v for barrett reduction
// t3: address related to the input polynomial
// t4: address related to the pre-computed table
// v0: mask used for vmerge.vvm instruction
// v28~v31: masks used for shuffle4/2
.globl intt_rvv
.align 2
intt_rvv:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329
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

// input:
// [a0,a2,a4,a6,a8,a10,a12,a14], [a1,a3,a5,a7,a9,a11,a13,a15]
// [a16,a18,a20,a22,a24,a26,a28,a30], [a17,a19,a21,a23,a25,a27,a29,a31]
// ...
// out:
// a0~a7, a8~a15, a16~a23, a24~a31, ......
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

// input:
// a0~a7, a8~a15, a16~a23, a24~a31, ......
// out:
// [a0,a2,a4,a6,a8,a10,a12,a14], [a1,a3,a5,a7,a9,a11,a13,a15]
// [a16,a18,a20,a22,a24,a26,a28,a30], [a17,a19,a21,a23,a25,a27,a29,a31]
// ...
.globl normal2ntt_order
.align 2
normal2ntt_order:
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
normal2ntt_order_loop:
    vle16.v v1, (a1);        addi a1, a1, 16
    vle16.v v2, (a1);        addi a1, a1, 16
    vle16.v v3, (a1);        addi a1, a1, 16
    vle16.v v4, (a1);        addi a1, a1, 16
    vmv.v.v v0, v26
    shuffle4 v5, v6, v1, v2, v31, v30   # v5, v6 = [a0~a3, a8~a11], [a4~a7,  a12~a15]
    shuffle4 v7, v8, v3, v4, v31, v30
    vle16.v v9,  (a1);       addi a1, a1, 16
    vle16.v v10, (a1);       addi a1, a1, 16
    vle16.v v11, (a1);       addi a1, a1, 16
    vle16.v v12, (a1);       addi a1, a1, 16
    shuffle4 v13,v14,v9, v10,v31, v30
    shuffle4 v15,v16,v11,v12,v31, v30
    vmv.v.v v0, v25
    shuffle2 v1, v2, v5, v6, v29, v28   # v1, v2 = [a0~a1,a4~a5,a8~a9,a12~a13], [a2~a3,a6~a7,a10~a11,a14~a15]
    shuffle2 v3, v4, v7, v8, v29, v28
    shuffle2 v9, v10,v13,v14,v29, v28
    shuffle2 v11,v12,v15,v16,v29, v28
    vmv.v.v v0, v24
    shuffle1 v5, v6, v1, v2, v27
    shuffle1 v7, v8, v3, v4, v27
    vse16.v v5, (a0);       addi a0, a0, 16
    vse16.v v6, (a0);       addi a0, a0, 16
    vse16.v v7, (a0);       addi a0, a0, 16
    vse16.v v8, (a0);       addi a0, a0, 16
    shuffle1 v13,v14,v9, v10,v27
    shuffle1 v15,v16,v11,v12,v27
    vse16.v v13, (a0);      addi a0, a0, 16
    vse16.v v14, (a0);      addi a0, a0, 16
    vse16.v v15, (a0);      addi a0, a0, 16
    vse16.v v16, (a0);      addi a0, a0, 16
    addi a2, a2, -1
    bnez a2, normal2ntt_order_loop
ret

.globl poly_reduce_rvv
.align 2
poly_reduce_rvv:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329
    li a6, 20159    # for barrett reduction
    li a2, 4
poly_reduce_rvv_loop:
    vle16.v v1,  (a0);       addi a0, a0, 16
    vle16.v v2,  (a0);       addi a0, a0, 16
    vle16.v v3,  (a0);       addi a0, a0, 16
    vle16.v v4,  (a0);       addi a0, a0, 16
    vle16.v v9,  (a0);       addi a0, a0, 16
    vle16.v v10, (a0);       addi a0, a0, 16
    vle16.v v11, (a0);       addi a0, a0, 16
    vle16.v v12, (a0);       addi a0, a0, -16*7
    barrettRdcX4 v1, v2, v3, v4, v5, v6, v7, v8, a6, t0
    barrettRdcX4 v9, v10,v11,v12,v5, v6, v7, v8, a6, t0
    vse16.v v1,  (a0);       addi a0, a0, 16
    vse16.v v2,  (a0);       addi a0, a0, 16
    vse16.v v3,  (a0);       addi a0, a0, 16
    vse16.v v4,  (a0);       addi a0, a0, 16
    vse16.v v9,  (a0);       addi a0, a0, 16
    vse16.v v10, (a0);       addi a0, a0, 16
    vse16.v v11, (a0);       addi a0, a0, 16
    vse16.v v12, (a0);       addi a0, a0, 16
    addi a2, a2, -1
    bnez a2, poly_reduce_rvv_loop
ret

.macro montMulX4 in0, in1, in2, in3, \
        vt0, vt1, vt2, vt3, \
        const_q, const_montsq, const_montsq_qinv
    vmul.vx \vt0, \in0, \const_montsq_qinv
    vmul.vx \vt1, \in1, \const_montsq_qinv
    vmul.vx \vt2, \in2, \const_montsq_qinv
    vmul.vx \vt3, \in3, \const_montsq_qinv
    vmulh.vx \in0, \in0, \const_montsq
    vmulh.vx \in1, \in1, \const_montsq
    vmulh.vx \in2, \in2, \const_montsq
    vmulh.vx \in3, \in3, \const_montsq
    vmulh.vx \vt0, \vt0, \const_q
    vmulh.vx \vt1, \vt1, \const_q
    vmulh.vx \vt2, \vt2, \const_q
    vmulh.vx \vt3, \vt3, \const_q
    vsub.vv  \in0, \in0, \vt0
    vsub.vv  \in1, \in1, \vt1
    vsub.vv  \in2, \in2, \vt2
    vsub.vv  \in3, \in3, \vt3
.endm

.globl poly_tomont_rvv
.align 2
poly_tomont_rvv:
    li t1, 128
    vsetvli t2, t1, e16, m1, tu, mu
    li t0, 3329
    li t1, 1353     # mont^2
    li t2, 20553    # qinv*mont^2
    li a2, 4
poly_tomont_rvv_loop:
    vle16.v v1,  (a0);       addi a0, a0, 16
    vle16.v v2,  (a0);       addi a0, a0, 16
    vle16.v v3,  (a0);       addi a0, a0, 16
    vle16.v v4,  (a0);       addi a0, a0, 16
    vle16.v v9,  (a0);       addi a0, a0, 16
    vle16.v v10, (a0);       addi a0, a0, 16
    vle16.v v11, (a0);       addi a0, a0, 16
    vle16.v v12, (a0);       addi a0, a0, -16*7
    montMulX4 v1, v2, v3, v4, v5, v6, v7, v8, t0, t1, t2
    montMulX4 v9, v10,v11,v12,v5, v6, v7, v8, t0, t1, t2
    vse16.v v1,  (a0);       addi a0, a0, 16
    vse16.v v2,  (a0);       addi a0, a0, 16
    vse16.v v3,  (a0);       addi a0, a0, 16
    vse16.v v4,  (a0);       addi a0, a0, 16
    vse16.v v9,  (a0);       addi a0, a0, 16
    vse16.v v10, (a0);       addi a0, a0, 16
    vse16.v v11, (a0);       addi a0, a0, 16
    vse16.v v12, (a0);       addi a0, a0, 16
    addi a2, a2, -1
    bnez a2, poly_tomont_rvv_loop
ret
