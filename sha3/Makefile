CC 		= riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
SCP 	= scp
# SCP		= @:

COMMONDIR 		= ../common
KECCAKDIR		= ../common/keccak
CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  				  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -I$(COMMONDIR) -I$(KECCAKDIR) -I.

CFLAGS_RV32IM 	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMB 	= $(CFLAGS_COMMON) -march=rv32imac_zbb -mabi=ilp32 -DRV32=1 -DBIT_INTERLEAVING
CFLAGS_RV32IMV 	= $(CFLAGS_COMMON) -march=rv32imacv -mabi=ilp32 -DRV32=1 -DVECTOR128 -DHYBRIDX3 -DHYBRIDX4
CFLAGS_RV32IMBV = $(CFLAGS_COMMON) -march=rv32imacv_zbb -mabi=ilp32 -DRV32=1 -DBIT_INTERLEAVING -DVECTOR128 -DHYBRIDX3 -DHYBRIDX4
CFLAGS_RV64IM 	= $(CFLAGS_COMMON) -march=rv64imac -mabi=lp64
CFLAGS_RV64IMB 	= $(CFLAGS_COMMON) -march=rv64imac_zba_zbb -mabi=lp64
CFLAGS_RV64IMV 	= $(CFLAGS_COMMON) -march=rv64imacv -mabi=lp64 -DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5 -DHYBRIDX6 -DHYBRIDX8
CFLAGS_RV64IMBV = $(CFLAGS_COMMON) -march=rv64imacv_zba_zbb -mabi=lp64 -DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5 -DHYBRIDX6 -DHYBRIDX8

CFLAGS_RV32IM_REF 	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMB_REF 	= $(CFLAGS_COMMON) -march=rv32imac_zbb -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMV_REF 	= $(CFLAGS_COMMON) -march=rv32imacv -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMBV_REF = $(CFLAGS_COMMON) -march=rv32imacv_zbb -mabi=ilp32 -DRV32=1
CFLAGS_RV64IM_REF 	= $(CFLAGS_COMMON) -march=rv64imac -mabi=lp64
CFLAGS_RV64IMB_REF 	= $(CFLAGS_COMMON) -march=rv64imac_zba_zbb -mabi=lp64
CFLAGS_RV64IMV_REF 	= $(CFLAGS_COMMON) -march=rv64imacv -mabi=lp64
CFLAGS_RV64IMBV_REF = $(CFLAGS_COMMON) -march=rv64imacv_zba_zbb -mabi=lp64

# TARGET_IP 	= 192.168.123.99
TARGET_IP = 192.168.31.252
TARGET_USER = root
TARGET_DIR  = /sharefs

RM = /bin/rm

SOURCES_RV32IM  = $(KECCAKDIR)/fips202_rv32.c $(KECCAKDIR)/fips202_rv32im.S
SOURCES_RV32IMB = $(KECCAKDIR)/fips202_rv32.c $(KECCAKDIR)/fips202_rv32imb_bitinter.S
SOURCES_RV32IMV = $(KECCAKDIR)/fips202_rv32.c $(KECCAKDIR)/fips202x_rv32.c $(KECCAKDIR)/fips202_rv32im.S $(KECCAKDIR)/fips202_rv32v.S $(KECCAKDIR)/fips202_rv32imv_hybrid_x3.S $(KECCAKDIR)/fips202_rv32imv_hybrid_x4.S
SOURCES_RV32IMBV= $(KECCAKDIR)/fips202_rv32.c $(KECCAKDIR)/fips202x_rv32.c $(KECCAKDIR)/fips202_rv32imb_bitinter.S $(KECCAKDIR)/fips202_rv32v.S $(KECCAKDIR)/fips202_rv32imbv_hybrid_x3.S $(KECCAKDIR)/fips202_rv32imbv_hybrid_x4.S
SOURCES_RV64IM	= $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202_rv64im.S
SOURCES_RV64IMB	= $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202_rv64imb.S
SOURCES_RV64IMV	= $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202x_rv64.c $(KECCAKDIR)/fips202_rv64im.S $(KECCAKDIR)/fips202_rv64v.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x3.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x4.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x5.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x6.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x8.S
SOURCES_RV64IMBV= $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202x_rv64.c $(KECCAKDIR)/fips202_rv64imb.S $(KECCAKDIR)/fips202_rv64v.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x3.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x4.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x5.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x6.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x8.S

SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(KECCAKDIR)/fips202.h $(KECCAKDIR)/fips202x.h $(COMMONDIR)/speed_print.h

SOURCES_REF 	= $(COMMONDIR)/cpucycles.c $(KECCAKDIR)/fips202_ref.c $(COMMONDIR)/speed_print.c
HEADERS_REF 	= $(COMMONDIR)/cpucycles.h $(KECCAKDIR)/fips202.h $(COMMONDIR)/speed_print.h

.PHONY: speed clean

speed: \
	out/test_speed_sha3_rv32im_ref 		out/test_speed_sha3_rv32imb_ref 	\
	out/test_speed_sha3_rv32imv_ref 	out/test_speed_sha3_rv32imbv_ref	\
	out/test_speed_sha3_rv64im_ref		out/test_speed_sha3_rv64imv_ref 	\
	out/test_speed_sha3_rv64imb_ref		out/test_speed_sha3_rv64imbv_ref	\
	out/test_speed_sha3_rv32im 			out/test_speed_sha3_rv32imb 		\
	out/test_speed_sha3_rv32imv 		out/test_speed_sha3_rv32imbv		\
	out/test_speed_sha3_rv64im			out/test_speed_sha3_rv64imv 		\
	out/test_speed_sha3_rv64imb			out/test_speed_sha3_rv64imbv		\
	out/scp_test

# Get the file results*.txt from the target machine. Note that when execute commands like test_speed* on the target machine, the output results are redirected to results.txt.
# The commands executed on target machine include:
# ./test_speed_sha3_rv32im_ref > results_rv32im_ref.txt; ./test_speed_sha3_rv32imb_ref > results_rv32imb_ref.txt; ./test_speed_sha3_rv32imv_ref > results_rv32imv_ref.txt; ./test_speed_sha3_rv32imbv_ref > results_rv32imbv_ref.txt; ./test_speed_sha3_rv64im_ref > results_rv64im_ref.txt; ./test_speed_sha3_rv64imb_ref > results_rv64imb_ref.txt; ./test_speed_sha3_rv64imv_ref > results_rv64imv_ref.txt; ./test_speed_sha3_rv64imbv_ref > results_rv64imbv_ref.txt
# ./test_speed_sha3_rv32im > results_rv32im.txt; ./test_speed_sha3_rv32imb > results_rv32imb.txt; ./test_speed_sha3_rv32imv > results_rv32imv.txt; ./test_speed_sha3_rv32imbv > results_rv32imbv.txt; ./test_speed_sha3_rv64im > results_rv64im.txt; ./test_speed_sha3_rv64imb > results_rv64imb.txt; ./test_speed_sha3_rv64imv > results_rv64imv.txt; ./test_speed_sha3_rv64imbv > results_rv64imbv.txt
results:
	scp root@$(TARGET_IP):/sharefs/results_rv32im_ref.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv32imb_ref.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv32imv_ref.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv32imbv_ref.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv64im_ref.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv64imb_ref.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv64imv_ref.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv64imbv_ref.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv32im.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv32imb.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv32imv.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv32imbv.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv64im.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv64imb.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv64imv.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv64imbv.txt .

out/scp_test:	\
	out/test_speed_sha3_rv32im_ref 		out/test_speed_sha3_rv32imb_ref 	\
	out/test_speed_sha3_rv32imv_ref 	out/test_speed_sha3_rv32imbv_ref	\
	out/test_speed_sha3_rv64im_ref		out/test_speed_sha3_rv64imv_ref 	\
	out/test_speed_sha3_rv64imb_ref		out/test_speed_sha3_rv64imbv_ref	\
	out/test_speed_sha3_rv32im 			out/test_speed_sha3_rv32imb 		\
	out/test_speed_sha3_rv32imv 		out/test_speed_sha3_rv32imbv		\
	out/test_speed_sha3_rv64im			out/test_speed_sha3_rv64imv 		\
	out/test_speed_sha3_rv64imb			out/test_speed_sha3_rv64imbv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

# ref implementation

# for RV32IM

out/test_speed_sha3_rv32im_ref: $(SOURCES_REF) $(HEADERS_REF) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMB

out/test_speed_sha3_rv32imb_ref: $(SOURCES_REF) $(HEADERS_REF) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMV

out/test_speed_sha3_rv32imv_ref: $(SOURCES_REF) $(HEADERS_REF) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMBV

out/test_speed_sha3_rv32imbv_ref: $(SOURCES_REF) $(HEADERS_REF) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IM

out/test_speed_sha3_rv64im_ref: $(SOURCES_REF) $(HEADERS_REF) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMB

out/test_speed_sha3_rv64imb_ref: $(SOURCES_REF) $(HEADERS_REF) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMV

out/test_speed_sha3_rv64imv_ref: $(SOURCES_REF) $(HEADERS_REF) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMBV

out/test_speed_sha3_rv64imbv_ref: $(SOURCES_REF) $(HEADERS_REF) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# ref implementation end

# for RV32IM

out/test_speed_sha3_rv32im: $(SOURCES_COMMON) $(SOURCES_RV32IM) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMB

out/test_speed_sha3_rv32imb: $(SOURCES_COMMON) $(SOURCES_RV32IMB) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMV

out/test_speed_sha3_rv32imv: $(SOURCES_COMMON) $(SOURCES_RV32IMV) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMBV

out/test_speed_sha3_rv32imbv: $(SOURCES_COMMON) $(SOURCES_RV32IMBV) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IM

out/test_speed_sha3_rv64im: $(SOURCES_COMMON) $(SOURCES_RV64IM) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMB

out/test_speed_sha3_rv64imb: $(SOURCES_COMMON) $(SOURCES_RV64IMB) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMV

out/test_speed_sha3_rv64imv: $(SOURCES_COMMON) $(SOURCES_RV64IMV) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMBV

out/test_speed_sha3_rv64imbv: $(SOURCES_COMMON) $(SOURCES_RV64IMBV) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@

clean:
	-$(RM) -rf out/
