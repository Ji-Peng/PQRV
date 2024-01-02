CC = riscv64-unknown-linux-gnu-gcc
OBJDUMP = riscv64-unknown-linux-gnu-objdump

COMMONDIR = ../common
CFLAGS = -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
		 -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer -static \
		 -march=rv64imafdcv -mabi=lp64d -I$(COMMONDIR) -I.
RM = /bin/rm

SOURCES = add.c
HEADERS = 

TARGET_IP = 192.168.123.99

.PHONY: speed results clean

speed: \
	test_add

objdump:
	$(OBJDUMP) -D out/test_add > out/test_add.S

test_add: $(SOURCES) $(HEADERS)
	mkdir -p out
	$(CC) $(CFLAGS) $(SOURCES) -o out/test_add
	scp out/test_add root@$(TARGET_IP):/sharefs/

clean:
	-$(RM) -rf out/
