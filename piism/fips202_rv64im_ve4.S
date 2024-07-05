.data
.align 2
constants_keccak:
.quad 0x0000000000000001
.quad 0x0000000000008082
.quad 0x800000000000808a
.quad 0x8000000080008000
.quad 0x000000000000808b
.quad 0x0000000080000001
.quad 0x8000000080008081
.quad 0x8000000000008009
.quad 0x000000000000008a
.quad 0x0000000000000088
.quad 0x0000000080008009
.quad 0x000000008000000a
.quad 0x000000008000808b
.quad 0x800000000000008b
.quad 0x8000000000008089
.quad 0x8000000000008003
.quad 0x8000000000008002
.quad 0x8000000000000080
.quad 0x000000000000800a
.quad 0x800000008000000a
.quad 0x8000000080008081
.quad 0x8000000000008080
.quad 0x0000000080000001
.quad 0x8000000080008008

.text

.macro ARoundInPlace \
        S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, \
        S10, S11, S12
.rep 9
    xor \S00, \S00, \S00
    xor \S01, \S01, \S01
    xor \S02, \S02, \S02
    xor \S03, \S03, \S03
    xor \S04, \S04, \S04
    xor \S05, \S05, \S05
    xor \S06, \S06, \S06
    xor \S07, \S07, \S07
    xor \S08, \S08, \S08
    xor \S09, \S09, \S09
    xor \S10, \S10, \S10
    xor \S11, \S11, \S11
    xor \S12, \S12, \S12
    xor \S03, \S03, \S03
    xor \S04, \S04, \S04
    xor \S05, \S05, \S05
    xor \S06, \S06, \S06
    xor \S07, \S07, \S07
    xor \S08, \S08, \S08
    xor \S09, \S09, \S09
.endr
    xor \S00, \S00, \S00
    xor \S01, \S01, \S01
    xor \S02, \S02, \S02
    ld   \S01, (a0)
    xor \S03, \S03, \S03
    xor \S04, \S04, \S04
    xor \S05, \S05, \S05
    xor \S06, \S06, \S06
    xor \S07, \S07, \S07
    xor \S08, \S08, \S08
    ld   \S02, 0(a0)
    xor \S09, \S09, \S09
    xor \S10, \S10, \S10
    addi \S01, \S01, 8
    xor \S11, \S11, \S11
    xor \S12, \S12, \S12
    sd   \S01, (a0)
    xor \S03, \S03, \S03
    xor \S06, \S06, \S06
    xor \S02, \S02, \S02
.endm

# 15*8(sp): a0
# 16*8(sp): loop control variable i
# 17*8(sp): table index
.globl KeccakF1600_StatePermute_RV64ASM
.align 2
KeccakF1600_StatePermute_RV64ASM:
    li t6, 24
    
loop:
    ARoundInPlace \
        a1, a2, a3, a4, a5, a6, a7, t0, t1, t2, \
        t3, t4, t5
    addi t6, t6, -1
    bnez t6, loop

    ret
