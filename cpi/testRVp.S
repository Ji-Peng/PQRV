.text

.globl cpi_add
.align 2
cpi_add:
    .rep 10
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
    .rep 10
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
    .rep 10
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
    .rep 10
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
    .rep 10
        add a0, a0, 1
        add a0, a0, 1
        add a1, a1, 1
        add a1, a1, 1
        add a2, a2, 1
        add a2, a2, 1
        add a3, a3, 1
        add a3, a3, 1
        add a4, a4, 1
        add a4, a4, 1
        add a5, a5, 1
        add a5, a5, 1
        add a6, a6, 1
        add a6, a6, 1
    .endr
    ret

.globl cpi_addxor
.align 2
cpi_addxor:
    .rep 10
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
    .rep 10
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
    .rep 10
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
    .rep 10
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
    .rep 10
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
    .rep 10
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
    .rep 10
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
    .rep 10
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
    .rep 10
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
    .rep 20
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
    .rep 20
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
    .rep 20
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
    .rep 10
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
    .rep 10
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
    .rep 15
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
    .rep 10
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
    .rep 10
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
    .rep 10
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
    .rep 10
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
        lh t3, 2*10(a0)
    .endr
    ret

.globl cpi_lw
.align 2
cpi_lw:
    .rep 10
        lw a1, 4*0(a0)
        lw a2, 4*1(a0)
        lw a3, 4*2(a0)
        lw a4, 4*3(a0)
        lw a5, 4*4(a0)
        lw a6, 4*5(a0)
        lw a7, 4*6(a0)
        lw t0, 4*7(a0)
        lw t1, 4*8(a0)
        lw t2, 4*9(a0)
        lw t3, 4*10(a0)
    .endr
    ret

#ifdef RV64
.globl cpi_ld
.align 2
cpi_ld:
    .rep 10
        ld a1, 4*0(a0)
        ld a2, 4*1(a0)
        ld a3, 4*2(a0)
        ld a4, 4*3(a0)
        ld a5, 4*4(a0)
        ld a6, 4*5(a0)
        ld a7, 4*6(a0)
        ld t0, 4*7(a0)
        ld t1, 4*8(a0)
        ld t2, 4*9(a0)
        ld t3, 4*10(a0)
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
    .rep 20
        plant_ct_bfu_x1 a0, a1, a2, a3, t0
        plant_ct_bfu_x1 a4, a5, a6, t1, t2
    .endr
    ret

.globl cpi_fake_plant_ct_bfu_x1
.align 2
cpi_fake_plant_ct_bfu_x1:
    .rep 40
        fake_plant_ct_bfu_x1
    .endr
    ret

.globl cpi_plant_ct_bfu_x2
.align 2
cpi_plant_ct_bfu_x2:
    .rep 20
        plant_ct_bfu_x2 a0, a0, a1, a1, a2, a2, a3, a4, a5
        plant_ct_bfu_x2 t0, t0, t1, t1, t2, t2, t3, t4, t5
    .endr
    ret

.globl cpi_fake_plant_ct_bfu_x2
.align 2
cpi_fake_plant_ct_bfu_x2:
    .rep 40
        fake_plant_ct_bfu_x2
    .endr
    ret

.globl cpi_plant_ct_bfu_x4
.align 2
cpi_plant_ct_bfu_x4:
    .rep 20
        plant_ct_bfu_x4 \
            a0, a1, a2, a3, a4, a5, a6, a7, \
            t0, t0, t0, t0, t1, \
            t2, t3, t4, t5
    .endr
    ret

.globl cpi_plant_ct_bfu_x8
.align 2
cpi_plant_ct_bfu_x8:
    .rep 10
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
    .rep 20
        plant_gs_bfu a0, a1, a2, a3, t0
        plant_gs_bfu a4, a5, a6, t1, t2
    .endr
    ret

.globl cpi_fake_plant_gs_bfu_x1
.align 2
cpi_fake_plant_gs_bfu_x1:
    .rep 40
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
    .rep 10
        plant_gs_bfu_x2 a0, a0, a1, a1, a2, a2, a3, a4, a5
        plant_gs_bfu_x2 t0, t0, t1, t1, t2, t2, t3, t4, t5
    .endr
    ret

.globl cpi_plant_gs_bfu_x4
.align 2
cpi_plant_gs_bfu_x4:
    .rep 10
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
    .rep 10
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
    .rep 20
        plant_mul_const a0, a1, a2, a3
        plant_mul_const a4, a5, a6, a7
        plant_mul_const t0, t1, t2, t3
    .endr
    ret

.globl cpi_plantmulx2
.align 2
cpi_plantmulx2:
    .rep 20
        plant_mul_const_x2 a0, a1, a2, a3, a4, a5, a6
        plant_mul_const_x2 a7, t0, t1, t2, t3, t4, t5
    .endr
    ret

.globl cpi_plantmulx4
.align 2
cpi_plantmulx4:
    .rep 20
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
    a_0, a_1, a_2, a_3,             \
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
    .rep 20
        plant_mul_const_rv64 a0, a1, a2, a3
        plant_mul_const_rv64 a4, a5, a6, a7
        plant_mul_const_rv64 t0, t1, t2, t3
    .endr
    ret

.globl cpi_plantmul_rv64x2
.align 2
cpi_plantmul_rv64x2:
    .rep 20
        plant_mul_const_rv64x2 a0, a1, a1, a2, a3, a4, a5
        plant_mul_const_rv64x2 a6, a7, a7, t0, t1, t2, t3
    .endr
    ret

.globl cpi_plantmul_rv64x4
.align 2
cpi_plantmul_rv64x4:
    .rep 20
        plant_mul_const_rv64x4 a0,  \
            a1, a1, a1, a1,         \
            a2, a3, a4, a5,         \
            a6, a7, t0, t1
    .endr
    ret

#endif

#ifdef VECTOR128

.globl init_vector
.align 2
init_vector:
    li t1, 128
    vsetvli a0, t1, e16, m1, tu, mu
    ret

.globl cpi_vle16
.align 2
cpi_vle16:
    .rep 20
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

.globl cpi_vmulvx
.align 2
cpi_vmulvx:
    .rep 20
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
    .rep 20
        vmul.vx v0, v0, t0
        vmul.vx v0, v0, t0
        vmul.vx v0, v0, t0
        vmul.vx v0, v0, t0
        vmul.vx v0, v0, t0
        vmul.vx v0, v0, t0
        vmul.vx v0, v0, t0
        vmul.vx v0, v0, t0
        vmul.vx v0, v0, t0
        vmul.vx v0, v0, t0
    .endr
    ret

.globl cpi_vmulvx_x2
.align 2
cpi_vmulvx_x2:
    .rep 20
        vmul.vx v0, v0, t0
        vmul.vx v1, v1, t0
        vmul.vx v0, v0, t0
        vmul.vx v1, v1, t0
        vmul.vx v0, v0, t0
        vmul.vx v1, v1, t0
        vmul.vx v0, v0, t0
        vmul.vx v1, v1, t0
        vmul.vx v0, v0, t0
        vmul.vx v1, v1, t0
    .endr
    ret

.globl cpi_vmulvx_x4
.align 2
cpi_vmulvx_x4:
    .rep 20
        vmul.vx v0, v0, t0
        vmul.vx v1, v1, t0
        vmul.vx v2, v2, t0
        vmul.vx v3, v3, t0
        vmul.vx v0, v0, t0
        vmul.vx v1, v1, t0
        vmul.vx v2, v2, t0
        vmul.vx v3, v3, t0
    .endr
    ret

.globl cpi_vmulvv
.align 2
cpi_vmulvv:
    .rep 20
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
    .rep 20
        vmul.vv v0, v0, v0
        vmul.vv v0, v0, v0
        vmul.vv v0, v0, v0
        vmul.vv v0, v0, v0
        vmul.vv v0, v0, v0
        vmul.vv v0, v0, v0
        vmul.vv v0, v0, v0
        vmul.vv v0, v0, v0
        vmul.vv v0, v0, v0
        vmul.vv v0, v0, v0
    .endr
    ret

.globl cpi_vmulvv_x2
.align 2
cpi_vmulvv_x2:
    .rep 20
        vmul.vv v0, v0, v10
        vmul.vv v1, v1, v10
        vmul.vv v0, v0, v10
        vmul.vv v1, v1, v10
        vmul.vv v0, v0, v10
        vmul.vv v1, v1, v10
        vmul.vv v0, v0, v10
        vmul.vv v1, v1, v10
        vmul.vv v0, v0, v10
        vmul.vv v1, v1, v10
    .endr
    ret

.globl cpi_vmulvv_x4
.align 2
cpi_vmulvv_x4:
    .rep 20
        vmul.vv v0, v0, v10
        vmul.vv v1, v1, v10
        vmul.vv v2, v2, v10
        vmul.vv v3, v3, v10
        vmul.vv v0, v0, v10
        vmul.vv v1, v1, v10
        vmul.vv v2, v2, v10
        vmul.vv v3, v3, v10
    .endr
    ret

.globl cpi_vaddvv
.align 2
cpi_vaddvv:
    .rep 20
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
    .rep 20
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
    .rep 20
        vadd.vx v0, v0, t2
        vadd.vx v0, v0, t2
        vadd.vx v0, v0, t2
        vadd.vx v0, v0, t2
        vadd.vx v0, v0, t2
        vadd.vx v0, v0, t2
        vadd.vx v0, v0, t2
        vadd.vx v0, v0, t2
        vadd.vx v0, v0, t2
        vadd.vx v0, v0, t2
    .endr
    ret

.globl cpi_vaddvx_x2
.align 2
cpi_vaddvx_x2:
    .rep 20
        vadd.vx v0, v0, t2
        vadd.vx v1, v1, t2
        vadd.vx v0, v0, t2
        vadd.vx v1, v1, t2
        vadd.vx v0, v0, t2
        vadd.vx v1, v1, t2
        vadd.vx v0, v0, t2
        vadd.vx v1, v1, t2
        vadd.vx v0, v0, t2
        vadd.vx v1, v1, t2
    .endr
    ret

.globl cpi_vaddvx_x4
.align 2
cpi_vaddvx_x4:
    .rep 20
        vadd.vx v0, v0, t2
        vadd.vx v1, v1, t2
        vadd.vx v2, v2, t2
        vadd.vx v3, v3, t2
        vadd.vx v0, v0, t2
        vadd.vx v1, v1, t2
        vadd.vx v2, v2, t2
        vadd.vx v3, v3, t2
        vadd.vx v0, v0, t2
        vadd.vx v1, v1, t2
        vadd.vx v2, v2, t2
        vadd.vx v3, v3, t2
    .endr
    ret

.globl cpi_vsravi
.align 2
cpi_vsravi:
    .rep 20
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

.globl cpi_vrgathervv
.align 2
cpi_vrgathervv:
    .rep 20
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

.globl cpi_vmergevvm
.align 2
cpi_vmergevvm:
    .rep 20
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

.macro montmul_x1 r, a, b, bqinv, q, t
    mul  \r, \a, \bqinv
    mulh \t, \a, \b
    mulh \r, \r, \q
    sub  \r, \t, \r
.endm

.macro ct_bfu_scalar_mont_x4 \
        a_0_0, a_0_1, a_1_0, a_1_1, \
        a_2_0, a_2_1, a_3_0, a_3_1, \
        zeta_0, zeta_1, \
        zeta_2, zeta_3, \
        zetaqinv_0, zetaqinv_1, \
        zetaqinv_2, zetaqinv_3, \
        q, \
        t_0_0, t_0_1, t_1_0, t_1_1, \
        t_2_0, t_2_1, t_3_0, t_3_1
    mul  \t_0_0, \a_0_1, \zetaqinv_0
    mul  \t_1_0, \a_1_1, \zetaqinv_1
    mul  \t_2_0, \a_2_1, \zetaqinv_2
    mul  \t_3_0, \a_3_1, \zetaqinv_3
    mulh \t_0_1, \a_0_1, \zeta_0
    mulh \t_1_1, \a_1_1, \zeta_1
    mulh \t_2_1, \a_2_1, \zeta_2
    mulh \t_3_1, \a_3_1, \zeta_3
    mulh \t_0_0, \t_0_0, \q
    mulh \t_1_0, \t_1_0, \q
    mulh \t_2_0, \t_2_0, \q
    mulh \t_3_0, \t_3_0, \q
    sub  \t_0_0, \t_0_1, \t_0_0
    sub  \t_1_0, \t_1_1, \t_1_0
    sub  \t_2_0, \t_2_1, \t_2_0
    sub  \t_3_0, \t_3_1, \t_3_0
    sub  \a_0_1, \a_0_0, \t_0_0
    sub  \a_1_1, \a_1_0, \t_1_0
    sub  \a_2_1, \a_2_0, \t_2_0
    sub  \a_3_1, \a_3_0, \t_3_0
    add  \a_0_0, \a_0_0, \t_0_0
    add  \a_1_0, \a_1_0, \t_1_0
    add  \a_2_0, \a_2_0, \t_2_0
    add  \a_3_0, \a_3_0, \t_3_0
.endm

.macro ct_bfu_scalar_mont_x8 \
        a_0_0, a_0_1, a_1_0, a_1_1, \
        a_2_0, a_2_1, a_3_0, a_3_1, \
        a_4_0, a_4_1, a_5_0, a_5_1, \
        a_6_0, a_6_1, a_7_0, a_7_1, \
        zeta_0, zeta_1, \
        zeta_2, zeta_3, \
        zeta_4, zeta_5, \
        zeta_6, zeta_7, \
        zetaqinv_0, zetaqinv_1, \
        zetaqinv_2, zetaqinv_3, \
        zetaqinv_4, zetaqinv_5, \
        zetaqinv_6, zetaqinv_7, \
        q, \
        t_0_0, t_0_1, t_1_0, t_1_1, \
        t_2_0, t_2_1, t_3_0, t_3_1, \
        t_4_0, t_4_1, t_5_0, t_5_1, \
        t_6_0, t_6_1, t_7_0, t_7_1
    mul  \t_0_0, \a_0_1, \zetaqinv_0
    mul  \t_1_0, \a_1_1, \zetaqinv_1
    mul  \t_2_0, \a_2_1, \zetaqinv_2
    mul  \t_3_0, \a_3_1, \zetaqinv_3
    mul  \t_4_0, \a_4_1, \zetaqinv_4
    mul  \t_5_0, \a_5_1, \zetaqinv_5
    mul  \t_6_0, \a_6_1, \zetaqinv_6
    mul  \t_7_0, \a_7_1, \zetaqinv_7
    mulh \t_0_1, \a_0_1, \zeta_0
    mulh \t_1_1, \a_1_1, \zeta_1
    mulh \t_2_1, \a_2_1, \zeta_2
    mulh \t_3_1, \a_3_1, \zeta_3
    mulh \t_4_1, \a_4_1, \zeta_4
    mulh \t_5_1, \a_5_1, \zeta_5
    mulh \t_6_1, \a_6_1, \zeta_6
    mulh \t_7_1, \a_7_1, \zeta_7
    mulh \t_0_0, \t_0_0, \q
    mulh \t_1_0, \t_1_0, \q
    mulh \t_2_0, \t_2_0, \q
    mulh \t_3_0, \t_3_0, \q
    mulh \t_4_0, \t_4_0, \q
    mulh \t_5_0, \t_5_0, \q
    mulh \t_6_0, \t_6_0, \q
    mulh \t_7_0, \t_7_0, \q
    sub  \t_0_0, \t_0_1, \t_0_0
    sub  \t_1_0, \t_1_1, \t_1_0
    sub  \t_2_0, \t_2_1, \t_2_0
    sub  \t_3_0, \t_3_1, \t_3_0
    sub  \t_4_0, \t_4_1, \t_4_0
    sub  \t_5_0, \t_5_1, \t_5_0
    sub  \t_6_0, \t_6_1, \t_6_0
    sub  \t_7_0, \t_7_1, \t_7_0
    sub  \a_0_1, \a_0_0, \t_0_0
    sub  \a_1_1, \a_1_0, \t_1_0
    sub  \a_2_1, \a_2_0, \t_2_0
    sub  \a_3_1, \a_3_0, \t_3_0
    sub  \a_4_1, \a_4_0, \t_4_0
    sub  \a_5_1, \a_5_0, \t_5_0
    sub  \a_6_1, \a_6_0, \t_6_0
    sub  \a_7_1, \a_7_0, \t_7_0
    add  \a_0_0, \a_0_0, \t_0_0
    add  \a_1_0, \a_1_0, \t_1_0
    add  \a_2_0, \a_2_0, \t_2_0
    add  \a_3_0, \a_3_0, \t_3_0
    add  \a_4_0, \a_4_0, \t_4_0
    add  \a_5_0, \a_5_0, \t_5_0
    add  \a_6_0, \a_6_0, \t_6_0
    add  \a_7_0, \a_7_0, \t_7_0
.endm

.macro ct_bfu_vector_mont_x1    \
        va_0_0, va_0_1, \
        vzeta_0, \
        vzetaqinv_0, \
        q, \
        vt_0_0, vt_0_1
    vmul.vx  \vt_0_0, \va_0_1, \vzetaqinv_0
    vmulh.vx \vt_0_1, \va_0_1, \vzeta_0
    vmulh.vx \vt_0_0, \vt_0_0, \q
    vsub.vv  \vt_0_0, \vt_0_1, \vt_0_0
    vsub.vv  \va_0_1, \va_0_0, \vt_0_0
    vadd.vv  \va_0_0, \va_0_0, \vt_0_0
.endm

.macro hybrid_ct_bfu_4s_mont_1v_mont \
        a_0_0, a_0_1, a_1_0, a_1_1, \
        a_2_0, a_2_1, a_3_0, a_3_1, \
        zeta_0, zeta_1, zeta_2, zeta_3, \
        zetaqinv_0, zetaqinv_1, \
        zetaqinv_2, zetaqinv_3, \
        q, \
        t_0_0, t_0_1, t_1_0, t_1_1, \
        t_2_0, t_2_1, t_3_0, t_3_1, \
        va_0_0, va_0_1, \
        vzeta_0, vzetaqinv_0, \
        vt_0_0, vt_0_1
    vmul.vx  \vt_0_0, \va_0_1, \vzetaqinv_0
    mul  \t_0_0, \a_0_1, \zetaqinv_0
    mul  \t_1_0, \a_1_1, \zetaqinv_1
    mul  \t_2_0, \a_2_1, \zetaqinv_2
    mul  \t_3_0, \a_3_1, \zetaqinv_3
    vmulh.vx \vt_0_1, \va_0_1, \vzeta_0
    mulh \t_0_1, \a_0_1, \zeta_0
    mulh \t_1_1, \a_1_1, \zeta_1
    mulh \t_2_1, \a_2_1, \zeta_2
    mulh \t_3_1, \a_3_1, \zeta_3
    vmulh.vx \vt_0_0, \vt_0_0, \q
    mulh \t_0_0, \t_0_0, \q
    mulh \t_1_0, \t_1_0, \q
    mulh \t_2_0, \t_2_0, \q
    mulh \t_3_0, \t_3_0, \q
    vsub.vv  \vt_0_0, \vt_0_1, \vt_0_0
    sub  \t_0_0, \t_0_1, \t_0_0
    sub  \t_1_0, \t_1_1, \t_1_0
    sub  \t_2_0, \t_2_1, \t_2_0
    sub  \t_3_0, \t_3_1, \t_3_0
    vsub.vv  \va_0_1, \va_0_0, \vt_0_0
    sub  \a_0_1, \a_0_0, \t_0_0
    sub  \a_1_1, \a_1_0, \t_1_0
    sub  \a_2_1, \a_2_0, \t_2_0
    sub  \a_3_1, \a_3_0, \t_3_0
    vadd.vv  \va_0_0, \va_0_0, \vt_0_0
    add  \a_0_0, \a_0_0, \t_0_0
    add  \a_1_0, \a_1_0, \t_1_0
    add  \a_2_0, \a_2_0, \t_2_0
    add  \a_3_0, \a_3_0, \t_3_0
.endm

.macro hybrid_ct_bfu_8s_mont_1v_mont \
        a_0_0, a_0_1, a_1_0, a_1_1, \
        a_2_0, a_2_1, a_3_0, a_3_1, \
        a_4_0, a_4_1, a_5_0, a_5_1, \
        a_6_0, a_6_1, a_7_0, a_7_1, \
        zeta_0, zeta_1, \
        zeta_2, zeta_3, \
        zeta_4, zeta_5, \
        zeta_6, zeta_7, \
        zetaqinv_0, zetaqinv_1, \
        zetaqinv_2, zetaqinv_3, \
        zetaqinv_4, zetaqinv_5, \
        zetaqinv_6, zetaqinv_7, \
        q, \
        t_0_0, t_0_1, t_1_0, t_1_1, \
        t_2_0, t_2_1, t_3_0, t_3_1, \
        t_4_0, t_4_1, t_5_0, t_5_1, \
        t_6_0, t_6_1, t_7_0, t_7_1, \
        va_0_0, va_0_1, \
        vzeta_0, vzetaqinv_0, \
        vt_0_0, vt_0_1
    vmul.vx  \vt_0_0, \va_0_1, \vzetaqinv_0
    mul  \t_0_0, \a_0_1, \zetaqinv_0
    mul  \t_1_0, \a_1_1, \zetaqinv_1
    mul  \t_2_0, \a_2_1, \zetaqinv_2
    mul  \t_3_0, \a_3_1, \zetaqinv_3
    mul  \t_4_0, \a_4_1, \zetaqinv_4
    mul  \t_5_0, \a_5_1, \zetaqinv_5
    mul  \t_6_0, \a_6_1, \zetaqinv_6
    mul  \t_7_0, \a_7_1, \zetaqinv_7
    vmulh.vx \vt_0_1, \va_0_1, \vzeta_0
    mulh \t_0_1, \a_0_1, \zeta_0
    mulh \t_1_1, \a_1_1, \zeta_1
    mulh \t_2_1, \a_2_1, \zeta_2
    mulh \t_3_1, \a_3_1, \zeta_3
    mulh \t_4_1, \a_4_1, \zeta_4
    mulh \t_5_1, \a_5_1, \zeta_5
    mulh \t_6_1, \a_6_1, \zeta_6
    mulh \t_7_1, \a_7_1, \zeta_7
    vmulh.vx \vt_0_0, \vt_0_0, \q
    mulh \t_0_0, \t_0_0, \q
    mulh \t_1_0, \t_1_0, \q
    mulh \t_2_0, \t_2_0, \q
    mulh \t_3_0, \t_3_0, \q
    mulh \t_4_0, \t_4_0, \q
    mulh \t_5_0, \t_5_0, \q
    mulh \t_6_0, \t_6_0, \q
    mulh \t_7_0, \t_7_0, \q
    vsub.vv  \vt_0_0, \vt_0_1, \vt_0_0
    sub  \t_0_0, \t_0_1, \t_0_0
    sub  \t_1_0, \t_1_1, \t_1_0
    sub  \t_2_0, \t_2_1, \t_2_0
    sub  \t_3_0, \t_3_1, \t_3_0
    sub  \t_4_0, \t_4_1, \t_4_0
    sub  \t_5_0, \t_5_1, \t_5_0
    sub  \t_6_0, \t_6_1, \t_6_0
    sub  \t_7_0, \t_7_1, \t_7_0
    vsub.vv  \va_0_1, \va_0_0, \vt_0_0
    sub  \a_0_1, \a_0_0, \t_0_0
    sub  \a_1_1, \a_1_0, \t_1_0
    sub  \a_2_1, \a_2_0, \t_2_0
    sub  \a_3_1, \a_3_0, \t_3_0
    sub  \a_4_1, \a_4_0, \t_4_0
    sub  \a_5_1, \a_5_0, \t_5_0
    sub  \a_6_1, \a_6_0, \t_6_0
    sub  \a_7_1, \a_7_0, \t_7_0
    vadd.vv  \va_0_0, \va_0_0, \vt_0_0
    add  \a_0_0, \a_0_0, \t_0_0
    add  \a_1_0, \a_1_0, \t_1_0
    add  \a_2_0, \a_2_0, \t_2_0
    add  \a_3_0, \a_3_0, \t_3_0
    add  \a_4_0, \a_4_0, \t_4_0
    add  \a_5_0, \a_5_0, \t_5_0
    add  \a_6_0, \a_6_0, \t_6_0
    add  \a_7_0, \a_7_0, \t_7_0
.endm

.globl cpi_ct_bfu_scalar_mont_x4
.align 2
cpi_ct_bfu_scalar_mont_x4:
    .rep 20
        ct_bfu_scalar_mont_x4 \
            a0, a0, a1, a1, \
            a2, a2, a3, a3, \
            t0, t0, t0, t0, \
            t0, t0, t0, t0, \
            t0, \
            a4, a5, a6, a7, \
            t1, t2, t3, t4
    .endr
    ret

.globl cpi_ct_bfu_scalar_mont_x8
.align 2
cpi_ct_bfu_scalar_mont_x8:
    .rep 10
        ct_bfu_scalar_mont_x8 \
            a0, a0, a1, a1, \
            a2, a2, a3, a3, \
            a4, a4, a5, a5, \
            a6, a6, a7, a7, \
            t0, t0, t0, t0, \
            t0, t0, t0, t0, \
            t0, t0, t0, t0, \
            t0, t0, t0, t0, \
            t0, \
            t1, t1, t2, t2, \
            t3, t3, t4, t4, \
            t5, t5, t6, t6, \
            a0, a0, a1, a1
    .endr
    ret

.globl cpi_ct_bfu_vector_mont_x1
.align 2
cpi_ct_bfu_vector_mont_x1:
    .rep 5
        ct_bfu_vector_mont_x1 \
            v0, v1, \
            t0, t1, t2, \
            v2, v3
        ct_bfu_vector_mont_x1 \
            v4, v5, \
            t0, t1, t2, \
            v6, v7
        ct_bfu_vector_mont_x1 \
            v8, v9, \
            t0, t1, t2, \
            v10, v11
        ct_bfu_vector_mont_x1 \
            v12, v13, \
            t0, t1, t2, \
            v14, v15
    .endr
    ret

.globl cpi_hybrid_ct_bfu_4s_mont_1v_mont
.align 2
cpi_hybrid_ct_bfu_4s_mont_1v_mont:
    .rep 20
        hybrid_ct_bfu_4s_mont_1v_mont \
            a0, a0, a1, a1, \
            a2, a2, a3, a3, \
            t0, t0, t0, t0, \
            t0, t0, t0, t0, \
            t0, \
            a4, a5, a6, a7, \
            t1, t2, t3, t4, \
            v0, v1, \
            t0, t0, \
            v2, v3
    .endr
    ret

# hybrid_ct_bfu_8s_mont_1v_mont
.globl cpi_hybrid_ct_bfu_8s_mont_1v_mont
.align 2
cpi_hybrid_ct_bfu_8s_mont_1v_mont:
    .rep 20
        hybrid_ct_bfu_8s_mont_1v_mont \
            a0, a0, a1, a1, \
            a2, a2, a3, a3, \
            a4, a4, a5, a5, \
            a6, a6, a7, a7, \
            t0, t0, t0, t0, \
            t0, t0, t0, t0, \
            t0, t0, t0, t0, \
            t0, t0, t0, t0, \
            t0, \
            t1, t1, t2, t2, \
            t3, t3, t4, t4, \
            t5, t5, t6, t6, \
            a0, a0, a1, a1, \
            v0, v1, \
            t0, t0, \
            v2, v3
    .endr
    ret

#endif