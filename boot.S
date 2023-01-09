bits 32

MULTIBOOT_HEADER_MAGIC		equ 0x1BADB002
MULTIBOOT_HEADER_FLAGS		equ 0x0
MULTIBOOT_HEADER_CHECKSUM	equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

section .multiboot_header
	dd MULTIBOOT_HEADER_MAGIC
	dd MULTIBOOT_HEADER_FLAGS
	dd MULTIBOOT_HEADER_CHECKSUM

section .text
global start
extern main

start:
	mov esp, stack_space	;set stack pointer
	call main
	hlt			;halt the CPU

section .bss
resb 8192			;8KB for stack
stack_space:
