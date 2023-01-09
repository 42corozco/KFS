section .text
global main:

main:

	mov eax, 0xb8000
	mov DWORD [eax], 0x0e320e34
	mov DWORD [eax+160], 0x0d340d32
