CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
RM = /bin/rm

COMMONDIR 		= ../common
SOURCES 		= testRVp.S $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c

CFLAGS_RV64IM 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
	-Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
	-march=rv64imac -mabi=lp64 -I$(COMMONDIR) -DRV64=1

CFLAGS_RV32IM 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
	-Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
	-march=rv32imac -mabi=ilp32 -I$(COMMONDIR) -DRV32=1

TARGET_IP = 192.168.123.99

.PHONY: all

all: out/test_cpi_rv32im out/test_cpi_rv64im

out/test_cpi_rv32im: $(SOURCES) test_cpi.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_cpi_rv64im: $(SOURCES) test_cpi.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/


