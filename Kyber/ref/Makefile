CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
CFLAGS = -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
  -march=rv64imac -mabi=lp64
RM = /bin/rm

SOURCES = kex.c kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c
SOURCESKECCAK = $(SOURCES) fips202.c symmetric-shake.c
SOURCESNINETIES = $(SOURCES) sha256.c sha512.c aes256ctr.c symmetric-aes.c
HEADERS = params.h kex.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.c verify.h symmetric.h
HEADERSKECCAK = $(HEADERS) fips202.h
HEADERSNINETIES = $(HEADERS) aes256ctr.h sha2.h

TARGET_IP = 192.168.123.99

.PHONY: all speed results clean

all: mkdirout \
	test_kyber512 scp_test_kyber512\
	test_kyber768 scp_test_kyber768 \
    test_kyber1024 scp_test_kyber1024 \
    test_vectors512 scp_test_vectors512 \
    test_vectors768 scp_test_vectors768 \
    test_vectors1024 scp_test_vectors1024

speed: mkdirout \
	test_speed_sha3 scp_test_speed_sha3 \
	test_speed512 scp_test_speed512 \
	test_speed768 scp_test_speed768 \
	test_speed1024 scp_test_speed1024

# Get the file results.txt from the target machine. Note that when I execute commands like test_speed* on the target machine, the output results are redirected to results.txt.
# The command I executed on target machine is ./test_speed_sha3 > results.txt; ./test_speed512 >> results.txt; ./test_speed768 >> results.txt; ./test_speed1024 >> results.txt
results:
	scp root@$(TARGET_IP):/sharefs/results.txt .

objdump:
	$(OBJDUMP) -D out/test_speed512 > out/test_speed512.S

mkdirout:
	mkdir -p out

test_speed_sha3: fips202.h speed_print.h cpucycles.h fips202.c speed_print.c cpucycles.c test_sha3.c
	$(CC) $(CFLAGS) fips202.c speed_print.c cpucycles.c test_sha3.c -o out/test_speed_sha3

test_kyber512: $(SOURCESKECCAK) $(HEADERSKECCAK) test_kyber.c randombytes.c
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCESKECCAK) randombytes.c test_kyber.c -o out/test_kyber512

test_kyber768: $(SOURCESKECCAK) $(HEADERSKECCAK) test_kyber.c randombytes.c
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCESKECCAK) randombytes.c test_kyber.c -o out/test_kyber768

test_kyber1024: $(SOURCESKECCAK) $(HEADERSKECCAK) test_kyber.c randombytes.c
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCESKECCAK) randombytes.c test_kyber.c -o out/test_kyber1024

scp_test_speed_sha3:
	scp out/test_speed_sha3 root@$(TARGET_IP):/sharefs/

scp_test_kyber512:
	scp out/test_kyber512 root@$(TARGET_IP):/sharefs/

scp_test_kyber768:
	scp out/test_kyber768 root@$(TARGET_IP):/sharefs/

scp_test_kyber1024:
	scp out/test_kyber1024 root@$(TARGET_IP):/sharefs/

test_vectors512: $(SOURCESKECCAK) $(HEADERSKECCAK) test_vectors.c
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCESKECCAK) test_vectors.c -o out/test_vectors512

test_vectors768: $(SOURCESKECCAK) $(HEADERSKECCAK) test_vectors.c
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCESKECCAK) test_vectors.c -o out/test_vectors768

test_vectors1024: $(SOURCESKECCAK) $(HEADERSKECCAK) test_vectors.c
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCESKECCAK) test_vectors.c -o out/test_vectors1024

scp_test_vectors512:
	scp out/test_vectors512 root@$(TARGET_IP):/sharefs/

scp_test_vectors768:
	scp out/test_vectors768 root@$(TARGET_IP):/sharefs/

scp_test_vectors1024:
	scp out/test_vectors1024 root@$(TARGET_IP):/sharefs/

test_speed512: $(SOURCESKECCAK) $(HEADERSKECCAK) cpucycles.h cpucycles.c speed_print.h speed_print.c test_speed.c randombytes.c
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCESKECCAK) randombytes.c cpucycles.c speed_print.c test_speed.c -o out/test_speed512

test_speed768: $(SOURCESKECCAK) $(HEADERSKECCAK) cpucycles.h cpucycles.c speed_print.h speed_print.c test_speed.c randombytes.c
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCESKECCAK) randombytes.c cpucycles.c speed_print.c test_speed.c -o out/test_speed768

test_speed1024: $(SOURCESKECCAK) $(HEADERSKECCAK) cpucycles.h cpucycles.c speed_print.h speed_print.c test_speed.c randombytes.c
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCESKECCAK) randombytes.c cpucycles.c speed_print.c test_speed.c -o out/test_speed1024

scp_test_speed512:
	scp out/test_speed512 root@$(TARGET_IP):/sharefs/

scp_test_speed768:
	scp out/test_speed768 root@$(TARGET_IP):/sharefs/

scp_test_speed1024:
	scp out/test_speed1024 root@$(TARGET_IP):/sharefs/

clean:
	-$(RM) -rf out/
