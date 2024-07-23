.text

.globl cpi_add
.align 2
cpi_add:
.rep 200
    add a0, a0, a0
    add a1, a1, a1
    add a2, a2, a2
    add a3, a3, a3
    add a4, a4, a4
    add a5, a5, a5
    add a6, a6, a6
    add a7, a7, a7
.endr
ret

.globl cpi_addi
.align 2
cpi_addi:
.rep 200
    addi a0, a0, 1
    addi a1, a1, 1
    addi a2, a2, 1
    addi a3, a3, 1
    addi a4, a4, 1
    addi a5, a5, 1
    addi a6, a6, 1
    addi a7, a7, 1
.endr
ret

.globl cpi_addi_x1
.align 2
cpi_addi_x1:
.rep 1600
    addi a0, a0, 1
.endr
ret

.globl cpi_xor
.align 2
cpi_xor:
.rep 200
    xor a0, a0, a0
    xor a1, a1, a1
    xor a2, a2, a2
    xor a3, a3, a3
    xor a4, a4, a4
    xor a5, a5, a5
    xor a6, a6, a6
    xor a7, a7, a7
.endr
ret

.globl cpi_xori
.align 2
cpi_xori:
.rep 200
    xori a0, a0, 1
    xori a1, a1, 1
    xori a2, a2, 1
    xori a3, a3, 1
    xori a4, a4, 1
    xori a5, a5, 1
    xori a6, a6, 1
    xori a7, a7, 1
.endr
ret

.globl cpi_mul
.align 2
cpi_mul:
.rep 200
    mul a0, a0, a0
    mul a1, a1, a1
    mul a2, a2, a2
    mul a3, a3, a3
    mul a4, a4, a4
    mul a5, a5, a5
    mul a6, a6, a6
    mul a7, a7, a7
.endr
ret

.globl cpi_mul_x1
.align 2
cpi_mul_x1:
.rep 1600
    mul a0, a0, a0
.endr
ret

.globl cpi_mulh
.align 2
cpi_mulh:
.rep 200
    mulh a0, a0, a0
    mulh a1, a1, a1
    mulh a2, a2, a2
    mulh a3, a3, a3
    mulh a4, a4, a4
    mulh a5, a5, a5
    mulh a6, a6, a6
    mulh a7, a7, a7
.endr
ret

#ifdef RV64
.globl cpi_mulw
.align 2
cpi_mulw:
.rep 200
    mulw a0, a0, a0
    mulw a1, a1, a1
    mulw a2, a2, a2
    mulw a3, a3, a3
    mulw a4, a4, a4
    mulw a5, a5, a5
    mulw a6, a6, a6
    mulw a7, a7, a7
.endr
ret

.globl cpi_mulw_x1
.align 2
cpi_mulw_x1:
.rep 1600
    mulw a0, a0, a0
.endr
ret
#endif

.globl cpi_lh
.align 2
cpi_lh:
.rep 200
    lh a1, 2*0(a0)
    lh a2, 2*1(a0)
    lh a3, 2*2(a0)
    lh a4, 2*3(a0)
    lh a5, 2*4(a0)
    lh a6, 2*5(a0)
    lh a7, 2*6(a0)
    lh t0, 2*7(a0)
.endr
ret

.globl cpi_lh_addi
.align 2
cpi_lh_addi:
.rep 200
    lh a1, 2*0(a0)
    lh a2, 2*1(a0)
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
.endr
ret

.globl cpi_lw
.align 2
cpi_lw:
.rep 200
    lw a1, 8*0(a0)
    lw a2, 8*1(a0)
    lw a3, 8*2(a0)
    lw a4, 8*3(a0)
    lw a5, 8*4(a0)
    lw a6, 8*5(a0)
    lw a7, 8*6(a0)
    lw t0, 8*7(a0)
.endr
ret

.globl cpi_lw_addi
.align 2
cpi_lw_addi:
.rep 200
    lw a1, 8*0(a0)
    lw a2, 8*1(a0)
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
.endr
ret

#ifdef RV64
.globl cpi_ld
.align 2
cpi_ld:
.rep 200
    ld a1, 8*0(a0)
    ld a2, 8*1(a0)
    ld a3, 8*2(a0)
    ld a4, 8*3(a0)
    ld a5, 8*4(a0)
    ld a6, 8*5(a0)
    ld a7, 8*6(a0)
    ld t0, 8*7(a0)
.endr
ret

.globl cpi_ld_addi
.align 2
cpi_ld_addi:
.rep 200
    ld a1, 8*0(a0)
    ld a2, 8*1(a0)
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
    addi a1, a1, 1
    addi a2, a2, 1
.endr
ret
#endif

.globl cpi_sh
.align 2
cpi_sh:
.rep 200
    sh a1, 8*0(a0)
    sh a2, 8*1(a0)
    sh a3, 8*2(a0)
    sh a4, 8*3(a0)
    sh a5, 8*4(a0)
    sh a6, 8*5(a0)
    sh a7, 8*6(a0)
    sh t0, 8*7(a0)
.endr
ret

.globl cpi_sw
.align 2
cpi_sw:
.rep 200
    sw a1, 8*0(a0)
    sw a2, 8*1(a0)
    sw a3, 8*2(a0)
    sw a4, 8*3(a0)
    sw a5, 8*4(a0)
    sw a6, 8*5(a0)
    sw a7, 8*6(a0)
    sw t0, 8*7(a0)
.endr
ret

.globl cpi_addi_sw_v2
.align 2
cpi_addi_sw_v2:
.rep 200
    addi a1, a1, 1
    addi a2, a2, 1
    addi a3, a3, 1
    addi a4, a4, 1
    sw a1, 8*0(a0)
    sw a2, 8*1(a0)
    sw a3, 8*2(a0)
    sw a4, 8*3(a0)
.endr
ret

#ifdef RV64
.globl cpi_sd
.align 2
cpi_sd:
.rep 200
    sd a1, 8*0(a0)
    sd a2, 8*1(a0)
    sd a3, 8*2(a0)
    sd a4, 8*3(a0)
    sd a5, 8*4(a0)
    sd a6, 8*5(a0)
    sd a7, 8*6(a0)
    sd t0, 8*7(a0)
.endr
ret
#endif

.text

.globl cpi_rori
.align 2
cpi_rori:
.rep 200
    rori a0, a0, 16
    rori a1, a1, 16
    rori a2, a2, 16
    rori a3, a3, 16
    rori a4, a4, 16
    rori a5, a5, 16
    rori a6, a6, 16
    rori a7, a7, 16
.endr
ret

.globl cpi_rori_x1
.align 2
cpi_rori_x1:
.rep 200
    rori a0, a0, 16
    rori a0, a0, 16
    rori a0, a0, 16
    rori a0, a0, 16
    rori a0, a0, 16
    rori a0, a0, 16
    rori a0, a0, 16
    rori a0, a0, 16
.endr
ret

.globl cpi_andn
.align 2
cpi_andn:
.rep 200
    andn a0, a0, t6
    andn a1, a1, t6
    andn a2, a2, t6
    andn a3, a3, t6
    andn a4, a4, t6
    andn a5, a5, t6
    andn a6, a6, t6
    andn a7, a7, t6
.endr
ret

.globl cpi_andn_x1
.align 2
cpi_andn_x1:
.rep 200
    andn a0, a0, t6
    andn a0, a0, t6
    andn a0, a0, t6
    andn a0, a0, t6
    andn a0, a0, t6
    andn a0, a0, t6
    andn a0, a0, t6
    andn a0, a0, t6
.endr
ret
