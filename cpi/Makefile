CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
RM = /bin/rm

COMMONDIR 		= ../common
SOURCES 		= testRVp.S $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c

CFLAGS = -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
  -march=rv64imac -mabi=lp64 -I$(COMMONDIR)

TARGET_IP = 192.168.123.99

.PHONY: all

all: out/test_cpi

out/test_cpi: $(SOURCES) test_cpi.c
	mkdir -p out
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/


