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
    lw t0, \len*4*0(\poly)
    lw t1, \len*4*1(\poly)
    lw t2, \len*4*2(\poly)
    lw t3, \len*4*3(\poly)
    lw t4, \len*4*4(\poly)
    lw t5, \len*4*5(\poly)
    lw t6, \len*4*6(\poly)
    lw tp, \len*4*7(\poly)
.endm

.macro store_coeffs len, poly
    sw t0, \len*4*0(\poly)
    sw t1, \len*4*1(\poly)
    sw t2, \len*4*2(\poly)
    sw t3, \len*4*3(\poly)
    sw t4, \len*4*4(\poly)
    sw t5, \len*4*5(\poly)
    sw t6, \len*4*6(\poly)
    sw tp, \len*4*7(\poly)
.endm

.macro load_zetas_zetasqinv
    lw s0, 0*4(a1);     lw s1, 1*4(a1)
    lw s2, 2*4(a1);     lw s3, 3*4(a1)
    lw s4, 4*4(a1);     lw s5, 5*4(a1)
    lw s6, 6*4(a1);     lw s7, 7*4(a1)
    lw s8, 8*4(a1);     lw s9, 9*4(a1)
    lw s10, 10*4(a1);   lw s11, 11*4(a1)
    lw gp,  12*4(a1);   lw ra,  13*4(a1)
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

.macro montmul_x2 \
        r_0, r_1, \
        a_0, a_1, \
        b_0, bqinv_0, \
        b_1, bqinv_1, \
        q, \
        t_0, t_1
    mul  \r_0, \a_0, \bqinv_0
    mul  \r_1, \a_1, \bqinv_1
    mulh \t_0, \a_0, \b_0
    mulh \t_1, \a_1, \b_1
    mulh \r_0, \r_0, \q
    mulh \r_1, \r_1, \q
    sub  \r_0, \t_0, \r_0
    sub  \r_1, \t_1, \r_1
.endm

.macro montmul_x3 \
        r_0, r_1, r_2 \
        a_0, a_1, a_2 \
        b_0, bqinv_0, \
        b_1, bqinv_1, \
        b_2, bqinv_2, \
        q, \
        t_0, t_1, t_2 
    mul  \r_0, \a_0, \bqinv_0
    mul  \r_1, \a_1, \bqinv_1
    mul  \r_2, \a_2, \bqinv_2
    mulh \t_0, \a_0, \b_0
    mulh \t_1, \a_1, \b_1
    mulh \t_2, \a_2, \b_2
    mulh \r_0, \r_0, \q
    mulh \r_1, \r_1, \q
    mulh \r_2, \r_2, \q
    sub  \r_0, \t_0, \r_0
    sub  \r_1, \t_1, \r_1
    sub  \r_2, \t_2, \r_2
.endm

.macro montmul_inplace a_0, zeta, zetaqinv, q, t_0
    mul  \t_0, \a_0, \zetaqinv
    mulh \a_0, \a_0, \zeta
    mulh \t_0, \t_0, \q
    sub  \a_0, \a_0, \t_0
.endm

.macro montmul_inplace_x4 \
        a_0, a_1, a_2, a_3, \
        zeta, zetaqinv, \
        q, t_0, t_1, t_2
    mul  \t_0, \a_0, \zetaqinv
    mul  \t_1, \a_1, \zetaqinv
    mul  \t_2, \a_2, \zetaqinv
    mul  \zetaqinv, \a_3, \zetaqinv
    mulh \a_0, \a_0, \zeta
    mulh \a_1, \a_1, \zeta
    mulh \a_2, \a_2, \zeta
    mulh \a_3, \a_3, \zeta
    mulh \t_0, \t_0, \q
    mulh \t_1, \t_1, \q
    mulh \t_2, \t_2, \q
    mulh \zetaqinv, \zetaqinv, \q
    sub  \a_0, \a_0, \t_0
    sub  \a_1, \a_1, \t_1
    sub  \a_2, \a_2, \t_2
    sub  \a_3, \a_3, \zetaqinv
.endm

.macro montrdc r_0, ch_0, cl_0, q, qinv
    mul  \r_0, \cl_0, \qinv
    mulh \r_0, \r_0, \q
    sub  \r_0, \ch_0, \r_0
.endm

.macro montrdc_x2 \
    r_0, r_1, \
    ch_0, cl_0, ch_1, cl_1, \
    q, qinv
    mul  \r_0, \cl_0, \qinv
    mul  \r_1, \cl_1, \qinv
    mulh \r_0, \r_0, \q
    mulh \r_1, \r_1, \q
    sub  \r_0, \ch_0, \r_0
    sub  \r_1, \ch_1, \r_1
.endm

# .macro ct_bfu in0, in1, zeta, zetaqinv, q, tmp0, tmp1
#     montmul \tmp0, \in1, \zeta, \zetaqinv, \q, \tmp1
#     sub \in1, \in0, \tmp0
#     add \in0, \in0, \tmp0
# .endm

.macro ct_bfu in0_0, in0_1, zeta0, zetaqinv0, q, tm0_0, tm0_1
    mul  \tm0_0, \in0_1, \zetaqinv0
    mulh \tm0_1, \in0_1, \zeta0
    mulh \tm0_0, \tm0_0, \q
    sub  \tm0_0, \tm0_1, \tm0_0
    sub  \in0_1, \in0_0, \tm0_0
    add  \in0_0, \in0_0, \tm0_0
.endm

.macro ct_bfu_x2 \
        in0_0, in0_1, in1_0, in1_1, \
        zeta0, zetaqinv0, zeta1, zetaqinv1, \
        q, \
        tm0_0, tm0_1, tm1_0, tm1_1
    mul  \tm0_0, \in0_1, \zetaqinv0
    mul  \tm1_0, \in1_1, \zetaqinv1
    mulh \tm0_1, \in0_1, \zeta0
    mulh \tm1_1, \in1_1, \zeta1
    mulh \tm0_0, \tm0_0, \q
    mulh \tm1_0, \tm1_0, \q
    sub  \tm0_0, \tm0_1, \tm0_0
    sub  \tm1_0, \tm1_1, \tm1_0
    sub  \in0_1, \in0_0, \tm0_0
    sub  \in1_1, \in1_0, \tm1_0
    add  \in0_0, \in0_0, \tm0_0
    add  \in1_0, \in1_0, \tm1_0
.endm

.macro ct_bfu_x4 \
        a_0_0, a_0_1, a_1_0, a_1_1, \
        a_2_0, a_2_1, a_3_0, a_3_1, \
        zeta0, zetaqinv0, zeta1, zetaqinv1, \
        zeta2, zetaqinv2, zeta3, zetaqinv3, \
        q, \
        t_0_0, t_0_1, t_1_0, t_1_1, \
        t_2_0, t_3_0
    mul  \t_0_0, \a_0_1, \zetaqinv0
    mul  \t_1_0, \a_1_1, \zetaqinv1
    mul  \t_2_0, \a_2_1, \zetaqinv2
    mul  \t_3_0, \a_3_1, \zetaqinv3
    mulh \t_0_1, \a_0_1, \zeta0
    mulh \t_0_0, \t_0_0, \q
    mulh \t_1_0, \t_1_0, \q
    mulh \t_2_0, \t_2_0, \q
    mulh \t_3_0, \t_3_0, \q
    sub  \t_0_0, \t_0_1, \t_0_0
    mulh \t_0_1, \a_1_1, \zeta1
    sub  \a_0_1, \a_0_0, \t_0_0
    add  \a_0_0, \a_0_0, \t_0_0
    mulh \t_1_1, \a_2_1, \zeta2
    sub  \t_1_0, \t_0_1, \t_1_0
    sub  \a_1_1, \a_1_0, \t_1_0
    add  \a_1_0, \a_1_0, \t_1_0
    mulh \t_0_1, \a_3_1, \zeta3
    sub  \t_2_0, \t_1_1, \t_2_0
    sub  \a_2_1, \a_2_0, \t_2_0
    add  \a_2_0, \a_2_0, \t_2_0
    sub  \t_3_0, \t_0_1, \t_3_0
    sub  \a_3_1, \a_3_0, \t_3_0
    add  \a_3_0, \a_3_0, \t_3_0
.endm

# .macro gs_bfu in0, in1, zeta, zetaqinv, q, tmp0, tmp1
#     sub \tmp0, \in0, \in1
#     add \in0, \in0, \in1
#     montmul \in1, \tmp0, \zeta, \zetaqinv, \q, \tmp1
# .endm

.macro gs_bfu in0_0, in0_1, zeta0, zetaqinv0, q, tm0_0, tm0_1
    sub  \tm0_0, \in0_0, \in0_1
    add  \in0_0, \in0_0, \in0_1
    mul  \in0_1, \tm0_0, \zetaqinv0
    mulh \tm0_1, \tm0_0, \zeta0
    mulh \in0_1, \in0_1, \q
    sub  \in0_1, \tm0_1, \in0_1
.endm

.macro gs_bfu_x2 \
        in0_0, in0_1, in1_0, in1_1, \
        zeta0, zetaqinv0, zeta1, zetaqinv1, \
        q, \
        tm0_0, tm0_1, tm1_0, tm1_1
    sub  \tm0_0, \in0_0, \in0_1
    sub  \tm1_0, \in1_0, \in1_1
    add  \in0_0, \in0_0, \in0_1
    add  \in1_0, \in1_0, \in1_1
    mul  \in0_1, \tm0_0, \zetaqinv0
    mul  \in1_1, \tm1_0, \zetaqinv1
    mulh \tm0_1, \tm0_0, \zeta0
    mulh \tm1_1, \tm1_0, \zeta1
    mulh \in0_1, \in0_1, \q
    mulh \in1_1, \in1_1, \q
    sub  \in0_1, \tm0_1, \in0_1
    sub  \in1_1, \tm1_1, \in1_1
.endm

.macro gs_bfu_x4 \
        a_0_0, a_0_1, a_1_0, a_1_1, \
        a_2_0, a_2_1, a_3_0, a_3_1, \
        zeta0, zetaqinv0, zeta1, zetaqinv1, \
        zeta2, zetaqinv2, zeta3, zetaqinv3, \
        q, \
        t_0_0, t_1_0, t_2_0, t_3_0
    sub  \t_0_0, \a_0_0, \a_0_1
    sub  \t_1_0, \a_1_0, \a_1_1
    sub  \t_2_0, \a_2_0, \a_2_1
    add  \a_0_0, \a_0_0, \a_0_1
    add  \a_1_0, \a_1_0, \a_1_1
    sub  \t_3_0, \a_3_0, \a_3_1
    add  \a_2_0, \a_2_0, \a_2_1
    add  \a_3_0, \a_3_0, \a_3_1
    mul  \a_0_1, \t_0_0, \zetaqinv0
    mul  \a_1_1, \t_1_0, \zetaqinv1
    mul  \a_2_1, \t_2_0, \zetaqinv2
    mul  \a_3_1, \t_3_0, \zetaqinv3
    mulh \t_0_0, \t_0_0, \zeta0
    mulh \t_1_0, \t_1_0, \zeta1
    mulh \t_2_0, \t_2_0, \zeta2
    mulh \t_3_0, \t_3_0, \zeta3
    mulh \a_0_1, \a_0_1, \q
    mulh \a_1_1, \a_1_1, \q
    mulh \a_2_1, \a_2_1, \q
    mulh \a_3_1, \a_3_1, \q
    sub  \a_0_1, \t_0_0, \a_0_1
    sub  \a_1_1, \t_1_0, \a_1_1
    sub  \a_2_1, \t_2_0, \a_2_1
    sub  \a_3_1, \t_3_0, \a_3_1
.endm

.macro mul64 hi, lo, in1, in2
    mul  \lo, \in1, \in2
    mulh \hi, \in1, \in2
.endm

.macro add64 oh, ol, ih, il
    add  \ol, \ol, \il
    sltu \il, \ol, \il
    add  \oh, \oh, \ih
    add  \oh, \oh, \il
.endm

.macro lw64 oh, ol, off, poly
    lw \ol, \off(\poly)
    lw \oh, \off+4(\poly)
.endm

.macro sw64 ih, il, off, poly
    sw \il, \off(\poly)
    sw \ih, \off+4(\poly)
.endm

# q * qinv = 1 mod 2^32, used for Montgomery arithmetic
.equ q, 8380417
.equ qinv, 58728449
# v = ??? (((int64_t)1 << 48) + M / 2) / M is used for barrett reduce
# .equ V, ???
# inv64 = 2^64 * (1/64) mod q is used for reverting standard domain
.equ inv64, 167912
# inv64qinv <- low(inv64*qinv)
.equ inv64qinv, 4261384168
# q/2
.equ q_div2, 4190208

# void ntt_6l_rv32im(int32_t in[256], const int32_t zetas[64*2]);
# register usage:
# a0-a1: in/out, zetas; a6: q; a1/a2/a3/a4/a5/a7: tmp
# 4*15(sp), 4*16(sp) for outer/inner loop control
# 4*17(sp) for saving a1
# t0-t6,tp: 8 coeffs; s0-s11, gp, ra: 7 zetas & zetas*qinv
.globl ntt_6l_rv32im
.align 2
ntt_6l_rv32im:
    addi sp, sp, -4*18
    save_regs
    li a6, q
    load_zetas_zetasqinv
    sw   a1, 4*17(sp)
    # loop control, a0+32*4=a[32], 32: loop numbers, 4: wordLen
    addi a4, a0, 32*4
    sw   a4, 4*15(sp)
# 123 layers merging
ntt_6l_rv32im_looper_123:
    load_coeffs 32, a0
    ct_bfu_x4 \
            t0, t4, t1, t5, t2, t6, t3, tp, \
            s0, s1, s0, s1, s0, s1, s0, s1, \
            a6, a1, a2, a3, a4, a5, a7
    ct_bfu_x4 \
        t0, t2, t1, t3, t4, t6, t5, tp, \
        s2, s3, s2, s3, s4, s5, s4, s5, \
        a6, a1, a2, a3, a4, a5, a7
    ct_bfu_x4 \
        t0, t1, t2, t3, t4, t5, t6, tp, \
        s6, s7, s8, s9, s10,s11, gp, ra,\
        a6, a1, a2, a3, a4, a5, a7
    store_coeffs 32, a0
    lw  a4, 4*15(sp)
    addi a0, a0, 4
    bne a4, a0, ntt_6l_rv32im_looper_123
    lw   a1, 4*17(sp)
# ============== level 4-6 ============== #
# reset a0, 32: previous loop number, 4: wordLen
addi a0, a0, -32*4
# a1 points to next 7 zetas & 7 zetasqinv
addi a1, a1, 4*7*2
# set outer loop control register a5, 8: outer loop number
addi a5, a1, 8*4*7*2
sw   a1, 4*17(sp)
sw   a5, 4*15(sp)
ntt_6l_rv32im_outer_456:
    load_zetas_zetasqinv
    # set looper control register a4, inner loop's increment is 4 words
    addi a4, a0, 4*4
    sw   a4, 4*16(sp)
    ntt_6l_rv32im_inner_456:
        load_coeffs 4, a0
        ct_bfu_x4 \
            t0, t4, t1, t5, t2, t6, t3, tp, \
            s0, s1, s0, s1, s0, s1, s0, s1, \
            a6, a1, a2, a3, a4, a5, a7
        ct_bfu_x4 \
            t0, t2, t1, t3, t4, t6, t5, tp, \
            s2, s3, s2, s3, s4, s5, s4, s5, \
            a6, a1, a2, a3, a4, a5, a7
        ct_bfu_x4 \
            t0, t1, t2, t3, t4, t5, t6, tp, \
            s6, s7, s8, s9, s10,s11, gp, ra,\
            a6, a1, a2, a3, a4, a5, a7
        store_coeffs 4, a0
        lw  a4, 4*16(sp)
        addi a0, a0, 4
        bne a4, a0, ntt_6l_rv32im_inner_456
    # a0 points to next block, a1 points to next 7 zetas & 7 zetasqinv
    # each block has 32 words, inner loop's increment is 4 words
    addi a0, a0, 32*4-4*4
    lw   a1, 4*17(sp)
    lw   a5, 4*15(sp)
    addi a1, a1, 4*7*2
    sw   a1, 4*17(sp)
    bne  a5, a1, ntt_6l_rv32im_outer_456
    restore_regs
    addi sp, sp, 4*18
    ret

# void intt_6l_rv32im(int32_t in[256], const int32_t zetas[64*2]);
# register usage: 
# a0-a1: in/out, zetas; a6: q; a4: looper control; a2/a3/a5/a7: tmp
# 4*15(sp) for loop control
# t0-t6,tp: 8 coeffs; s0-s11, gp, ra: 7 zetas & zetas*qinv
.globl intt_6l_rv32im
.align 2
intt_6l_rv32im:
    addi sp, sp, -4*16
    save_regs
# 8: outer loop number
addi a5, a1, 8*4*7*2
sw   a5, 4*15(sp)
li a6, q
intt_6l_rv32im_outer_123:
    load_zetas_zetasqinv
    addi a4, a0, 4*4
    intt_6l_rv32im_inner_123:
        load_coeffs 4, a0
        gs_bfu_x4 \
            t0, t1, t2, t3, t4, t5, t6, tp, \
            s0, s1, s2, s3, s4, s5, s6, s7, \
            a6, a2, a3, a5, a7
        gs_bfu_x4 \
            t0, t2, t1, t3, t4, t6, t5, tp, \
            s8, s9, s8, s9, s10,s11, s10,s11,\
            a6, a2, a3, a5, a7
        gs_bfu_x4 \
            t0, t4, t1, t5, t2, t6, t3, tp, \
            gp, ra, gp, ra, gp, ra, gp, ra, \
            a6, a2, a3, a5, a7
        store_coeffs 4, a0
        addi a0, a0, 4
        bne a4, a0, intt_6l_rv32im_inner_123
    # a0 points to next block, a1 points to next 7 zetas & 7 zetasqinv
    # each block has 32 words, inner loop's increment is 4 words
    lw   a5, 4*15(sp)
    addi a0, a0, 32*4-4*4
    addi a1, a1, 4*7*2
    bne  a5, a1, intt_6l_rv32im_outer_123
    # reset a0
    addi a0, a0, -8*32*4
    # loop control, 32: loop numbers, 4: wordLen
    addi a4, a0, 32*4
    load_zetas_zetasqinv
# 456 layers
intt_6l_rv32im_looper_456:
    load_coeffs 32, a0
    gs_bfu_x4 \
        t0, t1, t2, t3, t4, t5, t6, tp, \
        s0, s1, s2, s3, s4, s5, s6, s7, \
        a6, a2, a3, a5, a7
    gs_bfu_x4 \
        t0, t2, t1, t3, t4, t6, t5, tp, \
        s8, s9, s8, s9, s10,s11, s10,s11,\
        a6, a2, a3, a5, a7
    gs_bfu_x4 \
        t0, t4, t1, t5, t2, t6, t3, tp, \
        gp, ra, gp, ra, gp, ra, gp, ra, \
        a6, a2, a3, a5, a7
    sw a4, 4*15(sp)
    # revert to standard domain
    li a7, inv64
    li a5, inv64qinv
    montmul_inplace_x4 \
        t0, t1, t2, t3, \
        a7, a5, a6, a2, a3, a4
    store_coeffs 32, a0
    lw a4, 4*15(sp)
    addi a0, a0, 4
    bne a0, a4, intt_6l_rv32im_looper_456
    restore_regs
    addi sp, sp, 4*16
    ret

# void poly_basemul_6l_cache_init_rv32im(
#   int32_t r[256], const int32_t a[256], 
#   const int32_t b[256], int32_t b_cache[192],
#   int32_t zetas[32*2])
# register usage: 
# a0-a4: in/out, zetas; a6/a7: q/qinv; s11: looper control
# t0-t6,tp: 8 coeffs; gp, ra: zeta + zeta*qinv
# s0-s10: tmp
.globl poly_basemul_6l_cache_init_rv32im
.align 2
poly_basemul_6l_cache_init_rv32im:
    addi sp, sp, -4*15
    save_regs
    li a6, q
    li a7, qinv
    # loop counter
    li s11, 0
poly_basemul_6l_cache_init_rv32im_base_looper:
    lw t0, 0*4(a1) # a0
    lw t1, 1*4(a1) # a1
    lw t2, 2*4(a1) # a2
    lw t3, 3*4(a1) # a3
    lw t4, 0*4(a2) # b0
    lw t5, 1*4(a2) # b1
    lw t6, 2*4(a2) # b2
    lw tp, 3*4(a2) # b3
    lw gp, 0*4(a4)
    lw ra, 1*4(a4)
    andi s10, s11, 1
    beq  s10, zero, poly_basemul_6l_cache_init_rv32im_update_zeta_index_end
poly_basemul_6l_cache_init_rv32im_update_zeta_index:
    neg  gp, gp
    neg  ra, ra
    addi a4, a4, 4*2
poly_basemul_6l_cache_init_rv32im_update_zeta_index_end:
    // r0=a0b0+zeta*b3*a1+zeta*b2*a2+zeta*b1*a3
    montmul_x3 \
        s0, s1, s2, \
        tp, t6, t5, \
        gp, ra, gp, ra, gp, ra, \
        a6, \
        s10, s4, s3
    sw s0, 0*4(a3) # zeta*b3
    mul64 s8, s7, s0, t1
    sw s1, 1*4(a3) # zeta*b2
    sw s2, 2*4(a3) # zeta*b1
    mul64 s6, s5, s1, t2
    mul64 s4, s3, s2, t3
    add64 s8, s7, s6, s5
    mul64 s6, s5, t0, t4
    add64 s8, s7, s4, s3
    add64 s8, s7, s6, s5
    // r1=a0b1+a1b0+zeta*b3*a2+zeta*b2*a3
    mul64 s10, s9, s0, t2
    mul64 s6, s5, s1, t3
    mul64 s4, s3, t0, t5
    add64 s10, s9, s6, s5
    mul64 s6, s5, t1, t4
    add64 s10, s9, s4, s3
    add64 s10, s9, s6, s5
    montrdc_x2 \
        s5, s6, s8, s7, s10, s9, a6, a7
    sw s5, 0*4(a0)
    sw s6, 1*4(a0)
    // r2=a0b2+a1b1+a2b0+zeta*b3*a3
    mul64 s8, s7, s0, t3
    mul64 s6, s5, t0, t6
    mul64 s4, s3, t1, t5
    add64 s8, s7, s6, s5
    mul64 s6, s5, t2, t4
    add64 s8, s7, s4, s3
    add64 s8, s7, s6, s5
    // r3=a0b3+a1b2+a2b1+a3b0
    mul64 s10, s9, t0, tp
    mul64 s6, s5, t1, t6
    mul64 s4, s3, t2, t5
    add64 s10, s9, s6, s5
    mul64 s6, s5, t3, t4
    add64 s10, s9, s4, s3
    add64 s10, s9, s6, s5
    montrdc_x2 \
        s5, s6, s8, s7, s10, s9, a6, a7
    sw s5, 2*4(a0)
    sw s6, 3*4(a0)
    addi a0, a0, 4*4
    addi a1, a1, 4*4
    addi a2, a2, 4*4
    addi a3, a3, 4*3
    li s9, 64
    addi s11, s11, 1
    bne s9, s11, poly_basemul_6l_cache_init_rv32im_base_looper
    restore_regs
    addi sp, sp, 4*15
    ret

# void poly_basemul_6l_cached_rv32im(
#   int32_t r[256], const int32_t a[256], 
#   const int32_t b[256], int32_t b_cache[192])
# register usage: 
# a0-a4: in/out, zetas; a6/a7: q/qinv; s9/s11: looper control; a5: tmp
# t0-t6,tp: 8 coeffs
# s0-s10, gp, ra: tmp
.globl poly_basemul_6l_cached_rv32im
.align 2
poly_basemul_6l_cached_rv32im:
    addi sp, sp, -4*15
    save_regs
    li a6, q
    li a7, qinv
    # loop counter
    li s11, 0
poly_basemul_6l_cached_rv32im_base_looper:
    lw t0, 0*4(a1) # a0
    lw t1, 1*4(a1) # a1
    lw t2, 2*4(a1) # a2
    lw t3, 3*4(a1) # a3
    lw t4, 0*4(a2) # b0
    lw t5, 1*4(a2) # b1
    lw t6, 2*4(a2) # b2
    lw tp, 3*4(a2) # b3
    lw s0, 0*4(a3) # zeta*b3
    lw s1, 1*4(a3) # zeta*b2
    lw s2, 2*4(a3) # zeta*b1
    // r0=a0b0+zeta*b3*a1+zeta*b2*a2+zeta*b1*a3
    mul64 s8, s7, s0, t1
    mul64 s6, s5, s1, t2
    mul64 s4, s3, s2, t3
    add64 s8, s7, s6, s5
    mul64 s6, s5, t0, t4
    add64 s8, s7, s4, s3
    add64 s8, s7, s6, s5
    // r1=a0b1+a1b0+zeta*b3*a2+zeta*b2*a3
    mul64 s10, s9, s0, t2
    mul64 s6, s5, s1, t3
    mul64 s4, s3, t0, t5
    add64 s10, s9, s6, s5
    mul64 s6, s5, t1, t4
    add64 s10, s9, s4, s3
    add64 s10, s9, s6, s5
    montrdc_x2 \
        s5, s6, s8, s7, s10, s9, a6, a7
    sw s5, 0*4(a0)
    sw s6, 1*4(a0)
    // r2=a0b2+a1b1+a2b0+zeta*b3*a3
    mul64 s8, s7, s0, t3
    mul64 s6, s5, t0, t6
    mul64 s4, s3, t1, t5
    add64 s8, s7, s6, s5
    mul64 s6, s5, t2, t4
    add64 s8, s7, s4, s3
    add64 s8, s7, s6, s5
    // r3=a0b3+a1b2+a2b1+a3b0
    mul64 s10, s9, t0, tp
    mul64 s6, s5, t1, t6
    mul64 s4, s3, t2, t5
    add64 s10, s9, s6, s5
    mul64 s6, s5, t3, t4
    add64 s10, s9, s4, s3
    add64 s10, s9, s6, s5
    montrdc_x2 \
        s5, s6, s8, s7, s10, s9, a6, a7
    sw s5, 2*4(a0)
    sw s6, 3*4(a0)
    addi a0, a0, 4*4
    addi a1, a1, 4*4
    addi a2, a2, 4*4
    addi a3, a3, 4*3
    li s9, 64
    addi s11, s11, 1
    bne s9, s11, poly_basemul_6l_cached_rv32im_base_looper
    restore_regs
    addi sp, sp, 4*15
    ret
