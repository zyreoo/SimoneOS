C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

CC = i686-elf-gcc
LD = i686-elf-ld
ASM = nasm

CFLAGS = -g -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs \
		 -Wall -Wextra -Werror

all: os-image

boot.bin: boot/boot.asm
	$(ASM) -f bin boot/boot.asm -o boot.bin

os-image: boot.bin
	cat boot.bin > os-image

run: os-image
	qemu-system-i386 -fda os-image

clean:
	rm -rf *.bin *.o os-image
	rm -rf kernel/*.o drivers/*.o