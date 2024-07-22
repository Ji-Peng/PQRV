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

.macro plant_ct_bfu_x1 a_0, a_1, zeta, q16, tmp
    mul \tmp, \a_1, \zeta
    srai \tmp, \tmp, 16
    addi \tmp, \tmp, 8
    mulh \tmp, \tmp, \q16
    sub \a_1, \a_0, \tmp
    add \a_0, \a_0, \tmp
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

.globl cpi_ct_bfu_scalar_plant_x1
.align 2
cpi_ct_bfu_scalar_plant_x1:
.rep 100
    plant_ct_bfu_x1 a0, a1, a2, a3, t0
    plant_ct_bfu_x1 a4, a5, a6, t1, t2
.endr
ret

.globl cpi_ct_bfu_scalar_plant_x2
.align 2
cpi_ct_bfu_scalar_plant_x2:
.rep 100
    plant_ct_bfu_x2 a0, a0, a1, a1, a2, a2, a3, a4, a5
    plant_ct_bfu_x2 t0, t0, t1, t1, t2, t2, t3, t4, t5
.endr
ret

.globl cpi_ct_bfu_scalar_plant_x4
.align 2
cpi_ct_bfu_scalar_plant_x4:
.rep 100
    plant_ct_bfu_x4 \
        a0, a1, a2, a3, a4, a5, a6, a7, \
        t0, t0, t0, t0, t1, \
        t2, t3, t4, t5
.endr
ret

.globl cpi_ct_bfu_scalar_plant_x8
.align 2
cpi_ct_bfu_scalar_plant_x8:
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

.globl cpi_gs_bfu_scalar_plant_x1
.align 2
cpi_gs_bfu_scalar_plant_x1:
.rep 100
    plant_gs_bfu a0, a1, a2, a3, t0
    plant_gs_bfu a4, a5, a6, t1, t2
.endr
ret

.globl cpi_gs_bfu_scalar_plant_x2
.align 2
cpi_gs_bfu_scalar_plant_x2:
.rep 100
    plant_gs_bfu_x2 a0, a0, a1, a1, a2, a2, a3, a4, a5
    plant_gs_bfu_x2 t0, t0, t1, t1, t2, t2, t3, t4, t5
.endr
ret

.globl cpi_gs_bfu_scalar_plant_x4
.align 2
cpi_gs_bfu_scalar_plant_x4:
.rep 100
    plant_gs_bfu_x4 \
        a0, a1, a2, a3, \
        a4, a5, a6, a7, \
        t0, t0, t0, t0, \
        t1, t2, t3, t4, t5
.endr
ret

.globl cpi_gs_bfu_scalar_plant_x8
.align 2
cpi_gs_bfu_scalar_plant_x8:
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

.macro ct_bfu_scalar_mont_x4_v2 \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    a_2_0, a_2_1, a_3_0, a_3_1, \
    zeta_0, zeta_1, \
    zeta_2, zeta_3, \
    zetaqinv_0, zetaqinv_1, \
    zetaqinv_2, zetaqinv_3, \
    q, \
    t_0_0, t_0_1, t_1_0, t_2_0, \
    t_3_0
    mul  \t_0_0, \a_0_1, \zetaqinv_0
    mul  \t_1_0, \a_1_1, \zetaqinv_1
    mul  \t_2_0, \a_2_1, \zetaqinv_2
    mul  \t_3_0, \a_3_1, \zetaqinv_3
    mulh \t_0_1, \a_0_1, \zeta_0
    mulh \t_0_0, \t_0_0, \q
    mulh \t_1_0, \t_1_0, \q
    mulh \t_2_0, \t_2_0, \q
    mulh \t_3_0, \t_3_0, \q
    sub  \t_0_0, \t_0_1, \t_0_0
    mulh \t_0_1, \a_1_1, \zeta_1
    sub  \a_0_1, \a_0_0, \t_0_0
    add  \a_0_0, \a_0_0, \t_0_0
    sub  \t_1_0, \t_0_1, \t_1_0
    mulh \t_0_1, \a_2_1, \zeta_2
    sub  \a_1_1, \a_1_0, \t_1_0
    add  \a_1_0, \a_1_0, \t_1_0
    sub  \t_2_0, \t_0_1, \t_2_0
    mulh \t_0_1, \a_3_1, \zeta_3
    sub  \a_2_1, \a_2_0, \t_2_0
    add  \a_2_0, \a_2_0, \t_2_0
    sub  \t_3_0, \t_0_1, \t_3_0
    sub  \a_3_1, \a_3_0, \t_3_0
    add  \a_3_0, \a_3_0, \t_3_0
.endm

.macro ct_bfu_scalar_mont_x4_v3 \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    a_2_0, a_2_1, a_3_0, a_3_1, \
    zeta_0, zeta_1, \
    zeta_2, zeta_3, \
    zetaqinv_0, zetaqinv_1, \
    zetaqinv_2, zetaqinv_3, \
    q, \
    t_0_0, t_0_1, t_1_0, t_1_1, \
    t_2_0, t_3_0
    mul  \t_0_0, \a_0_1, \zetaqinv_0
    mul  \t_1_0, \a_1_1, \zetaqinv_1
    mul  \t_2_0, \a_2_1, \zetaqinv_2
    mul  \t_3_0, \a_3_1, \zetaqinv_3
    mulh \t_0_1, \a_0_1, \zeta_0
    mulh \t_0_0, \t_0_0, \q
    mulh \t_1_0, \t_1_0, \q
    mulh \t_2_0, \t_2_0, \q
    mulh \t_3_0, \t_3_0, \q
    sub  \t_0_0, \t_0_1, \t_0_0
    mulh \t_0_1, \a_1_1, \zeta_1
    sub  \a_0_1, \a_0_0, \t_0_0
    add  \a_0_0, \a_0_0, \t_0_0
    mulh \t_1_1, \a_2_1, \zeta_2
    sub  \t_1_0, \t_0_1, \t_1_0
    sub  \a_1_1, \a_1_0, \t_1_0
    add  \a_1_0, \a_1_0, \t_1_0
    mulh \t_0_1, \a_3_1, \zeta_3
    sub  \t_2_0, \t_1_1, \t_2_0
    sub  \a_2_1, \a_2_0, \t_2_0
    add  \a_2_0, \a_2_0, \t_2_0
    sub  \t_3_0, \t_0_1, \t_3_0
    sub  \a_3_1, \a_3_0, \t_3_0
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

.macro hybrid_to_mont_vx4_sx4 \
        va0, va1, va2, va3, \
        xb, xbqinv, xq, \
        vt0, vt1, vt2, vt3
    vmul.vx  \vt0, \va0, \xbqinv
    vmul.vx  \vt1, \va1, \xbqinv
    vmul.vx  \vt2, \va2, \xbqinv
    vmul.vx  \vt3, \va3, \xbqinv
    mul t0, t0, t0
    mul t1, t1, t1
    mul t2, t2, t2
    mul t3, t3, t3
    vmulh.vx \va0, \va0, \xb
    vmulh.vx \va1, \va1, \xb
    vmulh.vx \va2, \va2, \xb
    vmulh.vx \va3, \va3, \xb
    mul t4, t4, t4
    mul t5, t5, t5
    mul t6, t6, t6
    mul a1, a1, a1
    vmulh.vx \vt0, \vt0, \xq
    vmulh.vx \vt1, \vt1, \xq
    vmulh.vx \vt2, \vt2, \xq
    vmulh.vx \vt3, \vt3, \xq
    mul t0, t0, t0
    mul t1, t1, t1
    mul t2, t2, t2
    mul t3, t3, t3
    vsub.vv  \va0, \va0, \vt0
    vsub.vv  \va1, \va1, \vt1
    vsub.vv  \va2, \va2, \vt2
    vsub.vv  \va3, \va3, \vt3
    sub t4, t4, t4
    sub t5, t5, t5
    sub t6, t6, t6
    sub a1, a1, a1
.endm

.macro hybrid_to_mont_vx4_sx2 \
        va0, va1, va2, va3, \
        xb, xbqinv, xq, \
        vt0, vt1, vt2, vt3
    vmul.vx  \vt0, \va0, \xbqinv
    vmul.vx  \vt1, \va1, \xbqinv
    vmul.vx  \vt2, \va2, \xbqinv
    vmul.vx  \vt3, \va3, \xbqinv
    mul t0, t0, t0
    mul t1, t1, t1
    vmulh.vx \va0, \va0, \xb
    vmulh.vx \va1, \va1, \xb
    vmulh.vx \va2, \va2, \xb
    vmulh.vx \va3, \va3, \xb
    mul t4, t4, t4
    mul t5, t5, t5
    vmulh.vx \vt0, \vt0, \xq
    vmulh.vx \vt1, \vt1, \xq
    vmulh.vx \vt2, \vt2, \xq
    vmulh.vx \vt3, \vt3, \xq
    mul t0, t0, t0
    mul t1, t1, t1
    vsub.vv  \va0, \va0, \vt0
    vsub.vv  \va1, \va1, \vt1
    vsub.vv  \va2, \va2, \vt2
    vsub.vv  \va3, \va3, \vt3
    sub t4, t4, t4
    sub t5, t5, t5
.endm

.macro hybrid_to_mont_vx4_sx1 \
        va0, va1, va2, va3, \
        xb, xbqinv, xq, \
        vt0, vt1, vt2, vt3
    vmul.vx  \vt0, \va0, \xbqinv
    vmul.vx  \vt1, \va1, \xbqinv
    vmul.vx  \vt2, \va2, \xbqinv
    vmul.vx  \vt3, \va3, \xbqinv
    mul t0, t0, t0
    vmulh.vx \va0, \va0, \xb
    vmulh.vx \va1, \va1, \xb
    vmulh.vx \va2, \va2, \xb
    vmulh.vx \va3, \va3, \xb
    mul t4, t4, t4
    vmulh.vx \vt0, \vt0, \xq
    vmulh.vx \vt1, \vt1, \xq
    vmulh.vx \vt2, \vt2, \xq
    vmulh.vx \vt3, \vt3, \xq
    mul t0, t0, t0
    vsub.vv  \va0, \va0, \vt0
    vsub.vv  \va1, \va1, \vt1
    vsub.vv  \va2, \va2, \vt2
    vsub.vv  \va3, \va3, \vt3
    sub t4, t4, t4
.endm

.globl cpi_tomont_x4_vector
.align 2
cpi_tomont_x4_vector:
.rep 100
    tomont_x4 v0, v1, v2, v3, a1, a2, a3, v4, v5, v6, v7
.endr
ret

.globl cpi_hybrid_to_mont_vx4_sx4
.align 2
cpi_hybrid_to_mont_vx4_sx4:
.rep 100
    hybrid_to_mont_vx4_sx4 v0, v1, v2, v3, a1, a2, a3, v4, v5, v6, v7
.endr
ret

.globl cpi_hybrid_to_mont_vx4_sx2
.align 2
cpi_hybrid_to_mont_vx4_sx2:
.rep 100
    hybrid_to_mont_vx4_sx2 v0, v1, v2, v3, a1, a2, a3, v4, v5, v6, v7
.endr
ret

.globl cpi_hybrid_to_mont_vx4_sx1
.align 2
cpi_hybrid_to_mont_vx4_sx1:
.rep 100
    hybrid_to_mont_vx4_sx1 v0, v1, v2, v3, a1, a2, a3, v4, v5, v6, v7
.endr
ret

.globl cpi_ct_bfu_scalar_mont_x4
.align 2
cpi_ct_bfu_scalar_mont_x4:
.rep 200
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

.globl cpi_ct_bfu_scalar_mont_x4_v2
.align 2
cpi_ct_bfu_scalar_mont_x4_v2:
.rep 200
    ct_bfu_scalar_mont_x4_v2 \
    a0, a0, a1, a1, \
    a2, a2, a3, a3, \
    t0, t0, t0, t0, \
    t0, t0, t0, t0, \
    t0, \
    a4, a5, a6, a7, \
    t1
.endr
ret

.globl cpi_ct_bfu_scalar_mont_x4_v3
.align 2
cpi_ct_bfu_scalar_mont_x4_v3:
.rep 200
    ct_bfu_scalar_mont_x4_v3 \
        a0, a0, a1, a1, \
        a2, a2, a3, a3, \
        t0, t0, t0, t0, \
        t0, t0, t0, t0, \
        t0, \
        a4, a5, a6, a7, \
        t1, t2
.endr
ret

.globl cpi_ct_bfu_scalar_mont_x8
.align 2
cpi_ct_bfu_scalar_mont_x8:
    .rep 100
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
    .rep 50
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

.globl cpi_ct_bfu_vv_x4
.align 2
cpi_ct_bfu_vv_x4:
.rep 250
    ct_bfu_vv_x4 \
        v0,v1,v2,v3,v4,v5,v6,v7,\
        v8,v8,v8,v8,v8,v8,v8,v8,\
        a1,\
        v9,v10,v11,v12,v13,v14,v15,v16
    ct_bfu_vv_x4 \
        v17,v18,v19,v20,v21,v22,v23,v24,\
        v8,v8,v8,v8,v8,v8,v8,v8,\
        a1,\
        v25,v26,v27,v28,v29,v30,v31,v8
.endr
ret

.globl cpi_ct_bfu_vv_x8
.align 2
cpi_ct_bfu_vv_x8:
.rep 500
    ct_bfu_x8 v0,v1,v2,v3,v4,v5,v6,v7,\
        v9,v10,v11,v12,v13,v14,v15,v16,\
        t0,t0,t0,t0,\
        t0,t0,t0,t0,\
        t0,t0,t0,t0,\
        t0,t0,t0,t0,\
        a1,\
        v17,v18,v19,v20,\
        v21,v22,v23,v24,\
        v25,v26,v27,v28,\
        v29,v30,v31,v8
.endr
ret
