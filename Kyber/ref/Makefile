PLATFORM ?= C908

CC 		= riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
SCP 	= scp
# SCP		= @:

COMMONDIR 		= ../../common
KECCAKDIR		= ../../sha3
CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  				  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -I$(COMMONDIR) -I$(KECCAKDIR) -I. -DREF_IMPL

CFLAGS_RV32IM 	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMB 	= $(CFLAGS_COMMON) -march=rv32imac_zbb -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMV 	= $(CFLAGS_COMMON) -march=rv32imacv -mabi=ilp32 -DRV32=1
CFLAGS_RV32IMBV = $(CFLAGS_COMMON) -march=rv32imacv_zbb -mabi=ilp32 -DRV32=1

CFLAGS_RV64IM 	= $(CFLAGS_COMMON) -march=rv64imac -mabi=lp64
CFLAGS_RV64IMB 	= $(CFLAGS_COMMON) -march=rv64imac_zba_zbb -mabi=lp64
CFLAGS_RV64IMV 	= $(CFLAGS_COMMON) -march=rv64imacv -mabi=lp64
CFLAGS_RV64IMBV = $(CFLAGS_COMMON) -march=rv64imacv_zba_zbb -mabi=lp64

TARGET_IP 	= 192.168.123.99
TARGET_USER = root
TARGET_DIR  = /sharefs

RM = /bin/rm

SOURCES_RAND 	= $(COMMONDIR)/randombytes.c
HEADERS_RAND 	= $(COMMONDIR)/randombytes.h
SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(KECCAKDIR)/fips202_ref.c $(COMMONDIR)/speed_print.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(KECCAKDIR)/fips202.h $(COMMONDIR)/speed_print.h

SOURCES 		= $(SOURCES_COMMON) $(SOURCES_RAND) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS 		= $(HEADERS_COMMON) $(HEADERS_RAND) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.h verify.h symmetric.h
SOURCES_VECTOR 	= $(SOURCES_COMMON) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS_VECTOR 	= $(HEADERS_COMMON) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.c verify.h symmetric.h

.PHONY: all speed run_speed run_gen_vectors clean

all: \
	out/test_kyber512_rv32im 	 out/test_kyber768_rv32im 		out/test_kyber1024_rv32im 		\
	out/test_vectors512_rv32im 	 out/test_vectors768_rv32im 	out/test_vectors1024_rv32im 	\
	out/test_kyber512_rv32imb 	 out/test_kyber768_rv32imb 		out/test_kyber1024_rv32imb 		\
	out/test_vectors512_rv32imb  out/test_vectors768_rv32imb 	out/test_vectors1024_rv32imb	\
	out/test_kyber512_rv32imv	 out/test_kyber768_rv32imv		out/test_kyber1024_rv32imv		\
	out/test_vectors512_rv32imv	 out/test_vectors768_rv32imv	out/test_vectors1024_rv32imv	\
	out/test_kyber512_rv32imbv 	 out/test_kyber768_rv32imbv 	out/test_kyber1024_rv32imbv 	\
	out/test_vectors512_rv32imbv out/test_vectors768_rv32imbv 	out/test_vectors1024_rv32imbv	\
	out/test_kyber512_rv64im	 out/test_kyber768_rv64im		out/test_kyber1024_rv64im  		\
    out/test_vectors512_rv64im 	 out/test_vectors768_rv64im		out/test_vectors1024_rv64im 	\
	out/test_kyber512_rv64imb	 out/test_kyber768_rv64imb		out/test_kyber1024_rv64imb  	\
    out/test_vectors512_rv64imb  out/test_vectors768_rv64imb	out/test_vectors1024_rv64imb	\
	out/test_kyber512_rv64imv	 out/test_kyber768_rv64imv		out/test_kyber1024_rv64imv  	\
    out/test_vectors512_rv64imv  out/test_vectors768_rv64imv	out/test_vectors1024_rv64imv	\
	out/test_kyber512_rv64imbv	 out/test_kyber768_rv64imbv		out/test_kyber1024_rv64imbv  	\
    out/test_vectors512_rv64imbv out/test_vectors768_rv64imbv 	out/test_vectors1024_rv64imbv	\
	out/scp_test

speed: \
	out/test_speed512_rv32im 	out/test_speed768_rv32im 	out/test_speed1024_rv32im 			\
	out/test_speed512_rv32imb 	out/test_speed768_rv32imb 	out/test_speed1024_rv32imb			\
	out/test_speed512_rv32imv 	out/test_speed768_rv32imv 	out/test_speed1024_rv32imv 			\
	out/test_speed512_rv32imbv 	out/test_speed768_rv32imbv 	out/test_speed1024_rv32imbv			\
	out/test_speed512_rv64im	out/test_speed768_rv64im	out/test_speed1024_rv64im 			\
	out/test_speed512_rv64imb	out/test_speed768_rv64imb	out/test_speed1024_rv64imb			\
	out/test_speed512_rv64imv	out/test_speed768_rv64imv	out/test_speed1024_rv64imv 			\
	out/test_speed512_rv64imbv	out/test_speed768_rv64imbv	out/test_speed1024_rv64imbv			\
	out/scp_test_speed

run_speed: out/scp_test_speed
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv32im; ./test_speed768_rv32im; ./test_speed1024_rv32im" > results_rv32im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv32imb; ./test_speed768_rv32imb; ./test_speed1024_rv32imb" > results_rv32imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv32imv; ./test_speed768_rv32imv; ./test_speed1024_rv32imv" > results_rv32imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv32imbv; ./test_speed768_rv32imbv; ./test_speed1024_rv32imbv" > results_rv32imbv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv64im; ./test_speed768_rv64im; ./test_speed1024_rv64im" > results_rv64im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv64imb; ./test_speed768_rv64imb; ./test_speed1024_rv64imb" > results_rv64imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv64imv; ./test_speed768_rv64imv; ./test_speed1024_rv64imv" > results_rv64imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv64imbv; ./test_speed768_rv64imbv; ./test_speed1024_rv64imbv" > results_rv64imbv.txt

run_gen_vectors: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors512_rv32im" > vectors_kyber512.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors768_rv32im" > vectors_kyber768.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors1024_rv32im" > vectors_kyber1024.txt

out/scp_test_speed:	\
	out/test_speed512_rv32im 	out/test_speed768_rv32im 	out/test_speed1024_rv32im 	\
	out/test_speed512_rv32imb 	out/test_speed768_rv32imb 	out/test_speed1024_rv32imb	\
	out/test_speed512_rv32imv 	out/test_speed768_rv32imv 	out/test_speed1024_rv32imv 	\
	out/test_speed512_rv32imbv 	out/test_speed768_rv32imbv 	out/test_speed1024_rv32imbv	\
	out/test_speed512_rv64im	out/test_speed768_rv64im	out/test_speed1024_rv64im 	\
	out/test_speed512_rv64imb	out/test_speed768_rv64imb	out/test_speed1024_rv64imb	\
	out/test_speed512_rv64imv	out/test_speed768_rv64imv	out/test_speed1024_rv64imv 	\
	out/test_speed512_rv64imbv	out/test_speed768_rv64imbv	out/test_speed1024_rv64imbv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@
	
out/scp_test:	\
	out/test_kyber512_rv32im 	 out/test_kyber768_rv32im 		out/test_kyber1024_rv32im 		\
	out/test_vectors512_rv32im 	 out/test_vectors768_rv32im 	out/test_vectors1024_rv32im 	\
	out/test_kyber512_rv32imb 	 out/test_kyber768_rv32imb 		out/test_kyber1024_rv32imb 		\
	out/test_vectors512_rv32imb  out/test_vectors768_rv32imb 	out/test_vectors1024_rv32imb	\
	out/test_kyber512_rv32imv	 out/test_kyber768_rv32imv		out/test_kyber1024_rv32imv		\
	out/test_vectors512_rv32imv	 out/test_vectors768_rv32imv	out/test_vectors1024_rv32imv	\
	out/test_kyber512_rv32imbv 	 out/test_kyber768_rv32imbv 	out/test_kyber1024_rv32imbv 	\
	out/test_vectors512_rv32imbv out/test_vectors768_rv32imbv 	out/test_vectors1024_rv32imbv	\
	out/test_kyber512_rv64im	 out/test_kyber768_rv64im		out/test_kyber1024_rv64im  		\
    out/test_vectors512_rv64im 	 out/test_vectors768_rv64im		out/test_vectors1024_rv64im 	\
	out/test_kyber512_rv64imb	 out/test_kyber768_rv64imb		out/test_kyber1024_rv64imb  	\
    out/test_vectors512_rv64imb  out/test_vectors768_rv64imb	out/test_vectors1024_rv64imb	\
	out/test_kyber512_rv64imv	 out/test_kyber768_rv64imv		out/test_kyber1024_rv64imv  	\
    out/test_vectors512_rv64imv  out/test_vectors768_rv64imv	out/test_vectors1024_rv64imv	\
	out/test_kyber512_rv64imbv	 out/test_kyber768_rv64imbv		out/test_kyber1024_rv64imbv  	\
    out/test_vectors512_rv64imbv out/test_vectors768_rv64imbv 	out/test_vectors1024_rv64imbv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

# for RV64IM

out/test_kyber512_rv64im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv64im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv64im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv64im: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv64im: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv64im: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv64im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv64im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv64im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMB

out/test_kyber512_rv64imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv64imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv64imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv64imb: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv64imb: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv64imb: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv64imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv64imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv64imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMV

out/test_kyber512_rv64imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv64imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv64imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv64imv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv64imv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv64imv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv64imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv64imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv64imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV64IMBV

out/test_kyber512_rv64imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv64imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv64imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv64imbv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv64imbv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv64imbv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv64imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv64imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv64imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV64IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IM

out/test_kyber512_rv32im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv32im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv32im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv32im: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv32im: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv32im: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv32im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv32im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv32im: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMB

out/test_kyber512_rv32imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv32imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv32imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv32imb: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv32imb: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv32imb: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv32imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv32imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv32imb: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMV

out/test_kyber512_rv32imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv32imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv32imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv32imv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv32imv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv32imv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv32imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv32imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv32imv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

# for RV32IMBV

out/test_kyber512_rv32imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv32imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv32imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv32imbv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv32imbv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv32imbv: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv32imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv32imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv32imbv: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed_kyber.c
	$(CC) $(CFLAGS_RV32IMBV) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

clean:
	-$(RM) -rf out/
