.text

.globl cpi_add
.align 2
cpi_add:
.rep 100
    add a0, a0, a0
    add a1, a1, a1
    add a2, a2, a2
    add a3, a3, a3
    add a4, a4, a4
    add a5, a5, a5
    add a6, a6, a6
    add a7, a7, a7
    add t0, t0, t0
    add t1, t1, t1
    add t2, t2, t2
    add t3, t3, t3
    add t4, t4, t4
    add t5, t5, t5
    add t6, t6, t6
.endr
ret

.globl cpi_addi
.align 2
cpi_addi:
.rep 100
    add a0, a0, 1
    add a1, a1, 1
    add a2, a2, 1
    add a3, a3, 1
    add a4, a4, 1
    add a5, a5, 1
    add a6, a6, 1
    add a7, a7, 1
    add t0, t0, 1
    add t1, t1, 1
    add t2, t2, 1
    add t3, t3, 1
    add t4, t4, 1
    add t5, t5, 1
    add t6, t6, 1
.endr
ret

.globl cpi_xor
.align 2
cpi_xor:
.rep 100
    xor a0, a0, a0
    xor a1, a1, a1
    xor a2, a2, a2
    xor a3, a3, a3
    xor a4, a4, a4
    xor a5, a5, a5
    xor a6, a6, a6
    xor a7, a7, a7
    xor t0, t0, t0
    xor t1, t1, t1
    xor t2, t2, t2
    xor t3, t3, t3
    xor t4, t4, t4
    xor t5, t5, t5
    xor t6, t6, t6
.endr
ret

.globl cpi_xori
.align 2
cpi_xori:
.rep 100
    xori a0, a0, 1
    xori a1, a1, 1
    xori a2, a2, 1
    xori a3, a3, 1
    xori a4, a4, 1
    xori a5, a5, 1
    xori a6, a6, 1
    xori a7, a7, 1
    xori t0, t0, 1
    xori t1, t1, 1
    xori t2, t2, 1
    xori t3, t3, 1
    xori t4, t4, 1
    xori t5, t5, 1
    xori t6, t6, 1
.endr
ret

.globl cpi_addi_forward
.align 2
cpi_addi_forward:
.rep 100
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
    add a0, a0, 1
.endr
ret

.globl cpi_addxor
.align 2
cpi_addxor:
.rep 100
    addi a0, a0, 1
    xori a1, a1, 1
    addi a2, a2, 1
    xori a3, a3, 1
    addi a4, a4, 1
    xori a5, a5, 1
    addi a6, a6, 1
    xori a7, a7, 1
    addi t0, t0, 1
    xori t1, t1, 1
    addi t2, t2, 1
    xori t3, t3, 1
    addi t4, t4, 1
    xori t5, t5, 1
.endr
ret

.globl cpi_addxor_forward
.align 2
cpi_addxor_forward:
.rep 100
    addi a0, a0, 1
    xori a0, a0, 1
    addi a2, a2, 1
    xori a2, a2, 1
    addi a4, a4, 1
    xori a4, a4, 1
    addi a6, a6, 1
    xori a6, a6, 1
    addi t0, t0, 1
    xori t0, t0, 1
    addi t2, t2, 1
    xori t2, t2, 1
    addi t4, t4, 1
    xori t4, t4, 1
.endr
ret

.globl cpi_mul_mulh
.align 2
cpi_mul_mulh:
.rep 100
    mul  a0, a0, a0
    mulh a1, a1, a1
    mul  a2, a2, a2
    mulh a3, a3, a3
    mul  a4, a4, a4
    mulh a5, a5, a5
    mul  a6, a6, a6
    mulh a7, a7, a7
    mul  t0, t0, t0
    mulh t1, t1, t1
    mul  t2, t2, t2
    mulh t3, t3, t3
    mul  t4, t4, t4
    mulh t5, t5, t5
.endr
ret

.globl cpi_mul
.align 2
cpi_mul:
.rep 100
    mul a0, a0, a0
    mul a1, a1, a1
    mul a2, a2, a2
    mul a3, a3, a3
    mul a4, a4, a4
    mul a5, a5, a5
    mul a6, a6, a6
    mul a7, a7, a7
    mul t0, t0, t0
    mul t1, t1, t1
    mul t2, t2, t2
    mul t3, t3, t3
    mul t4, t4, t4
    mul t5, t5, t5
    mul t6, t6, t6
.endr
ret

.globl cpi_mul_x1
.align 2
cpi_mul_x1:
.rep 100
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
    mul a0, a0, a0
.endr
ret

.globl cpi_mul_x2
.align 2
cpi_mul_x2:
.rep 100
    mul a0, a0, a0
    mul a1, a1, a1
    mul a0, a0, a0
    mul a1, a1, a1
    mul a0, a0, a0
    mul a1, a1, a1
    mul a0, a0, a0
    mul a1, a1, a1
    mul a0, a0, a0
    mul a1, a1, a1
    mul a0, a0, a0
    mul a1, a1, a1
    mul a0, a0, a0
    mul a1, a1, a1
.endr
ret

.globl cpi_mul_x4
.align 2
cpi_mul_x4:
.rep 100
    mul a0, a0, a0
    mul a1, a1, a1
    mul a2, a2, a2
    mul a3, a3, a3
    mul a0, a0, a0
    mul a1, a1, a1
    mul a2, a2, a2
    mul a3, a3, a3
    mul a0, a0, a0
    mul a1, a1, a1
    mul a2, a2, a2
    mul a3, a3, a3
    mul a0, a0, a0
    mul a1, a1, a1
    mul a2, a2, a2
    mul a3, a3, a3
.endr
ret

.globl cpi_mulh
.align 2
cpi_mulh:
.rep 100
    mulh a0, a0, a0
    mulh a1, a1, a1
    mulh a2, a2, a2
    mulh a3, a3, a3
    mulh a4, a4, a4
    mulh a5, a5, a5
    mulh a6, a6, a6
    mulh a7, a7, a7
    mulh t0, t0, t0
    mulh t1, t1, t1
    mulh t2, t2, t2
    mulh t3, t3, t3
    mulh t4, t4, t4
    mulh t5, t5, t5
    mulh t6, t6, t6
.endr
ret

#ifdef RV64
.globl cpi_mulw
.align 2
cpi_mulw:
.rep 100
    mulw a0, a0, a0
    mulw a1, a1, a1
    mulw a2, a2, a2
    mulw a3, a3, a3
    mulw a4, a4, a4
    mulw a5, a5, a5
    mulw a6, a6, a6
    mulw a7, a7, a7
    mulw t0, t0, t0
    mulw t1, t1, t1
    mulw t2, t2, t2
    mulw t3, t3, t3
    mulw t4, t4, t4
    mulw t5, t5, t5
    mulw t6, t6, t6
.endr
ret

.globl cpi_mulw_x1
.align 2
cpi_mulw_x1:
.rep 200
    mulw a0, a0, a0
    mulw a0, a0, a0
    mulw a0, a0, a0
    mulw a0, a0, a0
    mulw a0, a0, a0
    mulw a0, a0, a0
    mulw a0, a0, a0
    mulw a0, a0, a0
    mulw a0, a0, a0
    mulw a0, a0, a0
.endr
ret

.globl cpi_mulw_x2
.align 2
cpi_mulw_x2:
.rep 200
    mulw a0, a0, a0
    mulw a1, a1, a1
    mulw a0, a0, a0
    mulw a1, a1, a1
    mulw a0, a0, a0
    mulw a1, a1, a1
    mulw a0, a0, a0
    mulw a1, a1, a1
    mulw a0, a0, a0
    mulw a1, a1, a1
    mulw a0, a0, a0
    mulw a1, a1, a1
.endr
ret

.globl cpi_mulw_x4
.align 2
cpi_mulw_x4:
.rep 200
    mulw a0, a0, a0
    mulw a1, a1, a1
    mulw a2, a2, a2
    mulw a3, a3, a3
    mulw a0, a0, a0
    mulw a1, a1, a1
    mulw a2, a2, a2
    mulw a3, a3, a3
    mulw a0, a0, a0
    mulw a1, a1, a1
    mulw a2, a2, a2
    mulw a3, a3, a3
.endr
ret
#endif

.globl cpi_muladd
.align 2
cpi_muladd:
.rep 100
    mul  a0, a0, a0
    addi a1, a1, 1
    mul  a2, a2, a2
    addi a3, a3, 1
    mul  a4, a4, a4
    addi a5, a5, 1
    mul  a6, a6, a6
    addi a7, a7, 1
    mul  t0, t0, t0
    addi t1, t1, 1
    mul  t2, t2, t2
    addi t3, t3, 1
    mul  t4, t4, t4
    addi t5, t5, 1
.endr
ret

.globl cpi_mulx1addx2
.align 2
cpi_mulx1addx2:
.rep 100
    mul  a0, a0, a0
    addi a1, a1, 1
    addi a2, a2, 1
    mul  a3, a3, a3
    addi a4, a4, 1
    addi a5, a5, 1
    mul  a6, a6, a6
    addi a7, a7, 1
    addi t0, t0, 1
    mul  t1, t1, t1
    addi t2, t2, 1
    addi t3, t3, 1
    mul  t4, t4, t4
    addi t5, t5, 1
    addi t6, t6, 1
.endr
ret

.globl cpi_mulx2addx4
.align 2
cpi_mulx2addx4:
.rep 150
    mul  a0, a0, a0
    mul  a3, a3, a3
    addi a1, a1, 1
    addi a2, a2, 1
    addi a4, a4, 1
    addi a5, a5, 1
    mul  a6, a6, a6
    mul  t1, t1, t1
    addi a7, a7, 1
    addi t0, t0, 1
    addi t2, t2, 1
    addi t3, t3, 1
.endr
ret

.globl cpi_mulx1addx3
.align 2
cpi_mulx1addx3:
.rep 100
    mul  a0, a0, a0
    addi a1, a1, 1
    addi a2, a2, 1
    addi a3, a3, 1
    mul  a4, a4, a4
    addi a5, a5, 1
    addi a6, a6, 1
    addi a7, a7, 1
    mul  t0, t0, t0
    addi t1, t1, 1
    addi t2, t2, 1
    addi t3, t3, 1
.endr
ret

.globl cpi_mulx1addx4
.align 2
cpi_mulx1addx4:
.rep 100
    mul  a0, a0, a0
    addi a1, a1, 1
    addi a2, a2, 1
    addi a3, a3, 1
    addi a4, a4, 1
    mul  a5, a5, a5
    addi a6, a6, 1
    addi a7, a7, 1
    addi t0, t0, 1
    addi t1, t1, 1
    mul  t2, t2, t2
    addi t3, t3, 1
    addi t4, t4, 1
    addi t5, t5, 1
    addi t6, t6, 1
.endr
ret

.globl cpi_shiftxor
.align 2
cpi_shiftxor:
.rep 100
    slli a0, a0, 10
    srli a1, a1, 10
    xori a2, a2, 10
    slli a3, a3, 10
    srli a4, a4, 10
    xori a5, a5, 10
    slli a6, a6, 10
    srli a7, a7, 10
    xori t0, t0, 10
    slli t1, t1, 10
    srli t2, t2, 10
    xori t3, t3, 10
.endr
ret

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
    lh t1, 2*8(a0)
    lh t2, 2*9(a0)
.endr
ret

.globl cpi_lh_addi
.align 2
cpi_lh_addi:
.rep 100
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
    lw t1, 8*8(a0)
    lw t2, 8*9(a0)
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
    ld t1, 8*8(a0)
    ld t2, 8*9(a0)
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
    sh t1, 8*8(a0)
    sh t2, 8*9(a0)
    sh a1, 8*10(a0)
    sh a2, 8*11(a0)
    sh a3, 8*12(a0)
    sh a4, 8*13(a0)
    sh a5, 8*14(a0)
    sh a6, 8*15(a0)
    sh a7, 8*16(a0)
    sh t0, 8*17(a0)
    sh t1, 8*18(a0)
    sh t2, 8*19(a0)
.endr
ret

.globl cpi_sh_lh_addi
.align 2
cpi_sh_lh_addi:
.rep 200
    sh a1, 8*0(a0)
    lh a2, 8*0(a0)
    addi a2, a2, 1
    addi a2, a2, 1
    addi a2, a2, 1
    addi a2, a2, 1
    sh a3, 8*1(a0)
    lh a4, 8*1(a0)
    addi a4, a4, 1
    addi a4, a4, 1
    addi a4, a4, 1
    addi a4, a4, 1
.endr
ret

.globl cpi_sw
.align 2
cpi_sw:
.rep 100
    sw a1, 8*0(a0)
    sw a2, 8*1(a0)
    sw a3, 8*2(a0)
    sw a4, 8*3(a0)
    sw a5, 8*4(a0)
    sw a6, 8*5(a0)
    sw a7, 8*6(a0)
    sw t0, 8*7(a0)
    sw t1, 8*8(a0)
    sw t2, 8*9(a0)
    sw a1, 8*10(a0)
    sw a2, 8*11(a0)
    sw a3, 8*12(a0)
    sw a4, 8*13(a0)
    sw a5, 8*14(a0)
    sw a6, 8*15(a0)
    sw a7, 8*16(a0)
    sw t0, 8*17(a0)
    sw t1, 8*18(a0)
    sw t2, 8*19(a0)
.endr
ret

.globl cpi_addi_sw_v0
.align 2
cpi_addi_sw_v0:
.rep 100
    addi a1, a1, 1
    sw a1, 8*0(a0)
    addi a2, a2, 1
    sw a2, 8*1(a0)
    addi a3, a3, 1
    sw a3, 8*2(a0)
    addi a4, a4, 1
    sw a4, 8*3(a0)
.endr
ret

.globl cpi_addi_sw_v1
.align 2
cpi_addi_sw_v1:
.rep 100
    addi a1, a1, 1
    addi a2, a2, 1
    sw a1, 8*0(a0)
    sw a2, 8*1(a0)
    addi a3, a3, 1
    addi a4, a4, 1
    sw a3, 8*2(a0)
    sw a4, 8*3(a0)
.endr
ret

.globl cpi_addi_sw_v2
.align 2
cpi_addi_sw_v2:
.rep 100
    addi a1, a1, 1
    addi a2, a2, 1
    addi a3, a3, 1
    addi a4, a4, 1
    sw a1, 8*0(a0)
    sw a2, 8*1(a0)
    sw a1, 8*2(a0)
    sw a2, 8*3(a0)
.endr
ret

.globl cpi_sw_lw_addi
.align 2
cpi_sw_lw_addi:
.rep 200
    sw a1, 8*0(a0)
    lw a2, 8*0(a0)
    addi a2, a2, 1
    addi a2, a2, 1
    addi a2, a2, 1
    addi a2, a2, 1
    sw a3, 8*1(a0)
    lw a4, 8*1(a0)
    addi a4, a4, 1
    addi a4, a4, 1
    addi a4, a4, 1
    addi a4, a4, 1
.endr
ret

#ifdef RV64
.globl cpi_sd
.align 2
cpi_sd:
.rep 100
    sd a1, 8*0(a0)
    sd a2, 8*1(a0)
    sd a3, 8*2(a0)
    sd a4, 8*3(a0)
    sd a5, 8*4(a0)
    sd a6, 8*5(a0)
    sd a7, 8*6(a0)
    sd t0, 8*7(a0)
    sd t1, 8*8(a0)
    sd t2, 8*9(a0)
    sd a1, 8*10(a0)
    sd a2, 8*11(a0)
    sd a3, 8*12(a0)
    sd a4, 8*13(a0)
    sd a5, 8*14(a0)
    sd a6, 8*15(a0)
    sd a7, 8*16(a0)
    sd t0, 8*17(a0)
    sd t1, 8*18(a0)
    sd t2, 8*19(a0)
.endr
ret

.globl cpi_sd_ld_addi
.align 2
cpi_sd_ld_addi:
.rep 200
    sd a1, 8*0(a0)
    ld a2, 8*0(a0)
    addi a2, a2, 1
    addi a2, a2, 1
    addi a2, a2, 1
    addi a2, a2, 1
    sd a3, 8*1(a0)
    ld a4, 8*1(a0)
    addi a4, a4, 1
    addi a4, a4, 1
    addi a4, a4, 1
    addi a4, a4, 1
.endr
ret
#endif

.macro plant_ct_bfu_x1 a_0, a_1, zeta, q16, tmp
    mul \tmp, \a_1, \zeta
    srai \tmp, \tmp, 16
    addi \tmp, \tmp, 8
    mulh \tmp, \tmp, \q16
    sub \a_1, \a_0, \tmp
    add \a_0, \a_0, \tmp
.endm

.macro fake_plant_ct_bfu_x1
    mul  a0, a0, a0
    srai a2, a2, 16
    addi a4, a4, 1
    mulh a6, a6, a6
    sub  t0, t1, t2
    add  t3, t1, t2
.endm

.macro plant_ct_bfu_x2 \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    zeta_0, zeta_1, \
    q16, \
    t_0, t_1
    mul  \t_0, \a_0_1, \zeta_0
    mul  \t_1, \a_1_1, \zeta_1
    srai \t_0, \t_0, 16
    srai \t_1, \t_1, 16
    addi \t_0, \t_0, 8
    addi \t_1, \t_1, 8
    mulh \t_0, \t_0, \q16
    mulh \t_1, \t_1, \q16
    sub  \a_0_1, \a_0_0, \t_0
    sub  \a_1_1, \a_1_0, \t_1
    add  \a_0_0, \a_0_0, \t_0
    add  \a_1_0, \a_1_0, \t_1
.endm

.macro fake_plant_ct_bfu_x2
    mul  a0, a0, a0
    srai a2, a2, 16
    srai a3, a3, 16
    mul  a1, a1, a1
    addi a4, a4, 1
    addi a5, a5, 1
    mulh a6, a6, a6
    sub  t0, t0, t1
    sub  t2, t2, t3
    mulh a7, a7, a7
    add  t4, t4, t5
    add  t6, t6, a5
.endm

.macro plant_ct_bfu_x4 \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    a_2_0, a_2_1, a_3_0, a_3_1, \
    zeta_0, zeta_1, zeta_2, zeta_3, \
    q16, \
    t_0, t_1, t_2, t_3
    mul  \t_0, \a_0_1, \zeta_0
    mul  \t_1, \a_1_1, \zeta_1
    mul  \t_2, \a_2_1, \zeta_2
    mul  \t_3, \a_3_1, \zeta_3
    srai \t_0, \t_0, 16
    addi \t_0, \t_0, 8
    srai \t_1, \t_1, 16
    addi \t_1, \t_1, 8
    mulh \t_0, \t_0, \q16
    mulh \t_1, \t_1, \q16
    srai \t_2, \t_2, 16
    addi \t_2, \t_2, 8
    srai \t_3, \t_3, 16
    addi \t_3, \t_3, 8
    mulh \t_2, \t_2, \q16
    mulh \t_3, \t_3, \q16
    sub  \a_0_1, \a_0_0, \t_0
    sub  \a_1_1, \a_1_0, \t_1
    sub  \a_2_1, \a_2_0, \t_2
    sub  \a_3_1, \a_3_0, \t_3
    add  \a_0_0, \a_0_0, \t_0
    add  \a_1_0, \a_1_0, \t_1
    add  \a_2_0, \a_2_0, \t_2
    add  \a_3_0, \a_3_0, \t_3
.endm

.macro plant_ct_bfu_x8 \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    a_2_0, a_2_1, a_3_0, a_3_1, \
    a_4_0, a_4_1, a_5_0, a_5_1, \
    a_6_0, a_6_1, a_7_0, a_7_1, \
    zeta_0, zeta_1, \
    zeta_2, zeta_3, \
    zeta_4, zeta_5, \
    zeta_6, zeta_7, \
    q16, \
    t_0, t_1, t_2, t_3
  mul  \t_0, \a_0_1, \zeta_0
  mul  \t_1, \a_1_1, \zeta_1
  mul  \t_2, \a_2_1, \zeta_2
  mul  \t_3, \a_3_1, \zeta_3
  srai \t_0, \t_0, 16
  srai \t_1, \t_1, 16
  addi \t_0, \t_0, 8
  addi \t_1, \t_1, 8
  mulh \t_0, \t_0, \q16
  srai \t_2, \t_2, 16
  srai \t_3, \t_3, 16
  mulh \t_1, \t_1, \q16
  addi \t_2, \t_2, 8
  addi \t_3, \t_3, 8
  mulh \t_2, \t_2, \q16
  sub  \a_0_1, \a_0_0, \t_0
  sub  \a_1_1, \a_1_0, \t_1
  mulh \t_3, \t_3, \q16
  add  \a_0_0, \a_0_0, \t_0
  add  \a_1_0, \a_1_0, \t_1
  mul  \t_0, \a_4_1, \zeta_4
  sub  \a_2_1, \a_2_0, \t_2
  sub  \a_3_1, \a_3_0, \t_3
  mul  \t_1, \a_5_1, \zeta_5
  add  \a_2_0, \a_2_0, \t_2
  add  \a_3_0, \a_3_0, \t_3
  mul  \t_2, \a_6_1, \zeta_6
  srai \t_0, \t_0, 16
  srai \t_1, \t_1, 16
  mul  \t_3, \a_7_1, \zeta_7
  addi \t_0, \t_0, 8
  addi \t_1, \t_1, 8
  mulh \t_0, \t_0, \q16
  srai \t_2, \t_2, 16
  srai \t_3, \t_3, 16
  mulh \t_1, \t_1, \q16
  addi \t_2, \t_2, 8
  addi \t_3, \t_3, 8
  add  \a_4_0, \a_4_0, \t_0
  mulh \t_2, \t_2, \q16
  sub  \a_4_1, \a_4_0, \t_0
  sub  \a_5_1, \a_5_0, \t_1
  add  \a_5_0, \a_5_0, \t_1
  mulh \t_3, \t_3, \q16
  sub  \a_6_1, \a_6_0, \t_2
  sub  \a_7_1, \a_7_0, \t_3
  add  \a_6_0, \a_6_0, \t_2
  add  \a_7_0, \a_7_0, \t_3
.endm

.globl cpi_plant_ct_bfu_x1
.align 2
cpi_plant_ct_bfu_x1:
.rep 200
    plant_ct_bfu_x1 a0, a1, a2, a3, t0
    plant_ct_bfu_x1 a4, a5, a6, t1, t2
.endr
ret

.globl cpi_fake_plant_ct_bfu_x1
.align 2
cpi_fake_plant_ct_bfu_x1:
.rep 400
    fake_plant_ct_bfu_x1
.endr
ret

.globl cpi_plant_ct_bfu_x2
.align 2
cpi_plant_ct_bfu_x2:
.rep 200
    plant_ct_bfu_x2 a0, a0, a1, a1, a2, a2, a3, a4, a5
    plant_ct_bfu_x2 t0, t0, t1, t1, t2, t2, t3, t4, t5
.endr
ret

.globl cpi_fake_plant_ct_bfu_x2
.align 2
cpi_fake_plant_ct_bfu_x2:
.rep 400
    fake_plant_ct_bfu_x2
.endr
ret

.globl cpi_plant_ct_bfu_x4
.align 2
cpi_plant_ct_bfu_x4:
.rep 200
    plant_ct_bfu_x4 \
        a0, a1, a2, a3, a4, a5, a6, a7, \
        t0, t0, t0, t0, t1, \
        t2, t3, t4, t5
.endr
ret

.globl cpi_plant_ct_bfu_x8
.align 2
cpi_plant_ct_bfu_x8:
.rep 100
    plant_ct_bfu_x8 \
        a0, a1, a2, a3, \
        a4, a5, a6, a7, \
        a0, a1, a2, a3, \
        a4, a5, a6, a7, \
        t0, t0, t0, t0, \
        t0, t0, t0, t0, \
        t1, \
        t2, t3, t4, t5
.endr
ret

.macro plant_gs_bfu a_0, a_1, zeta, q16, tmp
  sub \tmp, \a_0, \a_1
  add \a_0, \a_0, \a_1
  mul \a_1, \tmp, \zeta
  srai \a_1, \a_1, 16
  addi \a_1, \a_1, 8
  mulh \a_1, \a_1, \q16
.endm

.macro plant_gs_bfu_x2 a_0_0, a_0_1, a_1_0, a_1_1, \
    zeta_0, zeta_1, q16, t_0, t_1
  sub \t_0, \a_0_0, \a_0_1
  sub \t_1, \a_1_0, \a_1_1
  add \a_0_0, \a_0_0, \a_0_1
  add \a_1_0, \a_1_0, \a_1_1
  mul \a_0_1, \t_0, \zeta_0
  mul \a_1_1, \t_1, \zeta_1
  srai \a_0_1, \a_0_1, 16
  srai \a_1_1, \a_1_1, 16
  addi \a_0_1, \a_0_1, 8
  addi \a_1_1, \a_1_1, 8
  mulh \a_0_1, \a_0_1, \q16
  mulh \a_1_1, \a_1_1, \q16
.endm

.macro plant_gs_bfu_x4 \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    a_2_0, a_2_1, a_3_0, a_3_1, \
    zeta_0, zeta_1, zeta_2, zeta_3, \
    q16, t_0, t_1, t_2, t_3
  sub \t_0, \a_0_0, \a_0_1
  sub \t_1, \a_1_0, \a_1_1
  add \a_0_0, \a_0_0, \a_0_1
  add \a_1_0, \a_1_0, \a_1_1
  mul \a_0_1, \t_0, \zeta_0
  mul \a_1_1, \t_1, \zeta_1
  sub \t_2, \a_2_0, \a_2_1
  sub \t_3, \a_3_0, \a_3_1
  add \a_2_0, \a_2_0, \a_2_1
  add \a_3_0, \a_3_0, \a_3_1
  mul \a_2_1, \t_2, \zeta_2
  mul \a_3_1, \t_3, \zeta_3
  srai \a_0_1, \a_0_1, 16
  srai \a_1_1, \a_1_1, 16
  addi \a_0_1, \a_0_1, 8
  addi \a_1_1, \a_1_1, 8
  mulh \a_0_1, \a_0_1, \q16
  mulh \a_1_1, \a_1_1, \q16
  srai \a_2_1, \a_2_1, 16
  srai \a_3_1, \a_3_1, 16
  addi \a_2_1, \a_2_1, 8
  addi \a_3_1, \a_3_1, 8
  mulh \a_2_1, \a_2_1, \q16
  mulh \a_3_1, \a_3_1, \q16
.endm

.macro plant_gs_bfu_x8 \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    a_2_0, a_2_1, a_3_0, a_3_1, \
    a_4_0, a_4_1, a_5_0, a_5_1, \
    a_6_0, a_6_1, a_7_0, a_7_1, \
    zeta_0, zeta_1, \
    zeta_2, zeta_3, \
    zeta_4, zeta_5, \
    zeta_6, zeta_7, \
    q16, t_0, t_1, t_2, t_3
  sub \t_0, \a_0_0, \a_0_1
  sub \t_1, \a_1_0, \a_1_1
  add \a_0_0, \a_0_0, \a_0_1
  add \a_1_0, \a_1_0, \a_1_1
  mul \a_0_1, \t_0, \zeta_0
  mul \a_1_1, \t_1, \zeta_1
  sub \t_2, \a_2_0, \a_2_1
  sub \t_3, \a_3_0, \a_3_1
  add \a_2_0, \a_2_0, \a_2_1
  add \a_3_0, \a_3_0, \a_3_1
  mul \a_2_1, \t_2, \zeta_2
  mul \a_3_1, \t_3, \zeta_3
  srai \a_0_1, \a_0_1, 16
  srai \a_1_1, \a_1_1, 16
  addi \a_0_1, \a_0_1, 8
  addi \a_1_1, \a_1_1, 8
  mulh \a_0_1, \a_0_1, \q16
  mulh \a_1_1, \a_1_1, \q16
  srai \a_2_1, \a_2_1, 16
  srai \a_3_1, \a_3_1, 16
  addi \a_2_1, \a_2_1, 8
  addi \a_3_1, \a_3_1, 8
  mulh \a_2_1, \a_2_1, \q16
  mulh \a_3_1, \a_3_1, \q16
  sub \t_0, \a_4_0, \a_4_1
  sub \t_1, \a_5_0, \a_5_1
  add \a_4_0, \a_4_0, \a_4_1
  add \a_5_0, \a_5_0, \a_5_1
  mul \a_4_1, \t_0, \zeta_4
  mul \a_5_1, \t_1, \zeta_5
  sub \t_2, \a_6_0, \a_6_1
  sub \t_3, \a_7_0, \a_7_1
  add \a_6_0, \a_6_0, \a_6_1
  add \a_7_0, \a_7_0, \a_7_1
  mul \a_6_1, \t_2, \zeta_6
  mul \a_7_1, \t_3, \zeta_7
  srai \a_4_1, \a_4_1, 16
  srai \a_5_1, \a_5_1, 16
  addi \a_4_1, \a_4_1, 8
  addi \a_5_1, \a_5_1, 8
  mulh \a_4_1, \a_4_1, \q16
  mulh \a_5_1, \a_5_1, \q16
  srai \a_6_1, \a_6_1, 16
  srai \a_7_1, \a_7_1, 16
  addi \a_6_1, \a_6_1, 8
  addi \a_7_1, \a_7_1, 8
  mulh \a_6_1, \a_6_1, \q16
  mulh \a_7_1, \a_7_1, \q16
.endm

.globl cpi_plant_gs_bfu_x1
.align 2
cpi_plant_gs_bfu_x1:
.rep 200
    plant_gs_bfu a0, a1, a2, a3, t0
    plant_gs_bfu a4, a5, a6, t1, t2
.endr
ret

.globl cpi_fake_plant_gs_bfu_x1
.align 2
cpi_fake_plant_gs_bfu_x1:
.rep 400
    sub  a0, a0, a1
    add  a2, a2, a3
    mul  a4, a4, a5
    srai a6, a6, 16
    addi a7, a7, 8
    mulh t0, t0, t1
.endr
ret

.globl cpi_plant_gs_bfu_x2
.align 2
cpi_plant_gs_bfu_x2:
.rep 100
    plant_gs_bfu_x2 a0, a0, a1, a1, a2, a2, a3, a4, a5
    plant_gs_bfu_x2 t0, t0, t1, t1, t2, t2, t3, t4, t5
.endr
ret

.globl cpi_plant_gs_bfu_x4
.align 2
cpi_plant_gs_bfu_x4:
.rep 100
    plant_gs_bfu_x4 \
        a0, a1, a2, a3, \
        a4, a5, a6, a7, \
        t0, t0, t0, t0, \
        t1, t2, t3, t4, t5
.endr
ret

.globl cpi_plant_gs_bfu_x8
.align 2
cpi_plant_gs_bfu_x8:
.rep 100
    plant_gs_bfu_x8 \
        a0, a1, a2, a3, \
        a4, a5, a6, a7, \
        a0, a1, a2, a3, \
        a4, a5, a6, a7, \
        t0, t0, t0, t0, \
        t0, t0, t0, t0, \
        t1, \
        t2, t3, t4, t5
.endr
ret

.macro plant_mul_const q16, zeta, a, r
  mul \r, \a, \zeta
  srai \r, \r, 16
  addi \r, \r, 8
  mulh \r, \r, \q16
.endm

.macro plant_mul_const_x2 q16, zeta_0, zeta_1, a_0, a_1, r_0, r_1
  mul \r_0, \a_0, \zeta_0
  mul \r_1, \a_1, \zeta_1
  srai \r_0, \r_0, 16
  srai \r_1, \r_1, 16
  addi \r_0, \r_0, 8
  addi \r_1, \r_1, 8
  mulh \r_0, \r_0, \q16
  mulh \r_1, \r_1, \q16
.endm

.macro plant_mul_const_x4   \
    q16, zeta_0, zeta_1,\
    zeta_2, zeta_3,     \
    a_0, a_1, a_2, a_3, \
    r_0, r_1, r_2, r_3
  mul \r_0, \a_0, \zeta_0
  mul \r_1, \a_1, \zeta_1
  mul \r_2, \a_2, \zeta_2
  mul \r_3, \a_3, \zeta_3
  srai \r_0, \r_0, 16
  srai \r_1, \r_1, 16
  srai \r_2, \r_2, 16
  srai \r_3, \r_3, 16
  addi \r_0, \r_0, 8
  addi \r_1, \r_1, 8
  addi \r_2, \r_2, 8
  addi \r_3, \r_3, 8
  mulh \r_0, \r_0, \q16
  mulh \r_1, \r_1, \q16
  mulh \r_2, \r_2, \q16
  mulh \r_3, \r_3, \q16
.endm

.globl cpi_plantmul
.align 2
cpi_plantmul:
.rep 200
    plant_mul_const a0, a1, a2, a3
    plant_mul_const a4, a5, a6, a7
    plant_mul_const t0, t1, t2, t3
.endr
ret

.globl cpi_plantmulx2
.align 2
cpi_plantmulx2:
.rep 200
    plant_mul_const_x2 a0, a1, a2, a3, a4, a5, a6
    plant_mul_const_x2 a7, t0, t1, t2, t3, t4, t5
.endr
ret

.globl cpi_plantmulx4
.align 2
cpi_plantmulx4:
.rep 200
    plant_mul_const_x4 a0, \
        a1, a1, a1, a1, \
        a2, a3, a4, a5, \
        a6, a7, t0, t1
.endr
ret

#ifdef RV64

.macro plant_mul_const_rv64 q16, zeta_0, a_0, r_0
  mulw \r_0, \a_0, \zeta_0
  srai \r_0, \r_0, 16
  addi \r_0, \r_0, 8
  mul  \r_0, \r_0, \q16
  srai \r_0, \r_0, 32
.endm

.macro plant_mul_const_rv64x2 q16, \
    zeta_0, zeta_1, a_0, a_1, r_0, r_1
  mulw \r_0, \a_0, \zeta_0
  mulw \r_1, \a_1, \zeta_1
  srai \r_0, \r_0, 16
  srai \r_1, \r_1, 16
  addi \r_0, \r_0, 8
  addi \r_1, \r_1, 8
  mul  \r_0, \r_0, \q16
  mul  \r_1, \r_1, \q16
  srai \r_0, \r_0, 32
  srai \r_1, \r_1, 32
.endm

.macro plant_mul_const_rv64x4 q16,  \
    zeta_0, zeta_1, zeta_2, zeta_3, \
    a_0, a_1, a_2, a_3,         \
    r_0, r_1, r_2, r_3
  mulw \r_0, \a_0, \zeta_0
  mulw \r_1, \a_1, \zeta_1
  mulw \r_2, \a_2, \zeta_2
  mulw \r_3, \a_3, \zeta_3
  srai \r_0, \r_0, 16
  srai \r_1, \r_1, 16
  srai \r_2, \r_2, 16
  srai \r_3, \r_3, 16
  addi \r_0, \r_0, 8
  addi \r_1, \r_1, 8
  addi \r_2, \r_2, 8
  addi \r_3, \r_3, 8
  mul  \r_0, \r_0, \q16
  mul  \r_1, \r_1, \q16
  mul  \r_2, \r_2, \q16
  mul  \r_3, \r_3, \q16
  srai \r_0, \r_0, 32
  srai \r_1, \r_1, 32
  srai \r_2, \r_2, 32
  srai \r_3, \r_3, 32
.endm

.globl cpi_plantmul_rv64
.align 2
cpi_plantmul_rv64:
.rep 200
    plant_mul_const_rv64 a0, a1, a2, a3
    plant_mul_const_rv64 a4, a5, a6, a7
    plant_mul_const_rv64 t0, t1, t2, t3
.endr
ret

.globl cpi_plantmul_rv64x2
.align 2
cpi_plantmul_rv64x2:
.rep 200
    plant_mul_const_rv64x2 a0, a1, a1, a2, a3, a4, a5
    plant_mul_const_rv64x2 a6, a7, a7, t0, t1, t2, t3
.endr
ret

.globl cpi_plantmul_rv64x4
.align 2
cpi_plantmul_rv64x4:
.rep 200
    plant_mul_const_rv64x4 a0,  \
        a1, a1, a1, a1,     \
        a2, a3, a4, a5,     \
        a6, a7, t0, t1
.endr
ret

#endif
