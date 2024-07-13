CC 		= riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
SCP 	= scp
# SCP		= @:

COMMONDIR 		= ../common
KECCAKDIR		= .
CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  				  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -I$(COMMONDIR) -I$(KECCAKDIR)

CFLAGS_RV32IM 	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMB 	= $(CFLAGS_COMMON) -march=rv32imac_zbb -mabi=ilp32 -DRV32=1 -DBIT_INTERLEAVING
CFLAGS_RV32IMV 	= $(CFLAGS_COMMON) -march=rv32imacv -mabi=ilp32 -DRV32=1 \
	-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5
CFLAGS_RV32IMBV = $(CFLAGS_COMMON) -march=rv32imacv_zbb -mabi=ilp32 -DRV32=1 \
	-DBIT_INTERLEAVING \
	-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5
CFLAGS_RV64IM 	= $(CFLAGS_COMMON) -march=rv64imac -mabi=lp64
CFLAGS_RV64IMB 	= $(CFLAGS_COMMON) -march=rv64imac_zba_zbb -mabi=lp64
CFLAGS_RV64IMV 	= $(CFLAGS_COMMON) -march=rv64imacv -mabi=lp64 \
	-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5 -DHYBRIDX6 -DHYBRIDX8 -DHYBRIDX10 -DHYBRIDX14
CFLAGS_RV64IMBV = $(CFLAGS_COMMON) -march=rv64imacv_zba_zbb -mabi=lp64 \
	-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5 -DHYBRIDX6 -DHYBRIDX8 -DHYBRIDX10 -DHYBRIDX14

CFLAGS_RV32IM_REF 	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMB_REF 	= $(CFLAGS_COMMON) -march=rv32imac_zbb -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMV_REF 	= $(CFLAGS_COMMON) -march=rv32imacv -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMBV_REF = $(CFLAGS_COMMON) -march=rv32imacv_zbb -mabi=ilp32 -DRV32=1
CFLAGS_RV64IM_REF 	= $(CFLAGS_COMMON) -march=rv64imac -mabi=lp64
CFLAGS_RV64IMB_REF 	= $(CFLAGS_COMMON) -march=rv64imac_zba_zbb -mabi=lp64
CFLAGS_RV64IMV_REF 	= $(CFLAGS_COMMON) -march=rv64imacv -mabi=lp64
CFLAGS_RV64IMBV_REF = $(CFLAGS_COMMON) -march=rv64imacv_zba_zbb -mabi=lp64

TARGET_IP 	= 192.168.123.99
TARGET_USER = root
TARGET_DIR  = /sharefs

RM = /bin/rm

SOURCES_RV32IM  = $(KECCAKDIR)/fips202_rv32.c $(KECCAKDIR)/fips202_rv32im.S
SOURCES_RV32IMB = $(KECCAKDIR)/fips202_rv32.c $(KECCAKDIR)/fips202_rv32imb_bitinter.S
SOURCES_RV32IMV = $(KECCAKDIR)/fips202_rv32.c $(KECCAKDIR)/fips202x_rv32.c $(KECCAKDIR)/fips202_rv32im.S $(KECCAKDIR)/fips202_rv32v.S $(KECCAKDIR)/fips202_rv32imv_hybrid_x3.S $(KECCAKDIR)/fips202_rv32imv_hybrid_x4.S $(KECCAKDIR)/fips202_rv32imv_hybrid_x5.S
SOURCES_RV32IMBV= $(KECCAKDIR)/fips202_rv32.c $(KECCAKDIR)/fips202x_rv32.c $(KECCAKDIR)/fips202_rv32imb_bitinter.S $(KECCAKDIR)/fips202_rv32v.S $(KECCAKDIR)/fips202_rv32imbv_hybrid_x3.S $(KECCAKDIR)/fips202_rv32imbv_hybrid_x4.S $(KECCAKDIR)/fips202_rv32imbv_hybrid_x5.S
SOURCES_RV64IM	= $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202_rv64im.S
SOURCES_RV64IMB	= $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202_rv64imb.S
SOURCES_RV64IMV	= $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202x_rv64.c $(KECCAKDIR)/fips202_rv64im.S $(KECCAKDIR)/fips202_rv64v.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x3.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x4.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x5.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x6.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x8.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x10.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x14.S
SOURCES_RV64IMBV= $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202x_rv64.c $(KECCAKDIR)/fips202_rv64imb.S $(KECCAKDIR)/fips202_rv64v.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x3.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x4.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x5.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x6.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x8.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x10.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x14.S

SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(KECCAKDIR)/fips202.h $(KECCAKDIR)/fips202x.h $(COMMONDIR)/speed_print.h

SOURCES_REF 	= $(COMMONDIR)/cpucycles.c $(KECCAKDIR)/fips202_ref.c $(COMMONDIR)/speed_print.c
HEADERS_REF 	= $(COMMONDIR)/cpucycles.h $(KECCAKDIR)/fips202.h $(COMMONDIR)/speed_print.h

.PHONY: all run_all clean

all: \
	out/test_speed_sha3_rv32im_ref 		out/test_speed_sha3_rv32imb_ref 	\
	out/test_speed_sha3_rv32imv_ref 	out/test_speed_sha3_rv32imbv_ref	\
	out/test_speed_sha3_rv64im_ref		out/test_speed_sha3_rv64imv_ref 	\
	out/test_speed_sha3_rv64imb_ref		out/test_speed_sha3_rv64imbv_ref	\
	out/test_speed_sha3_rv32im 			out/test_speed_sha3_rv32imb 		\
	out/test_speed_sha3_rv32imv 		out/test_speed_sha3_rv32imbv		\
	out/test_speed_sha3_rv64im			out/test_speed_sha3_rv64imv 		\
	out/test_speed_sha3_rv64imb			out/test_speed_sha3_rv64imbv		\
	out/speed_ko_sha3_rv32im 			out/speed_riscvcrypto_sha3_rv64imb \
	out/scp_test

run_all: \
	run_rv32im_ref run_rv32imb_ref run_rv32imv_ref run_rv32imbv_ref \
	run_rv64im_ref run_rv64imv_ref run_rv64imb_ref run_rv64imbv_ref \
	run_rv32im run_rv32imb run_rv32imv run_rv32imbv \
	run_rv64im run_rv64imv run_rv64imb run_rv64imbv \
	run_ko_rv32im run_riscvcrypto_rv64imb

run_rv32im_ref: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv32im_ref" > results_rv32im_ref.txt
run_rv32imb_ref: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv32imb_ref" > results_rv32imb_ref.txt
run_rv32imv_ref: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv32imv_ref" > results_rv32imv_ref.txt
run_rv32imbv_ref: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv32imbv_ref" > results_rv32imbv_ref.txt
run_rv64im_ref: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv64im_ref" > results_rv64im_ref.txt
run_rv64imv_ref: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv64imv_ref" > results_rv64imv_ref.txt
run_rv64imb_ref: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv64imb_ref" > results_rv64imb_ref.txt
run_rv64imbv_ref: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv64imbv_ref" > results_rv64imbv_ref.txt
run_rv32im: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv32im" > results_rv32im.txt
run_rv32imb: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv32imb" > results_rv32imb.txt
run_rv32imv: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv32imv" > results_rv32imv.txt
run_rv32imbv: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv32imbv" > results_rv32imbv.txt
run_rv64im: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv64im" > results_rv64im.txt
run_rv64imv: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv64imv" > results_rv64imv.txt
run_rv64imb: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv64imb" > results_rv64imb.txt
run_rv64imbv: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed_sha3_rv64imbv" > results_rv64imbv.txt
run_ko_rv32im: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_ko_sha3_rv32im" > results_ko_rv32im.txt
run_riscvcrypto_rv64imb: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_riscvcrypto_sha3_rv64imb" > results_riscvcrypto_rv64imb.txt

out/scp_test:	\
	out/test_speed_sha3_rv32im_ref 		out/test_speed_sha3_rv32imb_ref 	\
	out/test_speed_sha3_rv32imv_ref 	out/test_speed_sha3_rv32imbv_ref	\
	out/test_speed_sha3_rv64im_ref		out/test_speed_sha3_rv64imv_ref 	\
	out/test_speed_sha3_rv64imb_ref		out/test_speed_sha3_rv64imbv_ref	\
	out/test_speed_sha3_rv32im 			out/test_speed_sha3_rv32imb 		\
	out/test_speed_sha3_rv32imv 		out/test_speed_sha3_rv32imbv		\
	out/test_speed_sha3_rv64im			out/test_speed_sha3_rv64imv 		\
	out/test_speed_sha3_rv64imb			out/test_speed_sha3_rv64imbv		\
	out/speed_ko_sha3_rv32im		 	out/speed_riscvcrypto_sha3_rv64imb
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

out/speed_riscvcrypto_sha3_rv64imb: $(SOURCES_COMMON) $(HEADERS_COMMON) speed_riscvcrypto_sha3.c riscvcrypto_rv64imb.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) $(filter %.c, $^) $(filter %.S, $^) -o $@

# Ko Stoffelen implementation

out/speed_ko_sha3_rv32im: $(SOURCES_COMMON) $(HEADERS_COMMON) speed_ko_sha3.c ko_fips202_rv32im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# ref implementation

# for RV32IM

out/test_speed_sha3_rv32im_ref: $(SOURCES_REF) $(HEADERS_REF) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMB

out/test_speed_sha3_rv32imb_ref: $(SOURCES_REF) $(HEADERS_REF) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMV

out/test_speed_sha3_rv32imv_ref: $(SOURCES_REF) $(HEADERS_REF) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMBV

out/test_speed_sha3_rv32imbv_ref: $(SOURCES_REF) $(HEADERS_REF) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IM

out/test_speed_sha3_rv64im_ref: $(SOURCES_REF) $(HEADERS_REF) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMB

out/test_speed_sha3_rv64imb_ref: $(SOURCES_REF) $(HEADERS_REF) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMV

out/test_speed_sha3_rv64imv_ref: $(SOURCES_REF) $(HEADERS_REF) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMBV

out/test_speed_sha3_rv64imbv_ref: $(SOURCES_REF) $(HEADERS_REF) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV_REF) $(filter %.c, $^) $(filter %.S, $^) -o $@

# ref implementation end

# for RV32IM

out/test_speed_sha3_rv32im: $(SOURCES_COMMON) $(SOURCES_RV32IM) $(HEADERS_COMMON) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMB

out/test_speed_sha3_rv32imb: $(SOURCES_COMMON) $(SOURCES_RV32IMB) $(HEADERS_COMMON) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMV

out/test_speed_sha3_rv32imv: $(SOURCES_COMMON) $(SOURCES_RV32IMV) $(HEADERS_COMMON) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMBV

out/test_speed_sha3_rv32imbv: $(SOURCES_COMMON) $(SOURCES_RV32IMBV) $(HEADERS_COMMON) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IM

out/test_speed_sha3_rv64im: $(SOURCES_COMMON) $(SOURCES_RV64IM) $(HEADERS_COMMON) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMB

out/test_speed_sha3_rv64imb: $(SOURCES_COMMON) $(SOURCES_RV64IMB) $(HEADERS_COMMON) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMV

out/test_speed_sha3_rv64imv: $(SOURCES_COMMON) $(SOURCES_RV64IMV) $(HEADERS_COMMON) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMBV

out/test_speed_sha3_rv64imbv: $(SOURCES_COMMON) $(SOURCES_RV64IMBV) $(HEADERS_COMMON) test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@

clean:
	-$(RM) -rf out/
