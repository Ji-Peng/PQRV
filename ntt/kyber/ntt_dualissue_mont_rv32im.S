.text

.macro save_regs
  sw s0,  0*4(sp)
  sw s1,  1*4(sp)
  sw s2,  2*4(sp)
  sw s3,  3*4(sp)
  sw s4,  4*4(sp)
  sw s5,  5*4(sp)
  sw s6,  6*4(sp)
  sw s7,  7*4(sp)
  sw s8,  8*4(sp)
  sw s9,  9*4(sp)
  sw s10, 10*4(sp)
  sw s11, 11*4(sp)
  sw gp,  12*4(sp)
  sw tp,  13*4(sp)
  sw ra,  14*4(sp)
.endm

.macro restore_regs
  lw s0,  0*4(sp)
  lw s1,  1*4(sp)
  lw s2,  2*4(sp)
  lw s3,  3*4(sp)
  lw s4,  4*4(sp)
  lw s5,  5*4(sp)
  lw s6,  6*4(sp)
  lw s7,  7*4(sp)
  lw s8,  8*4(sp)
  lw s9,  9*4(sp)
  lw s10, 10*4(sp)
  lw s11, 11*4(sp)
  lw gp,  12*4(sp)
  lw tp,  13*4(sp)
  lw ra,  14*4(sp)
.endm

.macro load_coeffs len, poly
    lh t0, \len*2*0(\poly)
    lh t1, \len*2*1(\poly)
    lh t2, \len*2*2(\poly)
    lh t3, \len*2*3(\poly)
    lh t4, \len*2*4(\poly)
    lh t5, \len*2*5(\poly)
    lh t6, \len*2*6(\poly)
    lh tp, \len*2*7(\poly)
.endm

.macro store_coeffs len, poly
    sh t0, \len*2*0(\poly)
    sh t1, \len*2*1(\poly)
    sh t2, \len*2*2(\poly)
    sh t3, \len*2*3(\poly)
    sh t4, \len*2*4(\poly)
    sh t5, \len*2*5(\poly)
    sh t6, \len*2*6(\poly)
    sh tp, \len*2*7(\poly)
.endm

.macro load_5_zetas_zetasqinv
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    lh s2, 2*4(a1);     lw s3, 3*4(a1)
    lh s4, 4*4(a1);     lw s5, 5*4(a1)
    lh s6, 6*4(a1);     lw s7, 7*4(a1)
    lh s8, 8*4(a1);     lw s9, 9*4(a1)
.endm

# in: a, b
# out: a*b*(2^{-32}) mod q
# int64_t c=a*b
# int32_t t=c*qinv
# r=((int64_t)c-(int64_t)t*q)>>32=a*b*(2^{-32}) mod q
.macro montmul_ref r, a, b, q, qinv, t
    # cl <- low(a*b)
    mul \r, \a, \b
    # clqinv <- low(cl*qinv)
    mul \r, \r, \qinv
    # tq <- high(clqinv*q)
    mulh \r, \r, \q
    # ch <- high(a*b)
    mulh \t, \a, \b
    # r <- ch - tq
    sub \r, \t, \r
.endm

# in: a, b, bqinv <- low(b*qinv)
# out: a*b*(2^{-32}) mod q
.macro montmul r, a, b, bqinv, q, t
    mul  \r, \a, \bqinv
    mulh \t, \a, \b
    mulh \r, \r, \q
    sub  \r, \t, \r
.endm

.macro montmul_inplace a, b, bqinv, q, t
    mul  \t, \a, \bqinv
    mulh \a, \a, \b
    mulh \t, \t, \q
    sub  \a, \a, \t
.endm

.macro montmul_inplace_x2 \
    a_0, a_1, \
    zeta, zetaqinv, q, \
    t_0, t_1
    mul  \t_0, \a_0, \zetaqinv
    mul  \t_1, \a_1, \zetaqinv
    mulh \a_0, \a_0, \zeta
    mulh \a_1, \a_1, \zeta
    mulh \t_0, \t_0, \q
    mulh \t_1, \t_1, \q
    sub  \a_0, \a_0, \t_0
    sub  \a_1, \a_1, \t_1
.endm

.macro montmul_inplace_x4 \
    a_0, a_1, a_2, a_3, \
    zeta, zetaqinv, q, \
    t_0, t_1, t_2, t_3
    mul  \t_0, \a_0, \zetaqinv
    mul  \t_1, \a_1, \zetaqinv
    mul  \t_2, \a_2, \zetaqinv
    mul  \t_3, \a_3, \zetaqinv
    mulh \a_0, \a_0, \zeta
    mulh \a_1, \a_1, \zeta
    mulh \a_2, \a_2, \zeta
    mulh \a_3, \a_3, \zeta
    mulh \t_0, \t_0, \q
    mulh \t_1, \t_1, \q
    mulh \t_2, \t_2, \q
    mulh \t_3, \t_3, \q
    sub  \a_0, \a_0, \t_0
    sub  \a_1, \a_1, \t_1
    sub  \a_2, \a_2, \t_2
    sub  \a_3, \a_3, \t_3
.endm

.macro montrdc r, ch, cl, q, qinv
    mul  \r, \cl, \qinv
    mulh \r, \r, \q
    sub  \r, \ch, \r
.endm

.macro montrdc_x4 \
    r_0, r_1, r_2, r_3, \
    ch_0, cl_0, ch_1, cl_1, \
    ch_2, cl_2, ch_3, cl_3, \
    q, qinv
    mul  \r_0, \cl_0, \qinv
    mul  \r_1, \cl_1, \qinv
    mul  \r_2, \cl_2, \qinv
    mul  \r_3, \cl_3, \qinv
    mulh \r_0, \r_0, \q
    mulh \r_1, \r_1, \q
    mulh \r_2, \r_2, \q
    mulh \r_3, \r_3, \q
    sub  \r_0, \ch_0, \r_0
    sub  \r_1, \ch_1, \r_1
    sub  \r_2, \ch_2, \r_2
    sub  \r_3, \ch_3, \r_3
.endm

# .macro ct_bfu in0, in1, zeta, zetaqinv, q, tmp0, tmp1
#     montmul \tmp0, \in1, \zeta, \zetaqinv, \q, \tmp1
#     sub \in1, \in0, \tmp0
#     add \in0, \in0, \tmp0
# .endm

.macro ct_bfu a_0_0, a_0_1, zeta_0, zetaqinv_0, q, t_0_0, t_0_1
    mul  \t_0_0, \a_0_1, \zetaqinv_0
    mulh \t_0_1, \a_0_1, \zeta_0
    mulh \t_0_0, \t_0_0, \q
    sub  \t_0_0, \t_0_1, \t_0_0
    sub  \a_0_1, \a_0_0, \t_0_0
    add  \a_0_0, \a_0_0, \t_0_0
.endm

.macro ct_bfu_x2 \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    zeta_0, zetaqinv_0, \
    zeta_1, zetaqinv_1, \
    q, \
    t_0_0, t_0_1, t_1_0, t_1_1
    mul  \t_0_0, \a_0_1, \zetaqinv_0
    mul  \t_1_0, \a_1_1, \zetaqinv_1
    mulh \t_0_1, \a_0_1, \zeta_0
    mulh \t_1_1, \a_1_1, \zeta_1
    mulh \t_0_0, \t_0_0, \q
    mulh \t_1_0, \t_1_0, \q
    sub  \t_0_0, \t_0_1, \t_0_0
    sub  \t_1_0, \t_1_1, \t_1_0
    sub  \a_0_1, \a_0_0, \t_0_0
    sub  \a_1_1, \a_1_0, \t_1_0
    add  \a_0_0, \a_0_0, \t_0_0
    add  \a_1_0, \a_1_0, \t_1_0
.endm

.macro ct_bfu_x4 \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    a_2_0, a_2_1, a_3_0, a_3_1, \
    zeta_0, zetaqinv_0, \
    zeta_1, zetaqinv_1, \
    zeta_2, zetaqinv_2, \
    zeta_3, zetaqinv_3, \
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

.macro ct_bfu_x4_load2zeta \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    a_2_0, a_2_1, a_3_0, a_3_1, \
    zeta_0, zetaqinv_0, \
    zeta_1, zetaqinv_1, \
    zeta_2, zetaqinv_2, \
    zeta_3, zetaqinv_3, \
    q, \
    t_0_0, t_0_1, t_1_0, t_1_1, \
    t_2_0, t_2_1, t_3_0, t_3_1
    lw   \t_3_1, 4*17(sp)
    lw   \t_2_0, \zetaqinv_2(\t_3_1)
    lw   \t_3_0, \zetaqinv_3(\t_3_1)
    lw   \t_2_1, \zeta_2(\t_3_1)
    lw   \t_3_1, \zeta_3(\t_3_1)
    mul  \t_0_0, \a_0_1, \zetaqinv_0
    mul  \t_1_0, \a_1_1, \zetaqinv_1
    mul  \t_2_0, \a_2_1, \t_2_0
    mul  \t_3_0, \a_3_1, \t_3_0
    mulh \t_0_1, \a_0_1, \zeta_0
    mulh \t_1_1, \a_1_1, \zeta_1
    mulh \t_2_1, \a_2_1, \t_2_1
    mulh \t_3_1, \a_3_1, \t_3_1
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

# .macro gs_bfu in0, in1, zeta, zetaqinv, q, tmp0, tmp1
#     sub \tmp0, \in0, \in1
#     add \in0, \in0, \in1
#     montmul \in1, \tmp0, \zeta, \zetaqinv, \q, \tmp1
# .endm

.macro gs_bfu a_0_0, a_0_1, zeta_0, zetaqinv_0, q, t_0_0, t_0_1
    sub  \t_0_0, \a_0_0, \a_0_1
    add  \a_0_0, \a_0_0, \a_0_1
    mul  \a_0_1, \t_0_0, \zetaqinv_0
    mulh \t_0_1, \t_0_0, \zeta_0
    mulh \a_0_1, \a_0_1, \q
    sub  \a_0_1, \t_0_1, \a_0_1
.endm

.macro gs_bfu_x2 \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    zeta_0, zetaqinv_0, \
    zeta_1, zetaqinv_1, \
    q, \
    t_0_0, t_0_1, t_1_0, t_1_1
    sub  \t_0_0, \a_0_0, \a_0_1
    sub  \t_1_0, \a_1_0, \a_1_1
    add  \a_0_0, \a_0_0, \a_0_1
    add  \a_1_0, \a_1_0, \a_1_1
    mul  \a_0_1, \t_0_0, \zetaqinv_0
    mul  \a_1_1, \t_1_0, \zetaqinv_1
    mulh \t_0_1, \t_0_0, \zeta_0
    mulh \t_1_1, \t_1_0, \zeta_1
    mulh \a_0_1, \a_0_1, \q
    mulh \a_1_1, \a_1_1, \q
    sub  \a_0_1, \t_0_1, \a_0_1
    sub  \a_1_1, \t_1_1, \a_1_1
.endm

.macro gs_bfu_x4 \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    a_2_0, a_2_1, a_3_0, a_3_1, \
    zeta_0, zetaqinv_0, \
    zeta_1, zetaqinv_1, \
    zeta_2, zetaqinv_2, \
    zeta_3, zetaqinv_3, \
    q, \
    t_0_0, t_0_1, t_1_0, t_1_1, \
    t_2_0, t_2_1, t_3_0, t_3_1
    sub  \t_0_0, \a_0_0, \a_0_1
    sub  \t_1_0, \a_1_0, \a_1_1
    sub  \t_2_0, \a_2_0, \a_2_1
    sub  \t_3_0, \a_3_0, \a_3_1
    add  \a_0_0, \a_0_0, \a_0_1
    add  \a_1_0, \a_1_0, \a_1_1
    add  \a_2_0, \a_2_0, \a_2_1
    add  \a_3_0, \a_3_0, \a_3_1
    mul  \a_0_1, \t_0_0, \zetaqinv_0
    mul  \a_1_1, \t_1_0, \zetaqinv_1
    mul  \a_2_1, \t_2_0, \zetaqinv_2
    mul  \a_3_1, \t_3_0, \zetaqinv_3
    mulh \t_0_1, \t_0_0, \zeta_0
    mulh \t_1_1, \t_1_0, \zeta_1
    mulh \t_2_1, \t_2_0, \zeta_2
    mulh \t_3_1, \t_3_0, \zeta_3
    mulh \a_0_1, \a_0_1, \q
    mulh \a_1_1, \a_1_1, \q
    mulh \a_2_1, \a_2_1, \q
    mulh \a_3_1, \a_3_1, \q
    sub  \a_0_1, \t_0_1, \a_0_1
    sub  \a_1_1, \t_1_1, \a_1_1
    sub  \a_2_1, \t_2_1, \a_2_1
    sub  \a_3_1, \t_3_1, \a_3_1
.endm

# 2l: 2th layer
.macro gs_bfu_x4_2l_load1zeta \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    a_2_0, a_2_1, a_3_0, a_3_1, \
    zeta_0, zetaqinv_0, \
    zeta_2, zetaqinv_2, \
    q, \
    t_0_0, t_0_1, t_1_0, t_1_1, \
    t_2_0, t_2_1, t_3_0, t_3_1
    lw   \t_3_1, 4*17(sp)
    sub  \t_0_0, \a_0_0, \a_0_1
    sub  \t_1_0, \a_1_0, \a_1_1
    sub  \t_2_0, \a_2_0, \a_2_1
    sub  \t_3_0, \a_3_0, \a_3_1
    lw   \t_2_1, \zetaqinv_2(\t_3_1)
    lw   \t_3_1, \zeta_2(\t_3_1)
    add  \a_0_0, \a_0_0, \a_0_1
    add  \a_1_0, \a_1_0, \a_1_1
    add  \a_2_0, \a_2_0, \a_2_1
    add  \a_3_0, \a_3_0, \a_3_1
    mul  \a_0_1, \t_0_0, \zetaqinv_0
    mul  \a_1_1, \t_1_0, \zetaqinv_0
    mul  \a_2_1, \t_2_0, \t_2_1
    mul  \a_3_1, \t_3_0, \t_2_1
    mulh \t_0_1, \t_0_0, \zeta_0
    mulh \t_1_1, \t_1_0, \zeta_0
    mulh \t_2_1, \t_2_0, \t_3_1
    mulh \t_3_1, \t_3_0, \t_3_1
    mulh \a_0_1, \a_0_1, \q
    mulh \a_1_1, \a_1_1, \q
    mulh \a_2_1, \a_2_1, \q
    mulh \a_3_1, \a_3_1, \q
    sub  \a_0_1, \t_0_1, \a_0_1
    sub  \a_1_1, \t_1_1, \a_1_1
    sub  \a_2_1, \t_2_1, \a_2_1
    sub  \a_3_1, \t_3_1, \a_3_1
.endm

# 3l: 3th layer
.macro gs_bfu_x4_3l_load1zeta \
    a_0_0, a_0_1, a_1_0, a_1_1, \
    a_2_0, a_2_1, a_3_0, a_3_1, \
    zeta_0, zetaqinv_0, \
    q, \
    t_0_0, t_0_1, t_1_0, t_1_1, \
    t_2_0, t_2_1, t_3_0, t_3_1
    lw   \t_2_1, 4*17(sp)
    sub  \t_0_0, \a_0_0, \a_0_1
    sub  \t_1_0, \a_1_0, \a_1_1
    sub  \t_2_0, \a_2_0, \a_2_1
    sub  \t_3_0, \a_3_0, \a_3_1
    lw   \t_3_1, \zeta_0(\t_2_1)
    lw   \t_2_1, \zetaqinv_0(\t_2_1)
    add  \a_0_0, \a_0_0, \a_0_1
    add  \a_1_0, \a_1_0, \a_1_1
    add  \a_2_0, \a_2_0, \a_2_1
    add  \a_3_0, \a_3_0, \a_3_1
    mul  \a_0_1, \t_0_0, \t_2_1
    mul  \a_1_1, \t_1_0, \t_2_1
    mul  \a_2_1, \t_2_0, \t_2_1
    mul  \a_3_1, \t_3_0, \t_2_1
    mulh \t_0_1, \t_0_0, \t_3_1
    mulh \t_1_1, \t_1_0, \t_3_1
    mulh \t_2_1, \t_2_0, \t_3_1
    mulh \t_3_1, \t_3_0, \t_3_1
    mulh \a_0_1, \a_0_1, \q
    mulh \a_1_1, \a_1_1, \q
    mulh \a_2_1, \a_2_1, \q
    mulh \a_3_1, \a_3_1, \q
    sub  \a_0_1, \t_0_1, \a_0_1
    sub  \a_1_1, \t_1_1, \a_1_1
    sub  \a_2_1, \t_2_1, \a_2_1
    sub  \a_3_1, \t_3_1, \a_3_1
.endm

# q * qinv = 1 mod 2^32, used for Montgomery arithmetic
.equ q, 3329
.equ qinv, 1806234369
# inv128 = 2^64 * (1/128) mod q is used for reverting standard domain
.equ inv128, 2208
# inv128qinv <- low(inv128*qinv)
.equ inv128qinv, 2435836064
# for barrett rdc
.equ v, 20159
# 2^32 mod q
.equ mont, 1353
# low(mont*qinv)
.equ montqinv, 4293677129

# void ntt_rv32im(int16_t in[256], const int32_t zetas[128*2]);
# register usage:
# a0-a1: in/out, zetas; a6: q; a1/a2/a3/a4/a5/a7/gp/ra: tmp
# 4*15(sp), 4*16(sp) for outer/inner loop control
# 4*17(sp) for saving a1
# t0-t6,tp: 8 coeffs; s0-s9: 5 zetas & zetas*qinv
# s10, s11: for scalar-vector hybrid programming
# strategy: 1+3+3 layers merging
.globl ntt_rv32im
.align 2
ntt_rv32im:
    addi sp, sp, -4*18
    save_regs
    li a6, q
    # load 1 zeta & zeta*qinv
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    sw a1, 4*17(sp)
    # loop control, a0+32*2=a[32], 32: loop numbers, 2: wordLen
    addi s2, a0, 32*2
ntt_rv32im_looper_1:
    load_coeffs 32, a0
    ct_bfu_x4 \
        t0, t4, t1, t5, \
        t2, t6, t3, tp, \
        s0, s1, s0, s1, \
        s0, s1, s0, s1, \
        a6, \
        a1, a2, a3, a4, \
        a5, a7, gp, ra
    store_coeffs 32, a0
    addi a0, a0, 2
    bne  s2, a0, ntt_rv32im_looper_1
    # reset a0 & update a1
    lw   a1, 4*17(sp)
    addi a0, a0, -32*2
    addi a1, a1, 4*2
    # outer loop control
    addi a5, a1, 2*4*7*2
    sw   a1, 4*17(sp)
    sw   a5, 4*15(sp)
ntt_rv32im_outer_234:
    load_5_zetas_zetasqinv
    # inner loop control
    addi a4, a0, 16*2
    sw   a4, 4*16(sp)
    ntt_rv32im_inner_234:
        load_coeffs 16, a0
        ct_bfu_x4   \
            t0, t4, t1, t5, \
            t2, t6, t3, tp, \
            s0, s1, s0, s1, \
            s0, s1, s0, s1, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        ct_bfu_x4   \
            t0, t2, t1, t3, \
            t4, t6, t5, tp, \
            s2, s3, s2, s3, \
            s4, s5, s4, s5, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        ct_bfu_x4_load2zeta   \
            t0, t1, t2, t3, \
            t4, t5, t6, tp, \
            s6, s7, s8, s9, \
            10*4, 11*4, 12*4, 13*4, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        store_coeffs 16, a0
        lw  a4, 4*16(sp)
        addi a0, a0, 2
        bne a4, a0, ntt_rv32im_inner_234
    addi a0, a0, 128*2-16*2
    lw   a1, 4*17(sp)
    lw   a5, 4*15(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    bne  a5, a1, ntt_rv32im_outer_234
    # reset a0
    addi a0, a0, -2*128*2
    # outer loop control
    addi a5, a1, 16*4*7*2
    sw   a5, 4*15(sp)
ntt_rv32im_outer_567:
    load_5_zetas_zetasqinv
    # inner loop control
    addi a4, a0, 2*2
    sw   a4, 4*16(sp)
    ntt_rv32im_inner_567:
        load_coeffs 2, a0
        ct_bfu_x4   \
            t0, t4, t1, t5, \
            t2, t6, t3, tp, \
            s0, s1, s0, s1, \
            s0, s1, s0, s1, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        ct_bfu_x4   \
            t0, t2, t1, t3, \
            t4, t6, t5, tp, \
            s2, s3, s2, s3, \
            s4, s5, s4, s5, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        ct_bfu_x4_load2zeta   \
            t0, t1, t2, t3, \
            t4, t5, t6, tp, \
            s6, s7, s8, s9, \
            10*4, 11*4, 12*4, 13*4, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        store_coeffs 2, a0
        lw   a4, 4*16(sp)
        addi a0, a0, 2
        bne  a4, a0, ntt_rv32im_inner_567
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    lw   a5, 4*15(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    bne  a5, a1, ntt_rv32im_outer_567
    restore_regs
    addi sp, sp, 4*18
    ret

# void intt_rv32im(int16_t in[256], const int32_t zetas[128*2]);
# register usage: 
# a0-a1: in/out, zetas; a6: q; a1/a2/a3/a4/a5/a7/gp/ra: tmp
# 4*15(sp), 4*16(sp) for outer/inner loop control
# 4*17(sp) for saving a1
# t0-t6,tp: 8 coeffs; s0-s9: 5 zetas & zetas*qinv
# s10,s11: for scalar-vector hybrid programming
# strategy: 3+3+1 layers merging
.globl intt_rv32im
.align 2
intt_rv32im:
    addi sp, sp, -4*18
    save_regs
    li a6, q
    # outer loop control
    addi a5, a1, 16*4*7*2
    sw   a5, 4*15(sp)
    sw   a1, 4*17(sp)
intt_rv32im_outer_123:
    load_5_zetas_zetasqinv
    # inner loop control
    addi a4, a0, 2*2
    sw   a4, 4*16(sp)
    intt_rv32im_inner_123:
        load_coeffs 2, a0
        gs_bfu_x4   \
            t0, t1, t2, t3, \
            t4, t5, t6, tp, \
            s0, s1, s2, s3, \
            s4, s5, s6, s7, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        gs_bfu_x4_2l_load1zeta \
            t0, t2, t1, t3, \
            t4, t6, t5, tp, \
            s8, s9,         \
            10*4, 11*4,     \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        gs_bfu_x4_3l_load1zeta \
            t0, t4, t1, t5, \
            t2, t6, t3, tp, \
            12*4, 13*4, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        li  a4, inv128
        li  a5, inv128qinv
        montmul_inplace_x4  \
            t0, t1, t2, t3, \
            a4, a5, a6,     \
            a7, gp, ra, a3
        store_coeffs 2, a0
        lw   a4, 4*16(sp)
        addi a0, a0, 2
        bne a4, a0, intt_rv32im_inner_123
    addi a0, a0, 16*2-2*2
    lw   a1, 4*17(sp)
    lw   a5, 4*15(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    bne  a5, a1, intt_rv32im_outer_123
    # reset a0
    addi a0, a0, -16*16*2
    # 456 merging - first outer loop
    load_5_zetas_zetasqinv
    # inner loop control
    addi a4, a0, 16*2
    sw   a4, 4*16(sp)
    intt_rv32im_inner_456_0:
        load_coeffs 16, a0
        gs_bfu_x4   \
            t0, t1, t2, t3, \
            t4, t5, t6, tp, \
            s0, s1, s2, s3, \
            s4, s5, s6, s7, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        gs_bfu_x4_2l_load1zeta \
            t0, t2, t1, t3, \
            t4, t6, t5, tp, \
            s8, s9,         \
            10*4, 11*4,     \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        gs_bfu_x4_3l_load1zeta \
            t0, t4, t1, t5, \
            t2, t6, t3, tp, \
            12*4, 13*4, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        # we use montmul for reduction because montmul is more pipeline-friendly than barrett rdc
        li  a4, mont
        li  a5, montqinv
        montmul_inplace t0, a4, a5, a6, gp
        store_coeffs 16, a0
        lw   a4, 4*16(sp)
        addi a0, a0, 2
        bne  a4, a0, intt_rv32im_inner_456_0
    addi a0, a0, 128*2-16*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    # 456 merging - second outer loop
    load_5_zetas_zetasqinv
    # inner loop control
    addi a4, a0, 16*2
    sw   a4, 4*16(sp)
    intt_rv32im_inner_456_1:
        load_coeffs 16, a0
        gs_bfu_x4   \
            t0, t1, t2, t3, \
            t4, t5, t6, tp, \
            s0, s1, s2, s3, \
            s4, s5, s6, s7, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        gs_bfu_x4_2l_load1zeta \
            t0, t2, t1, t3, \
            t4, t6, t5, tp, \
            s8, s9,         \
            10*4, 11*4,     \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        gs_bfu_x4_3l_load1zeta \
            t0, t4, t1, t5, \
            t2, t6, t3, tp, \
            12*4, 13*4, \
            a6, \
            a1, a2, a3, a4, \
            a5, a7, gp, ra
        store_coeffs 16, a0
        lw   a4, 4*16(sp)
        addi a0, a0, 2
        bne  a4, a0, intt_rv32im_inner_456_1
    addi a0, a0, 128*2-16*2
    lw   a1, 4*17(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    # reset a0
    addi a0, a0, -2*128*2
    # load 1 zeta & zeta*qinv
    lh s0, 0*4(a1);     lw s1, 1*4(a1)
    # loop control
    addi s2, a0, 32*2
intt_rv32im_looper_7:
    load_coeffs 32, a0
    gs_bfu_x4 \
        t0, t4, t1, t5, \
        t2, t6, t3, tp, \
        s0, s1, s0, s1, \
        s0, s1, s0, s1, \
        a6, \
        a1, a2, a3, a4, \
        a5, a7, gp, ra
    store_coeffs 32, a0
    addi a0, a0, 2
    bne  s2, a0, intt_rv32im_looper_7
    restore_regs
    addi sp, sp, 4*18
    ret