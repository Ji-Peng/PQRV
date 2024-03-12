CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump

COMMONDIR = ../common
CFLAGS = -O3 -fomit-frame-pointer -static -flax-vector-conversions \
		 -march=rv64imacv_zba_zbb -mabi=lp64 -I$(COMMONDIR) -I.
RM = /bin/rm

SOURCES = add.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
HEADERS = $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h

TARGET_IP = 192.168.123.99

.PHONY: speed results clean

speed: \
	out/test_add out/test_vmul64 out/test_ntt

objdump:
	$(OBJDUMP) -D out/test_add > out/test_add.S

out/test_add: $(SOURCES) $(HEADERS)
	mkdir -p out
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_vmul64: vmul64.c vmul64.S
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_ntt: $(COMMONDIR)/ntt/ntt_rvv.S ntt.c $(COMMONDIR)/ntt/consts.c $(COMMONDIR)/ntt/consts.h $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

clean:
	-$(RM) -rf out/
