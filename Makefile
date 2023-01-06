src = kernel.c \
	  boot.S \

iso = kfs.iso
bin = kernel
cfg = grub.cfg

build_dir ?= build
iso_path := iso
boot_path := ${iso_path}/boot
grub_path := ${boot_path}/grub

CC := gcc
CFLAGS := -fno-stack-protector \
 -fno-builtin \
 -fno-exceptions \
 -nostdlib \
 -nodefaultlibs \
 -m32 \

LD := ld
ldfile := linker.ld
LDFLAGS := -m elf_i386 -T ${ldfile}

AS := nasm
ASFLAGS := -f elf32

MKRESCUE := grub-mkrescue

objs := $(addprefix ${build_dir}/, ${src})
objs := ${objs:.c=.o}
objs := ${objs:.S=.o}

.PHONY: all
all: build link iso

.PHONY: build
build: ${objs}

${build_dir}/%.o: %.S
	@mkdir -pv ${build_dir}
	${AS} ${ASFLAGS} $< -o $@

${build_dir}/%.o: %.c
	@mkdir -pv ${build_dir}
	${CC} ${CFLAGS} -c $< -o $@

.PHONY: link
link: ${ldfile} ${objs}
	${LD} ${LDFLAGS} ${objs} -o ${bin}

.PHONY: iso
iso: ${bin}
	@mkdir -pv ${grub_path}
	cp ${bin} ${boot_path}
	cp ${cfg} ${grub_path}
	${MKRESCUE} -o ${iso} ${iso_path}

.PHONY: clean
clean:
	@/bin/rm -rf ${build_dir} ${iso}

.PHONY: fclean
fclean: clean
	@/bin/rm -rf ${iso} ${iso_path}

.PHONY: re
re: fclean all

.PHONY: run
run: all
	qemu-system-i386 -s -cdrom ${iso}
