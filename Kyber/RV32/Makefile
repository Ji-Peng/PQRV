CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
CFLAGS = -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
  -DRV32=1 \
  -march=rv32imac -mabi=ilp32
RM = /bin/rm

SOURCES = kex.c kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c
SOURCESKECCAK = $(SOURCES) fips202.c fips202.S symmetric-shake.c
SOURCESNINETIES = $(SOURCES) sha256.c sha512.c aes256ctr.c symmetric-aes.c
HEADERS = params.h kex.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.c verify.h symmetric.h
HEADERSKECCAK = $(HEADERS) fips202.h
HEADERSNINETIES = $(HEADERS) aes256ctr.h sha2.h

TARGET_IP = 192.168.123.99

.PHONY: all speed results clean

all: \
	test_kyber512_rv32    scp_test_kyber512_rv32\
	test_kyber768_rv32    scp_test_kyber768_rv32 \
    test_kyber1024_rv32   scp_test_kyber1024_rv32 \
    test_vectors512_rv32  scp_test_vectors512_rv32 \
    test_vectors768_rv32  scp_test_vectors768_rv32 \
    test_vectors1024_rv32 scp_test_vectors1024_rv32

speed: \
	test_speed_sha3_rv32 scp_test_speed_sha3_rv32 \
	test_speed512_rv32  scp_test_speed512_rv32 
	# test_speed768_rv32  scp_test_speed768_rv32 \
	# test_speed1024_rv32 scp_test_speed1024_rv32 \

# Get the file results.txt from the target machine. Note that when I execute commands like test_speed* on the target machine, the output results are redirected to results.txt.
# The command I executed on target machine is ./test_speed_sha3_rv32 > results_rv32.txt; ./test_speed512_rv32 >> results_rv32.txt; ./test_speed768_rv32 >> results_rv32.txt; ./test_speed1024_rv32 >> results_rv32.txt
results:
	scp root@$(TARGET_IP):/sharefs/results_rv32.txt .

objdump:
	mkdir -p out
	$(OBJDUMP) -D out/test_speed512_rv32 > out/test_speed512_rv32.S

test_speed_sha3_rv32: fips202.h speed_print.h cpucycles.h fips202.c fips202.S speed_print.c cpucycles.c test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS) fips202.c fips202.S speed_print.c cpucycles.c test_sha3.c -o out/test_speed_sha3_rv32

test_kyber512_rv32: $(SOURCESKECCAK) $(HEADERSKECCAK) test_kyber.c randombytes.c
	mkdir -p out
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCESKECCAK) randombytes.c test_kyber.c -o out/test_kyber512_rv32

test_kyber768_rv32: $(SOURCESKECCAK) $(HEADERSKECCAK) test_kyber.c randombytes.c
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCESKECCAK) randombytes.c test_kyber.c -o out/test_kyber768_rv32

test_kyber1024_rv32: $(SOURCESKECCAK) $(HEADERSKECCAK) test_kyber.c randombytes.c
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCESKECCAK) randombytes.c test_kyber.c -o out/test_kyber1024_rv32

scp_test_speed_sha3_rv32:
	scp out/test_speed_sha3_rv32 root@$(TARGET_IP):/sharefs/

scp_test_kyber512_rv32:
	scp out/test_kyber512_rv32 root@$(TARGET_IP):/sharefs/

scp_test_kyber768_rv32:
	scp out/test_kyber768_rv32 root@$(TARGET_IP):/sharefs/

scp_test_kyber1024_rv32:
	scp out/test_kyber1024_rv32 root@$(TARGET_IP):/sharefs/

test_vectors512_rv32: $(SOURCESKECCAK) $(HEADERSKECCAK) test_vectors.c
	mkdir -p out
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCESKECCAK) test_vectors.c -o out/test_vectors512_rv32

test_vectors768_rv32: $(SOURCESKECCAK) $(HEADERSKECCAK) test_vectors.c
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCESKECCAK) test_vectors.c -o out/test_vectors768_rv32

test_vectors1024_rv32: $(SOURCESKECCAK) $(HEADERSKECCAK) test_vectors.c
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCESKECCAK) test_vectors.c -o out/test_vectors1024_rv32

scp_test_vectors512_rv32:
	scp out/test_vectors512_rv32 root@$(TARGET_IP):/sharefs/

scp_test_vectors768_rv32:
	scp out/test_vectors768_rv32 root@$(TARGET_IP):/sharefs/

scp_test_vectors1024_rv32:
	scp out/test_vectors1024_rv32 root@$(TARGET_IP):/sharefs/

test_speed512_rv32: $(SOURCESKECCAK) $(HEADERSKECCAK) cpucycles.h cpucycles.c speed_print.h speed_print.c test_speed.c randombytes.c
	mkdir -p out
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCESKECCAK) randombytes.c cpucycles.c speed_print.c test_speed.c -o out/test_speed512_rv32

test_speed768_rv32: $(SOURCESKECCAK) $(HEADERSKECCAK) cpucycles.h cpucycles.c speed_print.h speed_print.c test_speed.c randombytes.c
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCESKECCAK) randombytes.c cpucycles.c speed_print.c test_speed.c -o out/test_speed768_rv32

test_speed1024_rv32: $(SOURCESKECCAK) $(HEADERSKECCAK) cpucycles.h cpucycles.c speed_print.h speed_print.c test_speed.c randombytes.c
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCESKECCAK) randombytes.c cpucycles.c speed_print.c test_speed.c -o out/test_speed1024_rv32

scp_test_speed512_rv32:
	scp out/test_speed512_rv32 root@$(TARGET_IP):/sharefs/

scp_test_speed768_rv32:
	scp out/test_speed768_rv32 root@$(TARGET_IP):/sharefs/

scp_test_speed1024_rv32:
	scp out/test_speed1024_rv32 root@$(TARGET_IP):/sharefs/

clean:
	-$(RM) -rf out/
