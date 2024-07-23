.text

.globl init_vector_e32_m1
.align 2
init_vector_e32_m1:
    li t1, 128
    vsetvli a0, t1, e32, m1, tu, mu
ret

.globl init_vector_e32_m8
.align 2
init_vector_e32_m8:
    li t1, 128
    vsetvli a0, t1, e32, m8, tu, mu
ret

.globl cpi_m1_vle32
.align 2
cpi_m1_vle32:
.rep 200
    vle32.v v0, (a0)
    vle32.v v1, (a0)
    vle32.v v2, (a0)
    vle32.v v3, (a0)
    vle32.v v4, (a0)
    vle32.v v5, (a0)
    vle32.v v6, (a0)
    vle32.v v7, (a0)
.endr
ret

.globl cpi_m8_vle32
.align 2
cpi_m8_vle32:
.rep 50
    vle32.v v0, (a0)
    vle32.v v8, (a0)
    vle32.v v16, (a0)
    vle32.v v24, (a0)
.endr
ret

.globl cpi_m1_vlse32
.align 2
cpi_m1_vlse32:
    li t3, 16
.rep 200
    vlse32.v v0, (a0), t3
    vlse32.v v1, (a0), t3
    vlse32.v v2, (a0), t3
    vlse32.v v3, (a0), t3
    vlse32.v v4, (a0), t3
    vlse32.v v5, (a0), t3
    vlse32.v v6, (a0), t3
    vlse32.v v7, (a0), t3
.endr
ret

.globl cpi_m8_vlse32
.align 2
cpi_m8_vlse32:
    li t3, 16
.rep 50
    vlse32.v v0,  (a0), t3
    vlse32.v v8,  (a0), t3
    vlse32.v v16, (a0), t3
    vlse32.v v24, (a0), t3
.endr
ret

.globl cpi_m1_vmulvx
.align 2
cpi_m1_vmulvx:
.rep 200
    vmul.vx v0, v0, a0
    vmul.vx v1, v1, a0
    vmul.vx v2, v2, a0
    vmul.vx v3, v3, a0
    vmul.vx v4, v4, a0
    vmul.vx v5, v5, a0
    vmul.vx v6, v6, a0
    vmul.vx v7, v7, a0
.endr
ret

.globl cpi_m8_vmulvx
.align 2
cpi_m8_vmulvx:
.rep 50
    vmul.vx v0,  v0,  a0
    vmul.vx v8,  v8,  a0
    vmul.vx v16, v16, a0
    vmul.vx v24, v24, a0
.endr
ret

.globl cpi_m1_vle32_vmul_vse32
.align 2
cpi_m1_vle32_vmul_vse32:
.rep 100
    vle32.v v0, (a0);       addi a0, a0, 4*4
    vle32.v v1, (a0);       addi a0, a0, 4*4
    vle32.v v2, (a0);       addi a0, a0, 4*4
    vle32.v v3, (a0);       addi a0, a0, 4*4
    vle32.v v4, (a0);       addi a0, a0, 4*4
    vle32.v v5, (a0);       addi a0, a0, 4*4
    vle32.v v6, (a0);       addi a0, a0, 4*4
    vle32.v v7, (a0);       addi a0, a0, -4*4*7
    vmul.vx v0, v0, a0
    vmul.vx v1, v1, a0
    vmul.vx v2, v2, a0
    vmul.vx v3, v3, a0
    vmul.vx v4, v4, a0
    vmul.vx v5, v5, a0
    vmul.vx v6, v6, a0
    vmul.vx v7, v7, a0
    vse32.v v0, (a0);       addi a0, a0, 4*4
    vse32.v v1, (a0);       addi a0, a0, 4*4
    vse32.v v2, (a0);       addi a0, a0, 4*4
    vse32.v v3, (a0);       addi a0, a0, 4*4
    vse32.v v4, (a0);       addi a0, a0, 4*4
    vse32.v v5, (a0);       addi a0, a0, 4*4
    vse32.v v6, (a0);       addi a0, a0, 4*4
    vse32.v v7, (a0);       addi a0, a0, -4*4*7
.endr
ret

.globl cpi_m1_vle32_vmul_vse32_opt
.align 2
cpi_m1_vle32_vmul_vse32_opt:
.rep 100
    vle32.v v0, (a0);       addi a0, a0, 4*4
    vle32.v v1, (a0);       addi a0, a0, 4*4
    vle32.v v2, (a0);       addi a0, a0, 4*4
    vle32.v v3, (a0);       addi a0, a0, -4*4*3
    vmul.vx v0, v0, a0
    vmul.vx v1, v1, a0
    vmul.vx v2, v2, a0
    vmul.vx v3, v3, a0
    vse32.v v0, (a0);       addi a0, a0, 4*4
    vse32.v v1, (a0);       addi a0, a0, 4*4
    vse32.v v2, (a0);       addi a0, a0, 4*4
    vse32.v v3, (a0);       addi a0, a0, 4*4
    vle32.v v4, (a0);       addi a0, a0, 4*4
    vle32.v v5, (a0);       addi a0, a0, 4*4
    vle32.v v6, (a0);       addi a0, a0, 4*4
    vle32.v v7, (a0);       addi a0, a0, -4*4*3
    vmul.vx v4, v4, a0
    vmul.vx v5, v5, a0
    vmul.vx v6, v6, a0
    vmul.vx v7, v7, a0
    vse32.v v4, (a0);       addi a0, a0, 4*4
    vse32.v v5, (a0);       addi a0, a0, 4*4
    vse32.v v6, (a0);       addi a0, a0, 4*4
    vse32.v v7, (a0);       addi a0, a0, -4*4*7
.endr
ret

.globl cpi_m1_vle32_vmul_vse32_opt_v2
.align 2
cpi_m1_vle32_vmul_vse32_opt_v2:
.rep 100
    vle32.v v0, (a0);       addi a0, a0, 4*4
    vle32.v v1, (a0);       addi a0, a0, -4*4
    vmul.vx v0, v0, a0
    vmul.vx v1, v1, a0
    vse32.v v0, (a0);       addi a0, a0, 4*4
    vse32.v v1, (a0);       addi a0, a0, 4*4
    vle32.v v2, (a0);       addi a0, a0, 4*4
    vle32.v v3, (a0);       addi a0, a0, -4*4
    vmul.vx v2, v2, a0
    vmul.vx v3, v3, a0
    vse32.v v2, (a0);       addi a0, a0, 4*4
    vse32.v v3, (a0);       addi a0, a0, 4*4
    vle32.v v4, (a0);       addi a0, a0, 4*4
    vle32.v v5, (a0);       addi a0, a0, -4*4
    vmul.vx v4, v4, a0
    vmul.vx v5, v5, a0
    vse32.v v4, (a0);       addi a0, a0, 4*4
    vse32.v v5, (a0);       addi a0, a0, 4*4
    vle32.v v6, (a0);       addi a0, a0, 4*4
    vle32.v v7, (a0);       addi a0, a0, -4*4
    vmul.vx v6, v6, a0
    vmul.vx v7, v7, a0
    vse32.v v6, (a0);       addi a0, a0, 4*4
    vse32.v v7, (a0);       addi a0, a0, -4*4*7
.endr
ret

.globl cpi_m8_vle32_vmul_vse32
.align 2
cpi_m8_vle32_vmul_vse32:
.rep 200
    vle32.v v0, (a0)
    vmul.vx v0, v0, a0
    vse32.v v0, (a0)
.endr
ret