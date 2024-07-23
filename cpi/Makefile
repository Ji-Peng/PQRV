CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
SCP 	= scp

COMMONDIR 		= ../common

CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  				  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -I$(COMMONDIR) -I.

CFLAGS_RV32IM 	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMB 	= $(CFLAGS_COMMON) -march=rv32imac_zbb -mabi=ilp32 -DRV32=1 -DBIT_INTERLEAVING -DRV32B
CFLAGS_RV32IMV 	= $(CFLAGS_COMMON) -march=rv32imacv -mabi=ilp32 -DRV32=1 -DVECTOR128
CFLAGS_RV32IMBV = $(CFLAGS_COMMON) -march=rv32imacv_zbb -mabi=ilp32 -DRV32=1 -DBIT_INTERLEAVING -DVECTOR128

CFLAGS_RV64IM 	= $(CFLAGS_COMMON) -march=rv64imac -mabi=lp64 -DRV64=1
CFLAGS_RV64IMB 	= $(CFLAGS_COMMON) -march=rv64imac_zba_zbb -mabi=lp64 -DRV64=1 -DRV64B
CFLAGS_RV64IMV 	= $(CFLAGS_COMMON) -march=rv64imacv -mabi=lp64 -DVECTOR128 -DRV64=1
CFLAGS_RV64IMBV = $(CFLAGS_COMMON) -march=rv64imacv_zba_zbb -mabi=lp64 -DVECTOR128 -DRV64=1

TARGET_IP 	= 192.168.123.99
TARGET_USER = root
TARGET_DIR  = /sharefs

SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h

.PHONY: all run_all clean

all: \
	out/cpi_rv32imb out/cpi_rv64imb out/cpi_rvv	\
	out/cpi_rv_vgroup	\
	out/cpi_ntt_rv32imv	\
	out/scp_speed

run_all: run_rv32imb run_rv64imb run_rvv run_rv_vgroup run_ntt_rv32imv

run_rv32imb: out/scp_speed
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./cpi_rv32imb" > cpi_rv32imb.txt

run_rv64imb: out/scp_speed
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./cpi_rv64imb" > cpi_rv64imb.txt

run_rvv: out/scp_speed
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./cpi_rvv" > cpi_rvv.txt

run_rv_vgroup: out/scp_speed
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./cpi_rv_vgroup" > cpi_rv_vgroup.txt

run_ntt_rv32imv: out/scp_speed
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./cpi_ntt_rv32imv" > cpi_ntt_rv32imv.txt

out/scp_speed:	\
	out/cpi_rv32imb out/cpi_rv64imb out/cpi_rvv	\
	out/cpi_rv_vgroup	\
	out/cpi_ntt_rv32imv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

out/cpi_rv32imb: $(SOURCES_COMMON) $(HEADERS_COMMON) test_rv_im.S test_cpi.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/cpi_rv64imb: $(SOURCES_COMMON) $(HEADERS_COMMON) test_rv_im.S test_cpi.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/cpi_rvv: $(SOURCES_COMMON) $(HEADERS_COMMON) test_rv_v.S test_cpi.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/cpi_rv_vgroup: $(SOURCES_COMMON) $(HEADERS_COMMON) test_rv_vgroup.S test_cpi_rv_vgroup.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/cpi_ntt_rv32imv: $(SOURCES_COMMON) $(HEADERS_COMMON) test_ntt.S test_cpi_ntt.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) $(filter %.c, $^) $(filter %.S, $^) -o $@

clean:
	rm -rf out/
