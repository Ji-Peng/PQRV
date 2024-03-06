CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump

COMMONDIR = ../common
CFLAGS = -O3 -fomit-frame-pointer -static -flax-vector-conversions \
		 -march=rv64imafdcv -mabi=lp64d -I$(COMMONDIR) -I.
RM = /bin/rm

SOURCES = add.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
HEADERS = $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h

TARGET_IP = 192.168.123.99

.PHONY: speed results clean

speed: \
	test_add test_vmul64

objdump:
	$(OBJDUMP) -D out/test_add > out/test_add.S

test_add: $(SOURCES) $(HEADERS)
	mkdir -p out
	$(CC) $(CFLAGS) $(SOURCES) -o out/test_add
	scp out/test_add root@$(TARGET_IP):/sharefs/

test_vmul64: vmul64.c vmul64.S
	$(CC) $(CFLAGS) vmul64.c vmul64.S -o out/test_vmul64
	scp out/test_vmul64 root@$(TARGET_IP):/sharefs/

clean:
	-$(RM) -rf out/
