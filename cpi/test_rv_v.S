.globl init_vector_e16
.align 2
init_vector_e16:
    li t1, 128
    vsetvli a0, t1, e16, m1, tu, mu
ret

.globl init_vector_e32
.align 2
init_vector_e32:
    li t1, 128
    vsetvli a0, t1, e32, m1, tu, mu
ret

.globl cpi_vle16
.align 2
cpi_vle16:
.rep 200
    vle16.v v0, (a0)
    vle16.v v1, (a0)
    vle16.v v2, (a0)
    vle16.v v3, (a0)
    vle16.v v4, (a0)
    vle16.v v5, (a0)
    vle16.v v6, (a0)
    vle16.v v7, (a0)
    vle16.v v8, (a0)
    vle16.v v9, (a0)
.endr
ret

.globl cpi_vle16_add
.align 2
cpi_vle16_add:
.rep 200
    vle16.v v0, (a0)
    vadd.vv v10, v0, v0
    vadd.vv v11, v0, v0
    vadd.vv v12, v0, v0
    vadd.vv v13, v0, v0
.endr
ret

.globl cpi_vse16
.align 2
cpi_vse16:
.rep 200
    vse16.v v0, (a0)
    vse16.v v1, (a1)
    vse16.v v2, (a2)
    vse16.v v3, (a3)
.endr
ret

# Since there is no data dependency between vse and vadd instructions, the actual latency of vse instruction cannot be reflected.
.globl cpi_vse16_add
.align 2
cpi_vse16_add:
.rep 200
    vse16.v v0, (a0)
    vadd.vv v10, v0, v0
    vadd.vv v11, v0, v0
    vadd.vv v12, v0, v0
    vadd.vv v13, v0, v0
.endr
ret

.globl cpi_vmulvx
.align 2
cpi_vmulvx:
.rep 200
    vmul.vx v0, v0, t0
    vmul.vx v1, v1, t0
    vmul.vx v2, v2, t0
    vmul.vx v3, v3, t0
    vmul.vx v4, v4, t0
    vmul.vx v5, v5, t0
    vmul.vx v6, v6, t0
    vmul.vx v7, v7, t0
    vmul.vx v8, v8, t0
    vmul.vx v9, v9, t0
.endr
ret

.globl cpi_vmulvx_x1
.align 2
cpi_vmulvx_x1:
.rep 2000
    vmul.vx v0, v0, t0
.endr
ret

.globl cpi_vmulvx_x2
.align 2
cpi_vmulvx_x2:
.rep 1000
    vmul.vx v0, v0, t0
    vmul.vx v1, v1, t0
.endr
ret

.globl cpi_vmulvx_x4
.align 2
cpi_vmulvx_x4:
.rep 500
    vmul.vx v0, v0, t0
    vmul.vx v1, v1, t0
    vmul.vx v2, v2, t0
    vmul.vx v3, v3, t0
.endr
ret

.globl cpi_vmulvv
.align 2
cpi_vmulvv:
.rep 200
    vmul.vv v0, v0, v10
    vmul.vv v1, v1, v10
    vmul.vv v2, v2, v10
    vmul.vv v3, v3, v10
    vmul.vv v4, v4, v10
    vmul.vv v5, v5, v10
    vmul.vv v6, v6, v10
    vmul.vv v7, v7, v10
    vmul.vv v8, v8, v10
    vmul.vv v9, v9, v10
.endr
ret

.globl cpi_vmulvv_x1
.align 2
cpi_vmulvv_x1:
.rep 2000
    vmul.vv v0, v0, v0
.endr
ret

.globl cpi_vmulvv_x2
.align 2
cpi_vmulvv_x2:
.rep 1000
    vmul.vv v0, v0, v10
    vmul.vv v1, v1, v10
.endr
ret

.globl cpi_vmulvv_x4
.align 2
cpi_vmulvv_x4:
.rep 500
    vmul.vv v0, v0, v10
    vmul.vv v1, v1, v10
    vmul.vv v2, v2, v10
    vmul.vv v3, v3, v10
.endr
ret

.globl cpi_vmulhvv
.align 2
cpi_vmulhvv:
.rep 200
    vmulh.vv v0, v0, v10
    vmulh.vv v1, v1, v10
    vmulh.vv v2, v2, v10
    vmulh.vv v3, v3, v10
    vmulh.vv v4, v4, v10
    vmulh.vv v5, v5, v10
    vmulh.vv v6, v6, v10
    vmulh.vv v7, v7, v10
    vmulh.vv v8, v8, v10
    vmulh.vv v9, v9, v10
.endr
ret

.globl cpi_vmulhvv_x1
.align 2
cpi_vmulhvv_x1:
.rep 2000
    vmulh.vv v0, v0, v0
.endr
ret

.globl cpi_vmulhvv_x2
.align 2
cpi_vmulhvv_x2:
.rep 1000
    vmulh.vv v0, v0, v10
    vmulh.vv v1, v1, v10
.endr
ret

.globl cpi_vmulhvv_x4
.align 2
cpi_vmulhvv_x4:
.rep 500
    vmulh.vv v0, v0, v10
    vmulh.vv v1, v1, v10
    vmulh.vv v2, v2, v10
    vmulh.vv v3, v3, v10
.endr
ret

.globl cpi_vaddvv
.align 2
cpi_vaddvv:
.rep 200
    vadd.vv v0, v0, v10
    vadd.vv v1, v1, v10
    vadd.vv v2, v2, v10
    vadd.vv v3, v3, v10
    vadd.vv v4, v4, v10
    vadd.vv v5, v5, v10
    vadd.vv v6, v6, v10
    vadd.vv v7, v7, v10
    vadd.vv v8, v8, v10
    vadd.vv v9, v9, v10
.endr
ret

.globl cpi_vaddvx
.align 2
cpi_vaddvx:
.rep 200
    vadd.vx v0, v0, t2
    vadd.vx v1, v1, t2
    vadd.vx v2, v2, t2
    vadd.vx v3, v3, t2
    vadd.vx v4, v4, t2
    vadd.vx v5, v5, t2
    vadd.vx v6, v6, t2
    vadd.vx v7, v7, t2
    vadd.vx v8, v8, t2
    vadd.vx v9, v9, t2
.endr
ret

.globl cpi_vaddvx_x1
.align 2
cpi_vaddvx_x1:
.rep 2000
    vadd.vx v0, v0, t2
.endr
ret

.globl cpi_vaddvx_x2
.align 2
cpi_vaddvx_x2:
.rep 1000
    vadd.vx v0, v0, t2
    vadd.vx v1, v1, t2
.endr
ret

.globl cpi_vaddvx_x4
.align 2
cpi_vaddvx_x4:
.rep 500
    vadd.vx v0, v0, t2
    vadd.vx v1, v1, t2
    vadd.vx v2, v2, t2
    vadd.vx v3, v3, t2
.endr
ret

.globl cpi_vandvv
.align 2
cpi_vandvv:
.rep 200
    vand.vv v0, v0, v10
    vand.vv v1, v1, v10
    vand.vv v2, v2, v10
    vand.vv v3, v3, v10
    vand.vv v4, v4, v10
    vand.vv v5, v5, v10
    vand.vv v6, v6, v10
    vand.vv v7, v7, v10
    vand.vv v8, v8, v10
    vand.vv v9, v9, v10
.endr
ret

.globl cpi_vandvx
.align 2
cpi_vandvx:
.rep 200
    vand.vx v0, v0, t0
    vand.vx v1, v1, t0
    vand.vx v2, v2, t0
    vand.vx v3, v3, t0
    vand.vx v4, v4, t0
    vand.vx v5, v5, t0
    vand.vx v6, v6, t0
    vand.vx v7, v7, t0
    vand.vx v8, v8, t0
    vand.vx v9, v9, t0
.endr
ret

.globl cpi_vandvx_and_hybrid_v1
.align 2
cpi_vandvx_and_hybrid_v1:
.rep 200
    vand.vx v0, v0, t0
    vand.vx v1, v1, t0
    and t1, t1, t1
    vand.vx v2, v2, t0
    vand.vx v3, v3, t0
    and t2, t2, t2
    vand.vx v4, v4, t0
    vand.vx v5, v5, t0
    and t3, t3, t3
    vand.vx v6, v6, t0
    vand.vx v7, v7, t0
    and t4, t4, t4
    vand.vx v8, v8, t0
    vand.vx v9, v9, t0
    and t5, t5, t5
.endr
ret

.globl cpi_vandvx_and_hybrid_v2
.align 2
cpi_vandvx_and_hybrid_v2:
.rep 200
    vand.vx v0, v0, t0
    vand.vx v1, v1, t0
    and t1, t1, t1
    and a1, a1, a1
    vand.vx v2, v2, t0
    vand.vx v3, v3, t0
    and t2, t2, t2
    and a2, t1, a2
    vand.vx v4, v4, t0
    vand.vx v5, v5, t0
    and t3, t3, t3
    and a3, a3, a3
    vand.vx v6, v6, t0
    vand.vx v7, v7, t0
    and t4, t4, t4
    and a4, a4, a4
    vand.vx v8, v8, t0
    vand.vx v9, v9, t0
    and t5, t5, t5
    and a5, a5, a5
.endr
ret

.globl cpi_vandvx_and_hybrid_v3
.align 2
cpi_vandvx_and_hybrid_v3:
.rep 200
    vand.vx v0, v0, t0
    vand.vx v1, v1, t0
    and t1, t1, t1
    and a1, a1, a1
    and t1, t1, t1
    vand.vx v2, v2, t0
    vand.vx v3, v3, t0
    and t2, t2, t2
    and a2, t1, a2
    and t2, t2, t2
    vand.vx v4, v4, t0
    vand.vx v5, v5, t0
    and t3, t3, t3
    and a3, a3, a3
    and t3, t3, t3
    vand.vx v6, v6, t0
    vand.vx v7, v7, t0
    and t4, t4, t4
    and a4, a4, a4
    and t4, t4, t4
    vand.vx v8, v8, t0
    vand.vx v9, v9, t0
    and t5, t5, t5
    and a5, a5, a5
    and t5, t5, t5
.endr
ret

.globl cpi_vandvx_and_hybrid_v4
.align 2
cpi_vandvx_and_hybrid_v4:
.rep 200
    vand.vx v0, v0, t0
    vand.vx v1, v1, t0
    and t1, t1, t1
    and a1, a1, a1
    and t1, t1, t1
    and a1, a1, a1
    vand.vx v2, v2, t0
    vand.vx v3, v3, t0
    and t2, t2, t2
    and a2, t1, a2
    and t2, t2, t2
    and a2, t1, a2
    vand.vx v4, v4, t0
    vand.vx v5, v5, t0
    and t3, t3, t3
    and a3, a3, a3
    and t3, t3, t3
    and a3, a3, a3
    vand.vx v6, v6, t0
    vand.vx v7, v7, t0
    and t4, t4, t4
    and a4, a4, a4
    and t4, t4, t4
    and a4, a4, a4
    vand.vx v8, v8, t0
    vand.vx v9, v9, t0
    and t5, t5, t5
    and a5, a5, a5
    and t5, t5, t5
    and a5, a5, a5
.endr
ret

.globl cpi_vandvx_and_hybrid_v4_1
.align 2
cpi_vandvx_and_hybrid_v4_1:
.rep 200
    vand.vx v0, v0, t0
    and t1, t1, t1
    and a1, a1, a1
    vand.vx v1, v1, t0
    and t1, t1, t1
    and a1, a1, a1
    vand.vx v2, v2, t0
    and t2, t2, t2
    and a2, t1, a2
    vand.vx v3, v3, t0
    and t2, t2, t2
    and a2, t1, a2
    vand.vx v4, v4, t0
    and t3, t3, t3
    and a3, a3, a3
    vand.vx v5, v5, t0
    and t3, t3, t3
    and a3, a3, a3
    vand.vx v6, v6, t0
    and t4, t4, t4
    and a4, a4, a4
    vand.vx v7, v7, t0
    and t4, t4, t4
    and a4, a4, a4
    vand.vx v8, v8, t0
    and t5, t5, t5
    and a5, a5, a5
    vand.vx v9, v9, t0
    and t5, t5, t5
    and a5, a5, a5
.endr
ret

.globl cpi_vandvx_and_hybrid_v5
.align 2
cpi_vandvx_and_hybrid_v5:
.rep 200
    vand.vx v0, v0, t0
    vand.vx v1, v1, t0
    and t1, t1, t1
    and a1, a1, a1
    and t1, t1, t1
    and a1, a1, a1
    and t1, t1, t1
    vand.vx v2, v2, t0
    vand.vx v3, v3, t0
    and t2, t2, t2
    and a2, t1, a2
    and t2, t2, t2
    and a2, t1, a2
    and t2, t2, t2
    vand.vx v4, v4, t0
    vand.vx v5, v5, t0
    and t3, t3, t3
    and a3, a3, a3
    and t3, t3, t3
    and a3, a3, a3
    and t3, t3, t3
    vand.vx v6, v6, t0
    vand.vx v7, v7, t0
    and t4, t4, t4
    and a4, a4, a4
    and t4, t4, t4
    and a4, a4, a4
    and t4, t4, t4
    vand.vx v8, v8, t0
    vand.vx v9, v9, t0
    and t5, t5, t5
    and a5, a5, a5
    and t5, t5, t5
    and a5, a5, a5
    and t5, t5, t5
.endr
ret

.globl cpi_vandvx_and_hybrid_v6
.align 2
cpi_vandvx_and_hybrid_v6:
.rep 200
    vand.vx v0, v0, t0
    vand.vx v1, v1, t0
    and t1, t1, t1
    and a1, a1, a1
    and t1, t1, t1
    and a1, a1, a1
    and t1, t1, t1
    and a1, a1, a1
    vand.vx v2, v2, t0
    vand.vx v3, v3, t0
    and t2, t2, t2
    and a2, t1, a2
    and t2, t2, t2
    and a2, t1, a2
    and t2, t2, t2
    and a2, t1, a2
    vand.vx v4, v4, t0
    vand.vx v5, v5, t0
    and t3, t3, t3
    and a3, a3, a3
    and t3, t3, t3
    and a3, a3, a3
    and t3, t3, t3
    and a3, a3, a3
    vand.vx v6, v6, t0
    vand.vx v7, v7, t0
    and t4, t4, t4
    and a4, a4, a4
    and t4, t4, t4
    and a4, a4, a4
    and t4, t4, t4
    and a4, a4, a4
    vand.vx v8, v8, t0
    vand.vx v9, v9, t0
    and t5, t5, t5
    and a5, a5, a5
    and t5, t5, t5
    and a5, a5, a5
    and t5, t5, t5
    and a5, a5, a5
.endr
ret

.globl cpi_vandvv_x1
.align 2
cpi_vandvv_x1:
.rep 2000
    vand.vv v0, v0, v10
.endr
ret

.globl cpi_vandvv_x2
.align 2
cpi_vandvv_x2:
.rep 1000
    vand.vv v0, v0, v10
    vand.vv v1, v1, v10
.endr
ret

.globl cpi_vandvv_x4
.align 2
cpi_vandvv_x4:
.rep 500
    vand.vv v0, v0, v10
    vand.vv v1, v1, v10
    vand.vv v2, v2, v10
    vand.vv v3, v3, v10
.endr
ret

.globl cpi_vnotv
.align 2
cpi_vnotv:
.rep 200
    vnot.v v0, v0
    vnot.v v1, v1
    vnot.v v2, v2
    vnot.v v3, v3
    vnot.v v4, v4
    vnot.v v5, v5
    vnot.v v6, v6
    vnot.v v7, v7
    vnot.v v8, v8
    vnot.v v9, v9
.endr
ret

.globl cpi_vnotv_x1
.align 2
cpi_vnotv_x1:
.rep 2000
    vnot.v v0, v0
.endr
ret

.globl cpi_vnotv_x2
.align 2
cpi_vnotv_x2:
.rep 1000
    vnot.v v0, v0
    vnot.v v1, v1
.endr
ret

.globl cpi_vnotv_x4
.align 2
cpi_vnotv_x4:
.rep 500
    vnot.v v0, v0
    vnot.v v1, v1
    vnot.v v2, v2
    vnot.v v3, v3
.endr
ret

.globl cpi_vxorvv
.align 2
cpi_vxorvv:
.rep 200
    vxor.vv v0, v0, v10
    vxor.vv v1, v1, v10
    vxor.vv v2, v2, v10
    vxor.vv v3, v3, v10
    vxor.vv v4, v4, v10
    vxor.vv v5, v5, v10
    vxor.vv v6, v6, v10
    vxor.vv v7, v7, v10
    vxor.vv v8, v8, v10
    vxor.vv v9, v9, v10
.endr
ret

.globl cpi_vxorvv_x1
.align 2
cpi_vxorvv_x1:
.rep 2000
    vxor.vv v0, v0, v10
.endr
ret

.globl cpi_vxorvv_x2
.align 2
cpi_vxorvv_x2:
.rep 1000
    vxor.vv v0, v0, v10
    vxor.vv v1, v1, v10
.endr
ret

.globl cpi_vxorvv_x4
.align 2
cpi_vxorvv_x4:
.rep 500
    vxor.vv v0, v0, v10
    vxor.vv v1, v1, v10
    vxor.vv v2, v2, v10
    vxor.vv v3, v3, v10
.endr
ret

.globl cpi_vsllvi
.align 2
cpi_vsllvi:
.rep 200
    vsll.vi v0, v0, 10
    vsll.vi v1, v1, 10
    vsll.vi v2, v2, 10
    vsll.vi v3, v3, 10
    vsll.vi v4, v4, 10
    vsll.vi v5, v5, 10
    vsll.vi v6, v6, 10
    vsll.vi v7, v7, 10
    vsll.vi v8, v8, 10
    vsll.vi v9, v9, 10
.endr
ret

.globl cpi_vsllvi_x1
.align 2
cpi_vsllvi_x1:
.rep 2000
    vsll.vi v0, v0, 10
.endr
ret

.globl cpi_vsllvi_x2
.align 2
cpi_vsllvi_x2:
.rep 1000
    vsll.vi v0, v0, 10
    vsll.vi v1, v1, 10
.endr
ret

.globl cpi_vsllvi_x4
.align 2
cpi_vsllvi_x4:
.rep 500
    vsll.vi v0, v0, 10
    vsll.vi v1, v1, 10
    vsll.vi v2, v2, 10
    vsll.vi v3, v3, 10
.endr
ret

.globl cpi_vsrlvx
.align 2
cpi_vsrlvx:
.rep 200
    vsrl.vx v0, v0, t0
    vsrl.vx v1, v1, t0
    vsrl.vx v2, v2, t0
    vsrl.vx v3, v3, t0
    vsrl.vx v4, v4, t0
    vsrl.vx v5, v5, t0
    vsrl.vx v6, v6, t0
    vsrl.vx v7, v7, t0
    vsrl.vx v8, v8, t0
    vsrl.vx v9, v9, t0
.endr
ret

.globl cpi_vsrlvx_x1
.align 2
cpi_vsrlvx_x1:
.rep 2000
    vsrl.vx v0, v0, t0
.endr
ret

.globl cpi_vsrlvx_x2
.align 2
cpi_vsrlvx_x2:
.rep 1000
    vsrl.vx v0, v0, t0
    vsrl.vx v1, v1, t0
.endr
ret

.globl cpi_vsrlvx_x4
.align 2
cpi_vsrlvx_x4:
.rep 500
    vsrl.vx v0, v0, t0
    vsrl.vx v1, v1, t0
    vsrl.vx v2, v2, t0
    vsrl.vx v3, v3, t0
.endr
ret

.globl cpi_vsravi
.align 2
cpi_vsravi:
.rep 200
    vsra.vi v0, v0, 10
    vsra.vi v1, v1, 10
    vsra.vi v2, v2, 10
    vsra.vi v3, v3, 10
    vsra.vi v4, v4, 10
    vsra.vi v5, v5, 10
    vsra.vi v6, v6, 10
    vsra.vi v7, v7, 10
    vsra.vi v8, v8, 10
    vsra.vi v9, v9, 10
.endr
ret

.globl cpi_vsravi_x1
.align 2
cpi_vsravi_x1:
.rep 2000
    vsra.vi v0, v0, 10
.endr
ret

.globl cpi_vsravi_x2
.align 2
cpi_vsravi_x2:
.rep 1000
    vsra.vi v0, v0, 10
    vsra.vi v1, v1, 10
.endr
ret

.globl cpi_vsravi_x4
.align 2
cpi_vsravi_x4:
.rep 500
    vsra.vi v0, v0, 10
    vsra.vi v1, v1, 10
    vsra.vi v2, v2, 10
    vsra.vi v3, v3, 10
.endr
ret

.globl cpi_vrgathervv
.align 2
cpi_vrgathervv:
.rep 200
    vrgather.vv v0, v10, v20
    vrgather.vv v1, v11, v20
    vrgather.vv v2, v12, v20
    vrgather.vv v3, v13, v20
    vrgather.vv v4, v14, v20
    vrgather.vv v5, v15, v20
    vrgather.vv v6, v16, v20
    vrgather.vv v7, v17, v20
    vrgather.vv v8, v18, v20
    vrgather.vv v9, v19, v20
.endr
ret

.globl cpi_vrgathervv_x1
.align 2
cpi_vrgathervv_x1:
.rep 200
    vrgather.vv v1, v0, v20
    vrgather.vv v2, v1, v20
    vrgather.vv v3, v2, v20
    vrgather.vv v4, v3, v20
    vrgather.vv v5, v4, v20
    vrgather.vv v6, v5, v20
    vrgather.vv v7, v6, v20
    vrgather.vv v8, v7, v20
    vrgather.vv v9, v8, v20
    vrgather.vv v10, v9, v20
    vrgather.vv v11, v10, v20
    vrgather.vv v12, v11, v20
    vrgather.vv v13, v12, v20
    vrgather.vv v14, v13, v20
    vrgather.vv v15, v14, v20
    vrgather.vv v16, v15, v20
    vrgather.vv v17, v16, v20
    vrgather.vv v18, v17, v20
    vrgather.vv v0, v18, v20
.endr
ret

.globl cpi_vrgathervv_x2
.align 2
cpi_vrgathervv_x2:
.rep 1000
    vrgather.vv v1, v0, v20
    vrgather.vv v3, v2, v20
.endr
ret

.globl cpi_vrgathervv_x4
.align 2
cpi_vrgathervv_x4:
.rep 500
    vrgather.vv v1, v0, v20
    vrgather.vv v3, v2, v20
    vrgather.vv v5, v4, v20
    vrgather.vv v7, v6, v20
.endr
ret

.globl cpi_vmergevvm
.align 2
cpi_vmergevvm:
.rep 200
    vmerge.vvm v1, v1, v2, v0
    vmerge.vvm v3, v3, v4, v0
    vmerge.vvm v5, v5, v6, v0
    vmerge.vvm v7, v7, v8, v0
    vmerge.vvm v9, v9, v10,v0
    vmerge.vvm v11,v11,v12,v0
    vmerge.vvm v13,v13,v14,v0
    vmerge.vvm v15,v15,v16,v0
    vmerge.vvm v17,v17,v18,v0
    vmerge.vvm v19,v19,v20,v0
.endr
ret

.globl cpi_vmergevvm_x1
.align 2
cpi_vmergevvm_x1:
.rep 2000
    vmerge.vvm v1, v1, v2, v0
.endr
ret

.globl cpi_vmergevvm_x2
.align 2
cpi_vmergevvm_x2:
.rep 1000
    vmerge.vvm v1, v1, v2, v0
    vmerge.vvm v3, v3, v4, v0
.endr
ret

.globl cpi_vmergevvm_x4
.align 2
cpi_vmergevvm_x4:
.rep 500
    vmerge.vvm v1, v1, v2, v0
    vmerge.vvm v3, v3, v4, v0
    vmerge.vvm v5, v5, v6, v0
    vmerge.vvm v7, v7, v8, v0
.endr
ret
