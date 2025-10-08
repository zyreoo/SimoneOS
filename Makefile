C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

CC = i686-elf-gcc
LD = i686-elf-ld
ASM = nasm

CFLAGS = -g -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
         -nostartfiles -nodefaultlibs -Wall -Wextra -Werror

all: os-image

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -c $< -o $@

kernel_entry.o: kernel/kernel_entry.asm
	${ASM} -f elf kernel/kernel_entry.asm -o kernel_entry.o

kernel.bin: kernel_entry.o ${OBJ}
	${LD} -o kernel.bin -Ttext 0x1000 $^ --oformat binary

boot.bin: boot/boot.asm
	${ASM} -f bin boot/boot.asm -o boot.bin

os-image: boot.bin kernel.bin
	cat boot.bin kernel.bin > os-image

run: os-image
	qemu-system-i386 -fda os-image

clean:
	rm -rf *.bin *.o os-image kernel/*.o drivers/*.o