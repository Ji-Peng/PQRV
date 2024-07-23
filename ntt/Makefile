CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
SCP 	= scp

COMMONDIR 		= ../common
KYBERNTTDIR		= ./kyber
DILITHIUMNTTDIR = ./dilithium

CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  				  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -I$(COMMONDIR) -I.

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

SOURCES			= speed_ntt.c

.PHONY: all run_all clean

all: \
	out/speed_singleissue_kyber_plantard_ntt_rv32	\
	out/speed_dualissue_kyber_plantard_ntt_rv32		\
	out/speed_singleissue_kyber_plantard_ntt_rv64	\
	out/speed_dualissue_kyber_plantard_ntt_rv64		\
	out/speed_dualissue_kyber_plantard_l32_ntt_rv64	\
	out/speed_singleissue_dilithium_mont_ntt_rv32	\
	out/speed_dualissue_dilithium_mont_ntt_rv32		\
	out/speed_dualissue_dilithium_plant_ntt_rv64		\
	out/speed_dualissue_kyber_mont_ntt_rv32			\
	out/speed_dualissue_kyber_mont_ntt_rvv			\
	out/speed_dualissue_dilithium_mont_ntt_rvv		\
	out/scp_speed

run_all: out/scp_speed
	@echo "speed_singleissue_kyber_plantard_ntt_rv32:" > speed_ntt.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_singleissue_kyber_plantard_ntt_rv32" >> speed_ntt.txt
	@echo "\nspeed_dualissue_kyber_plantard_ntt_rv32:" >> speed_ntt.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_dualissue_kyber_plantard_ntt_rv32" >> speed_ntt.txt
	@echo "\nspeed_singleissue_kyber_plantard_ntt_rv64:" >> speed_ntt.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_singleissue_kyber_plantard_ntt_rv64" >> speed_ntt.txt
	@echo "\nspeed_dualissue_kyber_plantard_ntt_rv64:" >> speed_ntt.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_dualissue_kyber_plantard_ntt_rv64" >> speed_ntt.txt
	@echo "\nspeed_dualissue_kyber_plantard_l32_ntt_rv64:" >> speed_ntt.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_dualissue_kyber_plantard_l32_ntt_rv64" >> speed_ntt.txt
	@echo "\nspeed_dualissue_kyber_mont_ntt_rv32:" >> speed_ntt.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_dualissue_kyber_mont_ntt_rv32" >> speed_ntt.txt
	@echo "\nspeed_dualissue_kyber_mont_ntt_rvv:" >> speed_ntt.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_dualissue_kyber_mont_ntt_rvv" >> speed_ntt.txt
	@echo "\nspeed_singleissue_dilithium_mont_ntt_rv32:" >> speed_ntt.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_singleissue_dilithium_mont_ntt_rv32" >> speed_ntt.txt
	@echo "\nspeed_dualissue_dilithium_mont_ntt_rv32:" >> speed_ntt.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_dualissue_dilithium_mont_ntt_rv32" >> speed_ntt.txt
	@echo "\nspeed_dualissue_dilithium_plant_ntt_rv64:" >> speed_ntt.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_dualissue_dilithium_plant_ntt_rv64" >> speed_ntt.txt
	@echo "\nspeed_dualissue_dilithium_mont_ntt_rvv:" >> speed_ntt.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./speed_dualissue_dilithium_mont_ntt_rvv" >> speed_ntt.txt

out/scp_speed:	\
	out/speed_singleissue_kyber_plantard_ntt_rv32	\
	out/speed_dualissue_kyber_plantard_ntt_rv32		\
	out/speed_singleissue_kyber_plantard_ntt_rv64	\
	out/speed_dualissue_kyber_plantard_ntt_rv64		\
	out/speed_dualissue_kyber_plantard_l32_ntt_rv64	\
	out/speed_singleissue_dilithium_mont_ntt_rv32	\
	out/speed_dualissue_dilithium_mont_ntt_rv32		\
	out/speed_dualissue_dilithium_plant_ntt_rv64		\
	out/speed_dualissue_kyber_mont_ntt_rv32			\
	out/speed_dualissue_kyber_mont_ntt_rvv			\
	out/speed_dualissue_dilithium_mont_ntt_rvv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

out/speed_singleissue_kyber_plantard_ntt_rv32: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) $(KYBERNTTDIR)/ntt_singleissue_plant_rv32im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -I$(KYBERNTTDIR) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_dualissue_kyber_plantard_ntt_rv32: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) $(KYBERNTTDIR)/ntt_dualissue_plant_rv32im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -I$(KYBERNTTDIR) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_singleissue_kyber_plantard_ntt_rv64: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) $(KYBERNTTDIR)/ntt_singleissue_plant_rv64im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -I$(KYBERNTTDIR) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_dualissue_kyber_plantard_ntt_rv64: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) $(KYBERNTTDIR)/ntt_dualissue_plant_rv64im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -I$(KYBERNTTDIR) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_dualissue_kyber_plantard_l32_ntt_rv64: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) $(KYBERNTTDIR)/ntt_dualissue_l32_plant_rv64im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -I$(KYBERNTTDIR) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_singleissue_dilithium_mont_ntt_rv32: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) $(DILITHIUMNTTDIR)/ntt_8l_singleissue_mont_rv32im.S $(DILITHIUMNTTDIR)/ntt_6l_singleissue_mont_rv32im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -I$(DILITHIUMNTTDIR) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_dualissue_dilithium_mont_ntt_rv32: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) $(DILITHIUMNTTDIR)/ntt_8l_dualissue_mont_rv32im.S $(DILITHIUMNTTDIR)/ntt_6l_dualissue_mont_rv32im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -I$(DILITHIUMNTTDIR) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_dualissue_dilithium_plant_ntt_rv64: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) $(DILITHIUMNTTDIR)/ntt_8l_dualissue_plant_rv64im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -I$(DILITHIUMNTTDIR) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_dualissue_kyber_mont_ntt_rv32: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) $(KYBERNTTDIR)/ntt_dualissue_mont_rv32im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -I$(KYBERNTTDIR) -DKYBER_RV32_MONT $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_dualissue_kyber_mont_ntt_rvv: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) $(KYBERNTTDIR)/ntt_rvv.S $(KYBERNTTDIR)/consts.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) -I$(KYBERNTTDIR) -DRVV $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_dualissue_dilithium_mont_ntt_rvv: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) $(DILITHIUMNTTDIR)/ntt_rvv.S $(DILITHIUMNTTDIR)/basemul_acc_double.S $(DILITHIUMNTTDIR)/consts.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) -I$(DILITHIUMNTTDIR) -DRVV $(filter %.c, $^) $(filter %.S, $^) -o $@

clean:
	rm -rf out/
