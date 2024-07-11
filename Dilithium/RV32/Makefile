PLATFORM ?= C908

CC 		= riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
SCP 	= scp
# SCP		= @:

COMMONDIR 		= ../../common
KECCAKDIR		= ../../sha3
NTTDIR			= ../../ntt/dilithium

CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  				  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -DRV32=1 -I$(COMMONDIR) -I$(KECCAKDIR) -I$(NTTDIR) -I. -DDILITHIUM_COUNT_REJ_NUM

CFLAGS_RV32IM 	= $(CFLAGS_COMMON) -march=rv32imac -mabi=ilp32 -DRV32IM
CFLAGS_RV32IMB 	= $(CFLAGS_COMMON) -march=rv32imac_zbb -mabi=ilp32 -DRV32IMB -DBIT_INTERLEAVING
CFLAGS_RV32IMV 	= $(CFLAGS_COMMON) -march=rv32imacv -mabi=ilp32 -DRV32IMV \
	-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4
CFLAGS_RV32IMBV = $(CFLAGS_COMMON) -march=rv32imacv_zbb -mabi=ilp32 -DRV32IMBV -DBIT_INTERLEAVING \
	-DVECTOR128 -DHYBRIDX3 -DHYBRIDX4 -DHYBRIDX5

TARGET_IP 	= 192.168.123.99
TARGET_USER = root
TARGET_DIR  = /sharefs

RM = /bin/rm

SOURCES_RAND 	= $(COMMONDIR)/randombytes.c
HEADERS_RAND 	= $(COMMONDIR)/randombytes.h
SOURCES_COMMON 	= $(COMMONDIR)/cpucycles.c $(COMMONDIR)/speed_print.c $(KECCAKDIR)/fips202_rv32.c
HEADERS_COMMON 	= $(COMMONDIR)/cpucycles.h $(COMMONDIR)/speed_print.h $(KECCAKDIR)/fips202.h $(KECCAKDIR)/fips202x.h

SOURCES_RV32IM  = $(KECCAKDIR)/fips202_rv32im.S $(NTTDIR)/ntt_8l_dualissue_mont_rv32im.S
SOURCES_RV32IMB = $(KECCAKDIR)/fips202_rv32imb_bitinter.S $(NTTDIR)/ntt_8l_dualissue_mont_rv32im.S
SOURCES_RV32IMV = $(KECCAKDIR)/fips202x_rv32.c $(KECCAKDIR)/fips202_rv32im.S $(KECCAKDIR)/fips202_rv32v.S $(KECCAKDIR)/fips202_rv32imv_hybrid_x3.S $(KECCAKDIR)/fips202_rv32imv_hybrid_x4.S $(NTTDIR)/ntt_rvv.S $(NTTDIR)/consts.c
SOURCES_RV32IMBV= $(KECCAKDIR)/fips202x_rv32.c $(KECCAKDIR)/fips202_rv32imb_bitinter.S $(KECCAKDIR)/fips202_rv32v.S $(KECCAKDIR)/fips202_rv32imbv_hybrid_x3.S $(KECCAKDIR)/fips202_rv32imbv_hybrid_x4.S $(KECCAKDIR)/fips202_rv32imbv_hybrid_x5.S $(NTTDIR)/ntt_rvv.S $(NTTDIR)/consts.c

SOURCES 		= $(SOURCES_COMMON) $(SOURCES_RAND) sign.c packing.c polyvec.c poly.c ntt.c reduce.c rounding.c
HEADERS 		= $(HEADERS_COMMON) $(HEADERS_RAND) config.h params.h api.h sign.h packing.h polyvec.h poly.h ntt.h reduce.h rounding.h
SOURCES_VECTOR 	= $(SOURCES_COMMON) sign.c packing.c polyvec.c poly.c ntt.c reduce.c rounding.c
HEADERS_VECTOR 	= $(HEADERS_COMMON) config.h params.h api.h sign.h packing.h polyvec.h poly.h ntt.h reduce.h rounding.h

.PHONY: all speed run_speed run_diff_vectors clean

all: \
	out/test_dilithium2_rv32im 		\
	out/test_dilithium3_rv32im		out/test_dilithium5_rv32im 	\
	out/test_vectors2_rv32im 		\
	out/test_vectors3_rv32im		out/test_vectors5_rv32im	\
	out/test_dilithium2_rv32imb 	\
	out/test_dilithium3_rv32imb		out/test_dilithium5_rv32imb \
	out/test_vectors2_rv32imb 		\
	out/test_vectors3_rv32imb		out/test_vectors5_rv32imb	\
	out/test_dilithium2_rv32imv 	\
	out/test_dilithium3_rv32imv		out/test_dilithium5_rv32imv \
	out/test_vectors2_rv32imv 		\
	out/test_vectors3_rv32imv		out/test_vectors5_rv32imv	\
	out/test_dilithium2_rv32imbv 	\
	out/test_dilithium3_rv32imbv	out/test_dilithium5_rv32imbv \
	out/test_vectors2_rv32imbv 		\
	out/test_vectors3_rv32imbv		out/test_vectors5_rv32imbv	\
	out/scp_test

speed: \
	out/test_mul_rv32im 			out/test_speed2_rv32im 		\
	out/test_speed3_rv32im			out/test_speed5_rv32im 		\
	out/test_mul_rv32imb 			out/test_speed2_rv32imb 	\
	out/test_speed3_rv32imb			out/test_speed5_rv32imb 	\
	out/test_mul_rv32imv 			out/test_speed2_rv32imv 	\
	out/test_speed3_rv32imv			out/test_speed5_rv32imv 	\
	out/test_mul_rv32imbv 			out/test_speed2_rv32imbv 	\
	out/test_speed3_rv32imbv		out/test_speed5_rv32imbv 	\
	out/scp_test_speed

run_speed: out/scp_test_speed
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv32im; ./test_speed2_rv32im; ./test_speed3_rv32im; ./test_speed5_rv32im" > results_rv32im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv32imb; ./test_speed2_rv32imb; ./test_speed3_rv32imb; ./test_speed5_rv32imb" > results_rv32imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv32imv; ./test_speed2_rv32imv; ./test_speed3_rv32imv; ./test_speed5_rv32imv" > results_rv32imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv32imbv; ./test_speed2_rv32imbv; ./test_speed3_rv32imbv; ./test_speed5_rv32imbv" > results_rv32imbv.txt

run_diff_vectors: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors2_rv32im" > vectors_dilithium2_rv32im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors3_rv32im" > vectors_dilithium3_rv32im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors5_rv32im" > vectors_dilithium5_rv32im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors2_rv32imb" > vectors_dilithium2_rv32imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors3_rv32imb" > vectors_dilithium3_rv32imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors5_rv32imb" > vectors_dilithium5_rv32imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors2_rv32imv" > vectors_dilithium2_rv32imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors3_rv32imv" > vectors_dilithium3_rv32imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors5_rv32imv" > vectors_dilithium5_rv32imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors2_rv32imbv" > vectors_dilithium2_rv32imbv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors3_rv32imbv" > vectors_dilithium3_rv32imbv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors5_rv32imbv" > vectors_dilithium5_rv32imbv.txt
	diff vectors_dilithium2_rv32im.txt ../ref/vectors_dilithium2.txt
	diff vectors_dilithium3_rv32im.txt ../ref/vectors_dilithium3.txt
	diff vectors_dilithium5_rv32im.txt ../ref/vectors_dilithium5.txt
	diff vectors_dilithium2_rv32imb.txt ../ref/vectors_dilithium2.txt
	diff vectors_dilithium3_rv32imb.txt ../ref/vectors_dilithium3.txt
	diff vectors_dilithium5_rv32imb.txt ../ref/vectors_dilithium5.txt
	diff vectors_dilithium2_rv32imv.txt ../ref/vectors_dilithium2.txt
	diff vectors_dilithium3_rv32imv.txt ../ref/vectors_dilithium3.txt
	diff vectors_dilithium5_rv32imv.txt ../ref/vectors_dilithium5.txt
	diff vectors_dilithium2_rv32imbv.txt ../ref/vectors_dilithium2.txt
	diff vectors_dilithium3_rv32imbv.txt ../ref/vectors_dilithium3.txt
	diff vectors_dilithium5_rv32imbv.txt ../ref/vectors_dilithium5.txt

out/scp_test:	\
	out/test_dilithium2_rv32im 		\
	out/test_dilithium3_rv32im		out/test_dilithium5_rv32im 	\
	out/test_vectors2_rv32im 		\
	out/test_vectors3_rv32im		out/test_vectors5_rv32im	\
	out/test_dilithium2_rv32imb 	\
	out/test_dilithium3_rv32imb		out/test_dilithium5_rv32imb \
	out/test_vectors2_rv32imb 		\
	out/test_vectors3_rv32imb		out/test_vectors5_rv32imb	\
	out/test_dilithium2_rv32imv 	\
	out/test_dilithium3_rv32imv		out/test_dilithium5_rv32imv \
	out/test_vectors2_rv32imv 		\
	out/test_vectors3_rv32imv		out/test_vectors5_rv32imv	\
	out/test_dilithium2_rv32imbv 	\
	out/test_dilithium3_rv32imbv	out/test_dilithium5_rv32imbv \
	out/test_vectors2_rv32imbv 		\
	out/test_vectors3_rv32imbv		out/test_vectors5_rv32imbv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

out/scp_test_speed:	\
	out/test_mul_rv32im 			out/test_speed2_rv32im 		\
	out/test_speed3_rv32im			out/test_speed5_rv32im 		\
	out/test_mul_rv32imb 			out/test_speed2_rv32imb 	\
	out/test_speed3_rv32imb			out/test_speed5_rv32imb 	\
	out/test_mul_rv32imv 			out/test_speed2_rv32imv 	\
	out/test_speed3_rv32imv			out/test_speed5_rv32imv 	\
	out/test_mul_rv32imbv 			out/test_speed2_rv32imbv 	\
	out/test_speed3_rv32imbv		out/test_speed5_rv32imbv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

# For RV32IM

out/test_dilithium2_rv32im: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IM) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv32im: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IM) $(HEADERS)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv32im: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IM) $(HEADERS)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv32im: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv32im: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv32im: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IM) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv32im: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IM) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv32im: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IM) $(HEADERS)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv32im: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IM) $(HEADERS)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv32im: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(SOURCES_RV32IM) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IM) -UDBENCH -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

# For RV32IMB

out/test_dilithium2_rv32imb: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv32imb: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv32imb: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv32imb: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IMB) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv32imb: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IMB) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv32imb: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IMB) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv32imb: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv32imb: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv32imb: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv32imb: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(SOURCES_RV32IMB) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMB) -UDBENCH -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

# For RV32IMV

out/test_dilithium2_rv32imv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv32imv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv32imv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv32imv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IMV) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv32imv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IMV) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv32imv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IMV) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv32imv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv32imv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv32imv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv32imv: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(SOURCES_RV32IMV) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMV) -UDBENCH -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

# For RV32IMBV

out/test_dilithium2_rv32imbv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv32imbv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv32imbv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv32imbv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IMBV) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv32imbv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IMBV) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv32imbv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(SOURCES_RV32IMBV) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv32imbv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv32imbv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv32imbv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv32imbv: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(SOURCES_RV32IMBV) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMBV) -UDBENCH -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

clean:
	-$(RM) -rf out/
