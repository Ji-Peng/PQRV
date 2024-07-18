PLATFORM ?= C908

CC 		= riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
SCP 	= scp
# SCP		= @:

COMMONDIR 		= ../../common
KECCAKDIR		= ../../sha3
NTTDIR			= ../../ntt/kyber

CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
				  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -DRV32=1 -I$(COMMONDIR) -I$(KECCAKDIR) -I$(NTTDIR) -I.

CFLAGS_RV32IM  	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32 -DRV32IM
CFLAGS_RV32IMB 	= $(CFLAGS_COMMON) -march=rv32imac_zbb -mabi=ilp32 -DRV32IMB \
	-DBIT_INTERLEAVING
CFLAGS_RV32IMV 	= $(CFLAGS_COMMON) -march=rv32imacv -mabi=ilp32 -DRV32IMV \
	-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4
CFLAGS_RV32IMBV = $(CFLAGS_COMMON) -march=rv32imacv_zbb -mabi=ilp32 -DRV32IMBV \
	-DBIT_INTERLEAVING \
	-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5
TARGET_IP = 192.168.123.99
TARGET_USER = root
TARGET_DIR  = /sharefs

RM = /bin/rm

SOURCES_RAND 	= $(COMMONDIR)/randombytes.c
HEADERS_RAND 	= $(COMMONDIR)/randombytes.h
SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c $(KECCAKDIR)/fips202_rv32.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h $(KECCAKDIR)/fips202.h $(KECCAKDIR)/fips202x.h
SOURCES_RV32IM  = $(KECCAKDIR)/fips202_rv32im.S $(NTTDIR)/ntt_dualissue_plant_rv32im.S
SOURCES_RV32IMB = $(KECCAKDIR)/fips202_rv32imb_bitinter.S $(NTTDIR)/ntt_dualissue_plant_rv32im.S
SOURCES_RV32IMV = $(KECCAKDIR)/fips202x_rv32.c $(KECCAKDIR)/fips202_rv32im.S $(KECCAKDIR)/fips202_rv32v.S $(KECCAKDIR)/fips202_rv32imv_hybrid_x3.S $(KECCAKDIR)/fips202_rv32imv_hybrid_x4.S $(NTTDIR)/ntt_rvv.S $(NTTDIR)/consts.c
SOURCES_RV32IMBV= $(KECCAKDIR)/fips202x_rv32.c $(KECCAKDIR)/fips202_rv32imb_bitinter.S $(KECCAKDIR)/fips202_rv32v.S $(KECCAKDIR)/fips202_rv32imbv_hybrid_x3.S $(KECCAKDIR)/fips202_rv32imbv_hybrid_x4.S $(KECCAKDIR)/fips202_rv32imbv_hybrid_x5.S $(NTTDIR)/ntt_rvv.S $(NTTDIR)/consts.c

SOURCES 		= $(SOURCES_COMMON) $(SOURCES_RAND) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS 		= $(HEADERS_COMMON) $(HEADERS_RAND) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.h verify.h symmetric.h
SOURCES_VECTOR 	= $(SOURCES_COMMON) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS_VECTOR 	= $(HEADERS_COMMON) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.c verify.h symmetric.h

.PHONY: all speed run_speed run_diff_vectors clean

all: \
	out/test_kyber512_rv32im    	\
	out/test_kyber768_rv32im      	out/test_kyber1024_rv32im   	\
	out/test_vectors512_rv32im		\
	out/test_vectors768_rv32im		out/test_vectors1024_rv32im   	\
	out/test_kyber512_rv32imb   	\
	out/test_kyber768_rv32imb     	out/test_kyber1024_rv32imb  	\
	out/test_vectors512_rv32imb		\
	out/test_vectors768_rv32imb		out/test_vectors1024_rv32imb  	\
	out/test_kyber512_rv32imv    	\
	out/test_kyber768_rv32imv      	out/test_kyber1024_rv32imv   	\
	out/test_vectors512_rv32imv		\
	out/test_vectors768_rv32imv		out/test_vectors1024_rv32imv   	\
	out/test_kyber512_rv32imbv   	\
	out/test_kyber768_rv32imbv     	out/test_kyber1024_rv32imbv  	\
	out/test_vectors512_rv32imbv	\
	out/test_vectors768_rv32imbv	out/test_vectors1024_rv32imbv  	\
	out/scp_test

speed: \
	out/test_speed512_rv32im  		\
	out/test_speed768_rv32im  		out/test_speed1024_rv32im		\
	out/test_speed512_rv32imb 		\
	out/test_speed768_rv32imb 		out/test_speed1024_rv32imb 		\
	out/test_speed512_rv32imv		\
	out/test_speed768_rv32imv		out/test_speed1024_rv32imv		\
	out/test_speed512_rv32imbv		\
	out/test_speed768_rv32imbv		out/test_speed1024_rv32imbv		\
	out/scp_test_speed

run_speed: out/scp_test_speed
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv32im; ./test_speed768_rv32im; ./test_speed1024_rv32im" > results_rv32im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv32imb; ./test_speed768_rv32imb; ./test_speed1024_rv32imb" > results_rv32imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv32imv; ./test_speed768_rv32imv; ./test_speed1024_rv32imv" > results_rv32imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv32imbv; ./test_speed768_rv32imbv; ./test_speed1024_rv32imbv" > results_rv32imbv.txt

run_diff_vectors: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors512_rv32im" > vectors_kyber512_rv32im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors768_rv32im" > vectors_kyber768_rv32im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors1024_rv32im" > vectors_kyber1024_rv32im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors512_rv32imb" > vectors_kyber512_rv32imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors768_rv32imb" > vectors_kyber768_rv32imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors1024_rv32imb" > vectors_kyber1024_rv32imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors512_rv32imv" > vectors_kyber512_rv32imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors768_rv32imv" > vectors_kyber768_rv32imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors1024_rv32imv" > vectors_kyber1024_rv32imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors512_rv32imbv" > vectors_kyber512_rv32imbv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors768_rv32imbv" > vectors_kyber768_rv32imbv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors1024_rv32imbv" > vectors_kyber1024_rv32imbv.txt
	diff vectors_kyber512_rv32im.txt ../ref/vectors_kyber512.txt
	diff vectors_kyber768_rv32im.txt ../ref/vectors_kyber768.txt
	diff vectors_kyber1024_rv32im.txt ../ref/vectors_kyber1024.txt
	diff vectors_kyber512_rv32imb.txt ../ref/vectors_kyber512.txt
	diff vectors_kyber768_rv32imb.txt ../ref/vectors_kyber768.txt
	diff vectors_kyber1024_rv32imb.txt ../ref/vectors_kyber1024.txt
	diff vectors_kyber512_rv32imv.txt ../ref/vectors_kyber512.txt
	diff vectors_kyber768_rv32imv.txt ../ref/vectors_kyber768.txt
	diff vectors_kyber1024_rv32imv.txt ../ref/vectors_kyber1024.txt
	diff vectors_kyber512_rv32imbv.txt ../ref/vectors_kyber512.txt
	diff vectors_kyber768_rv32imbv.txt ../ref/vectors_kyber768.txt
	diff vectors_kyber1024_rv32imbv.txt ../ref/vectors_kyber1024.txt

out/scp_test_speed: \
	out/test_speed512_rv32im	\
	out/test_speed768_rv32im	out/test_speed1024_rv32im			\
	out/test_speed512_rv32imb	\
	out/test_speed768_rv32imb	out/test_speed1024_rv32imb			\
	out/test_speed512_rv32imv	\
	out/test_speed768_rv32imv	out/test_speed1024_rv32imv			\
	out/test_speed512_rv32imbv	\
	out/test_speed768_rv32imbv	out/test_speed1024_rv32imbv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@
	
out/scp_test:	\
	out/test_kyber512_rv32im    	\
	out/test_kyber768_rv32im      	out/test_kyber1024_rv32im   	\
	out/test_vectors512_rv32im		\
	out/test_vectors768_rv32im		out/test_vectors1024_rv32im   	\
	out/test_kyber512_rv32imb   	\
	out/test_kyber768_rv32imb     	out/test_kyber1024_rv32imb  	\
	out/test_vectors512_rv32imb		\
	out/test_vectors768_rv32imb		out/test_vectors1024_rv32imb  	\
	out/test_kyber512_rv32imv    	\
	out/test_kyber768_rv32imv      	out/test_kyber1024_rv32imv   	\
	out/test_vectors512_rv32imv		\
	out/test_vectors768_rv32imv		out/test_vectors1024_rv32imv   	\
	out/test_kyber512_rv32imbv   	\
	out/test_kyber768_rv32imbv     	out/test_kyber1024_rv32imbv  	\
	out/test_vectors512_rv32imbv	\
	out/test_vectors768_rv32imbv	out/test_vectors1024_rv32imbv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

# for RV32IM

out/test_kyber512_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv32im: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv32im: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv32im: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMB

out/test_kyber512_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv32imb: $(SOURCES_VECTOR) $(SOURCES_RV32IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv32imb: $(SOURCES_VECTOR) $(SOURCES_RV32IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv32imb: $(SOURCES_VECTOR) $(SOURCES_RV32IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMV

out/test_kyber512_rv32imv: $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv32imv: $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv32imv: $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv32imv: $(SOURCES_VECTOR) $(SOURCES_RV32IMV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv32imv: $(SOURCES_VECTOR) $(SOURCES_RV32IMV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv32imv: $(SOURCES_VECTOR) $(SOURCES_RV32IMV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv32imv: $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv32imv: $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv32imv: $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMBV

out/test_kyber512_rv32imbv: $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv32imbv: $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv32imbv: $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv32imbv: $(SOURCES_VECTOR) $(SOURCES_RV32IMBV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv32imbv: $(SOURCES_VECTOR) $(SOURCES_RV32IMBV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv32imbv: $(SOURCES_VECTOR) $(SOURCES_RV32IMBV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv32imbv: $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv32imbv: $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv32imbv: $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

clean:
	-$(RM) -rf out/
