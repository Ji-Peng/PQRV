CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
SCP 	= scp

COMMONDIR 		= ../common

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

SOURCES			= speed_piism_sha3.c

.PHONY: all clean

all: \
	out/speed_piism_sha3_vr0	\
	out/speed_piism_sha3_vr1	\
	out/speed_piism_sha3_vr2	\
	out/speed_piism_sha3_vr3	\
	out/speed_piism_sha3_vr4	\
	out/speed_piism_sha3_ve0 	\
	out/speed_piism_sha3_ve1 	\
	out/speed_piism_sha3_ve2 	\
	out/scp_speed

out/scp_speed:	\
	out/speed_piism_sha3_vr0	\
	out/speed_piism_sha3_vr1	\
	out/speed_piism_sha3_vr2	\
	out/speed_piism_sha3_vr3	\
	out/speed_piism_sha3_vr4	\
	out/speed_piism_sha3_ve0	\
	out/speed_piism_sha3_ve1	\
	out/speed_piism_sha3_ve2
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

run: \
	out/speed_piism_sha3_vr0	\
	out/speed_piism_sha3_vr1	\
	out/speed_piism_sha3_vr2	\
	out/speed_piism_sha3_vr3	\
	out/speed_piism_sha3_vr4	\
	out/speed_piism_sha3_ve0 	\
	out/speed_piism_sha3_ve1 	\
	out/speed_piism_sha3_ve2 	\
	out/scp_speed
	@ssh $(TARGET_USER)@$(TARGET_IP) "bash -c '\
		cd $(TARGET_DIR) && \
		./speed_piism_sha3_vr0 && ./speed_piism_sha3_vr1 && ./speed_piism_sha3_vr2 && \
		./speed_piism_sha3_vr3 && ./speed_piism_sha3_vr4 && \
		echo -e \ && \
		./speed_piism_sha3_ve0 && ./speed_piism_sha3_ve1 && ./speed_piism_sha3_ve2 \
	'"

out/speed_piism_sha3_vr0: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr0.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_vr1: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr1.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_vr2: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr2.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_vr3: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr3.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_vr4: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_vr4.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DRIGHT_IMPL $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_ve0: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_ve0.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_ve1: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_ve1.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

out/speed_piism_sha3_ve2: $(SOURCES_COMMON) $(SOURCES) $(HEADERS_COMMON) fips202_rv64im_ve2.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@

clean:
	rm -rf out/
