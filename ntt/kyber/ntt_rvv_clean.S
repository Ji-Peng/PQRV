#include "consts.h"

// [a0~a3,a4~a7]+[a8~a11,a12~a15]
// ->
// [a0~a3,a8~a11]+[a4~a7,a12~a15]
// related masks are ready for using
// v0: _MASK_11110000, vm0/vm1: _MASK_45674567/_MASK_01230123
.macro shuffle4 in0_0, in0_1, tm0_0, tm0_1, vm0, vm1
    vrgather.vv \tm0_1, \in0_0, \vm0
    vrgather.vv \tm0_0, \in0_1, \vm1
    vmerge.vvm  \in0_1, \in0_1, \tm0_1, v0
    vmerge.vvm  \in0_0, \tm0_0, \in0_0, v0
.endm

.macro shuffle4_x2 \
    in0_0, in0_1, in1_0, in1_1, \
    tm0_0, tm0_1, tm1_0, tm1_1, \
    vm0, vm1
    vrgather.vv \tm0_1, \in0_0, \vm0
    vrgather.vv \tm0_0, \in0_1, \vm1
    vrgather.vv \tm1_1, \in1_0, \vm0
    vrgather.vv \tm1_0, \in1_1, \vm1
    vmerge.vvm  \in0_1, \in0_1, \tm0_1, v0
    vmerge.vvm  \in0_0, \tm0_0, \in0_0, v0
    vmerge.vvm  \in1_1, \in1_1, \tm1_1, v0
    vmerge.vvm  \in1_0, \tm1_0, \in1_0, v0
.endm

.macro shuffle4_x4 \
    in0_0, in0_1, in1_0, in1_1, in2_0, in2_1, in3_0, in3_1, \
    tm0_0, tm0_1, tm1_0, tm1_1, tm2_0, tm2_1, tm3_0, tm3_1, \
    vm0, vm1
    vrgather.vv \tm0_1, \in0_0, \vm0
    vrgather.vv \tm0_0, \in0_1, \vm1
    vrgather.vv \tm1_1, \in1_0, \vm0
    vrgather.vv \tm1_0, \in1_1, \vm1
    vrgather.vv \tm2_1, \in2_0, \vm0
    vrgather.vv \tm2_0, \in2_1, \vm1
    vrgather.vv \tm3_1, \in3_0, \vm0
    vrgather.vv \tm3_0, \in3_1, \vm1
    vmerge.vvm  \in0_1, \in0_1, \tm0_1, v0
    vmerge.vvm  \in0_0, \tm0_0, \in0_0, v0
    vmerge.vvm  \in1_1, \in1_1, \tm1_1, v0
    vmerge.vvm  \in1_0, \tm1_0, \in1_0, v0
    vmerge.vvm  \in2_1, \in2_1, \tm2_1, v0
    vmerge.vvm  \in2_0, \tm2_0, \in2_0, v0
    vmerge.vvm  \in3_1, \in3_1, \tm3_1, v0
    vmerge.vvm  \in3_0, \tm3_0, \in3_0, v0
.endm

// [a0~a1,a2~a3,a8~a9,a10~a11]+[a4~a5,a6~a7,a12~a13,a14~a15]
// ->
// [a0~a1,a4~a5,a8~a9,a12~a13]+[a2~a3,a6~a7,a10~a11,a14~a15]
// related masks are ready for using
// v0: _MASK_11001100, vm0/vm1: _MASK_00010045/_MASK_23006700
.macro shuffle2 in0_0, in0_1, tm0_0, tm0_1, vm0, vm1
    vrgather.vv \tm0_0, \in0_1, \vm0
    vrgather.vv \tm0_1, \in0_0, \vm1
    vmerge.vvm  \in0_0, \tm0_0, \in0_0, v0
    vmerge.vvm  \in0_1, \in0_1, \tm0_1, v0
.endm

.macro shuffle2_x2 \
        in0_0, in0_1, in1_0, in1_1, \
        tm0_0, tm0_1, tm1_0, tm1_1, \
        vm0, vm1
    vrgather.vv \tm0_0, \in0_1, \vm0
    vrgather.vv \tm0_1, \in0_0, \vm1
    vrgather.vv \tm1_0, \in1_1, \vm0
    vrgather.vv \tm1_1, \in1_0, \vm1
    vmerge.vvm  \in0_0, \tm0_0, \in0_0, v0
    vmerge.vvm  \in0_1, \in0_1, \tm0_1, v0
    vmerge.vvm  \in1_0, \tm1_0, \in1_0, v0
    vmerge.vvm  \in1_1, \in1_1, \tm1_1, v0
.endm

.macro shuffle2_x4 \
        in0_0, in0_1, in1_0, in1_1, \
        in2_0, in2_1, in3_0, in3_1, \
        tm0_0, tm0_1, tm1_0, tm1_1, \
        tm2_0, tm2_1, tm3_0, tm3_1, \
        vm0, vm1
    vrgather.vv \tm0_0, \in0_1, \vm0
    vrgather.vv \tm0_1, \in0_0, \vm1
    vrgather.vv \tm1_0, \in1_1, \vm0
    vrgather.vv \tm1_1, \in1_0, \vm1
    vrgather.vv \tm2_0, \in2_1, \vm0
    vrgather.vv \tm2_1, \in2_0, \vm1
    vrgather.vv \tm3_0, \in3_1, \vm0
    vrgather.vv \tm3_1, \in3_0, \vm1
    vmerge.vvm  \in0_0, \tm0_0, \in0_0, v0
    vmerge.vvm  \in0_1, \in0_1, \tm0_1, v0
    vmerge.vvm  \in1_0, \tm1_0, \in1_0, v0
    vmerge.vvm  \in1_1, \in1_1, \tm1_1, v0
    vmerge.vvm  \in2_0, \tm2_0, \in2_0, v0
    vmerge.vvm  \in2_1, \in2_1, \tm2_1, v0
    vmerge.vvm  \in3_0, \tm3_0, \in3_0, v0
    vmerge.vvm  \in3_1, \in3_1, \tm3_1, v0
.endm

// [a0~a1,a4~a5,a8~a9,a12~a13]+[a2~a3,a6~a7,a10~a11,a14~a15]
// ->
// [a0,a2,a4,a6,a8,a10,a12,a14]+[a1,a3,a5,a7,a9,a11,a13,a15]
// related masks are ready for using
// v0: _MASK_10101010, vm0: _MASK_10325476
.macro shuffle1 in0_0, in0_1, tm0_0, tm0_1, vm0
    vrgather.vv \tm0_0, \in0_1, \vm0      # [a3,a2,a7,a6]
    vrgather.vv \tm0_1, \in0_0, \vm0      # [a1,a0,a5,a4]
    vmerge.vvm  \in0_0, \tm0_0, \in0_0, v0
    vmerge.vvm  \in0_1, \in0_1, \tm0_1, v0
.endm

.macro shuffle1_x2 \
        in0_0, in0_1, in1_0, in1_1, \
        tm0_0, tm0_1, tm1_0, tm1_1, \
        vm0
    vrgather.vv \tm0_0, \in0_1, \vm0
    vrgather.vv \tm0_1, \in0_0, \vm0
    vrgather.vv \tm1_0, \in1_1, \vm0
    vrgather.vv \tm1_1, \in1_0, \vm0
    vmerge.vvm  \in0_0, \tm0_0, \in0_0, v0
    vmerge.vvm  \in0_1, \in0_1, \tm0_1, v0
    vmerge.vvm  \in1_0, \tm1_0, \in1_0, v0
    vmerge.vvm  \in1_1, \in1_1, \tm1_1, v0
.endm

.macro shuffle1_x4 \
        in0_0, in0_1, in1_0, in1_1, \
        in2_0, in2_1, in3_0, in3_1, \
        tm0_0, tm0_1, tm1_0, tm1_1, \
        tm2_0, tm2_1, tm3_0, tm3_1, \
        vm0
    vrgather.vv \tm0_0, \in0_1, \vm0
    vrgather.vv \tm0_1, \in0_0, \vm0
    vrgather.vv \tm1_0, \in1_1, \vm0
    vrgather.vv \tm1_1, \in1_0, \vm0
    vrgather.vv \tm2_0, \in2_1, \vm0
    vrgather.vv \tm2_1, \in2_0, \vm0
    vrgather.vv \tm3_0, \in3_1, \vm0
    vrgather.vv \tm3_1, \in3_0, \vm0
    vmerge.vvm  \in0_0, \tm0_0, \in0_0, v0
    vmerge.vvm  \in0_1, \in0_1, \tm0_1, v0
    vmerge.vvm  \in1_0, \tm1_0, \in1_0, v0
    vmerge.vvm  \in1_1, \in1_1, \tm1_1, v0
    vmerge.vvm  \in2_0, \tm2_0, \in2_0, v0
    vmerge.vvm  \in2_1, \in2_1, \tm2_1, v0
    vmerge.vvm  \in3_0, \tm3_0, \in3_0, v0
    vmerge.vvm  \in3_1, \in3_1, \tm3_1, v0
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

.macro tomont va0, xb, xbqinv, xq, vt0
    vmul.vx  \vt0, \va0, \xbqinv
    vmulh.vx \va0, \va0, \xb
    vmulh.vx \vt0, \vt0, \xq
    vsub.vv  \va0, \va0, \vt0
.endm

.macro tomont_x2 \
        va0, va1, \
        xb, xbqinv, xq, \
        vt0, vt1
    vmul.vx  \vt0, \va0, \xbqinv
    vmul.vx  \vt1, \va1, \xbqinv
    vmulh.vx \va0, \va0, \xb
    vmulh.vx \va1, \va1, \xb
    vmulh.vx \vt0, \vt0, \xq
    vmulh.vx \vt1, \vt1, \xq
    vsub.vv  \va0, \va0, \vt0
    vsub.vv  \va1, \va1, \vt1
.endm

.macro tomont_x4 \
        va0, va1, va2, va3, \
        xb, xbqinv, xq, \
        vt0, vt1, vt2, vt3
    vmul.vx  \vt0, \va0, \xbqinv
    vmul.vx  \vt1, \va1, \xbqinv
    vmul.vx  \vt2, \va2, \xbqinv
    vmul.vx  \vt3, \va3, \xbqinv
    vmulh.vx \va0, \va0, \xb
    vmulh.vx \va1, \va1, \xb
    vmulh.vx \va2, \va2, \xb
    vmulh.vx \va3, \va3, \xb
    vmulh.vx \vt0, \vt0, \xq
    vmulh.vx \vt1, \vt1, \xq
    vmulh.vx \vt2, \vt2, \xq
    vmulh.vx \vt3, \vt3, \xq
    vsub.vv  \va0, \va0, \vt0
    vsub.vv  \va1, \va1, \vt1
    vsub.vv  \va2, \va2, \vt2
    vsub.vv  \va3, \va3, \vt3
.endm

.macro tomont_x8 \
        va0, va1, va2, va3, \
        va4, va5, va6, va7, \
        xb, xbqinv, xq, \
        vt0, vt1, vt2, vt3, \
        vt4, vt5, vt6, vt7
    vmul.vx  \vt0, \va0, \xbqinv
    vmul.vx  \vt1, \va1, \xbqinv
    vmul.vx  \vt2, \va2, \xbqinv
    vmul.vx  \vt3, \va3, \xbqinv
    vmul.vx  \vt4, \va4, \xbqinv
    vmul.vx  \vt5, \va5, \xbqinv
    vmul.vx  \vt6, \va6, \xbqinv
    vmul.vx  \vt7, \va7, \xbqinv
    vmulh.vx \va0, \va0, \xb
    vmulh.vx \va1, \va1, \xb
    vmulh.vx \va2, \va2, \xb
    vmulh.vx \va3, \va3, \xb
    vmulh.vx \va4, \va4, \xb
    vmulh.vx \va5, \va5, \xb
    vmulh.vx \va6, \va6, \xb
    vmulh.vx \va7, \va7, \xb
    vmulh.vx \vt0, \vt0, \xq
    vmulh.vx \vt1, \vt1, \xq
    vmulh.vx \vt2, \vt2, \xq
    vmulh.vx \vt3, \vt3, \xq
    vmulh.vx \vt4, \vt4, \xq
    vmulh.vx \vt5, \vt5, \xq
    vmulh.vx \vt6, \vt6, \xq
    vmulh.vx \vt7, \vt7, \xq
    vsub.vv  \va0, \va0, \vt0
    vsub.vv  \va1, \va1, \vt1
    vsub.vv  \va2, \va2, \vt2
    vsub.vv  \va3, \va3, \vt3
    vsub.vv  \va4, \va4, \vt4
    vsub.vv  \va5, \va5, \vt5
    vsub.vv  \va6, \va6, \vt6
    vsub.vv  \va7, \va7, \vt7
.endm

.macro montmul_ref vr0, va0, vb0, xq, xqinv, vt0
    vmul.vv  \vr0, \va0, \vb0
    vmul.vx  \vr0, \vr0, \xqinv
    vmulh.vx \vr0, \vr0, \xq
    vmulh.vv \vt0, \va0, \vb0
    vsub.vv  \vr0, \vt0, \vr0
.endm

.macro montmul_ref_x2 \
        vr0, vr1, \
        va0, va1, \
        vb0, vb1, \
        xq, xqinv, \
        vt0, vt1
    vmul.vv  \vr0, \va0, \vb0
    vmul.vv  \vr1, \va1, \vb1
    vmul.vx  \vr0, \vr0, \xqinv
    vmul.vx  \vr1, \vr1, \xqinv
    vmulh.vx \vr0, \vr0, \xq
    vmulh.vx \vr1, \vr1, \xq
    vmulh.vv \vt0, \va0, \vb0
    vmulh.vv \vt1, \va1, \vb1
    vsub.vv  \vr0, \vt0, \vr0
    vsub.vv  \vr1, \vt1, \vr1
.endm

.macro montmul_ref_x4 \
        vr0, vr1, vr2, vr3, \
        va0, va1, va2, va3, \
        vb0, vb1, vb2, vb3, \
        xq, xqinv, \
        vt0, vt1, vt2, vt3
    vmul.vv  \vr0, \va0, \vb0
    vmul.vv  \vr1, \va1, \vb1
    vmul.vv  \vr2, \va2, \vb2
    vmul.vv  \vr3, \va3, \vb3
    vmul.vx  \vr0, \vr0, \xqinv
    vmul.vx  \vr1, \vr1, \xqinv
    vmul.vx  \vr2, \vr2, \xqinv
    vmul.vx  \vr3, \vr3, \xqinv
    vmulh.vx \vr0, \vr0, \xq
    vmulh.vx \vr1, \vr1, \xq
    vmulh.vx \vr2, \vr2, \xq
    vmulh.vx \vr3, \vr3, \xq
    vmulh.vv \vt0, \va0, \vb0
    vmulh.vv \vt1, \va1, \vb1
    vmulh.vv \vt2, \va2, \vb2
    vmulh.vv \vt3, \va3, \vb3
    vsub.vv  \vr0, \vt0, \vr0
    vsub.vv  \vr1, \vt1, \vr1
    vsub.vv  \vr2, \vt2, \vr2
    vsub.vv  \vr3, \vt3, \vr3
.endm

.macro montmul_ref_x8 \
        vr0, vr1, vr2, vr3, vr4, vr5, vr6, vr7,  \
        va0, va1, va2, va3, va4, va5, va6, va7,  \
        vb0, vb1, vb2, vb3, vb4, vb5, vb6, vb7,  \
        xq, xqinv, \
        vt0, vt1, vt2, vt3, vt4, vt5, vt6, vt7
    vmul.vv  \vr0, \va0, \vb0
    vmul.vv  \vr1, \va1, \vb1
    vmul.vv  \vr2, \va2, \vb2
    vmul.vv  \vr3, \va3, \vb3
    vmul.vv  \vr4, \va4, \vb4
    vmul.vv  \vr5, \va5, \vb5
    vmul.vv  \vr6, \va6, \vb6
    vmul.vv  \vr7, \va7, \vb7
    vmul.vx  \vr0, \vr0, \xqinv
    vmul.vx  \vr1, \vr1, \xqinv
    vmul.vx  \vr2, \vr2, \xqinv
    vmul.vx  \vr3, \vr3, \xqinv
    vmul.vx  \vr4, \vr4, \xqinv
    vmul.vx  \vr5, \vr5, \xqinv
    vmul.vx  \vr6, \vr6, \xqinv
    vmul.vx  \vr7, \vr7, \xqinv
    vmulh.vx \vr0, \vr0, \xq
    vmulh.vx \vr1, \vr1, \xq
    vmulh.vx \vr2, \vr2, \xq
    vmulh.vx \vr3, \vr3, \xq
    vmulh.vx \vr4, \vr4, \xq
    vmulh.vx \vr5, \vr5, \xq
    vmulh.vx \vr6, \vr6, \xq
    vmulh.vx \vr7, \vr7, \xq
    vmulh.vv \vt0, \va0, \vb0
    vmulh.vv \vt1, \va1, \vb1
    vmulh.vv \vt2, \va2, \vb2
    vmulh.vv \vt3, \va3, \vb3
    vmulh.vv \vt4, \va4, \vb4
    vmulh.vv \vt5, \va5, \vb5
    vmulh.vv \vt6, \va6, \vb6
    vmulh.vv \vt7, \va7, \vb7
    vsub.vv  \vr0, \vt0, \vr0
    vsub.vv  \vr1, \vt1, \vr1
    vsub.vv  \vr2, \vt2, \vr2
    vsub.vv  \vr3, \vt3, \vr3
    vsub.vv  \vr4, \vt4, \vr4
    vsub.vv  \vr5, \vt5, \vr5
    vsub.vv  \vr6, \vt6, \vr6
    vsub.vv  \vr7, \vt7, \vr7
.endm

.macro ct_bfu \
        va0_0, va0_1, \
        xzeta0, xzetaqinv0, \
        xq, vt0_0, vt0_1
    vmul.vx  \vt0_0, \va0_1, \xzetaqinv0
    vmulh.vx \vt0_1, \va0_1, \xzeta0
    vmulh.vx \vt0_0, \vt0_0, \xq
    vsub.vv  \vt0_0, \vt0_1, \vt0_0
    vsub.vv  \va0_1, \va0_0, \vt0_0
    vadd.vv  \va0_0, \va0_0, \vt0_0
.endm

.macro ct_bfu_x2 \
        va0_0, va0_1, va1_0, va1_1, \
        xzeta0, xzetaqinv0, xzeta1, xzetaqinv1, \
        xq, vt0_0, vt0_1, vt1_0, vt1_1
    vmul.vx  \vt0_0, \va0_1, \xzetaqinv0
    vmul.vx  \vt1_0, \va1_1, \xzetaqinv1
    vmulh.vx \vt0_1, \va0_1, \xzeta0
    vmulh.vx \vt1_1, \va1_1, \xzeta1
    vmulh.vx \vt0_0, \vt0_0, \xq
    vmulh.vx \vt1_0, \vt1_0, \xq
    vsub.vv  \vt0_0, \vt0_1, \vt0_0
    vsub.vv  \vt1_0, \vt1_1, \vt1_0
    vsub.vv  \va0_1, \va0_0, \vt0_0
    vsub.vv  \va1_1, \va1_0, \vt1_0
    vadd.vv  \va0_0, \va0_0, \vt0_0
    vadd.vv  \va1_0, \va1_0, \vt1_0
.endm

.macro ct_bfu_x4 \
        va0_0, va0_1, va1_0, va1_1, va2_0, va2_1, va3_0, va3_1, \
        xzeta0, xzetaqinv0, xzeta1, xzetaqinv1, \
        xzeta2, xzetaqinv2, xzeta3, xzetaqinv3, \
        xq, \
        vt0_0, vt0_1, vt1_0, vt1_1, \
        vt2_0, vt2_1, vt3_0, vt3_1
    vmul.vx  \vt0_0, \va0_1, \xzetaqinv0
    vmul.vx  \vt1_0, \va1_1, \xzetaqinv1
    vmul.vx  \vt2_0, \va2_1, \xzetaqinv2
    vmul.vx  \vt3_0, \va3_1, \xzetaqinv3
    vmulh.vx \vt0_1, \va0_1, \xzeta0
    vmulh.vx \vt1_1, \va1_1, \xzeta1
    vmulh.vx \vt2_1, \va2_1, \xzeta2
    vmulh.vx \vt3_1, \va3_1, \xzeta3
    vmulh.vx \vt0_0, \vt0_0, \xq
    vmulh.vx \vt1_0, \vt1_0, \xq
    vmulh.vx \vt2_0, \vt2_0, \xq
    vmulh.vx \vt3_0, \vt3_0, \xq
    vsub.vv  \vt0_0, \vt0_1, \vt0_0
    vsub.vv  \vt1_0, \vt1_1, \vt1_0
    vsub.vv  \vt2_0, \vt2_1, \vt2_0
    vsub.vv  \vt3_0, \vt3_1, \vt3_0
    vsub.vv  \va0_1, \va0_0, \vt0_0
    vsub.vv  \va1_1, \va1_0, \vt1_0
    vsub.vv  \va2_1, \va2_0, \vt2_0
    vsub.vv  \va3_1, \va3_0, \vt3_0
    vadd.vv  \va0_0, \va0_0, \vt0_0
    vadd.vv  \va1_0, \va1_0, \vt1_0
    vadd.vv  \va2_0, \va2_0, \vt2_0
    vadd.vv  \va3_0, \va3_0, \vt3_0
.endm

.macro ct_bfu_vv_x4 \
        va0_0, va0_1, va1_0, va1_1, va2_0, va2_1, va3_0, va3_1, \
        vzeta0, vzetaqinv0, vzeta1, vzetaqinv1, \
        vzeta2, vzetaqinv2, vzeta3, vzetaqinv3, \
        xq, \
        vt0_0, vt0_1, vt1_0, vt1_1, \
        vt2_0, vt2_1, vt3_0, vt3_1
    vmul.vv  \vt0_0, \va0_1, \vzetaqinv0
    vmul.vv  \vt1_0, \va1_1, \vzetaqinv1
    vmul.vv  \vt2_0, \va2_1, \vzetaqinv2
    vmul.vv  \vt3_0, \va3_1, \vzetaqinv3
    vmulh.vv \vt0_1, \va0_1, \vzeta0
    vmulh.vv \vt1_1, \va1_1, \vzeta1
    vmulh.vv \vt2_1, \va2_1, \vzeta2
    vmulh.vv \vt3_1, \va3_1, \vzeta3
    vmulh.vx \vt0_0, \vt0_0, \xq
    vmulh.vx \vt1_0, \vt1_0, \xq
    vmulh.vx \vt2_0, \vt2_0, \xq
    vmulh.vx \vt3_0, \vt3_0, \xq
    vsub.vv  \vt0_0, \vt0_1, \vt0_0
    vsub.vv  \vt1_0, \vt1_1, \vt1_0
    vsub.vv  \vt2_0, \vt2_1, \vt2_0
    vsub.vv  \vt3_0, \vt3_1, \vt3_0
    vsub.vv  \va0_1, \va0_0, \vt0_0
    vsub.vv  \va1_1, \va1_0, \vt1_0
    vsub.vv  \va2_1, \va2_0, \vt2_0
    vsub.vv  \va3_1, \va3_0, \vt3_0
    vadd.vv  \va0_0, \va0_0, \vt0_0
    vadd.vv  \va1_0, \va1_0, \vt1_0
    vadd.vv  \va2_0, \va2_0, \vt2_0
    vadd.vv  \va3_0, \va3_0, \vt3_0
.endm

.macro ct_bfu_x8 \
        va0_0, va0_1, va1_0, va1_1, va2_0, va2_1, va3_0, va3_1, \
        va4_0, va4_1, va5_0, va5_1, va6_0, va6_1, va7_0, va7_1, \
        xzeta0, xzetaqinv0, xzeta1, xzetaqinv1, \
        xzeta2, xzetaqinv2, xzeta3, xzetaqinv3, \
        xzeta4, xzetaqinv4, xzeta5, xzetaqinv5, \
        xzeta6, xzetaqinv6, xzeta7, xzetaqinv7, \
        xq, \
        vt0_0, vt0_1, vt1_0, vt1_1, \
        vt2_0, vt2_1, vt3_0, vt3_1, \
        vt4_0, vt4_1, vt5_0, vt5_1, \
        vt6_0, vt6_1, vt7_0, vt7_1
    vmul.vx  \vt0_0, \va0_1, \xzetaqinv0
    vmul.vx  \vt1_0, \va1_1, \xzetaqinv1
    vmul.vx  \vt2_0, \va2_1, \xzetaqinv2
    vmul.vx  \vt3_0, \va3_1, \xzetaqinv3
    vmul.vx  \vt4_0, \va4_1, \xzetaqinv4
    vmul.vx  \vt5_0, \va5_1, \xzetaqinv5
    vmul.vx  \vt6_0, \va6_1, \xzetaqinv6
    vmul.vx  \vt7_0, \va7_1, \xzetaqinv7
    vmulh.vx \vt0_1, \va0_1, \xzeta0
    vmulh.vx \vt1_1, \va1_1, \xzeta1
    vmulh.vx \vt2_1, \va2_1, \xzeta2
    vmulh.vx \vt3_1, \va3_1, \xzeta3
    vmulh.vx \vt4_1, \va4_1, \xzeta4
    vmulh.vx \vt5_1, \va5_1, \xzeta5
    vmulh.vx \vt6_1, \va6_1, \xzeta6
    vmulh.vx \vt7_1, \va7_1, \xzeta7
    vmulh.vx \vt0_0, \vt0_0, \xq
    vmulh.vx \vt1_0, \vt1_0, \xq
    vmulh.vx \vt2_0, \vt2_0, \xq
    vmulh.vx \vt3_0, \vt3_0, \xq
    vmulh.vx \vt4_0, \vt4_0, \xq
    vmulh.vx \vt5_0, \vt5_0, \xq
    vmulh.vx \vt6_0, \vt6_0, \xq
    vmulh.vx \vt7_0, \vt7_0, \xq
    vsub.vv  \vt0_0, \vt0_1, \vt0_0
    vsub.vv  \vt1_0, \vt1_1, \vt1_0
    vsub.vv  \vt2_0, \vt2_1, \vt2_0
    vsub.vv  \vt3_0, \vt3_1, \vt3_0
    vsub.vv  \vt4_0, \vt4_1, \vt4_0
    vsub.vv  \vt5_0, \vt5_1, \vt5_0
    vsub.vv  \vt6_0, \vt6_1, \vt6_0
    vsub.vv  \vt7_0, \vt7_1, \vt7_0
    vsub.vv  \va0_1, \va0_0, \vt0_0
    vsub.vv  \va1_1, \va1_0, \vt1_0
    vsub.vv  \va2_1, \va2_0, \vt2_0
    vsub.vv  \va3_1, \va3_0, \vt3_0
    vsub.vv  \va4_1, \va4_0, \vt4_0
    vsub.vv  \va5_1, \va5_0, \vt5_0
    vsub.vv  \va6_1, \va6_0, \vt6_0
    vsub.vv  \va7_1, \va7_0, \vt7_0
    vadd.vv  \va0_0, \va0_0, \vt0_0
    vadd.vv  \va1_0, \va1_0, \vt1_0
    vadd.vv  \va2_0, \va2_0, \vt2_0
    vadd.vv  \va3_0, \va3_0, \vt3_0
    vadd.vv  \va4_0, \va4_0, \vt4_0
    vadd.vv  \va5_0, \va5_0, \vt5_0
    vadd.vv  \va6_0, \va6_0, \vt6_0
    vadd.vv  \va7_0, \va7_0, \vt7_0
.endm

.macro gs_bfu \
        va0_0, va0_1, \
        xzeta0, xzetaqinv0, \
        xq, vt0_0, vt0_1
    vsub.vv  \vt0_0, \va0_0, \va0_1
    vadd.vv  \va0_0, \va0_0, \va0_1
    vmul.vx  \va0_1, \vt0_0, \xzetaqinv0
    vmulh.vx \vt0_1, \vt0_0, \xzeta0
    vmulh.vx \va0_1, \va0_1, \xq
    vsub.vv  \va0_1, \vt0_1, \va0_1
.endm

.macro gs_bfu_x2 \
        va0_0, va0_1, va1_0, va1_1, \
        xzeta0, xzetaqinv0, xzeta1, xzetaqinv1, \
        xq, \
        vt0_0, vt0_1, vt1_0, vt1_1
    vsub.vv  \vt0_0, \va0_0, \va0_1
    vsub.vv  \vt1_0, \va1_0, \va1_1
    vadd.vv  \va0_0, \va0_0, \va0_1
    vadd.vv  \va1_0, \va1_0, \va1_1
    vmul.vx  \va0_1, \vt0_0, \xzetaqinv0
    vmul.vx  \va1_1, \vt1_0, \xzetaqinv1
    vmulh.vx \vt0_1, \vt0_0, \xzeta0
    vmulh.vx \vt1_1, \vt1_0, \xzeta1
    vmulh.vx \va0_1, \va0_1, \xq
    vmulh.vx \va1_1, \va1_1, \xq
    vsub.vv  \va0_1, \vt0_1, \va0_1
    vsub.vv  \va1_1, \vt1_1, \va1_1
.endm

.macro gs_bfu_x4 \
        va0_0, va0_1, va1_0, va1_1, \
        va2_0, va2_1, va3_0, va3_1, \
        xzeta0, xzetaqinv0, xzeta1, xzetaqinv1, \
        xzeta2, xzetaqinv2, xzeta3, xzetaqinv3, \
        xq, \
        vt0_0, vt0_1, vt1_0, vt1_1, \
        vt2_0, vt2_1, vt3_0, vt3_1
    vsub.vv  \vt0_0, \va0_0, \va0_1
    vsub.vv  \vt1_0, \va1_0, \va1_1
    vsub.vv  \vt2_0, \va2_0, \va2_1
    vsub.vv  \vt3_0, \va3_0, \va3_1
    vadd.vv  \va0_0, \va0_0, \va0_1
    vadd.vv  \va1_0, \va1_0, \va1_1
    vadd.vv  \va2_0, \va2_0, \va2_1
    vadd.vv  \va3_0, \va3_0, \va3_1
    vmul.vx  \va0_1, \vt0_0, \xzetaqinv0
    vmul.vx  \va1_1, \vt1_0, \xzetaqinv1
    vmul.vx  \va2_1, \vt2_0, \xzetaqinv2
    vmul.vx  \va3_1, \vt3_0, \xzetaqinv3
    vmulh.vx \vt0_1, \vt0_0, \xzeta0
    vmulh.vx \vt1_1, \vt1_0, \xzeta1
    vmulh.vx \vt2_1, \vt2_0, \xzeta2
    vmulh.vx \vt3_1, \vt3_0, \xzeta3
    vmulh.vx \va0_1, \va0_1, \xq
    vmulh.vx \va1_1, \va1_1, \xq
    vmulh.vx \va2_1, \va2_1, \xq
    vmulh.vx \va3_1, \va3_1, \xq
    vsub.vv  \va0_1, \vt0_1, \va0_1
    vsub.vv  \va1_1, \vt1_1, \va1_1
    vsub.vv  \va2_1, \vt2_1, \va2_1
    vsub.vv  \va3_1, \vt3_1, \va3_1
.endm

.macro gs_bfu_vv_x4 \
        va0_0, va0_1, va1_0, va1_1, \
        va2_0, va2_1, va3_0, va3_1, \
        vzeta0, vzetaqinv0, vzeta1, vzetaqinv1, \
        vzeta2, vzetaqinv2, vzeta3, vzetaqinv3, \
        xq, \
        vt0_0, vt0_1, vt1_0, vt1_1, \
        vt2_0, vt2_1, vt3_0, vt3_1
    vsub.vv  \vt0_0, \va0_0, \va0_1
    vsub.vv  \vt1_0, \va1_0, \va1_1
    vsub.vv  \vt2_0, \va2_0, \va2_1
    vsub.vv  \vt3_0, \va3_0, \va3_1
    vadd.vv  \va0_0, \va0_0, \va0_1
    vadd.vv  \va1_0, \va1_0, \va1_1
    vadd.vv  \va2_0, \va2_0, \va2_1
    vadd.vv  \va3_0, \va3_0, \va3_1
    vmul.vv  \va0_1, \vt0_0, \vzetaqinv0
    vmul.vv  \va1_1, \vt1_0, \vzetaqinv1
    vmul.vv  \va2_1, \vt2_0, \vzetaqinv2
    vmul.vv  \va3_1, \vt3_0, \vzetaqinv3
    vmulh.vv \vt0_1, \vt0_0, \vzeta0
    vmulh.vv \vt1_1, \vt1_0, \vzeta1
    vmulh.vv \vt2_1, \vt2_0, \vzeta2
    vmulh.vv \vt3_1, \vt3_0, \vzeta3
    vmulh.vx \va0_1, \va0_1, \xq
    vmulh.vx \va1_1, \va1_1, \xq
    vmulh.vx \va2_1, \va2_1, \xq
    vmulh.vx \va3_1, \va3_1, \xq
    vsub.vv  \va0_1, \vt0_1, \va0_1
    vsub.vv  \va1_1, \vt1_1, \va1_1
    vsub.vv  \va2_1, \vt2_1, \va2_1
    vsub.vv  \va3_1, \vt3_1, \va3_1
.endm

.macro gs_bfu_x8 \
        va0_0, va0_1, va1_0, va1_1, \
        va2_0, va2_1, va3_0, va3_1, \
        va4_0, va4_1, va5_0, va5_1, \
        va6_0, va6_1, va7_0, va7_1, \
        xzeta0, xzetaqinv0, xzeta1, xzetaqinv1, \
        xzeta2, xzetaqinv2, xzeta3, xzetaqinv3, \
        xzeta4, xzetaqinv4, xzeta5, xzetaqinv5, \
        xzeta6, xzetaqinv6, xzeta7, xzetaqinv7, \
        xq, \
        vt0_0, vt0_1, vt1_0, vt1_1, \
        vt2_0, vt2_1, vt3_0, vt3_1, \
        vt4_0, vt4_1, vt5_0, vt5_1, \
        vt6_0, vt6_1, vt7_0, vt7_1
    vsub.vv  \vt0_0, \va0_0, \va0_1
    vsub.vv  \vt1_0, \va1_0, \va1_1
    vsub.vv  \vt2_0, \va2_0, \va2_1
    vsub.vv  \vt3_0, \va3_0, \va3_1
    vsub.vv  \vt4_0, \va4_0, \va4_1
    vsub.vv  \vt5_0, \va5_0, \va5_1
    vsub.vv  \vt6_0, \va6_0, \va6_1
    vsub.vv  \vt7_0, \va7_0, \va7_1
    vadd.vv  \va0_0, \va0_0, \va0_1
    vadd.vv  \va1_0, \va1_0, \va1_1
    vadd.vv  \va2_0, \va2_0, \va2_1
    vadd.vv  \va3_0, \va3_0, \va3_1
    vadd.vv  \va4_0, \va4_0, \va4_1
    vadd.vv  \va5_0, \va5_0, \va5_1
    vadd.vv  \va6_0, \va6_0, \va6_1
    vadd.vv  \va7_0, \va7_0, \va7_1
    vmul.vx  \va0_1, \vt0_0, \xzetaqinv0
    vmul.vx  \va1_1, \vt1_0, \xzetaqinv1
    vmul.vx  \va2_1, \vt2_0, \xzetaqinv2
    vmul.vx  \va3_1, \vt3_0, \xzetaqinv3
    vmul.vx  \va4_1, \vt4_0, \xzetaqinv4
    vmul.vx  \va5_1, \vt5_0, \xzetaqinv5
    vmul.vx  \va6_1, \vt6_0, \xzetaqinv6
    vmul.vx  \va7_1, \vt7_0, \xzetaqinv7
    vmulh.vx \vt0_1, \vt0_0, \xzeta0
    vmulh.vx \vt1_1, \vt1_0, \xzeta1
    vmulh.vx \vt2_1, \vt2_0, \xzeta2
    vmulh.vx \vt3_1, \vt3_0, \xzeta3
    vmulh.vx \vt4_1, \vt4_0, \xzeta4
    vmulh.vx \vt5_1, \vt5_0, \xzeta5
    vmulh.vx \vt6_1, \vt6_0, \xzeta6
    vmulh.vx \vt7_1, \vt7_0, \xzeta7
    vmulh.vx \va0_1, \va0_1, \xq
    vmulh.vx \va1_1, \va1_1, \xq
    vmulh.vx \va2_1, \va2_1, \xq
    vmulh.vx \va3_1, \va3_1, \xq
    vmulh.vx \va4_1, \va4_1, \xq
    vmulh.vx \va5_1, \va5_1, \xq
    vmulh.vx \va6_1, \va6_1, \xq
    vmulh.vx \va7_1, \va7_1, \xq
    vsub.vv  \va0_1, \vt0_1, \va0_1
    vsub.vv  \va1_1, \vt1_1, \va1_1
    vsub.vv  \va2_1, \vt2_1, \va2_1
    vsub.vv  \va3_1, \vt3_1, \va3_1
    vsub.vv  \va4_1, \vt4_1, \va4_1
    vsub.vv  \va5_1, \vt5_1, \va5_1
    vsub.vv  \va6_1, \vt6_1, \va6_1
    vsub.vv  \va7_1, \vt7_1, \va7_1
.endm

.macro ntt_rvv_level0
    lh t2, (_ZETAS_EXP+0)*2(a1)
    lh t1, (_ZETAS_EXP+1)*2(a1)
    # a[0-63] & a[128-191]
    vle16.v v1,  (a0);          addi a0, a0, 8*2 # a[0]
    vle16.v v2,  (a0);          addi a0, a0, 8*2
    vle16.v v3,  (a0);          addi a0, a0, 8*2
    vle16.v v4,  (a0);          addi a0, a0, 8*2
    vle16.v v5,  (a0);          addi a0, a0, 8*2
    vle16.v v6,  (a0);          addi a0, a0, 8*2
    vle16.v v7,  (a0);          addi a0, a0, 8*2
    vle16.v v8,  (a0);          addi a0, a0, -7*8*2+128*2
    vle16.v v9,  (a0);          addi a0, a0, 8*2 # a[128]
    vle16.v v10, (a0);          addi a0, a0, 8*2
    vle16.v v11, (a0);          addi a0, a0, 8*2
    vle16.v v12, (a0);          addi a0, a0, 8*2
    vle16.v v13, (a0);          addi a0, a0, 8*2
    vle16.v v14, (a0);          addi a0, a0, 8*2
    vle16.v v15, (a0);          addi a0, a0, 8*2
    vle16.v v16, (a0);          addi a0, a0, -7*8*2-128*2
    ct_bfu_x8 \
        v1, v9, v2, v10,v3, v11,v4, v12,\
        v5, v13,v6, v14,v7, v15,v8, v16,\
        t1, t2, t1, t2, t1, t2, t1, t2, \
        t1, t2, t1, t2, t1, t2, t1, t2, \
        t0, \
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v25,v26,v27,v28,v29,v30,v31,v0
    vse16.v v1,  (a0);          addi a0, a0, 8*2 # a[0]
    vse16.v v2,  (a0);          addi a0, a0, 8*2
    vse16.v v3,  (a0);          addi a0, a0, 8*2
    vse16.v v4,  (a0);          addi a0, a0, 8*2
    vse16.v v5,  (a0);          addi a0, a0, 8*2
    vse16.v v6,  (a0);          addi a0, a0, 8*2
    vse16.v v7,  (a0);          addi a0, a0, 8*2
    vse16.v v8,  (a0);          addi a0, a0, -7*8*2+128*2
    vse16.v v9,  (a0);          addi a0, a0, 8*2 # a[128]
    vse16.v v10, (a0);          addi a0, a0, 8*2
    vse16.v v11, (a0);          addi a0, a0, 8*2
    vse16.v v12, (a0);          addi a0, a0, 8*2
    vse16.v v13, (a0);          addi a0, a0, 8*2
    vse16.v v14, (a0);          addi a0, a0, 8*2
    vse16.v v15, (a0);          addi a0, a0, 8*2
    vse16.v v16, (a0);          addi a0, a0, -7*8*2-128*2+64*2
    # a[64-127] & a[192-255]
    vle16.v v1,  (a0);          addi a0, a0, 8*2 # a[64]
    vle16.v v2,  (a0);          addi a0, a0, 8*2
    vle16.v v3,  (a0);          addi a0, a0, 8*2
    vle16.v v4,  (a0);          addi a0, a0, 8*2
    vle16.v v5,  (a0);          addi a0, a0, 8*2
    vle16.v v6,  (a0);          addi a0, a0, 8*2
    vle16.v v7,  (a0);          addi a0, a0, 8*2
    vle16.v v8,  (a0);          addi a0, a0, -7*8*2+128*2
    vle16.v v9,  (a0);          addi a0, a0, 8*2 # a[192]
    vle16.v v10, (a0);          addi a0, a0, 8*2
    vle16.v v11, (a0);          addi a0, a0, 8*2
    vle16.v v12, (a0);          addi a0, a0, 8*2
    vle16.v v13, (a0);          addi a0, a0, 8*2
    vle16.v v14, (a0);          addi a0, a0, 8*2
    vle16.v v15, (a0);          addi a0, a0, 8*2
    vle16.v v16, (a0);          addi a0, a0, -7*8*2-128*2
    ct_bfu_x8 \
        v1, v9, v2, v10,v3, v11,v4, v12,\
        v5, v13,v6, v14,v7, v15,v8, v16,\
        t1, t2, t1, t2, t1, t2, t1, t2, \
        t1, t2, t1, t2, t1, t2, t1, t2, \
        t0, \
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v25,v26,v27,v28,v29,v30,v31,v0
    vse16.v v1,  (a0);          addi a0, a0, 8*2 # a[64]
    vse16.v v2,  (a0);          addi a0, a0, 8*2
    vse16.v v3,  (a0);          addi a0, a0, 8*2
    vse16.v v4,  (a0);          addi a0, a0, 8*2
    vse16.v v5,  (a0);          addi a0, a0, 8*2
    vse16.v v6,  (a0);          addi a0, a0, 8*2
    vse16.v v7,  (a0);          addi a0, a0, 8*2
    vse16.v v8,  (a0);          addi a0, a0, -7*8*2+128*2
    vse16.v v9,  (a0);          addi a0, a0, 8*2 # a[192]
    vse16.v v10, (a0);          addi a0, a0, 8*2
    vse16.v v11, (a0);          addi a0, a0, 8*2
    vse16.v v12, (a0);          addi a0, a0, 8*2
    vse16.v v13, (a0);          addi a0, a0, 8*2
    vse16.v v14, (a0);          addi a0, a0, 8*2
    vse16.v v15, (a0);          addi a0, a0, 8*2
    vse16.v v16, (a0);          addi a0, a0, -7*8*2-128*2-64*2
.endm

.macro ntt_rvv_level1to6 off
    addi a0, a0, (\off*128)*2   # a[0] or a[128]
    vle16.v v1,  (a0);          addi a0, a0, 8*2
    vle16.v v2,  (a0);          addi a0, a0, 8*2
    vle16.v v3,  (a0);          addi a0, a0, 8*2
    vle16.v v4,  (a0);          addi a0, a0, 8*2
    vle16.v v5,  (a0);          addi a0, a0, 8*2
    vle16.v v6,  (a0);          addi a0, a0, 8*2
    vle16.v v7,  (a0);          addi a0, a0, 8*2
    vle16.v v8,  (a0);          addi a0, a0, -7*8*2+64*2
    vle16.v v9,  (a0);          addi a0, a0, 8*2 # a[64] or a[192]
    vle16.v v10, (a0);          addi a0, a0, 8*2
    vle16.v v11, (a0);          addi a0, a0, 8*2
    vle16.v v12, (a0);          addi a0, a0, 8*2
    vle16.v v13, (a0);          addi a0, a0, 8*2
    vle16.v v14, (a0);          addi a0, a0, 8*2
    vle16.v v15, (a0);          addi a0, a0, 8*2
    vle16.v v16, (a0);          addi a0, a0, -7*8*2-64*2
    // level 1
    lh t2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L1 + \off*_ZETAS_EXP_1TO6_P1_L1)*2(a1)
    lh t1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L1 + \off*_ZETAS_EXP_1TO6_P1_L1 + 1)*2(a1)
    ct_bfu_x8 \
        v1, v9, v2, v10,v3, v11,v4, v12,\
        v5, v13,v6, v14,v7, v15,v8, v16,\
        t1, t2, t1, t2, t1, t2, t1, t2, \
        t1, t2, t1, t2, t1, t2, t1, t2, \
        t0, \
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v25,v26,v27,v28,v29,v30,v31,v0
    // level 2
    lh t2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2)*2(a1)
    lh t1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2 + 1)*2(a1)
    lh t4, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2 + 2)*2(a1)
    lh t3, ((1-\off)*_ZETAS_EXP_1TO6_P0_L2 + \off*_ZETAS_EXP_1TO6_P1_L2 + 3)*2(a1)
    ct_bfu_x8 \
        v1, v5, v2, v6, v3, v7, v4, v8, \
        v9, v13,v10,v14,v11,v15,v12,v16,\
        t1, t2, t1, t2, t1, t2, t1, t2, \
        t3, t4, t3, t4, t3, t4, t3, t4, \
        t0, \
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v25,v26,v27,v28,v29,v30,v31,v0
    // level 3
    lh t2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 0)*2(a1)
    lh t1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 1)*2(a1)
    lh t4, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 2)*2(a1)
    lh t3, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 3)*2(a1)
    lh t6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 4)*2(a1)
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 5)*2(a1)
    lh a6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 6)*2(a1)
    lh a5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L3 + \off*_ZETAS_EXP_1TO6_P1_L3 + 7)*2(a1)
    ct_bfu_x8 \
        v1, v3, v2, v4, v5, v7, v6, v8, \
        v9, v11,v10,v12,v13,v15,v14,v16,\
        t1, t2, t1, t2, t3, t4, t3, t4, \
        t5, t6, t5, t6, a5, a6, a5, a6, \
        t0, \
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v25,v26,v27,v28,v29,v30,v31,v0
    // level 4
    lh t2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 0)*2(a1)
    lh t1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 1)*2(a1)
    lh t4, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 2)*2(a1)
    lh t3, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 3)*2(a1)
    lh t6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 4)*2(a1)
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 5)*2(a1)
    lh a6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 6)*2(a1)
    lh a5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 7)*2(a1)
    ct_bfu_x4 \
        v1, v2, v3, v4, v5, v6, v7, v8, \
        t1, t2, t3, t4, t5, t6, a5, a6, \
        t0, \
        v17,v18,v19,v20,v21,v22,v23,v24
    lh t2, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 8)*2(a1)
    lh t1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 + 9)*2(a1)
    lh t4, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +10)*2(a1)
    lh t3, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +11)*2(a1)
    lh t6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +12)*2(a1)
    lh t5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +13)*2(a1)
    lh a6, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +14)*2(a1)
    lh a5, ((1-\off)*_ZETAS_EXP_1TO6_P0_L4 + \off*_ZETAS_EXP_1TO6_P1_L4 +15)*2(a1)
    ct_bfu_x4 \
        v9, v10,v11,v12,v13,v14,v15,v16,\
        t1, t2, t3, t4, t5, t6, a5, a6, \
        t0, \
        v17,v18,v19,v20,v21,v22,v23,v24
    addi t4, a1, _MASK_11110000*2
    vle16.v v0, (t4)
    addi t4, a1, _MASK_45674567*2
    vle16.v v31, (t4)
    addi t4, a1, _MASK_01230123*2
    vle16.v v30, (t4)
    shuffle4_x4 \
        v1, v2, v3, v4, v5, v6, v7, v8, \
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v31,v30
    shuffle4_x4 \
        v9, v10,v11,v12,v13,v14,v15,v16,\
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v31,v30
    # format: [a0~a3,a8~a11],[a4~a7,a12~a15]
    // level 5
    addi t4, a1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L5+\off*_ZETAS_EXP_1TO6_P1_L5)*2
    vle16.v v31, (t4);          addi t4, t4, 8*2
    vle16.v v30, (t4);          addi t4, t4, 8*2
    vle16.v v29, (t4);          addi t4, t4, 8*2
    vle16.v v28, (t4);          addi t4, t4, 8*2
    vle16.v v27, (t4);          addi t4, t4, 8*2
    vle16.v v26, (t4);          addi t4, t4, 8*2
    vle16.v v25, (t4);          addi t4, t4, 8*2
    vle16.v v24, (t4);          addi t4, t4, 8*2
    ct_bfu_vv_x4 \
        v1, v2, v3, v4, v5, v6, v7, v8, \
        v30,v31,v28,v29,v26,v27,v24,v25,\
        t0, \
        v17,v18,v19,v20,v21,v22,v23,v0
    vle16.v v31, (t4);          addi t4, t4, 8*2
    vle16.v v30, (t4);          addi t4, t4, 8*2
    vle16.v v29, (t4);          addi t4, t4, 8*2
    vle16.v v28, (t4);          addi t4, t4, 8*2
    vle16.v v27, (t4);          addi t4, t4, 8*2
    vle16.v v26, (t4);          addi t4, t4, 8*2
    vle16.v v25, (t4);          addi t4, t4, 8*2
    vle16.v v24, (t4)
    ct_bfu_vv_x4 \
        v9, v10,v11,v12,v13,v14,v15,v16,\
        v30,v31,v28,v29,v26,v27,v24,v25,\
        t0, \
        v17,v18,v19,v20,v21,v22,v23,v0
    addi t4, a1, _MASK_11001100*2
    vle16.v v0, (t4)
    addi t4, a1, _MASK_00010045*2
    vle16.v v31, (t4)
    addi t4, a1, _MASK_23006700*2
    vle16.v v30, (t4)
    shuffle2_x4 \
        v1, v2, v3, v4, v5, v6, v7, v8, \
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v31, v30
    shuffle2_x4 \
        v9, v10,v11,v12,v13,v14,v15,v16,\
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v31, v30
    # format: [a0~a1,a4~a5,a8~a9,a12~a13]+[a2~a3,a6~a7,a10~a11,a14~a15]
    // level 6
    addi t4, a1, ((1-\off)*_ZETAS_EXP_1TO6_P0_L6+ \off*_ZETAS_EXP_1TO6_P1_L6)*2
    vle16.v v31, (t4);          addi t4, t4, 8*2     
    vle16.v v30, (t4);          addi t4, t4, 8*2     
    vle16.v v29, (t4);          addi t4, t4, 8*2     
    vle16.v v28, (t4);          addi t4, t4, 8*2     
    vle16.v v27, (t4);          addi t4, t4, 8*2     
    vle16.v v26, (t4);          addi t4, t4, 8*2     
    vle16.v v25, (t4);          addi t4, t4, 8*2     
    vle16.v v24, (t4);          addi t4, t4, 8*2
    ct_bfu_vv_x4 \
        v1, v2, v3, v4, v5, v6, v7, v8, \
        v30,v31,v28,v29,v26,v27,v24,v25,\
        t0, \
        v17,v18,v19,v20,v21,v22,v23,v0
    vle16.v v31, (t4);          addi t4, t4, 8*2     
    vle16.v v30, (t4);          addi t4, t4, 8*2     
    vle16.v v29, (t4);          addi t4, t4, 8*2     
    vle16.v v28, (t4);          addi t4, t4, 8*2     
    vle16.v v27, (t4);          addi t4, t4, 8*2     
    vle16.v v26, (t4);          addi t4, t4, 8*2     
    vle16.v v25, (t4);          addi t4, t4, 8*2     
    vle16.v v24, (t4)
    ct_bfu_vv_x4 \
        v9, v10,v11,v12,v13,v14,v15,v16,\
        v30,v31,v28,v29,v26,v27,v24,v25,\
        t0, \
        v17,v18,v19,v20,v21,v22,v23,v0
    addi t4, a1, _MASK_10101010*2
    vle16.v v0, (t4)
    addi t4, a1, _MASK_10325476*2
    vle16.v v27, (t4)
    shuffle1_x4 \
        v1, v2, v3, v4, v5, v6, v7, v8, \
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v27
    shuffle1_x4 \
        v9, v10,v11,v12,v13,v14,v15,v16,\
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v27
    vse16.v v1,  (a0);          addi a0, a0, 8*2
    vse16.v v2,  (a0);          addi a0, a0, 8*2
    vse16.v v3,  (a0);          addi a0, a0, 8*2
    vse16.v v4,  (a0);          addi a0, a0, 8*2
    vse16.v v5,  (a0);          addi a0, a0, 8*2
    vse16.v v6,  (a0);          addi a0, a0, 8*2
    vse16.v v7,  (a0);          addi a0, a0, 8*2
    vse16.v v8,  (a0);          addi a0, a0, -7*8*2+64*2
    vse16.v v9,  (a0);          addi a0, a0, 8*2
    vse16.v v10, (a0);          addi a0, a0, 8*2
    vse16.v v11, (a0);          addi a0, a0, 8*2
    vse16.v v12, (a0);          addi a0, a0, 8*2
    vse16.v v13, (a0);          addi a0, a0, 8*2
    vse16.v v14, (a0);          addi a0, a0, 8*2
    vse16.v v15, (a0);          addi a0, a0, 8*2
    vse16.v v16, (a0);          addi a0, a0, -7*8*2-64*2-(\off*128)*2
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
    ntt_rvv_level1to6 0
    ntt_rvv_level1to6 1
ret
