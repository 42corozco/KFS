OUTPUT_FORMAT(elf32-i386)
ENTRY(start)
SECTIONS
{
	// This memory address is commonly used as the starting address for 
	// the kernel in PC-based operating systems as it is above the memory used by the BIOS and the multiboot loader.
	. = 0x100000;

	.text :
	{
		*(.multiboot_header)
		*(.text)
	}

	.data : { *(.data) } // ".o" contain initialized data
	.bss  : { *(.bss)  } // ".o" contain unnitialized data
}

