CC 		= riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump

COMMONDIR 		= ../common
CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
			  	  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -I$(COMMONDIR) -I.

CFLAGS_RV64IM 	= $(CFLAGS_COMMON) -march=rv64imac -mabi=lp64
CFLAGS_RV64IMB 	= $(CFLAGS_COMMON) -march=rv64imac_zba_zbb -mabi=lp64
CFLAGS_RV64V 	= $(CFLAGS_COMMON) -march=rv64imacv -mabi=lp64 -DVECTOR128

RM = /bin/rm

SOURCES_RAND 	= $(COMMONDIR)/randombytes.c
HEADERS_RAND 	= $(COMMONDIR)/randombytes.h
SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h $(COMMONDIR)/fips202.h
SOURCES_RV64IM	= fips202.c fips202_rv64im_unroll.S
SOURCES_RV64IMB	= fips202.c fips202_rv64imb_unroll.S
SOURCES_RV64V	= fips202x2.c fips202_rv64v.S fips202_rv64imv_hybrid_x3.S

SOURCES 		= $(SOURCES_COMMON) $(SOURCES_RAND) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS 		= $(HEADERS_COMMON) $(HEADERS_RAND) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.h verify.h symmetric.h
SOURCES_VECTOR 	= $(SOURCES_COMMON) kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c symmetric-shake.c
HEADERS_VECTOR 	= $(HEADERS_COMMON) params.h kem.h indcpa.h polyvec.h poly.h ntt.h cbd.h reduce.c verify.h symmetric.h

TARGET_IP = 192.168.123.99

.PHONY: all speed results clean

all: \
	test_kyber512_rv64im    test_kyber768_rv64im 	\
    test_kyber1024_rv64im   test_vectors512_rv64im 	\
    test_vectors768_rv64im  test_vectors1024_rv64im	\
	test_kyber512_rv64imb   test_kyber768_rv64imb 	\
    test_kyber1024_rv64imb  test_vectors512_rv64imb \
    test_vectors768_rv64imb test_vectors1024_rv64imb
	
# \
# test_kyber512_rv64v   	test_kyber768_rv64v 	\
# test_kyber1024_rv64v  	test_vectors512_rv64v 	\
# test_vectors768_rv64v 	test_vectors1024_rv64v

speed: \
	test_speed_sha3_rv64im 	\
	test_speed512_rv64im 	test_speed768_rv64im   	test_speed1024_rv64im	\
	test_speed_sha3_rv64imb \
	test_speed512_rv64imb	test_speed768_rv64imb   test_speed1024_rv64imb	\
	test_speed_sha3_rv64v 	
	
# \
# test_speed512_rv64v		test_speed768_rv64v   	test_speed1024_rv64v

# Get the file results*.txt from the target machine. Note that when executing commands like test_speed* on the target machine, the output results are redirected to results.txt.
# The commands executed on target machine include:
# ./test_speed_sha3_rv64im > results_rv64im.txt; ./test_speed512_rv64im >> results_rv64im.txt; ./test_speed768_rv64im >> results_rv64im.txt; ./test_speed1024_rv64im >> results_rv64im.txt
# ./test_speed_sha3_rv64imb > results_rv64imb.txt; ./test_speed512_rv64imb >> results_rv64imb.txt; ./test_speed768_rv64imb >> results_rv64imb.txt; ./test_speed1024_rv64imb >> results_rv64imb.txt
# ./test_speed_sha3_rv64v > results_rv64v.txt; ./test_speed512_rv64v >> results_rv64v.txt; ./test_speed768_rv64v >> results_rv64v.txt; ./test_speed1024_rv64v >> results_rv64v.txt
results:
	scp root@$(TARGET_IP):/sharefs/results_rv64im.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv64imb.txt .
	scp root@$(TARGET_IP):/sharefs/results_rv64v.txt .

objdump:
	$(OBJDUMP) -D out/test_speed512 > out/test_speed512.S

# for RV64IM

test_speed_sha3_rv64im: $(SOURCES_COMMON) $(SOURCES_RV64IM) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) $(SOURCES_COMMON) $(SOURCES_RV64IM) $(COMMONDIR)/test_sha3.c -o out/test_speed_sha3_rv64im
	scp out/test_speed_sha3_rv64im root@$(TARGET_IP):/sharefs/

test_kyber512_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber512_rv64im
	scp out/test_kyber512_rv64im root@$(TARGET_IP):/sharefs/

test_kyber768_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber768_rv64im
	scp out/test_kyber768_rv64im root@$(TARGET_IP):/sharefs/

test_kyber1024_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_kyber.c -o out/test_kyber1024_rv64im
	scp out/test_kyber1024_rv64im root@$(TARGET_IP):/sharefs/

test_vectors512_rv64im: $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(COMMONDIR)/test_vectors.c -o out/test_vectors512_rv64im
	scp out/test_vectors512_rv64im root@$(TARGET_IP):/sharefs/

test_vectors768_rv64im: $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(COMMONDIR)/test_vectors.c -o out/test_vectors768_rv64im
	scp out/test_vectors768_rv64im root@$(TARGET_IP):/sharefs/

test_vectors1024_rv64im: $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(SOURCES_VECTOR) $(SOURCES_RV64IM) $(COMMONDIR)/test_vectors.c -o out/test_vectors1024_rv64im
	scp out/test_vectors1024_rv64im root@$(TARGET_IP):/sharefs/

test_speed512_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_speed.c -o out/test_speed512_rv64im
	scp out/test_speed512_rv64im root@$(TARGET_IP):/sharefs/

test_speed768_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_speed.c -o out/test_speed768_rv64im
	scp out/test_speed768_rv64im root@$(TARGET_IP):/sharefs/

test_speed1024_rv64im: $(SOURCES) $(SOURCES_RV64IM) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV64IM) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IM) $(COMMONDIR)/test_speed.c -o out/test_speed1024_rv64im
	scp out/test_speed1024_rv64im root@$(TARGET_IP):/sharefs/

# for RV64IMB

test_speed_sha3_rv64imb: $(SOURCES_COMMON) $(SOURCES_RV64IMB) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) $(SOURCES_COMMON) $(SOURCES_RV64IMB) $(COMMONDIR)/test_sha3.c -o out/test_speed_sha3_rv64imb
	scp out/test_speed_sha3_rv64imb root@$(TARGET_IP):/sharefs/

test_kyber512_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_kyber.c -o out/test_kyber512_rv64imb
	scp out/test_kyber512_rv64imb root@$(TARGET_IP):/sharefs/

test_kyber768_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_kyber.c -o out/test_kyber768_rv64imb
	scp out/test_kyber768_rv64imb root@$(TARGET_IP):/sharefs/

test_kyber1024_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_kyber.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_kyber.c -o out/test_kyber1024_rv64imb
	scp out/test_kyber1024_rv64imb root@$(TARGET_IP):/sharefs/

test_vectors512_rv64imb: $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(COMMONDIR)/test_vectors.c -o out/test_vectors512_rv64imb
	scp out/test_vectors512_rv64imb root@$(TARGET_IP):/sharefs/

test_vectors768_rv64imb: $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(COMMONDIR)/test_vectors.c -o out/test_vectors768_rv64imb
	scp out/test_vectors768_rv64imb root@$(TARGET_IP):/sharefs/

test_vectors1024_rv64imb: $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(SOURCES_VECTOR) $(SOURCES_RV64IMB) $(COMMONDIR)/test_vectors.c -o out/test_vectors1024_rv64imb
	scp out/test_vectors1024_rv64imb root@$(TARGET_IP):/sharefs/

test_speed512_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_speed.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_speed.c -o out/test_speed512_rv64imb
	scp out/test_speed512_rv64imb root@$(TARGET_IP):/sharefs/

test_speed768_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_speed.c -o out/test_speed768_rv64imb
	scp out/test_speed768_rv64imb root@$(TARGET_IP):/sharefs/

test_speed1024_rv64imb: $(SOURCES) $(SOURCES_RV64IMB) $(HEADERS) $(COMMONDIR)/test_speed.c
	$(CC) $(CFLAGS_RV64IMB) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64IMB) $(COMMONDIR)/test_speed.c -o out/test_speed1024_rv64imb
	scp out/test_speed1024_rv64imb root@$(TARGET_IP):/sharefs/

# for RV64V

test_speed_sha3_rv64v: $(SOURCES_COMMON) $(SOURCES_RV64V) $(HEADERS_COMMON) $(COMMONDIR)/test_sha3.c
	mkdir -p out
	$(CC) $(CFLAGS_RV64V) $(SOURCES_COMMON) $(SOURCES_RV64V) $(COMMONDIR)/test_sha3.c -o out/test_speed_sha3_rv64v
	scp out/test_speed_sha3_rv64v root@$(TARGET_IP):/sharefs/

# test_kyber512_rv64v: $(SOURCES) $(SOURCES_RV64V) $(HEADERS) $(COMMONDIR)/test_kyber.c
# 	mkdir -p out
# 	$(CC) $(CFLAGS_RV64V) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64V) $(COMMONDIR)/test_kyber.c -o out/test_kyber512_rv64v
# 	scp out/test_kyber512_rv64v root@$(TARGET_IP):/sharefs/

# test_kyber768_rv64v: $(SOURCES) $(SOURCES_RV64V) $(HEADERS) $(COMMONDIR)/test_kyber.c
# 	$(CC) $(CFLAGS_RV64V) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64V) $(COMMONDIR)/test_kyber.c -o out/test_kyber768_rv64v
# 	scp out/test_kyber768_rv64v root@$(TARGET_IP):/sharefs/

# test_kyber1024_rv64v: $(SOURCES) $(SOURCES_RV64V) $(HEADERS) $(COMMONDIR)/test_kyber.c
# 	$(CC) $(CFLAGS_RV64V) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64V) $(COMMONDIR)/test_kyber.c -o out/test_kyber1024_rv64v
# 	scp out/test_kyber1024_rv64v root@$(TARGET_IP):/sharefs/

# test_vectors512_rv64v: $(SOURCES_VECTOR) $(SOURCES_RV64V) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
# 	mkdir -p out
# 	$(CC) $(CFLAGS_RV64V) -DKYBER_K=2 $(SOURCES_VECTOR) $(SOURCES_RV64V) $(COMMONDIR)/test_vectors.c -o out/test_vectors512_rv64v
# 	scp out/test_vectors512_rv64v root@$(TARGET_IP):/sharefs/

# test_vectors768_rv64v: $(SOURCES_VECTOR) $(SOURCES_RV64V) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
# 	$(CC) $(CFLAGS_RV64V) -DKYBER_K=3 $(SOURCES_VECTOR) $(SOURCES_RV64V) $(COMMONDIR)/test_vectors.c -o out/test_vectors768_rv64v
# 	scp out/test_vectors768_rv64v root@$(TARGET_IP):/sharefs/

# test_vectors1024_rv64v: $(SOURCES_VECTOR) $(SOURCES_RV64V) $(HEADERS_VECTOR) $(COMMONDIR)/test_vectors.c
# 	$(CC) $(CFLAGS_RV64V) -DKYBER_K=4 $(SOURCES_VECTOR) $(SOURCES_RV64V) $(COMMONDIR)/test_vectors.c -o out/test_vectors1024_rv64v
# 	scp out/test_vectors1024_rv64v root@$(TARGET_IP):/sharefs/

# test_speed512_rv64v: $(SOURCES) $(SOURCES_RV64V) $(HEADERS) $(COMMONDIR)/test_speed.c
# 	mkdir -p out
# 	$(CC) $(CFLAGS_RV64V) -DKYBER_K=2 $(SOURCES) $(SOURCES_RV64V) $(COMMONDIR)/test_speed.c -o out/test_speed512_rv64v
# 	scp out/test_speed512_rv64v root@$(TARGET_IP):/sharefs/

# test_speed768_rv64v: $(SOURCES) $(SOURCES_RV64V) $(HEADERS) $(COMMONDIR)/test_speed.c
# 	$(CC) $(CFLAGS_RV64V) -DKYBER_K=3 $(SOURCES) $(SOURCES_RV64V) $(COMMONDIR)/test_speed.c -o out/test_speed768_rv64v
# 	scp out/test_speed768_rv64v root@$(TARGET_IP):/sharefs/

# test_speed1024_rv64v: $(SOURCES) $(SOURCES_RV64V) $(HEADERS) $(COMMONDIR)/test_speed.c
# 	$(CC) $(CFLAGS_RV64V) -DKYBER_K=4 $(SOURCES) $(SOURCES_RV64V) $(COMMONDIR)/test_speed.c -o out/test_speed1024_rv64v
# 	scp out/test_speed1024_rv64v root@$(TARGET_IP):/sharefs/

clean:
	-$(RM) -rf out/
