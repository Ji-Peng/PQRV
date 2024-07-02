.globl poly_basemul_acc_double_8l_rvv
.align 2
poly_basemul_acc_double_8l_rvv:
    li t1, 128
    li t3, 16
poly_basemul_acc_double_8l_rvv_loop:
    vsetvli t2, t1, e32, m4, tu, mu
    vle32.v v0, (a1);   addi a1, a1, 4*4*4
    vle32.v v4, (a2);   addi a2, a2, 4*4*4
    vwmul.vv v8, v0, v4 # into v8-v15
    vsetvli t2, t1, e64, m8, tu, mu
    vle64.v v16, (a0)
    vadd.vv v8, v8, v16
    vse64.v v8, (a0);  addi a0, a0, 8*2*8
    addi t3, t3, -1
    bnez t3, poly_basemul_acc_double_8l_rvv_loop
ret
