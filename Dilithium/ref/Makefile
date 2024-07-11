PLATFORM ?= C908

CC 		= riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump
SCP 	= scp
# SCP		= @:

COMMONDIR 		= ../../common
KECCAKDIR		= ../../sha3
CFLAGS_COMMON 	= -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  				  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
				  -I$(COMMONDIR) -I$(KECCAKDIR) -I. -DDILITHIUM_COUNT_REJ_NUM \
				  -DREF_IMPL

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

SOURCES 		= $(SOURCES_COMMON) $(SOURCES_RAND) sign.c packing.c polyvec.c poly.c ntt.c reduce.c rounding.c symmetric-shake.c
HEADERS 		= $(HEADERS_COMMON) $(HEADERS_RAND) config.h params.h api.h sign.h packing.h polyvec.h poly.h ntt.h reduce.h rounding.h symmetric.h
SOURCES_VECTOR 	= $(SOURCES_COMMON) sign.c packing.c polyvec.c poly.c ntt.c reduce.c rounding.c symmetric-shake.c
HEADERS_VECTOR 	= $(HEADERS_COMMON) config.h params.h api.h sign.h packing.h polyvec.h poly.h ntt.h reduce.h rounding.h symmetric.h

.PHONY: all speed run_speed run_gen_vectors clean

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
	out/test_dilithium2_rv64im 		\
	out/test_dilithium3_rv64im		out/test_dilithium5_rv64im 	\
	out/test_vectors2_rv64im 		\
	out/test_vectors3_rv64im		out/test_vectors5_rv64im	\
	out/test_dilithium2_rv64imb 	\
	out/test_dilithium3_rv64imb		out/test_dilithium5_rv64imb \
	out/test_vectors2_rv64imb 		\
	out/test_vectors3_rv64imb		out/test_vectors5_rv64imb	\
	out/test_dilithium2_rv64imv 	\
	out/test_dilithium3_rv64imv		out/test_dilithium5_rv64imv \
	out/test_vectors2_rv64imv 		\
	out/test_vectors3_rv64imv		out/test_vectors5_rv64imv	\
	out/test_dilithium2_rv64imbv 	\
	out/test_dilithium3_rv64imbv	out/test_dilithium5_rv64imbv \
	out/test_vectors2_rv64imbv 		\
	out/test_vectors3_rv64imbv		out/test_vectors5_rv64imbv	\
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
	out/test_mul_rv64im 			out/test_speed2_rv64im 		\
	out/test_speed3_rv64im			out/test_speed5_rv64im 		\
	out/test_mul_rv64imb 			out/test_speed2_rv64imb 	\
	out/test_speed3_rv64imb			out/test_speed5_rv64imb 	\
	out/test_mul_rv64imv 			out/test_speed2_rv64imv 	\
	out/test_speed3_rv64imv			out/test_speed5_rv64imv 	\
	out/test_mul_rv64imbv 			out/test_speed2_rv64imbv 	\
	out/test_speed3_rv64imbv		out/test_speed5_rv64imbv 	\
	out/scp_test_speed

run_speed: out/scp_test_speed
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv32im; ./test_speed2_rv32im; ./test_speed3_rv32im; ./test_speed5_rv32im" > results_rv32im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv32imb; ./test_speed2_rv32imb; ./test_speed3_rv32imb; ./test_speed5_rv32imb" > results_rv32imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv32imv; ./test_speed2_rv32imv; ./test_speed3_rv32imv; ./test_speed5_rv32imv" > results_rv32imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv32imbv; ./test_speed2_rv32imbv; ./test_speed3_rv32imbv; ./test_speed5_rv32imbv" > results_rv32imbv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv64im; ./test_speed2_rv64im; ./test_speed3_rv64im; ./test_speed5_rv64im" > results_rv64im.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv64imb; ./test_speed2_rv64imb; ./test_speed3_rv64imb; ./test_speed5_rv64imb" > results_rv64imb.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv64imv; ./test_speed2_rv64imv; ./test_speed3_rv64imv; ./test_speed5_rv64imv" > results_rv64imv.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_mul_rv64imbv; ./test_speed2_rv64imbv; ./test_speed3_rv64imbv; ./test_speed5_rv64imbv" > results_rv64imbv.txt

run_gen_vectors: out/scp_test
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors2_rv32im" > vectors_dilithium2.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors3_rv32im" > vectors_dilithium3.txt
	ssh $(TARGET_USER)@$(TARGET_IP) "cd $(TARGET_DIR) && ./test_vectors5_rv32im" > vectors_dilithium5.txt

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
	out/test_vectors3_rv32imbv		out/test_vectors5_rv32imbv	\
	out/test_dilithium2_rv64im 		\
	out/test_dilithium3_rv64im		out/test_dilithium5_rv64im 	\
	out/test_vectors2_rv64im 		\
	out/test_vectors3_rv64im		out/test_vectors5_rv64im	\
	out/test_dilithium2_rv64imb 	\
	out/test_dilithium3_rv64imb		out/test_dilithium5_rv64imb \
	out/test_vectors2_rv64imb 		\
	out/test_vectors3_rv64imb		out/test_vectors5_rv64imb	\
	out/test_dilithium2_rv64imv 	\
	out/test_dilithium3_rv64imv		out/test_dilithium5_rv64imv \
	out/test_vectors2_rv64imv 		\
	out/test_vectors3_rv64imv		out/test_vectors5_rv64imv	\
	out/test_dilithium2_rv64imbv 	\
	out/test_dilithium3_rv64imbv	out/test_dilithium5_rv64imbv \
	out/test_vectors2_rv64imbv 		\
	out/test_vectors3_rv64imbv		out/test_vectors5_rv64imbv
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
	out/test_speed3_rv32imbv		out/test_speed5_rv32imbv 	\
	out/test_mul_rv64im 			out/test_speed2_rv64im 		\
	out/test_speed3_rv64im			out/test_speed5_rv64im 		\
	out/test_mul_rv64imb 			out/test_speed2_rv64imb 	\
	out/test_speed3_rv64imb			out/test_speed5_rv64imb 	\
	out/test_mul_rv64imv 			out/test_speed2_rv64imv 	\
	out/test_speed3_rv64imv			out/test_speed5_rv64imv 	\
	out/test_mul_rv64imbv 			out/test_speed2_rv64imbv 	\
	out/test_speed3_rv64imbv		out/test_speed5_rv64imbv
	$(SCP) $^ $(TARGET_USER)@$(TARGET_IP):$(TARGET_DIR)/
	@echo 1 > $@

# For RV32IM

out/test_dilithium2_rv32im: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv32im: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv32im: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv32im: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv32im: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv32im: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv32im: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv32im: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv32im: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IM) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv32im: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IM) -UDBENCH \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

# For RV32IMB

out/test_dilithium2_rv32imb: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv32imb: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv32imb: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv32imb: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv32imb: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv32imb: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv32imb: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv32imb: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv32imb: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMB) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv32imb: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMB) -UDBENCH \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

# For RV32IMV

out/test_dilithium2_rv32imv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv32imv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv32imv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv32imv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv32imv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv32imv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv32imv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv32imv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv32imv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv32imv: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMV) -UDBENCH \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

# For RV32IMBV

out/test_dilithium2_rv32imbv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv32imbv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv32imbv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv32imbv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv32imbv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv32imbv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv32imbv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv32imbv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv32imbv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV32IMBV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv32imbv: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV32IMBV) -UDBENCH \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

# For RV64IM

out/test_dilithium2_rv64im: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IM) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv64im: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IM) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv64im: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IM) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv64im: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IM) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv64im: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV64IM) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv64im: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV64IM) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv64im: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IM) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv64im: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IM) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv64im: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IM) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv64im: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IM) -UDBENCH \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

# For RV64IMB

out/test_dilithium2_rv64imb: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMB) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv64imb: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMB) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv64imb: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMB) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv64imb: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMB) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv64imb: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV64IMB) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv64imb: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV64IMB) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv64imb: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMB) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv64imb: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMB) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv64imb: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMB) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv64imb: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMB) -UDBENCH \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

# For RV64IMV

out/test_dilithium2_rv64imv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv64imv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv64imv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv64imv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv64imv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV64IMV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv64imv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV64IMV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv64imv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv64imv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv64imv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv64imv: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMV) -UDBENCH \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

# For RV64IMBV

out/test_dilithium2_rv64imbv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMBV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium3_rv64imbv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMBV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_dilithium5_rv64imbv: $(COMMONDIR)/test_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMBV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors2_rv64imbv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMBV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors3_rv64imbv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV64IMBV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_vectors5_rv64imbv: $(COMMONDIR)/test_vectors_dilithium.c $(SOURCES_VECTOR) $(HEADERS_VECTOR)
	$(CC) $(CFLAGS_RV64IMBV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed2_rv64imbv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMBV) -DDILITHIUM_MODE=2 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed3_rv64imbv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMBV) -DDILITHIUM_MODE=3 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_speed5_rv64imbv: $(COMMONDIR)/test_speed_dilithium.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS_RV64IMBV) -DDILITHIUM_MODE=5 \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

out/test_mul_rv64imbv: $(COMMONDIR)/test_mul_dilithium.c $(SOURCES) $(HEADERS)
	mkdir -p out/
	$(CC) $(CFLAGS_RV64IMBV) -UDBENCH \
	  -o $@ $(filter %.c, $^) $(filter %.S, $^)

clean:
	-$(RM) -rf out/
