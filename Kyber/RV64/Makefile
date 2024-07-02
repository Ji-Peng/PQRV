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
				  -DRV64=1 -I$(COMMONDIR) -I$(KECCAKDIR) -I$(NTTDIR) -I.

CFLAGS_RV64IM 	= $(CFLAGS_COMMON) -march=rv64imac -mabi=lp64 -DRV64IM
CFLAGS_RV64IMB 	= $(CFLAGS_COMMON) -march=rv64imac_zba_zbb -mabi=lp64 -DRV64IMB
CFLAGS_RV64IMV 	= $(CFLAGS_COMMON) -march=rv64imacv -mabi=lp64 -DRV64IMV \
	-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5 -DHYBRIDX6 -DHYBRIDX8
CFLAGS_RV64IMBV = $(CFLAGS_COMMON) -march=rv64imacv_zba_zbb -mabi=lp64 -DRV64IMBV \
	-DVECTOR128 -DHYBRIDX8
TARGET_IP = 192.168.123.99
TARGET_USER = root
TARGET_DIR  = /sharefs

RM = /bin/rm

SOURCES_RAND 	= $(COMMONDIR)/randombytes.c
HEADERS_RAND 	= $(COMMONDIR)/randombytes.h
SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c $(KECCAKDIR)/fips202_rv64.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h $(KECCAKDIR)/fips202.h $(KECCAKDIR)/fips202x.h
SOURCES_RV64IM	= $(KECCAKDIR)/fips202_rv64im.S $(NTTDIR)/ntt_dualissue_plant_rv64im.S
SOURCES_RV64IMB	= $(KECCAKDIR)/fips202_rv64imb.S $(NTTDIR)/ntt_dualissue_plant_rv64im.S
SOURCES_RV64IMV	= $(KECCAKDIR)/fips202x_rv64.c $(KECCAKDIR)/fips202_rv64im.S $(KECCAKDIR)/fips202_rv64v.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x3.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x4.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x5.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x6.S $(KECCAKDIR)/fips202_rv64imv_hybrid_x8.S $(NTTDIR)/ntt_rvv.S $(NTTDIR)/consts.c
SOURCES_RV64IMBV= $(KECCAKDIR)/fips202x_rv64.c $(KECCAKDIR)/fips202_rv64imb.S $(KECCAKDIR)/fips202_rv64v.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x3.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x4.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x5.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x6.S $(KECCAKDIR)/fips202_rv64imbv_hybrid_x8.S $(NTTDIR)/ntt_rvv.S $(NTTDIR)/consts.c

SOURCES 		= $(SOURCES_COMMON) $(SOURCES_RAND) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS 		= $(HEADERS_COMMON) $(HEADERS_RAND) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.h verify.h symmetric.h
SOURCES_VECTOR 	= $(SOURCES_COMMON) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS_VECTOR 	= $(HEADERS_COMMON) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.c verify.h symmetric.h

.PHONY: all speed results scp_vectors diff_vectors clean

all: \
	out/test_kyber512_rv64im    \
	out/test_kyber768_rv64im 	out/test_kyber1024_rv64im   \
	out/test_vectors512_rv64im 	\
	out/test_vectors768_rv64im  out/test_vectors1024_rv64im	\
	out/test_kyber512_rv64imb   \
	out/test_kyber768_rv64imb 	out/test_kyber1024_rv64imb  \
	out/test_vectors512_rv64imb \
    out/test_vectors768_rv64imb out/test_vectors1024_rv64imb\
	out/test_kyber512_rv64imv   \
	out/test_kyber768_rv64imv 	out/test_kyber1024_rv64imv  \
	out/test_vectors512_rv64imv \
	out/test_vectors768_rv64imv  out/test_vectors1024_rv64imv\
	out/test_kyber512_rv64imbv  \
	out/test_kyber768_rv64imbv 	out/test_kyber1024_rv64imbv  \
	out/test_vectors512_rv64imbv\
    out/test_vectors768_rv64imbv out/test_vectors1024_rv64imbv\
	out/scp_test
	
speed: \
	out/test_speed512_rv64im 		\
	out/test_speed768_rv64im   		out/test_speed1024_rv64im		\
	out/test_speed512_rv64imb		\
	out/test_speed768_rv64imb   	out/test_speed1024_rv64imb		\
	out/test_speed512_rv64imv		\
	out/test_speed768_rv64imv   	out/test_speed1024_rv64imv		\
	out/test_speed512_rv64imbv		\
	out/test_speed768_rv64imbv   	out/test_speed1024_rv64imbv		\
	out/scp_test_speed


# Get the file results*.txt from the target machine. Note that when executing commands like test_speed* on the target machine, the output results are redirected to results.txt.
# The commands executed on target machine include:
# ./test_speed512_rv64im > results_rv64im.txt; ./test_speed768_rv64im >> results_rv64im.txt; ./test_speed1024_rv64im >> results_rv64im.txt
# ./test_speed512_rv64imb > results_rv64imb.txt; ./test_speed768_rv64imb >> results_rv64imb.txt; ./test_speed1024_rv64imb >> results_rv64imb.txt
# ./test_speed512_rv64imv > results_rv64imv.txt; ./test_speed768_rv64imv >> results_rv64imv.txt; ./test_speed1024_rv64imv >> results_rv64imv.txt
# ./test_speed512_rv64imbv > results_rv64imbv.txt; ./test_speed768_rv64imbv >> results_rv64imbv.txt; ./test_speed1024_rv64imbv >> results_rv64imbv.txt
results:
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/results_rv64im.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/results_rv64imb.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/results_rv64imv.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/results_rv64imbv.txt .

# ./test_vectors512_rv64im > vectors_kyber512_rv64im.txt; ./test_vectors768_rv64im > vectors_kyber768_rv64im.txt; ./test_vectors1024_rv64im > vectors_kyber1024_rv64im.txt
# ./test_vectors512_rv64imb > vectors_kyber512_rv64imb.txt; ./test_vectors768_rv64imb > vectors_kyber768_rv64imb.txt; ./test_vectors1024_rv64imb > vectors_kyber1024_rv64imb.txt
# ./test_vectors512_rv64imv > vectors_kyber512_rv64imv.txt; ./test_vectors768_rv64imv > vectors_kyber768_rv64imv.txt; ./test_vectors1024_rv64imv > vectors_kyber1024_rv64imv.txt
# ./test_vectors512_rv64imbv > vectors_kyber512_rv64imbv.txt; ./test_vectors768_rv64imbv > vectors_kyber768_rv64imbv.txt; ./test_vectors1024_rv64imbv > vectors_kyber1024_rv64imbv.txt
scp_vectors:
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber512_rv64im.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber768_rv64im.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber1024_rv64im.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber512_rv64imb.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber768_rv64imb.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber1024_rv64imb.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber512_rv64imv.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber768_rv64imv.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber1024_rv64imv.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber512_rv64imbv.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber768_rv64imbv.txt .
	$(SCP) $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/vectors_kyber1024_rv64imbv.txt .

diff_vectors:
	diff vectors_kyber512_rv64im.txt ../ref/vectors_kyber512.txt
	diff vectors_kyber768_rv64im.txt ../ref/vectors_kyber768.txt
	diff vectors_kyber1024_rv64im.txt ../ref/vectors_kyber1024.txt
	diff vectors_kyber512_rv64imb.txt ../ref/vectors_kyber512.txt
	diff vectors_kyber768_rv64imb.txt ../ref/vectors_kyber768.txt
	diff vectors_kyber1024_rv64imb.txt ../ref/vectors_kyber1024.txt
	diff vectors_kyber512_rv64imv.txt ../ref/vectors_kyber512.txt
	diff vectors_kyber768_rv64imv.txt ../ref/vectors_kyber768.txt
	diff vectors_kyber1024_rv64imv.txt ../ref/vectors_kyber1024.txt
	diff vectors_kyber512_rv64imbv.txt ../ref/vectors_kyber512.txt
	diff vectors_kyber768_rv64imbv.txt ../ref/vectors_kyber768.txt
	diff vectors_kyber1024_rv64imbv.txt ../ref/vectors_kyber1024.txt


objdump:
	$(OBJDUMP) -D out/test_speed_sha3_rv64imv > out/test_speed_sha3_rv64imv.S

out/scp_test_speed:	\
	out/test_speed512_rv64im 		\
	out/test_speed768_rv64im   		out/test_speed1024_rv64im		\
	out/test_speed512_rv64imb		\
	out/test_speed768_rv64imb   	out/test_speed1024_rv64imb		\
	out/test_speed512_rv64imv		\
	out/test_speed768_rv64imv   	out/test_speed1024_rv64imv		\
	out/test_speed512_rv64imbv		\
	out/test_speed768_rv64imbv   	out/test_speed1024_rv64imbv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@
	
out/scp_test:	\
	out/test_kyber512_rv64im    \
	out/test_kyber768_rv64im 	out/test_kyber1024_rv64im   \
	out/test_vectors512_rv64im 	\
	out/test_vectors768_rv64im  out/test_vectors1024_rv64im	\
	out/test_kyber512_rv64imb   \
	out/test_kyber768_rv64imb 	out/test_kyber1024_rv64imb  \
	out/test_vectors512_rv64imb \
    out/test_vectors768_rv64imb out/test_vectors1024_rv64imb\
	out/test_kyber512_rv64imv   \
	out/test_kyber768_rv64imv 	out/test_kyber1024_rv64imv  \
	out/test_vectors512_rv64imv \
	out/test_vectors768_rv64imv  out/test_vectors1024_rv64imv\
	out/test_kyber512_rv64imbv  \
	out/test_kyber768_rv64imbv 	out/test_kyber1024_rv64imbv  \
	out/test_vectors512_rv64imbv\
    out/test_vectors768_rv64imbv out/test_vectors1024_rv64imbv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

# for RV64IM

out/test_kyber512_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv64im: $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv64im: $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv64im: $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMB

out/test_kyber512_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv64imb: $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv64imb: $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv64imb: $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMV

out/test_kyber512_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv64imv: $(SOURCES_VECTOR) $(SOURCES_RV64IMV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv64imv: $(SOURCES_VECTOR) $(SOURCES_RV64IMV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv64imv: $(SOURCES_VECTOR) $(SOURCES_RV64IMV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMBV

out/test_kyber512_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv64imbv: $(SOURCES_VECTOR) $(SOURCES_RV64IMBV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv64imbv: $(SOURCES_VECTOR) $(SOURCES_RV64IMBV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv64imbv: $(SOURCES_VECTOR) $(SOURCES_RV64IMBV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

clean:
	-$(RM) -rf out/
