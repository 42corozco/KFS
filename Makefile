src = kernel.S \
	  boot.S \

build_dir = build
iso_path := iso
boot_path := ${iso_path}/boot
grub_path := ${boot_path}/grub

iso = kfs.iso
bin = ${build_dir}/kernel
cfg = grub.cfg

LD := ld
ldfile := linker.ld
LDFLAGS := -m elf_i386 -T ${ldfile}

AS := nasm
ASFLAGS := -f elf32

MKRESCUE := grub-mkrescue

objs := $(addprefix ${build_dir}/, ${src:.S=.o})


.PHONY: all
all: build link iso

.PHONY: build
build: ${objs}
	@printf "\033[0;36m0bject file created\033[m\n"

${build_dir}/%.o: %.S
	@mkdir -p ${build_dir}
	${AS} ${ASFLAGS} $< -o $@

.PHONY: link
link: build ${ldfile}
	${LD} ${LDFLAGS} ${objs} -o ${bin}
	@printf "\033[0;34mLinking completed\033[m\n"


.PHONY: iso
iso: link ${bin}
	@mkdir -p ${grub_path}
	@cp ${bin} ${boot_path}
	@cp ${cfg} ${grub_path}
	@${MKRESCUE} -o ${iso} ${iso_path}
	@printf "\033[0;32mIso file created\033[m\n"


.PHONY: clean
clean:
	@/bin/rm -rf ${build_dir}

.PHONY: fclean
fclean: clean
	@/bin/rm -rf ${iso} ${iso_path}

.PHONY: re
re: fclean all

.PHONY: run
run: iso ${iso}
	qemu-system-i386 -s -cdrom ${iso}
