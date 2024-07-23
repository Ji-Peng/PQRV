CC 		= riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump

COMMONDIR 		= ../common
CFLAGS_COMMON 	= -O3 -fomit-frame-pointer -static \
				  -DRV32=1 -I$(COMMONDIR) -I.
CFLAGS_RV32IM  	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32

SCP 	= scp
TARGET_IP = 192.168.123.99
TARGET_USER = root
TARGET_DIR  = /sharefs

RM = /bin/rm

SOURCES_RAND 	= $(COMMONDIR)/randombytes.c
HEADERS_RAND 	= $(COMMONDIR)/randombytes.h
SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c fips202.c keccakf1600.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h fips202.h keccakf1600.h
SOURCES_RV32IM  = fastaddsub.S fastbasemul.S fastinvntt.S fastntt.S kyber.S matacc_asm.S reduce.S

SOURCES 		= $(SOURCES_COMMON) $(SOURCES_RAND) cbd.c indcpa.c kem.c matacc.c ntt.c poly.c polyvec.c symmetric-fips202.c verify.c
HEADERS 		= $(HEADERS_COMMON) $(HEADERS_RAND) api.h cbd.h implvariant.h indcpa.h matacc.h ntt.h params.h poly.h polyvec.h symmetric.h verify.h
SOURCES_VECTOR	= $(SOURCES_COMMON) cbd.c indcpa.c kem.c matacc.c ntt.c poly.c polyvec.c symmetric-fips202.c verify.c
HEADERS_VECTOR	= $(HEADERS_COMMON) api.h cbd.h implvariant.h indcpa.h matacc.h ntt.h params.h poly.h polyvec.h symmetric.h verify.h

.PHONY: all speed run_speed run_diff_vectors clean

all: \
	out/test_kyber512_rv32im_fspeed    out/test_kyber768_rv32im_fspeed      \
    out/test_kyber1024_rv32im_fspeed   out/test_vectors512_rv32im_fspeed    \
    out/test_vectors768_rv32im_fspeed  out/test_vectors1024_rv32im_fspeed	\
	out/scp_test

speed: \
	out/test_speed512_rv32im_fspeed  out/test_speed768_rv32im_fspeed  	\
	out/test_speed1024_rv32im_fspeed	\
	out/scp_test_speed

run_speed: out/scp_test_speed
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_speed512_rv32im_fspeed; ./test_speed768_rv32im_fspeed; ./test_speed1024_rv32im_fspeed" > results_rv32im_fspeed.txt

run_diff_vectors: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors512_rv32im_fspeed" > vectors_kyber512_rv32im_fspeed.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors768_rv32im_fspeed" > vectors_kyber768_rv32im_fspeed.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors1024_rv32im_fspeed" > vectors_kyber1024_rv32im_fspeed.txt
	diff vectors_kyber512_rv32im_fspeed.txt ../../Kyber/ref/vectors_kyber512.txt
	diff vectors_kyber768_rv32im_fspeed.txt ../../Kyber/ref/vectors_kyber768.txt
	diff vectors_kyber1024_rv32im_fspeed.txt ../../Kyber/ref/vectors_kyber1024.txt

out/scp_test:	\
	out/test_kyber512_rv32im_fspeed    out/test_kyber768_rv32im_fspeed      \
    out/test_kyber1024_rv32im_fspeed   out/test_vectors512_rv32im_fspeed    \
    out/test_vectors768_rv32im_fspeed  out/test_vectors1024_rv32im_fspeed
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

out/scp_test_speed:	\
	out/test_speed512_rv32im_fspeed  out/test_speed768_rv32im_fspeed  	\
	out/test_speed1024_rv32im_fspeed
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

# for RV32IM

out/test_speed_sha3_rv32im_fspeed: $(SOURCES_COMMON) $(SOURCES_RV32IM) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) $(filter %.c, $^) $(filter %.S, $^) -o $@
	scp $@ root@$(TARGET_IP):/sharefs/

out/test_kyber512_rv32im_fspeed: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber768_rv32im_fspeed: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_kyber1024_rv32im_fspeed: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors512_rv32im_fspeed: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors768_rv32im_fspeed: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_vectors1024_rv32im_fspeed: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed512_rv32im_fspeed: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed768_rv32im_fspeed: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(filter %.c, $^) $(filter %.S, $^) -o $@

out/test_speed1024_rv32im_fspeed: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(filter %.c, $^) $(filter %.S, $^) -o $@

clean:
	-$(RM) -rf out/
