.text

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
    mul  \r, \a, \binv
    mulh \r, \r, \q
    mulh \t, \a, \b
    sub  \r, \t, \r
.endm

# a will be overwritten
.macro montmul_inplace r, a, b, bqinv, q
    mul  \r, \a, \binv
    mulh \r, \r, \q
    mulh \a, \a, \b
    sub  \r, \a, \r
.endm

.macro montrdc r, cl, ch, q, qinv
    mul  \r, \cl, \qinv
    mulh \r, \r, \q
    sub  \r, \ch, \r
.endm

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

# int64_t a=in1*in2
# int32_t t=a*Mprime
# t=((int64_t)a-(int64_t)t*M)>>32
# in1 will be overwritten, in2 will not be overwritten
.macro MontMulNew in1, in2, out, CM, CMprime
    # out=low(in1*in2)=aLo
    mul \out, \in1, \in2
    # aLo=aLo*M'
    mul \out, \out, \CMprime
    # aLo=aLo*M, only high-libm is needed
    mulh \out, \out, \CM
    # in1=high(in1*in2)=aHi
    mulh \in1, \in1, \in2
    # out=aHi-aLo
    sub \out, \in1, \out
.endm

# int64_t a=inHi&&inLo
# inHi and inLo wille be rewrited
# t=(a mod R)*M' mod R, a=(a-t*M)/R
.macro MontReduce inLo, inHi, out, CM, CMprime
    # inLo=inLo*M'
    mul \inLo, \inLo, \CMprime
    # inLo=inLo*M only high-limb is needed, because the low-limb is same
    mulh \inLo, \inLo, \CM
    # out=inHi-inLo
    sub \out, \inHi, \inLo
.endm

# input: int32_t a
# int32_t t=((int64_t)v * a + ((int64_t)1 << 47)) >> 48
# return a-t*M;
.macro BarrettReduce in, out, tmp1
    # tmp1=V
    li \tmp1, V
    # tmp1=high(v*a)
    mulh \tmp1, \tmp1, \in
    # out=(1<<47)>>32=1<<15, 15=12+3
    lui \out, 0x8
    # (v*a+1<<47)>>32
    add \out, \out, \tmp1
    # (v*a+1<<47)>>48
    srai \out, \out, 0x10
    # t*M
    li \tmp1, M
    mul \out, \out, \tmp1
    # a-t*M
    sub \out, \in, \out
.endm

# Butterfly Unit for NTT
# in1, in2: t=zeta*in2, in2=in1-t; in1=in1+t;
.macro BFU in1, in2, zeta, CM, CMprime, tmp1
    # tmp1=zeta*in1
    MontMulNew \in2, \zeta, \tmp1, \CM, \CMprime
    # in2=in1-t
    sub \in2, \in1, \tmp1
    # in1=in1+t
    add \in1, \in1, \tmp1
.endm

# Butterfly Unit for INTT
# in1, in2: t=in1-in2, in1=in1+in2, in2=t*zeta
.macro BFUINTT in1, in2, zeta, CM, CMprime, tmp1
    sub \tmp1, \in1, \in2
    add \in1, \in1, \in2
    MontMulNew \tmp1, \zeta, \in2, \CM, \CMprime
.endm

# int32_t mask;
# mask = (a + M / 2) >> 31;
# a += mask & M;
# mask = a - M / 2;
# mask = (mask >> 31) & 0x1;
# mask = mask - 1;
# a -= mask & M;
.macro CenReduce in, out, CM, CMDiv2, tmp1
    # tmp1=in+M/2
    add \tmp1, \in, \CMDiv2
    # tmp1>>31 : 0xffff_ffff or 0
    srai \tmp1, \tmp1, 0x1f
    # tmp1=tmp1 & M
    and \tmp1, \tmp1, \CM
    # in=in+tmp1
    add \in, \in, \tmp1
    # tmp1=in-M/2
    sub \tmp1, \in, \CMDiv2
    # tmp1>>31 : 0 or 1
    srli \tmp1, \tmp1, 0x1f
    # tmp1 = tmp1 - 1 : 0xffff_ffff or 0
    addi \tmp1, \tmp1, -1
    # tmp1=tmp1&M
    and \tmp1, \tmp1, \CM
    # out=in-tmp1
    sub \out, \in, \tmp1
.endm

# revert to Standard domain and reduce to Centered representation
# s0-s7: 8 coefficients, a3: NINV, s8-s9: temp
# a6-a7: M, Mprime, s10: MDiv2
.macro SCReduce CNINV, CM, CMprime, CMDiv2, tmp1, tmp2
    # reduce s0
    MontMulNew s0, \CNINV, \tmp1, \CM, \CMprime
    CenReduce \tmp1, s0, \CM, \CMDiv2, \tmp2
    # reduce s1
    MontMulNew s1, \CNINV, \tmp1, \CM, \CMprime
    CenReduce \tmp1, s1, \CM, \CMDiv2, \tmp2
    # reduce s2
    MontMulNew s2, \CNINV, \tmp1, \CM, \CMprime
    CenReduce \tmp1, s2, \CM, \CMDiv2, \tmp2
    # reduce s3
    MontMulNew s3, \CNINV, \tmp1, \CM, \CMprime
    CenReduce \tmp1, s3, \CM, \CMDiv2, \tmp2
    # reduce s4
    CenReduce s4, s4, \CM, \CMDiv2, \tmp2
    # reduce s5
    CenReduce s5, s5, \CM, \CMDiv2, \tmp2
    # reduce s6
    CenReduce s6, s6, \CM, \CMDiv2, \tmp2
    # reduce s7
    CenReduce s7, s7, \CM, \CMDiv2, \tmp2
.endm

.macro LoadZetas
    # t0-t6 save 7 zetas
    lw t0, 0*4(a2)
    lw t1, 1*4(a2)
    lw t2, 2*4(a2)
    lw t3, 3*4(a2)
    lw t4, 4*4(a2)
    lw t5, 5*4(a2)
    lw t6, 6*4(a2)
.endm

.macro LoadS hw, len, wordLen, reg
    l\hw s0, \len*\wordLen*0(\reg)
    l\hw s1, \len*\wordLen*1(\reg)
    l\hw s2, \len*\wordLen*2(\reg)
    l\hw s3, \len*\wordLen*3(\reg)
    l\hw s4, \len*\wordLen*4(\reg)
    l\hw s5, \len*\wordLen*5(\reg)
    l\hw s6, \len*\wordLen*6(\reg)
    l\hw s7, \len*\wordLen*7(\reg)
.endm

.macro StoreS len, reg
    sw s0, \len*4*0(\reg)
    sw s1, \len*4*1(\reg)
    sw s2, \len*4*2(\reg)
    sw s3, \len*4*3(\reg)
    sw s4, \len*4*4(\reg)
    sw s5, \len*4*5(\reg)
    sw s6, \len*4*6(\reg)
    sw s7, \len*4*7(\reg)
.endm

# {hi,lo}=in1*in2
.macro MUL64 in1, in2, lo, hi
    mul \lo, \in1, \in2
    mulh \hi, \in1, \in2
.endm

# inLo and inHi will be rewrited
.macro ADD64 inLo, inHi, outLo, outHi
    # add low 32bits
    add  \outLo, \outLo, \inLo
    # (inLo+outLo)<inLo=>carry=1 else carry=0
    sltu \inLo, \outLo, \inLo
    # add high 32bits
    add  \outHi, \outHi, \inHi
    # add carry
    add  \outHi, \outHi, \inLo
.endm

# q * qinv = 1 mod 2^32, used for Montgomery arithmetic
.equ q, 8380417
.equ qinv, 58728449
# v = ??? (((int64_t)1 << 48) + M / 2) / M is used for barrett reduce
.equ V, ???
# ninv = 2^64 * (1/64) mod q is used for reverting standard domain
.equ ninv, 167912
# q/2
.equ q_div2, 4190208

# void ntt_rv32im(const uint32_t in[256], const int32_t zetas[64]);
# register usage:
# a0-a2: parameter, t0-t7: zetas, s0-s7: 8 coefficients
# s8, s9 temporary usage, a6/a7: M/Mprime, a4/a5: looper control
.globl ntt_rv32im
.align 2
ntt_rv32im:
    addi sp, sp, -4*15
    save_regs

    # zeta, M, Mprime
    LoadZetas
    li a6, M
    li a7, Mprime
    # loop control, a0+64=a[32], 32: loop numbers, 2: uint16_t=2B
    addi a4, a0, 32*2
# 123 layers, input is uint16_t in[N], output is int32_t out[N]
looper_123:
    # s0-s7 = a[0,32,64,...,224]
    # todo: int32_t
    LoadS h, 32, 2, a0
    # level1
    BFU s0, s4, t0, a6, a7, s8
    BFU s1, s5, t0, a6, a7, s8
    BFU s2, s6, t0, a6, a7, s8
    BFU s3, s7, t0, a6, a7, s8
    # level2
    BFU s0, s2, t1, a6, a7, s8
    BFU s1, s3, t1, a6, a7, s8
    BFU s4, s6, t2, a6, a7, s8
    BFU s5, s7, t2, a6, a7, s8
    # level3
    BFU s0, s1, t3, a6, a7, s8
    BFU s2, s3, t4, a6, a7, s8
    BFU s4, s5, t5, a6, a7, s8
    BFU s6, s7, t6, a6, a7, s8
    //save results
    # todo: int32_t
    StoreS 32, a1

    addi a0, a0, 2
    addi a1, a1, 4
    bne a4, a0, looper_123

# ============== level 4-6 ============== #
# reset a1, 32: inner loop number, 4: wordLen
addi a1, a1, -32*4
# a2 points to next 7 zetas
addi a2, a2, 4*7
# set outer loop control register a5, 8: inner loop number
addi a5, a2, 8*4*7

outer_456:
    LoadZetas
    # set looper control register a4, inner loop's increment is 4 words
    addi a4, a1, 4*4

    inner_456:
        # a[0,4,...,28]
        # todo: int32_t
        LoadS w, 4, 4, a1
        # level1
        BFU s0, s4, t0, a6, a7, s8
        BFU s1, s5, t0, a6, a7, s8
        BFU s2, s6, t0, a6, a7, s8
        BFU s3, s7, t0, a6, a7, s8
        # level2
        BFU s0, s2, t1, a6, a7, s8
        BFU s1, s3, t1, a6, a7, s8
        BFU s4, s6, t2, a6, a7, s8
        BFU s5, s7, t2, a6, a7, s8
        # level3
        BFU s0, s1, t3, a6, a7, s8
        BFU s2, s3, t4, a6, a7, s8
        BFU s4, s5, t5, a6, a7, s8
        BFU s6, s7, t6, a6, a7, s8

        //save results
        # todo: int32_t
        StoreS 4, a1
        # looper control register changes
        addi a1, a1, 4
        bne a4, a1, inner_456
    # a1 points to next block, a2 points to next 7 zetas
    # each block has 32 words, inner loop's increment is 4 words
    addi a1, a1, 32*4-4*4
    addi a2, a2, 4*7
    bne  a5, a2, outer_456

    restore_regs
    addi sp, sp, 4*15
    ret

# void intt_asm(const uint32_t in[256], int32_t out[256],
# const int32_t rootTable[64]);
# register usage: 
# a0-a2: parameter, a3: NINV, a4/a5: looper control, a6/a7: M/Mprime
# t0-t6: zetas
# s0-s7: 8 coefficients
# s8, s9 temporary usage, s10: M/2 for CenReduce
.globl intt_asm_6layer
.align 2
intt_asm_6layer:
    addi sp, sp, -4*15
    save_regs

# set outer loop control register a5, 8: inner loop number
addi a5, a2, 8*4*7
li a6, M
li a7, Mprime
outer_123:
    LoadZetas
    # set looper control register a4, inner loop's increment is 4 words
    addi a4, a1, 4*4

    inner_123:
        # a[0,4,...,28]
        LoadS w, 4, 4, a0
        # level1
        BFUINTT s0, s1, t0, a6, a7, s8
        BFUINTT s2, s3, t1, a6, a7, s8
        BFUINTT s4, s5, t2, a6, a7, s8
        BFUINTT s6, s7, t3, a6, a7, s8
        # level2
        BFUINTT s0, s2, t4, a6, a7, s8
        BFUINTT s1, s3, t4, a6, a7, s8
        BFUINTT s4, s6, t5, a6, a7, s8
        BFUINTT s5, s7, t5, a6, a7, s8
        # level3
        BFUINTT s0, s4, t6, a6, a7, s8
        BFUINTT s1, s5, t6, a6, a7, s8
        BFUINTT s2, s6, t6, a6, a7, s8
        BFUINTT s3, s7, t6, a6, a7, s8

        //save results
        StoreS 4, a1
        # looper control register changes
        addi a0, a0, 4
        addi a1, a1, 4
        bne a1, a4, inner_123
    # a1 points to next block, a2 points to next 7 zetas
    # each block has 32 words, inner loop's increment is 4 words
    addi a0, a0, 32*4-4*4
    addi a1, a1, 32*4-4*4
    addi a2, a2, 4*7
    bne  a2, a5, outer_123

    # reset a1
    addi a1, a1, -8*32*4
    # loop control, 32: loop numbers, 4: int32_t=4B
    addi a4, a1, 32*4
    LoadZetas
    # Load NINV for reverting to standard domain
    li a3, NINV
    li s10, MDiv2
# 456 layers, input is int32_t out[N], output is int32_t out[N]
looper_456:
    # s0-s7 = a[0,32,64,...,224]
    LoadS w, 32, 4, a1
    # level1
    BFUINTT s0, s1, t0, a6, a7, s8
    BFUINTT s2, s3, t1, a6, a7, s8
    BFUINTT s4, s5, t2, a6, a7, s8
    BFUINTT s6, s7, t3, a6, a7, s8
    # level2
    BFUINTT s0, s2, t4, a6, a7, s8
    BFUINTT s1, s3, t4, a6, a7, s8
    BFUINTT s4, s6, t5, a6, a7, s8
    BFUINTT s5, s7, t5, a6, a7, s8
    # level3
    BFUINTT s0, s4, t6, a6, a7, s8
    BFUINTT s1, s5, t6, a6, a7, s8
    BFUINTT s2, s6, t6, a6, a7, s8
    BFUINTT s3, s7, t6, a6, a7, s8
    # revert to standard domain and reduce to centered representation
    SCReduce a3, a6, a7, s10, s8, s9
    # save results
    StoreS 32, a1

    addi a1, a1, 4
    bne a1, a4, looper_456

    restore_regs
    addi sp, sp, 4*15
    ret    

# void basemul_asm(int32_t a[SABER_N], const int32_t b[SABER_N], int32_t zeta[SABER_N/4])
# save results to a[SABER_N]
# register usage: a0,a1,a2: parameters; t0-t3: a[0-3]; t4-t6,a7: b[0-3];
# a3-a6,s2: temporary usage; s0=M, s1=Mprime; s3: loop control
.globl basemul_asm_6layer
.align 2
basemul_asm_6layer:
    addi sp, sp, -4*15
    save_regs

    # Load M, Mprime
    li s0, M
    li s1, Mprime
    # loop counter
    addi s3, a0, 64*4*4
base_looper:
    # load a0-a3 to t0-t3
    lw t0, 0*4(a0) # a0
    lw t1, 1*4(a0) # a1
    lw t2, 2*4(a0) # a2
    lw t3, 3*4(a0) # a3
    # load b0-b3 to t4,t5,t6,a7
    lw t4, 0*4(a1) # b0
    lw t5, 1*4(a1) # b1
    lw t6, 2*4(a1) # b2
    lw a7, 3*4(a1) # b3
    # zeta
    lw s4, 0*4(a2)
    // r0=a0b0+zeta*(a1b3+a2b2+a3b1)
    # a1b3
    MUL64 t1, a7, a3, a4
    # a2b2
    MUL64 t2, t6, a5, a6
    # a1b3+a2b2
    ADD64 a3, a4, a5, a6
    # a3b1
    MUL64 t3, t5, a3, a4
    # a1b3+a2b2+a3b1
    ADD64 a3, a4, a5, a6
    # a3=MontReduce(a1b3+a2b2+a3b1)
    MontReduce a5, a6, a3, s0, s1
    # a4=zeta*a3
    MontMul s4, a3, a4, s0, s1, a5
    # a3=FqMul(a0,b0)
    MontMul t0, t4, a3, s0, s1, a5
    add a3, a3, a4
    # save to a[0]
    sw a3, 0*4(a0)

    // r1=a0b1+a1b0+zeta*(a2b3+a3b2)
    # a2b3
    MUL64 t2, a7, a3, a4
    # a3b2
    MUL64 t3, t6, a5, a6
    # a2b3+a3b2
    ADD64 a3, a4, a5, a6
    # a3=MontReduce(a2b3+a3b2)
    MontReduce a5, a6, a3, s0, s1
    # s2=zeta*a3
    MontMul s4, a3, s2, s0, s1, a5
    # a0b1
    MUL64 t0, t5, a3, a4
    # a1b0
    MUL64 t1, t4, a5, a6
    # a0b1+a1b0
    ADD64 a3, a4, a5, a6
    # a3=MontReduce(a0b1+a1b0)
    MontReduce a5, a6, a3, s0, s1
    add a3, a3, s2
    # save to a[1]
    sw a3, 1*4(a0)

    // r2=a0b2+a1b1+a2b0+zeta*(a3b3)
    # a3=FqMul(a3,b3)
    MontMul t3, a7, a3, s0, s1, a4
    # s2=zeta*a3
    MontMul s4, a3, s2, s0, s1, a5
    # a0b2
    MUL64 t0, t6, a3, a4
    # a1b1
    MUL64 t1, t5, a5, a6
    # a0b2+a1b1
    ADD64 a3, a4, a5, a6
    # a2b0
    MUL64 t2, t4, a3, a4
    # a0b2+a1b1+a2b0
    ADD64 a3, a4, a5, a6
    # a3=MontReduce(a0b2+a1b1+a2b0)
    MontReduce a5, a6, a3, s0, s1
    add a3, a3, s2
    # save to a[2]
    sw a3, 2*4(a0)

    // r3=a0b3+a1b2+a2b1+a3b0
    # a0b3
    MUL64 t0, a7, a3, a4
    # a1b2
    MUL64 t1, t6, a5, a6
    # a0b3+a1b2
    ADD64 a3, a4, a5, a6
    # a2b1
    MUL64 t2, t5, a3, a4
    # a0b3+a1b2+a2b1
    ADD64 a3, a4, a5, a6
    # a3b0
    MUL64 t3, t4, a3, a4
    # a0b3+a1b2+a2b1+a3b0
    ADD64 a3, a4, a5, a6
    # MontReduce(a0b3+a1b2+a2b1+a3b0)
    MontReduce a5, a6, a3, s0, s1
    # save to a[3]
    sw a3, 3*4(a0)

    # update index
    addi a0, a0, 4*4
    addi a1, a1, 4*4
    addi a2, a2, 4
    bne s3, a0, base_looper

    restore_regs
    addi sp, sp, 4*15
    ret