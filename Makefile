#color
COM_COLOR   = \033[0;34m
OBJ_COLOR   = \033[0;36m
OK_COLOR    = \033[0;32m
ERROR_COLOR = \033[0;31m
WARN_COLOR  = \033[0;33m
NO_COLOR    = \033[m

OK_STRING    = "[OK]"
ERROR_STRING = "[ERROR]"
WARN_STRING  = "[WARNING]"
COM_STRING   = "Compiling"

define run_and_test
printf "%b" "$(COM_COLOR)$(COM_STRING) $(OBJ_COLOR)$(@F)$(NO_COLOR)\r"; \
$(1) 2> $@.log; \
RESULT=$$?; \
if [ $$RESULT -ne 0 ]; then \
  printf "%-60b%b" "$(COM_COLOR)$(COM_STRING)$(OBJ_COLOR) $@" "$(ERROR_COLOR)$(ERROR_STRING)$(NO_COLOR)\n"   ; \
elif [ -s $@.log ]; then \
  printf "%-60b%b" "$(COM_COLOR)$(COM_STRING)$(OBJ_COLOR) $@" "$(WARN_COLOR)$(WARN_STRING)$(NO_COLOR)\n"   ; \
else  \
  printf "%-60b%b" "$(COM_COLOR)$(COM_STRING)$(OBJ_COLOR) $(@F)" "$(OK_COLOR)$(OK_STRING)$(NO_COLOR)\n"   ; \
fi; \
cat $@.log; \
rm -f $@.log; \
exit $$RESULT
endef

# ---------------------------------------------------------

CP := cp
RM := rm -rf
MKDIR := @mkdir -p

ISO = KFS.iso
BIN = kernel
CFG = grub.cfg
# ---------------------------------------------------------

#PATH
ISO_PATH := iso
BOOT_PATH := $(ISO_PATH)/boot
GRUB_PATH := $(BOOT_PATH)/grub
# ---------------------------------------------------------

#GCC
CC := gcc
CCFLAGS = -fno-stack-protector -fno-builtin -fno-exceptions -nostdlib -nodefaultlibs -m32 -c

#LD
LDFLAGS = -m elf_i386 -T

#NAMS
NAMSFLAGS = -f elf32
# ---------------------------------------------------------

all: fclean bootloader kernel linker iso
	@printf "%b" "$(ERROR_COLOR)\tMake has completed\t$(OK_COLOR)[SUCCESS]$(NO_COLOR)\n";

bootloader: boot.asm
	@$(call run_and_test,nasm $(NAMSFLAGS) boot.asm -o boot.o)

kernel: kernel.c
	@$(call run_and_test,$(CC) $(CCFLAGS) kernel.c -o kernel.o)

linker: linker.ld boot.o kernel.o
	@$(call run_and_test,ld $(LDFLAGS) linker.ld -o kernel boot.o kernel.o)

iso: kernel
	@$(MKDIR) $(GRUB_PATH)
	@$(CP) $(BIN) $(BOOT_PATH)
	@$(CP) $(CFG) $(GRUB_PATH)
	@grub-file --is-x86-multiboot $(BOOT_PATH)/$(BIN)
	@grub-mkrescue --compress=xz -o $(ISO) $(ISO_PATH)

clean:
	@$(RM) *.o $(BIN) $(ISO_PATH)
	@printf "%b" "$(ERROR_COLOR)\tmake clean\t$(OK_COLOR)[SUCCESS]$(NO_COLOR)\n";

fclean: clean
	@$(RM) $(ISO)

re: fclean all

run:
	qemu-system-i386 -s -cdrom $(ISO)

.PHONY: all bootloader kernel linker iso clean fclean re run
