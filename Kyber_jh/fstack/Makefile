CC 		= riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump

COMMONDIR 		= ../common
CFLAGS_COMMON 	= -O3 -fomit-frame-pointer -static \
				  -DRV32=1 -I$(COMMONDIR) -I.
CFLAGS_RV32IM  	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32

RM = /bin/rm

SOURCES_RAND 	= $(COMMONDIR)/randombytes.c
HEADERS_RAND 	= $(COMMONDIR)/randombytes.h
SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c fips202.c keccakf1600.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h fips202.h keccakf1600.h
SOURCES_RV32IM  = fastaddsub.S fastinvntt_ct.S fastinvntt.S fastntt.S kyber.S reduce.S

SOURCES 		= $(SOURCES_COMMON) $(SOURCES_RAND) cbd.c indcpa.c kem.c ntt.c poly.c polyvec.c symmetric-fips202.c verify.c
HEADERS 		= $(HEADERS_COMMON) $(HEADERS_RAND) api.h cbd.h implvariant.h indcpa.h ntt.h params.h poly.h polyvec.h symmetric.h verify.h

TARGET_IP = 192.168.123.99

.PHONY: all speed results clean

all: \
	test_kyber512_rv32im_fstack    test_kyber768_rv32im_fstack      \
    test_kyber1024_rv32im_fstack   test_vectors512_rv32im_fstack    \
    test_vectors768_rv32im_fstack  test_vectors1024_rv32im_fstack

speed: \
	test_speed512_rv32im_fstack  test_speed768_rv32im_fstack  test_speed1024_rv32im_fstack

# Get the file results*.txt from the target machine. Note that when execute commands like test_speed* on the target machine, the output results are redirected to results.txt.
# The command executed on target machine include: 
# ./test_speed_sha3_rv32im_fstack > results_rv32im_fstack.txt; ./test_speed512_rv32im_fstack >> results_rv32im_fstack.txt; ./test_speed768_rv32im_fstack >> results_rv32im_fstack.txt; ./test_speed1024_rv32im_fstack >> results_rv32im_fstack.txt
results:
	scp root@$(TARGET_IP):/sharefs/results_rv32im_fstack.txt .

objdump:
	mkdir -p out
	$(OBJDUMP) -D out/test_speed512_rv32im_fstack > out/test_speed512_rv32im_fstack.S

# for RV32IM

test_speed_sha3_rv32im_fstack: $(SOURCES_COMMON) $(SOURCES_RV32IM) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) $(SOURCES_COMMON) $(SOURCES_RV32IM) $(COMMONDIR)/test_sha3.c -o out/test_speed_sha3_rv32im_fstack
	scp out/test_speed_sha3_rv32im_fstack root@$(TARGET_IP):/sharefs/

test_kyber512_rv32im_fstack: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber512_rv32im_fstack
	scp out/test_kyber512_rv32im_fstack root@$(TARGET_IP):/sharefs/

test_kyber768_rv32im_fstack: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber768_rv32im_fstack
	scp out/test_kyber768_rv32im_fstack root@$(TARGET_IP):/sharefs/

test_kyber1024_rv32im_fstack: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber1024_rv32im_fstack
	scp out/test_kyber1024_rv32im_fstack root@$(TARGET_IP):/sharefs/

test_vectors512_rv32im_fstack: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(COMMONDIR)/test_vectors.c -o out/test_vectors512_rv32im_fstack
	scp out/test_vectors512_rv32im_fstack root@$(TARGET_IP):/sharefs/

test_vectors768_rv32im_fstack: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(SOURCES_VECTOR) $(COMMONDIR)/test_vectors.c -o out/test_vectors768_rv32im_fstack
	scp out/test_vectors768_rv32im_fstack root@$(TARGET_IP):/sharefs/

test_vectors1024_rv32im_fstack: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(SOURCES_VECTOR) $(COMMONDIR)/test_vectors.c -o out/test_vectors1024_rv32im_fstack
	scp out/test_vectors1024_rv32im_fstack root@$(TARGET_IP):/sharefs/

test_speed512_rv32im_fstack: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_speed.c -o out/test_speed512_rv32im_fstack
	scp out/test_speed512_rv32im_fstack root@$(TARGET_IP):/sharefs/

test_speed768_rv32im_fstack: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_speed.c -o out/test_speed768_rv32im_fstack
	scp out/test_speed768_rv32im_fstack root@$(TARGET_IP):/sharefs/

test_speed1024_rv32im_fstack: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_speed.c -o out/test_speed1024_rv32im_fstack
	scp out/test_speed1024_rv32im_fstack root@$(TARGET_IP):/sharefs/

clean:
	-$(RM) -rf out/
