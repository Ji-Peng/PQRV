CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump

COMMONDIR = ../common
CFLAGS = -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
  -DRV32=1 -I$(COMMONDIR) -I. \
  -march=rv32imac_zbb -mabi=ilp32
RM = /bin/rm

SOURCES_RAND = $(COMMONDIR)/randombytes.c
HEADERS_RAND = $(COMMONDIR)/randombytes.h
SOURCES_COMMON = $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c fips202.c fips202.S
HEADERS_COMMON = $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h $(COMMONDIR)/fips202.h

SOURCES = $(SOURCES_COMMON) $(SOURCES_RAND) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS = $(HEADERS_COMMON) $(HEADERS_RAND) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.c verify.h symmetric.h
SOURCES_VECTOR = $(SOURCES_COMMON) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS_VECTOR = $(HEADERS_COMMON) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.c verify.h symmetric.h

TARGET_IP = 192.168.123.99

.PHONY: all speed results clean

all: \
	test_kyber512_rv32 test_kyber768_rv32     \
    test_kyber1024_rv32 test_vectors512_rv32   \
    test_vectors768_rv32 test_vectors1024_rv32 

speed: \
	test_speed_sha3_rv32 test_speed512_rv32 \
	test_speed768_rv32 test_speed1024_rv32 

# Get the file results.txt from the target machine. Note that when I execute commands like test_speed* on the target machine, the output results are redirected to results.txt.
# The command I executed on target machine is ./test_speed_sha3_rv32 > results_rv32.txt; ./test_speed512_rv32 >> results_rv32.txt; ./test_speed768_rv32 >> results_rv32.txt; ./test_speed1024_rv32 >> results_rv32.txt
results:
	scp root@$(TARGET_IP):/sharefs/results_rv32.txt .

objdump:
	mkdir -p out
	$(OBJDUMP) -D out/test_speed512_rv32 > out/test_speed512_rv32.S

test_speed_sha3_rv32: $(SOURCES_COMMON) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS) $(SOURCES_COMMON) $(COMMONDIR)/test_sha3.c -o out/test_speed_sha3_rv32
	scp out/test_speed_sha3_rv32 root@$(TARGET_IP):/sharefs/

test_kyber512_rv32: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCES) $(COMMONDIR)/test_kyber.c -o out/test_kyber512_rv32
	scp out/test_kyber512_rv32 root@$(TARGET_IP):/sharefs/

test_kyber768_rv32: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCES) $(COMMONDIR)/test_kyber.c -o out/test_kyber768_rv32
	scp out/test_kyber768_rv32 root@$(TARGET_IP):/sharefs/

test_kyber1024_rv32: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCES) $(COMMONDIR)/test_kyber.c -o out/test_kyber1024_rv32
	scp out/test_kyber1024_rv32 root@$(TARGET_IP):/sharefs/

test_vectors512_rv32: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	mkdir -p out
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCES_VECTOR) $(COMMONDIR)/test_vectors.c -o out/test_vectors512_rv32
	scp out/test_vectors512_rv32 root@$(TARGET_IP):/sharefs/

test_vectors768_rv32: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCES_VECTOR) $(COMMONDIR)/test_vectors.c -o out/test_vectors768_rv32
	scp out/test_vectors768_rv32 root@$(TARGET_IP):/sharefs/

test_vectors1024_rv32: $(SOURCES_VECTOR) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCES_VECTOR) $(COMMONDIR)/test_vectors.c -o out/test_vectors1024_rv32
	scp out/test_vectors1024_rv32 root@$(TARGET_IP):/sharefs/

test_speed512_rv32: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed.c
	mkdir -p out
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCES) $(COMMONDIR)/test_speed.c -o out/test_speed512_rv32
	scp out/test_speed512_rv32 root@$(TARGET_IP):/sharefs/

test_speed768_rv32: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCES) $(COMMONDIR)/test_speed.c -o out/test_speed768_rv32
	scp out/test_speed768_rv32 root@$(TARGET_IP):/sharefs/

test_speed1024_rv32: $(SOURCES) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCES) $(COMMONDIR)/test_speed.c -o out/test_speed1024_rv32
	scp out/test_speed1024_rv32 root@$(TARGET_IP):/sharefs/

clean:
	-$(RM) -rf out/
