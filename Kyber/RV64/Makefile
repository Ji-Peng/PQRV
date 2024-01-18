PLATFORM ?= C908

CC 		= riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump

COMMONDIR 		= ../common
CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
			  	  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -I$(COMMONDIR) -I.

ifeq ($(PLATFORM), C910)
	CFLAGS_RV64IM 	= $(CFLAGS_COMMON) -march=rv64imac -mabi=lp64
	CFLAGS_RV64IMB 	= $(CFLAGS_COMMON) -march=rv64imac_zba_zbb -mabi=lp64
	CFLAGS_RV64IMV 	= $(CFLAGS_COMMON) -DV0p7 -march=rv64imacv0p7 -mabi=lp64 \
		-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5 -DHYBRIDX6 -DHYBRIDX8
	CFLAGS_RV64IMBV = $(CFLAGS_COMMON) -DV0p7 -march=rv64imacv0p7_zba_zbb -mabi=lp64 \
		-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5 -DHYBRIDX6 -DHYBRIDX8
	TARGET_IP = 192.168.123.80
	TARGET_USER = sipeed
	TARGET_DIR  = /home/sipeed/PQRV
else
	CFLAGS_RV64IM 	= $(CFLAGS_COMMON) -march=rv64imac -mabi=lp64
	CFLAGS_RV64IMB 	= $(CFLAGS_COMMON) -march=rv64imac_zba_zbb -mabi=lp64
	CFLAGS_RV64IMV 	= $(CFLAGS_COMMON) -march=rv64imacv -mabi=lp64 \
		-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5 -DHYBRIDX6 -DHYBRIDX8
	CFLAGS_RV64IMBV = $(CFLAGS_COMMON) -march=rv64imacv_zba_zbb -mabi=lp64 \
		-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5 -DHYBRIDX6 -DHYBRIDX8
	TARGET_IP 	= 192.168.123.99
	TARGET_USER = root
	TARGET_DIR  = /sharefs
endif

RM = /bin/rm

SOURCES_RAND 	= $(COMMONDIR)/randombytes.c
HEADERS_RAND 	= $(COMMONDIR)/randombytes.h
SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c fips202.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h $(COMMONDIR)/fips202.h
SOURCES_RV64IM	= fips202_rv64im.S
SOURCES_RV64IMB	= fips202_rv64imb.S
SOURCES_RV64IMV	= fips202x.c fips202_rv64im.S fips202_rv64v.S fips202_rv64imv_hybrid_x3.S fips202_rv64imv_hybrid_x4.S fips202_rv64imv_hybrid_x5.S fips202_rv64imv_hybrid_x6.S fips202_rv64imv_hybrid_x8.S
SOURCES_RV64IMBV= fips202x.c fips202_rv64imb.S fips202_rv64v.S fips202_rv64imbv_hybrid_x3.S fips202_rv64imbv_hybrid_x4.S fips202_rv64imbv_hybrid_x5.S fips202_rv64imbv_hybrid_x6.S fips202_rv64imbv_hybrid_x8.S

SOURCES 		= $(SOURCES_COMMON) $(SOURCES_RAND) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS 		= $(HEADERS_COMMON) $(HEADERS_RAND) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.h verify.h symmetric.h
SOURCES_VECTOR 	= $(SOURCES_COMMON) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS_VECTOR 	= $(HEADERS_COMMON) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.c verify.h symmetric.h

.PHONY: all speed results clean

all: \
	test_kyber512_rv64im    test_kyber768_rv64im 	\
    test_kyber1024_rv64im   test_vectors512_rv64im 	\
    test_vectors768_rv64im  test_vectors1024_rv64im	\
	test_kyber512_rv64imb   test_kyber768_rv64imb 	\
    test_kyber1024_rv64imb  test_vectors512_rv64imb \
    test_vectors768_rv64imb test_vectors1024_rv64imb
	
# \
# test_kyber512_rv64imv   	test_kyber768_rv64imv 	\
# test_kyber1024_rv64imv  	test_vectors512_rv64imv 	\
# test_vectors768_rv64imv 	test_vectors1024_rv64imv

speed: \
	test_speed_sha3_rv64im test_speed_sha3_rv64imv test_speed_sha3_rv64imbv

# test_speed_sha3_rv64im 	\
# test_speed512_rv64im 	test_speed768_rv64im   	test_speed1024_rv64im	\
# test_speed_sha3_rv64imb \
# test_speed512_rv64imb	test_speed768_rv64imb   test_speed1024_rv64imb	\
# test_speed_sha3_rv64imv \
# test_speed_sha3_rv64imbv
	
# \
# test_speed512_rv64imv		test_speed768_rv64imv   	test_speed1024_rv64imv

# Get the file results*.txt from the target machine. Note that when executing commands like test_speed* on the target machine, the output results are redirected to results.txt.
# The commands executed on target machine include:
# ./test_speed_sha3_rv64im > results_rv64im.txt; ./test_speed512_rv64im >> results_rv64im.txt; ./test_speed768_rv64im >> results_rv64im.txt; ./test_speed1024_rv64im >> results_rv64im.txt
# ./test_speed_sha3_rv64imb > results_rv64imb.txt; ./test_speed512_rv64imb >> results_rv64imb.txt; ./test_speed768_rv64imb >> results_rv64imb.txt; ./test_speed1024_rv64imb >> results_rv64imb.txt
# ./test_speed_sha3_rv64imv > results_rv64imv.txt; ./test_speed512_rv64imv >> results_rv64imv.txt; ./test_speed768_rv64imv >> results_rv64imv.txt; ./test_speed1024_rv64imv >> results_rv64imv.txt
results:
	scp $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/results_rv64im.txt .
	scp $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/results_rv64imb.txt .
	scp $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/results_rv64imv.txt .

objdump:
	$(OBJDUMP) -D out/test_speed_sha3_rv64imv > out/test_speed_sha3_rv64imv.S

# for RV64IM

test_speed_sha3_rv64im: $(SOURCES_COMMON) $(SOURCES_RV64IM) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(SOURCES_COMMON) $(SOURCES_RV64IM) $(COMMONDIR)/test_sha3.c -o out/test_speed_sha3_rv64im
	scp out/test_speed_sha3_rv64im $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_kyber512_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber512_rv64im
	scp out/test_kyber512_rv64im $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_kyber768_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber768_rv64im
	scp out/test_kyber768_rv64im $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_kyber1024_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber1024_rv64im
	scp out/test_kyber1024_rv64im $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_vectors512_rv64im: $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(COMMONDIR)/test_vectors.c -o out/test_vectors512_rv64im
	scp out/test_vectors512_rv64im $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_vectors768_rv64im: $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(COMMONDIR)/test_vectors.c -o out/test_vectors768_rv64im
	scp out/test_vectors768_rv64im $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_vectors1024_rv64im: $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(COMMONDIR)/test_vectors.c -o out/test_vectors1024_rv64im
	scp out/test_vectors1024_rv64im $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_speed512_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_speed.c -o out/test_speed512_rv64im
	scp out/test_speed512_rv64im $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_speed768_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_speed.c -o out/test_speed768_rv64im
	scp out/test_speed768_rv64im $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_speed1024_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_speed.c -o out/test_speed1024_rv64im
	scp out/test_speed1024_rv64im $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# for RV64IMB

test_speed_sha3_rv64imb: $(SOURCES_COMMON) $(SOURCES_RV64IMB) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) $(SOURCES_COMMON) $(SOURCES_RV64IMB) $(COMMONDIR)/test_sha3.c -o out/test_speed_sha3_rv64imb
	scp out/test_speed_sha3_rv64imb $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_kyber512_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_kyber.c -o out/test_kyber512_rv64imb
	scp out/test_kyber512_rv64imb $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_kyber768_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_kyber.c -o out/test_kyber768_rv64imb
	scp out/test_kyber768_rv64imb $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_kyber1024_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_kyber.c -o out/test_kyber1024_rv64imb
	scp out/test_kyber1024_rv64imb $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_vectors512_rv64imb: $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(COMMONDIR)/test_vectors.c -o out/test_vectors512_rv64imb
	scp out/test_vectors512_rv64imb $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_vectors768_rv64imb: $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(COMMONDIR)/test_vectors.c -o out/test_vectors768_rv64imb
	scp out/test_vectors768_rv64imb $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_vectors1024_rv64imb: $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(COMMONDIR)/test_vectors.c -o out/test_vectors1024_rv64imb
	scp out/test_vectors1024_rv64imb $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_speed512_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_speed.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_speed.c -o out/test_speed512_rv64imb
	scp out/test_speed512_rv64imb $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_speed768_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_speed.c -o out/test_speed768_rv64imb
	scp out/test_speed768_rv64imb $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

test_speed1024_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_speed.c -o out/test_speed1024_rv64imb
	scp out/test_speed1024_rv64imb $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# for RV64IMV

test_speed_sha3_rv64imv: $(SOURCES_COMMON) $(SOURCES_RV64IMV) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) $(SOURCES_COMMON) $(SOURCES_RV64IMV) $(COMMONDIR)/test_sha3.c -o out/test_speed_sha3_rv64imv
	scp out/test_speed_sha3_rv64imv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_kyber512_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_kyber.c
# 	mkdir -p out
# 	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IMV) $(COMMONDIR)/test_kyber.c -o out/test_kyber512_rv64imv
# 	scp out/test_kyber512_rv64imv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_kyber768_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_kyber.c
# 	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IMV) $(COMMONDIR)/test_kyber.c -o out/test_kyber768_rv64imv
# 	scp out/test_kyber768_rv64imv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_kyber1024_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_kyber.c
# 	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IMV) $(COMMONDIR)/test_kyber.c -o out/test_kyber1024_rv64imv
# 	scp out/test_kyber1024_rv64imv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_vectors512_rv64imv: $(SOURCES_VECTOR) $(SOURCES_RV64IMV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
# 	mkdir -p out
# 	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=2 $(SOURCES_VECTOR) $(SOURCES_RV64IMV) $(COMMONDIR)/test_vectors.c -o out/test_vectors512_rv64imv
# 	scp out/test_vectors512_rv64imv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_vectors768_rv64imv: $(SOURCES_VECTOR) $(SOURCES_RV64IMV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
# 	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=3 $(SOURCES_VECTOR) $(SOURCES_RV64IMV) $(COMMONDIR)/test_vectors.c -o out/test_vectors768_rv64imv
# 	scp out/test_vectors768_rv64imv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_vectors1024_rv64imv: $(SOURCES_VECTOR) $(SOURCES_RV64IMV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
# 	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=4 $(SOURCES_VECTOR) $(SOURCES_RV64IMV) $(COMMONDIR)/test_vectors.c -o out/test_vectors1024_rv64imv
# 	scp out/test_vectors1024_rv64imv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_speed512_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_speed.c
# 	mkdir -p out
# 	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IMV) $(COMMONDIR)/test_speed.c -o out/test_speed512_rv64imv
# 	scp out/test_speed512_rv64imv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_speed768_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_speed.c
# 	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IMV) $(COMMONDIR)/test_speed.c -o out/test_speed768_rv64imv
# 	scp out/test_speed768_rv64imv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_speed1024_rv64imv: $(SOURCES) $(SOURCES_RV64IMV) $(HEADERS) $(COMMONDIR)/test_speed.c
# 	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IMV) $(COMMONDIR)/test_speed.c -o out/test_speed1024_rv64imv
# 	scp out/test_speed1024_rv64imv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# for RV64IMBV

test_speed_sha3_rv64imbv: $(SOURCES_COMMON) $(SOURCES_RV64IMBV) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV) $(SOURCES_COMMON) $(SOURCES_RV64IMBV) $(COMMONDIR)/test_sha3.c -o out/test_speed_sha3_rv64imbv
	scp out/test_speed_sha3_rv64imbv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_kyber512_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_kyber.c
# 	mkdir -p out
# 	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IMBV) $(COMMONDIR)/test_kyber.c -o out/test_kyber512_rv64imbv
# 	scp out/test_kyber512_rv64imbv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_kyber768_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_kyber.c
# 	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IMBV) $(COMMONDIR)/test_kyber.c -o out/test_kyber768_rv64imbv
# 	scp out/test_kyber768_rv64imbv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_kyber1024_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_kyber.c
# 	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IMBV) $(COMMONDIR)/test_kyber.c -o out/test_kyber1024_rv64imbv
# 	scp out/test_kyber1024_rv64imbv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_vectors512_rv64imbv: $(SOURCES_VECTOR) $(SOURCES_RV64IMBV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
# 	mkdir -p out
# 	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=2 $(SOURCES_VECTOR) $(SOURCES_RV64IMBV) $(COMMONDIR)/test_vectors.c -o out/test_vectors512_rv64imbv
# 	scp out/test_vectors512_rv64imbv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_vectors768_rv64imbv: $(SOURCES_VECTOR) $(SOURCES_RV64IMBV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
# 	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=3 $(SOURCES_VECTOR) $(SOURCES_RV64IMBV) $(COMMONDIR)/test_vectors.c -o out/test_vectors768_rv64imbv
# 	scp out/test_vectors768_rv64imbv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_vectors1024_rv64imbv: $(SOURCES_VECTOR) $(SOURCES_RV64IMBV) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
# 	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=4 $(SOURCES_VECTOR) $(SOURCES_RV64IMBV) $(COMMONDIR)/test_vectors.c -o out/test_vectors1024_rv64imbv
# 	scp out/test_vectors1024_rv64imbv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_speed512_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_speed.c
# 	mkdir -p out
# 	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IMBV) $(COMMONDIR)/test_speed.c -o out/test_speed512_rv64imbv
# 	scp out/test_speed512_rv64imbv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_speed768_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_speed.c
# 	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IMBV) $(COMMONDIR)/test_speed.c -o out/test_speed768_rv64imbv
# 	scp out/test_speed768_rv64imbv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

# test_speed1024_rv64imbv: $(SOURCES) $(SOURCES_RV64IMBV) $(HEADERS) $(COMMONDIR)/test_speed.c
# 	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IMBV) $(COMMONDIR)/test_speed.c -o out/test_speed1024_rv64imbv
# 	scp out/test_speed1024_rv64imbv $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/

clean:
	-$(RM) -rf out/
