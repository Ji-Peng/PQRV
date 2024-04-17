CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump

COMMONDIR = ../common
CFLAGS = -O3 -fomit-frame-pointer -static -flax-vector-conversions \
		 -march=rv64imafdcv_zba_zbb -mabi=lp64d -I$(COMMONDIR) -I$(COMMONDIR)/kyber_ntt -I.
CFLAGS_RV32IMBV = -O3 -fomit-frame-pointer -static -flax-vector-conversions \
		 -march=rv32imacv_zbb -mabi=ilp32 -DRV32=1 -I$(COMMONDIR) -I$(COMMONDIR)/kyber_ntt -I.
RM = /bin/rm

SOURCES = add.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
HEADERS = $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h

TARGET_IP = 192.168.123.99

.PHONY: speed results clean

speed: \
	out/test_add out/test_mul out/test_ntt out/test_ntt_rv32 out/test_hybrid

objdump:
	$(OBJDUMP) -D out/test_add > out/test_add.S

out/test_add: $(SOURCES) $(HEADERS)
	mkdir -p out
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_mul: vmul.c vmul.S
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_ntt: $(COMMONDIR)/kyber_ntt/ntt_rvv.S ntt.c $(COMMONDIR)/kyber_ntt/consts.c $(COMMONDIR)/kyber_ntt/consts.h $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_ntt_rv32: $(COMMONDIR)/kyber_ntt/ntt_rvv.S ntt.c $(COMMONDIR)/kyber_ntt/consts.c $(COMMONDIR)/kyber_ntt/consts.h $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_hybrid: $(COMMONDIR)/kyber_ntt/test_hybrid.S test_hybrid.c $(COMMONDIR)/kyber_ntt/consts.c $(COMMONDIR)/kyber_ntt/consts.h $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

clean:
	-$(RM) -rf out/
