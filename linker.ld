OUTPUT_FORMAT(elf32-i386)
ENTRY(start)
SECTIONS
{
	. = 0x100000;

	.text :
	{
		*(.multiboot_header)
		*(.text)
	}

	.data : { *(.data) }
	.bss  : { *(.bss)  }
}

