.text

.globl vmul64
.align 2
vmul64:

    li a3, 128
    vsetvli a3, a3, e64, m1, tu, mu

    vle64.v v0, (a0)
    vle64.v v1, (a1)

    vmul.vv v2, v0, v1
    vmulh.vv v3, v0, v1
    
    vse64.v v2, (a2)
    addi a2, a2, 16
    vse64.v v3, (a2)

    ret