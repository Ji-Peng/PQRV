CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump

COMMONDIR 		= ../common
KYBERNTTDIR		= ../ntt/kyber
DILITHIUMNTTDIR	= ../ntt/dilithium

CFLAGS = -O3 -fomit-frame-pointer -static -flax-vector-conversions \
		 -march=rv64imafdcv_zba_zbb -mabi=lp64d -I$(COMMONDIR) -I$(KYBERNTTDIR) -I.
CFLAGS_RV32IMBV = -O3 -fomit-frame-pointer -static -flax-vector-conversions \
		 -march=rv32imacv_zbb -mabi=ilp32 -DVECTOR128 -DRV32=1 -I$(COMMONDIR) -I$(KYBERNTTDIR) -I.
CFLAGS_RV32IM 	= -O3 -fomit-frame-pointer -static -flax-vector-conversions \
		 -march=rv32imac -mabi=ilp32 -DRV32=1 -I$(COMMONDIR) -I$(DILITHIUMNTTDIR) -I.
CFLAGS_RV64IM 	= -O3 -fomit-frame-pointer -static -flax-vector-conversions \
		 -march=rv64imac -mabi=lp64 -DRV64=1 -I$(COMMONDIR) -I$(DILITHIUMNTTDIR) -I.
CFLAGS_RV64IMBV = -O3 -fomit-frame-pointer -static -flax-vector-conversions \
		 -march=rv64imacv_zba_zbb -mabi=lp64 -DVECTOR128 -DRV64=1 -I$(COMMONDIR) -I$(DILITHIUMNTTDIR) -I.

RM = /bin/rm

SOURCES = add.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
HEADERS = $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h

TARGET_IP = 192.168.123.99

.PHONY: all results clean

all: \
	out/test_add

# out/test_dilithium_mont_rv32imv
# out/test_kyber_ntt_rvv
# out/test_dilithium_mont_rv32imv
# out/test_dilithium_mont_rv64imv
# out/test_dilithium_singleissue_plant_ntt_rv64 out/test_dilithium_dualissue_plant_ntt_rv64
# out/test_kyber_hybrid_ntt_rv32v
# out/test_kyber_mont_ntt_rv32
# out/test_add64 out/test_dilithium_ntt
# out/test_add  out/test_mul out/test_ntt out/test_ntt_rv32 out/test_hybrido ut/test_plantard out/test_plantard_rv64 out/test_ntt_rv32im out/test_ntt_rv64im

objdump:
	$(OBJDUMP) -D out/test_add > out/test_add.S

out/test_kyber_ntt_rvv: test_kyber_ntt_rvv.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c $(KYBERNTTDIR)/ntt_rvv.S $(KYBERNTTDIR)/consts.c $(KYBERNTTDIR)/consts.h
	mkdir -p out
	$(CC) -I$(KYBERNTTDIR) $(CFLAGS_RV32IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_dilithium_mont_rv32imv: test_dilithium_mont_rvv.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c $(DILITHIUMNTTDIR)/ntt_rvv.S $(DILITHIUMNTTDIR)/consts.c $(DILITHIUMNTTDIR)/consts.h
	mkdir -p out
	$(CC) -I$(DILITHIUMNTTDIR) $(CFLAGS_RV32IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_dilithium_mont_rv64imv: test_dilithium_mont_rvv.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c $(DILITHIUMNTTDIR)/ntt_rvv.S $(DILITHIUMNTTDIR)/consts.c $(DILITHIUMNTTDIR)/consts.h
	mkdir -p out
	$(CC) -I$(DILITHIUMNTTDIR) $(CFLAGS_RV64IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_dilithium_singleissue_plant_ntt_rv64: test_dilithium_plant_ntt_rv64.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c $(DILITHIUMNTTDIR)/ntt_8l_singleissue_plant_rv64im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_dilithium_dualissue_plant_ntt_rv64: test_dilithium_plant_ntt_rv64.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c $(DILITHIUMNTTDIR)/ntt_8l_dualissue_plant_rv64im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_kyber_mont_ntt_rv32: test_kyber_mont_ntt_rv32.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c $(KYBERNTTDIR)/ntt_dualissue_mont_rv32im.S
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_dilithium_ntt: $(DILITHIUMNTTDIR)/ntt_6l_singleissue_mont_rv32im.S $(DILITHIUMNTTDIR)/ntt_8l_dualissue_mont_rv32im.S test_dilithium_ntt.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_add: $(SOURCES) $(HEADERS)
	mkdir -p out
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_add64: add64.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_mul: vmul.c vmul.S
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_ntt: $(KYBERNTTDIR)/ntt_rvv.S ntt.c $(KYBERNTTDIR)/consts.c $(KYBERNTTDIR)/consts.h $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_ntt_rv32: $(KYBERNTTDIR)/ntt_rvv.S ntt.c $(KYBERNTTDIR)/consts.c $(KYBERNTTDIR)/consts.h $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_hybrid: $(KYBERNTTDIR)/test_hybrid.S test_hybrid.c $(KYBERNTTDIR)/consts.c $(KYBERNTTDIR)/consts.h $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_plantard: $(KYBERNTTDIR)/ntt_singleissue_plant_rv32im.S test_plantard.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_plantard_rv64: $(KYBERNTTDIR)/ntt_singleissue_plant_rv64im.S test_plantard_rv64.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_ntt_rv32im: $(KYBERNTTDIR)/ntt_singleissue_plant_rv32im.S test_ntt_rv32im.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_ntt_rv64im: $(KYBERNTTDIR)/ntt_singleissue_plant_rv64im.S test_ntt_rv64im.c $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
	mkdir -p out
	$(CC) $(CFLAGS) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

clean:
	-$(RM) -rf out/
