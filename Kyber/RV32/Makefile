CC 		= riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump

COMMONDIR 		= ../common
CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
				  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -DRV32=1 -I$(COMMONDIR) -I.
CFLAGS_RV32IM  	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32
CFLAGS_RV32IMB 	= $(CFLAGS_COMMON) -march=rv32imac_zbb -mabi=ilp32

RM = /bin/rm

SOURCES_RAND 	= $(COMMONDIR)/randombytes.c
HEADERS_RAND 	= $(COMMONDIR)/randombytes.h
SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c fips202.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h $(COMMONDIR)/fips202.h
SOURCES_RV32IM  = fips202_rv32im.S
SOURCES_RV32IMB = fips202_rv32imb.S

SOURCES 		= $(SOURCES_COMMON) $(SOURCES_RAND) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS 		= $(HEADERS_COMMON) $(HEADERS_RAND) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.h verify.h symmetric.h
SOURCES_VECTOR 	= $(SOURCES_COMMON) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS_VECTOR 	= $(HEADERS_COMMON) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.c verify.h symmetric.h

TARGET_IP = 192.168.123.99

.PHONY: all speed results clean

all: \
	test_kyber512_rv32im    test_kyber768_rv32im      \
    test_kyber1024_rv32im   test_vectors512_rv32im    \
    test_vectors768_rv32im  test_vectors1024_rv32im   \
	test_kyber512_rv32imb   test_kyber768_rv32imb     \
    test_kyber1024_rv32imb  test_vectors512_rv32imb   \
    test_vectors768_rv32imb test_vectors1024_rv32imb 

speed: \
	test_speed_sha3_rv32im \
	test_speed512_rv32im  test_speed768_rv32im  test_speed1024_rv32im \
	test_speed_sha3_rv32imb \
	test_speed512_rv32imb test_speed768_rv32imb test_speed1024_rv32imb \

# Get the file results*.txt from the target machine. Note that when execute commands like test_speed* on the target machine, the output results are redirected to results.txt.
# The command executed on target machine include: 
# ./test_speed_sha3_rv32im > results_rv32im.txt; ./test_speed512_rv32im >> results_rv32im.txt; ./test_speed768_rv32im >> results_rv32im.txt; ./test_speed1024_rv32im >> results_rv32im.txt
# ./test_speed_sha3_rv32imb > results_rv32imb.txt; ./test_speed512_rv32imb >> results_rv32imb.txt; ./test_speed768_rv32imb >> results_rv32imb.txt; ./test_speed1024_rv32imb >> results_rv32imb.txt
results:
	scp root@$(TARGET_IP):/sharefs/results_rv32im.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv32imb.txt .

objdump:
	mkdir -p out
	$(OBJDUMP) -D out/test_speed512_rv32im > out/test_speed512_rv32im.S

# for RV32IM

test_speed_sha3_rv32im: $(SOURCES_COMMON) $(SOURCES_RV32IM) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) $(SOURCES_COMMON) $(SOURCES_RV32IM) $(COMMONDIR)/test_sha3.c -o out/test_speed_sha3_rv32im
	scp out/test_speed_sha3_rv32im root@$(TARGET_IP):/sharefs/

test_kyber512_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber512_rv32im
	scp out/test_kyber512_rv32im root@$(TARGET_IP):/sharefs/

test_kyber768_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber768_rv32im
	scp out/test_kyber768_rv32im root@$(TARGET_IP):/sharefs/

test_kyber1024_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber1024_rv32im
	scp out/test_kyber1024_rv32im root@$(TARGET_IP):/sharefs/

test_vectors512_rv32im: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(COMMONDIR)/test_vectors.c -o out/test_vectors512_rv32im
	scp out/test_vectors512_rv32im root@$(TARGET_IP):/sharefs/

test_vectors768_rv32im: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(SOURCES_VECTOR) $(COMMONDIR)/test_vectors.c -o out/test_vectors768_rv32im
	scp out/test_vectors768_rv32im root@$(TARGET_IP):/sharefs/

test_vectors1024_rv32im: $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(SOURCES_VECTOR) $(COMMONDIR)/test_vectors.c -o out/test_vectors1024_rv32im
	scp out/test_vectors1024_rv32im root@$(TARGET_IP):/sharefs/

test_speed512_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_speed.c -o out/test_speed512_rv32im
	scp out/test_speed512_rv32im root@$(TARGET_IP):/sharefs/

test_speed768_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_speed.c -o out/test_speed768_rv32im
	scp out/test_speed768_rv32im root@$(TARGET_IP):/sharefs/

test_speed1024_rv32im: $(SOURCES) $(SOURCES_RV32IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV32IM) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV32IM) $(COMMONDIR)/test_speed.c -o out/test_speed1024_rv32im
	scp out/test_speed1024_rv32im root@$(TARGET_IP):/sharefs/

# for RV32IMB

test_speed_sha3_rv32imb: $(SOURCES_COMMON) $(SOURCES_RV32IMB) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) $(SOURCES_COMMON) $(SOURCES_RV32IMB) $(COMMONDIR)/test_sha3.c -o out/test_speed_sha3_rv32imb
	scp out/test_speed_sha3_rv32imb root@$(TARGET_IP):/sharefs/

test_kyber512_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV32IMB) $(COMMONDIR)/test_kyber.c -o out/test_kyber512_rv32imb
	scp out/test_kyber512_rv32imb root@$(TARGET_IP):/sharefs/

test_kyber768_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV32IMB) $(COMMONDIR)/test_kyber.c -o out/test_kyber768_rv32imb
	scp out/test_kyber768_rv32imb root@$(TARGET_IP):/sharefs/

test_kyber1024_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV32IMB) $(COMMONDIR)/test_kyber.c -o out/test_kyber1024_rv32imb
	scp out/test_kyber1024_rv32imb root@$(TARGET_IP):/sharefs/

test_vectors512_rv32imb: $(SOURCES_VECTOR) $(SOURCES_RV32IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=2 $(SOURCES_VECTOR) $(SOURCES_RV32IMB) $(COMMONDIR)/test_vectors.c -o out/test_vectors512_rv32imb
	scp out/test_vectors512_rv32imb root@$(TARGET_IP):/sharefs/

test_vectors768_rv32imb: $(SOURCES_VECTOR) $(SOURCES_RV32IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=3 $(SOURCES_VECTOR) $(COMMONDIR)/test_vectors.c -o out/test_vectors768_rv32imb
	scp out/test_vectors768_rv32imb root@$(TARGET_IP):/sharefs/

test_vectors1024_rv32imb: $(SOURCES_VECTOR) $(SOURCES_RV32IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=4 $(SOURCES_VECTOR) $(COMMONDIR)/test_vectors.c -o out/test_vectors1024_rv32imb
	scp out/test_vectors1024_rv32imb root@$(TARGET_IP):/sharefs/

test_speed512_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_speed.c
	mkdir -p out
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV32IMB) $(COMMONDIR)/test_speed.c -o out/test_speed512_rv32imb
	scp out/test_speed512_rv32imb root@$(TARGET_IP):/sharefs/

test_speed768_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV32IMB) $(COMMONDIR)/test_speed.c -o out/test_speed768_rv32imb
	scp out/test_speed768_rv32imb root@$(TARGET_IP):/sharefs/

test_speed1024_rv32imb: $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV32IMB) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV32IMB) $(COMMONDIR)/test_speed.c -o out/test_speed1024_rv32imb
	scp out/test_speed1024_rv32imb root@$(TARGET_IP):/sharefs/

clean:
	-$(RM) -rf out/
