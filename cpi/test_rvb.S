.text

.globl cpi_rori
.align 2
cpi_rori:
    .rep 10
        rori a0, a0, 16
        rori a1, a1, 16
        rori a2, a2, 16
        rori a3, a3, 16
        rori a4, a4, 16
        rori a5, a5, 16
        rori a6, a6, 16
        rori a7, a7, 16
        rori t0, t0, 16
        rori t1, t1, 16
        rori t2, t2, 16
        rori t3, t3, 16
        rori t4, t4, 16
        rori t5, t5, 16
        rori t6, t6, 16
    .endr
    ret

.globl cpi_rori_x1
.align 2
cpi_rori_x1:
    .rep 10
        rori a0, a0, 16
        rori a0, a0, 16
        rori a0, a0, 16
        rori a0, a0, 16
        rori a0, a0, 16
        rori a0, a0, 16
        rori a0, a0, 16
        rori a0, a0, 16
        rori t0, t0, 16
        rori t0, t0, 16
        rori t0, t0, 16
        rori t0, t0, 16
        rori t0, t0, 16
        rori t0, t0, 16
        rori t0, t0, 16
    .endr
    ret

.globl cpi_rori_x2
.align 2
cpi_rori_x2:
    .rep 10
        rori a0, a0, 16
        rori a1, a1, 16
        rori a0, a0, 16
        rori a1, a1, 16
        rori a0, a0, 16
        rori a1, a1, 16
        rori a0, a0, 16
        rori a1, a1, 16
        rori a0, a0, 16
        rori a1, a1, 16
        rori a0, a0, 16
        rori a1, a1, 16
        rori a0, a0, 16
        rori a1, a1, 16
    .endr
    ret

.globl cpi_rori_x4
.align 2
cpi_rori_x4:
    .rep 10
        rori a0, a0, 16
        rori a1, a1, 16
        rori a2, a2, 16
        rori a3, a3, 16
        rori a0, a0, 16
        rori a1, a1, 16
        rori a2, a2, 16
        rori a3, a3, 16
        rori a0, a0, 16
        rori a1, a1, 16
        rori a2, a2, 16
        rori a3, a3, 16
        rori a0, a0, 16
        rori a1, a1, 16
        rori a2, a2, 16
        rori a3, a3, 16
    .endr
    ret

.globl cpi_andn
.align 2
cpi_andn:
    .rep 10
        andn a0, a0, t6
        andn a1, a1, t6
        andn a2, a2, t6
        andn a3, a3, t6
        andn a4, a4, t6
        andn a5, a5, t6
        andn a6, a6, t6
        andn a7, a7, t6
        andn t0, t0, t6
        andn t1, t1, t6
        andn t2, t2, t6
        andn t3, t3, t6
        andn t4, t4, t6
        andn t5, t5, t6
    .endr
    ret

.globl cpi_andn_x1
.align 2
cpi_andn_x1:
    .rep 10
        andn a0, a0, t6
        andn a0, a0, t6
        andn a0, a0, t6
        andn a0, a0, t6
        andn a0, a0, t6
        andn a0, a0, t6
        andn a0, a0, t6
        andn a0, a0, t6
        andn t0, t0, t6
        andn t0, t0, t6
        andn t0, t0, t6
        andn t0, t0, t6
        andn t0, t0, t6
        andn t0, t0, t6
    .endr
    ret

.globl cpi_andn_x2
.align 2
cpi_andn_x2:
    .rep 10
        andn a0, a0, t6
        andn a1, a1, t6
        andn a0, a0, t6
        andn a1, a1, t6
        andn a0, a0, t6
        andn a1, a1, t6
        andn a0, a0, t6
        andn a1, a1, t6
        andn a0, a0, t6
        andn a1, a1, t6
        andn a0, a0, t6
        andn a1, a1, t6
        andn a0, a0, t6
        andn a1, a1, t6
    .endr
    ret

.globl cpi_andn_x4
.align 2
cpi_andn_x4:
    .rep 10
        andn a0, a0, t6
        andn a1, a1, t6
        andn a2, a2, t6
        andn a3, a3, t6
        andn a0, a0, t6
        andn a1, a1, t6
        andn a2, a2, t6
        andn a3, a3, t6
        andn a0, a0, t6
        andn a1, a1, t6
        andn a2, a2, t6
        andn a3, a3, t6
        andn a0, a0, t6
        andn a1, a1, t6
        andn a2, a2, t6
        andn a3, a3, t6
    .endr
    ret