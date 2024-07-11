CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
SCP 	= scp

COMMONDIR 		= ../common
KECCAKDIR		= ../sha3

CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  				  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -I$(COMMONDIR) -I. -I$(KECCAKDIR)

CFLAGS_RV32IM 	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMB 	= $(CFLAGS_COMMON) -march=rv32imac_zbb -mabi=ilp32 -DRV32=1 -DBIT_INTERLEAVING
CFLAGS_RV32IMV 	= $(CFLAGS_COMMON) -march=rv32imacv -mabi=ilp32 -DRV32=1 -DVECTOR128
CFLAGS_RV32IMBV = $(CFLAGS_COMMON) -march=rv32imacv_zbb -mabi=ilp32 -DRV32=1 -DBIT_INTERLEAVING -DVECTOR128
CFLAGS_RV64IM 	= $(CFLAGS_COMMON) -march=rv64imac -mabi=lp64 -DRV64=1
CFLAGS_RV64IMB 	= $(CFLAGS_COMMON) -march=rv64imac_zba_zbb -mabi=lp64 -DRV64=1
CFLAGS_RV64IMV 	= $(CFLAGS_COMMON) -march=rv64imacv -mabi=lp64 -DVECTOR128 -DRV64=1
CFLAGS_RV64IMBV = $(CFLAGS_COMMON) -march=rv64imacv_zba_zbb -mabi=lp64 -DVECTOR128 -DRV64=1

TARGET_IP 	= 192.168.123.99
TARGET_USER = root
TARGET_DIR  = /sharefs

SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h

SOURCES			= speed_piism_sha3.c

.PHONY: all run_rv64im run_rv64imb run_rv32im clean

all: out/rv64im_scp out/rv32im_scp

out/rv32v_scp: \
	out/speed_piism_sha3_rv32v_vr0 \
	out/speed_piism_sha3_rv32v_vr1
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

run_rv32v: out/rv32v_scp
	@ssh $(TARGET_USER)@$(TARGET_IP) "bash -c '\
		cd $(TARGET_DIR) && \
		./speed_piism_sha3_rv32v_vr0 && ./speed_piism_sha3_rv32v_vr1 \
	'"

out/speed_piism_sha3_rv32v_vr0: $(SOURCES_COMMON) speed_piism_sha3_rvv.c $(HEADERS_COMMON) fips202_rv32v_vr0.S $(KECCAKDIR)/fips202_rv32.c $(KECCAKDIR)/fips202_rv32im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv32v_vr1: $(SOURCES_COMMON) speed_piism_sha3_rvv.c $(HEADERS_COMMON) fips202_rv32v_vr1_unroll.S $(KECCAKDIR)/fips202_rv32.c $(KECCAKDIR)/fips202_rv32im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/rv64v_scp: \
	out/speed_piism_sha3_rv64v_vr0 \
	out/speed_piism_sha3_rv64v_vr1 \
	out/speed_piism_sha3_rv64v_vr2 \
	out/speed_piism_sha3_rv64imv_hybridx3 \
	out/speed_piism_sha3_rv64imbv_hybridx3
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

run_rv64v: out/rv64v_scp
	@ssh $(TARGET_USER)@$(TARGET_IP) "bash -c '\
		cd $(TARGET_DIR) && \
		./speed_piism_sha3_rv64v_vr0 && ./speed_piism_sha3_rv64v_vr1 && \
		./speed_piism_sha3_rv64v_vr2 && ./speed_piism_sha3_rv64imv_hybridx3 && \
		./speed_piism_sha3_rv64imbv_hybridx3 \
	'"

out/rv64imbv_scp: out/speed_piism_sha3_rv64imbv_hybridx3
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

run_rv64imbv: out/rv64imbv_scp
	@ssh $(TARGET_USER)@$(TARGET_IP) "bash -c '\
		cd $(TARGET_DIR) && \
		./speed_piism_sha3_rv64imbv_hybridx3 \
	'"

out/speed_piism_sha3_rv64v_vr0: $(SOURCES_COMMON) speed_piism_sha3_rvv.c $(HEADERS_COMMON) fips202_rv64v_vr0.S $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202_rv64im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64v_vr1: $(SOURCES_COMMON) speed_piism_sha3_rvv.c $(HEADERS_COMMON) fips202_rv64v_vr1.S $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202_rv64im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64v_vr2: $(SOURCES_COMMON) speed_piism_sha3_rvv.c $(HEADERS_COMMON) fips202_rv64v_vr2.S $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202_rv64im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64imv_hybridx3: $(SOURCES_COMMON) speed_piism_sha3_rvv.c $(HEADERS_COMMON) fips202_rv64v_vr2.S fips202_rv64imv_hybrid_x3.S fips202_rv64imv_hybrid_x4.S fips202_rv64imv_hybrid_x5.S fips202_rv64imv_hybrid_x6.S fips202_rv64imv_hybrid_x8.S $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202_rv64im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5 -DHYBRIDX6 -DHYBRIDX8 -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64imbv_hybridx3: $(SOURCES_COMMON) speed_piism_sha3_rvv.c $(HEADERS_COMMON) fips202_rv64v_vr2.S fips202_rv64imbv_hybrid_x3.S fips202_rv64imbv_hybrid_x4.S fips202_rv64imbv_hybrid_x5.S fips202_rv64imbv_hybrid_x6.S fips202_rv64imbv_hybrid_x8.S $(KECCAKDIR)/fips202_rv64.c $(KECCAKDIR)/fips202_rv64im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV) -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5 -DHYBRIDX6 -DHYBRIDX8 -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/rv64im_scp:	\
	out/speed_piism_sha3_rv64im_vr0	\
	out/speed_piism_sha3_rv64im_vr1	\
	out/speed_piism_sha3_rv64im_vr2	\
	out/speed_piism_sha3_rv64im_vr3	\
	out/speed_piism_sha3_rv64im_vr4	\
	out/speed_piism_sha3_rv64im_vr5	\
	out/speed_piism_sha3_rv64im_vr6	\
	out/speed_piism_sha3_rv64im_ve0	\
	out/speed_piism_sha3_rv64im_ve1	\
	out/speed_piism_sha3_rv64im_ve2 \
	out/speed_piism_sha3_rv64im_ve3 \
	out/speed_piism_sha3_rv64im_ve4 \
	out/speed_piism_sha3_rv64im_ve5
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

run_rv64im: out/rv64im_scp
	@ssh $(TARGET_USER)@$(TARGET_IP) "bash -c '\
		cd $(TARGET_DIR) && \
		./speed_piism_sha3_rv64im_vr0 && ./speed_piism_sha3_rv64im_vr1 && ./speed_piism_sha3_rv64im_vr2 && \
		./speed_piism_sha3_rv64im_vr3 && ./speed_piism_sha3_rv64im_vr4 && \
		./speed_piism_sha3_rv64im_vr5 && ./speed_piism_sha3_rv64im_vr6 \
		echo -e \ && \
		./speed_piism_sha3_rv64im_ve0 && ./speed_piism_sha3_rv64im_ve1 && \
		./speed_piism_sha3_rv64im_ve2 && ./speed_piism_sha3_rv64im_ve3 && \
		./speed_piism_sha3_rv64im_ve4 \
	'"

out/rv64imb_scp: \
	out/speed_piism_sha3_rv64imb_vr0 out/speed_piism_sha3_rv64imb_vr1
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

run_rv64imb: out/rv64imb_scp
	@ssh $(TARGET_USER)@$(TARGET_IP) "bash -c '\
		cd $(TARGET_DIR) && \
		./speed_piism_sha3_rv64imb_vr0 && ./speed_piism_sha3_rv64imb_vr1 \
	'"

out/rv32im_scp: \
	out/speed_piism_sha3_rv32im_vr0 out/speed_piism_sha3_rv32im_vr1 \
	out/speed_piism_sha3_rv32im_vr2
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

run_rv32im: out/rv32im_scp
	@ssh $(TARGET_USER)@$(TARGET_IP) "bash -c '\
		cd $(TARGET_DIR) && \
		./speed_piism_sha3_rv32im_vr0 && ./speed_piism_sha3_rv32im_vr1 && \
		./speed_piism_sha3_rv32im_vr2 \
	'"
out/speed_piism_sha3_rv32im_vr0: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv32im_vr0.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv32im_vr1: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv32im_vr1.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv32im_vr2: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv32im_vr2.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/rv32imb_scp: \
	out/speed_piism_sha3_rv32imb_bitinter_vr0 out/speed_piism_sha3_rv32imb_bitinter_vr1
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

run_rv32imb: out/rv32imb_scp
	@ssh $(TARGET_USER)@$(TARGET_IP) "bash -c '\
		cd $(TARGET_DIR) && \
		./speed_piism_sha3_rv32imb_bitinter_vr0 && ./speed_piism_sha3_rv32imb_bitinter_vr1 \
	'"

out/speed_piism_sha3_rv32imb_bitinter_vr0: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv32imb_bitinter_vr0.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) -DRIGHT_IMPL -DBIT_INTERLEAVING $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv32imb_bitinter_vr1: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv32imb_bitinter_vr1.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) -DRIGHT_IMPL -DBIT_INTERLEAVING $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64imb_vr0: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64imb_vr0.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64imb_vr1: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64imb_vr1.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_vr0: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr0.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_vr1: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr1.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_vr2: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr2.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_vr3: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr3.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_vr4: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr4.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_vr5: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr5.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_vr6: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr6.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_ve0: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_ve0.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_ve1: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_ve1.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_ve2: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_ve2.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_ve3: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_ve3.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_ve4: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_ve4.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_rv64im_ve5: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_ve5.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

clean:
	rm -rf out/
